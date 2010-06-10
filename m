Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab0FJPpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:45:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab0FJPpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:45:31 -0400
Date: Thu, 10 Jun 2010 11:44:52 -0400
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 02/13] jump label v9: base patch
Message-ID: <20100610154451.GC3923@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
 <ba56ef382c3b1a1d17a21005d5c4eda54cced0bf.1276116186.git.jbaron@redhat.com>
 <20100609223548.GB12752@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609223548.GB12752@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 12:35:49AM +0200, Frederic Weisbecker wrote:
> On Wed, Jun 09, 2010 at 05:38:57PM -0400, Jason Baron wrote:
> > +static int build_jump_label_hashtable(struct jump_entry *start, struct jump_entry *stop)
> > +{
> > +	struct jump_entry *iter, *iter_begin;
> > +	struct jump_label_entry *entry;
> > +	int count;
> > +
> > +	sort_jump_label_entries(start, stop);
> > +	iter = start;
> > +	while (iter < stop) {
> > +		entry = get_jump_label_entry((char *)iter->name);
> > +		if (!entry) {
> > +			iter_begin = iter;
> > +			count = 0;
> > +			while ((iter < stop) &&
> > +				(strcmp((char *)iter->name,
> > +					(char *)iter_begin->name) == 0)) {
> > +				iter++;
> > +				count++;
> > +			}
> 
> 
> 
> 
> So, you can have multiple entries with the same name? How can that happen
> in fact?
> 
> 

this is the case where a single tracepoint such as kmalloc(), is used in
all over the kernel. So, there is one name or key value associated with
a kmalloc tracepoint. however, we have to patch the jump or nop into a
bunch of places in the kernel text.

> 
> 
> > +			entry = add_jump_label_entry((char *)iter_begin->name,
> > +							count, iter_begin);
> > +			if (IS_ERR(entry))
> > +				return PTR_ERR(entry);
> > +			continue;
> > +		}
> > +		WARN(1, KERN_ERR "build_jump_hashtable: unexpected entry!\n");
> 
> 
> 
> It seems you are going to endless loop in this fail case.
> 

agreed. I need to stick that 'WARN' into the else clause of "if
(!entry)" and return an error.

> 
> 
> > +	}
> > +	return 0;
> > +}
> > +
> > +/***
> > + * jump_label_update - update jump label text
> > + * @name - name of the jump label
> > + * @type - enum set to JUMP_LABEL_ENABLE or JUMP_LABEL_DISABLE
> > + *
> > + * Will enable/disable the jump for jump label @name, depending on the
> > + * value of @type.
> > + *
> > + */
> > +
> > +void jump_label_update(const char *name, enum jump_label_type type)
> > +{
> > +	struct jump_entry *iter;
> > +	struct jump_label_entry *entry;
> > +	struct hlist_node *module_node;
> > +	struct jump_label_module_entry *e_module;
> > +	int count;
> > +
> > +	mutex_lock(&jump_label_mutex);
> > +	entry = get_jump_label_entry(name);
> > +	if (entry) {
> > +		count = entry->nr_entries;
> > +		iter = entry->table;
> > +		while (count--) {
> > +			if (kernel_text_address(iter->code))
> > +				arch_jump_label_transform(iter, type);
> > +			iter++;
> > +		}
> 
> 
> 
> So, this is going to patch multiple times the same value on the
> same address in case you have multiple entries for the same name?
> 
> That look weird.

no. as mentioned before, there are multiple text addresses potentially
associated with a single jump label conditional variable. So we need to
patch all of them.

> 
> BTW, if you can't find the entry, you should perhaps propagate an error.
> 
> 
> 
> > +	}
> > +	mutex_unlock(&jump_label_mutex);
> > +}
> > +
> > +static int init_jump_label(void)
> 
> 
> 
> This can be __init.
>

ok.

thanks for the review.

-Jason 
