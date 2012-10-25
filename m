Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936055Ab2JYURn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:17:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50967 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab2JYURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:17:41 -0400
MIME-Version: 1.0
In-Reply-To: <20121025124832.840241082@chello.nl>
References: <20121025121617.617683848@chello.nl> <20121025124832.840241082@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Oct 2012 13:17:19 -0700
X-Google-Sender-Auth: fsNcE9xXVHgNlg_8CrAxRlmB7nI
Message-ID: <CA+55aFxRh43832cEW39t0+d1Sdz46Up6Za9w641jpWukmi4zFw@mail.gmail.com>
Subject: Re: [PATCH 05/31] x86/mm: Reduce tlb flushes from ptep_set_access_flags()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 5:16 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> From: Rik van Riel <riel@redhat.com>
>
> @@ -306,11 +306,26 @@ int ptep_set_access_flags(struct vm_area
>                           pte_t entry, int dirty)
>  {
>         int changed = !pte_same(*ptep, entry);
> +       /*
> +        * If the page used to be inaccessible (_PAGE_PROTNONE), or
> +        * this call upgrades the access permissions on the same page,
> +        * it is safe to skip the remote TLB flush.
> +        */
> +       bool flush_remote = false;
> +       if (!pte_accessible(*ptep))
> +               flush_remote = false;
> +       else if (pte_pfn(*ptep) != pte_pfn(entry) ||
> +                       (pte_write(*ptep) && !pte_write(entry)) ||
> +                       (pte_exec(*ptep) && !pte_exec(entry)))
> +               flush_remote = true;
>
>         if (changed && dirty) {

Did anybody ever actually look at this sh*t-for-brains patch?

Yeah, I'm grumpy. But I'm wasting time looking at patches that have
new code in them that is stupid and retarded.

This is the VM, guys, we don't add stupid and retarded code.

LOOK at the code, for chrissake. Just look at it. And if you don't see
why the above is stupid and retarded, you damn well shouldn't be
touching VM code.

              Linus
