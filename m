Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1C3PKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:10:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44311 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754861Ab1C3PKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:10:17 -0400
Date: Wed, 30 Mar 2011 11:10:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: "Rafael J. Wysocki" <rjw@suse.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
In-Reply-To: <4D933A05.10603@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1103301059450.2085-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Jiri Slaby wrote:

> > Strange indeed.  It's worth noting that the async stuff affects only
> > the normal suspend and resume operations, not the late-suspend and
> > early-resume operations.  This means that it all likelihood, the system
> > crashes either before finishing the suspend or after doing a fair
> > amount of the resume.  And yet that's not consistent with what you see
> > on the screen.
> > 
> > By the way, are you booting with no_console_suspend?  And do you do 
> > "echo 8 >/proc/sys/kernel/printk" (or equivalently, Alt-SysRq-8) before 
> > suspending?
> 
> I'm testing this on my desktop. I found out yesterday, that I had async
> completely disabled. So I have no output yet.
> 
> I took my dvb-t tuner from desktop and connected it to my notebook. And
> got a similar hang during resume right now. It may not be related
> though. The trace is:
> s2disk          D 0000000000000000     0  6125   5902 0x00000004
>  ffff8800797aba78 0000000000000082 ffff8800797ab9f8 0000000000012ac0
>  ffff8800797abfd8 0000000000012ac0 ffff8800797abfd8 ffff8800797abfd8
>  ffff8800777fe7f0 0000000000012ac0 0000000000012ac0 ffff8800797aa000
> Call Trace:
>  [<ffffffff8151e2ed>] schedule_timeout+0x28d/0x310
>  [<ffffffff8151d410>] wait_for_common+0xc0/0x150
>  [<ffffffff8133ad22>] _request_firmware+0x132/0x270
>  [<ffffffffa06df2c7>] dvb_usb_download_firmware+0x37/0xf0 [dvb_usb]
>  [<ffffffffa06dfbe5>] dvb_usb_device_init+0x165/0x1b0 [dvb_usb]
>  [<ffffffffa06d6c27>] af9015_usb_probe+0x87/0xa0 [dvb_usb_af9015]
>  [<ffffffff8138d9d2>] usb_probe_interface+0x142/0x270
>  [<ffffffff8132f3c0>] really_probe+0x70/0x220
>  [<ffffffff8132f757>] driver_probe_device+0x47/0xa0
>  [<ffffffff8132e19c>] bus_for_each_drv+0x5c/0x90
>  [<ffffffff8132f62f>] device_attach+0x8f/0xb0
>  [<ffffffff8138d5b0>] usb_rebind_intf+0x60/0xa0
>  [<ffffffff8138d6c7>] do_unbind_rebind+0x77/0xb0
>  [<ffffffff8138d76b>] usb_resume+0x6b/0xb0
>  [<ffffffff8137f96b>] usb_dev_complete+0xb/0x10
>  [<ffffffff81334d1e>] device_complete+0x8e/0xe0
>  [<ffffffff81335da1>] dpm_resume_end+0xa1/0x120
>  [<ffffffff8109d890>] hibernation_snapshot+0xc0/0x120
>  [<ffffffff810a1cde>] snapshot_ioctl+0x3ae/0x590
>  [<ffffffff81169794>] do_vfs_ioctl+0x84/0x2f0
>  [<ffffffff81169a98>] sys_ioctl+0x98/0xa0
>  [<ffffffff81002ed2>] system_call_fastpath+0x16/0x1b
>  [<00007fe6c82f8ce7>] 0x7fe6c82f8ce7
> 
> 
> The firmware request should time out. I think I waited for longer than
> 60 s before when I saw the hangs on the desktop, But do you have an idea
> why it doesn't load the FW immediately?

I don't know why the request didn't time out, but this behavior should
at least be reproducible.  Your stack trace implies that the firmware
will need to be transferred every time the device resumes... but of
course this leaves open the question of why your desktop crashed only
occasionally.

Probably the firmware wasn't transferred immediately because the kernel
relies on a userspace process to find and load the firmware, but at
that point userspace was still frozen.

Rafael, this does seem to be a general problem.  Suppose a new device
gets connected while the system is suspended.  How is the driver's
probe method supposed to cope if it gets called while userspace is
still frozen but it needs to load some firmware?

Is the answer that probing should always be delayed until after tasks
are thawed?  There must be lots of subsystems which would have trouble 
doing that, although we ought to be able to implement delayed probing 
from within the driver core easily enough.

Alan Stern

