Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0E1TOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:14:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab0E1TOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:14:22 -0400
Date: Fri, 28 May 2010 21:12:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Henderson <rth@twiddle.net>,
       wezhang@redhat.com, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: [PATCH 2/2] remove the bogus checks in
	sys_personality()->__set_personality() path
Message-ID: <20100528191231.GD12090@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com> <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org> <20100527171530.GA18284@redhat.com> <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org> <20100528191139.GB12090@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528191139.GB12090@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup, no functional changes.

- __set_personality() always changes ->exec_domain/personality, the
  special case when ->exec_domain remains the same buys nothing but
  complicates the code. Unify both cases to simplify the code.

- The -EINVAL check in sys_personality() was never right. If we assume
  that set_personality() can fail we should check the value it returns
  instead of verifying that task->personality was actually changed.

  Remove it. Before the previous patch it was possible to hit this case
  due to overflow problems, but this -EINVAL just indicated the kernel
  bug.

OTOH, probably it makes sense to change lookup_exec_domain() to return
ERR_PTR() instead of default_exec_domain if the search in exec_domains
list fails, and report this error to the user-space. But this means
another user-space change, and we have in-kernel users which need fixes.
For example, PER_OSF4 falls into PER_MASK for unkown reason and nobody
cares to register this domain.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exec_domain.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

--- 34-rc1/kernel/exec_domain.c~2_CLEANUP	2010-05-28 18:23:25.000000000 +0200
+++ 34-rc1/kernel/exec_domain.c	2010-05-28 20:07:48.000000000 +0200
@@ -134,23 +134,14 @@ unregister:
 	return 0;
 }
 
-int
-__set_personality(unsigned int personality)
+int __set_personality(unsigned int personality)
 {
-	struct exec_domain	*ep, *oep;
-
-	ep = lookup_exec_domain(personality);
-	if (ep == current_thread_info()->exec_domain) {
-		current->personality = personality;
-		module_put(ep->module);
-		return 0;
-	}
+	struct exec_domain *oep = current_thread_info()->exec_domain;
 
+	current_thread_info()->exec_domain = lookup_exec_domain(personality);
 	current->personality = personality;
-	oep = current_thread_info()->exec_domain;
-	current_thread_info()->exec_domain = ep;
-
 	module_put(oep->module);
+
 	return 0;
 }
 
@@ -192,11 +183,8 @@ SYSCALL_DEFINE1(personality, unsigned in
 {
 	unsigned int old = current->personality;
 
-	if (personality != 0xffffffff) {
+	if (personality != 0xffffffff)
 		set_personality(personality);
-		if (current->personality != personality)
-			return -EINVAL;
-	}
 
 	return old;
 }

