Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1IMVwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:52:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16997 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab1IMVwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:52:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=h6VrhVqo4U2ath1d9jEjgmmqy+TbspIPnDmVj9I0ZebqpJAwoOqCFqLvRVHoTsZEI
	/ekKnx2jexT8Pv8mvertg==
Date: Tue, 13 Sep 2011 14:52:18 -0700
From: Andrew Morton <akpm@google.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, mahesh@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2 2/2] s390: Add architecture code for unmapping
 crashkernel memory
Message-Id: <20110913145218.659f9e21.akpm@google.com>
In-Reply-To: <20110913132654.157278466@linux.vnet.ibm.com>
References: <20110913132635.063397500@linux.vnet.ibm.com>
	<20110913132654.157278466@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Sep 2011 15:26:37 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> This patch implements the crash_map_pages() function for s390.
> KEXEC_CRASH_MEM_ALIGN is set to HPAGE_SIZE, in order to support
> kernel mappings that use large pages.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  arch/s390/include/asm/kexec.h    |    3 +++
>  arch/s390/kernel/machine_kexec.c |   31 +++++++++++++++++++++++++++++++
>  arch/s390/kernel/setup.c         |   10 ++++++----
>  3 files changed, 40 insertions(+), 4 deletions(-)
> 
> --- a/arch/s390/include/asm/kexec.h
> +++ b/arch/s390/include/asm/kexec.h
> @@ -36,6 +36,9 @@
>  /* Allocate one page for the pdp and the second for the code */
>  #define KEXEC_CONTROL_PAGE_SIZE 4096
>  
> +/* Alignment of crashkernel memory */
> +#define KEXEC_CRASH_MEM_ALIGN HPAGE_SIZE

Why not make this unconditional, for all architectures which support
hugepages?  ie:

#ifdef HPAGE_SIZE
#define KEXEC_CRASH_MEM_ALIGN HPAGE_SIZE
#else
#define KEXEC_CRASH_MEM_ALIGN PAGE_SIZE
#endif

in include/linux/kexec.h?

IOW, what are the compromises here?

Also, does s390 support CONFIG_HUGETLB_PAGE=n?  If so, does the use of
HPAGE_SIZE still make sense?  Does it compile?


>  /* The native architecture */
>  #define KEXEC_ARCH KEXEC_ARCH_S390
>  
> --- a/arch/s390/kernel/machine_kexec.c
> +++ b/arch/s390/kernel/machine_kexec.c
> @@ -243,6 +243,37 @@ static void __machine_kdump(void *image)
>  #endif
>  
>  /*
> + * Map or unmap crashkernel memory
> + */
> +static void crash_map_pages(int enable)
> +{
> +	unsigned long size = crashk_res.end - crashk_res.start + 1;

resource_size().

> +	BUG_ON(crashk_res.start % KEXEC_CRASH_MEM_ALIGN ||
> +	       size % KEXEC_CRASH_MEM_ALIGN);
> +	if (enable)
> +		vmem_add_mapping(crashk_res.start, size);
> +	else
> +		vmem_remove_mapping(crashk_res.start, size);
> +}
>
> ...
>
