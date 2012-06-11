Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2FKNob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:44:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61213 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab2FKNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:44:29 -0400
Date: Mon, 11 Jun 2012 15:44:26 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, asharma@fb.com, mingo@elte.hu
Subject: [PATCH] perf/x86: fix broken LBR fixup code
Message-ID: <20120611134426.GA7542@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I noticed that the LBR fixups were not working anymore
on programs where they used to. I tracked this down to
a recent change to copy_from_user_nmi().

commit db0dc75d6403b6663c0eab4c6ccb672eb9b2ed72
Author: Arun Sharma <asharma@fb.com>
Date:   Fri Apr 20 15:41:36 2012 -0700

    perf/x86: Check user address explicitly in copy_from_user_nmi()
    
This commit added a call to __range_not_ok() to the
copy_from_user_nmi() routine. The problem is that the logic
of the test must be reversed. __range_not_ok() returns 0 if the
range is VALID. We want to return early from copy_from_user_nmi()
if the range is NOT valid.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
index 677b1ed..4f74d94 100644
--- a/arch/x86/lib/usercopy.c
+++ b/arch/x86/lib/usercopy.c
@@ -22,7 +22,7 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 	void *map;
 	int ret;
 
-	if (__range_not_ok(from, n, TASK_SIZE) == 0)
+	if (__range_not_ok(from, n, TASK_SIZE))
 		return len;
 
 	do {
