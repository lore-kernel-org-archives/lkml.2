Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab2APUpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:45:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab2APUpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:45:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: 3.2.0-07927-gc49c41a: s2ram: Device 'machinecheck1' does not have a release() function, it is broken and must be fixed
Date: Mon, 16 Jan 2012 21:48:47 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Tony Luck <tony.luck@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com
References: <20120116131842.53f7ccc8@sf.home> <4F140872.3090409@linux.vnet.ibm.com>
In-Reply-To: <4F140872.3090409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201162148.47996.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 16, 2012, Srivatsa S. Bhat wrote:
> On 01/16/2012 03:48 PM, Sergei Trofimovich wrote:
> 
> > With 3.2.0-rc0 I was not able to s2ram twice in a row. Bisected down to
> > 
> >   commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
> >   Author: Kay Sievers <kay.sievers@vrfy.org>
> >   Date:   Wed Dec 21 14:29:42 2011 -0800
> > 
> >       cpu: convert 'cpu' and 'machinecheck' sysdev_class to a regular subsystem
> > 
> > it was fixed recently by commit
> > 
> >   commit a3301b751b19f0efbafddc4034f8e7ce6bf3007b
> >   Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >   Date:   Sat Jan 14 08:11:31 2012 +0530
> > 
> >     x86/mce: Fix CPU hotplug and suspend regression related to MCE
> > 
> > alas the warning pop ups (3.2.0-07927-gc49c41a).
> > 
> > command for suspend:
> >     sudo sh -c "echo mem > /sys/power/state"
> > 
> > [ 7915.604188] ------------[ cut here ]------------
> > [ 7915.604203] WARNING: at drivers/base/core.c:194 device_release+0x85/0x90()
> > [ 7915.604209] Hardware name: HP Compaq 2510p Notebook PC
> > [ 7915.604214] Device 'machinecheck1' does not have a release() function, it is broken and must be fixed.
> > [ 7915.604219] Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
> >  ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
> >  snd_timer iwl4965 iwlegacy snd mac80211 cfg80211 yenta_socket soundcore pcmcia_core pcmcia_rsrc rfkill i915 sdhci_pci drm_kms_
> > helper sdhci mmc_core drm e1000e snd_page_alloc i2c_algo_bit
> > [ 7915.604293] Pid: 30171, comm: sh Not tainted 3.2.0-07927-gc49c41a #190
> > [ 7915.604298] Call Trace:
> > [ 7915.604311]  [<ffffffff81038f9a>] warn_slowpath_common+0x7a/0xb0
> > [ 7915.604320]  [<ffffffff81039071>] warn_slowpath_fmt+0x41/0x50
> > [ 7915.604331]  [<ffffffff81060781>] ? get_parent_ip+0x11/0x50
> > [ 7915.604338]  [<ffffffff8130a3d5>] device_release+0x85/0x90
> > [ 7915.604348]  [<ffffffff8125483d>] kobject_release+0x8d/0x1d0
> > [ 7915.604356]  [<ffffffff812546dc>] kobject_put+0x2c/0x60
> > [ 7915.604364]  [<ffffffff8130a122>] put_device+0x12/0x20
> > [ 7915.604371]  [<ffffffff8130b235>] device_unregister+0x25/0x60
> > [ 7915.604383]  [<ffffffff81450485>] mce_cpu_callback+0xe2/0x18a
> > [ 7915.604392]  [<ffffffff8105b4bc>] notifier_call_chain+0x4c/0x70
> > [ 7915.604400]  [<ffffffff8105b569>] __raw_notifier_call_chain+0x9/0x10
> > [ 7915.604408]  [<ffffffff8103ab1b>] __cpu_notify+0x1b/0x30
> > [ 7915.604416]  [<ffffffff8103ab40>] cpu_notify+0x10/0x20
> > [ 7915.604423]  [<ffffffff8103ab59>] cpu_notify_nofail+0x9/0x20
> > [ 7915.604433]  [<ffffffff8144345b>] _cpu_down+0x13b/0x250
> > [ 7915.604441]  [<ffffffff8145536c>] ? printk+0x3c/0x40
> > [ 7915.604450]  [<ffffffff8103ad76>] disable_nonboot_cpus+0x86/0x120
> > [ 7915.604460]  [<ffffffff81083598>] suspend_devices_and_enter+0x148/0x240
> > [ 7915.604469]  [<ffffffff810837e9>] enter_state+0x159/0x180
> > [ 7915.604477]  [<ffffffff81082606>] state_store+0xc6/0x140
> > [ 7915.604485]  [<ffffffff81254567>] kobj_attr_store+0x17/0x20
> > [ 7915.604494]  [<ffffffff81142ce4>] sysfs_write_file+0xf4/0x170
> > [ 7915.604504]  [<ffffffff810e15e6>] vfs_write+0xc6/0x180
> > [ 7915.604512]  [<ffffffff810e18fc>] sys_write+0x4c/0x90
> > [ 7915.604521]  [<ffffffff81459122>] system_call_fastpath+0x16/0x1b
> > [ 7915.604528] ---[ end trace a06cd82fe48c1076 ]---
> > 
> 
> 
> Hi Sergei,
> 
> As I noted in the mail in which I posted that patch
> (http://thread.gmane.org/gmane.linux.kernel/1237745/focus=1239134),
> my patch just fixes the suspend issue. It doesn't attempt to fix the
> "machinecheck not having a release() function" warning. And as mentioned
> in the preceding discussion in the same thread,
> (http://thread.gmane.org/gmane.linux.kernel/1237745/focus=1239052)
> this warning is not a problem for suspend to work.
> 
> Of course, we have to get rid of this warning and one easy and trivial
> way to get rid of this would be to add a dummy release() function for
> MCE, since technically there is nothing to be released, since we use
> per-cpu allocations of struct device.
> 
> But the only reason I haven't really jumped into writing such a patch
> is that I would prefer to get the semantics right - adding a dummy
> function is IMO something like working around the rules of the driver-core
> framework just to silence the warning. Hence I feel we should resort
> to it _only_ if there is nothing better we can do about this.
> 
> Just to re-instate, an end-user need not really worry about this warning
> too much since this was there before (at a different place, and hidden)
> when things were working fine... Hence it would be worthwhile to fix
> this warning "correctly" if possible, than just do a quick and dirty
> "silence the warning" kind of workaround. 

Well, since there's nothing to release in there, I really see only two
possible "fixes": either silence the warning the way you describe, or
remove it from the core.

Thanks,
Rafael
