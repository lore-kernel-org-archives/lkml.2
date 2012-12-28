Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2L1Tvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:51:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55081 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533Ab2L1TRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:42 -0500
Message-Id: <20121228190358.615981770@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@ZenIV.linux.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 141/173] ARM: missing ->mmap_sem around find_vma() in swp_emulate.c
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 7bf9b7bef881aac820bf1f2e9951a17b09bd7e04 upstream.

find_vma() is *not* safe when somebody else is removing vmas.  Not just
the return value might get bogus just as you are getting it (this instance
doesn't try to dereference the resulting vma), the search itself can get
buggered in rather spectacular ways.  IOW, ->mmap_sem really, really is
not optional here.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/swp_emulate.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
index df74518..ab1017b 100644
--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -109,10 +109,12 @@ static void set_segfault(struct pt_regs *regs, unsigned long addr)
 {
 	siginfo_t info;
 
+	down_read(&current->mm->mmap_sem);
 	if (find_vma(current->mm, addr) == NULL)
 		info.si_code = SEGV_MAPERR;
 	else
 		info.si_code = SEGV_ACCERR;
+	up_read(&current->mm->mmap_sem);
 
 	info.si_signo = SIGSEGV;
 	info.si_errno = 0;


