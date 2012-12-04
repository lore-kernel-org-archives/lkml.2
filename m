Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2LDRjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 12:39:42 -0500
Received: from [206.117.179.246] ([206.117.179.246]:32774 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752277Ab2LDRjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 12:39:39 -0500
Message-ID: <1354642763.6973.15.camel@joe-AO722>
Subject: Re: [PATCH v6 3/3] aerdrv: Cleanup log output for CPER based AER
From: Joe Perches <joe@perches.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 09:39:23 -0800
In-Reply-To: <20121204170442.31397.21190.stgit@grignak.americas.hpqcorp.net>
References: <20121204170429.31397.50068.stgit@grignak.americas.hpqcorp.net>
	 <20121204170442.31397.21190.stgit@grignak.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-04 at 10:04 -0700, Lance Ortiz wrote:
> These changes make cper_print_aer more consistent with aer_print_error
> which is called in the AER interrupt case. The string in the variable
> 'prefix' is printed at the beginning of each print statement in
> cper_print_aer(). The prefix is a string containing the driver name
> and the device's slot location.  From the callers the value of prefix
> is never assigned and is NULL, so when cper_print_aer prints data the
> initial string does not get printed.  This string is important because
> it identifies the device that the error is on.

Hi again Lance.

> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
[]
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
> +
>  	if (aer_severity == AER_CORRECTABLE) {
>  		status = aer->cor_status;
>  		mask = aer->cor_mask;

Perhaps this would be better just using dev_printk
instead of snprintf into a prefix with printk to
emulate dev_printk.

Also, perhaps KERN_NOTICE is preferable to KERN_WARNING
in the CORRECTABLE case.

Maybe something like:

	const char *level = KERN_ERR;
	if (aer_severity == AER_CORRECTABLE)
		level = KERN_NOTICE;

	...

	dev_printk(level, &dev->dev, etc...);

Maybe do this after this series of patches is accepted.
Enough with the revisions for awhile...

