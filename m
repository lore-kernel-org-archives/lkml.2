Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab2JBWBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:01:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab2JBWBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:01:06 -0400
Date: Tue, 2 Oct 2012 15:01:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mhocko@suse.cz, kirill@shutemov.name,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH v2] mm: thp: Set the accessed flag for old pages on
 access fault.
Message-Id: <20121002150104.da57fa94.akpm@linux-foundation.org>
In-Reply-To: <1349197151-19645-1-git-send-email-will.deacon@arm.com>
References: <1349197151-19645-1-git-send-email-will.deacon@arm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Oct 2012 17:59:11 +0100
Will Deacon <will.deacon@arm.com> wrote:

> On x86 memory accesses to pages without the ACCESSED flag set result in the
> ACCESSED flag being set automatically. With the ARM architecture a page access
> fault is raised instead (and it will continue to be raised until the ACCESSED
> flag is set for the appropriate PTE/PMD).
> 
> For normal memory pages, handle_pte_fault will call pte_mkyoung (effectively
> setting the ACCESSED flag). For transparent huge pages, pmd_mkyoung will only
> be called for a write fault.
> 
> This patch ensures that faults on transparent hugepages which do not result
> in a CoW update the access flags for the faulting pmd.

Alas, the code you're altering has changed so much in linux-next that I
am reluctant to force this fix in there myself.  Can you please
redo/retest/resend?  You can do that on 3.7-rc1 if you like, then we
can feed this into -rc2.

> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3524,7 +3524,8 @@ retry:
>  
>  		barrier();
>  		if (pmd_trans_huge(orig_pmd)) {
> -			if (flags & FAULT_FLAG_WRITE &&
> +			int dirty = flags & FAULT_FLAG_WRITE;

`flags' is `unsigned int', so making `dirty' match that is nicer.


