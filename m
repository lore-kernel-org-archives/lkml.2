Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab0EKTMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:12:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225Ab0EKTMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:12:00 -0400
Date: Tue, 11 May 2010 12:10:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: DRM Error on Acer Aspire One
Message-Id: <20100511121001.0731a9c2.akpm@linux-foundation.org>
In-Reply-To: <89kc63$grv1m8@fmsmga002.fm.intel.com>
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
	<89kc63$grtht6@fmsmga002.fm.intel.com>
	<20100511104818.8382a7de.akpm@linux-foundation.org>
	<89khjo$fd26d3@orsmga002.jf.intel.com>
	<20100511113555.a78c9c8e.akpm@linux-foundation.org>
	<89kc63$grv1m8@fmsmga002.fm.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 19:52:31 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> On Tue, 11 May 2010 11:35:55 -0400, Andrew Morton <akpm@linux-foundation.org> wrote:
> > No, io_mapping_map_atomic_wc() cannot be used from [soft]irq context:
> > it hardwires use of KM_USER0.  I suggest that io_mapping_create_wc(),
> > io_mapping_map_atomic_wc() etc be changed so that the caller passes in the
> > KM_foo kmap slot index.
> 
> Argh, sorry for the noise, read the mail in the wrong order. Thanks for
> the review. It would be sensible to go with your simpler patch whilst
> io_mapping_map_atomic_wc() is improved.

OK.  I'll be sending a bunch of fixes Linuswards in an hour or two.  
Should I include this?


Subject: drivers/gpu/drm/i915/i915_irq.c:i915_error_object_create(): use correct kmap-atomic slot
From: Andrew Morton <akpm@linux-foundation.org>

i915_error_object_create() is called from the timer interrupt and hence
can corrupt the KM_USER0 slot.  Use KM_IRQ0 instead.

Reported-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Tested-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_irq.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_irq.c~drivers-gpu-drm-i915-i915_irqc-i915_error_object_create-use-correct-kmap-atomic-slot drivers/gpu/drm/i915/i915_irq.c
--- a/drivers/gpu/drm/i915/i915_irq.c~drivers-gpu-drm-i915-i915_irqc-i915_error_object_create-use-correct-kmap-atomic-slot
+++ a/drivers/gpu/drm/i915/i915_irq.c
@@ -461,11 +461,15 @@ i915_error_object_create(struct drm_devi
 
 	for (page = 0; page < page_count; page++) {
 		void *s, *d = kmalloc(PAGE_SIZE, GFP_ATOMIC);
+		unsigned long flags;
+
 		if (d == NULL)
 			goto unwind;
-		s = kmap_atomic(src_priv->pages[page], KM_USER0);
+		local_irq_save(flags);
+		s = kmap_atomic(src_priv->pages[page], KM_IRQ0);
 		memcpy(d, s, PAGE_SIZE);
-		kunmap_atomic(s, KM_USER0);
+		kunmap_atomic(s, KM_IRQ0);
+		local_irq_restore(flags);
 		dst->pages[page] = d;
 	}
 	dst->page_count = page_count;
_

