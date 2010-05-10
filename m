Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0EJIHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:07:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:48172 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab0EJIHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:07:04 -0400
Date: Mon, 10 May 2010 17:06:20 +0900
To: catalin.marinas@arm.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org,
       davem@davemloft.net, rmk@arm.linux.org.uk
Subject: Re: [RFC PATCH] Update the cachetlb.txt file WRT flush_dcache_page
 and update_mmu_cache
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100507132418.28009.6013.stgit@e102109-lin.cambridge.arm.com>
References: <20100507132418.28009.6013.stgit@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100510170616O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 10 May 2010 17:06:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 May 2010 14:24:18 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

>    void flush_dcache_page(struct page *page)
>  
> -	Any time the kernel writes to a page cache page, _OR_
> +	Any time the kernel modifies an existing page cache page, _OR_
>  	the kernel is about to read from a page cache page and
>  	user space shared/writable mappings of this page potentially
>  	exist, this routine is called.
> @@ -289,20 +295,26 @@ maps this page at its virtual address.
>  	      handling vfs symlinks in the page cache need not call
>  	      this interface at all.
>  
> +	      The kernel may not call this function on a newly allocated
> +	      page cache page even though it stored data into the page.
> +
>  	The phrase "kernel writes to a page cache page" means,
>  	specifically, that the kernel executes store instructions
>  	that dirty data in that page at the page->virtual mapping
>  	of that page.  It is important to flush here to handle
>  	D-cache aliasing, to make sure these kernel stores are
> -	visible to user space mappings of that page.
> +	visible to user space mappings of that page. It is also
> +	important to flush the cache on Harvard architectures where the
> +	I and D caches are not coherent.
>  
>  	The corollary case is just as important, if there are users
>  	which have shared+writable mappings of this file, we must make
>  	sure that kernel reads of these pages will see the most recent
>  	stores done by the user.
>  
> -	If D-cache aliasing is not an issue, this routine may
> -	simply be defined as a nop on that architecture.
> +	If D-cache aliasing is not an issue and the I and D caches are
> +	unified, this routine may simply be defined as a nop on that
> +	architecture.
>  
>          There is a bit set aside in page->flags (PG_arch_1) as
>  	"architecture private".  The kernel guarantees that,
> @@ -312,15 +324,15 @@ maps this page at its virtual address.
>  	This allows these interfaces to be implemented much more
>  	efficiently.  It allows one to "defer" (perhaps indefinitely)
>  	the actual flush if there are currently no user processes
> -	mapping this page.  See sparc64's flush_dcache_page and
> -	update_mmu_cache implementations for an example of how to go
> +	mapping this page.  See IA-64's flush_dcache_page and
> +	set_pte_at implementations for an example of how to go
>  	about doing this.

cachetlb.txt says that flush_dcache_page() is the API to solve the
D-cache aliasing issue. Using IA64 as an example for the API here
looks strange since IA64 (PIPT) doesn't have D-cache aliasing
issue.

I don't think that just replacing sparc64 with IA64 helps much here
since we still have the problem that the whole cache handling
(architectures, subsystems, file systems) is inconsistent. I think
that we need to agree on it first.
