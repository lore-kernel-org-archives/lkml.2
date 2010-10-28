Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab0J1LVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:21:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60678 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab0J1LVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:21:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] preempt: fix kernel build with !CONFIG_BKL
Date: Thu, 28 Oct 2010 13:20:44 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Brian Gerst <brgerst@gmail.com>, David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, x86@kernel.org
References: <20101028095910.GA15970@shutemov.name>
In-Reply-To: <20101028095910.GA15970@shutemov.name>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201010281320.44765.arnd@arndb.de>
X-Provags-ID: V02:K0:e/dXgw6ifcCRNeSly6hYuUZEEZy+m0m7Wi/4TzznF0Z
 +5a1SFkqU8khk9c8m6izWl2FlhUcGtmUdT9T730h54J7uC0FUq
 IcxSgyastOMqGIuFhqsuNPiaepNLg2vwYpqXKL9arivRsbp9p7
 6Bjg3VIU1o322oamqa8K6/JaQ4pjnsbeHA7d1cft67X21JRCVk
 88SppPCep0jhM+b6AptTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preempt count logic tries to take the BKL into account, which breaks
when CONFIG_BKL is not set.

Use the same preempt_count offset that we use without CONFIG_PREEMPT
when CONFIG_BKL is disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>

---
> /home/kas/git/tmp/linux-2.6-local/arch/x86/include/asm/i387.h: In function ‘irq_ts_save’:
> /home/kas/git/tmp/linux-2.6-local/arch/x86/include/asm/i387.h:324: error: implicit declaration of function ‘kernel_locked’
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2

Ah, found it. I had not considered or tested the case of CONFIG_BKL=n
with CONFIG_PREEMPT=y.

Does this work? Ideally please test with LOCKDEP enabled to see if
there are other problems in this configuration that I missed.

--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -96,7 +96,7 @@
  */
 #define in_nmi()	(preempt_count() & NMI_MASK)
 
-#if defined(CONFIG_PREEMPT)
+#if defined(CONFIG_PREEMPT) && defined(CONFIG_BKL)
 # define PREEMPT_INATOMIC_BASE kernel_locked()
 # define PREEMPT_CHECK_OFFSET 1
 #else
