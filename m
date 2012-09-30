Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2I3H7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:59:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20387 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2I3H5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:57:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/13] x86, mm: Set memblock initial limit to 1M
Date: Sun, 30 Sep 2012 00:57:19 -0700
Message-Id: <1348991844-12285-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_x86_fill() could double memory array.
If we set max_pfn_mapped to 512M, so memory array could be around 512M.
So kdump will not get big range (like 512M) under 1024M.

Try to put it down under 1M, it could use about 4k or so.

Also we need this one when we try to only map ram range only later.
if the early double the range near 512M, and later init_mem_mapping()
first several range could under 512M, then after mapping get reset,
we will lose access the memblock memory array. but we are using
memblock memory array for iteration.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 249384a..9db2922 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -889,7 +889,7 @@ void __init setup_arch(char **cmdline_p)
 
 	cleanup_highmap();
 
-	memblock.current_limit = get_max_mapped();
+	memblock.current_limit = ISA_END_ADDRESS;
 	memblock_x86_fill();
 
 	/*
-- 
1.7.7

