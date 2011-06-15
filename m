Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1FOVOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:14:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51658 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755137Ab1FOVOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:14:04 -0400
Date: Wed, 15 Jun 2011 17:14:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Keith Packard <keithp@keithp.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: Oops in i915 intel_init_clock_gating
In-Reply-To: <20110615133256.113293a0@jbarnes-desktop>
Message-ID: <Pine.LNX.4.44L0.1106151707440.1797-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Jesse Barnes wrote:

> On Wed, 15 Jun 2011 16:08:51 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > The problem of dev_priv->display.init_clock_gating not getting set is 
> > still present in 3.0-rc3.  On my system this happens because 
> > intel_init_display() never gets called in the first place.
> > 
> > AFAICT, the normal calling sequence during driver initialization is:
> > 
> > 	i915_driver_load() -> i915_load_modeset_init() ->
> > 		intel_modeset_init() -> intel_init_display().
> > 
> > But in my case the call to i915_load_modeset_init() doesn't occur 
> > because drm_core_check_feature(dev, DRIVER_MODESET) is False.
> 
> Ouch, a non-KMS config.  Any reason you can't use KMS?

Normally I do use it.  This was a special testing config I've been 
nursing along for years, since well before KMS existed.  Either I never 
enabled KMS in the config, or else at some point it caused trouble so I 
removed it and never added it back.  Can't remember which -- all the 
testing I do with this config is at a VT, never under X.

> This patch should help at any rate.

I confirm that the patch fixes the problem.  Thanks.

On a different but related note, "rmmod i915" incites a lockdep 
notification:

[   54.316439] INFO: trying to register non-static key.
[   54.316589] the code is fine but needs lockdep annotation.
[   54.316729] turning off the locking correctness validator.
[   54.316871] Pid: 1683, comm: rmmod Not tainted 3.0.0-rc3 #2
[   54.317011] Call Trace:
[   54.317153]  [<c11f582a>] ? printk+0xf/0x11
[   54.317296]  [<c1049b3f>] register_lock_class+0x58/0x2d7
[   54.317438]  [<c102176e>] ? get_parent_ip+0xb/0x31
[   54.317579]  [<c105295a>] ? is_module_text_address+0x37/0x45
[   54.317722]  [<c1038917>] ? __kernel_text_address+0x1c/0x3e
[   54.317864]  [<c1049e61>] __lock_acquire+0xa3/0xc5a
[   54.318005]  [<c1003833>] ? dump_trace+0x7f/0xa5
[   54.318146]  [<c104aa09>] ? __lock_acquire+0xc4b/0xc5a
[   54.318287]  [<c104adf7>] lock_acquire+0x5e/0x75
[   54.318427]  [<c10364f4>] ? work_on_cpu+0x96/0x96
[   54.318567]  [<c1036530>] wait_on_work+0x3c/0x133
[   54.318707]  [<c10364f4>] ? work_on_cpu+0x96/0x96
[   54.318848]  [<c102fe0d>] ? lock_timer_base.clone.23+0x20/0x3e
[   54.318991]  [<c11f7892>] ? _raw_spin_unlock_irqrestore+0x36/0x5b
[   54.319134]  [<c102176e>] ? get_parent_ip+0xb/0x31
[   54.319275]  [<c11f9f99>] ? sub_preempt_count+0x7c/0x89
[   54.319417]  [<c1036cb2>] __cancel_work_timer+0xa0/0xde
[   54.319559]  [<c1036d07>] cancel_work_sync+0xa/0xc
[   54.319714]  [<f0128105>] i915_driver_unload+0x136/0x224 [i915]
[   54.319874]  [<f00af39d>] drm_put_dev+0xa9/0x170 [drm]
[   54.320029]  [<f00b086d>] drm_pci_exit+0x49/0x63 [drm]
[   54.320045]  [<f01508d0>] i915_exit+0x12/0x742 [i915]
[   54.320045]  [<c1050da5>] sys_delete_module+0x175/0x1c1
[   54.320045]  [<c107efb2>] ? remove_vma+0x52/0x58
[   54.320045]  [<c11f7ce0>] ? restore_all+0xf/0xf
[   54.320045]  [<c11fb610>] sysenter_do_call+0x12/0x36
[   54.336786] [drm] Module unloaded

Is this a known problem?

Alan Stern

