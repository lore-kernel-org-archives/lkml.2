Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0HXQfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:35:11 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:48483 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754941Ab0HXQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:35:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Xtduz+T57rG4jXF8GC1TJ/z3o8PqwZhj/JKs/5WNAmKBohgmFfIG/LPnEor1sXH0TXUoc3Wh9OsY+ikNdRAqOsPecc9CZmuSKvHaOuqBKVxJ2IIcfznD1Ll0ZD9RzomO;
Date: Tue, 24 Aug 2010 09:35:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: intel-gfx@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/2] drm/i915: Revert extra intel_wait_for_vblank to
 prevent stalls.
Message-ID: <20100824093503.471bcf4e@virtuousgeek.org>
In-Reply-To: <20100824155616.GC10473@sucs.org>
References: <20100823233551.GA31920@sucs.org>
	<89kc63$hrmse5@fmsmga002.fm.intel.com>
	<20100824075741.GA11000@sucs.org>
	<8u3s8d$jcg467@orsmga001.jf.intel.com>
	<20100824084902.GA27569@sucs.org>
	<89kc63$hrqoho@fmsmga002.fm.intel.com>
	<20100824095535.GA14020@sucs.org>
	<20100824155359.GB10473@sucs.org>
	<20100824155616.GC10473@sucs.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 16:56:16 +0100
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> With the extra intel_wait_for_vblank added in commit
> 9d0498a2bf7455159b317f19531a3e5db2ecc9c4 periodic stalls were being
> triggered (which were detected by i915_hangcheck_elapsed). Partially
> revert this change for now.
> 
> Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 116d938..534f1fa 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -2379,8 +2379,10 @@ static void i9xx_crtc_dpms(struct drm_crtc *crtc, int mode)
>  			I915_READ(dspbase_reg);
>  		}
>  
> -		/* Wait for vblank for the disable to take effect */
> -		intel_wait_for_vblank_off(dev, pipe);
> +		if (!IS_I9XX(dev)) {
> +			/* Wait for vblank for the disable to take effect */
> +			intel_wait_for_vblank_off(dev, pipe);
> +		}
>  
>  		/* Don't disable pipe A or pipe A PLLs if needed */
>  		if (pipeconf_reg == PIPEACONF &&

Hm why would we be triggering the hangcheck timer due to this code?
I'd rather figure that out and fix it before covering it up like this.

Wait for vblank off will spin until the display line reg stops
incrementing, so it's important that we flush any previous writes to
shut off the pipe before waiting.  So adding a POSTING_READ() above it
might help?  But that still doesn't explain why it would cause the
hangcheck timer to notice a hang...

-- 
Jesse Barnes, Intel Open Source Technology Center
