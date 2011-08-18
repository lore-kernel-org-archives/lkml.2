Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab1HRR4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:56:50 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:35528 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1HRR4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:56:49 -0400
Subject: Re: [patch v3 3/8] kdump: Add size to elfcorehdr kernel parameter
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20110818172815.GD15413@redhat.com>
References: <20110812134849.748973593@linux.vnet.ibm.com>
	 <20110812134907.325789470@linux.vnet.ibm.com>
	 <20110817210554.GD14813@redhat.com> <1313657279.3528.6.camel@br98xy6r>
	 <20110818172815.GD15413@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 18 Aug 2011 19:56:46 +0200
Message-ID: <1313690206.3528.32.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Thu, 2011-08-18 at 13:28 -0400, Vivek Goyal wrote:
> > The parameter is parsed in common code (kernel/crash_dump.c) in
> > early_param("elfcorehdr", setup_elfcorehdr), as it is already currently
> > the case.
> > 
> > We use address and size of the ELF core header to reserve the header
> > memory in setup.c (see patch #8):
> > 
> > +#ifdef CONFIG_CRASH_DUMP
> > +       if (is_kdump_kernel())
> > +               reserve_bootmem(elfcorehdr_addr - OLDMEM_BASE,
> > +                               PAGE_ALIGN(elfcorehdr_size), BOOTMEM_DEFAULT);
> > +#endif
> > 
> > Does that answer your question?
> 
> Yes it does. Thanks.
> 
> It brings up few more questions about rest of the memory mangement.
> 
> So kdump kernel is loaded in reserved area but does not run from there.
> It reloads itself into lower memory areas and swaps the contents of
> lower memory with reserved memory? If yes, how does it, kernel or
> purgatory?

With the v3 patch series purgatory does that (see
purgatory-s390.c/post_verification_setup_arch()):

> How does kernel come to know about how much memory is to be swapped

2nd kernel knows crash_base and crash_base because kexec tools told him
that. We do it like registering the ramdisk. See kexec-image.c:

+               if (info->kexec_flags & KEXEC_ON_CRASH) {
+                       tmp = krnl_buffer + OLDMEM_BASE_OFFS;
+                       *tmp = crash_base;
+
+                       tmp = krnl_buffer + OLDMEM_SIZE_OFFS;
+                       *tmp = crash_end - crash_base + 1;
+               }

> and how do you bound the memory usage of second kernel so that it
> does not try to use other memory which has not been swapped into
> reserved area.

See kernel patches setup.c:

+/*
+ * Make sure that oldmem, where the dump is stored, is protected
+ */
+static void reserve_oldmem(void)
+{
+#ifdef CONFIG_CRASH_DUMP
+       if (!is_kdump_kernel())
+               return;
+
+       reserve_kdump_bootmem(OLDMEM_BASE, OLDMEM_SIZE, CHUNK_OLDMEM);
+       reserve_kdump_bootmem(OLDMEM_SIZE, memory_end - OLDMEM_SIZE,
+                             CHUNK_OLDMEM);
+       if (OLDMEM_BASE + OLDMEM_SIZE == real_memory_size)
+               saved_max_pfn = PFN_DOWN(OLDMEM_BASE) - 1;
+       else
+               saved_max_pfn = PFN_DOWN(real_memory_size) - 1;
+#endif
+}

Michael










