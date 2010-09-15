Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab0IONRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:17:16 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39279 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab0IONRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vsAkkSMvMLlwdVog0PYo/Wba8czWWW2FgEt0VIUht/RT4F/WONAbkumB9Jt6ZH10yL
         ghIzevwivtpjNFoRR3gu8SDhR4TQiGOSk3/hRBeOf5gAGOsDmlGNdYVkIyD3sIPqyMv+
         4LE6j4LH1Ah4TEt6fm6F+AnNLgGqH7h7YSUAI=
Date: Wed, 15 Sep 2010 06:17:12 -0700
From: mark gross <markgross@thegnar.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Simon Kirby <sim@hostway.ca>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>
Subject: Re: [linux-pm] [2.6.36-rc4/HEAD] unable to handle kernel NULL
 pointer dereference	(plist_add)
Message-ID: <20100915131712.GB24308@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100913070034.GA4820@hostway.ca>
 <201009142238.25840.rjw@sisk.pl>
 <201009150006.26411.rjw@sisk.pl>
 <s5hfwxbpfy5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfwxbpfy5.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 10:29:54AM +0200, Takashi Iwai wrote:
> At Wed, 15 Sep 2010 00:06:26 +0200,
> Rafael J. Wysocki wrote:
> > 
> > On Tuesday, September 14, 2010, Rafael J. Wysocki wrote:
> > > On Monday, September 13, 2010, Simon Kirby wrote:
> > > > Hi!
> > > > 
> > > > At first I thought I hitting a suspend bug, but it was because I had an
> > > > rmmod/modprobe of snd_ice1724 in my "gosleep" script to work around my
> > > > sound sounding crackly after resume.  I can reproduce this same crash
> > > > simply by using sound, rmmod snd_ice1724, modprobe snd_ice1724, and then
> > > > using sound again.
> > > > 
> > > > I git-bisected to:
> > > > 82f682514a5df89ffb3890627eebf0897b7a84ec is the first bad commit
> > > > commit 82f682514a5df89ffb3890627eebf0897b7a84ec
> > > > Author: James Bottomley <James.Bottomley@suse.de>
> > > > Date:   Mon Jul 5 22:53:06 2010 +0200
> > > > 
> > > >     pm_qos: Get rid of the allocation in pm_qos_add_request()
> > > > 
> > > >     All current users of pm_qos_add_request() have the ability to supply
> > > >     the memory required by the pm_qos routines, so make them do this and
> > > >     eliminate the kmalloc() with pm_qos_add_request().  This has the
> > > >     double benefit of making the call never fail and allowing it to be
> > > >     called from atomic context.
> > > > 
> > > >     Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> > > >     Signed-off-by: mark gross <markgross@thegnar.org>
> > > >     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > :040000 040000 0370d037cfe56ae4079bc47713b98c5961de258f 92d6437da54649496c84bacc16ef4b17f8087bbd M      drivers
> > > > :040000 040000 6ec551133758633de70e97b4a41d893a5c050e74 4ac17ea227c07d9cf7dae297a40bbbcc374c232f M      include
> > > > :040000 040000 d0bb4b15e77a0976940af48588ef0e9b9fd7590b ac682974217c7e75a771b92c8efa7c83659d2916 M      kernel
> > > > :040000 040000 9ab6e37ec622354cb93abc2b7424b10263bcd007 011680bad3da4b60aebb659eaeb85a037e2513f3 M      sound
> > > > 
> > > > ...but I can't revert this over HEAD due to conflicts and I can't see
> > > > what's wrong in the diff.  2.6.35 is fine.
> > > > 
> > > > Simon-
> > > > 
> > > > [   61.234230] ICE1724 0000:01:06.0: PCI INT A disabled
> > > > [   61.240010] ICE1724 0000:01:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> > > > [   62.156008] BUG: unable to handle kernel NULL pointer dereference at (null)
> > > > [   62.156008] IP: [<ffffffff81379706>] plist_add+0x36/0xa0
> > > > [   62.156008] PGD 1ad813067 PUD 1ad989067 PMD 0 
> > > > [   62.156008] Oops: 0000 [#1] SMP 
> > > > [   62.156008] last sysfs file: /sys/devices/pci0000:00/0000:00:14.4/0000:01:06.0/sound/card0/uevent
> > > > [   62.156118] CPU 1 
> > > > [   62.156147] Modules linked in: snd_ice1724 sco bnep rfcomm l2cap bluetooth ppdev hwmon_vid usb_storage tun i2c_viapro snd_rawmidi snd_ice17xx_ak4xxx snd_ac97_codec ac97_bus snd_ak4xxx_adda snd_ak4114 snd_pt2258 snd_i2c parport_pc r8169 parport snd_ak4113 k10temp [last unloaded: snd_ice1724]
> > > > [   62.156849] 
> > > > [   62.156925] Pid: 3053, comm: mplayer Not tainted 2.6.36-rc4-oof+ #6 M4A79T Deluxe/System Product Name
> > > > [   62.157058] RIP: 0010:[<ffffffff81379706>]  [<ffffffff81379706>] plist_add+0x36/0xa0
> > > > [   62.157217] RSP: 0018:ffff8801ac7f3cd8  EFLAGS: 00010002
> > > > [   62.157297] RAX: fffffffffffffff8 RBX: ffff8801a93eae40 RCX: ffff8801ac48e048
> > > > [   62.157386] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801a93eae40
> > > > [   62.157475] RBP: ffff8801ac7f3cf8 R08: 0000000000005356 R09: 0000000000004000
> > > > [   62.157564] R10: 0000000000000000 R11: 00000000fffffffe R12: ffffffff8195a2a0
> > > > [   62.157590] R13: ffff8801a93eae58 R14: 0000000000003e80 R15: ffffffff8195a2b0
> > > > [   62.157590] FS:  00007f79749f5860(0000) GS:ffff880001c80000(0000) knlGS:0000000000000000
> > > > [   62.157590] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [   62.157590] CR2: 0000000000000000 CR3: 00000001aef63000 CR4: 00000000000006e0
> > > > [   62.157590] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > [   62.157590] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > [   62.157590] Process mplayer (pid: 3053, threadinfo ffff8801ac7f2000, task ffff8801ac535cd0)
> > > > [   62.157590] Stack:
> > > > [   62.157590]  ffff8801ac7f3d18 ffffffff8195a2a0 ffff8801a93eae40 00000000ffffffff
> > > > [   62.157590] <0> ffff8801ac7f3d48 ffffffff8105f35b ffff880100000000 0000000000000292
> > > > [   62.157590] <0> ffff8801ac7f3d58 ffff8801a93eae40 ffff8801ad849400 ffff8801ad849c00
> > > > [   62.157590] Call Trace:
> > > > [   62.157590]  [<ffffffff8105f35b>] update_target+0x12b/0x140
> > > > [   62.157590]  [<ffffffff8105f5aa>] pm_qos_add_request+0x4a/0x80
> > > > [   62.157590]  [<ffffffff8157e8a4>] snd_pcm_hw_params+0x2d4/0x3a0
> > > > [   62.157590]  [<ffffffff8157ed41>] snd_pcm_common_ioctl1+0xb1/0xb90
> > > > [   62.157590]  [<ffffffff810bcbc2>] ? handle_mm_fault+0x192/0xa50
> > > > [   62.157590]  [<ffffffff8157facd>] snd_pcm_playback_ioctl1+0x3d/0x220
> > > > [   62.157590]  [<ffffffff81698b9f>] ? do_page_fault+0x17f/0x440
> > > > [   62.157590]  [<ffffffff8158035d>] snd_pcm_playback_ioctl+0x3d/0x50
> > > > [   62.157590]  [<ffffffff810e8787>] do_vfs_ioctl+0x97/0x530
> > > > [   62.157590]  [<ffffffff810c493c>] ? do_mmap_pgoff+0x34c/0x3a0
> > > > [   62.157590]  [<ffffffff810e8c6a>] sys_ioctl+0x4a/0x80
> > > > [   62.157590]  [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
> > > > [   62.157590] Code: 54 49 89 f4 53 48 89 fb 48 83 ec 08 4c 3b 6f 18 75 69 49 8b 04 24 48 83 e8 08 eb 0f 90 8b 30 39 33 7c 18 66 90 74 4e 48 8d 42 f8 <48> 8b 50 08 48 8d 48 08 4c 39 e1 0f 18 0a 75 e2 48 8b 50 10 48 
> > > > [   62.157590] RIP  [<ffffffff81379706>] plist_add+0x36/0xa0
> > > > [   62.157590]  RSP <ffff8801ac7f3cd8>
> > > > [   62.157590] CR2: 0000000000000000
> > > > [   62.157590] ---[ end trace 853ed59ac5273c1f ]---
> > > 
> > > Hmm, interesting.  This looks like a plist corruption to me, but can you please
> > > check (using gdb) what line of code corresponds to the address
> > > plist_add+0x36/0xa0 ?
> > 
> > Well, my current theory is that the list member of latency_pm_qos_req in
> > struct snd_pcm_substream gets corrupted because of the changed size of the
> > structure.  Then, deleting it from the plist corrupts the plist itself, which
> > only turns up when we try to add a new item to it.
> > 
> > If that's really the case, the (untested!) patch below should help (unless I broke it).
> 
> Could you try first the patch in kernel bugzilla 17922?
> This might be an unreleased object, mostly only triggered via OSS
> emulation.
>     https://bugzilla.kernel.org/show_bug.cgi?id=17922

adding the pm_qos_remove in the snd_pcm_release_substream may be all
thats needed to fix the problem.  If the snd_cpm is unloading its module
without removing the qos request from the list then the very next time
any pm_qos operation requiring a list walk like adding or removing an
element, would trigger a failure.

i.e. the second hunk of the change in the above bugzilla should be all
that is needed.

--mark

> 
> 
> thanks,
> 
> Takashi
