Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0KXOps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:45:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45576 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0KXOpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:45:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=viSyFpJmwea4UCpWjhmI59pQh0nLternWLyfzq6uy8p1Pf2hxpDb7f/DisEYnQmDa6
         NKTVWxPjV26Za8OH7WWCNfSI6qkwrVzQVt/DDFUOzGyKDPtfD7e0PeXVA3DOusCCUb9L
         4Uy/AhwoeBNk/+PMHwnM1GtVXMZ7XFOLNiSDc=
Date: Wed, 24 Nov 2010 12:45:40 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: tom.leiming@gmail.com
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 1/2] perf:tools: avoid to create much more maps for
 kernel symbols on ARM
Message-ID: <20101124144540.GB15875@ghostprotocols.net>
References: <1290598502-31727-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290598502-31727-1-git-send-email-tom.leiming@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 24, 2010 at 07:35:02PM +0800, tom.leiming@gmail.com escreveu:
> From: Ming Lei <tom.leiming@gmail.com>
 
> On ARM, module addresss space is ahead of kernel space, so the module
> symbols are handled before kernel symbol in dso__split_kallsyms, then
> cause one map is created for each kernel symbol.
 
> This patch fixes the issue by restoring to original kernel map in
> dso__split_kallsyms() to avoid create unnecessary maps for kernel
> symbols when starting to handle kenel symbol maps but after module
> symbol maps are handled over.

Can you try with the following patch instead?

- Arnaldo

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b39f499..a7518d2 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -530,7 +530,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 	struct machine *machine = kmaps->machine;
 	struct map *curr_map = map;
 	struct symbol *pos;
-	int count = 0;
+	int count = 0, moved = 0;	
 	struct rb_root *root = &self->symbols[map->type];
 	struct rb_node *next = rb_first(root);
 	int kernel_range = 0;
@@ -588,6 +588,11 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			char dso_name[PATH_MAX];
 			struct dso *dso;
 
+			if (count == 0) {
+				curr_map = map;
+				goto filter_symbol;
+			}
+
 			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
@@ -613,7 +618,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			map_groups__insert(kmaps, curr_map);
 			++kernel_range;
 		}
-
+filter_symbol:
 		if (filter && filter(curr_map, pos)) {
 discard_symbol:		rb_erase(&pos->rb_node, root);
 			symbol__delete(pos);
@@ -621,8 +626,9 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 			if (curr_map != map) {
 				rb_erase(&pos->rb_node, root);
 				symbols__insert(&curr_map->dso->symbols[curr_map->type], pos);
-			}
-			count++;
+				++moved;
+			} else
+				++count;
 		}
 	}
 
@@ -632,7 +638,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 		dso__set_loaded(curr_map->dso, curr_map->type);
 	}
 
-	return count;
+	return count + moved;
 }
 
 int dso__load_kallsyms(struct dso *self, const char *filename,
