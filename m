Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0KWSf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:35:27 -0500
Received: from [69.28.251.93] ([69.28.251.93]:36795 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab0KWSf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:35:26 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] MIPS: Fix CP0 COUNTER clockevent race
Date: Tue, 23 Nov 2010 10:26:44 -0800
Message-Id: <444ef6c4bbb47d55c700452d8cd23229@localhost>
In-Reply-To: <8a8eee995454c8b271cceb440e31699a@localhost>
References: <8a8eee995454c8b271cceb440e31699a@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider the following test case:

write_c0_compare(read_c0_count());

Even if the counter doesn't increment during execution, this might not
generate an interrupt until the counter wraps around.  The CPU may
perform the comparison each time CP0 COUNT increments, not when CP0
COMPARE is written.

If mips_next_event() is called with a very small delta, and CP0 COUNT
increments during the calculation of "cnt += delta", it is possible
that CP0 COMPARE will be written with the current value of CP0 COUNT.
If this is detected, the function should return -ETIME, to indicate
that the interrupt might not have actually gotten scheduled.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/kernel/cevt-r4k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 2f4d7a9..98c5a97 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -32,7 +32,7 @@ static int mips_next_event(unsigned long delta,
 	cnt = read_c0_count();
 	cnt += delta;
 	write_c0_compare(cnt);
-	res = ((int)(read_c0_count() - cnt) > 0) ? -ETIME : 0;
+	res = ((int)(read_c0_count() - cnt) >= 0) ? -ETIME : 0;
 	return res;
 }
 
-- 
1.7.0.4

