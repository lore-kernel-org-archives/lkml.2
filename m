Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2JFIEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:04:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:6011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab2JFIEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:04:47 -0400
Message-Id: <b94cdc$6rvjl8@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,543,1344236400"; 
   d="scan'208";a="230674088"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 3.5 regression on i915
To: Willy Tarreau <w@1wt.eu>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20121005234218.GC21163@1wt.eu>
References: <20121005234218.GC21163@1wt.eu>
Date: Sat, 06 Oct 2012 09:04:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2012 01:42:18 +0200, Willy Tarreau <w@1wt.eu> wrote:
> Chris, Daniel,
> 
> since version 3.5, my Asus EeePC 1005HA bugs during startx. I didn't
> have the time to investigate until this evening.
> 
> I could bisect the commits and found that the following one was merged
> in 3.5-rc1 and is responsible for these bugs that can reliably be
> triggered :
> 
>   1b50247a8ddde4af5aaa0e6bc125615372ce6c16 is the first bad commit
>   commit 1b50247a8ddde4af5aaa0e6bc125615372ce6c16
>   Author: Chris Wilson <chris@chris-wilson.co.uk>
>   Date:   Tue Apr 24 15:47:30 2012 +0100
> 
>     drm/i915: Remove the list of pinned inactive objects
>     
>     Simplify object tracking by removing the inactive but pinned list. The
>     only place where this was used is for counting the available memory,
>     which is just as easy performed by checking all objects on the rare
>     occasions it is required (application startup). For ease of debugging,
>     we keep the reporting of pinned objects through the error-state and
>     debugfs.
>     
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> I tried to revert it from 3.5.6-rc1 but it does not revert cleanly at all
> and I'm totall unfamiliar with this code to attempt anything sane at this
> time of the night.
> 
> The crash happens here in i915_gem_entervt_ioctl() :
> 
>     3659          BUG_ON(!list_empty(&dev_priv->mm.active_list));
>     3660          BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
>  -> 3661          BUG_ON(!list_empty(&dev_priv->mm.inactive_list));
>     3662          mutex_unlock(&dev->struct_mutex);

That BUG_ON there is silly and can simply be removed. The check is to
verify that no batches were submitted to the kernel whilst the UMS/GEM
client was suspended - to which the BUG_ONs are a crude approximation.
Furthermore, the checks are too late, since it means we attempted to
program the hardware whilst it was in an invalid state, the BUG_ONs are
the least of your concerns at that point.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
