Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab2IXVls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 17:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab2IXVlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 17:41:47 -0400
From: Mark Salter <msalter@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH] c/r: prctl: fix build error for no-MMU case
Date: Mon, 24 Sep 2012 17:41:32 -0400
Message-Id: <1348522892-12705-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1ad75b9e1 added some address checking to prctl_set_mm()
used by checkpoint-restore. This causes a build error for no-MMU
systems:

   kernel/sys.c: In function 'prctl_set_mm':
   kernel/sys.c:1868:34: error: 'mmap_min_addr' undeclared (first use in this function)

The test for mmap_min_addr doesn't make a lot of sense for no-MMU
code as noted in commit 6e1415467. This patch defines mmap_min_addr
as 0UL in the no-MMU case so that the compiler will optimize away
tests for "addr < mmap_min_addr".

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 include/linux/security.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 3dea6a9..d143b8e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -118,6 +118,7 @@ void reset_security_ops(void);
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
 #else
+#define mmap_min_addr		0UL
 #define dac_mmap_min_addr	0UL
 #endif
 
-- 
1.7.9.1

