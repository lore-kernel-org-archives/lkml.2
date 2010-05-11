Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab0EKStn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:49:43 -0400
Received: from mga10.intel.com ([192.55.52.92]:28278 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567Ab0EKStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:49:42 -0400
Message-Id: <89kc63$grv0vn@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,209,1272870000"; 
   d="scan'208";a="566199287"
Date: Tue, 11 May 2010 19:49:36 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drm/i915: Record error batch buffers using iomem
Cc: intel-gfx@lists.freedesktop.org,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org
References: <0100511104818.8382a7de.akpm@linux-foundation.org> <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk> <20100511113722.65ab2f4a.akpm@linux-foundation.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100511113722.65ab2f4a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 11:37:22 -0400, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 11 May 2010 19:22:14 +0100 Chris Wilson <chris@chris-wilson.co.uk> wrote:
> 
> > +	reloc_offset = src_priv->gtt_offset;
> >  	for (page = 0; page < page_count; page++) {
> > -		void *s, *d = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> > +		void __iomem *s;
> > +		void *d;
> > +
> > +		d = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> >  		if (d == NULL)
> >  			goto unwind;
> > -		s = kmap_atomic(src_priv->pages[page], KM_USER0);
> > -		memcpy(d, s, PAGE_SIZE);
> > -		kunmap_atomic(s, KM_USER0);
> > +
> > +		s = io_mapping_map_atomic_wc(dev_priv->mm.gtt_mapping,
> > +					     reloc_offset);
> > +		memcpy_fromio(d, s, PAGE_SIZE);
> > +		io_mapping_unmap_atomic(s);
> 
> As mentioned in the other email, this will still corrupt the KM_USER0
> slot, and will generate a debug_kmap_atomic() warning.

How, as kmap_atomic(KM_USER0) is no longer used?
-- 
Chris Wilson, Intel Open Source Technology Centre
