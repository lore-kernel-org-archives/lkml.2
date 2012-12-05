Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2LEOuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:50:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56879 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2LEOui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:50:38 -0500
Date: Wed, 5 Dec 2012 15:50:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/3] aerdrv: Cleanup log output for CPER based AER
Message-ID: <20121205145035.GE2364@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
	rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121204210305.4515.91100.stgit@grignak.americas.hpqcorp.net>
 <20121204210318.4515.10180.stgit@grignak.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121204210318.4515.10180.stgit@grignak.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 02:03:18PM -0700, Lance Ortiz wrote:
> These changes make cper_print_aer more consistent with aer_print_error
> which is called in the AER interrupt case. The string in the variable
> 'prefix' is printed at the beginning of each print statement in
> cper_print_aer(). The prefix is a string containing the driver name
> and the device's slot location.  From the callers the value of prefix
> is never assigned and is NULL, so when cper_print_aer prints data the
> initial string does not get printed.  This string is important because
> it identifies the device that the error is on.
> 
> v1-v2 fix some compile errors withinn the #ifdef
> v3-v4 remove agent id stuff and kept print the same to avoid
> compatibility issues
> 
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
> 
>  drivers/pci/pcie/aer/aerdrv_errprint.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
> index 34d96e4..58ff4c0 100644
> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
> @@ -228,9 +228,14 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
>  	int aer_severity, layer, agent, status_strs_size, tlp_header_valid = 0;
>  	u32 status, mask;
>  	const char **status_strs;
> -	char *prefix = NULL;
> +	char prefix[44];
>  
>  	aer_severity = cper_severity_to_aer(cper_severity);
> +	snprintf(prefix, sizeof(prefix), "%s%s %s: ",
> +		(aer_severity == AER_CORRECTABLE) ?
> +		KERN_WARNING : KERN_ERR,
> +		dev_driver_string(&dev->dev), dev_name(&dev->dev));

Here it is, you're initializing 'prefix' here although it is being
used in the previous patch. You should concentrate the whole prefix
initialization and passing in one patch so that there are no breakages.

Also, why is it exactly 44 chars long, is that some magic number
that always works? At least this is what aer_print_error does
too. I'm guessing someone chose it because it is large enough for
dev_driver_string() and dev_name() and a couple more formatting
characters. Oh well.

Thanks.

-- 
Regards/Gruss,
    Boris.
