Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2DTSl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:41:56 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:14879 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2DTSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:41:54 -0400
Subject: Re: [PATCH 03/17] hpsa: enable bus master bit after
 pci_enable_device
From: Khalid Aziz <khalid.aziz@hp.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.gates@hp.com,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
In-Reply-To: <20120420150629.10596.51923.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
	 <20120420150629.10596.51923.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 12:41:50 -0600
Message-ID: <1334947310.10129.124.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 10:06 -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> pci_disable_device() disables the bus master bit and pci_enable_device does
> not re-enable it.  It needs to be enabled.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 5119ce6..363619d 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3917,6 +3917,7 @@ static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
>  static int __devinit hpsa_pci_init(struct ctlr_info *h)
>  {
>  	int prod_index, err;
> +	u16 command_register;
>  
>  	prod_index = hpsa_lookup_board_id(h->pdev, &h->board_id);
>  	if (prod_index < 0)
> @@ -3933,6 +3934,11 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
>  		return err;
>  	}
>  
> +	/* Enable bus mastering (pci_disable_device may disable this) */
> +	pci_read_config_word(h->pdev, PCI_COMMAND, &command_register);
> +	command_register |= PCI_COMMAND_MASTER;
> +	pci_write_config_word(h->pdev, PCI_COMMAND, command_register);
> +
>  	err = pci_request_regions(h->pdev, HPSA);
>  	if (err) {
>  		dev_err(&h->pdev->dev,

Wouldn't it be better to use pci_set_master(h->pdev) to enable bus
mastering?

-- 
====================================================================
Khalid Aziz                                         Unix Systems Lab
(970)898-9214                                        Hewlett-Packard
khalid.aziz@hp.com                                  Fort Collins, CO

