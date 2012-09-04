Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2IDSAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:00:38 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44778 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab2IDSAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:00:02 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 173.246.103.110
Date: Tue, 4 Sep 2012 10:59:52 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pawel Moll <pawel.moll@arm.com>, linux-acpi@vger.kernel.org,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 0/3] Fix ACPI BGRT support for images located in EFI boot
 services memory
Message-ID: <20120904175952.GA4103@jtriplet-mobl1>
References: <cover.1346361959.git.josh@joshtriplett.org>
 <1346768840.4244.52.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346768840.4244.52.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:27:20PM +0100, Matt Fleming wrote:
> On Thu, 2012-08-30 at 14:28 -0700, Josh Triplett wrote:
> > The ACPI BGRT lets the OS access the BIOS logo image and its position on the
> > screen at boot time, allowing it to maintain that image on the screen until
> > ready to display something else, making boot more seamless.  This series fixes
> > support for accessing the boot logo image via the BGRT when the BIOS stores it
> > in EFI boot services memory, as recommended by the ACPI 5.0 spec.  Linux needs
> > to copy the image out of boot services memory before reclaiming boot services
> > memory.
> > 
> > The first patch refactors EFI initialization to defer freeing boot services
> > memory until later in the boot process, after we have ACPI available.  The
> > second patch adds a helper function to look up existing EFI boot services
> > mappings, to avoid re-mapping them.  The third patch moves BGRT initialization
> > to before the reclamation of boot services memory, copies the logo at that
> > point, and reworks the existing BGRT driver to use that existing copy.
> 
> Since we always end up doing a copy anyway, is there no way we could
> just copy the boot logo *without* deferring freeing the boot services
> code, e.g. move the copy before we do SetVirtualAddressMap()?

Unfortunately not.  We need enough of ACPI available to go read the
BGRT to know what to copy, so we need to defer freeing boot services
code until after we initialize ACPI (and thus everything ACPI needs,
which includes EFI since ACPI looks for root tables there).

> I wouldn't be surprised if some implementations got really cranky if
> we accessed boot services data after we installed a new virtual memory
> map.

Note that I've carefully accessed the boot services data *through* the
new virtual memory map, which should work fine.

> Besides, if we can avoid moving the efi_free_boot_services() call we can
> avoid littering init/main.c with more #ifdef CONFIG_X86 blocks.

Those seem easy enough to convert into appropriate always-available
stubs, if you'd like.  And I could move efi_free_boot_services() inside
efi_late_init(), too, keeping it an internal implementation detail of
EFI initialization.  Would that help?

- Josh Triplett
