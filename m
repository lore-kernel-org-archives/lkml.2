Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab2BXAIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:08:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54354 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2BXAGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:06:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.73.225 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120224000220.581161542@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 23 Feb 2012 16:02:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 03/10] i387: fix sense of sanity check
In-Reply-To: <20120224000510.GA1005@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit c38e23456278e967f094b08247ffc3711b1029b2 upstream.

The check for save_init_fpu() (introduced in commit 5b1cbac37798: "i387:
make irq_fpu_usable() tests more robust") was the wrong way around, but
I hadn't noticed, because my "tests" were bogus: the FPU exceptions are
disabled by default, so even doing a divide by zero never actually
triggers this code at all unless you do extra work to enable them.

So if anybody did enable them, they'd get one spurious warning.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/i387.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -404,7 +404,7 @@ static inline void irq_ts_restore(int TS
  */
 static inline void save_init_fpu(struct task_struct *tsk)
 {
-	WARN_ON_ONCE(task_thread_info(tsk)->status & TS_USEDFPU);
+	WARN_ON_ONCE(!(task_thread_info(tsk)->status & TS_USEDFPU));
 	preempt_disable();
 	__save_init_fpu(tsk);
 	stts();


