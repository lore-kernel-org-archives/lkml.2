Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab1I3JIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:08:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab1I3JIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:08:09 -0400
Date: Fri, 30 Sep 2011 11:05:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/2] at91: add Atmel ISI and ov2640 support on
 sam9m10/sam9g45 board.
In-Reply-To: <1316664661-11383-2-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1109300857580.1888@axis700.grange>
References: <1316664661-11383-1-git-send-email-josh.wu@atmel.com>
 <1316664661-11383-2-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:NkF6Edd5n8knBdVHy5WtWV/aIrioSOkaqZR7n9Eul2f
 ynd8Z3LoYEJWfOW2ixSgYyKM54eIN20klhRTiv6mOs1jgwHDwk
 AA9Zu3VD2vqBMiucpnnRv5rfh1+JTK84S6LfnROuqoF0pmiFHw
 z4YvM6JhK4RzmWImDOcXf6ktukiF88Dd47o176nuAPwcQekZ81
 MO/2LhEQ+DiFehSCnsc+242uqG3G/Qpb31PWKO3iJrtNh1qljn
 C8Y+VpPFGLBENb/YVNOKhgf/2kRKXLrDqT4kY3mz7CCAxfHip0
 fx/+KF5kiqif4RQhkAogLJQb/ENKbipt1QwDmK2U8+CdLgYxCF
 YtpgZq7efo+9XUTUDFfKzyvhzO5VVZTAX3+pkxgtNWZNjn5W5O
 2NZmj5EwPtfqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011, Josh Wu wrote:

> This patch
> 1. add ISI_MCK parent setting code when add ISI device.
> 2. add ov2640 support on board file.
> 3. define isi_mck clock in sam9g45 chip file.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Looking a bit more at this, I think, the arch maintainer might want to 
take a closer look at this:

1. Wouldn't it be a good idea to also bind the isi_clk via a clock 
connection ID and not via the clock's name?

2. pck1 is not really dedicated to ISI on sam9g45. It can also be used, 
e.g., as a generic clock output and ISI_PCK can be supplied by an external 
oscillator. Such set up seems perfectly valid to me and your patch would 
just unconditionally grab PCK1 and configure it to some frequency... I 
think, this shall be improved.

3.

> +static int __init isi_set_clk_parent(void)
> +{
> +	struct clk *pck1;
> +	struct clk *plla;
> +	int ret;
> +
> +	/* ISI_MCK is supplied by PCK1 - set parent for it. */
> +	pck1 = clk_get(NULL, "pck1");
> +	if (IS_ERR(pck1)) {
> +		printk(KERN_ERR "Failed to get PCK1\n");
> +		ret = PTR_ERR(pck1);
> +		goto err;
> +	}
> +
> +	plla = clk_get(NULL, "plla");
> +	if (IS_ERR(plla)) {
> +		printk(KERN_ERR "Failed to get PLLA\n");
> +		ret = PTR_ERR(plla);
> +		goto err_pck1;
> +	}
> +	ret = clk_set_parent(pck1, plla);
> +	clk_put(plla);

I think, here you also need a

	clk_put(pck1);

> +	if (ret != 0) {
> +		printk(KERN_ERR "Failed to set PCK1 parent\n");
> +		goto err_pck1;
> +	}
> +	return ret;
> +
> +err_pck1:
> +	clk_put(pck1);
> +err:
> +	return ret;
> +}


Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
