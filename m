Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab3AIUkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:40:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:43082 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933751Ab3AIUkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 67/80] ARM: missing ->mmap_sem around find_vma() in swp_emulate.c
Date: Wed,  9 Jan 2013 12:35:59 -0800
Message-Id: <20130109201509.013336490@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/swp_emulate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -109,10 +109,12 @@ static void set_segfault(struct pt_regs
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


