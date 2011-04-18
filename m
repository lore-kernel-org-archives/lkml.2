Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1DRDFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 23:05:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1DRDFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 23:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=dV33P8ocsc7S5l2l6zvkhqvJxmKnAeyYGldVjZRFPosy5jrphOcix3CnwU8X7lBEBo
         PbHJ8BCXGtZ+laZoIRKg==
Date: Sun, 17 Apr 2011 20:05:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Shaohua Li <shaohua.li@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH]mmap: avoid unnecessary anon_vma lock
In-Reply-To: <1301277532.3981.25.camel@sli10-conroe>
Message-ID: <alpine.LSU.2.00.1104172003330.22756@sister.anvils>
References: <1301277532.3981.25.camel@sli10-conroe>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Shaohua Li wrote:

> If we only change vma->vm_end, we can avoid taking anon_vma lock even 'insert'
> isn't NULL, which is the case of split_vma.
> From my understanding, we need the lock before because rmap must get the
> 'insert' VMA when we adjust old VMA's vm_end (the 'insert' VMA is linked to
> anon_vma list in __insert_vm_struct before).
> But now this isn't true any more. The 'insert' VMA is already linked to
> anon_vma list in __split_vma(with anon_vma_clone()) instead of
> __insert_vm_struct. There is no race rmap can't get required VMAs.
> So the anon_vma lock is unnecessary, and this can reduce one locking in brk
> case and improve scalability.
> 
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>

I was sceptical at first, but yes, you're right: thanks.
Acked-by: Hugh Dickins <hughd@google.com>

> 
> ---
>  mm/mmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/mm/mmap.c
> ===================================================================
> --- linux.orig/mm/mmap.c	2011-03-24 09:08:27.000000000 +0800
> +++ linux/mm/mmap.c	2011-03-24 09:14:03.000000000 +0800
> @@ -605,7 +605,7 @@ again:			remove_next = 1 + (end > next->
>  	 * lock may be shared between many sibling processes.  Skipping
>  	 * the lock for brk adjustments makes a difference sometimes.
>  	 */
> -	if (vma->anon_vma && (insert || importer || start != vma->vm_start)) {
> +	if (vma->anon_vma && (importer || start != vma->vm_start)) {
>  		anon_vma = vma->anon_vma;
>  		anon_vma_lock(anon_vma);
>  	}
