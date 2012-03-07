Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2CGAmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:42:54 -0500
Received: from ozlabs.org ([203.10.76.45]:35742 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab2CGAmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:42:52 -0500
Date: Wed, 7 Mar 2012 11:42:49 +1100
From: Anton Blanchard <anton@samba.org>
To: acme@redhat.com, paulus@samba.org, peterz@infradead.org, mingo@elte.hu,
        dsahern@gmail.com, fweisbec@gmail.com, yanmin_zhang@linux.intel.com,
        emunson@mgebm.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120307114249.44275ca3@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a workload where perf top scribbles over the stack and we
SEGV. What makes it interesting is that an snprintf is causing this.

The workload is a c++ gem that has method names over 3000 characters
long, but snprintf is designed to avoid overrunning buffers. So what
went wrong?

The problem is we assume snprintf returns the number of characters
written:

    ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
...
    ret += repsep_snprintf(bf + ret, size - ret, "%s", self->ms.sym->name);

Unfortunately this is not how snprintf works. snprintf returns the
number of characters that would have been written if there was enough
space. In the above case, if the first snprintf returns a value larger
than size, we pass a negative size into the second snprintf and
happily scribble over the stack. If you have 3000 character c++
methods thats a lot of stack to trample.

This patch fixes repsep_snprintf by clamping the value at size - 1
which is the maximum snprintf can write before adding the NULL
terminator.

I get the sinking feeling that there are a lot of other uses of
snprintf that have this same bug, we should audit them all.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: stable@kernel.org
---

Index: linux-build/tools/perf/util/sort.c
===================================================================
--- linux-build.orig/tools/perf/util/sort.c	2012-03-07 10:58:57.502318907 +1100
+++ linux-build/tools/perf/util/sort.c	2012-03-07 11:00:58.812423271 +1100
@@ -33,6 +33,9 @@ static int repsep_snprintf(char *bf, siz
 		}
 	}
 	va_end(ap);
+
+	if (n >= (int)size)
+		return size - 1;
 	return n;
 }
 
