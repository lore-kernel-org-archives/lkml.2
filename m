Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2GWOkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:40:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab2GWOkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:40:40 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] init: Introduce early initrd files through uncompressed cpio passing
Date: Mon, 23 Jul 2012 16:40:34 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        initramfs@vger.kernel.org, bigeasy@linutronix.de,
        Fenghua Yu <fenghua.yu@intel.com>
References: <1342607764-66747-1-git-send-email-trenn@suse.de> <1342607764-66747-2-git-send-email-trenn@suse.de> <500AC8F6.4010802@zytor.com>
In-Reply-To: <500AC8F6.4010802@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231640.35023.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 21, 2012 05:21:26 PM H. Peter Anvin wrote:
> On 07/18/2012 03:36 AM, Thomas Renninger wrote:
> > cpio parsing code comes from  H. Peter Anvin.
> > The CONFIG_EARLY_INITRD feature is architecture independent, but
> > for now only enabled/called for X86.
> > The problem is that initrd_start must be valid, but there is no
> > architecture independent reserve_initrd() call in init/main.c or
> > similiar.
> > + * Add here new callback functions and the path relevant files show up in an
> > + * uncompressed cpio
> > + */
> > +static __initdata struct initrd_early_data initrd_early_callbacks[] =
> > +{
> > +	{
> > +		.namesp = NULL,
> > +	}
> > +};
> > +
> 
> I don't like your callback interface at all.  In fact, it is actively 
> broken, because it assumes that all early users are runnable at the same 
> time,
That's wrong.
If you have a closer look at the "ACPI table override" solution, it's
splitted up:
The callback collects all initrd provided tables:
    __init acpi_initrd_table_override() and __init acpi_initrd_finalize()
the actual usage of the files can happen any time later on when
the ACPICA subsystems grabs another table.

This is the most flexible solution and I cannot see why others
cannot do the same.

> which is trivially shown false -- the microcode work that Fenghua 
> Yu is working on needs access to its early data much, much earlier than 
> your ACPI code.
This is another problem and I expect I call:
early_initrd_find_cpio_data()
early enough for Fenghua's needs.
If not, how early exactly is this needed?

I hook in shortly after initrd_start gets valid.
This is necessary so that early_initrd_find_cpio_data can make
use of the arch independent initrd_start variable and the whole
feature is kept arch independent:

@@ -941,6 +941,8 @@ void __init setup_arch(char **cmdline_p)
 
        reserve_initrd();
 
+       early_initrd_find_cpio_data((void *)initrd_start, initrd_end - initrd_start);
+

I have heard about a possible use case on ARM for this (pass device tree
via initrd). I will ask...

> So big NAK on this change.  Instead we should stick to the imperative 
> interface that I had in my original code (call the search function with 
> a filename and let it return a pointer if found.)
This does not work with what I like to achive with APCI table overriding:
Pass an arbitrary amount of firmware files.
It could work with pre-defining the files, but that is not nice:
.../acpi0.aml
..
.../acpi9.aml

Another advantage:
If (just an example) CPU microcode files get passed via "early initrd",
the same path could be provided than needed by request_fw().
For Intel CPU microcode that would be:
/lib/firmware/intel-ucode
and files are split up there into family-model-stepping as done
already by microcode_intel.c
This would allow (with my approach):
   1) One can build a CPU family-model-stepping independent,
      generic initrd putting in all available Intel CPU microcodes.
   2) The path in cpio accessed via "uncompressed early initrd"
      can be the same as in the later unpacked rootfs accessed
      by initrd userspace tools.
      No need to add them twice, to the compressed and uncompressed
      cpio if the files should be available as "early initrd" data
      *and* in initramfs.      
      So above CPU microcode files could be used via "early initrd"
      mechanism to flash the boot CPU. And the same file(s) can be used
      later in unpacked intramfs via request_fw() to flash other, later
      brought up CPUs.
   3) ...


-> I'd prefer to go with this more flexible callback approach, instead
of spreading initrd_findcpio(..) calls all over the kernel when this gets
used more often.

   Thomas
