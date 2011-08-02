Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1HBMAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 08:00:52 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:46782 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050Ab1HBMAq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 08:00:46 -0400
From: Alexey ORISHKO <alexey.orishko@stericsson.com>
To: Josh Boyer <jwboyer@redhat.com>, Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 2 Aug 2011 14:00:16 +0200
Subject: RE: cdc_ncm uses stack memory for DMA
Thread-Topic: cdc_ncm uses stack memory for DMA
Thread-Index: AcxRA5h0AqvYDgpgSIWqMqF7bsK+3QAA3UDQ
Message-ID: <2AC7D4AD8BA1C640B4C60C61C8E520153E3DEF668B@EXDCVYMBSTM006.EQ1STM.local>
References: <20110801195949.GB2096@zod.bos.redhat.com>
 <201108012226.16180.oliver@neukum.org>
 <20110802110138.GD2096@zod.bos.redhat.com>
In-Reply-To: <20110802110138.GD2096@zod.bos.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org]
> On Behalf Of Josh Boyer
> Sent: Tuesday, August 02, 2011 1:02 PM

> 
> -		err = cdc_ncm_do_request(ctx, &req, &max_datagram_size, 0, NULL,
> +		err = cdc_ncm_do_request(ctx, &req, max_datagram_size, 0, NULL,
>  									1000);
> +
>  		if (err) {
>  			pr_debug("GET_MAX_DATAGRAM_SIZE failed, use size=%u\n",
>  						CDC_NCM_MIN_DATAGRAM_SIZE);

You miss to free it here.

>  		} else {
> -			ctx->max_datagram_size = le16_to_cpu(max_datagram_size);
> +			ctx->max_datagram_size = le16_to_cpu(*max_datagram_size);
>  			/* Check Eth descriptor value */
>  			if (eth_max_sz < CDC_NCM_MAX_DATAGRAM_SIZE) {
>  				if (ctx->max_datagram_size > eth_max_sz)
> @@ -401,10 +423,12 @@ static u8 cdc_ncm_setup(struct cdc_ncm_ctx *ctx)
>  			req.wValue = 0;
>  			req.wIndex = cpu_to_le16(iface_no);
>  			req.wLength = 2;
> -			max_datagram_size = cpu_to_le16(ctx->max_datagram_size);
> +			*max_datagram_size = cpu_to_le16(ctx->max_datagram_size);
> 
> -			err = cdc_ncm_do_request(ctx, &req, &max_datagram_size,
> +			err = cdc_ncm_do_request(ctx, &req, max_datagram_size,
>  								0, NULL, 1000);
> +			kfree(max_datagram_size);
> +max_dgram_err:
>  			if (err)
>  				pr_debug("SET_MAX_DATAGRAM_SIZE failed\n");
>  		}
> --


You have mem leak in case of request failure. Will you resubmit it with this change?
I have HW available and can test this patch on Ubuntu 11.04. 

FYI: There is another bug in ncm driver and I'm about to post a patch for it.

Alexey
