Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab2KNSBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:01:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35724 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab2KNSBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:01:31 -0500
MIME-Version: 1.0
In-Reply-To: <1352883029-7885-1-git-send-email-mingo@kernel.org>
References: <1352883029-7885-1-git-send-email-mingo@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Nov 2012 10:01:08 -0800
X-Google-Sender-Auth: d_hCFLknlQNPS4rQl2q8nD4M4Tc
Message-ID: <CA+55aFz_JnoR73O46YWhZn2A4t_CSUkGzMMprCUpvR79TVMCEQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] change_protection(): Count the number of pages affected
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 12:50 AM, Ingo Molnar <mingo@kernel.org> wrote:
> What do you guys think about this mprotect() optimization?

Hmm..

If this is mainly about just avoiding the TLB flushing, I do wonder if
it might not be more interesting to try to be much more aggressive.

As noted elsewhere, we should just notice when vm_page_prot doesn't
change at all - even if 'flags' change, it is possible that the actual
low-level page protection bits do not (due to the X=R issue).

But even *more* aggressively, how about looking at

 - not flushing the TLB at all if the bits become  more permissive
(taking the TLB micro-fault and letting the CPU just update it on its
own)

 - even *more* aggressive: if the bits become strictly more
restrictive, how about not flushing the TLB at all, *and* not even
changing the page tables, and just teaching the page fault code to do
it lazily at fault time?

Now, the "change protections lazily" might actually be a huge
performance problem with the page fault overhead dwarfing any TLB
flush costs, but we don't really know, do we? It might be worth trying
out.

               Linus
