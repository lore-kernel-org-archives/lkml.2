Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab0JGOrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:47:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0JGOrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:47:17 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] single block fix for 2.6.36
References: <4CAD7A00.6060003@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Oct 2010 10:45:38 -0400
In-Reply-To: <4CAD7A00.6060003@fusionio.com> (Jens Axboe's message of "Thu, 07
	Oct 2010 09:42:56 +0200")
Message-ID: <x49lj6a9i3x.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

> Hi Linus,
>
> The API that was added for drivers to switch IO schedulers
> when loaded does not work if the driver isn't in a fully
> initialized state. The in-kernel ones call it right after
> blk_init_queue(), which will result in an oops when the
> elevator core tries to unregister unregistered kobjects.

Color me confused.  If the problem is trying to unregister unregistered
objects, then why does your backtrace show a problem registering
objects?

    RIP: 0010:[<ffffffff8116f15e>]  [<ffffffff8116f15e>] sysfs_create_dir+0x2e/0xc0
...
    Call Trace:
     [<ffffffff8123fb77>] kobject_add_internal+0xe7/0x1f0
     [<ffffffff8123fd98>] kobject_add_varg+0x38/0x60
     [<ffffffff8123feb9>] kobject_add+0x69/0x90
     [<ffffffff8116efe0>] ? sysfs_remove_dir+0x20/0xa0
     [<ffffffff8103d48d>] ? sub_preempt_count+0x9d/0xe0
     [<ffffffff8143de20>] ? _raw_spin_unlock+0x30/0x50
     [<ffffffff8116efe0>] ? sysfs_remove_dir+0x20/0xa0
     [<ffffffff8116eff4>] ? sysfs_remove_dir+0x34/0xa0
     [<ffffffff81224204>] elv_register_queue+0x34/0xa0
     [<ffffffff81224aad>] elevator_change+0xfd/0x250
     [<ffffffffa007e000>] ? t_init+0x0/0x361 [t]
     [<ffffffffa007e000>] ? t_init+0x0/0x361 [t]
     [<ffffffffa007e0a8>] t_init+0xa8/0x361 [t]
     [<ffffffff810001de>] do_one_initcall+0x3e/0x170
     [<ffffffff8108c3fd>] sys_init_module+0xbd/0x220
     [<ffffffff81002f2b>] system_call_fastpath+0x16/0x1b

I tried to track down what was going on, but I don't have your .config,
so trying to pick things apart by guessing wasn't working out very well
for me.  Also, your changelog entry in your tree is different from what
you posted here (more complete) and you never posted a relevant patch to
the list.

> Add a registered bit and only do the unregister/register
> dance in elevator_switch() if we need to. The other call
> path for this is the sysfs parts to allow online switching,
> which can only be called with a fully setup driver.

I don't doubt that you're right, but you certainly haven't given enough
information for me to verify this in the 20 or 30 minutes I spent
looking.

Cheers,
Jeff
