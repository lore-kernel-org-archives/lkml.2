Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab2BJW7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:59:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab2BJWou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:50 -0500
MIME-Version: 1.0
Message-Id: <20120210223443.279046084@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 34/55] lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit df754e6af2f237a6c020c0daff55a1a609338e31 upstream.

It's unlikely that TAINT_FIRMWARE_WORKAROUND causes false
lockdep messages, so do not disable lockdep in that case.
We still want to keep lockdep disabled in the
TAINT_OOT_MODULE case:

  - bin-only modules can cause various instabilities in
    their and in unrelated kernel code

  - they are impossible to debug for kernel developers

  - they also typically do not have the copyright license
    permission to link to the GPL-ed lockdep code.

Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-xopopjjens57r0i13qnyh2yo@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/panic.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -236,8 +236,16 @@ void add_taint(unsigned flag)
 	 * Also we want to keep up lockdep for staging development and
 	 * post-warning case.
 	 */
-	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
-		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+	switch (flag) {
+	case TAINT_CRAP:
+	case TAINT_WARN:
+	case TAINT_FIRMWARE_WORKAROUND:
+		break;
+
+	default:
+		if (__debug_locks_off())
+			printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+	}
 
 	set_bit(flag, &tainted_mask);
 }


