Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2E1M3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:29:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25837 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab2E1M3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:29:24 -0400
MIME-Version: 1.0
Message-ID: <aabb3c7d-1c1a-4558-805a-b6d8478d1494@default>
Date: Mon, 28 May 2012 05:29:11 -0700 (PDT)
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
To: <mingo@redhat.com>, <x86@kernel.org>, <yinghai@kernel.org>,
        <tglx@linutronix.de>, <hpa@zytor.com>
Cc: Feng Jin <joe.jin@oracle.com>, <ethan.zhao@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix an overflow in range_to_mtrr func
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When boot x86_64 kernel on sun G5+ with 4T mem, see an overflow in mtrr cleanup as below.

*BAD*gran_size: 2G      chunk_size: 2G  num_reg: 10     lose cover RAM:
-18014398505283592M

This is because 1<<31 sign extended.
Use explicit type conversion to force a 64bit constant to fix it.
Useful for mem larger than or equal to 4T.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index ac140c7..853a4c6 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -266,7 +266,7 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
 		if (align > max_align)
 			align = max_align;
 
-		sizek = 1 << align;
+		sizek = (unsigned long)1 << align;
 		if (debug_print) {
 			char start_factor = 'K', size_factor = 'K';
 			unsigned long start_base, size_base;
-- 
1.7.3

