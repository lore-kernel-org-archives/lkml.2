Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255Ab0EDWCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:02:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57700 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934244Ab0EDWCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:02:01 -0400
Date: Tue, 4 May 2010 15:00:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, jmorris@namei.org
Subject: Re: [PATCH] TPM: ACPI/PNP dependency removal
Message-Id: <20100504150026.907f3ed3.randy.dunlap@oracle.com>
In-Reply-To: <1273009760.3532.41.camel@blackbox.ibm.com>
References: <1273009760.3532.41.camel@blackbox.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BE09955.018E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 May 2010 18:49:20 -0300 Rajiv Andrade wrote:

> This patch pushes the ACPI dependency into the device driver code
> itself. Now, even without ACPI/PNP enabled, the device can be registered
> using the TIS specified memory space. This will however result in the
> lack of access to the bios event log, being the only implication of such
> ACPI removal.
> 
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/Kconfig   |   14 +++++++++++---
>  drivers/char/tpm/tpm_tis.c |   42 ++++++++++++++++++++++--------------------
>  2 files changed, 33 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index f5fc64f..0a9ec0b 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -17,20 +17,28 @@ menuconfig TCG_TPM
>  	  obtained at: <http://sourceforge.net/projects/trousers>.  To 
>  	  compile this driver as a module, choose M here; the module 
>  	  will be called tpm. If unsure, say N.
> -	  Note: For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
> -	  and CONFIG_PNPACPI.
> +	  Note: For more TPM drivers and BIOS LOG access enable 
> +	  CONFIG_PNP, CONFIG_ACPI and CONFIG_PNPACPI.
>  
>  if TCG_TPM
>  
>  config TCG_TIS
>  	tristate "TPM Interface Specification 1.2 Interface"
> -	depends on PNP
>  	---help---
>  	  If you have a TPM security chip that is compliant with the
>  	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
>  	  from within Linux.  To compile this driver as a module, choose
>  	  M here; the module will be called tpm_tis.
>  
> +config TCG_BIOS_LOG
> +	bool "TPM bios mesurement log"

	          BIOS measurement

> +	depends on X86
> +	select ACPI
> +	---help---
> +	  ACPI is required for access to bios measurements lists and therefore

	                                 BIOS

and if I had any say-so, I would Nack this part of the patch.
Selecting ACPI adds a huge amount of code, so it should just depend on ACPI IMO.

Also, ACPI depends on PCI and PM, so if this "select" part remains,
this should be more like:

	  depends on X86 && PCI && PM

(unless that's already enforced somewhere else).

> +	  to validate the PCR[0] value. So say Yes in case you want this
> +	  feature and, consequently, ACPI will be enabled.
> +
>  config TCG_NSC
>  	tristate "National Semiconductor TPM Interface"
>  	---help---


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
