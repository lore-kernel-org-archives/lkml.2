Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2G0APr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 20:15:47 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:49218
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457Ab2G0APp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 20:15:45 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI1432Izz1202hzz8275bh8275dhz2fh2a8h668h839hd25hf0ah107ah10d2h)
Message-ID: <5011DD9B.1030901@am.sony.com>
Date: Thu, 26 Jul 2012 17:15:23 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, <tglx@linutronix.de>,
        <chris.pringle@miranda.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 05/12] slab: Prevent local lock deadlock
References: <20120718223910.898476857@goodmis.org> <20120718223957.856443728@goodmis.org>
In-Reply-To: <20120718223957.856443728@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/12 15:39, Steven Rostedt wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> On RT we avoid the cross cpu function calls and take the per cpu local
> locks instead. Now the code missed that taking the local lock on the
> cpu which runs the code must use the proper local lock functions and
> not a simple spin_lock(). Otherwise it deadlocks later when trying to
> acquire the local lock with the proper function.
> 
> Reported-and-tested-by: Chris Pringle <chris.pringle@miranda.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  mm/slab.c |   26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)


This patch leads to a warning during boot on the ARM pandaboard:

[    0.225097] Brought up 2 CPUs
[    0.225097] SMP: Total of 2 processors activated (2007.19 BogoMIPS).
[    0.225952] 
[    0.225982] =============================================
[    0.225982] [ INFO: possible recursive locking detected ]
[    0.225982] 3.0.36-rt58 #1
[    0.225982] ---------------------------------------------
[    0.225982] swapper/0/1 is trying to acquire lock:
[    0.226013]  (&per_cpu(slab_lock, __cpu).lock){+.+...}, at: [<c0147544>] do_ccupdate_local+0x18/0x44
[    0.226043] 
[    0.226043] but task is already holding lock:
[    0.226043]  (&per_cpu(slab_lock, __cpu).lock){+.+...}, at: [<c014737c>] lock_slab_on+0x48/0x134
[    0.226074] 
[    0.226074] other info that might help us debug this:
[    0.226074]  Possible unsafe locking scenario:
[    0.226074] 
[    0.226074]        CPU0
[    0.226074]        ----
[    0.226074]   lock(&per_cpu(slab_lock, __cpu).lock);
[    0.226104]   lock(&per_cpu(slab_lock, __cpu).lock);
[    0.226104] 
[    0.226104]  *** DEADLOCK ***
[    0.226104] 
[    0.226104]  May be due to missing lock nesting notation
[    0.226104] 
[    0.226104] 2 locks held by swapper/0/1:
[    0.226135]  #0:  (cache_chain_mutex){+.+.+.}, at: [<c014a618>] kmem_cache_create+0x74/0x4bc
[    0.226135]  #1:  (&per_cpu(slab_lock, __cpu).lock){+.+...}, at: [<c014737c>] lock_slab_on+0x48/0x134
[    0.226165] 
[    0.226165] stack backtrace:
[    0.226196] [<c00681f8>] (unwind_backtrace+0x0/0xf0) from [<c00da918>] (__lock_acquire+0x1984/0x1ce8)
[    0.226196] [<c00da918>] (__lock_acquire+0x1984/0x1ce8) from [<c00db29c>] (lock_acquire+0x100/0x120)
[    0.226226] [<c00db29c>] (lock_acquire+0x100/0x120) from [<c0485c10>] (rt_spin_lock+0x4c/0x5c)
[    0.226257] [<c0485c10>] (rt_spin_lock+0x4c/0x5c) from [<c0147544>] (do_ccupdate_local+0x18/0x44)
[    0.226257] [<c0147544>] (do_ccupdate_local+0x18/0x44) from [<c01476e8>] (slab_on_each_cpu+0x2c/0x64)
[    0.226287] [<c01476e8>] (slab_on_each_cpu+0x2c/0x64) from [<c0149c70>] (do_tune_cpucache+0xd8/0x3e8)
[    0.226287] [<c0149c70>] (do_tune_cpucache+0xd8/0x3e8) from [<c014a154>] (enable_cpucache+0x50/0xcc)
[    0.226318] [<c014a154>] (enable_cpucache+0x50/0xcc) from [<c014a974>] (kmem_cache_create+0x3d0/0x4bc)
[    0.226318] [<c014a974>] (kmem_cache_create+0x3d0/0x4bc) from [<c0021e54>] (init_tmpfs+0x3c/0xe8)
[    0.226348] [<c0021e54>] (init_tmpfs+0x3c/0xe8) from [<c00083b4>] (kernel_init+0x80/0x150)
[    0.226379] [<c00083b4>] (kernel_init+0x80/0x150) from [<c0061e30>] (kernel_thread_exit+0x0/0x8)
[    0.239776] omap_hwmod: _populate_mpu_rt_base found no _mpu_rt_va for emif_fw
[    0.239776] omap_hwmod: _populate_mpu_rt_base found no _mpu_rt_va for l3_instr



Config is from arch/arm/configs/omap2plus_defconfig
plus:

   CONFIG_USB_EHCI_HCD=y
   CONFIG_USB_NET_SMSC95XX=y
   CONFIG_PREEMPT_RT_FULL=y


-Frank

