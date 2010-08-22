Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab0HVFtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 01:49:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45606 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0HVFtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 01:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M4hCcgviCP36RMVvq9/MT1BEFm0bbcC7d5ptx0DYT8U1pnxSblhKSonHjkhgOBA+zG
         Q158MOlwgqWvhMxRsGMmr7kjeD2MzLNjX4G/1GL4eKjB7AjFBHjjEdgzGqb5fNzwdu9O
         GlZNX1Rk9Y0uBRf6tHvVHuOWQKl2y+1FEdF7M=
Date: Sun, 22 Aug 2010 07:20:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100822052013.GF5258@nowhere>
References: <20100815225359.GA32152@infradead.org> <20100819005720.GB5324@nowhere> <20100819085700.GB8782@infradead.org> <20100819150422.GA325@ghostprotocols.net> <20100820091645.GA20138@infradead.org> <20100821024713.GD7959@nowhere> <20100821144239.GA31202@infradead.org> <20100821144625.GA19711@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20100821144625.GA19711@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 21, 2010 at 10:46:25AM -0400, Christoph Hellwig wrote:
> On Sat, Aug 21, 2010 at 10:42:39AM -0400, Christoph Hellwig wrote:
> > It does seem to fix the bug for some cases but not all.  Default perf
> > report in TUI and the normal command line seem to get it right.  perf
> > report -g flat still shows the old problem.  perf report -g flat,0.0
> > shows callgraphs, but just as before they just show the 0.<n>
> > percentages.
> 
> -g graph also shows the same issue of not beeing able to expand the
> python line.  It seems like only the fractal case was fixed by that
> patch.
> 


Now does it work with the patch in attachment?
It includes the previous one.

It still needs a few cleanups but the idea is there.
Ah and it applies in tip:perf/core but latest -linus
should be fine.

Thanks.



--YZ5djTAD1cGYuMQK
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="callchain.diff"

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index f231f43..e0b5183 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -379,7 +379,6 @@ static void filter_context(struct ip_callchain *old, struct resolved_chain *new,
 	new->nr = j;
 }
 
-
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		 struct map_symbol *syms, u64 period)
 {
@@ -404,3 +403,71 @@ end:
 
 	return 0;
 }
+
+static int
+merge_chain_branch(struct callchain_node *dst, struct callchain_node *src,
+		   struct ip_callchain *chain, struct map_symbol *syms)
+{
+	struct callchain_node *child;
+	struct callchain_list *list;
+	int old_pos = chain->nr;
+	int err = 0;
+
+	list_for_each_entry(list, &src->val, list) {
+		if (chain->nr == 4096) {
+			err = -ENOSPC;
+			goto out;
+		}
+
+		chain->ips[chain->nr] = list->ip;
+		syms[chain->nr] = list->ms;
+		chain->nr++;
+	}
+
+	if (src->hit)
+		err = append_chain(dst, chain, syms, src->hit);
+
+	if (!err) {
+		chain_for_each_child(child, src) {
+			err = merge_chain_branch(dst, child, chain, syms);
+			if (err)
+				break;
+		}
+	}
+
+out:
+	chain->nr = old_pos;
+
+	return err;
+}
+
+int merge_chain(struct callchain_node *dst, struct callchain_node *src)
+{
+	struct callchain_node *child;
+	struct ip_callchain *chain;
+	struct map_symbol *syms;
+	int err = 0;
+
+	chain = malloc(sizeof(*chain) + 4096 * sizeof(u64));
+	if (!chain)
+		return -ENOMEM;
+
+	chain->nr = 0;
+
+	syms = malloc(sizeof(*syms) * 4096);
+	if (!syms) {
+		free(chain);
+		return -ENOMEM;
+	}
+
+	chain_for_each_child(child, src) {
+		err = merge_chain_branch(dst, child, chain, syms);
+		if (err)
+			break;
+	}
+
+	free(chain);
+	free(syms);
+
+	return err;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 624a96c..da5cd09 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -50,6 +50,7 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->children);
 	INIT_LIST_HEAD(&node->val);
 
+	node->children_hit = 0;
 	node->parent = NULL;
 	node->hit = 0;
 }
@@ -62,6 +63,7 @@ static inline u64 cumul_hits(struct callchain_node *node)
 int register_callchain_param(struct callchain_param *param);
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		 struct map_symbol *syms, u64 period);
+int merge_chain(struct callchain_node *dst, struct callchain_node *src);
 
 bool ip_callchain__valid(struct ip_callchain *chain, const event_t *event);
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index be22ae6..5ba3de7 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -226,6 +226,7 @@ static bool collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 
 		if (!cmp) {
 			iter->period += he->period;
+			merge_chain(iter->callchain, he->callchain);
 			hist_entry__free(he);
 			return false;
 		}

--YZ5djTAD1cGYuMQK--

