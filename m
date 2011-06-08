Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1FHTbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:31:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59452 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab1FHTbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:31:36 -0400
Message-ID: <4DEFCDFB.5070703@oracle.com>
Date: Wed, 08 Jun 2011 12:31:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: arnd@arndb.de, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@elte.hu, josh@joshtriplett.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH] Add debugging boundary check to pfn_to_page
References: <1307560734-3915-1-git-send-email-emunson@mgebm.net>
In-Reply-To: <1307560734-3915-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DEFCE08.00B4:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/11 12:18, Eric B Munson wrote:
> Bugzilla 36192 showed a problem where pages were being accessed outside of
> a node boundary.  It would be helpful in diagnosing this kind of problem to
> have pfn_to_page complain when a page is accessed outside of the node boundary.
> This patch adds a new debug config option which adds a WARN_ON in pfn_to_page
> that will complain when pages are accessed outside of the node boundary.
> 
> Signed-of-by: Eric B Munson <emunson@mgebm.net>
> ---
>  include/asm-generic/memory_model.h |   19 +++++++++++++++----
>  lib/Kconfig.debug                  |   10 ++++++++++
>  2 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
> index fb2d63f..a0f1d19 100644
> --- a/include/asm-generic/memory_model.h
> +++ b/include/asm-generic/memory_model.h
> @@ -62,11 +62,22 @@
>  	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
>  })
>  
> -#define __pfn_to_page(pfn)				\
> -({	unsigned long __pfn = (pfn);			\
> -	struct mem_section *__sec = __pfn_to_section(__pfn);	\
> -	__section_mem_map_addr(__sec) + __pfn;		\
> +#ifdef CONFIG_DEBUG_MEMORY_MODEL
> +#define __pfn_to_page(pfn)						\
> +({	unsigned long __pfn = (pfn);					\
> +	struct mem_section *__sec = __pfn_to_section(__pfn);		\
> +	struct page *__page = __section_mem_map_addr(__sec) + __pfn;	\
> +	WARN_ON(__page->flags == 0);					\
> +	__page;								\
>  })
> +#else
> +#define __pfn_to_page(pfn)						\
> +({	unsigned long __pfn = (pfn);					\
> +	struct mem_section *__sec = __pfn_to_section(__pfn);		\
> +	__section_mem_map_addr(__sec) + __pfn;	\
> +})
> +#endif /* CONFIG_DEBUG_MEMORY_MODEL */
> +
>  #endif /* CONFIG_FLATMEM/DISCONTIGMEM/SPARSEMEM */
>  
>  #define page_to_pfn __page_to_pfn
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index dd373c8..d932cbf 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -777,6 +777,16 @@ config DEBUG_MEMORY_INIT
>  
>  	  If unsure, say Y
>  
> +config DEBUG_MEMORY_MODEL
> +	bool "Debug memory model" if SPARSEMEM || DISCONTIGMEM
> +	depends on SPARSEMEM || DISCONTIGMEM

	bool <prompt> <expr>
creates the dependency, so the "depends on" line is not needed.

> +	help
> +	  Enable this to check that page accesses are done within node
> +	  boundaries.  The check will warn each time a page is requested
> +	  outside node boundaries.
> +
> +	  If unsure, say N
> +
>  config DEBUG_LIST
>  	bool "Debug linked list manipulation"
>  	depends on DEBUG_KERNEL


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
