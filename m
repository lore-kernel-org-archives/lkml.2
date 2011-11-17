Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1KQX2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:28:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1KQX2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:28:43 -0500
Date: Thu, 17 Nov 2011 15:28:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 2/2] hugetlb: Provide safer dummy values for
 HPAGE_MASK and HPAGE_SIZE
Message-Id: <20111117152841.dc962d9d.akpm@linux-foundation.org>
In-Reply-To: <1321567050-13197-3-git-send-email-ddaney.cavm@gmail.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
	<1321567050-13197-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 13:57:30 -0800
David Daney <ddaney.cavm@gmail.com> wrote:

> From: David Daney <david.daney@cavium.com>
> 
> It was pointed out by David Rientjes that the dummy values for
> HPAGE_MASK and HPAGE_SIZE are quite unsafe.  It they are inadvertently
> used with !CONFIG_HUGETLB_PAGE, compilation would succeed, but the
> resulting code would surly not do anything sensible.
> 
> Place BUG() in the these dummy definitions, as we do in similar
> circumstances in other places, so any abuse can be easily detected.
> 
> Since the only sane place to use these symbols when
> !CONFIG_HUGETLB_PAGE is on dead code paths, the BUG() cause any actual
> code to be emitted by the compiler.

I assume you meant "omitted" here.

But I don't think it's true.  Any such code would occur after testing
is_vm_hugetlb_page() or similar, and would have been omitted anyway.

> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -111,8 +111,9 @@ static inline void copy_huge_page(struct page *dst, struct page *src)
>  #define hugetlb_change_protection(vma, address, end, newprot)
>  
>  #ifndef HPAGE_MASK
> -#define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
> -#define HPAGE_SIZE	PAGE_SIZE
> +/* Keep the compiler happy with some dummy (but BUGgy) values */

That's a quite poor comment.  This?

--- a/include/linux/hugetlb.h~hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix
+++ a/include/linux/hugetlb.h
@@ -111,7 +111,11 @@ static inline void copy_huge_page(struct
 #define hugetlb_change_protection(vma, address, end, newprot)
 
 #ifndef HPAGE_MASK
-/* Keep the compiler happy with some dummy (but BUGgy) values */
+/*
+ * HPAGE_MASK and friends are defined if !CONFIG_HUGETLB_PAGE as an
+ * ifdef-avoiding convenience.  However they should never be evaluated at
+ * runtime if !CONFIG_HUGETLB_PAGE.
+ */
 #define HPAGE_MASK	({BUG(); 0; })
 #define HPAGE_SIZE	({BUG(); 0; })
 #define HPAGE_SHIFT	({BUG(); 0; })
_

> +#define HPAGE_MASK	({BUG(); 0; })
> +#define HPAGE_SIZE	({BUG(); 0; })
>  #define HPAGE_SHIFT	({BUG(); 0; })

This change means that HPAGE_* cannot be evaluated at compile time.  So

int foo = HPAGE_SIZE;

outside functions will explode.  I guess that's OK - actually desirable
- as such code shouldn't have been compiled anyway.



