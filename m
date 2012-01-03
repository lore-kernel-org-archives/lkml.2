Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2ACPli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 10:41:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34612 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2ACPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 10:41:35 -0500
Message-ID: <1325605290.2320.76.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] x86: fix and improve cmpxchg_double{,_local}()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date: Tue, 03 Jan 2012 16:41:30 +0100
In-Reply-To: <1325603714.2320.73.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4F01F12A020000780006A19B@nat28.tlf.novell.com>
	 <1325602830.2320.69.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1325603714.2320.73.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 03 janvier 2012 à 16:15 +0100, Eric Dumazet a écrit :

> Very old it seems...
> 
> arch/x86/lib/atomic64_cx8_32.S
> 
> all "jxx 1b" are wrong if a LOCK_PREFIX is included after the 1: label
> 
> 1:
> 	inst1
> 	LOCK_PREFIX
> 	cmpxchg8b (%ebp)
> 	jne 1b  / jumps to beginning of LOCK_PREFIX, inst1 is not replayed
> 
> 
> 
> 

A possible fix would be to not use "1" label in LOCK_PREFIX macro,
but 672 magic value.

Not sure if we can use a local label in a macro ?

 arch/x86/include/asm/alternative-asm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 091508b..952bd01 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -4,10 +4,10 @@
 
 #ifdef CONFIG_SMP
 	.macro LOCK_PREFIX
-1:	lock
+672:	lock
 	.section .smp_locks,"a"
 	.balign 4
-	.long 1b - .
+	.long 672b - .
 	.previous
 	.endm
 #else


