Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab2AEV6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:58:31 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:49477 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2AEV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:58:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, mingo@elte.hu, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] init: Warn on non-existent rdinit
References: <1325789819-30502-1-git-send-email-richard@nod.at>
	<m14nw9c1me.fsf@fess.ebiederm.org> <4F0619F9.8010505@nod.at>
Date: Thu, 05 Jan 2012 14:00:41 -0800
In-Reply-To: <4F0619F9.8010505@nod.at> (Richard Weinberger's message of "Thu,
	05 Jan 2012 22:45:29 +0100")
Message-ID: <m1vcopajxy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+K3an9K8mf4eUM3Ct5AzDxHxWOxEMkzCM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 05.01.2012 21:53, schrieb Eric W. Biederman:
>> Richard Weinberger <richard@nod.at> writes:
>> 
>>> Such a warning would have saved me some time...
>>> Hopefully this printk() saves someone else's time. :-)
>> 
>> The warning is wrong if you are not using an initramfs or an initial
>> ramdisk.
>
> Gnah, you're so right.
> I did not test it without a ramdisk.
>
>> I expect what you want is something like:
>> 
>> diff --git a/init/main.c b/init/main.c
>> index 217ed23..8d53d28 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -830,10 +830,11 @@ static int __init kernel_init(void * unused)
>>          * the work
>>          */
>>  
>> -       if (!ramdisk_execute_command)
>> +       if (!ramdisk_execute_command &&
>> +           (sys_access((const char __user *)"/init", 0) == 0))
>>                 ramdisk_execute_command = "/init";
>>  
>> -       if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
>> +       if (!ramdisk_execute_command) {
>>                 ramdisk_execute_command = NULL;
>>                 prepare_namespace();
>>         }
>
> Why ramdisk_execute_command = NULL; in the !ramdisk_execute_command
> case?

Because in my untested patch I didn't get as far as deleting that line.

>> That way we don't clear ramdisk_execute_command if it was set and
>> we complain if we attempt exec the ramdisk_execute_command.
>
> If "/init" does not exist we still don't get a warning.

Perhaps it has a /linuxrc.  If you can find a way of figuring out we
always need the file we can print an error.  Otherwise it is a case of
the kernel auto-detecting what to do, and not printing a warning when it
has decided there is no /init to play with.

Eric
