Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0KXSZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:25:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab0KXSZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:25:13 -0500
Date: Wed, 24 Nov 2010 13:24:25 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu, peterz@infradead.org,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
	label key entries
Message-ID: <20101124182424.GF2815@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com> <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com> <20101123234355.GA21549@Krystal> <1290556830.30543.415.camel@gandalf.stny.rr.com> <20101124002411.GA29158@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101124002411.GA29158@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 07:24:11PM -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Tue, 2010-11-23 at 18:43 -0500, Mathieu Desnoyers wrote:
> > > * Jason Baron (jbaron@redhat.com) wrote:
> > > [...]
> > > > +static void update_jump_label_module(struct module *mod)
> > > > +{
> > > > +	struct hlist_head *head;
> > > > +	struct hlist_node *node, *node_next, *module_node, *module_node_next;
> > > > +	struct jump_label_entry *e;
> > > > +	struct jump_label_module_entry *e_module;
> > > > +	struct jump_entry *iter;
> > > > +	int i, count;
> > > > +
> > > > +	/* if the module doesn't have jump label entries, just return */
> > > > +	if (!mod->num_jump_entries)
> > > > +		return;
> > > > +
> > > > +	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
> > > > +		head = &jump_label_table[i];
> > > > +		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
> > > > +			if (!e->enabled)
> > > > +				continue;
> > > > +			hlist_for_each_entry_safe(e_module, module_node,
> > > > +						  module_node_next,
> > > > +						  &(e->modules), hlist) {
> > > > +				if (e_module->mod != mod)
> > > > +					continue;
> > > 
> > > Ouch.
> > > 
> > > Could you iterate on the loaded/unloaded module jump labels and do hash
> > > table lookups rather than doing this O(n^3) iteration ?
> > 
> > This does not look O(n^3) to me.
> > 
> > It's a hash table, thus the first two loops is just iterating O(n) items
> > in the hash.
> 
> Good point.
> 
> > 
> > And the third loop is all the modules that use a particular event.
> > 
> > So it is O(n*m)  where n is the number of events, and m is the number of
> > modules attached to the events. And that's only if all events are used
> > by those modules. The actual case is much smaller.
> 
> Still, I wonder if the O(n) iteration on all events could be shrinked to
> an interation on only the events present in the loaded/unloaded module ?
> I think I did something like that for immediate values already. It might
> apply (or not) here, just a thought.
> 
> Thanks,
> 
> Mathieu
> 
> 

indeed. here's a re-spun patch that only iterates over the events in
loaded module.

In practice, at least in my testing, most of these iterations tend to be
O(n), since almost all the tracepoints are used in one location. The
exceptions being kmalloc (which I believe there are patches pending to
put it in a centralized location), and module_get. In addition they are
on the slow module load/unload paths.

thanks,

-Jason

By storing the state of the jump label with each key, we make
sure that when modules are added, they are updated to the correct
state. For example, if the kmalloc tracepoint is enabled and
a module is added which has kmalloc, we make sure that the tracepoint
is properly enabled on module load.

Also, if jump_label_enable(key), is called but the key has not yet
been added to the hashtable of jump label keys, add 'key' to the table.
In this way, if key value has its state updated, but we have not
yet encountered a JUMP_LABEL() definition for it (if its located in
a module), we ensure that the jump label is set to the correct
state when it finally is encountered.

When modules are unloaded, we traverse the jump label hashtable,
and remove any entries that have a key value that is contained
by that module's text section. In this way key values are properly
unregistered, and can be re-used.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/jump_label.c |   71 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 3b79bd9..c27e004 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -26,10 +26,11 @@ static DEFINE_MUTEX(jump_label_mutex);
 struct jump_label_entry {
 	struct hlist_node hlist;
 	struct jump_entry *table;
-	int nr_entries;
 	/* hang modules off here */
 	struct hlist_head modules;
 	unsigned long key;
+	u32 nr_entries : 31,
+	       enabled :  1;
 };
 
 struct jump_label_module_entry {
@@ -108,6 +109,7 @@ add_jump_label_entry(jump_label_t key, int nr_entries, struct jump_entry *table)
 	e->key = key;
 	e->table = table;
 	e->nr_entries = nr_entries;
+	e->enabled = 0;
 	INIT_HLIST_HEAD(&(e->modules));
 	hlist_add_head(&e->hlist, head);
 	return e;
@@ -164,27 +166,37 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
 
 	jump_label_lock();
 	entry = get_jump_label_entry((jump_label_t)key);
-	if (entry) {
-		count = entry->nr_entries;
-		iter = entry->table;
+	if (!entry) {
+		if (type == JUMP_LABEL_ENABLE) {
+			entry = add_jump_label_entry(key, 0, NULL);
+			if (IS_ERR(entry))
+				goto out;
+		} else
+			goto out;
+	}
+	if (type == JUMP_LABEL_ENABLE)
+		entry->enabled = 1;
+	else
+		entry->enabled = 0;
+	count = entry->nr_entries;
+	iter = entry->table;
+	while (count--) {
+		if (kernel_text_address(iter->code))
+			arch_jump_label_transform(iter, type);
+		iter++;
+	}
+	/* enable/disable jump labels in modules */
+	hlist_for_each_entry(e_module, module_node, &(entry->modules),
+						hlist) {
+		count = e_module->nr_entries;
+		iter = e_module->table;
 		while (count--) {
-			if (kernel_text_address(iter->code))
+			if (iter->key && kernel_text_address(iter->code))
 				arch_jump_label_transform(iter, type);
 			iter++;
 		}
-		/* eanble/disable jump labels in modules */
-		hlist_for_each_entry(e_module, module_node, &(entry->modules),
-							hlist) {
-			count = e_module->nr_entries;
-			iter = e_module->table;
-			while (count--) {
-				if (iter->key &&
-						kernel_text_address(iter->code))
-					arch_jump_label_transform(iter, type);
-				iter++;
-			}
-		}
 	}
+out:
 	jump_label_unlock();
 }
 
@@ -305,6 +317,7 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
 			    int count, struct module *mod)
 {
 	struct jump_label_module_entry *e;
+	struct jump_entry *iter;
 
 	e = kmalloc(sizeof(struct jump_label_module_entry), GFP_KERNEL);
 	if (!e)
@@ -313,6 +326,13 @@ add_jump_label_module_entry(struct jump_label_entry *entry,
 	e->nr_entries = count;
 	e->table = iter_begin;
 	hlist_add_head(&e->hlist, &entry->modules);
+	if (entry->enabled) {
+		iter = iter_begin;
+		while (count--) {
+			arch_jump_label_transform(iter, JUMP_LABEL_ENABLE);
+			iter++;
+		}
+	}
 	return e;
 }
 
@@ -360,10 +380,6 @@ static void remove_jump_label_module(struct module *mod)
 	struct jump_label_module_entry *e_module;
 	int i;
 
-	/* if the module doesn't have jump label entries, just return */
-	if (!mod->num_jump_entries)
-		return;
-
 	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
 		head = &jump_label_table[i];
 		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
@@ -375,10 +391,21 @@ static void remove_jump_label_module(struct module *mod)
 					kfree(e_module);
 				}
 			}
+		}
+	}
+	/* now check if any keys can be removed */
+	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
+		head = &jump_label_table[i];
+		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
+			if (!within_module_core(e->key, mod))
+				continue;
 			if (hlist_empty(&e->modules) && (e->nr_entries == 0)) {
 				hlist_del(&e->hlist);
 				kfree(e);
+				continue;
 			}
+			WARN(1, KERN_ERR "jump label: "
+				"tyring to remove used key: %lu !\n", e->key);
 		}
 	}
 }
@@ -470,7 +497,7 @@ void jump_label_apply_nops(struct module *mod)
 
 struct notifier_block jump_label_module_nb = {
 	.notifier_call = jump_label_module_notify,
-	.priority = 0,
+	.priority = 1, /* higher than tracepoints */
 };
 
 static __init int init_jump_label_module(void)
-- 
1.7.1

