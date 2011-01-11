Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1AKQkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:40:37 -0500
Received: from mail-ww0-f66.google.com ([74.125.82.66]:42616 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab1AKQkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:40:35 -0500
Date: Tue, 11 Jan 2011 16:40:24 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 07/16] staging: tidspbridge: don't treat NULL clk as an
 error
Message-ID: <20110111164024.GA3181@pulham.picochip.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
 <1294749833-32019-8-git-send-email-jamie@jamieiles.com>
 <alpine.DEB.1.10.1101111739400.18906@esdhcp041196.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1101111739400.18906@esdhcp041196.research.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

On Tue, Jan 11, 2011 at 05:50:06PM +0200, Aaro Koskinen wrote:
> On Tue, 11 Jan 2011, Jamie Iles wrote:
[...]
> >#include <dspbridge/dbdefs.h>
> >@@ -60,15 +61,15 @@ int dsp_wdt_init(void)
> >
> >	dsp_wdt.fclk = clk_get(NULL, "wdt3_fck");
> >
> >-	if (dsp_wdt.fclk) {
> >+	if (!IS_ERR(dsp_wdt.fclk)) {
> >		dsp_wdt.iclk = clk_get(NULL, "wdt3_ick");
> >-		if (!dsp_wdt.iclk) {
> >+		if (IS_ERR(dsp_wdt.iclk)) {
> >			clk_put(dsp_wdt.fclk);
> >			dsp_wdt.fclk = NULL;
> >-			ret = -EFAULT;
> >+			ret = PTR_ERR(dsp_wdt.iclk);
> >		}
> >	} else
> >-		ret = -EFAULT;
> >+		ret = PTR_ERR(dsp_wdt.fclk);
> 
> There are also other places in this driver where dsp_wdt.[if]clk is
> checked against NULL, so this change alone is not sufficient.

Yes, you're quite right.

On closer inspection it looks to me like the error handling in 
drivers/staging/tidspbridge/io_sm.c::bridge_io_create needs to be fixed 
up first otherwise we can end up calling dsp_wdt_exit() through 
bridge_io_destroy() without the contents of dsp_wdt being coherently 
initialized (there are also failure paths where the wdt irq and tasklet 
can be freed/killed without first being setup).

Jamie
