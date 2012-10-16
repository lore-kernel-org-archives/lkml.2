Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2JPLsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:48:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:39185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab2JPLs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:48:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235689589"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCHv3 3/6] staging: rts_pstor: reuse kbasename()
Date: Tue, 16 Oct 2012 14:48:11 +0300
Message-Id: <1350388094-18805-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The custom filename function mostly repeats the kernel's kbasename. This patch
simplifies it. The updated filename() will not check for the '\' in the
filenames. It seems redundant in Linux. The __FILE__ macro always defined if
we compile an existing file. Thus, NULL check is not needed there as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rts_pstor/trace.h |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
index cf60a1b..bff99bf 100644
--- a/drivers/staging/rts_pstor/trace.h
+++ b/drivers/staging/rts_pstor/trace.h
@@ -24,31 +24,15 @@
 #ifndef __REALTEK_RTSX_TRACE_H
 #define __REALTEK_RTSX_TRACE_H
 
+#include <linux/string.h>
+
 #define _MSG_TRACE
 
 #ifdef _MSG_TRACE
-static inline char *filename(char *path)
-{
-	char *ptr;
-
-	if (path == NULL)
-		return NULL;
-
-	ptr = path;
-
-	while (*ptr != '\0') {
-		if ((*ptr == '\\') || (*ptr == '/'))
-			path = ptr + 1;
-		
-		ptr++;
-	}
-
-	return path;
-}
 
 #define TRACE_RET(chip, ret)   										\
 do {													\
-	char *_file = filename(__FILE__);								\
+	const char *_file = kbasename(__FILE__);								\
 	RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__);					\
 	(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__);					\
 	strncpy((chip)->trace_msg[(chip)->msg_idx].func, __func__, MSG_FUNC_LEN-1);			\
@@ -64,7 +48,7 @@ do {													\
 
 #define TRACE_GOTO(chip, label)   									\
 do {													\
-	char *_file = filename(__FILE__);								\
+	const char *_file = kbasename(__FILE__);								\
 	RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__);					\
 	(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__);					\
 	strncpy((chip)->trace_msg[(chip)->msg_idx].func, __func__, MSG_FUNC_LEN-1);			\
-- 
1.7.10.4

