Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab2IDUL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:11:29 -0400
Received: from mga05.intel.com ([192.55.52.89]:2261 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757463Ab2IDULZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:11:25 -0400
Subject: Re: [PATCH 0/3] Fix ACPI BGRT support for images located in EFI
 boot services memory
From: Matt Fleming <matt.fleming@intel.com>
To: Josh Triplett <josh@joshtriplett.org>
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
In-Reply-To: <20120904175952.GA4103@jtriplet-mobl1>
References: <cover.1346361959.git.josh@joshtriplett.org>
	 <1346768840.4244.52.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120904175952.GA4103@jtriplet-mobl1>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Tue, 04 Sep 2012 21:11:14 +0100
Message-ID: <1346789474.4244.56.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 10:59 -0700, Josh Triplett wrote:
> On Tue, Sep 04, 2012 at 03:27:20PM +0100, Matt Fleming wrote:
> > On Thu, 2012-08-30 at 14:28 -0700, Josh Triplett wrote:
> > > The ACPI BGRT lets the OS access the BIOS logo image and its position on the
> > > screen at boot time, allowing it to maintain that image on the screen until
> > > ready to display something else, making boot more seamless.  This series fixes
> > > support for accessing the boot logo image via the BGRT when the BIOS stores it
> > > in EFI boot services memory, as recommended by the ACPI 5.0 spec.  Linux needs
> > > to copy the image out of boot services memory before reclaiming boot services
> > > memory.
> > > 
> > > The first patch refactors EFI initialization to defer freeing boot services
> > > memory until later in the boot process, after we have ACPI available.  The
> > > second patch adds a helper function to look up existing EFI boot services
> > > mappings, to avoid re-mapping them.  The third patch moves BGRT initialization
> > > to before the reclamation of boot services memory, copies the logo at that
> > > point, and reworks the existing BGRT driver to use that existing copy.
> > 
> > Since we always end up doing a copy anyway, is there no way we could
> > just copy the boot logo *without* deferring freeing the boot services
> > code, e.g. move the copy before we do SetVirtualAddressMap()?
> 
> Unfortunately not.  We need enough of ACPI available to go read the
> BGRT to know what to copy, so we need to defer freeing boot services
> code until after we initialize ACPI (and thus everything ACPI needs,
> which includes EFI since ACPI looks for root tables there).

Ah, right. It was also pointed out to me offline that some drivers have
been known to access boot services data even after
SetVirtualAddressMap(), so this deferring shouldn't be a problem.

> > I wouldn't be surprised if some implementations got really cranky if
> > we accessed boot services data after we installed a new virtual memory
> > map.
> 
> Note that I've carefully accessed the boot services data *through* the
> new virtual memory map, which should work fine.
> 
> > Besides, if we can avoid moving the efi_free_boot_services() call we can
> > avoid littering init/main.c with more #ifdef CONFIG_X86 blocks.
> 
> Those seem easy enough to convert into appropriate always-available
> stubs, if you'd like.  And I could move efi_free_boot_services() inside
> efi_late_init(), too, keeping it an internal implementation detail of
> EFI initialization.  Would that help?

Yeah, that would seem like a good solution.

