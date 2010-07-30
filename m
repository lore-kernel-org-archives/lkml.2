Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab0G3R5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:57:45 -0400
Received: from kroah.org ([198.145.64.141]:58776 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760011Ab0G3R4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:32 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:44 2010
Message-Id: <20100730175144.580602183@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [117/205] ARM: 6211/1: atomic ops: fix register constraints for atomic64_add_unless
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 068de8d1be48a04b92fd97f76bb7e113b7be82a8 upstream.

The atomic64_add_unless function compares an atomic variable with
a given value and, if they are not equal, adds another given value
to the atomic variable. The function returns zero if the addition
did not occur and non-zero otherwise.

On ARM, the return value is initialised to 1 in C code. Inline assembly
code then performs the atomic64_add_unless operation, setting the
return value to 0 iff the addition does not occur. This means that
when the addition *does* occur, the value of ret must be preserved
across the inline assembly and therefore requires a "+r" constraint
rather than the current one of "=&r".

Thanks to Nicolas Pitre for helping to spot this.

Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/include/asm/atomic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -440,7 +440,7 @@ static inline int atomic64_add_unless(at
 "	teq	%2, #0\n"
 "	bne	1b\n"
 "2:"
-	: "=&r" (val), "=&r" (ret), "=&r" (tmp)
+	: "=&r" (val), "+r" (ret), "=&r" (tmp)
 	: "r" (&v->counter), "r" (u), "r" (a)
 	: "cc");
 


