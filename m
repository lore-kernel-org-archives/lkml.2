Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2HXHJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:09:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:57032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab2HXHJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,302,1344236400"; 
   d="scan'208";a="213323766"
From: Jani Nikula <jani.nikula@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
In-Reply-To: <20120824121955.454ebce22142f238f89c9a9a@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20120824121955.454ebce22142f238f89c9a9a@canb.auug.org.au>
User-Agent: Notmuch/0.13.2+113~gc6f17a0 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 24 Aug 2012 10:13:07 +0300
Message-ID: <87ehmwbw58.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dave,
>
> Today's linux-next merge of the drm tree got a conflict in
> drivers/gpu/drm/i915/intel_modes.c between commit 4eab81366465
> ("drm/i915: extract connector update from intel_ddc_get_modes() for
> reuse") from Linus' tree and commit 451023dc32d4 ("drm: remove the
> raw_edid field from struct drm_display_info") from the drm tree.

Ugh, both from me, sorry about that. Wasn't sure when or in what order
they'd go in.

> I fixed it up (see below) and can carry the fix as necessary.

I'm not quite sure what the patch below is against, but just removing
the reference to raw_edid from a slightly different place is the way to
go. Like you seem to do, so:

Acked-by: Jani Nikula <jani.nikula@intel.com>

I can also provide a patch against drm-next if needed.

BR,
Jani.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/gpu/drm/i915/intel_modes.c
> index 29b7259,7a5238f..0000000
> --- a/drivers/gpu/drm/i915/intel_modes.c
> +++ b/drivers/gpu/drm/i915/intel_modes.c
> @@@ -33,25 -33,6 +33,24 @@@
>   #include "i915_drv.h"
>   
>   /**
>  + * intel_connector_update_modes - update connector from edid
>  + * @connector: DRM connector device to use
>  + * @edid: previously read EDID information
>  + */
>  +int intel_connector_update_modes(struct drm_connector *connector,
>  +				struct edid *edid)
>  +{
>  +	int ret;
>  +
>  +	drm_mode_connector_update_edid_property(connector, edid);
>  +	ret = drm_add_edid_modes(connector, edid);
>  +	drm_edid_to_eld(connector, edid);
> - 	connector->display_info.raw_edid = NULL;
>  +	kfree(edid);
>  +
>  +	return ret;
>  +}
>  +
>  +/**
>    * intel_ddc_get_modes - get modelist from monitor
>    * @connector: DRM connector device to use
>    * @adapter: i2c adapter
