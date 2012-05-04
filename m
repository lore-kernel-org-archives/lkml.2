Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148Ab2EDQRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:17:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40877 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2EDQRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:17:43 -0400
Date: Fri, 4 May 2012 12:11:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Marco Aurelio da Costa <costa@gamic.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH v2] ACPI: Ignore invalid _PSS entries, but use valid
 ones
Message-ID: <20120504161154.GA16255@phenom.dumpdata.com>
References: <CAEe-dwgCR55urie0c1MdBWTS6-E=3faXj68=WMcb6NvQCQX0rg@mail.gmail.com>
 <20120504135217.GB1049@phenom.dumpdata.com>
 <CAEe-dwj4JP-U0tc3wpmHvzv=aQU5zy3cG_E9FrriPw_sdfg2bg@mail.gmail.com>
 <CAEe-dwg5pG2aDHopeHA2yiACUjS3cba5Vm1GyOaM4y=gpvpmMQ@mail.gmail.com>
 <CAEe-dwjVsqn-XyXfhRacEF5gh_5GCX_MeNafPkSGFu_eeA3Pfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEe-dwjVsqn-XyXfhRacEF5gh_5GCX_MeNafPkSGFu_eeA3Pfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 05:25:13PM +0200, Marco Aurelio da Costa wrote:
> From: Marco Aurelio da Costa <costa@gamic.com>
> [v2: Fixes suggested by Konrad]
> Signed-off-by: Marco Aurelio da Costa <costa@gamic.com>

Heh. You didn't compile test this version did you?
> 
> The EliteBook 8560W has non-initialized entries in its _PSS ACPI
> table. Instead of bailing out when the first non-initialized entry is
> found, ignore it and use only  the valid entries. Only bail out if there
> is no valid entry at all.
> 
> ---
> --- linux-3.3.3/drivers/acpi/processor_perflib.c.orig	2012-04-24
> 22:18:23.288041268 +0200
> +++ linux-3.3.3/drivers/acpi/processor_perflib.c	2012-05-04
> 17:22:57.400034613 +0200
> @@ -311,6 +311,7 @@ static int acpi_processor_get_performanc
>  	struct acpi_buffer state = { 0, NULL };
>  	union acpi_object *pss = NULL;
>  	int i;
> +	int last_invalid = -1;
> 
> 
>  	status = acpi_evaluate_object(pr->handle, "_PSS", NULL, &buffer);
> @@ -372,14 +373,32 @@ static int acpi_processor_get_performanc
>  		    ((u32)(px->core_frequency * 1000) !=
>  		     (px->core_frequency * 1000))) {
>  			printk(KERN_ERR FW_BUG PREFIX
> -			       "Invalid BIOS _PSS frequency: 0x%llx MHz\n",
> -			       px->core_frequency);
> -			result = -EFAULT;
> -			kfree(pr->performance->states);
> -			goto end;
> +			       "Invalid BIOS _PSS frequency found for processor %d: 0x%llx MHz\n",
> +			       pr->id, px->core_frequency);
> +			if (last_invalidi == -1)

Hrmm. invalidi?

> +				last_invalid = i;
> +		} else {
> +			if (last_invalid != -1) {
> +				/*
> +				 * Copy this valid entry over last_invalid entry
> +				 */
> +				memcpy(&(pr->performance->states[last_invalid]),
> +				       px, sizeof(struct acpi_processor_px));
> +				++last_invalid;
> +			}
>  		}
>  	}
> 
> +	if (last_invalid == 0) {
> +		printk(KERN_ERR FW_BUG PREFIX
> +		       "No valid BIOS _PSS frequency found for processor %d\n", pr->id);
> +		result = -EFAULT;
> +		kfree(pr->performance->states);

Just as a precaution - also do this pls:

pr->performance->states = NULL?

> +	}
> +
> +	if (last_invalid > 0)
> +		pr->performance->state_count = last_invalid;
> +
>        end:
>  	kfree(buffer.pointer);
> 
> -- 
> Marco Costa
> Customer Support
> --
> GAMIC mbH
> Roermonder Strasse, 151
> 52072 Aachen
> Germany
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
