Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1CKV2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:28:49 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43891 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab1CKV2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:28:47 -0500
Date: Fri, 11 Mar 2011 13:27:47 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Kees Cook <kees.cook@canonical.com>,
        David Howells <dhowells@redhat.com>, Eugene Teo <eugeneteo@kernel.sg>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] proc: protect mm start_code/end_code in /proc/pid/stat
Message-ID: <20110311212747.GA27618@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While mm->start_stack was protected from cross-uid viewing (commit
f83ce3e6b02d5e48b3a43b001390e2b58820389d), the start_code and end_code
values were not. This would allow the text location of a PIE binary to
leak, defeating ASLR.

Note that the value "1" is used instead of "0" for a protected value
since "ps", "killall", and likely other readers of /proc/pid/stat, take
start_code of "0" to mean a kernel thread and will misbehave. Thanks to
Brad Spengler for pointing this out.

CVE-2011-0726

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: stable@kernel.org
---
 fs/proc/array.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 7c99c1c..5e4f776 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -489,8 +489,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		vsize,
 		mm ? get_mm_rss(mm) : 0,
 		rsslim,
-		mm ? mm->start_code : 0,
-		mm ? mm->end_code : 0,
+		mm ? (permitted ? mm->start_code : 1) : 0,
+		mm ? (permitted ? mm->end_code : 1) : 0,
 		(permitted && mm) ? mm->start_stack : 0,
 		esp,
 		eip,
-- 
1.7.4.1

-- 
Kees Cook
Ubuntu Security Team
