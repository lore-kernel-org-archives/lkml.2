Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1CKCrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:47:42 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20256 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1CKCrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:47:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mvOeQJlLb5682lS7GFYYIDHtdXCE2CSOCCRu3v7JbMqVF2SHu3VTzwVA/QogP6vBCB
         6Uc38tN3x1HCYqMyRR+g==
Date: Thu, 10 Mar 2011 18:47:31 -0800
From: Michel Lespinasse <walken@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] futex: do not pagefault_disable in
 futex_atomic_cmpxchg_inatomic()
Message-ID: <20110311024731.GB26122@google.com>
References: <20110307021127.GB31188@google.com>
 <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
 <20110309112550.GA3050@google.com>
 <alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
 <20110311021654.GA26122@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311021654.GA26122@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/futex.c disables page faults before calling
futex_atomic_cmpxchg_inatomic(), so there is no need to do it again
within that function.
    
Signed-off-by: Michel Lespinasse <walken@google.com>

diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
index b33fe70..7133a86 100644
--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -95,7 +95,8 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
-	pagefault_disable();	/* implies preempt_disable() */
+	/* Note that preemption is disabled by futex_atomic_cmpxchg_inatomic
+	 * call sites. */
 
 	__asm__ __volatile__("@futex_atomic_cmpxchg_inatomic\n"
 	"1:	" T(ldr) "	%0, [%3]\n"
@@ -115,8 +116,6 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 	: "r" (oldval), "r" (newval), "r" (uaddr), "Ir" (-EFAULT)
 	: "cc", "memory");
 
-	pagefault_enable();	/* subsumes preempt_enable() */
-
 	return val;
 }
 
-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
