Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab0IRTxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:53:51 -0400
Received: from kroah.org ([198.145.64.141]:51357 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab0IRTBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:39 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:56 2010
Message-Id: <20100918185956.759306842@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Swiecki <swiecki@google.com>, Eugene Teo <eugene@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [046/123] tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=tracing-t_start-reset-ftrace_iter_hash-in-case-of-seek-pread.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

commit df09162550fbb53354f0c88e85b5d0e6129ee9cc upstream.

Be sure to avoid entering t_show() with FTRACE_ITER_HASH set without
having properly started the iterator to iterate the hash.  This case is
degenerate and, as discovered by Robert Swiecki, can cause t_hash_show()
to misuse a pointer.  This causes a NULL ptr deref with possible security
implications.  Tracked as CVE-2010-3079.

Cc: Robert Swiecki <swiecki@google.com>
Cc: Eugene Teo <eugene@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/ftrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1480,6 +1480,8 @@ static void *t_start(struct seq_file *m,
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
+		/* reset in case of seek/pread */
+		iter->flags &= ~FTRACE_ITER_HASH;
 		return iter;
 	}
 


