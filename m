Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1AXRF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:05:59 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:44513 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753398Ab1AXRF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:05:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5tk0CDMVM1mN046Nxh8tErB5BIdy2W7HpIduQ1l6O7xDyGd
 crsqi4WDpq6AIAcA6VqZwoCgNGK8IK3aHAhJFIKDSe01K99xRgDB2MHVhE7g
 HSCgTHBZP3d4MNxLQIbXonHCY8BGzEVN438SzmFXUKaf80KMwS60kzTOneLC
 p8QQdIWl0xTX1oVfquY2_niGEzeHeggj9rzASEoqUQYEyI.0w7FStL6yZ48j
 _WLmns1YsoXmzBNwpfffv.IX51PU0sAmSQx3Q7VBSFZzHqb3ukgB48aodsBq
 pHCAiXnZWG8WFvtB4tDBmNbSVStckMqc8nILy5T6H1cNPolQ-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 24 Jan 2011 11:05:54 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tejun Heo <tj@kernel.org>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
In-Reply-To: <4D3A096C.7060800@zytor.com>
Message-ID: <alpine.DEB.2.00.1101241105180.31219@router.home>
References: <alpine.DEB.2.00.1012151404070.21102@router.home> <20110121171133.GI2832@htj.dyndns.org> <alpine.DEB.2.00.1101211114530.15692@router.home> <20110121172836.GK2832@htj.dyndns.org> <alpine.DEB.2.00.1101211139330.15692@router.home>
 <4D3A096C.7060800@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, H. Peter Anvin wrote:

> On 01/21/2011 09:46 AM, Christoph Lameter wrote:
> >> Oh, you're right.  Sorry about that.  Can you please then add a
> >> comment noting that the operation is x86 only?  Maybe prefix it with
> >> x86_?
> >
> > For a function defined in an specific include file and only used in arch
> > specific code?
>
> Yes, x86_ prefix to indicate it's an x86-specific interface, as opposed
> to arch_ which is a architecture-specific component of the
> implementation of a generic interface.

Subject: x86,percpu: Add x86_ prefix to this_cpu_test_bit and do not use percpu_read_stable

Add a prefix to this_cpu_test_bit and friends and do not use percpu_read_stable for
checking per cpu features.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/include/asm/percpu.h     |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h	2011-01-24 09:18:53.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/cpufeature.h	2011-01-24 09:19:02.000000000 -0600
@@ -224,7 +224,7 @@ extern const char * const x86_power_flag

 #define this_cpu_has(bit)						\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : 	\
-	 this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))
+	 x86_this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))

 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2011-01-24 09:18:53.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2011-01-24 09:24:21.000000000 -0600
@@ -492,15 +492,15 @@ do {									\
 	old__;								\
 })

-static __always_inline int this_cpu_constant_test_bit(unsigned int nr,
+static __always_inline int x86_this_cpu_constant_test_bit(unsigned int nr,
                         const unsigned long __percpu *addr)
 {
 	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;

-	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read_stable(*a)) != 0;
+	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read(*a)) != 0;
 }

-static inline int this_cpu_variable_test_bit(int nr,
+static inline int x86_this_cpu_variable_test_bit(int nr,
                         const unsigned long __percpu *addr)
 {
 	int oldbit;
@@ -513,10 +513,10 @@ static inline int this_cpu_variable_test
 	return oldbit;
 }

-#define this_cpu_test_bit(nr, addr)			\
+#define x86_this_cpu_test_bit(nr, addr)			\
 	(__builtin_constant_p((nr))			\
-	 ? this_cpu_constant_test_bit((nr), (addr))	\
-	 : this_cpu_variable_test_bit((nr), (addr)))
+	 ? x86_this_cpu_constant_test_bit((nr), (addr))	\
+	 : x86_this_cpu_variable_test_bit((nr), (addr)))


 #include <asm-generic/percpu.h>
