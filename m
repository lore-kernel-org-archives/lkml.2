Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1FHKhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:37:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45594 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1FHKhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:37:08 -0400
Date: Wed, 8 Jun 2011 15:59:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Josh Stone <jistone@redhat.com>
Cc: Stephen Wilson <wilsons@start.ca>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 3/22]  3: uprobes: Adding and remove a
 uprobe in a rb tree.
Message-ID: <20110608102957.GA10529@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125850.28590.10861.sendpatchset@localhost6.localdomain6>
 <20110608041217.GA4879@wicker.gateway.2wire.net>
 <4DEF1F07.4000400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4DEF1F07.4000400@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Stone <jistone@redhat.com> [2011-06-08 00:04:39]:

> On 06/07/2011 09:12 PM, Stephen Wilson wrote:
> > Also, changing the argument order seems to solve the issue reported by
> > Josh Stone where only the uprobe with the lowest address was responding
> > (thou I did not test with perf, just lightly with the trace_event
> > interface).
> 
> Makes sense, and indeed after swapping the arguments to both calls, the
> perf test I gave now works as expected.  Thanks!
> 
> Josh

Thanks Stephen for the fix and Josh for both reporting and confirming
that the fix works. 

Stephen, Along with the parameter interchange, I also modified the
parameter name so that they dont confuse with the argument names in
match_uprobe.  Otherwise 'r' in __find_uprobe would correspond to 'l' in 
match_uprobe. The result is something like below.

I am resending the faulty patch with the fix and also checked in the fix
into my git tree.

-- 
Thanks and Regards
Srikar

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 95c16dd..72f21db 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -363,14 +363,14 @@ static int match_uprobe(struct uprobe *l, struct uprobe *r, int *match_inode)
 static struct uprobe *__find_uprobe(struct inode * inode,
 			 loff_t offset, struct rb_node **close_match)
 {
-	struct uprobe r = { .inode = inode, .offset = offset };
+	struct uprobe u = { .inode = inode, .offset = offset };
 	struct rb_node *n = uprobes_tree.rb_node;
 	struct uprobe *uprobe;
 	int match, match_inode;
 
 	while (n) {
 		uprobe = rb_entry(n, struct uprobe, rb_node);
-		match = match_uprobe(uprobe, &r, &match_inode);
+		match = match_uprobe(&u, uprobe, &match_inode);
 		if (close_match && match_inode)
 			*close_match = n;
 
@@ -412,7 +412,7 @@ static struct uprobe *__insert_uprobe(struct uprobe *uprobe)
 	while (*p) {
 		parent = *p;
 		u = rb_entry(parent, struct uprobe, rb_node);
-		match = match_uprobe(u, uprobe, NULL);
+		match = match_uprobe(uprobe, u, NULL);
 		if (!match) {
 			atomic_inc(&u->ref);
 			return u;
