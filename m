Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab0K3DEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 22:04:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab0K3DEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 22:04:42 -0500
Date: Mon, 29 Nov 2010 19:03:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v2 2/3] ACPI, APEI, Add APEI generic error status print
 support
Message-Id: <20101129190343.7d7cea12.akpm@linux-foundation.org>
In-Reply-To: <1291085501-31494-3-git-send-email-ying.huang@intel.com>
References: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
	<1291085501-31494-3-git-send-email-ying.huang@intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 10:51:40 +0800 Huang Ying <ying.huang@intel.com> wrote:

> printk is one of the methods to report hardware errors to user space.
> Hardware error information reported by firmware to Linux kernel is in
> the format of APEI generic error status (struct
> acpi_hes_generic_status).  This patch adds print support for the
> format, so that the corresponding hardware error information can be
> reported to user space via printk.
> 
> PCIe AER information print is not implemented yet.  Will refactor the
> original PCIe AER information printing code to avoid code duplicating.
> 
> ...
>  
> +#define pr_pfx(pfx, fmt, ...)			\
> +	printk("%s" fmt, pfx, ##__VA_ARGS__)

hm, why does so much code create little printk helper macros.  Isn't
there something generic somewhere?

>  /*
>   * CPER record ID need to be unique even after reboot, because record
>   * ID is used as index for ERST storage, while CPER records from
> @@ -46,6 +49,302 @@ u64 cper_next_record_id(void)
>  }
>  EXPORT_SYMBOL_GPL(cper_next_record_id);
>  
> +static const char *cper_severity_strs[] = {
> +	[CPER_SEV_RECOVERABLE]		= "recoverable",
> +	[CPER_SEV_FATAL]		=  "fatal",
> +	[CPER_SEV_CORRECTED]		= "corrected",
> +	[CPER_SEV_INFORMATIONAL]	= "info",
> +};
> +
> +static const char *cper_severity_str(unsigned int severity)
> +{
> +	return severity < ARRAY_SIZE(cper_severity_strs) ?
> +		cper_severity_strs[severity] : "unknown";
> +}

This code will explode nastily if CPER_SEV_RECOVERABLE .. 
CPER_SEV_INFORMATIONAL do not exactly have the values 0, 1, 2 and 3. 
They do have those values, but it would be a bit safer if they were
enumerated types and not #defines..

> +static void cper_print_bits(const char *pfx, unsigned int bits,
> +			    const char *strs[], unsigned int strs_size)
> +{
> +	int i, len = 0;
> +	const char *str;
> +
> +	for (i = 0; i < strs_size; i++) {
> +		if (!(bits & (1U << i)))
> +			continue;
> +		str = strs[i];
> +		if (len && len + strlen(str) + 2 > 80) {
> +			printk("\n");
> +			len = 0;
> +		}
> +		if (!len)
> +			len = pr_pfx(pfx, "%s", str);
> +		else
> +			len += printk(", %s", str);
> +	}
> +	if (len)
> +		printk("\n");
> +}

geeze, that's the sort of code you have to execute to find out what it
does.  Or ask the author to document it.



This patchset appears to implement a new kernel->userspace interface. 
But that interface isn't actually described anywhere, so reviewers must
reverse-engineer the interface from the implementation to be able to
review the interface.  Nobody bothers doing that so we end up with an
unreviewed interface, which we must maintain for eternity.

Please fully document all proposed interfaces?
