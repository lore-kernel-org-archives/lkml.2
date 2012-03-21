Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab2CUVQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:16:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61339 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759861Ab2CUVQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:16:53 -0400
Message-Id: <20120321211448.584861997@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 21 Mar 2012 14:14:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Ahern <dsahern@gmail.com>,
        Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [ 4/8] perf tools: Incorrect use of snprintf results in SEGV
In-Reply-To: <20120321211522.GA28233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit b832796caa1fda8516464a003c8c7cc547bc20c2 upstream.

I have a workload where perf top scribbles over the stack and we SEGV.
What makes it interesting is that an snprintf is causing this.

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
than size, we pass a negative size into the second snprintf and happily
scribble over the stack. If you have 3000 character c++ methods thats a
lot of stack to trample.

This patch fixes repsep_snprintf by clamping the value at size - 1 which
is the maximum snprintf can write before adding the NULL terminator.

I get the sinking feeling that there are a lot of other uses of snprintf
that have this same bug, we should audit them all.

Cc: David Ahern <dsahern@gmail.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Link: http://lkml.kernel.org/r/20120307114249.44275ca3@kryten
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/sort.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -122,6 +122,9 @@ static int repsep_snprintf(char *bf, siz
 		}
 	}
 	va_end(ap);
+
+	if (n >= (int)size)
+		return size - 1;
 	return n;
 }
 


