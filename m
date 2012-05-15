Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641Ab2EOCjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:39:43 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53498 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965332Ab2EOCRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 131/179] powerpc/kdump: Fix timeout in crash_kexec_wait_realmode
Date: Mon, 14 May 2012 22:13:47 -0400
Message-ID: <1337048075-6132-132-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 63f21a56f1cc0b800a4c00349c59448f82473d19 upstream.

The existing code it pretty ugly.  How about we clean it up even more
like this?

From: Anton Blanchard <anton@samba.org>

We check for timeout expiry in the outer loop, but we also need to
check it in the inner loop or we can lock up forever waiting for a
CPU to hit real mode.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/crash.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index ddf1fea..d2f619b 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -176,12 +176,8 @@ static void crash_kexec_wait_realmode(int cpu)
 
 		while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
 			barrier();
-			if (!cpu_possible(i)) {
+			if (!cpu_possible(i) || !cpu_online(i) || (msecs <= 0))
 				break;
-			}
-			if (!cpu_online(i)) {
-				break;
-			}
 			msecs--;
 			mdelay(1);
 		}
-- 
1.7.9.6

