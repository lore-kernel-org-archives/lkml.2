Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2AYIA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 03:00:29 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:55110
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795Ab2AYIA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 03:00:28 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0P7xxGp009602
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Suresh Jayaraman <sjayaraman@suse.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Slab corruption in floppy driver module
In-Reply-To: <20120124223153.GG17291@redhat.com> (Vivek Goyal's message of
	"Tue, 24 Jan 2012 17:31:53 -0500")
References: <4F1EAFE9.5000306@suse.com> <20120124223153.GG17291@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Wed, 25 Jan 2012 08:59:57 +0100
Message-ID: <giobtsxldu.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Wed, 25 Jan 2012 09:00:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Jan 24, 2012 at 06:49:37PM +0530, Suresh Jayaraman wrote:
>
> [..]
>
>> [   33.372026]  ffff88041dd9be08 ffffffff8134f517 ffff88041dd9be28
>> ffff88041da9bc68
>> [   33.372026] Call Trace:
>> [   33.372026]  [<ffffffff81243a15>] blk_put_queue+0x15/0x20
>> [   33.372026]  [<ffffffff8124d4ff>] disk_release+0x8f/0xd0
>> [   33.372026]  [<ffffffff8134f517>] device_release+0x27/0xa0
>> [   33.372026]  [<ffffffff812754fd>] kobject_cleanup+0x6d/0x1b0
>> [   33.372026]  [<ffffffff8127564d>] kobject_release+0xd/0x10
>> [   33.372026]  [<ffffffff81276b17>] kref_put+0x37/0x70
>> [   33.372026]  [<ffffffff81275387>] kobject_put+0x27/0x60
>> [   33.372026]  [<ffffffff8124dbf7>] put_disk+0x17/0x20
>> [   33.372026]  [<ffffffffa00fa92c>] floppy_init+0x1c1/0x675 [floppy]
>> [   33.372026]  [<ffffffffa00fae37>] floppy_module_init+0x57/0x220 [floppy]
>> [   33.372026]  [<ffffffff810001d3>] do_one_initcall+0x43/0x180
>> [   33.372026]  [<ffffffff810a526d>] sys_init_module+0xcd/0x240
>> [   33.372026]  [<ffffffff8148d4c2>] system_call_fastpath+0x16/0x1b
>> [   33.372026]  [<00007f86dce3406a>] 0x7f86dce34069
>> [   33.372026] Code: eb cc 48 89 fe 31 c0 48 c7 c7 60 aa 7a 81 e8 26 c4 20 00
>> e8 92 c1 20 00 eb 8e 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 16 <f6> 47
>> 3c 01 74 19 48 8d 7b 38 48 c7 c6 40 56 27 81 e8 59 17 00
>> [   33.372026] RIP  [<ffffffff81275371>] kobject_put+0x11/0x60
>> [   33.372026]  RSP <ffff88041dd9bda8>
>> [   33.372026] CR2: ffff88041d986c9c
>> [   33.372026] ---[ end trace f624c17dc6e4672a ]---
>> --- cut-here ---
>> 
>> What seems to be happening is after commit f992ae80, add_disk takes a
>> extra reference to the queue which is supposed to be put in disk_release().
>> In floppy_init() when there were "no floppy controllers found" the control
>> goes to out_flush_work. Note that add_disk() is not being called at all and
>> so extra reference not taken. We try to put_disk() and the call sequence is
>>   put_disk()
>>    kobject_put()
>>     kref_put()
>>      kobject_release()
>>       kobject_cleanup()
>>        device_release()
>>         disk_release()
>>          blk_put_queue()  <-- put without a get
>>           kobject_put()
>> 
>> 
>> Reverting f992ae80 makes the oops and the slab corruption messages disappear.
>> The "no floppy controllers found" message was found in the dmesg.
>
> I am wondering if extra queue reference for gendisk should be taken by driver
> and not by add_disk(). Why? Because disk->queue association is setup by
> driver and not by add_disk(). That way even if we don't call, add_disk(),
> we should be fine.

I also noticed this problem about two weeks ago
(https://lkml.org/lkml/2012/1/10/177) -- the mentioned commit 523e1d399c
seems to be identical to f992ae80.

Perhaps, it is helpful to notice that I also played with this on a
machine that _has_ a floppy controler and if the floppy driver is loaded
as a module on boot, then unloaded and reloaded it also outputs error
messages, i.e. re-loading the module also causes problems.

Thanks,

Dirk
