Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1INI6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:58:40 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:35012 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1INI6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:58:39 -0400
Subject: Re: [patch v2 2/2] s390: Add architecture code for unmapping
 crashkernel memory
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@google.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, mahesh@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110913145218.659f9e21.akpm@google.com>
References: <20110913132635.063397500@linux.vnet.ibm.com>
	 <20110913132654.157278466@linux.vnet.ibm.com>
	 <20110913145218.659f9e21.akpm@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 14 Sep 2011 10:58:28 +0200
Message-ID: <1315990708.3367.14.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Tue, 2011-09-13 at 14:52 -0700, Andrew Morton wrote:
> On Tue, 13 Sep 2011 15:26:37 +0200
> Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

[snip]

> > --- a/arch/s390/include/asm/kexec.h
> > +++ b/arch/s390/include/asm/kexec.h
> > @@ -36,6 +36,9 @@
> >  /* Allocate one page for the pdp and the second for the code */
> >  #define KEXEC_CONTROL_PAGE_SIZE 4096
> >  
> > +/* Alignment of crashkernel memory */
> > +#define KEXEC_CRASH_MEM_ALIGN HPAGE_SIZE
> 
> Why not make this unconditional, for all architectures which support
> hugepages?  ie:
> 
> #ifdef HPAGE_SIZE
> #define KEXEC_CRASH_MEM_ALIGN HPAGE_SIZE
> #else
> #define KEXEC_CRASH_MEM_ALIGN PAGE_SIZE
> #endif

> in include/linux/kexec.h?
> 
> IOW, what are the compromises here?

If we would do it that way, crashkernel memory on architectures that
support large pages but do not support unmapping of crashkernel memory
would always be aligned to HPAGE_SIZE. But only PAGE_SIZE alignment
would be necessary in that case.

If that is acceptable I have no problem to define that unconditional for
all architectures. Vivek what do you think?

> 
> Also, does s390 support CONFIG_HUGETLB_PAGE=n?  If so, does the use of
> HPAGE_SIZE still make sense?  Does it compile?

Yes, s390 supports CONFIG_HUGETLB_PAGE=n and it still compiles in that
case. For us it is ok to use HPAGE_SIZE crashkernel alignment also for
kernels with CONFIG_HUGETLB_PAGE=n.

> 
> 
> >  /* The native architecture */
> >  #define KEXEC_ARCH KEXEC_ARCH_S390
> >  
> > --- a/arch/s390/kernel/machine_kexec.c
> > +++ b/arch/s390/kernel/machine_kexec.c
> > @@ -243,6 +243,37 @@ static void __machine_kdump(void *image)
> >  #endif
> >  
> >  /*
> > + * Map or unmap crashkernel memory
> > + */
> > +static void crash_map_pages(int enable)
> > +{
> > +	unsigned long size = crashk_res.end - crashk_res.start + 1;
> 
> resource_size().

Ok I will use that. Thanks for the hint.

Michael

