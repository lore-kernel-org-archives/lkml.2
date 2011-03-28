Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1C1KcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:32:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53977 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1C1KcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YHg6iFMaBjD/UoaJvDNy69ulnNiGc2gpgpQmFLjZq2R9UCORZyqj94NaDBpkcnGdYm
         vKQmJchuA0/yCjBkP9ue51Oj9TUdZz7TmNVxaucnKsbU8ZnkPV1wv8A7xMjLILBfPYI9
         hdplQBiom/khKntp6v34S+Yiyg8X3nyvYbkq4=
Subject: [PATCH] percpu: avoid extra NOP in percpu_cmpxchg16b_double
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1301212347.32248.1.camel@edumazet-laptop>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	 <20110324142146.GA11682@elte.hu>
	 <alpine.DEB.2.00.1103240940570.32226@router.home>
	 <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	 <20110324172653.GA28507@elte.hu> <20110324185258.GA28370@elte.hu>
	 <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6>
	 <20110324192247.GA5477@elte.hu>
	 <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com>
	 <20110326112725.GA28612@elte.hu> <20110326114736.GA8251@elte.hu>
	 <1301161507.2979.105.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1103261406420.24195@router.home>
	 <alpine.DEB.2.00.1103261428200.25375@router.home>
	 <alpine.DEB.2.00.1103261440160.25375@router.home>
	 <AANLkTinTzKQkRcE2JvP_BpR0YMj82gppAmNo7RqgftCG@mail.gmail.com>
	 <alpine.DEB.2.00.1103262028170.1004@router.home>
	 <alpine.DEB.2.00.1103262054410.1373@router.home>
	 <1301212347.32248.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 12:32:15 +0200
Message-ID: <1301308335.3182.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_cmpxchg16b_double() uses alternative_io() and looks like :

e8 .. .. .. ..  call this_cpu_cmpxchg16b_emu
X bytes		NOPX

or, once patched (if cpu supports native instruction) on SMP build :

65 48 0f c7 0e  cmpxchg16b %gs:(%rsi)
0f 94 c0        sete %al

on !SMP build :

48 0f c7 0e     cmpxchg16b (%rsi)
0f 94 c0        sete %al

Therefore, NOPX should be :

P6_NOP3 on SMP
P6_NOP2 on !SMP

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index d475b43..d68fca6 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -509,6 +509,11 @@ do {									\
  * it in software.  The address used in the cmpxchg16 instruction must be
  * aligned to a 16 byte boundary.
  */
+#ifdef CONFIG_SMP
+#define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" P6_NOP3
+#else
+#define CMPXCHG16B_EMU_CALL "call this_cpu_cmpxchg16b_emu\n\t" P6_NOP2
+#endif
 #define percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)			\
 ({									\
 	char __ret;							\
@@ -517,7 +522,7 @@ do {									\
 	typeof(o2) __o2 = o2;						\
 	typeof(o2) __n2 = n2;						\
 	typeof(o2) __dummy;						\
-	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" P6_NOP4,	\
+	alternative_io(CMPXCHG16B_EMU_CALL,				\
 		       "cmpxchg16b " __percpu_prefix "(%%rsi)\n\tsetz %0\n\t",	\
 		       X86_FEATURE_CX16,				\
 		       ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\


