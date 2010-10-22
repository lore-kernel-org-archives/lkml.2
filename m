Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994Ab0JVSlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:41:45 -0400
Received: from kroah.org ([198.145.64.141]:46017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758911Ab0JVSln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:43 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:40:34 2010
Message-Id: <20101022184034.003754079@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:39:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland McGrath <roland@redhat.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [17/17] execve: make responsive to SIGKILL with large arguments
In-Reply-To: <20101022184048.GA25391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -393,6 +393,9 @@ static int count(char __user * __user *
 			argv++;
 			if(++i > max)
 				return -E2BIG;
+
+			if (fatal_signal_pending(current))
+				return -ERESTARTNOHAND;
 			cond_resched();
 		}
 	}
@@ -436,6 +439,10 @@ static int copy_strings(int argc, char _
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			if (fatal_signal_pending(current)) {
+				ret = -ERESTARTNOHAND;
+				goto out;
+			}
 			cond_resched();
 
 			offset = pos % PAGE_SIZE;


