Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1BXPqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:46:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53236 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab1BXPqQ convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 24 Feb 2011 10:46:16 -0500
Date: Thu, 24 Feb 2011 10:45:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] radeon: DMA unmap dummy page during unload/unbind.
Message-ID: <20110224154503.GA6893@dumpdata.com>
References: <1298494135-16751-1-git-send-email-konrad.wilk@oracle.com>
 <1298494135-16751-2-git-send-email-konrad.wilk@oracle.com>
 <AANLkTi==tDG6wMVNTSYjucZH+g-G3P6OiqSmHXWm8LP9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTi==tDG6wMVNTSYjucZH+g-G3P6OiqSmHXWm8LP9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D667D37.0105:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 03:25:43AM -0500, Alex Deucher wrote:
> On Wed, Feb 23, 2011 at 3:48 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > git commit 82568565683b4991964a5fc89a9ca0c7122818e8 adds a dummy page
> > so that if something goes wrong it will at least fetch/write data
> > _only_ to this location.
> >
> > The radeon_gart_init sets it up.. but there is no corresponding
> > free-ing of this dummy page. There is one invocation to free-ing
> > the dummy page in r600.c but nothing in the radeon_gart_fini path.
> >
> > This patch adds in the unloading/unbind path the free-ing of said
> > dummy page.
> 
> This patch looks good, but we might as go one step further and just
> remove the dummy page stuff from r600.c, rv770.c and evergreen.c and
> just consolidate it in gart_init() and gart_fini().  See the attached
> patch.

Excellent. Thank you!

> 
> Alex
> 
> >
> > Without this patch and if we have CONFIG_DMA_API_DEBUG=y set we
> > get this:
> >
> > [   22.113420] drm: unregistered panic notifier
> > [   22.126500] [drm] radeon: finishing device.
> > [   22.130868] [drm] radeon: cp finalized
> > [   22.135384] [TTM] Finalizing pool allocator.
> > [   22.139669] [TTM] Zone  kernel: Used memory at exit: 0 kiB.
> > [   22.145229] [drm] radeon: ttm finalized
> > [   22.149055] vga_switcheroo: disabled
> > [   22.153393] ------------[ cut here ]------------
> > [   22.158021] WARNING: at /home/konrad/ssd/linux/lib/dma-debug.c:689 dma_debug_device_change+0x12e/0x161()
> > [   22.167475] Hardware name: PowerEdge T105
> > [   22.171562] pci 0000:01:08.0: DMA-API: device driver has pending DMA allocations while released from device [count=1]
> >
> > With this patch we don't see this anymore.
> >
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/gpu/drm/radeon/radeon_gart.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
> > index 6501611..dc04c7b 100644
> > --- a/drivers/gpu/drm/radeon/radeon_gart.c
> > +++ b/drivers/gpu/drm/radeon/radeon_gart.c
> > @@ -269,4 +269,6 @@ void radeon_gart_fini(struct radeon_device *rdev)
> >        kfree(rdev->gart.pages_addr);
> >        rdev->gart.pages = NULL;
> >        rdev->gart.pages_addr = NULL;
> > +
> > +       radeon_dummy_page_fini(rdev);
> >  }
> > --
> > 1.7.1
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/dri-devel
> >

> From d22bba30a66ba95cabeed7a71c982dfa96521384 Mon Sep 17 00:00:00 2001
> From: Alex Deucher <alexdeucher@gmail.com>
> Date: Thu, 24 Feb 2011 03:16:21 -0500
> Subject: [PATCH] drm/radeon/kms: clean up gart dummy page handling
> 
> As per Konrad's original patch, the dummy page used
> by the gart code and allocated in radeon_gart_init()
> was not freed properly in radeon_gart_fini().
> 
> At the same time r6xx and newer allocated and freed the
> dummy page on their own.  So to do Konrad's patch one
> better, just remove the allocation and freeing of the
> dummy page in the r6xx, 7xx, evergreen, and ni code and
> allocate and free in the gart_init/fini() functions for
> all asics.
> 
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jerome Glisse <jglisse@redhat.com>
> Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
> ---
>  drivers/gpu/drm/radeon/evergreen.c   |    4 ----
>  drivers/gpu/drm/radeon/r600.c        |    4 ----
>  drivers/gpu/drm/radeon/radeon_gart.c |    2 ++
>  drivers/gpu/drm/radeon/rv770.c       |    4 ----
>  4 files changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
> index 789441e..9ecb2b6 100644
> --- a/drivers/gpu/drm/radeon/evergreen.c
> +++ b/drivers/gpu/drm/radeon/evergreen.c
> @@ -3048,9 +3048,6 @@ int evergreen_init(struct radeon_device *rdev)
>  {
>  	int r;
>  
> -	r = radeon_dummy_page_init(rdev);
> -	if (r)
> -		return r;
>  	/* This don't do much */
>  	r = radeon_gem_init(rdev);
>  	if (r)
> @@ -3162,7 +3159,6 @@ void evergreen_fini(struct radeon_device *rdev)
>  	radeon_atombios_fini(rdev);
>  	kfree(rdev->bios);
>  	rdev->bios = NULL;
> -	radeon_dummy_page_fini(rdev);
>  }
>  
>  static void evergreen_pcie_gen2_enable(struct radeon_device *rdev)
> diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
> index 1252198..88eaffc 100644
> --- a/drivers/gpu/drm/radeon/r600.c
> +++ b/drivers/gpu/drm/radeon/r600.c
> @@ -2510,9 +2510,6 @@ int r600_init(struct radeon_device *rdev)
>  {
>  	int r;
>  
> -	r = radeon_dummy_page_init(rdev);
> -	if (r)
> -		return r;
>  	if (r600_debugfs_mc_info_init(rdev)) {
>  		DRM_ERROR("Failed to register debugfs file for mc !\n");
>  	}
> @@ -2626,7 +2623,6 @@ void r600_fini(struct radeon_device *rdev)
>  	radeon_atombios_fini(rdev);
>  	kfree(rdev->bios);
>  	rdev->bios = NULL;
> -	radeon_dummy_page_fini(rdev);
>  }
>  
>  
> diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
> index 6501611..dc04c7b 100644
> --- a/drivers/gpu/drm/radeon/radeon_gart.c
> +++ b/drivers/gpu/drm/radeon/radeon_gart.c
> @@ -269,4 +269,6 @@ void radeon_gart_fini(struct radeon_device *rdev)
>  	kfree(rdev->gart.pages_addr);
>  	rdev->gart.pages = NULL;
>  	rdev->gart.pages_addr = NULL;
> +
> +	radeon_dummy_page_fini(rdev);
>  }
> diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
> index d8ba676..6a312e6 100644
> --- a/drivers/gpu/drm/radeon/rv770.c
> +++ b/drivers/gpu/drm/radeon/rv770.c
> @@ -1256,9 +1256,6 @@ int rv770_init(struct radeon_device *rdev)
>  {
>  	int r;
>  
> -	r = radeon_dummy_page_init(rdev);
> -	if (r)
> -		return r;
>  	/* This don't do much */
>  	r = radeon_gem_init(rdev);
>  	if (r)
> @@ -1373,7 +1370,6 @@ void rv770_fini(struct radeon_device *rdev)
>  	radeon_atombios_fini(rdev);
>  	kfree(rdev->bios);
>  	rdev->bios = NULL;
> -	radeon_dummy_page_fini(rdev);
>  }
>  
>  static void rv770_pcie_gen2_enable(struct radeon_device *rdev)
> -- 
> 1.7.1.1
> 

