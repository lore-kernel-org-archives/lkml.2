Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1DSUpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:45:31 -0400
Received: from kroah.org ([198.145.64.141]:58985 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab1DSUms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:18 2011
Message-Id: <20110419204118.837200557@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:30:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: [20/28] next_pidmap: fix overflow condition
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 include/linux/pid.h |    2 +-
 kernel/pid.c        |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -117,7 +117,7 @@ extern struct pid *find_vpid(int nr);
  */
 extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
-int next_pidmap(struct pid_namespace *pid_ns, int last);
+int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -182,11 +182,14 @@ static int alloc_pidmap(struct pid_names
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


