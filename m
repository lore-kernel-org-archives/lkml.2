Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2AQW6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 17:58:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45021 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab2AQW6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 17:58:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120117.124449.1065919030248165158.davem@davemloft.net>
References: <CA+HUmGgLmsHsTUbKb=XB_Ow+BPajpu75B18Um0zRZRkof8rQmw@mail.gmail.com>
	<20120117.124449.1065919030248165158.davem@davemloft.net>
Date: Tue, 17 Jan 2012 14:58:32 -0800
Message-ID: <CA+HUmGgi2yv+CebywB1Yqs+u_o-GXp6HWVKbUafTGW1N_dp-jQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: race condition in ipv6 forwarding and
 disable_ipv6 parameters
From: Francesco Ruggeri <fruggeri@aristanetworks.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 9:44 AM, David Miller <davem@davemloft.net> wrote:
> From: Francesco Ruggeri <fruggeri@aristanetworks.com>
> Date: Mon, 16 Jan 2012 12:40:10 -0800
>
>> -static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int old)
>> +static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int newf)
>  ...
>> @@ -4257,9 +4259,17 @@ int addrconf_sysctl_forward(ctl_table *c
>>       int *valp = ctl->data;
>>       int val = *valp;
>>       loff_t pos = *ppos;
>> +     ctl_table lctl;
>>       int ret;
>>
>> -     ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
>> +     /*
>> +      * ctl->data points to idev->cnf.forwarding, we should
>> +      * not modify it until we get the rtnl lock.
>> +      */
>> +     lctl = *ctl;
>> +     lctl.data = &val;
>> +
>> +     ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
>>
>>       if (write)
>>               ret = addrconf_fixup_forwarding(ctl, valp, val);
>
> I don't understand this at all.
>
> "val" is still the old value, before proc_dointvec() runs, after your
> changes.  So renaming the argument to addrconf_fixup_forwarding() as
> "newf" and treating it as the new value doesn't make any sense at all.
>
> Did you really test this patch?

Hi David,
thanks for reviewing the patch.
Yes, I did test it. We have been running this patch on 60 servers for
a week without problems, whereas we would see problems within the
first 24 hours without the patch.

val does contain the old value before proc_dointvec is invoked (that
is needed for reads), but it contains the new value after
proc_dointvec is invoked if "write" is non
zero.

proc_dointvec is defined as:
proc_dointvec(struct ctl_table *table, ...
In case of a write, proc_dointvec modifies the location pointed to by
table->data. In case of a read it just reads it.

The change here is that instead of using the original ctl structure I
make a copy of it (lctl) and then change lctl.data to point to "val"
on the stack.
In this way proc_dointvec does not use the original structure, and in
case of a write it only modifies "val" on the stack. In case of a read
it still reads the original value (which as you point out was saved in
"val = *valp").

In both the new and the old code, valp points to the location that has
to be changed (in the inet6_dev structure).
With the old code, the old value would be saved in "val",
proc_dointvec would change *valp, and val would be passed to
addrconf_fixup_forwarding as the old value (so that it could be
restored).
With the new code, proc_dointvec modifies "val", which is used by
addrconf_fixup_forwarding to modify *valp only after it has acquired
the lock.

Let me know if this clarifies things.
Thanks,
Francesco
