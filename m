Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2LCOmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:42:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43903 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755484Ab2LCOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:54 -0500
Message-Id: <20121203143152.494585915@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:21 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Schwab <schwab@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [ 35/89] m68k: fix sigset_t accessor functions
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m68k/include/asm/signal.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.h
index 67e489d..2df26b5 100644
--- a/arch/m68k/include/asm/signal.h
+++ b/arch/m68k/include/asm/signal.h
@@ -41,7 +41,7 @@ struct k_sigaction {
 static inline void sigaddset(sigset_t *set, int _sig)
 {
 	asm ("bfset %0{%1,#1}"
-		: "+od" (*set)
+		: "+o" (*set)
 		: "id" ((_sig - 1) ^ 31)
 		: "cc");
 }
@@ -49,7 +49,7 @@ static inline void sigaddset(sigset_t *set, int _sig)
 static inline void sigdelset(sigset_t *set, int _sig)
 {
 	asm ("bfclr %0{%1,#1}"
-		: "+od" (*set)
+		: "+o" (*set)
 		: "id" ((_sig - 1) ^ 31)
 		: "cc");
 }
@@ -65,7 +65,7 @@ static inline int __gen_sigismember(sigset_t *set, int _sig)
 	int ret;
 	asm ("bfextu %1{%2,#1},%0"
 		: "=d" (ret)
-		: "od" (*set), "id" ((_sig-1) ^ 31)
+		: "o" (*set), "id" ((_sig-1) ^ 31)
 		: "cc");
 	return ret;
 }


