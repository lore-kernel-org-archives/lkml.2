Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0JVSkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:40:13 -0400
Received: from kroah.org ([198.145.64.141]:45895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758683Ab0JVSjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:39:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:01 2010
Message-Id: <20101022183601.817868003@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland McGrath <roland@redhat.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [63/66] execve: make responsive to SIGKILL with large arguments
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland McGrath <roland@redhat.com>

commit 9aea5a65aa7a1af9a4236dfaeb0088f1624f9919 upstream.

An execve with a very large total of argument/environment strings
can take a really long time in the execve system call.  It runs
uninterruptibly to count and copy all the strings.  This change
makes it abort the exec quickly if sent a SIGKILL.

Note that this is the conservative change, to interrupt only for
SIGKILL, by using fatal_signal_pending().  It would be perfectly
correct semantics to let any signal interrupt the string-copying in
execve, i.e. use signal_pending() instead of fatal_signal_pending().
We'll save that change for later, since it could have user-visible
consequences, such as having a timer set too quickly make it so that
an execve can never complete, though it always happened to work before.

Signed-off-by: Roland McGrath <roland@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 fs/exec.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -376,6 +376,9 @@ static int count(char __user * __user *
 			argv++;
 			if (i++ >= max)
 				return -E2BIG;
+
+			if (fatal_signal_pending(current))
+				return -ERESTARTNOHAND;
 			cond_resched();
 		}
 	}
@@ -419,6 +422,10 @@ static int copy_strings(int argc, char _
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			if (fatal_signal_pending(current)) {
+				ret = -ERESTARTNOHAND;
+				goto out;
+			}
 			cond_resched();
 
 			offset = pos % PAGE_SIZE;


