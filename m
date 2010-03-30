Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0C3De2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 23:34:28 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52099 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751666Ab0C3De1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 23:34:27 -0400
Date: Mon, 29 Mar 2010 23:34:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, stable <stable@kernel.org>
Subject: [PATCH] lockdep fix incorrect percpu usage
Message-ID: <20100330033425.GD7683@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 23:32:12 up 66 days,  6:09,  4 users,  load average: 0.18, 0.10,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
for per cpu pointers).

git blame points to commit:

lockdep.c: commit 8e18257d29238311e82085152741f0c3aa18b74d

But it's really just moving the code around. But it's enough to say that the
problems appeared before Jul 19 01:48:54 2007, which brings us back to 2.6.23.

So it should be applied to stable 2.6.23.x to 2.6.33.x (or whichever of these
stable branches are still maintained) and to mainline 2.6.34-rc2.

This patch should be queued for the stable branch.
(tested on 2.6.33.1 x86_64)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: Eric Dumazet <dada1@cosmosbay.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: stable <stable@kernel.org>
---
 kernel/lockdep.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/kernel/lockdep.c
===================================================================
--- linux-2.6-lttng.orig/kernel/lockdep.c	2010-03-29 23:54:31.000000000 -0400
+++ linux-2.6-lttng/kernel/lockdep.c	2010-03-29 23:54:38.000000000 -0400
@@ -609,9 +609,9 @@ static int static_obj(void *obj)
 	 * percpu var?
 	 */
 	for_each_possible_cpu(i) {
-		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
-					+ per_cpu_offset(i);
+		start = (unsigned long) per_cpu_ptr(&__per_cpu_start, i);
+		end   = (unsigned long) per_cpu_ptr(&__per_cpu_start
+						    + PERCPU_ENOUGH_ROOM, i);
 
 		if ((addr >= start) && (addr < end))
 			return 1;

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
