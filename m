Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1GOT7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 15:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab1GOT7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 15:59:11 -0400
Date: Fri, 15 Jul 2011 15:59:03 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Bart Van Assche <bvanassche@acm.org>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11 re-post] dynamic_debug: use a single printk() to
 emit msgs
Message-ID: <20110715195903.GA7470@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
 <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
 <1310744914.7582.36.camel@Joe-Laptop>
 <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
 <20110715160417.GB2493@redhat.com>
 <CAO+b5-qgrV=gfZAczxfPbGqVtv4ZD_zZHOn-BMVY9wnJytbrtw@mail.gmail.com>
 <1310746580.7582.50.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310746580.7582.50.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 09:16:20AM -0700, Joe Perches wrote:
> X-Scanned-By: MIMEDefang 2.68 on 10.5.110.19
> 
> On Fri, 2011-07-15 at 18:10 +0200, Bart Van Assche wrote:
> > On Fri, Jul 15, 2011 at 6:04 PM, Jason Baron <jbaron@redhat.com> wrote:
> > > yes, but that approach uses 'KERN_CONT'. The point of patch 11/11 is to get rid
> > > of KERN_CONT, which is racy.
> > I know. What I'm trying to explain is that since patch 11/11 modifies
> > dynamic_emit_prefix() such that it writes its output to a buffer there
> > is no longer a need to write into that buffer with a single snprintf()
> > call. Using multiple snprintf() calls is also fine. Hence it is
> > possible to eliminate the two temporary arrays (tid[] and lineno[])
> > from dynamic_emit_prefix() without reintroducing these races.
> 
> Ah, just so.  It's so easy to be narrow minded.
> 
> Jason, you are going to do this yes?
> 

Yes. ok here's Bart's suggestion as re-post. It looks much cleaner to
me...

thanks,

-Jason


We were using KERN_CONT to combine msgs with their prefix. However,
KERN_CONT is not smp safe, in the sense that it can interleave messages.
This interleaving can result in printks coming out at the wrong loglevel.
With the high frequency of printks, that dynamic debug can produce, this
is not desirable.

Thus, make dynamic_emit_prefix(), fill a char buf[64], instead
of doing a printk directly. If we enable printing out of
function, module, line, or pid info, they are placed in this
64 byte buffer. In my testing 64 bytes was enough size to fulfill
all requests. Even if its not, we can match up the printk itself
to see where its from, so to me this is no big deal.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   66 +++++++++++++++++++++------------------------------
 1 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 198d2af..1f11978 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -422,52 +422,46 @@ static int ddebug_exec_query(char *query_string)
 	return 0;
 }
 
-static int dynamic_emit_prefix(const struct _ddebug *descriptor)
+#define PREFIX_SIZE 64
+#define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
+
+static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
 {
-	char tid[sizeof(int) + sizeof(int)/2 + 4];
-	char lineno[sizeof(int) + sizeof(int)/2];
+	int pos = 0;
 
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
+	pos += snprintf(buf + pos, LEFT(pos), "%s", KERN_DEBUG);
+	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
 		if (in_interrupt())
-			snprintf(tid, sizeof(tid), "%s", "<intr> ");
+			pos += snprintf(buf + pos, LEFT(pos), "%s ",
+						"<intr>");
 		else
-			snprintf(tid, sizeof(tid), "[%d] ",
-				 task_pid_vnr(current));
-	} else {
-		tid[0] = 0;
+			pos += snprintf(buf + pos, LEFT(pos), "[%d] ",
+						task_pid_vnr(current));
 	}
+	if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
+		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->modname);
+	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
+		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
+	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
+		pos += snprintf(buf + pos, LEFT(pos), "%d ", desc->lineno);
 
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		snprintf(lineno, sizeof(lineno), "%d", descriptor->lineno);
-	else
-		lineno[0] = 0;
-
-	return printk(KERN_DEBUG "%s%s%s%s%s%s",
-		      tid,
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
-		      descriptor->modname : "",
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
-		      ":" : "",
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
-		      descriptor->function : "",
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
-		      ":" : "",
-		      lineno);
+	return buf;
 }
 
 int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 {
 	va_list args;
 	int res;
+	struct va_format vaf;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
-
-	res = dynamic_emit_prefix(descriptor);
-	res += vprintk(fmt, args);
-
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	res = printk("%s%pV", dynamic_emit_prefix(descriptor, buf), &vaf);
 	va_end(args);
 
 	return res;
@@ -480,18 +474,15 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 	struct va_format vaf;
 	va_list args;
 	int res;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
-
 	vaf.fmt = fmt;
 	vaf.va = &args;
-
-	res = dynamic_emit_prefix(descriptor);
-	res += __dev_printk(KERN_CONT, dev, &vaf);
-
+	res = __dev_printk(dynamic_emit_prefix(descriptor, buf), dev, &vaf);
 	va_end(args);
 
 	return res;
@@ -504,18 +495,15 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 	struct va_format vaf;
 	va_list args;
 	int res;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
-
 	vaf.fmt = fmt;
 	vaf.va = &args;
-
-	res = dynamic_emit_prefix(descriptor);
-	res += __netdev_printk(KERN_CONT, dev, &vaf);
-
+	res = __netdev_printk(dynamic_emit_prefix(descriptor, buf), dev, &vaf);
 	va_end(args);
 
 	return res;
-- 
1.7.5.4

