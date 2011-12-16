Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193Ab1LPIk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:40:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1LPIkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:40:23 -0500
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Do not round per_cpu_ptr_to_phys to page boundary
Date: Fri, 16 Dec 2011 09:40:20 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.9-default; KDE/4.6.0; i686; ; )
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, surovegin@google.com,
        gthelen@google.com
References: <201112140033.58951.ptesarik@suse.cz> <CAOS58YP8o9xQvZJtpEJobChhJ+pSDQ9PqDwaXFS_h+JFd65jOw@mail.gmail.com> <201112160904.23252.ptesarik@suse.cz>
In-Reply-To: <201112160904.23252.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112160940.20909.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore my patch. I can see, a patch has already been accepted.

I only replied too fast (before I read the rest of the thread).

Petr

Dne Pá 16. prosince 2011 09:04:23 Petr Tesarik napsal(a):
> The phys_addr_t per_cpu_ptr_to_phys() function ignores the offset within a
> page, whenever not using a simple translation using __pa().
> 
> Without this patch /sys/devices/system/cpu/cpu*/crash_notes shows incorrect
> values, which breaks kdump. Other things may also be broken.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 3bb810a..1a1b5ac 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -998,6 +998,7 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  	bool in_first_chunk = false;
>  	unsigned long first_low, first_high;
>  	unsigned int cpu;
> +	phys_addr_t page_addr;
> 
>  	/*
>  	 * The following test on unit_low/high isn't strictly
> @@ -1023,9 +1024,10 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  		if (!is_vmalloc_addr(addr))
>  			return __pa(addr);
>  		else
> -			return page_to_phys(vmalloc_to_page(addr));
> +			page_addr = page_to_phys(vmalloc_to_page(addr));
>  	} else
> -		return page_to_phys(pcpu_addr_to_page(addr));
> +		page_addr = page_to_phys(pcpu_addr_to_page(addr));
> +	return page_addr + offset_in_page(addr);
>  }
> 
>  /**
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign
> http://stopthemeter.ca/ Don't email: <a href=mailto:"dont@kvack.org">
> email@kvack.org </a>
