Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1IMNaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 09:30:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50569 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1IMN37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 09:29:59 -0400
Date: Tue, 13 Sep 2011 14:29:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matt Fleming <matt.fleming@intel.com>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: Re: [PATCH v2 10/10] x86, efi: EFI boot stub support
Message-ID: <20110913132931.GA5203@srcf.ucam.org>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
 <1315838094-2307-11-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315838094-2307-11-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 03:34:54PM +0100, Matt Fleming wrote:

> +	status = efi_call_phys5(sys_table->boottime->locate_handle,
> +				EFI_LOCATE_BY_PROTOCOL, proto,
> +				NULL, &size, gop_handle);
> +	if (status != EFI_SUCCESS)
> +		goto free_handle;
> +
> +	nr_gops = size / sizeof(void *);
> +	for (i = 0; i < nr_gops; i++) {
> +		void *h = gop_handle[i];
> +
> +		status = efi_call_phys3(sys_table->boottime->handle_protocol,
> +					h, proto, &gop);
> +		if (status != EFI_SUCCESS)
> +			continue;
> +
> +		status = efi_call_phys4(gop->query_mode, gop, gop->mode->mode,
> +					&size, &info);
> +		if (status == EFI_SUCCESS)
> +			break;
> +	}

Apple do something funky here, which is to provide a GOP that's not 
backed by real hardware but which muxes writes out to multiple outputs 
in order to handle the multiple display case without screwing up aspect 
ratio. That's fine, except that the stride reported for the fake one is 
just the horizontal width of the logical display. That results in things 
failing badly. The real one also implements PCIIO. My workaround so far 
has been to look for a GOP that handles PCIIO and use it if found, and 
otherwise just fall back to the first GOP.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
