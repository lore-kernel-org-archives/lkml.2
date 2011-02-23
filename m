Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1BWI0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:26:44 -0500
Received: from ist.d-labs.de ([213.239.218.44]:41194 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab1BWI0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:26:43 -0500
Date: Wed, 23 Feb 2011 09:26:19 +0100
From: Florian Mickler <florian@mickler.org>
To: akpm@linux-foundation.org
Cc: Florian Mickler <florian@mickler.org>, airlied@linux.ie,
        randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64-agp: fix crash at second module load
Message-ID: <20110223092619.4dfa7480@schatten.dmk.lab>
In-Reply-To: <1297117771-12392-1-git-send-email-florian@mickler.org>
References: <1297117771-12392-1-git-send-email-florian@mickler.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
I sent this to Dave Airlie because that is what MAINTAINERS says, but
that is probably the wrong receipient? 

Regards,
Flo

On Mon,  7 Feb 2011 23:29:31 +0100
Florian Mickler <florian@mickler.org> wrote:

> The module forgot to sometimes unregister some resources.
> 
> This fixes Bug #22882.
> 
> [Patch updated to 2.6.38-rc3 by Randy Dunlap.]
> Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
>  drivers/char/agp/amd64-agp.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
> index 9252e85..780498d 100644
> --- a/drivers/char/agp/amd64-agp.c
> +++ b/drivers/char/agp/amd64-agp.c
> @@ -773,18 +773,23 @@ int __init agp_amd64_init(void)
>  #else
>  			printk(KERN_INFO PFX "You can boot with agp=try_unsupported\n");
>  #endif
> +			pci_unregister_driver(&agp_amd64_pci_driver);
>  			return -ENODEV;
>  		}
>  
>  		/* First check that we have at least one AMD64 NB */
> -		if (!pci_dev_present(amd_nb_misc_ids))
> +		if (!pci_dev_present(amd_nb_misc_ids)) {
> +			pci_unregister_driver(&agp_amd64_pci_driver);
>  			return -ENODEV;
> +		}
>  
>  		/* Look for any AGP bridge */
>  		agp_amd64_pci_driver.id_table = agp_amd64_pci_promisc_table;
>  		err = driver_attach(&agp_amd64_pci_driver.driver);
> -		if (err == 0 && agp_bridges_found == 0)
> +		if (err == 0 && agp_bridges_found == 0) {
> +			pci_unregister_driver(&agp_amd64_pci_driver);
>  			err = -ENODEV;
> +		}
>  	}
>  	return err;
>  }
