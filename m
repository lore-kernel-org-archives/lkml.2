Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0KXAeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:34:17 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:43161 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755581Ab0KXAeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:34:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJbn60xGHlyW/2dsb2JhbACianK+EIVLBIRa
Date: Tue, 23 Nov 2010 19:24:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, peterz@infradead.org,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
	label key entries
Message-ID: <20101124002411.GA29158@Krystal>
References: <cover.1290546539.git.jbaron@redhat.com> <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com> <20101123234355.GA21549@Krystal> <1290556830.30543.415.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1290556830.30543.415.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:22:22 up 230 days, 10:12,  5 users,  load average: 0.18, 0.13,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2010-11-23 at 18:43 -0500, Mathieu Desnoyers wrote:
> > * Jason Baron (jbaron@redhat.com) wrote:
> > [...]
> > > +static void update_jump_label_module(struct module *mod)
> > > +{
> > > +	struct hlist_head *head;
> > > +	struct hlist_node *node, *node_next, *module_node, *module_node_next;
> > > +	struct jump_label_entry *e;
> > > +	struct jump_label_module_entry *e_module;
> > > +	struct jump_entry *iter;
> > > +	int i, count;
> > > +
> > > +	/* if the module doesn't have jump label entries, just return */
> > > +	if (!mod->num_jump_entries)
> > > +		return;
> > > +
> > > +	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> > > +		head = &jump_label_table[i];
> > > +		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> > > +			if (!e->enabled)
> > > +				continue;
> > > +			hlist_for_each_entry_safe(e_module, module_node,
> > > +						  module_node_next,
> > > +						  &(e->modules), hlist) {
> > > +				if (e_module->mod != mod)
> > > +					continue;
> > 
> > Ouch.
> > 
> > Could you iterate on the loaded/unloaded module jump labels and do hash
> > table lookups rather than doing this O(n^3) iteration ?
> 
> This does not look O(n^3) to me.
> 
> It's a hash table, thus the first two loops is just iterating O(n) items
> in the hash.

Good point.

> 
> And the third loop is all the modules that use a particular event.
> 
> So it is O(n*m)  where n is the number of events, and m is the number of
> modules attached to the events. And that's only if all events are used
> by those modules. The actual case is much smaller.

Still, I wonder if the O(n) iteration on all events could be shrinked to
an interation on only the events present in the loaded/unloaded module ?
I think I did something like that for immediate values already. It might
apply (or not) here, just a thought.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
