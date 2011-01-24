Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1AXHk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 02:40:58 -0500
Received: from smtp-out.google.com ([74.125.121.67]:59295 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1AXHk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 02:40:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ujxoAQClPNV68uUSEE3ewwsuZRtCY8sK3lU3Z++qrFEno+X7MVBrIFs3taXBgweReY
         A1hm5UnmWuYUD9NzYcsA==
Date: Sun, 23 Jan 2011 23:40:41 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Olsa <jolsa@redhat.com>, Chris Clayton <chris2553@googlemail.com>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
In-Reply-To: <20110123175945.GA1760@nowhere>
Message-ID: <alpine.LSU.2.00.1101232246380.3691@sister.anvils>
References: <20110123011221.GB1805@nowhere> <1295780472-8475-1-git-send-email-chris@chris-wilson.co.uk> <20110123175945.GA1760@nowhere>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011, Frederic Weisbecker wrote:
> On Sun, Jan 23, 2011 at 11:01:12AM +0000, Chris Wilson wrote:
> > We can only utilize the stolen portion of the GTT if we are in sole
> > charge of the hardware. This is only true if using GEM and KMS,
> > otherwise VESA continues to access stolen memory.
> > 
> > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Tested-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > ---
> > 
> > Frederic, updated patch attached. The bug was that clear_range took (start,
> > count) and I was passing in (start, end) so we were dereferencing past the
> > end of the valid pages.
> > -Chris
> 
> Works well, thank you :)
> 
> Tested-by: Frederic Weisbecker <fweisbec@gmail.com>

It improved matters for me (on a two-year-old Aspire One which had been
showing the same few characters of text repeated a large number of times
across the screen with 2.6.38-rc1 and rc2): the VESA framebuffer showing
good text at last.  But crashed once I tried startx, netconsole showing:

BUG: unable to handle kernel paging request at c00c0000
IP: [<802dcd32>] i830_write_entry+0x22/0x30
*pdpt = 0000000000730001 *pde = 000000003e4a0067 *pte = 0000000000000000 
Oops: 0002 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.3/0000:04:00.4/resource

Pid: 2908, comm: X Not tainted 2.6.38-rc2+ #16         /AOA110
EIP: 0060:[<802dcd32>] EFLAGS: 00213286 CPU: 0
EIP is at i830_write_entry+0x22/0x30
EAX: 3e4a1000 EBX: 3e4a1001 ECX: 00000001 EDX: c00c0000
ESI: 00010001 EDI: 000107b4 EBP: bbc45e00 ESP: bbc45dfc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process X (pid: 2908, ti=bbc44000 task=bdb62370 task.ti=bbc44000)
Stack:
 8055e7d4 bbc45e14 802dce45 be56a000 007bf000 0fff5000 bbc45e30 80306720
 0f836000 0fff5000 be4ca800 be4ca814 40106453 bbc45e48 80306776 0fff5000
 bbc45e94 bbc43380 be4ca800 bbc45f20 802e6a7e 00000001 8061e704 8055ef16
Call Trace:
 [<802dce45>] intel_gtt_clear_range+0x25/0x50
 [<80306720>] i915_gem_do_init+0x70/0x80
 [<80306776>] i915_gem_init_ioctl+0x46/0x70
 [<802e6a7e>] drm_ioctl+0x1ce/0x420
 [<80306730>] ? i915_gem_init_ioctl+0x0/0x70
 [<8018b1d1>] ? handle_pte_fault+0x81/0x7b0
 [<8017a325>] ? __free_pages+0x35/0x40
 [<8018c996>] ? handle_mm_fault+0xb6/0xf0
 [<802e68b0>] ? drm_ioctl+0x0/0x420
 [<801b2bcc>] do_vfs_ioctl+0x7c/0x580
 [<8011e543>] ? do_page_fault+0x173/0x3d0
 [<801a3417>] ? filp_close+0x47/0x70
 [<801b3109>] sys_ioctl+0x39/0x70
 [<80102b90>] sysenter_do_call+0x12/0x26
 [<80520000>] ? pci_scan_bridge+0x29b/0x414
Code: 26 00 8d bc 27 00 00 00 00 55 81 f9 01 00 01 00 89 e5 b9 01 00 00 00 53 bb 07 00 00 00 0f 45 d9 09 c3 c1 e2 02 03 15 34 bf 79 80 <89> 1a 5b 5d c3 89 f6 8d bc 27 00 00 00 00 a1 a0 be 79 80 55 89 
EIP: [<802dcd32>] i830_write_entry+0x22/0x30 SS:ESP 0068:bbc45dfc
CR2: 00000000c00c0000
---[ end trace 5eaf99b7f1ac958b ]---

But your comment above on clear_range was very helpful: your latest
patch fixed one call, but left two others unfixed.  Please fold in:

--- a/drivers/gpu/drm/i915/i915_gem_gtt.c	2011-01-23 11:52:47.350395154 -0800
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c	2011-01-23 20:13:01.457805176 -0800
@@ -36,7 +36,7 @@ void i915_gem_restore_gtt_mappings(struc
 
 	/* First fill with scratch pages */
 	intel_gtt_clear_range(dev_priv->mm.gtt_start / PAGE_SIZE,
-			      dev_priv->mm.gtt_end / PAGE_SIZE);
+		(dev_priv->mm.gtt_end - dev_priv->mm.gtt_start) / PAGE_SIZE);
 
 	list_for_each_entry(obj, &dev_priv->mm.gtt_list, gtt_list) {
 		i915_gem_clflush_object(obj);
--- a/drivers/gpu/drm/i915/i915_gem.c	2011-01-23 11:52:47.346395154 -0800
+++ b/drivers/gpu/drm/i915/i915_gem.c	2011-01-23 20:10:58.081193280 -0800
@@ -149,7 +149,7 @@ void i915_gem_do_init(struct drm_device
 	dev_priv->mm.mappable_gtt_total = min(end, mappable_end) - start;
 
 	/* Take over this portion of the GTT */
-	intel_gtt_clear_range(start / PAGE_SIZE, end / PAGE_SIZE);
+	intel_gtt_clear_range(start / PAGE_SIZE, (end - start) / PAGE_SIZE);
 }
 
 int

With that added into the mix, starting X then crashed with
i915_get_vblank_timestamp in the trace: which directed me to other
mailthreads, from which I picked up first your "Increase the amount
of defense" patch, which got X working at last, with reports of
[drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0
and then your "Disable high-precision vblank timestamping for UMS"
patch (I'd forgotten I was using UMS), which equally got X working.

So it's now running with your revised patch to Frederic, my correction
above, and your UMS vblank fix to Chris Clayton (looks like I don't
need the interrupts one).

On this laptop I'm typing from (GM965 with KMS), I've had no trouble
getting X up; but when typing in one of the xterms, typed characters
often stop echoing, until I shift to a different window, whereupon
they appear.  This condition cleared (for a while) by switching to
VESA fb console and back; no such problem observed on that console.

Does that sound familiar?  I have no evidence whatever that i915 is
to blame here.  Several times I tried bisecting last week, but each
attempt ended up in a nonsensical place, because the effect does not
occur to order.  So I'd sometimes mark a bisection point as good when
I guess it must actually have been bad.  Perhaps it's a matter of
timing or an uninitialized variable.  But while I'm here, worth asking
if that behaviour sounds like anything you might be responsible for?

Thanks,
Hugh
