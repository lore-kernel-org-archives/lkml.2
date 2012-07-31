Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2GaKwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:52:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40518 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab2GaKwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:52:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, hpa@zytor.com, x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/3] x86: Let extend_brk return a NULL pointer instead of just BUG_ON.
Date: Tue, 31 Jul 2012 06:42:56 -0400
Message-Id: <1343731376-20658-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1343731376-20658-1-git-send-email-konrad.wilk@oracle.com>
References: <1343731376-20658-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callers of this function (dmi_alloc) and the various
Xen related ones can deal with a NULL pointer.

Suggested-by: Ian Campbell <Ian.Campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/setup.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 16be6dc..13d6c51 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -268,9 +268,10 @@ void * __init extend_brk(size_t size, size_t align)
 	BUG_ON(_brk_start == 0);
 	BUG_ON(align & mask);
 
-	_brk_end = (_brk_end + mask) & ~mask;
-	BUG_ON((char *)(_brk_end + size) > __brk_limit);
+	if ((char *)(((_brk_end + mask) & ~mask) + size) > __brk_limit)
+		return NULL;
 
+	_brk_end = (_brk_end + mask) & ~mask;
 	ret = (void *)_brk_end;
 	_brk_end += size;
 
-- 
1.7.7.6

