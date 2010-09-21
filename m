Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0IUOhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:37:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab0IUOhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:37:05 -0400
Date: Tue, 21 Sep 2010 10:35:55 -0400
From: Jason Baron <jbaron@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
Message-ID: <20100921143555.GA2873@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com> <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com> <20100921131232.GA3024@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921131232.GA3024@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 03:12:32PM +0200, Andi Kleen wrote:
> On Fri, Sep 17, 2010 at 11:09:00AM -0400, Jason Baron wrote:
> > +extern void arch_jump_label_transform(struct jump_entry *entry,
> > +				 enum jump_label_type type);
> > +extern void jump_label_update(unsigned long key, enum jump_label_type type);
> > +extern void jump_label_apply_nops(struct module *mod);
> > +extern void arch_jump_label_text_poke_early(jump_label_t addr);
> 
> These function names are too long.
> 
> Also it would be better if the types for the pointers are kept
> instead of casting to unsigned long. All the variables
> are ints right?
> 

So far, yes. But I didn't want to force this, in case the users of the
API wanted to use other types. But I'm ok with 'int *' here.

> > +#define JUMP_LABEL_HASH_BITS 6
> > +#define JUMP_LABEL_TABLE_SIZE (1 << JUMP_LABEL_HASH_BITS)
> > +static struct hlist_head jump_label_table[JUMP_LABEL_TABLE_SIZE];
> 
> It's not clear to me why this hash table is needed. There should
> not be that many trace points, is it that big a problem to simply
> walk all the sections when something is changed?
> 
> Or maybe the sections could be just sorted and a binary search used
> like with exception tables.
> 
> I suspect that would simplify a lot of code.
> 
> Overall I like the idea, but the current code is too complicated
> for the benefit I think.
> 
> Can it be put on a diet?
> 
> -Andi

So there are ~150 tracepoints, but this code is also being proposed for
use with 'dynamic debug' of which there are > 1000, and I'm hoping for
more users moving forward.

Also, I think the hash table deals nicely with modules. I create a
linked list of only those module sections that are relevant to each hash
bucket. If you search through all the section on each enable/disable,
its going to be proportional to the number of modules as well.

thanks,

-Jason
