Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1I0R5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:57:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63582 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1I0R5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:57:34 -0400
Date: Tue, 27 Sep 2011 21:56:42 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-hardening@lists.openwall.com,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: restrict access to /proc/meminfo
Message-ID: <20110927175642.GA3432@albatros>
References: <20110927175453.GA3393@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927175453.GA3393@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/meminfo stores information related to memory pages usage, which
may be used to monitor the number of objects in specific caches (and/or
the changes of these numbers).  This might reveal private information
similar to /proc/slabinfo infoleaks.  To remove the infoleak, just
restrict meminfo to root.  If it is used by unprivileged daemons,
meminfo permissions can be altered the same way as slabinfo:

    groupadd meminfo
    usermod -a -G meminfo $MONITOR_USER
    chmod g+r /proc/meminfo
    chgrp meminfo /proc/meminfo

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
CC: Kees Cook <kees@ubuntu.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Christoph Lameter <cl@gentwo.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Valdis.Kletnieks@vt.edu
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>
CC: Alan Cox <alan@linux.intel.com>
---
 fs/proc/meminfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 5861741..949bdee 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -187,7 +187,7 @@ static const struct file_operations meminfo_proc_fops = {
 
 static int __init proc_meminfo_init(void)
 {
-	proc_create("meminfo", 0, NULL, &meminfo_proc_fops);
+	proc_create("meminfo", S_IFREG | S_IRUSR, NULL, &meminfo_proc_fops);
 	return 0;
 }
 module_init(proc_meminfo_init);
