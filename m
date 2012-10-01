Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2JAW7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:33 -0400
Received: from 1wt.eu ([62.212.114.60]:34959 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab2JAW71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:27 -0400
Message-Id: <20121001225158.802435384@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Junxiao Bi <junxiao.bi@oracle.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 028/180] oprofile: use KM_NMI slot for kmap_atomic
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

If one kernel path is using KM_USER0 slot and is interrupted by
the oprofile nmi, then in copy_from_user_nmi(), the KM_USER0 slot
will be overwrite and cleared to zero at last, when the control
return to the original kernel path, it will access an invalid
virtual address and trigger a crash.

Cc: Robert Richter <robert.richter@amd.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

[WT: According to Junxiao and Robert, this patch is needed for stable kernels
 which include a backport of a0e3e70243f5b270bc3eca718f0a9fa5e6b8262e without
 3e4d3af501cccdc8a8cca41bdbe57d54ad7e7e73, but there is no exact equivalent in
 mainline]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/oprofile/backtrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 829edf0..b50a280 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -71,9 +71,9 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 		offset = addr & (PAGE_SIZE - 1);
 		size = min(PAGE_SIZE - offset, n - len);
 
-		map = kmap_atomic(page, KM_USER0);
+		map = kmap_atomic(page, KM_NMI);
 		memcpy(to, map+offset, size);
-		kunmap_atomic(map, KM_USER0);
+		kunmap_atomic(map, KM_NMI);
 		put_page(page);
 
 		len  += size;
-- 
1.7.2.1.45.g54fbc



