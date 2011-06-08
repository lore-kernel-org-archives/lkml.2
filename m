Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab1FHEOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 00:14:01 -0400
Received: from mout.perfora.net ([74.208.4.195]:61071 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab1FHEOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 00:14:00 -0400
Date: Wed, 8 Jun 2011 00:12:17 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH v4 3.0-rc2-tip 3/22]  3: uprobes: Adding and remove a
 uprobe in a rb tree.
Message-ID: <20110608041217.GA4879@wicker.gateway.2wire.net>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125850.28590.10861.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607125850.28590.10861.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:zsyVazACadjkK6SAmytmKqFQeG7tR6mhK633f5fqpIu
 Z3bWixEfz0fjfaoWg4ObbtJHAS02oj+au6ZEK+2Ck7aEhAZxEB
 r5IwR1z4sIWWRiJHkDDDW0mRjn3sEJMKd+Mt6nIhZD0hIzUmXS
 XUgTS//E3zU/KscmuC1GqsCGoOHvi2AU5xtOAF81/RKqzzeULg
 A1QVn8/eGQ+POSHnI2OWBWMS4n19EnfhmgWMBa5kRs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Srikar,

On Tue, Jun 07, 2011 at 06:28:50PM +0530, Srikar Dronamraju wrote:
> +/* Called with uprobes_treelock held */
> +static struct uprobe *__find_uprobe(struct inode * inode,
> +			 loff_t offset, struct rb_node **close_match)
> +{
> +	struct uprobe r = { .inode = inode, .offset = offset };
> +	struct rb_node *n = uprobes_tree.rb_node;
> +	struct uprobe *uprobe;
> +	int match, match_inode;
> +
> +	while (n) {
> +		uprobe = rb_entry(n, struct uprobe, rb_node);
> +		match = match_uprobe(uprobe, &r, &match_inode);
> +		if (close_match && match_inode)
> +			*close_match = n;
> +
> +		if (!match) {
> +			atomic_inc(&uprobe->ref);
> +			return uprobe;
> +		}
> +		if (match < 0)
> +			n = n->rb_left;
> +		else
> +			n = n->rb_right;
> +
> +	}
> +	return NULL;
> +}
> +

I think there is a simple mistake in the search logic here.  In particular, I
think the arguments to match_uprobe() should be swapped to give:

	match = match_uprobe(&r, uprobe, NULL)

Otherwise, when we do not have an exact match, the next node to be considered
is the left child of 'uprobe' even though 'uprobe' is "smaller" than r (and
vice versa for the "larger" case).

> +static struct uprobe *__insert_uprobe(struct uprobe *uprobe)
> +{
> +	struct rb_node **p = &uprobes_tree.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct uprobe *u;
> +	int match;
> +
> +	while (*p) {
> +		parent = *p;
> +		u = rb_entry(parent, struct uprobe, rb_node);
> +		match = match_uprobe(u, uprobe, NULL);
> +		if (!match) {
> +			atomic_inc(&u->ref);
> +			return u;
> +		}
> +
> +		if (match < 0)
> +			p = &parent->rb_left;
> +		else
> +			p = &parent->rb_right;
> +
> +	}

I think the match_uprobe() arguments should be swapped here as well for
similar reasons as above.

Also, changing the argument order seems to solve the issue reported by
Josh Stone where only the uprobe with the lowest address was responding
(thou I did not test with perf, just lightly with the trace_event
interface).  In particular, iteration using rb_next() appears to work as
expected, thus allowing all breakpoints to be registered in
mmap_uprobe().

> +	u = NULL;
> +	rb_link_node(&uprobe->rb_node, parent, p);
> +	rb_insert_color(&uprobe->rb_node, &uprobes_tree);
> +	/* get access + drop ref */
> +	atomic_set(&uprobe->ref, 2);
> +	return u;
> +}

-- 
steve

