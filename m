Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1H2NwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:52:04 -0400
Received: from mxout1.idt.com ([157.165.5.25]:32860 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab1H2Nv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:51:57 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] rapidio: potential null deref in rio_setup_device()
Date: Mon, 29 Aug 2011 06:51:53 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520210D5A4@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20110827100045.GL3775@shale.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] rapidio: potential null deref in rio_setup_device()
Thread-Index: AcxkoInG+ihilDkpQWSmhVCNQTJwfwBsOAww
References: <20110827100045.GL3775@shale.localdomain>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Dan Carpenter" <error27@gmail.com>,
        "Matt Porter" <mporter@kernel.crashing.org>
Cc: "open list" <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:

> The "goto cleanup" path can dereference "rswitch" which is NULL here.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> This is sort of embarrassing, I've patched this function before but
> missed this.  Hopefully it's right now.
> 
> diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
> index 0914f49..882cef9 100644
> --- a/drivers/rapidio/rio-scan.c
> +++ b/drivers/rapidio/rio-scan.c
> @@ -432,7 +432,7 @@ static struct rio_dev __devinit
> *rio_setup_device(struct rio_net *net,
>  		/* Assign component tag to device */
>  		if (next_comptag >= 0x10000) {
>  			pr_err("RIO: Component Tag Counter Overflow\n");
> -			goto cleanup;
> +			goto out_rdev;
>  		}
>  		rio_mport_write_config_32(port, destid, hopcount,
>  					  RIO_COMPONENT_TAG_CSR,
next_comptag);
> @@ -518,7 +518,7 @@ static struct rio_dev __devinit
> *rio_setup_device(struct rio_net *net,
>  cleanup:
>  	if (rio_is_switch(rdev))
>  		kfree(rswitch->route_table);

Because rswitch is set not-NULL only for switch devices the check below
can make things simpler: 
  cleanup:
	if (rswitch)
  		kfree(rswitch->route_table);

> -
> +out_rdev:
>  	kfree(rdev);
>  	return NULL;
>  }
