Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0JGQge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:36:34 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48975 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab0JGQgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:36:33 -0400
Message-ID: <4CADF727.9070404@fusionio.com>
Date: Thu, 07 Oct 2010 18:36:55 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] single block fix for 2.6.36
References: <4CAD7A00.6060003@fusionio.com> <x49lj6a9i3x.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49lj6a9i3x.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-07 16:45, Jeff Moyer wrote:
> Jens Axboe <jaxboe@fusionio.com> writes:
> 
>> Hi Linus,
>>
>> The API that was added for drivers to switch IO schedulers
>> when loaded does not work if the driver isn't in a fully
>> initialized state. The in-kernel ones call it right after
>> blk_init_queue(), which will result in an oops when the
>> elevator core tries to unregister unregistered kobjects.
> 
> Color me confused.  If the problem is trying to unregister unregistered
> objects, then why does your backtrace show a problem registering
> objects?

Probably mostly circumstantial, it ends up triggering deletions on
not-added kobjects. Why it triggers specifically in the addition I
haven't checked, I think it's running into a NULL parent (I noticed this
last week and got an oops, and iirc that's where it crashed in
sysfs_create_dir()).

So where it bombs does seem a bit confusing, but the reason for why is
as I outlined in the mail and in the changelog.

>     RIP: 0010:[<ffffffff8116f15e>]  [<ffffffff8116f15e>] sysfs_create_dir+0x2e/0xc0
> ...
>     Call Trace:
>      [<ffffffff8123fb77>] kobject_add_internal+0xe7/0x1f0
>      [<ffffffff8123fd98>] kobject_add_varg+0x38/0x60
>      [<ffffffff8123feb9>] kobject_add+0x69/0x90
>      [<ffffffff8116efe0>] ? sysfs_remove_dir+0x20/0xa0
>      [<ffffffff8103d48d>] ? sub_preempt_count+0x9d/0xe0
>      [<ffffffff8143de20>] ? _raw_spin_unlock+0x30/0x50
>      [<ffffffff8116efe0>] ? sysfs_remove_dir+0x20/0xa0
>      [<ffffffff8116eff4>] ? sysfs_remove_dir+0x34/0xa0
>      [<ffffffff81224204>] elv_register_queue+0x34/0xa0
>      [<ffffffff81224aad>] elevator_change+0xfd/0x250
>      [<ffffffffa007e000>] ? t_init+0x0/0x361 [t]
>      [<ffffffffa007e000>] ? t_init+0x0/0x361 [t]
>      [<ffffffffa007e0a8>] t_init+0xa8/0x361 [t]
>      [<ffffffff810001de>] do_one_initcall+0x3e/0x170
>      [<ffffffff8108c3fd>] sys_init_module+0xbd/0x220
>      [<ffffffff81002f2b>] system_call_fastpath+0x16/0x1b
> 
> I tried to track down what was going on, but I don't have your .config,
> so trying to pick things apart by guessing wasn't working out very well
> for me.  Also, your changelog entry in your tree is different from what
> you posted here (more complete) and you never posted a relevant patch to
> the list.

Just add an elevator_change(q, "noop"); or similar to any driver and
you'll see the issue. My .config doesn't matter, unless you are using
the S390 tape block driver or mGine flash block driver (mg_block). They
are the only users of that API.

I figured the folks that were truly interested would check the
changelog, the git pull requests are rarely as informative as the
individual changes. I actually thought I did pretty well on this one :-)

>> Add a registered bit and only do the unregister/register
>> dance in elevator_switch() if we need to. The other call
>> path for this is the sysfs parts to allow online switching,
>> which can only be called with a fully setup driver.
> 
> I don't doubt that you're right, but you certainly haven't given enough
> information for me to verify this in the 20 or 30 minutes I spent
> looking.

Did you try calling elevator_change? That should show the problem right
away, not in 20-30 minutes :-)

-- 
Jens Axboe

