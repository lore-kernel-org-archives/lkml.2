Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab0JDTnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:43:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab0JDTnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:43:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Anisse Astier <anisse@astier.eu>
Subject: Re: [Bug #16891] Kernel panic while loading intel module during boot
Date: Mon, 4 Oct 2010 21:42:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Eric Anholt" <eric@anholt.net>,
        "Tim Gardner" <tim.gardner@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera> <N9RAiGGLCfN.A.v9C.bUPqMB@chimera> <20101004172509.0aded2ba@destiny.ordissimo>
In-Reply-To: <20101004172509.0aded2ba@destiny.ordissimo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010042142.29402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 04, 2010, Anisse Astier wrote:
> On Sun,  3 Oct 2010 23:53:02 +0200 (CEST), "Rafael J. Wysocki" <rjw@sisk.pl> wrote :
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16891
> > Subject		: Kernel panic while loading intel module during boot
> > Submitter	: Anisse Astier <anisse@astier.eu>
> > Date		: 2010-08-24 13:19 (41 days old)
> > 
> > 
> 
> This bug is still valid, and should be listed as a regression.
> I tried to upload on bugzilla a patch authored by Daniel Vetter that fixes
> the problem, but then bugzilla went into blackhole mode.
> 
> I'll provide this patch here in the meantime in case anyone is interested.

Thanks for the update and the patch.

Well, I wonder who's going to merge it?

Rafael


> ---
> From: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date: Fri, 1 Oct 2010 19:52:09 +0200
> Subject: [PATCH] intel-gtt: fix 2.6.35 regression
> 
> Port of commit "intel-gtt: fix gtt_total_entries detection" to 2.6.35.
> 
> Also adds PINEVIEW_IG to IS_G33 detection list
> 
> Signed-off-by: Anisse Astier <anisse@astier.eu>
> ---
>  drivers/char/agp/intel-agp.h |    1 +
>  drivers/char/agp/intel-gtt.c |   63 ++++++++++++++++++------------------------
>  2 files changed, 28 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
> index bc9a4ad..2fbbe63 100644
> --- a/drivers/char/agp/intel-agp.h
> +++ b/drivers/char/agp/intel-agp.h
> @@ -226,6 +226,7 @@
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q33_HB || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_PINEVIEW_M_HB || \
> +		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_PINEVIEW_IG || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_PINEVIEW_HB)
>  
>  #define IS_PINEVIEW (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_PINEVIEW_M_HB || \
> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
> index ed11c77..ea18f64 100644
> --- a/drivers/char/agp/intel-gtt.c
> +++ b/drivers/char/agp/intel-gtt.c
> @@ -501,7 +501,7 @@ static void intel_i830_init_gtt_entries(void)
>  
>  	pci_read_config_word(agp_bridge->dev, I830_GMCH_CTRL, &gmch_ctrl);
>  
> -	if (IS_I965) {
> +	if (IS_G33 || IS_I965) {
>  		u32 pgetbl_ctl;
>  		pgetbl_ctl = readl(intel_private.registers+I810_PGETBL_CTL);
>  
> @@ -534,22 +534,6 @@ static void intel_i830_init_gtt_entries(void)
>  			size = 512;
>  		}
>  		size += 4; /* add in BIOS popup space */
> -	} else if (IS_G33 && !IS_PINEVIEW) {
> -	/* G33's GTT size defined in gmch_ctrl */
> -		switch (gmch_ctrl & G33_PGETBL_SIZE_MASK) {
> -		case G33_PGETBL_SIZE_1M:
> -			size = 1024;
> -			break;
> -		case G33_PGETBL_SIZE_2M:
> -			size = 2048;
> -			break;
> -		default:
> -			dev_info(&agp_bridge->dev->dev,
> -				 "unknown page table size 0x%x, assuming 512KB\n",
> -				(gmch_ctrl & G33_PGETBL_SIZE_MASK));
> -			size = 512;
> -		}
> -		size += 4;
>  	} else if (IS_G4X || IS_PINEVIEW) {
>  		/* On 4 series hardware, GTT stolen is separate from graphics
>  		 * stolen, ignore it in stolen gtt entries counting.  However,
> @@ -1220,24 +1204,31 @@ static int intel_i915_get_gtt_size(void)
>  	int size;
>  
>  	if (IS_G33) {
> -		u16 gmch_ctrl;
> +		u32 pgetbl_ctl;
> +		pgetbl_ctl = readl(intel_private.registers+I810_PGETBL_CTL);
>  
> -		/* G33's GTT size defined in gmch_ctrl */
> -		pci_read_config_word(agp_bridge->dev, I830_GMCH_CTRL, &gmch_ctrl);
> -		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
> -		case I830_GMCH_GMS_STOLEN_512:
> +		switch (pgetbl_ctl & I965_PGETBL_SIZE_MASK) {
> +		case I965_PGETBL_SIZE_128KB:
> +			size = 128;
> +			break;
> +		case I965_PGETBL_SIZE_256KB:
> +			size = 256;
> +			break;
> +		case I965_PGETBL_SIZE_512KB:
>  			size = 512;
>  			break;
> -		case I830_GMCH_GMS_STOLEN_1024:
> +		case I965_PGETBL_SIZE_1MB:
>  			size = 1024;
>  			break;
> -		case I830_GMCH_GMS_STOLEN_8192:
> -			size = 8*1024;
> +		case I965_PGETBL_SIZE_2MB:
> +			size = 2048;
> +			break;
> +		case I965_PGETBL_SIZE_1_5MB:
> +			size = 1024 + 512;
>  			break;
>  		default:
> -			dev_info(&agp_bridge->dev->dev,
> -				 "unknown page table size 0x%x, assuming 512KB\n",
> -				(gmch_ctrl & I830_GMCH_GMS_MASK));
> +			dev_info(&intel_private.pcidev->dev,
> +				 "unknown page table size, assuming 512KB\n");
>  			size = 512;
>  		}
>  	} else {
> @@ -1269,14 +1260,6 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
>  	pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
>  	pci_read_config_dword(intel_private.pcidev, I915_PTEADDR, &temp2);
>  
> -	gtt_map_size = intel_i915_get_gtt_size();
> -
> -	intel_private.gtt = ioremap(temp2, gtt_map_size);
> -	if (!intel_private.gtt)
> -		return -ENOMEM;
> -
> -	intel_private.gtt_total_size = gtt_map_size / 4;
> -
>  	temp &= 0xfff80000;
>  
>  	intel_private.registers = ioremap(temp, 128 * 4096);
> @@ -1285,6 +1268,14 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
>  		return -ENOMEM;
>  	}
>  
> +	gtt_map_size = intel_i915_get_gtt_size();
> +
> +	intel_private.gtt = ioremap(temp2, gtt_map_size);
> +	if (!intel_private.gtt)
> +		return -ENOMEM;
> +
> +	intel_private.gtt_total_size = gtt_map_size / 4;
> +
>  	temp = readl(intel_private.registers+I810_PGETBL_CTL) & 0xfffff000;
>  	global_cache_flush();	/* FIXME: ? */
>  
> 

