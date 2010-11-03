Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0KCC5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 22:57:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab0KCC5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 22:57:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] One more power management fix for 2.6.37
Date: Wed, 3 Nov 2010 03:56:13 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw; KDE/4.4.4; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201010292358.27975.rjw@sisk.pl> <AANLkTikF+8VsxyjmXUc_6Epd923g5DCxneNArFNTGrZ_@mail.gmail.com>
In-Reply-To: <AANLkTikF+8VsxyjmXUc_6Epd923g5DCxneNArFNTGrZ_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011030356.13878.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 02, 2010, Linus Torvalds wrote:
> On Fri, Oct 29, 2010 at 5:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Please pull one more power management fix for 2.6.37 from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes
> >
> > It fixes a regression in the core I/O runtime PM code.
> 
> I think we have more. It may be the driver core, though. So I added
> GregKH to the recipients too...
> 
> On resume-from-ram with basically current -git (-rc1 + four patches):
> 
>   ...
>   ata1.01: configured for MWDMA2
>   ata1: EH complete
>   PM: resume of devices complete after 3240.438 msecs
>   ------------[ cut here ]------------
>   WARNING: at lib/kref.c:34 kref_get+0x23/0x2c()
>   Hardware name: HP Compaq 2510p Notebook PC
>   Modules linked in: iwlagn [last unloaded: scsi_wait_scan]
>   Pid: 7985, comm: pm-suspend Not tainted 2.6.37-rc1-00004-geb8abb9 #11
>   Call Trace:
>    [<ffffffff81036082>] warn_slowpath_common+0x80/0x98
>    [<ffffffff810360af>] warn_slowpath_null+0x15/0x17
>    [<ffffffff8120001f>] kref_get+0x23/0x2c
>    [<ffffffff811fee1b>] kobject_get+0x1a/0x21
>    [<ffffffff812d84bb>] get_device+0x14/0x1a
>    [<ffffffff812dfcd5>] dpm_resume_end+0x230/0x37c
>    [<ffffffff81060a09>] suspend_devices_and_enter+0x158/0x188
>    [<ffffffff81060b04>] enter_state+0xcb/0xcf
>    [<ffffffff810602cf>] state_store+0xa7/0xc6
>    [<ffffffff811fec2b>] kobj_attr_store+0x17/0x19
>    [<ffffffff810f75dc>] sysfs_write_file+0xf2/0x12e
>    [<ffffffff810ab99c>] vfs_write+0xb0/0x12f
>    [<ffffffff810abbf8>] sys_write+0x45/0x6c
>    [<ffffffff81001fab>] system_call_fastpath+0x16/0x1b
>   ---[ end trace af18256edd598c9c ]---
> 
> Any ideas? I incuded the "ata1:..." lines, but the timestamps are actually

Not at the moment.  I don't think this failure is related to the runtime PM code,
though.

>   ...
>   [11627.776490] ata1: EH complete
>   [11629.384719] PM: resume of devices complete after 3240.438 msecs
>   [11629.400284] ------------[ cut here ]------------
>   ...
> 
> so it's a second and a half after that ata1 resume EH complete
> message, and a bit after it says that it's completed all device
> resumes.
> 
> This oops is then followed by a lot of other oopses,most of which
> didn't get captured because the box hung afterwards. But the next oops
> was in kmem_cache_alloc(), so I think it's because the device
> refcounts were bad and had caused slab corruption when being freed too
> early or something. So I think the other oopses are all a result of
> this kref problem.
> 
> Hmm?

Can you boot with initcall_debug and try to suspend, please?  That should tell
us what device this actually happens to.

I don't even think it's necessary to suspend, it should be sufficient to do 

# echo devices > /sys/power/pm_test
# echo mem > /sys/power/state

Let's see if that reproduces the problem.

Thanks,
Rafael
