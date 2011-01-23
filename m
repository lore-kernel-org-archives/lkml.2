Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab1AWPi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:38:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42242 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1AWPi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:38:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IutDm2HbkMQKiiLyjLkk26/rlQM6Y62Yecvo3b39bYPMUs8SVoA/J/++oyz7wOUeuo
         q+pq9/HW+pU+q2Ah9gK+7oiqWLiEueg0YfNu/SPiwdoF4UiMnVTmoNYV0h7kStu7cOiP
         urQhPY2SFS+RlDrtuHy7eLrSk2cpdKBbnxMiU=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Handle the no-interrupts case for UMS by polling
Date: Sun, 23 Jan 2011 15:38:41 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <201101231128.22951.chris2553@googlemail.com> <1295787965-6849-1-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1295787965-6849-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101231538.41929.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 January 2011, Chris Wilson wrote:
> If the driver calls into the kernel to wait for a breadcrumb to pass,
> but hasn't enabled interrupts, fallback to polling the breadcrumb value.
>
> Reported-by: Chris Clayton <chris2553@googlemail.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/gpu/drm/i915/i915_irq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_irq.c
> b/drivers/gpu/drm/i915/i915_irq.c index 98106b7..4b5a35c 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -1293,12 +1293,12 @@ static int i915_wait_irq(struct drm_device * dev,
> int irq_nr) if (master_priv->sarea_priv)
>  		master_priv->sarea_priv->perf_boxes |= I915_BOX_WAIT;
>
> -	ret = -ENODEV;
>  	if (ring->irq_get(ring)) {
>  		DRM_WAIT_ON(ret, ring->irq_queue, 3 * DRM_HZ,
>  			    READ_BREADCRUMB(dev_priv) >= irq_nr);
>  		ring->irq_put(ring);
> -	}
> +	} else if (wait_for(READ_BREADCRUMB(dev_priv) >= irq_nr, 3000))
> +		ret = -EBUSY;
>
>  	if (ret == -EBUSY) {
>  		DRM_ERROR("EBUSY -- rec: %d emitted: %d\n",

That's done it. With all three patches applied, X and KDE are starting now. 
Thanks for your work on this.

A couple of points though.

1. The latest patch applied but the following warning was spat out:

patching file drivers/gpu/drm/i915/i915_irq.c
Hunk #1 succeeded at 1288 (offset -5 lines).

I guess we may be working with slightly different versions of the source.

2. The kernel log now contains the following:

r8169 0000:02:00.0: eth0: link up
[drm] Initialized drm 1.1.0 20060810
irq 16: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: kworker/0:1 Not tainted 2.6.38-rc2+ #502
Call Trace:
 [<c1070a54>] ? __report_bad_irq.clone.2+0x24/0x90
 [<c1070c17>] ? note_interrupt+0x157/0x190
 [<c101b1cd>] ? ack_apic_level+0x5d/0x1e0
 [<c107175b>] ? handle_fasteoi_irq+0xab/0xd0
 [<c10716b0>] ? handle_fasteoi_irq+0x0/0xd0
 <IRQ>  [<c1004ddd>] ? do_IRQ+0x3d/0xc0
 [<c1037f27>] ? irq_exit+0x57/0x70
 [<c1019173>] ? smp_apic_timer_interrupt+0x53/0x90
 [<c1003229>] ? common_interrupt+0x29/0x30
 [<c119fbe9>] ? acpi_safe_halt+0x19/0x26
 [<c119fc50>] ? acpi_idle_enter_c1+0x5a/0xa9
 [<c1244d98>] ? cpuidle_idle_call+0x68/0xf0
 [<c1001726>] ? cpu_idle+0x46/0x80
handlers:
[<c129dd60>] (azx_interrupt+0x0/0x180)
[<c12210d0>] (usb_hcd_irq+0x0/0x60)
Disabling IRQ #16
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
ioremap error for 0xbdce0000-0xbdce3000, requested 0x10, got 0x0
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

Is this likely to be related the the irq issues your patch addressed or is it a 
separate thing that I should report separately?

Thanks again.

Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
