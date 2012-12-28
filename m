Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2L1CQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 21:16:47 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:46601 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2L1CQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 21:16:45 -0500
X-Remote-IP: 213.191.128.133
Date: Fri, 28 Dec 2012 03:16:38 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhouping Liu <zliu@redhat.com>, Sedat Dilek <sedat.dilek@gmail.com>
References: <50D24AF3.1050809@iskon.hr> <20121220111208.GD10819@suse.de> <20121220125802.23e9b22d.akpm@linux-foundation.org> <50D601C9.9060803@iskon.hr> <50D71166.6030608@iskon.hr> <50DB129E.7010000@iskon.hr>
In-Reply-To: <50DB129E.7010000@iskon.hr>
Message-ID: <50DD0106.7040001@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [PATCH] mm: fix null pointer dereference in wait_iff_congested()
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121228 #8901209, check: 20121228 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 40800 [Dec 28 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zlatko Calusic <zlatko.calusic@iskon.hr>

The unintended consequence of commit 4ae0a48b is that
wait_iff_congested() can now be called with NULL struct zone*
producing kernel oops like this:

BUG: unable to handle kernel NULL pointer dereference
IP: [<ffffffff811542d9>] wait_iff_congested+0x59/0x140

This trivial patch fixes it.

Reported-by: Zhouping Liu <zliu@redhat.com>
Reported-and-tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Zlatko Calusic <zlatko.calusic@iskon.hr>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 02bcfa3..e55ce55 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2782,7 +2782,7 @@ loop_again:
 		if (total_scanned && (sc.priority < DEF_PRIORITY - 2)) {
 			if (has_under_min_watermark_zone)
 				count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
-			else
+			else if (unbalanced_zone)
 				wait_iff_congested(unbalanced_zone, BLK_RW_ASYNC, HZ/10);
 		}
 
-- 
1.8.1.rc3

-- 
Zlatko
