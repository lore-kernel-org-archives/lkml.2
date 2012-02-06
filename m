Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2BFHPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:15:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:45724 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab2BFHPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:15:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114493906"
Subject: Re: [BUG 3.3-rc2] spinlock trylock failure on UP on CPU#0
From: Shaohua Li <shaohua.li@intel.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4F2F7D04.6020502@t-online.de>
References: <4F2EED22.3070901@t-online.de>
	 <CA+55aFzPiy5RB+B70gPGX7sSJvcwqHuwL9F=SGMZBG58CuX9pQ@mail.gmail.com>
	 <CANejiEWBdL4G3qt4=qjzakkokt1xbmcRXFS15EFt3bnSsvkCMA@mail.gmail.com>
	 <4F2F7D04.6020502@t-online.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 15:13:31 +0800
Message-ID: <1328512411.21268.63.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 08:11 +0100, Knut Petersen wrote:
> Am 06.02.2012 02:25, schrieb Shaohua Li: 
> > 2012/2/6 Linus Torvalds <torvalds@linux-foundation.org>:
> > > Jens, Tejun - the crazy-ass games that this code is playing is clearly
> > > messing not just with lockdep, it's messing with some very reasonable
> > > spinlock sanity checks on UP (which just boil down to "a spinlock
> > > should never have contention on UP")
> > > 
> > > Any chance of sanitizing this all?
> > I just sent out a debug patch, please try:
> > http://marc.info/?l=linux-kernel&m=132849146702770&w=2
> > 
> 
> Your debug patch helps - but with you patch applied another problem is
> back again:
Looks not related to the original block issue. please report it to DVB
guys.

Thanks,
Shaohua

> 3.2.1 ... 3.2.4
> ===========
> dvb-s reception with kaffeine works well, but starting kaffeine 
> triggers a circular locking dependency warning, see:
> http://www.gossamer-threads.com/lists/linux/kernel/1487577
> 
> 
> 3.3-rc2+ (23783f817bceedd6d4e549385e3f400ea64059e5)
> ===============================================
> spinlock trylock failure on UP on CPU#0 warning is triggered during
> system startup,
> dvb-s with kaffeine is broken (only about  1-2 fps, video frames and
> audio distorted), 
> the circular locking dependency warning mentioned above is gone.
> 
> 
> 3.3-rc2+ (23783f817bceedd6d4e549385e3f400ea64059e5) +
> blk-icq-lock-fix.patch
> =================================================================
> spinlock trylock failure warning during system startup is gone,
> dvb-s reception with kaffeine is still broken,
> the circular locking dependency warning is triggered again by
> kaffeine:
> 
> [  124.314255] 
> [  124.314262] ======================================================
> [  124.314270] [ INFO: possible circular locking dependency detected ]
> [  124.314279] 3.3.0-rc2-main+ #22 Not tainted
> [  124.314285] -------------------------------------------------------
> [  124.314293] kaffeine/3743 is trying to acquire lock:
> [  124.314300]  (&fe->lock){+.+.+.}, at: [<f85e70cf>]
> videobuf_dvb_find_frontend+0x16/0x3e [videobuf_dvb]
> [  124.314320] 
> [  124.314321] but task is already holding lock:
> [  124.314327]  (minor_rwsem#2){++++..}, at: [<f8e430c8>]
> dvb_device_open+0x24/0x185 [dvb_core]
> [  124.314348] 
> [  124.314349] which lock already depends on the new lock.
> [  124.314351] 
> [  124.314359] 
> [  124.314360] the existing dependency chain (in reverse order) is:
> [  124.314369] 
> [  124.314370] -> #2 (minor_rwsem#2){++++..}:
> [  124.314382]        [<c0149609>] lock_acquire+0x45/0x5c
> [  124.314394]        [<c0441070>] down_write+0x1b/0x36
> [  124.314405]        [<f8e43521>] dvb_register_device+0x113/0x1ed
> [dvb_core]
> [  124.314420]        [<f8e4b320>] dvb_register_frontend+0x172/0x19e
> [dvb_core]
> [  124.314437]        [<f85e7266>] videobuf_dvb_register_bus
> +0xbe/0x2cb [videobuf_dvb]
> [  124.314450]        [<f86d0c9e>] cx8802_dvb_probe+0x1eac/0x1f22
> [cx88_dvb]
> [  124.314464]        [<f857a420>] cx8802_register_driver+0x116/0x1cc
> [cx8802]
> [  124.314479]        [<f8ce701c>] 0xf8ce701c
> [  124.314490]        [<c0101070>] do_one_initcall+0x70/0x118
> [  124.314500]        [<c01504d1>] sys_init_module+0x12a3/0x1543
> [  124.314510]        [<c0442bf5>] syscall_call+0x7/0xb
> [  124.314520] 
> [  124.314521] -> #1 (dvbdev_register_lock){+.+.+.}:
> [  124.314532]        [<c0149609>] lock_acquire+0x45/0x5c
> [  124.314541]        [<c0440b37>] mutex_lock_nested+0x35/0x275
> [  124.314550]        [<f8e4342d>] dvb_register_device+0x1f/0x1ed
> [dvb_core]
> [  124.314564]        [<f8e439a5>] dvb_dmxdev_init+0xc0/0xf0
> [dvb_core]
> [  124.314577]        [<f85e7311>] videobuf_dvb_register_bus
> +0x169/0x2cb [videobuf_dvb]
> [  124.314589]        [<f86d0c9e>] cx8802_dvb_probe+0x1eac/0x1f22
> [cx88_dvb]
> [  124.314601]        [<f857a420>] cx8802_register_driver+0x116/0x1cc
> [cx8802]
> [  124.314612]        [<f8ce701c>] 0xf8ce701c
> [  124.314620]        [<c0101070>] do_one_initcall+0x70/0x118
> [  124.314629]        [<c01504d1>] sys_init_module+0x12a3/0x1543
> [  124.314638]        [<c0442bf5>] syscall_call+0x7/0xb
> [  124.314647] 
> [  124.314648] -> #0 (&fe->lock){+.+.+.}:
> [  124.314658]        [<c0148d54>] __lock_acquire+0xd88/0x12b8
> [  124.314667]        [<c0149609>] lock_acquire+0x45/0x5c
> [  124.314675]        [<c0440b37>] mutex_lock_nested+0x35/0x275
> [  124.314684]        [<f85e70cf>] videobuf_dvb_find_frontend
> +0x16/0x3e [videobuf_dvb]
> [  124.314695]        [<f86ced7a>] cx88_dvb_bus_ctrl+0x22/0x9a
> [cx88_dvb]
> [  124.314707]        [<f8e4982f>] dvb_frontend_open+0x14b/0x2ee
> [dvb_core]
> [  124.314722]        [<f8e43173>] dvb_device_open+0xcf/0x185
> [dvb_core]
> [  124.314735]        [<c0194f15>] chrdev_open+0x14e/0x16c
> [  124.314754]        [<c019056b>] __dentry_open+0x193/0x288
> [  124.314768]        [<c01913a9>] nameidata_to_filp+0x42/0x50
> [  124.314780]        [<c019c89b>] do_last+0x6db/0x6ed
> [  124.314793]        [<c019c973>] path_openat+0xa1/0x2c2
> [  124.314805]        [<c019cc40>] do_filp_open+0x21/0x5d
> [  124.314818]        [<c01914a5>] do_sys_open+0xee/0x167
> [  124.314830]        [<c019153d>] sys_open+0x1f/0x27
> [  124.314842]        [<c0442bf5>] syscall_call+0x7/0xb
> [  124.314855] 
> [  124.314856] other info that might help us debug this:
> [  124.314857] 
> [  124.314876] Chain exists of:
> [  124.314877]   &fe->lock --> dvbdev_register_lock --> minor_rwsem#2
> [  124.314896] 
> [  124.314906]  Possible unsafe locking scenario:
> [  124.314908] 
> [  124.314921]        CPU0                    CPU1
> [  124.314931]        ----                    ----
> [  124.314940]   lock(minor_rwsem#2);
> [  124.314951]
> lock(dvbdev_register_lock);
> [  124.314964]                                lock(minor_rwsem#2);
> [  124.314977]   lock(&fe->lock);
> [  124.314987] 
> [  124.314987]  *** DEADLOCK ***
> [  124.314989] 
> [  124.315007] 2 locks held by kaffeine/3743:
> [  124.315016]  #0:  (dvbdev_mutex){+.+...}, at: [<f8e430be>]
> dvb_device_open+0x1a/0x185 [dvb_core]
> [  124.315040]  #1:  (minor_rwsem#2){++++..}, at: [<f8e430c8>]
> dvb_device_open+0x24/0x185 [dvb_core]
> [  124.315065] 
> [  124.315066] stack backtrace:
> [  124.315080] Pid: 3743, comm: kaffeine Not tainted 3.3.0-rc2-main+
> #22
> [  124.315091] Call Trace:
> [  124.315103]  [<c011dd19>] ? console_unlock+0x1ad/0x1d3
> [  124.315116]  [<c043cfa8>] print_circular_bug+0x215/0x222
> [  124.315129]  [<c0148d54>] __lock_acquire+0xd88/0x12b8
> [  124.315141]  [<c0103d67>] ? print_context_stack+0x7a/0x8d
> [  124.315153]  [<c0103268>] ? dump_trace+0x78/0xa5
> [  124.315165]  [<c0149609>] lock_acquire+0x45/0x5c
> [  124.315178]  [<f85e70cf>] ? videobuf_dvb_find_frontend+0x16/0x3e
> [videobuf_dvb]
> [  124.315194]  [<f85e70cf>] ? videobuf_dvb_find_frontend+0x16/0x3e
> [videobuf_dvb]
> [  124.315208]  [<c0440b37>] mutex_lock_nested+0x35/0x275
> [  124.315222]  [<f85e70cf>] ? videobuf_dvb_find_frontend+0x16/0x3e
> [videobuf_dvb]
> [  124.315237]  [<f85e70cf>] videobuf_dvb_find_frontend+0x16/0x3e
> [videobuf_dvb]
> [  124.315254]  [<f86ced7a>] cx88_dvb_bus_ctrl+0x22/0x9a [cx88_dvb]
> [  124.315273]  [<f8e4982f>] dvb_frontend_open+0x14b/0x2ee [dvb_core]
> [  124.315293]  [<f8e43173>] dvb_device_open+0xcf/0x185 [dvb_core]
> [  124.315307]  [<c0194f15>] chrdev_open+0x14e/0x16c
> [  124.315320]  [<c019056b>] __dentry_open+0x193/0x288
> [  124.315333]  [<c044502f>] ? sub_preempt_count+0x81/0x8e
> [  124.315345]  [<c01913a9>] nameidata_to_filp+0x42/0x50
> [  124.315357]  [<c0194dc7>] ? cdev_put+0x1a/0x1a
> [  124.315369]  [<c019c89b>] do_last+0x6db/0x6ed
> [  124.315381]  [<c019c973>] path_openat+0xa1/0x2c2
> [  124.315393]  [<c019cc40>] do_filp_open+0x21/0x5d
> [  124.315406]  [<c044502f>] ? sub_preempt_count+0x81/0x8e
> [  124.315418]  [<c04428ba>] ? _raw_spin_unlock+0x27/0x3d
> [  124.315432]  [<c01a5a8f>] ? alloc_fd+0xb3/0xbe
> [  124.315444]  [<c01914a5>] do_sys_open+0xee/0x167
> [  124.315456]  [<c019153d>] sys_open+0x1f/0x27
> [  124.315468]  [<c0442bf5>] syscall_call+0x7/0xb
> [  124.315480]  [<c0440000>] ? schedule_timeout_interruptible+0x8/0x16
> 
> Software
> =======
> openSuSE 12.1, Tumbleweed
> X.Org X Server 1.11.99.902 (1.12.0 RC 2), current git master
> Kaffeine: 1.2.2 (Qt: 4.7.4, KDE: 4.7.2 (4.7.2) "release 5")
> 
> Hardware
> ========
> AOpen i915GMm-hfs, Pentium-M Dothan (2GHz), 2GB RAM
> Hauppauge WinTV Nova-HD-S2
> 
> cu,
> knut


