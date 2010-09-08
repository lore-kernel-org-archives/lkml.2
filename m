Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab0IHCiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040Ab0IHCiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:38:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
X-Fcc: ~/Mail/linus
In-Reply-To: Roland McGrath's message of  Tuesday, 7 September 2010 19:34:17 -0700 <20100908023417.8B055401AF@magilla.sf.frob.com>
References: <20100827220258.GF4703@outflux.net>
	<20100830005648.431B7400D9@magilla.sf.frob.com>
	<20100830032331.GA22773@openwall.com>
	<20100830100616.78971400D9@magilla.sf.frob.com>
	<20100908023417.8B055401AF@magilla.sf.frob.com>
X-Shopping-List: (1) Prosperous pincushions
   (2) Prosthetic documents
   (3) Spacious pig apparitions
   (4) Adamant hilarious paradox riots
Subject: [PATCH 3/3] execve: make responsive to SIGKILL with large arguments
Message-Id: <20100908023706.9901D401AF@magilla.sf.frob.com>
Date: Tue,  7 Sep 2010 19:37:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 fs/exec.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6f2d777..828dd24 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -376,6 +376,9 @@ static int count(const char __user * const __user * argv, int max)
 			argv++;
 			if (i++ >= max)
 				return -E2BIG;
+
+			if (fatal_signal_pending(current))
+				return -ERESTARTNOHAND;
 			cond_resched();
 		}
 	}
@@ -419,6 +422,10 @@ static int copy_strings(int argc, const char __user *const __user *argv,
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			if (fatal_signal_pending(current)) {
+				ret = -ERESTARTNOHAND;
+				goto out;
+			}
 			cond_resched();
 
 			offset = pos % PAGE_SIZE;
