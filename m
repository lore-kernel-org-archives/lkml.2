Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab0KGQ6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 11:58:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51759 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab0KGQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 11:58:33 -0500
Date: Sun, 7 Nov 2010 16:57:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexey Charkov <alchark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v2] ARM: Add basic architecture support for
	VIA/WonderMedia 85xx SoC's
Message-ID: <20101107165745.GB1759@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289147348-31969-1-git-send-email-alchark@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 07:28:52PM +0300, Alexey Charkov wrote:
> +static inline void preallocate_fb(struct vt8500fb_platform_data *p,
> +				  unsigned long align) {
> +	p->video_mem_len = (p->xres_virtual * p->yres_virtual * 4) >>
> +			(p->bpp > 16 ? 0 : (p->bpp > 8 ? 1 :
> +					(8 / p->bpp) + 1));
> +	p->video_mem_phys = (unsigned long)memblock_alloc(p->video_mem_len,
> +							  align);
> +	p->video_mem_virt = phys_to_virt(p->video_mem_phys);
> +}
...
> +void __init vt8500_map_io(void)
> +{
> +	wmt_current_regs = &wmt_regmaps[VT8500_INDEX];
> +	wmt_current_irqs = &wmt_irqs[VT8500_INDEX];
> +	set_data();
> +#ifdef CONFIG_FB_VT8500
> +	panels[current_panel_idx].bpp = 16; /* Always use RGB565 */
> +	preallocate_fb(&panels[current_panel_idx], SZ_4M);
> +	vt8500_device_lcdc.dev.platform_data = &panels[current_panel_idx];
> +#endif
> +	iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
> +}
...
> +void __init wm8505_map_io(void)
> +{
> +	wmt_current_regs = &wmt_regmaps[WM8505_INDEX];
> +	wmt_current_irqs = &wmt_irqs[WM8505_INDEX];
> +	set_data();
> +#ifdef CONFIG_FB_WM8505
> +	panels[current_panel_idx].bpp = 32; /* Always use RGB888 */
> +	preallocate_fb(&panels[current_panel_idx], 32);
> +	vt8500_device_wm8505_fb.dev.platform_data = &panels[current_panel_idx];
> +#endif
> +	iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
> +}

I'd much prefer that the allocation of memblock memory is done via the
'reserve' machine callback, rather than trying to group it into the IO
mapping callback.  Is there a reason it can't be?
