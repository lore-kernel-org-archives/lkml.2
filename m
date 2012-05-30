Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2E3EwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:52:02 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33438 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2E3EwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:52:00 -0400
Message-ID: <4FC5A77F.6060505@oracle.com>
Date: Wed, 30 May 2012 12:52:15 +0800
From: "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: zhenzhong.duan@oracle.com, mingo@redhat.com, x86@kernel.org,
        tglx@linutronix.de, hpa@zytor.com, Feng Jin <joe.jin@oracle.com>,
        ethan.zhao@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Fix an overflow in range_to_mtrr func
References: <aabb3c7d-1c1a-4558-805a-b6d8478d1494@default> <CAE9FiQV1ckyhy+cWVZC+=rU9s2nrBO6qV0Yt5xkYuv_gS9ZSWQ@mail.gmail.com>
In-Reply-To: <CAE9FiQV1ckyhy+cWVZC+=rU9s2nrBO6qV0Yt5xkYuv_gS9ZSWQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When boot on sun G5+ with 4T mem, see an overflow in mtrr cleanup as below.

*BAD*gran_size: 2G      chunk_size: 2G  num_reg: 10     lose cover RAM:
-18014398505283592M

This is because 1<<31 sign extended. Use 64bit constant to fix it.
Useful for mem larger than or equal to 4T.

-v2: Use 64bit constant instead of explicit type conversion as suggested
by Yinghai. Description updated too.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
  arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c
b/arch/x86/kernel/cpu/mtrr/cleanup.c
index ac140c7..853a4c6 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -266,7 +266,7 @@ range_to_mtrr(unsigned int reg, unsigned long
range_startk,
  		if (align > max_align)
  			align = max_align;

-		sizek = 1 << align;
+		sizek = 1UL << align;
  		if (debug_print) {
  			char start_factor = 'K', size_factor = 'K';
  			unsigned long start_base, size_base;
-- 1.7.3
