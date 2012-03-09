Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031063Ab2CITtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:49:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031004Ab2CITtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:17 -0500
Message-Id: <20120309190207.817875694@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ming Lei <tom.leiming@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 68/95] ARM: 7355/1: perf: clear overflow flag when disabling counter on ARMv7 PMU
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 99c1745b9c76910e195889044f914b4898b7c9a5 upstream.

When disabling a counter on an ARMv7 PMU, we should also clear the
overflow flag in case an overflow occurred whilst stopping the counter.
This prevents a spurious overflow being picked up later and leading to
either false accounting or a NULL dereference.

Reported-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event_v7.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -878,6 +878,11 @@ static inline int armv7_pmnc_disable_int
 
 	counter = ARMV7_IDX_TO_COUNTER(idx);
 	asm volatile("mcr p15, 0, %0, c9, c14, 2" : : "r" (BIT(counter)));
+	isb();
+	/* Clear the overflow flag in case an interrupt is pending. */
+	asm volatile("mcr p15, 0, %0, c9, c12, 3" : : "r" (BIT(counter)));
+	isb();
+
 	return idx;
 }
 


