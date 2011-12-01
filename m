Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1LAWIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:08:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:51256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab1LAWIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:08:47 -0500
Message-ID: <1322777299.4699.57.camel@twins>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Date: Thu, 01 Dec 2011 23:08:19 +0100
In-Reply-To: <20111201211350.GD2443@redhat.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20111201154036.GA2443@redhat.com> <1322756898.4699.30.camel@twins>
	 <20111201165009.GB2443@redhat.com> <1322761185.4699.47.camel@twins>
	 <20111201211350.GD2443@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 16:13 -0500, Jason Baron wrote:

> I think what you have below should work modulo the no out-of-line
> branches and the following change:
> 
> > -			if (neg)
> > +			if (neg) {
> >  				sysctl_sched_features &= ~(1UL << i);
> > -			else
> > +#ifdef HAVE_JUMP_LABEL
> > +				if (!jump_label_enabled(&sched_feat_keys[i]))
> > +					jump_label_inc(&sched_feat_keys[i]);
> > +#endif
> 
> I think here its:
> 			if (jump_label_enabled())
> 				jump_label_dec();
> 
> 
> > +			} else {
> >  				sysctl_sched_features |= (1UL << i);
> > +#ifdef HAVE_JUMP_LABEL
> > +				if (jump_label_enabled(&sched_feat_keys[i]))
> > +					jump_label_dec(&sched_feat_keys[i]);
> > +#endif
> > +			}
> 
> Same here:
> 			if (!jump_label_enabled())
> 				jump_label_inc()

Gah, right. An earlier version used !static_branch().

> 
> The inc/dec behavior we have now, in fact will only mess up in the case
> where we define 'static_branch_true()'. Because then, in that case the
> jump_label_inc() will cause a jump to the false branch. So as long as we
> don't introduce 'static_branch_true()' and do an early setting of those
> branches which are true via __init code as you have here, I think things are
> correct.

That's with your definition of static_branch_true(). Not mine :-)

Mine simply doesn't out-of-line the branch, and ideally has a
jump_label_key initializer that initializes to true (1) and has gcc
generate right code.

I can do the initializer, something like the below. What I cannot do is
make gcc generate the enabled case so we don't have the small nop window
(although with the below I'm not sure it really matters).

But the more important point is not getting the branch out-of-line.

---
Index: linux-2.6/include/linux/jump_label.h
===================================================================
--- linux-2.6.orig/include/linux/jump_label.h
+++ linux-2.6/include/linux/jump_label.h
@@ -128,4 +128,6 @@ static inline void jump_label_rate_limit
 }
 #endif	/* HAVE_JUMP_LABEL */
 
+#define jump_label_key_true	((struct jump_label_key){ .enabled = ATOMIC_INIT(1), })
+
 #endif	/* _LINUX_JUMP_LABEL_H */
Index: linux-2.6/kernel/jump_label.c
===================================================================
--- linux-2.6.orig/kernel/jump_label.c
+++ linux-2.6/kernel/jump_label.c
@@ -248,8 +248,13 @@ void jump_label_apply_nops(struct module
 	if (iter_start == iter_stop)
 		return;
 
-	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		struct jump_label_key *iterk;
+
+		iterk = (struct jump_label_key *)(unsigned long)iter->key;
+		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
+				JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+	}
 }
 
 static int jump_label_add_module(struct module *mod)
@@ -289,8 +294,7 @@ static int jump_label_add_module(struct
 		key->next = jlm;
 
 		if (jump_label_enabled(key))
-			__jump_label_update(key, iter, iter_stop,
-					    JUMP_LABEL_ENABLE);
+			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_ENABLE);
 	}
 
 	return 0;

