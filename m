Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab1C3VJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:9067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965000Ab1C3VJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133925"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: kees.cook@canonical.com, ak@linux.intel.com, adobriyan@gmail.com,
        dhowells@redhat.com, eugeneteo@kernel.sg, schwidefsky@de.ibm.com,
        spender@grsecurity.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [229/275] proc: protect mm start_code/end_code in /proc/pid/stat
Message-Id: <20110330210754.CFC573E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kees Cook <kees.cook@canonical.com>

commit 5883f57ca0008ffc93e09cbb9847a1928e50c6f3 upstream.

While mm->start_stack was protected from cross-uid viewing (commit
f83ce3e6b02d5 ("proc: avoid information leaks to non-privileged
processes")), the start_code and end_code values were not.  This would
allow the text location of a PIE binary to leak, defeating ASLR.

Note that the value "1" is used instead of "0" for a protected value since
"ps", "killall", and likely other readers of /proc/pid/stat, take
start_code of "0" to mean a kernel thread and will misbehave.  Thanks to
Brad Spengler for pointing this out.

Addresses CVE-2011-0726

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/array.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/fs/proc/array.c
===================================================================
--- linux-2.6.35.y.orig/fs/proc/array.c	2011-03-29 23:03:00.892277339 -0700
+++ linux-2.6.35.y/fs/proc/array.c	2011-03-29 23:03:02.997223479 -0700
@@ -489,8 +489,8 @@
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
