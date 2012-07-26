Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab2GZUjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:39:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:39164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2GZUjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:39:37 -0400
Message-ID: <1343335169.32120.18.camel@twins>
Subject: Re: [RFC] page-table walkers vs memory order
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 26 Jul 2012 22:39:29 +0200
In-Reply-To: <alpine.LSU.2.00.1207241356350.2094@eggly.anvils>
References: <1343064870.26034.23.camel@twins>
	 <alpine.LSU.2.00.1207241356350.2094@eggly.anvils>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 14:51 -0700, Hugh Dickins wrote:
> I do love the status quo, but an audit would be welcome.  When
> it comes to patches, personally I tend to prefer ACCESS_ONCE() and
> smp_read_barrier_depends() and accompanying comments to be hidden away
> in the underlying macros or inlines where reasonable, rather than
> repeated all over; but I may have my priorities wrong on that.
> 
> 
Yeah, I was being lazy, and I totally forgot to actually look at the
alpha code.

How about we do a generic (cribbed from rcu_dereference):

#define page_table_deref(p)					\
({								\
	typeof(*p) *______p = (typeof(*p) __force *)ACCESS_ONCE(p);\
	smp_read_barrier_depends();				\
	((typeof(*p) __force __kernel *)(______p));		\
})

and use that all over to dereference page-tables. That way all this
lives in one place. Granted, I'll have to go edit all arch code, but I
seem to be doing that on a frequent basis anyway :/


