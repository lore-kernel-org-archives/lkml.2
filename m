Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0HXNiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:38:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:58763 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0HXNiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:38:03 -0400
Message-Id: <89k77n$oolmh9@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,263,1280732400"; 
   d="scan'208";a="831183401"
Date: Tue, 24 Aug 2010 14:37:58 +0100
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [now bisected] i915: 2.6.36-rc2 hoses my Intel display
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Eric Anholt <eric@anholt.net>
References: <20100823110145.08eb72fd@bike.lwn.net> <20100823151708.6b242599@bike.lwn.net> <8u3s8d$jcc0rr@orsmga001.jf.intel.com> <20100823173225.2bda6f78@bike.lwn.net> <8u3s94$gak083@orsmga002.jf.intel.com> <20100823174641.4ba58bfe@bike.lwn.net> <8u3s94$gak45q@orsmga002.jf.intel.com> <20100824071626.1be75877@bike.lwn.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100824071626.1be75877@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 07:16:26 -0600, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 24 Aug 2010 00:55:54 +0100
> Chris Wilson <chris@chris-wilson.co.uk> wrote:
> 
> > In threes. Hmm, one for primary, cursor and self-refresh. drm.debug=0xe
> > would be interesting to see what the pixel clock is.
> > 
> > Can you grab one before the bad commit and one after? If there is a change
> > that may help pin-point the mistake. Or indicate further problems...
> 
> OK, three files attached; drm.good is from 2.6.35, drm.bad is from
> 2.6.36-rc2.  I also stripped the times and did a diff, in case that's
> useful.

[snip]

> -[drm:intel_calculate_wm], FIFO entries required for mode: 48
> -[drm:intel_calculate_wm], FIFO watermark level: -22
> +[drm:intel_calculate_wm], FIFO entries required for mode: 49
> +[drm:intel_calculate_wm], FIFO watermark level: -23
> +*ERROR* Insufficient FIFO for plane, expect flickering: entries required = 51, available = 28.
>  [drm:intel_calculate_wm], FIFO entries required for mode: 0
>  [drm:intel_calculate_wm], FIFO watermark level: 29
>  [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 29
> -[drm:i9xx_update_wm], self-refresh entries: 60
> -[drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 29, C: 2, SR 35
> -[drm:i915_get_vblank_counter], trying to get vblank count for disabled pipe 1
> +[drm:i9xx_update_wm], self-refresh entries: 120
> +[drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 29, C: 2, SR 1

I'm going to focus on this since this could account for the on-screen
corruption. Here we suddenly double the computed minimal FIFO size for
self-refresh and due to a separate bug program a minimal low watermark.

That should addressed with
http://cgit.freedesktop.org/~ickle/linux-2.6/commit/?h=drm-testing&id=30c127264ef9729bcef1d9901718f9a8a47be6a4
however that patch isn't quite ready yet since Jesse pointed out that
some chipsets do indeed want a high-watermark instead of the low-watermark
used, at least, for gen3+.

The question though is why that bad commit would cause a doubling of the
SR. Thanks for the diff, I now know that I need to look more closely at
the mode-fixup for SDVO.

-- 
Chris Wilson, Intel Open Source Technology Centre
