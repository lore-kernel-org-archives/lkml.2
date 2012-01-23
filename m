Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2AWPID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:08:03 -0500
Received: from tservice.ru ([195.178.208.66]:43682 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752899Ab2AWPIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:08:01 -0500
Date: Mon, 23 Jan 2012 18:07:53 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, neilb@suse.de
Subject: Re: [PATCH] W1: OMAP HDQ1W: use 32-bit register accesses
Message-ID: <20120123150753.GA21395@ioremap.net>
References: <alpine.DEB.2.00.1201221319270.26641@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201221319270.26641@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul

Patchset looks good, feel free to add my ack

On Sun, Jan 22, 2012 at 01:26:23PM -0700, Paul Walmsley (paul@pwsan.com) wrote:
> 
> HDQ/1-wire registers are 32 bits long, even if the register contents
> fit into 8 bits, so accesses must be 32-bit aligned.  Evidently the
> OMAP2/3 interconnects allowed the driver to get away with 8 bit accesses,
> but the OMAP4 puts a stop to that:
> 
> [    1.488800] Driver for 1-wire Dallas network protocol.
> [    1.495025] Bad mode in data abort handler detected
> [    1.500122] Internal error: Oops - bad mode: 0 [#1] SMP
> [    1.505615] Modules linked in:
> [    1.508819] CPU: 0    Not tainted  (3.3.0-rc1-00008-g45030e9 #992)
> [    1.515289] PC is at 0xffff0018
> [    1.518615] LR is at omap_hdq_probe+0xd4/0x2cc
> 
> The OMAP4430 ES2 Rev X TRM does warn about this restriction in section 
> 23.2.6.2 "HDQ/1-Wire Registers".
> 
> Fixes the crash on OMAP4430 ES2 Pandaboard.  Tested also on OMAP34xx and 
> OMAP2420; it seems to work fine on those chips, although due to the lack 
> of boards with HDQ/1-wire devices here, a more indepth test was not 
> possible.
> 
> ---
> Intended for the v3.4 merge window.
> 
>  drivers/w1/masters/omap_hdq.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
> index 63e3eda..291897c 100644
> --- a/drivers/w1/masters/omap_hdq.c
> +++ b/drivers/w1/masters/omap_hdq.c
> @@ -100,20 +100,20 @@ static struct w1_bus_master omap_w1_master = {
>  /* HDQ register I/O routines */
>  static inline u8 hdq_reg_in(struct hdq_data *hdq_data, u32 offset)
>  {
> -	return __raw_readb(hdq_data->hdq_base + offset);
> +	return __raw_readl(hdq_data->hdq_base + offset);
>  }
>  
>  static inline void hdq_reg_out(struct hdq_data *hdq_data, u32 offset, u8 val)
>  {
> -	__raw_writeb(val, hdq_data->hdq_base + offset);
> +	__raw_writel(val, hdq_data->hdq_base + offset);
>  }
>  
>  static inline u8 hdq_reg_merge(struct hdq_data *hdq_data, u32 offset,
>  			u8 val, u8 mask)
>  {
> -	u8 new_val = (__raw_readb(hdq_data->hdq_base + offset) & ~mask)
> +	u8 new_val = (__raw_readl(hdq_data->hdq_base + offset) & ~mask)
>  			| (val & mask);
> -	__raw_writeb(new_val, hdq_data->hdq_base + offset);
> +	__raw_writel(new_val, hdq_data->hdq_base + offset);
>  
>  	return new_val;
>  }
> -- 
> 1.7.8.3

-- 
	Evgeniy Polyakov
