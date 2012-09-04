Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2IDO1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:27:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:6455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221Ab2IDO1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:27:32 -0400
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
In-Reply-To: <cover.1346361959.git.josh@joshtriplett.org>
References: <cover.1346361959.git.josh@joshtriplett.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Tue, 04 Sep 2012 15:27:20 +0100
Message-ID: <1346768840.4244.52.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 14:28 -0700, Josh Triplett wrote:
> The ACPI BGRT lets the OS access the BIOS logo image and its position on the
> screen at boot time, allowing it to maintain that image on the screen until
> ready to display something else, making boot more seamless.  This series fixes
> support for accessing the boot logo image via the BGRT when the BIOS stores it
> in EFI boot services memory, as recommended by the ACPI 5.0 spec.  Linux needs
> to copy the image out of boot services memory before reclaiming boot services
> memory.
> 
> The first patch refactors EFI initialization to defer freeing boot services
> memory until later in the boot process, after we have ACPI available.  The
> second patch adds a helper function to look up existing EFI boot services
> mappings, to avoid re-mapping them.  The third patch moves BGRT initialization
> to before the reclamation of boot services memory, copies the logo at that
> point, and reworks the existing BGRT driver to use that existing copy.

Since we always end up doing a copy anyway, is there no way we could
just copy the boot logo *without* deferring freeing the boot services
code, e.g. move the copy before we do SetVirtualAddressMap()? I wouldn't
be surprised if some implementations got really cranky if we accessed
boot services data after we installed a new virtual memory map.

Besides, if we can avoid moving the efi_free_boot_services() call we can
avoid littering init/main.c with more #ifdef CONFIG_X86 blocks.

