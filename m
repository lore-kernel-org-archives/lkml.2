Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab0FBTuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:50:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51070 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab0FBTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lXeYeoB93qxKGT1HPWVav/f+ke6KIByAuN/L3FsJwfpSf7eAFK839CXBPNeJPNm9j/
         4qJXiXwnsKstwTA54DWoypV5h4rX9CMjESO/frgwtBgiTbhfpvLdNHmNs8h/+epgUe7i
         DMieU9eGmRFNr7bl83/DkWHejb4w+aY4SYtFU=
Date: Wed, 2 Jun 2010 23:49:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, mjg@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH]: x86: use acpi flags for apic mapping
Message-ID: <20100602194956.GB5264@lenovo>
References: <20100602192418.2706.35192.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602192418.2706.35192.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 03:29:27PM -0400, Prarit Bhargava wrote:
> ACPI FADT has entries to describe the apic mapping of a system.  Currently,
> these are ignored in the apic code.
> 
> Introduce apic_is_acpi_clustered_box() and read the FADT to determine
> if a box is clustered or not.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 1fa03e0..4518683 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -252,6 +252,14 @@ static inline int apic_is_clustered_box(void)
>  }
>  #endif
>  
> +enum apic_acpi_map_status {
> +	APIC_ACPI_BOTH,
> +	APIC_ACPI_CLUSTER,
> +	APIC_ACPI_PHYSICAL,
> +	APIC_ACPI_NONE
> +};
> +extern enum apic_acpi_map_status apic_is_acpi_clustered_box(void);
> +
>  extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
>  extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
>  
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index e5a4a1e..6ca346a 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -2189,6 +2189,30 @@ static const __cpuinitconst struct dmi_system_id multi_dmi_table[] = {
>  	{}
>  };
>  
> +#ifdef CONFIG_ACPI
> +enum apic_acpi_map_status apic_is_acpi_clustered_box(void)
> +{

It's a bit strange that function is "is" prefixed and returns not true or false
but enum, perhaps we may name it apic_acpi_dst_model() or something like
that?

> +	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) {
> +		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL &&
> +		    acpi_gbl_FADT.flags & ACPI_FADT_APIC_CLUSTER) {
> +			/*
> +			 * The rest of the code assumes physical flat
> +			 * in this case.
> +			 */
> +			return APIC_ACPI_BOTH;
> +		}
> +
> +		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_CLUSTER)
> +			return APIC_ACPI_CLUSTER;
> +
> +		if (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)
> +			return APIC_ACPI_PHYSICAL;
> +	}
> +
> +	return APIC_ACPI_NONE;
> +}
> +#endif
> +
>  static void __cpuinit dmi_check_multi(void)
>  {
>  	if (multi_checked)
> @@ -2208,6 +2232,20 @@ static void __cpuinit dmi_check_multi(void)
>   */
>  __cpuinit int apic_is_clustered_box(void)
>  {
> +#ifdef CONFIG_ACPI
> +	switch (apic_is_acpi_clustered_box()) {
> +		case APIC_ACPI_PHYSICAL:
> +		case APIC_ACPI_BOTH: /* assume physical flat in this case */
> +			return 0;
> +			break;
> +		case APIC_ACPI_CLUSTER:
> +			return 1;
> +			break;
> +		default:
> +			break;
> +	}
> +#endif
> +
>  	dmi_check_multi();
>  	if (multi)
>  		return 1;
> diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
> index 09d3b17..80e291a 100644
> --- a/arch/x86/kernel/apic/apic_flat_64.c
> +++ b/arch/x86/kernel/apic/apic_flat_64.c
> @@ -231,14 +231,32 @@ static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  {
>  #ifdef CONFIG_ACPI
>  	/*
> -	 * Quirk: some x86_64 machines can only use physical APIC mode
> -	 * regardless of how many processors are present (x86_64 ES7000
> -	 * is an example).
> +	 * Some x86_64 machines can only use clustered or physical APIC
> +	 * mode regardless of how many processors are present.
>  	 */

Hmm, was it really needed to remove ES7000 from comment? Keep it here please.

> -	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
> -		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
> -		printk(KERN_DEBUG "system APIC only can use physical flat");
> -		return 1;
> +	switch (apic_is_acpi_clustered_box()) {
> +		case APIC_ACPI_BOTH:
> +			printk(KERN_WARNING FW_BUG "ACPI has set apic mode to "
> +			       "both clustered and physical flat.  Please "
> +			       "contact your firmware vendor for an update.\n");
> +			/*
> +			 * In this case assume physical flat as only a very
> +			 * limited number of systems use cluster
> +			 */
> +			printk(KERN_DEBUG "system APIC using physical flat\n");
> +			return 1;
> +			break;
> +		case APIC_ACPI_CLUSTER:
> +			printk(KERN_DEBUG "system APIC can only use cluster\n");
> +			return 0;
> +			break;
> +		case APIC_ACPI_PHYSICAL:
> +			printk(KERN_DEBUG "system APIC can only use physical"
> +			       " flat\n");
> +			return 1;
> +			break;
> +		default:
> +			break;
>  	}
>  
>  	if (!strncmp(oem_id, "IBM", 3) && !strncmp(oem_table_id, "EXA", 3)) {

	-- Cyrill
