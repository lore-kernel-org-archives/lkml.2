Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2LMOHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:07:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab2LMOHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 114/241] m68k: fix sigset_t accessor functions
Date: Thu, 13 Dec 2012 11:57:59 -0200
Message-Id: <1355407206-17100-115-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit 34fa78b59c52d1db3513db4c1a999db26b2e9ac2 upstream.

The sigaddset/sigdelset/sigismember functions that are implemented with
bitfield insn cannot allow the sigset argument to be placed in a data
register since the sigset is wider than 32 bits.  Remove the "d"
constraint from the asm statements.

The effect of the bug is that sending RT signals does not work, the signal
number is truncated modulo 32.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/m68k/include/asm/signal.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.h
index 60e8866..93fe83e 100644
--- a/arch/m68k/include/asm/signal.h
+++ b/arch/m68k/include/asm/signal.h
@@ -156,7 +156,7 @@ typedef struct sigaltstack {
 static inline void sigaddset(sigset_t *set, int _sig)
 {
 	asm ("bfset %0{%1,#1}"
-		: "+od" (*set)
+		: "+o" (*set)
 		: "id" ((_sig - 1) ^ 31)
 		: "cc");
 }
@@ -164,7 +164,7 @@ static inline void sigaddset(sigset_t *set, int _sig)
 static inline void sigdelset(sigset_t *set, int _sig)
 {
 	asm ("bfclr %0{%1,#1}"
-		: "+od" (*set)
+		: "+o" (*set)
 		: "id" ((_sig - 1) ^ 31)
 		: "cc");
 }
@@ -180,7 +180,7 @@ static inline int __gen_sigismember(sigset_t *set, int _sig)
 	int ret;
 	asm ("bfextu %1{%2,#1},%0"
 		: "=d" (ret)
-		: "od" (*set), "id" ((_sig-1) ^ 31)
+		: "o" (*set), "id" ((_sig-1) ^ 31)
 		: "cc");
 	return ret;
 }
-- 
1.7.9.5

