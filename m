Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab0DVTgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:36:31 -0400
Received: from kroah.org ([198.145.64.141]:41448 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab0DVT3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:46 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:22 2010
Message-Id: <20100422190922.618832798@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: [170/197] lockdep: fix incorrect percpu usage
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

The mainline kernel as of 2.6.34-rc5 is not affected by this problem because
commit 10fad5e46f6c7bdfb01b1a012380a38e3c6ab346 fixed it by refactoring.

lockdep fix incorrect percpu usage

Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
for per cpu pointers).

git blame points to commit:

lockdep.c: commit 8e18257d29238311e82085152741f0c3aa18b74d

But it's really just moving the code around. But it's enough to say that the
problems appeared before Jul 19 01:48:54 2007, which brings us back to 2.6.23.

It should be applied to stable 2.6.23.x to 2.6.33.x (or whichever of these
stable branches are still maintained).

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/lockdep.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -591,9 +591,9 @@ static int static_obj(void *obj)
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


