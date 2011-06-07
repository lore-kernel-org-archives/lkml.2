Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1FGUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:25:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50552 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1FGUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:25:25 -0400
Date: Tue, 7 Jun 2011 21:25:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>
Subject: Re: [PATCH v2 3/3] efi: Add support for using efivars as a pstore
 backend
Message-ID: <20110607202517.GA732@srcf.ucam.org>
References: <1307470562-15633-1-git-send-email-mjg@redhat.com>
 <1307470562-15633-4-git-send-email-mjg@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E70D8EAE@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E70D8EAE@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 01:16:55PM -0700, Luck, Tony wrote:
> +	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
> +	if (efi_pstore_info.buf) {
> +		efi_pstore_info.bufsize = 1024;
> +		efi_pstore_info.data = efivars;
> +		mutex_init(&efi_pstore_info.buf_mutex);
> +		pstore_register(&efi_pstore_info);
> +	}
> 
> I'd imagined #ifdef CONFIG_PSTORE around this (and the
> efi_pstore_info definition) rather than providing stubs
> for the !PSTORE case.

We usually seem to frown on #ifdefs in the middle of functions. We could 
probably make this easier by adding a pstore_enabled that's #defined to 
0 in the !PSTORE case, then the compiler ought to just get rid of it 
all.

> You should avoid a memory leak with:
> 
> 		if (!pstore_register(&efi_pstore_info))
> 			kfree(efi_pstore_info.buf);

Ah, true.

> I've also been thinking some more about how to handle a
> system that has more than one pstore back-end available.
> I still don't have any good ideas how to make use of more
> than one backend - but it occurs to me that we may need
> a way to let the user choose which to use (e.g. in the
> unlikely event that a BIOS bug made one of ERST or EFI
> unusable by pstore). The current "whoever registers first
> gets to use it" now seems inadequate.

Mm. Given that the name of the source is in the file, there's no 
namespacing issues. In an ideal world I think we'd register all of them 
in order to provide a better chance of at least one of them ending up in 
actual persistent storage.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
