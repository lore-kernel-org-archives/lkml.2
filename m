Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0KAPF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:05:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54247 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab0KAPFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T00DWg3saDKqLLa2D6TUwGdnvySwt4LabBiKhb55ADANGsK8Po7AjGY+/m/sA1whAr
         akXMS7yhjkO0tDuKOd+cpWrINtW1lXZfcOwMvDPECYxDKcd0RxTDnERDaaNgEyopyeww
         61lHErrpcTyVV0koQDTRWbtfdUBlgnZOZ0Bf4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikWWGpAM8+_z9fnngYuYSpT3NWgM7xeGkOzZ3jg@mail.gmail.com>
References: <6631e123845856ac20423c25e07844c8@mail.gmail.com>
	<AANLkTikWWGpAM8+_z9fnngYuYSpT3NWgM7xeGkOzZ3jg@mail.gmail.com>
Date: Mon, 1 Nov 2010 11:05:53 -0400
Message-ID: <AANLkTikQuUcAMZKqZ3Rz5HVzOs+63-Y4VYUo5-3EM30H@mail.gmail.com>
Subject: Re: All Applied micro boards are failing with current mainline kernel
From: Josh Boyer <jwboyer@gmail.com>
To: Rupjyoti Sarmah <rsarmah@apm.com>, Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 9:22 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Fri, Oct 29, 2010 at 11:06 PM, Rupjyoti Sarmah <rsarmah@apm.com> wrote:
>> Hi ,
>>
>> APM boards Canyonlands/Kilauea/Glacier/Katmai/Sequoia are all failing
>> during booting.
>
> What kernel version?  What config?  Have you tried a git bisect to see
> when it broke?  Etc, etc.
>>
>> Call trace is same for all
>>
>>
>> Call Trace:
>>
>> [df835d70] [c02d27cc] emac_probe+0xf28/0x12a8 (unreliable)
>>
>> [df835e50] [c023c7cc] platform_driver_probe_shim+0x40/0x54
>>
>> [df835e60] [c01bf354] platform_drv_probe+0x20/0x30
>>
>> [df835e70] [c01bde68] driver_probe_device+0x148/0x1ac
>>
>> [df835e90] [c01be17c] __driver_attach+0xa4/0xa8
>>
>> [df835eb0] [c01bcfa4] bus_for_each_dev+0x60/0x9c
>>
>> [df835ee0] [c01bdbbc] driver_attach+0x24/0x34
>>
>> [df835ef0] [c01bd94c] bus_add_driver+0x1b8/0x274
>>
>> [df835f20] [c01be3d8] driver_register+0x6c/0x160
>>
>> [df835f40] [c01bf6c4] platform_driver_register+0x68/0x78
>>
>> [df835f50] [c023c998] of_register_platform_driver+0xa8/0xc4
>>
>> [df835f60] [c0393e88] emac_init+0x1ac/0x1dc
>>
>> [df835fa0] [c0001574] do_one_initcall+0x160/0x1a8
>>
>> [df835fd0] [c037a1e8] kernel_init+0xcc/0x174
>>
>> [df835ff0] [c000c5b0] kernel_thread+0x4c/0x68
>>
>> Instruction dump:
>>
>> 419e016c 2f800007 419e0164 38130774 901a00d0 381306b0 901a00d4 7f43d378
>>
>> 4bf91d89 817a01a0 39200001 380b0008 <7d400028> 7d4a4b78 7d40012d 40a2fff4
>>
>> ---[ end trace dac0cf4779f83901 ]---

A git bisect between 2.6.36 (working) and Linus tip (traceback) points to:

e6484930d7c73d324bccda7d43d131088da697b9 net: allocate tx queues in
register_netdevice

as causing this.  I'm not entirely sure why yet, but the commit
message seems slightly off to me.  It claims to make TX queue
allocation identical to RX, but from what I can tell, most of the RX
queue logic is hidden behind CONFIG_RPS, which is not set in my config
at all (and can't be due to a dep on CONFIG_SMP).  This change doesn't
guard anything behind that.

A few hints would be appreciated.

josh
