Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1HWHXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:23:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:4114 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1HWHXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:23:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,267,1312182000"; 
   d="scan'208";a="44104247"
From: "Zou, Yi" <yi.zou@intel.com>
To: Julia Lawall <julia@diku.dk>, Jesper Juhl <jj@chaosbits.net>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "devel@open-fcoe.org" <devel@open-fcoe.org>
Date: Tue, 23 Aug 2011 00:23:15 -0700
Subject: RE: [Open-FCoE] [PATCH 2/4] drivers/scsi/fcoe/fcoe.c: add missing
	test
Thread-Topic: [Open-FCoE] [PATCH 2/4] drivers/scsi/fcoe/fcoe.c: add missing
	test
Thread-Index: Acxg2sdik/tQH7CMQp+ASckUs0OeigAij67w
Message-ID: <5A9BD224CEA58D4CB62235967D650C1609F5B04B@orsmsx509.amr.corp.intel.com>
References: <1314021636-11528-2-git-send-email-julia@diku.dk>
	<alpine.LNX.2.00.1108221632130.9774@swampdragon.chaosbits.net>
 <Pine.LNX.4.64.1108221648560.10948@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1108221648560.10948@ask.diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From nobody Mon Aug 22 15:57:42 CEST 2011
> From: Julia Lawall <julia@diku.dk>
> To: Robert Love <robert.w.love@intel.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,devel@open-
> fcoe.org,linux-scsi@vger.kernel.org,linux-kernel@vger.kernel.org
> Subject: [PATCH 2/4] drivers/scsi/fcoe/fcoe.c: add missing test
> 
> From: Julia Lawall <julia@diku.dk>
> 
> The initializations of both fcoe_nport_scsi_transport and
> fcoe_vport_scsi_transport can fail, so test both of them.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> identifier x,y,f!={PTR_ERR,ERR_PTR,ERR_CAST};
> statement S;
> @@
> 
> x = f(...);
> (
> if (\(x == NULL\|IS_ERR(x)\)) S
> |
> *if (\(y == NULL\|IS_ERR(y)\))
>  { ... when != x
>    return ...; }
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/scsi/fcoe/fcoe.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index ba710e3..9f2e2f4 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1093,11 +1093,20 @@ static int __init fcoe_if_init(void)
>  	/* attach to scsi transport */
>  	fcoe_nport_scsi_transport =
>  		fc_attach_transport(&fcoe_nport_fc_functions);
> +
> +	if (!fcoe_nport_scsi_transport) {
> +		printk(KERN_ERR
> +		       "fcoe_nport: Failed to attach to the FC transport\n");
> +		return -ENODEV;
> +	}
> +
>  	fcoe_vport_scsi_transport =
>  		fc_attach_transport(&fcoe_vport_fc_functions);
> 
> -	if (!fcoe_nport_scsi_transport) {
> -		printk(KERN_ERR "fcoe: Failed to attach to the FC
> transport\n");
> +	if (!fcoe_vport_scsi_transport) {
> +		printk(KERN_ERR
> +		       "fcoe_vport: Failed to attach to the FC transport\n");
> +		fc_release_transport(fcoe_nport_scsi_transport);
>  		return -ENODEV;
>  	}
> 

I understand we were using -ENODEV before, but -ENOMEM is preferred here 
as that's the only err from fc_attach_transport.

Thanks,
yi

