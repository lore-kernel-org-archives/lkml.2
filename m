Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1BRL3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 06:29:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:33722 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1BRL32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 06:29:28 -0500
Subject: Re: [PATCH 3/3] mm: Simplify anon_vma refcounts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <AANLkTimj1d6QpzuNZ6NJvLDVvvC++mPodggFaBziU8Bj@mail.gmail.com>
References: <20110217161948.045410404@chello.nl>
	 <20110217162124.457572646@chello.nl>
	 <AANLkTimj1d6QpzuNZ6NJvLDVvvC++mPodggFaBziU8Bj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 12:30:35 +0100
Message-ID: <1298028635.5226.685.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 10:30 -0800, Linus Torvalds wrote:
> On Thu, Feb 17, 2011 at 8:19 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > +void __put_anon_vma(struct anon_vma *anon_vma)
> > +{
> > +       if (anon_vma->root != anon_vma)
> > +               put_anon_vma(anon_vma->root);
> > +       anon_vma_free(anon_vma);
> >  }
> 
> So this makes me nervous. It looks like recursion.
> 
> Now, I don't think we can ever get a chain of these things (because
> the root should be the root of everything),

Exactly.

>  but I still preferred the
> older code that made that "one-level root" case explicit, and didn't
> have recursion.
> 
> IOW, even though it should be entirely equivalent, I think I'd really
> prefer something like
> 
>   void __put_anon_vma(struct anon_vma *anon_vma)
>   {
>     struct anon_vma *root = anon_vma->root;
> 
>     if (root != anon_vma && atomic_dec_and_test(&root->refcount))
>       anon_vma_free(root);
>     anon_vma_free(anon_vma);
>   }
> 
> instead. Exactly because it makes it very clear that the "root" is a
> root, and we're not doing some possibly arbitrarily deep list like the
> dentry tree (which avoids recursion by open-coding its freeing as a
> loop).
> 
> Hmm? (The above is obviously untested, maybe it has some stupid bug)

Looks about right, I'll give it a spin. 

