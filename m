Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab1DZVZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:25:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:60554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab1DZVOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327607"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: torvalds@linux-foundation.org, ebiederm@xmission.com, xemul@openvz.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [72/106] next_pidmap: fix overflow condition
Message-Id: <20110426211353.8C6343E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit c78193e9c7bcbf25b8237ad0dec82f805c4ea69b upstream.

next_pidmap() just quietly accepted whatever 'last' pid that was passed
in, which is not all that safe when one of the users is /proc.

Admittedly the proc code should do some sanity checking on the range
(and that will be the next commit), but that doesn't mean that the
helper functions should just do that pidmap pointer arithmetic without
checking the range of its arguments.

So clamp 'last' to PID_MAX_LIMIT.  The fact that we then do "last+1"
doesn't really matter, the for-loop does check against the end of the
pidmap array properly (it's only the actual pointer arithmetic overflow
case we need to worry about, and going one bit beyond isn't going to
overflow).

[ Use PID_MAX_LIMIT rather than pid_max as per Eric Biederman ]

Reported-by: Tavis Ormandy <taviso@cmpxchg8b.com>
Analyzed-by: Robert Święcki <robert@swiecki.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/pid.h |    2 +-
 kernel/pid.c        |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/include/linux/pid.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/pid.h
+++ linux-2.6.35.y/include/linux/pid.h
@@ -117,7 +117,7 @@ extern struct pid *find_vpid(int nr);
  */
 extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
-int next_pidmap(struct pid_namespace *pid_ns, int last);
+int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
Index: linux-2.6.35.y/kernel/pid.c
===================================================================
--- linux-2.6.35.y.orig/kernel/pid.c
+++ linux-2.6.35.y/kernel/pid.c
@@ -183,11 +183,14 @@ static int alloc_pidmap(struct pid_names
 	return -1;
 }
 
-int next_pidmap(struct pid_namespace *pid_ns, int last)
+int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
 {
 	int offset;
 	struct pidmap *map, *end;
 
+	if (last >= PID_MAX_LIMIT)
+		return -1;
+
 	offset = (last + 1) & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
 	end = &pid_ns->pidmap[PIDMAP_ENTRIES];
