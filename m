Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab1BQSbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:31:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab1BQSa6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <20110217162124.457572646@chello.nl>
References: <20110217161948.045410404@chello.nl> <20110217162124.457572646@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 10:30:07 -0800
Message-ID: <AANLkTimj1d6QpzuNZ6NJvLDVvvC++mPodggFaBziU8Bj@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: Simplify anon_vma refcounts
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 8:19 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> +void __put_anon_vma(struct anon_vma *anon_vma)
> +{
> +       if (anon_vma->root != anon_vma)
> +               put_anon_vma(anon_vma->root);
> +       anon_vma_free(anon_vma);
>  }

So this makes me nervous. It looks like recursion.

Now, I don't think we can ever get a chain of these things (because
the root should be the root of everything), but I still preferred the
older code that made that "one-level root" case explicit, and didn't
have recursion.

IOW, even though it should be entirely equivalent, I think I'd really
prefer something like

  void __put_anon_vma(struct anon_vma *anon_vma)
  {
    struct anon_vma *root = anon_vma->root;

    if (root != anon_vma && atomic_dec_and_test(&root->refcount))
      anon_vma_free(root);
    anon_vma_free(anon_vma);
  }

instead. Exactly because it makes it very clear that the "root" is a
root, and we're not doing some possibly arbitrarily deep list like the
dentry tree (which avoids recursion by open-coding its freeing as a
loop).

Hmm? (The above is obviously untested, maybe it has some stupid bug)

                   Linus
