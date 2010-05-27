Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab0E0PiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:38:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab0E0Ph6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:37:58 -0400
Date: Thu, 27 May 2010 17:36:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: [PATCH 3/3] __set_personality: no need to check the old
	->exec_domain
Message-ID: <20100527153639.GD13858@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527153522.GA13858@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. __set_personality() always changes ->exec_domain/personality,
the special case when ->exec_domain remains the same buys nothing but
complicates the code.

I don't understand why lookup_exec_domain() always succeeds even if
the search in ->exec_domains list fails, we use default_exec_domain
in this case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exec_domain.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- 34-rc1/kernel/exec_domain.c~3_CLEANUP_SET_PERSONALITY	2010-05-27 15:54:33.000000000 +0200
+++ 34-rc1/kernel/exec_domain.c	2010-05-27 17:03:29.000000000 +0200
@@ -134,23 +134,14 @@ unregister:
 	return 0;
 }
 
-int
-__set_personality(u_long personality)
+int __set_personality(u_long personality)
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
 

