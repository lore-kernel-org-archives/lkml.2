Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081Ab2BJXWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:22:42 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295Ab2BJWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:40:50 -0500
MIME-Version: 1.0
Message-Id: <20120210222946.198111485@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 13/86] ARM: 7308/1: vfp: flush thread hwstate before copying ptrace registers
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 8130b9d7b9d858aa04ce67805e8951e3cb6e9b2f upstream.

If we are context switched whilst copying into a thread's
vfp_hard_struct then the partial copy may be corrupted by the VFP
context switching code (see "ARM: vfp: flush thread hwstate before
restoring context from sigframe").

This patch updates the ptrace VFP set code so that the thread state is
flushed before the copy, therefore disabling VFP and preventing
corruption from occurring.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -726,8 +726,8 @@ static int vfp_set(struct task_struct *t
 	if (ret)
 		return ret;
 
-	thread->vfpstate.hard = new_vfp;
 	vfp_flush_hwstate(thread);
+	thread->vfpstate.hard = new_vfp;
 
 	return 0;
 }


