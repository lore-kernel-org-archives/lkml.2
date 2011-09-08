Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1IHXww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:52:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756247Ab1IHXwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:52:46 -0400
Date: Thu, 8 Sep 2011 16:52:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] dynamic_debug: use a single printk() to emit msgs
Message-Id: <20110908165239.120f25c5.akpm@linux-foundation.org>
In-Reply-To: <c106d5b6978b550e3a98b5425cc2ba00b090c9eb.1314725877.git.jbaron@redhat.com>
References: <cover.1314725877.git.jbaron@redhat.com>
	<c106d5b6978b550e3a98b5425cc2ba00b090c9eb.1314725877.git.jbaron@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 14:28:50 -0400
Jason Baron <jbaron@redhat.com> wrote:

> We were using KERN_CONT to combine msgs with their prefix. However,
> KERN_CONT is not smp safe, in the sense that it can interleave messages.
> This interleaving can result in printks coming out at the wrong loglevel.
> With the high frequency of printks, that dynamic debug can produce, this
> is not desirable.
> 
> Thus, make dynamic_emit_prefix(), fill a char buf[64], instead
> of doing a printk directly. If we enable printing out of
> function, module, line, or pid info, they are placed in this
> 64 byte buffer. In my testing 64 bytes was enough size to fulfill
> all requests. Even if its not, we can match up the printk itself
> to see where its from, so to me this is no big deal.
> 
> ...
>
> +#define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0

This macro will misbehave if passed an expression with side effects and
is rather ugly and didn't actually need to be implemented as a macro at
all.

This?

--- a/lib/dynamic_debug.c~dynamic_debug-use-a-single-printk-to-emit-messages-fix
+++ a/lib/dynamic_debug.c
@@ -423,31 +423,39 @@ static int ddebug_exec_query(char *query
 }
 
 #define PREFIX_SIZE 64
-#define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
+
+static int remaining(int wrote)
+{
+	if (PREFIX_SIZE - wrote > 0)
+		return PREFIX_SIZE - wrote;
+	return 0;
+}
 
 static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
 {
 	int pos_after_tid;
 	int pos = 0;
 
-	pos += snprintf(buf + pos, LEFT(pos), "%s", KERN_DEBUG);
+	pos += snprintf(buf + pos, remaining(pos), "%s", KERN_DEBUG);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
 		if (in_interrupt())
-			pos += snprintf(buf + pos, LEFT(pos), "%s ",
+			pos += snprintf(buf + pos, remaining(pos), "%s ",
 						"<intr>");
 		else
-			pos += snprintf(buf + pos, LEFT(pos), "[%d] ",
+			pos += snprintf(buf + pos, remaining(pos), "[%d] ",
 						task_pid_vnr(current));
 	}
 	pos_after_tid = pos;
 	if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
-		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->modname);
+		pos += snprintf(buf + pos, remaining(pos), "%s:",
+					desc->modname);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
-		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
+		pos += snprintf(buf + pos, remaining(pos), "%s:",
+					desc->function);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		pos += snprintf(buf + pos, LEFT(pos), "%d:", desc->lineno);
+		pos += snprintf(buf + pos, remaining(pos), "%d:", desc->lineno);
 	if (pos - pos_after_tid)
-		pos += snprintf(buf + pos, LEFT(pos), " ");
+		pos += snprintf(buf + pos, remaining(pos), " ");
 	if (pos >= PREFIX_SIZE)
 		buf[PREFIX_SIZE - 1] = '\0';
 
_

