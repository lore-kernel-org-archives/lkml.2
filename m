Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0K2JrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:47:03 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61168 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0K2JrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:47:01 -0500
MIME-Version: 1.0
X-Originating-IP: [66.201.52.98]
In-Reply-To: <20101126225339.GA26864@n2100.arm.linux.org.uk>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101126045912.GC6598@lixom.net>
 <AANLkTin5Tfcuy0WcHJ22rWC8niwZCj8SZAMKLz0p9jwc@mail.gmail.com>
 <20101126091832.GE9310@n2100.arm.linux.org.uk> <AANLkTimS-cSi1B5LdtwhJWhKDuFKOYG1j_p-iQiH=zRe@mail.gmail.com>
 <20101126104548.GG9310@n2100.arm.linux.org.uk> <AANLkTi=h3gPN63NKKJ4wjumKNx9qDtxCKvOSbtRkr1wx@mail.gmail.com>
 <20101126225339.GA26864@n2100.arm.linux.org.uk>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 29 Nov 2010 11:46:40 +0200
Message-ID: <AANLkTi=AtYTL-w5Jajypnbj=G_MGzyeLxtusu5V72eG+@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Kevin Hilman <khilman@deeprootsystems.com>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 12:53 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Nov 27, 2010 at 12:18:55AM +0200, Ohad Ben-Cohen wrote:
>> But then there's the other (quite reasonable) claim that says we
>> shouldn't crash the machine because of a non fatal bug: if a crappy
>> driver messes up, the user (not the developer) will most probably
>> prefer the machine to keep running with degraded functionality rather
>> than boot.
>
> There's also the quite reasonable expectation that we shouldn't corrupt
> user data.  With locking interfaces, if someone abuses them and they
> fail to work, then the risk is data corruption due to races.  The safe
> thing in that case is to panic - terminate that thread before it does
> anything unsafe, thereby preventing data corruption.

Makes sense.

I considered hwspinlock as a peripheral which doesn't qualify to take
down the system on failure, but in general I agree that there indeed
might be critical user data involved. Especially if this is a
framework and not just another driver.

But as a framework that can be used on non ARM architectures as well,
I do prefer to check for NULL pointers and not rely on the Oops.

If we had a macro that would be compiled out on architectures that
reliably produces an Oops on NULL dereference, but otherwise, would
BUG_ON on them, that should satisfy everyone.

The BUG_ON_MAPPABLE_NULL() macro below should achieve exactly that,
please tell me what you think, thanks!

 arch/arm/include/asm/mman.h |    1 +
 include/asm-generic/bug.h   |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/mman.h b/arch/arm/include/asm/mman.h
index 41f99c5..d4ee003 100644
--- a/arch/arm/include/asm/mman.h
+++ b/arch/arm/include/asm/mman.h
@@ -1,4 +1,5 @@
 #include <asm-generic/mman.h>
+#include <asm/pgtable.h>

 #define arch_mmap_check(addr, len, flags) \
 	(((flags) & MAP_FIXED && (addr) < FIRST_USER_ADDRESS) ? -EINVAL : 0)
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index c2c9ba0..d211d9c 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -2,6 +2,11 @@
 #define _ASM_GENERIC_BUG_H

 #include <linux/compiler.h>
+#include <asm/mman.h>
+
+#ifndef arch_mmap_check
+#define arch_mmap_check(addr, len, flags)	(0)
+#endif

 #ifdef CONFIG_BUG

@@ -53,6 +58,41 @@ struct bug_entry {
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif

+/**
+ * BUG_ON_MAPPABLE_NULL() - panic on NULL only if address 0 is mappable
+ * @addr:	address to check
+ *
+ * In general, NULL dereference Oopses are not desirable, since they take down
+ * the system with them and make the user extremely unhappy. So as a general
+ * rule kernel code should avoid dereferencing NULL pointers by doing a
+ * simple check (when appropriate), and if needed, continue operating
+ * with reduced functionality rather than crash.
+ *
+ * _Critical_ kernel code, OTOH, that should not (/cannot) keep running when
+ * given an unexpected NULL pointer, should just crash. On some architectures,
+ * a NULL dereference will always reliably produce an Oops. On others, where
+ * the zero address can be mmapped, an Oops is not guaranteed. Relying on
+ * NULL dereference Oopses to happen on these architectures might lead to
+ * data corruptions (system will keep running despite a critical bug and
+ * the results will be horribly undefined). In addition, these situations
+ * can also have security implications - we have seen several privilege
+ * escalation exploits with which an attacker gained full control over the
+ * system due to NULL dereference bugs.
+ *
+ * This macro will BUG_ON if @addr is NULL on architectures where the zero
+ * addresses can be mapped. On other architectures, where the zero address
+ * can never be mapped, this macro is compiled out, so the system will just
+ * Oops when the @addr is dereferenced.
+ *
+ * As with BUG_ON, use this macro only if a NULL @addr cannot be tolerated.
+ * If proceeding with degraded functionality is an option, it's much
+ * better to just simply check for the NULL and returning instead of crashing
+ * the system.
+ */
+#define BUG_ON_MAPPABLE_NULL(addr) do { \
+	if (arch_mmap_check(0, 1, MAP_FIXED) == 0) BUG_ON(!addr); \
+} while(0)
+
 /*
  * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
  * significant issues that need prompt attention if they should ever
-- 
1.7.0.4
