Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab0KPOBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:01:25 -0500
Received: from mxout1.idt.com ([157.165.5.25]:48219 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474Ab0KPOBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:01:24 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/4][v2] rapidio, powerpc/85xx: Error interrupt handler for sRIO.
Date: Tue, 16 Nov 2010 06:00:42 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552015397DD@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1288777048-25105-1-git-send-email-b21989@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/4][v2] rapidio, powerpc/85xx: Error interrupt handler for sRIO.
Thread-Index: Act7PxazDA9lLqXhTJqKq+aY0TMBMQKVdNcA
References: <1288777048-25105-1-git-send-email-b21989@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Shaohui Xie" <b21989@freescale.com>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <kumar.gala@freescale.com>,
        "Roy Zang" <tie-fei.zang@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Shaohui Xie [mailto:b21989@freescale.com]
> 
> The sRIO controller reports errors to the core with one signal, it
uses
> register EPWISR to provides the core quick access to where the error
occurred.
> The EPWISR indicates that there are 4 interrupts sources, port1,
port2, message
> unit and port write receive, but the sRIO driver does not support
port2
> for now, still the handler takes care of port2.
> Currently the handler only clear error status without any recovery.
>

Do these dual-RIO controllers have only one port-write interrupt?
(sorry, user manuals are not available for download from FSL).   
 
> @@ -1082,14 +1142,24 @@ fsl_rio_port_write_handler(int irq, void
*dev_instance)
>  	ipwsr = in_be32(&priv->msg_regs->pwsr);
> 
>  	epwisr = in_be32(priv->regs_win + RIO_EPWISR);
> -	if (epwisr & 0x80000000) {
> +	if (epwisr & EPWISR_ERR_PINT1) {
>  		tmp = in_be32(priv->regs_win + RIO_LTLEDCSR);
>  		pr_info("RIO_LTLEDCSR = 0x%x\n", tmp);
> -		out_be32(priv->regs_win + RIO_LTLEDCSR, 0);
> +		port_error_handler(port, 0);
> +	}
> +
> +	if (epwisr & EPWISR_ERR_PINT2) {
> +		pr_info("RIO: port2 error\n");
> +		port_error_handler(port, 1);
> +	}
> +
> +	if (epwisr & EPWISR_ERR_MU) {
> +		pr_info("RIO: message unit error\n");
> +		msg_unit_error_handler(port);
>  	}
> 
> -	if (!(epwisr & 0x00000001))
> -		return IRQ_HANDLED;
> +	if (!(epwisr & EPWISR_ERR_PW))
> +		return IRQ_NONE;
> 
>  #ifdef DEBUG_PW
>  	pr_debug("PW Int->IPWMR: 0x%08x IPWSR: 0x%08x (", ipwmr, ipwsr);

This part is out of sync with mainline code tree (37-rc1). Probably it
should be updated to make it easier to apply your patch. Besides that,
works as expected on my RIO setup.

Regards,

Alex.


