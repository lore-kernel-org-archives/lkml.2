Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0KXAAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:00:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37283 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab0KXAAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:00:34 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=UaNWXry1k3EA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=NLwZnATxghb4xyrAVV8A:9 a=0kpbyiTMGpHQedcnu3UA:7 a=z84xeTM9nBZ-mSswjy9mMQkbqDkA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=g2S-Y9ntAuOr0qc0:21 a=F_sjLIc0uwHTlX4L:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
 label key entries
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101123234355.GA21549@Krystal>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
	 <20101123234355.GA21549@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 19:00:30 -0500
Message-ID: <1290556830.30543.415.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 18:43 -0500, Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
> [...]
> > +static void update_jump_label_module(struct module *mod)
> > +{
> > +	struct hlist_head *head;
> > +	struct hlist_node *node, *node_next, *module_node, *module_node_next;
> > +	struct jump_label_entry *e;
> > +	struct jump_label_module_entry *e_module;
> > +	struct jump_entry *iter;
> > +	int i, count;
> > +
> > +	/* if the module doesn't have jump label entries, just return */
> > +	if (!mod->num_jump_entries)
> > +		return;
> > +
> > +	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> > +		head = &jump_label_table[i];
> > +		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> > +			if (!e->enabled)
> > +				continue;
> > +			hlist_for_each_entry_safe(e_module, module_node,
> > +						  module_node_next,
> > +						  &(e->modules), hlist) {
> > +				if (e_module->mod != mod)
> > +					continue;
> 
> Ouch.
> 
> Could you iterate on the loaded/unloaded module jump labels and do hash
> table lookups rather than doing this O(n^3) iteration ?

This does not look O(n^3) to me.

It's a hash table, thus the first two loops is just iterating O(n) items
in the hash.

And the third loop is all the modules that use a particular event.

So it is O(n*m)  where n is the number of events, and m is the number of
modules attached to the events. And that's only if all events are used
by those modules. The actual case is much smaller.

-- Steve


