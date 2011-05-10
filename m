Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1EJKoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:44:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1EJKoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:44:02 -0400
Date: Tue, 10 May 2011 12:43:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCHv2] jump_label: check entries limit in __jump_label_update
Message-ID: <20110510104346.GC1899@jolsa.brq.redhat.com>
References: <1304523023-7501-1-git-send-email-jolsa@redhat.com>
 <20110509193248.GC2524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509193248.GC2524@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 03:32:48PM -0400, Jason Baron wrote:
> On Wed, May 04, 2011 at 05:30:23PM +0200, Jiri Olsa wrote:
> > When iterating the jump_label entries array (core or modules),
> > the __jump_label_update function peeks over the last entry.
> > 
> > The reason is that the end of the for loop depends on the key
> > value of the processed entry. Thus when going through the
> > last array entry, we will touch the memory behind the array
> > limit.
> > 
> > This bug probably will never be triggered, since most likely the
> > memory behind the jump_label entries will be accesable and the
> > entry->key will be different than the expected value.
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/jump_label.c |   17 ++++++++++++-----
> >  1 files changed, 12 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/jump_label.c b/kernel/jump_label.c
> > index 74d1c09..b2ee97a 100644
> > --- a/kernel/jump_label.c
> > +++ b/kernel/jump_label.c
> > @@ -105,9 +105,12 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
> >  }
> >  
> >  static void __jump_label_update(struct jump_label_key *key,
> > -		struct jump_entry *entry, int enable)
> > +				struct jump_entry *entry,
> > +				struct jump_entry *stop, int enable)
> >  {
> > -	for (; entry->key == (jump_label_t)(unsigned long)key; entry++) {
> > +	for (; (entry < stop) &&
> > +	      (entry->key == (jump_label_t)(unsigned long)key);
> > +	      entry++) {
> >  		/*
> >  		 * entry->code set to 0 invalidates module init text sections
> >  		 * kernel_text_address() verifies we are not in core kernel
> > @@ -158,6 +161,7 @@ early_initcall(jump_label_init);
> >  struct jump_label_mod {
> >  	struct jump_label_mod *next;
> >  	struct jump_entry *entries;
> > +	struct jump_entry *entries_stop;
> >  	struct module *mod;
> >  };
> >  
> > @@ -181,7 +185,8 @@ static void __jump_label_mod_update(struct jump_label_key *key, int enable)
> >  	struct jump_label_mod *mod = key->next;
> >  
> >  	while (mod) {
> > -		__jump_label_update(key, mod->entries, enable);
> > +		__jump_label_update(key, mod->entries, mod->entries_stop,
> > +				    enable);
> >  		mod = mod->next;
> 
> hmmm. Instead of adding a new field to the 'struct jump_label_mod' data
> structure (and thus increasing its footprint), why not use:
> mod->jump_entries +  mod->num_jump_entries here?

yep, overlooked the struct module pointer inside jump_label_mod
attaching new patch

thanks,
jirka
 
---
When iterating the jump_label entries array (core or modules),
the __jump_label_update function peeks over the last entry.

The reason is that the end of the for loop depends on the key
value of the processed entry. Thus when going through the
last array entry, we will touch the memory behind the array
limit.

This bug probably will never be triggered, since most likely the
memory behind the jump_label entries will be accesable and the
entry->key will be different than the expected value.


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/jump_label.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 74d1c09..fa27e75 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -105,9 +105,12 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
 }
 
 static void __jump_label_update(struct jump_label_key *key,
-		struct jump_entry *entry, int enable)
+				struct jump_entry *entry,
+				struct jump_entry *stop, int enable)
 {
-	for (; entry->key == (jump_label_t)(unsigned long)key; entry++) {
+	for (; (entry < stop) &&
+	      (entry->key == (jump_label_t)(unsigned long)key);
+	      entry++) {
 		/*
 		 * entry->code set to 0 invalidates module init text sections
 		 * kernel_text_address() verifies we are not in core kernel
@@ -181,7 +184,11 @@ static void __jump_label_mod_update(struct jump_label_key *key, int enable)
 	struct jump_label_mod *mod = key->next;
 
 	while (mod) {
-		__jump_label_update(key, mod->entries, enable);
+		struct module *m = mod->mod;
+
+		__jump_label_update(key, mod->entries,
+				    m->jump_entries + m->num_jump_entries,
+				    enable);
 		mod = mod->next;
 	}
 }
@@ -245,7 +252,8 @@ static int jump_label_add_module(struct module *mod)
 		key->next = jlm;
 
 		if (jump_label_enabled(key))
-			__jump_label_update(key, iter, JUMP_LABEL_ENABLE);
+			__jump_label_update(key, iter, iter_stop,
+					    JUMP_LABEL_ENABLE);
 	}
 
 	return 0;
@@ -371,7 +379,7 @@ static void jump_label_update(struct jump_label_key *key, int enable)
 
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, enable);
+		__jump_label_update(key, entry, __stop___jump_table, enable);
 
 #ifdef CONFIG_MODULES
 	__jump_label_mod_update(key, enable);
-- 
1.7.1

