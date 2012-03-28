Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab2C1AVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:21:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab2C1AVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:21:37 -0400
Date: Tue, 27 Mar 2012 20:21:27 -0400
From: Dave Jones <davej@redhat.com>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: WARNING: at drivers/gpu/drm/radeon/radeon_object.c:236
Message-ID: <20120328002127.GA8368@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <20120326213250.GA16328@redhat.com>
 <1332829303.2882.52.camel@pasglop>
 <1332836421.5395.338.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1332836421.5395.338.camel@thor.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 10:20:21AM +0200, Michel Dänzer wrote:
 > On Die, 2012-03-27 at 17:21 +1100, Benjamin Herrenschmidt wrote:
 > >         On Mon, 2012-03-26 at 17:32 -0400, Dave Jones wrote:
 > >         > Seeing this in Linus' tree as of v3.3-6972-ge22057c
 > >         
 > >         Same WARN_ON hit here on a G5 with rv350
 > 
 > Thanks for the report, guys. Does the patch below help?
 > 
 > 
 > diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
 > index f441d58..ad9d450 100644
 > --- a/drivers/gpu/drm/radeon/radeon_object.c
 > +++ b/drivers/gpu/drm/radeon/radeon_object.c
 > @@ -233,7 +233,17 @@ int radeon_bo_pin_restricted(struct radeon_bo *bo, u32 domain, u64 max_offset,
 >  		bo->pin_count++;
 >  		if (gpu_addr)
 >  			*gpu_addr = radeon_bo_gpu_offset(bo);
 > -		WARN_ON_ONCE(max_offset != 0);
 > +
 > +		if (max_offset != 0) {
 > +			u64 domain_start;
 > +
 > +			if (domain == RADEON_GEM_DOMAIN_VRAM)
 > +				domain_start = bo->rdev->mc.vram_start;
 > +			else
 > +				domain_start = bo->rdev->mc.gtt_start;
 > +			WARN_ON_ONCE((*gpu_addr - domain_start) > max_offset);
 > +		}
 > +
 >  		return 0;

Stops the warning, and there are no additional side-effects,
so looks all good here.

Tested-by: Dave Jones <davej@redhat.com>

thanks,

	Dave

