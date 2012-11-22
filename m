Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2KVWay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:30:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:49020 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab2KVSdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [ 53/83] m68k: fix sigset_t accessor functions
Date: Wed, 21 Nov 2012 16:42:15 -0800
Message-Id: <20121122004218.414682890@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m68k/include/asm/signal.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
@@ -164,7 +164,7 @@ static inline void sigaddset(sigset_t *s
 static inline void sigdelset(sigset_t *set, int _sig)
 {
 	asm ("bfclr %0{%1,#1}"
-		: "+od" (*set)
+		: "+o" (*set)
 		: "id" ((_sig - 1) ^ 31)
 		: "cc");
 }
@@ -180,7 +180,7 @@ static inline int __gen_sigismember(sigs
 	int ret;
 	asm ("bfextu %1{%2,#1},%0"
 		: "=d" (ret)
-		: "od" (*set), "id" ((_sig-1) ^ 31)
+		: "o" (*set), "id" ((_sig-1) ^ 31)
 		: "cc");
 	return ret;
 }


