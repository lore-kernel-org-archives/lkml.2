Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab2EaUZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:25:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab2EaUZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:25:16 -0400
Date: Thu, 31 May 2012 13:25:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>, hughd@google.com, npiggin@gmail.com,
        cl@linux.com, lee.schermerhorn@hp.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH v2] tmpfs not interleaving properly
Message-Id: <20120531132515.6af60152.akpm@linux-foundation.org>
In-Reply-To: <4FC7CFEB.5040009@gmail.com>
References: <20120531143916.GA16162@gulag1.americas.sgi.com>
	<4FC7CFEB.5040009@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012 16:09:15 -0400
KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -929,7 +929,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
> >   	/*
> >   	 * alloc_page_vma() will drop the shared policy reference
> >   	 */
> > -	return alloc_page_vma(gfp,&pvma, 0);
> > +	return alloc_page_vma(gfp,&pvma, info->node_offset<<  PAGE_SHIFT );
> 
> 3rd argument of alloc_page_vma() is an address. This is type error.

Well, it's an unsigned long...

But yes, it is conceptually wrong and *looks* weird.  I think we can
address that by overcoming our peculair aversion to documenting our
code, sigh.  This?

--- a/mm/shmem.c~tmpfs-implement-numa-node-interleaving-fix
+++ a/mm/shmem.c
@@ -927,9 +927,12 @@ static struct page *shmem_alloc_page(gfp
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
 
 	/*
-	 * alloc_page_vma() will drop the shared policy reference
+	 * alloc_page_vma() will drop the shared policy reference.
+	 *
+	 * To avoid allocating all tmpfs pages on node 0, we fake up a virtual
+	 * address based on this file's predetermined preferred node.
 	 */
-	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT );
+	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT);
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
_


