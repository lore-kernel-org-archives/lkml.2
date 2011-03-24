Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab1CXA3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:29:47 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4090 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406Ab1CXA3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:29:46 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: [PATCH] bnx2fc: setup em for npiv port
From: "Bhanu Gollapudi" <bprakash@broadcom.com>
To: James.Bottomley@suse.de
cc: "devel@open-fcoe.org" <devel@open-fcoe.org>,
        "Vasu Dev" <vasu.dev@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110315231329.13280.54456.stgit@vifc.jf.intel.com>
References: <20110315231329.13280.54456.stgit@vifc.jf.intel.com>
Date: Wed, 23 Mar 2011 17:29:35 -0700
Message-ID: <1300926575.6240.4.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 61944E873CK5272854-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 16:13 -0700, Vasu Dev wrote: 
> Use fc_exch_mgr_list_clone to setup em for npiv port.
> 
> Also remove redundant vport and lport initializations.
> 
> Signed-off-by: Vasu Dev <vasu.dev@intel.com>
> ---

James, 

We have tested this, and would like to ack it.

Thanks,
Bhanu

> 
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   29 +++++++++++++++--------------
>  1 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index e476e87..71842a7 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -1296,20 +1296,17 @@ setup_err:
>  static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
>  				  struct device *parent, int npiv)
>  {
> -	struct fc_lport		*lport = NULL;
> +	struct fc_lport		*lport, *n_port;
>  	struct fcoe_port	*port;
>  	struct Scsi_Host	*shost;
>  	struct fc_vport		*vport = dev_to_vport(parent);
>  	int			rc = 0;
>  
>  	/* Allocate Scsi_Host structure */
> -	if (!npiv) {
> -		lport = libfc_host_alloc(&bnx2fc_shost_template,
> -					  sizeof(struct fcoe_port));
> -	} else {
> -		lport = libfc_vport_create(vport,
> -					   sizeof(struct fcoe_port));
> -	}
> +	if (!npiv)
> +		lport = libfc_host_alloc(&bnx2fc_shost_template, sizeof(*port));
> +	else
> +		lport = libfc_vport_create(vport, sizeof(*port));
>  
>  	if (!lport) {
>  		printk(KERN_ERR PFX "could not allocate scsi host structure\n");
> @@ -1327,7 +1324,6 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
>  		goto lp_config_err;
>  
>  	if (npiv) {
> -		vport = dev_to_vport(parent);
>  		printk(KERN_ERR PFX "Setting vport names, 0x%llX 0x%llX\n",
>  			vport->node_name, vport->port_name);
>  		fc_set_wwnn(lport, vport->node_name);
> @@ -1356,12 +1352,17 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
>  	fc_host_port_type(lport->host) = FC_PORTTYPE_UNKNOWN;
>  
>  	/* Allocate exchange manager */
> -	if (!npiv) {
> +	if (!npiv)
>  		rc = bnx2fc_em_config(lport);
> -		if (rc) {
> -			printk(KERN_ERR PFX "Error on bnx2fc_em_config\n");
> -			goto shost_err;
> -		}
> +	else {
> +		shost = vport_to_shost(vport);
> +		n_port = shost_priv(shost);
> +		rc = fc_exch_mgr_list_clone(n_port, lport);
> +	}
> +
> +	if (rc) {
> +		printk(KERN_ERR PFX "Error on bnx2fc_em_config\n");
> +		goto shost_err;
>  	}
>  
>  	bnx2fc_interface_get(hba);
> 
> 



