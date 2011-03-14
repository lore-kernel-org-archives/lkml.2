Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1CNRgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:36:44 -0400
Received: from 4.26.mail-out.ovh.net ([46.105.53.201]:39152 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754581Ab1CNRgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:36:42 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Mar 2011 13:36:42 EDT
Date: Mon, 14 Mar 2011 18:24:14 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jamie Iles <jamie@jamieiles.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: Re: [PATCH] macb: detect IP version to determin if we are on at91
 or avr32
Message-ID: <20110314172414.GB14548@game.jcrosoft.org>
References: <1299863585-17263-1-git-send-email-plagnioj@jcrosoft.com>
 <20110314101512.GA26085@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314101512.GA26085@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5806828770345724851
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:15 Mon 14 Mar     , Russell King - ARM Linux wrote:
> On Fri, Mar 11, 2011 at 06:13:05PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > +	if (macb_is_at91(bp)) {
> > +		bp->pclk = clk_get(&pdev->dev, "macb_clk");
> > +		if (IS_ERR(bp->pclk)) {
> > +			dev_err(&pdev->dev, "failed to get macb_clk\n");
> > +			goto err_out_free_dev;
> > +		}
> > +		clk_enable(bp->pclk);
> > +	} else {
> > +		bp->pclk = clk_get(&pdev->dev, "pclk");
> > +		if (IS_ERR(bp->pclk)) {
> > +			dev_err(&pdev->dev, "failed to get pclk\n");
> > +			goto err_out_free_dev;
> > +		}
> > +		bp->hclk = clk_get(&pdev->dev, "hclk");
> > +		if (IS_ERR(bp->hclk)) {
> > +			dev_err(&pdev->dev, "failed to get hclk\n");
> > +			goto err_out_put_pclk;
> > +		}
> > +
> > +		clk_enable(bp->pclk);
> > +		clk_enable(bp->hclk);
> > +	}
> 
> This is the same kind of sillyness that started getting OMAP into problems
> with the clk API.  Just do this instead:
> 
> 	bp->pclk = clk_get(&pdev->dev, "pclk");
> 	if (IS_ERR(bp->pclk)) {
> 		dev_err(&pdev->dev, "failed to get pclk\n");
> 		goto err_out_free_dev;
> 	}
> 	bp->hclk = clk_get(&pdev->dev, "hclk");
> 	if (IS_ERR(bp->hclk)) {
> 		dev_err(&pdev->dev, "failed to get hclk\n");
> 		goto err_out_put_pclk;
> 	}
> 
> 	clk_enable(bp->pclk);
> 	clk_enable(bp->hclk);
> 
> And then require _all_ platforms using this driver to provide a pclk and
> a hclk for this device, whether they exist in the SoC or not.  Where they
> don't, provide dummy clocks for it.
> 
> This probably means you end up with _less_ bloat overall because you're
> not having to build the above code.  You've less lines of source code to
> maintain.  You have a simplified dirver with consistent requirements
> across all platforms.  You don't need to read the version register, and
> you don't need macb_is_at91() and macb_is_avr32().
no we do need it for some of the register IP implementation related to the MII
at least
> 
> With clkdev it's _cheap_ to provide these dummy clocks once you have one
> dummy clock already in place.
I known and already agree about the clock, Jamie Patches will take care about it

this patch remove the ifdef ARCH and now detect the IP revision to determin
the IP specific implementation

Best Regards,
J.
