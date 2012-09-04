Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2IDX2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:28:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35202 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2IDX2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:28:51 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 173.246.103.110
Date: Tue, 4 Sep 2012 16:28:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Olof Johansson <olof@lixom.net>, Matthew Garrett <mjg@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pawel Moll <pawel.moll@arm.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv2 0/4] Fix ACPI BGRT support for images located in EFI
 boot services memory
Message-ID: <20120904232843.GA11855@jtriplet-mobl1>
References: <cover.1346792566.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1346792566.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 02:21:19PM -0700, Josh Triplett wrote:
> v2: Made the new internal function efi_unmap_memmap static.  Incorporated
>     feedback from H. Peter Anvin and Matt Fleming: added stubs for
>     x86-specific EFI functions called from init/main.c to eliminate the
>     corresponding ifdefs in start_kernel; deferred
>     efi_free_boot_services even later, to just before free_initmem.

Argh, looks like I missed something important in testing: a WARN from
check_early_ioremap_leak.  Looks like moving the reclamation of the EFI
memory map that late makes check_early_ioremap_leak figure that it won't
get reclaimed at all.

As far as I can tell, ioremap won't work that early; EFI really does
need to use early_ioremap.  Since at the moment we don't seem to have
any other drivers that need to access boot services memory, any
objection to moving efi_free_boot_services back to just after ACPI?

- Josh Triplett
