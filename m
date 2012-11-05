Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2KEVEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:04:35 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39390 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab2KEVEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:04:34 -0500
Date: Mon, 5 Nov 2012 13:04:21 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH] pstore/ram: no timekeeping calls when unavailable
Message-ID: <20121105210421.GA14819@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must not call timekeeping functions unless they are available. If we dump
before they have resumed, avoid a WARN_ON by setting the timestamp to 0.

Reported-by: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/ram.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1a4f6da..6d014e0 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -171,7 +171,13 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
 	struct timeval timestamp;
 	size_t len;
 
-	do_gettimeofday(&timestamp);
+	/* Handle dumping before timekeeping has resumed. */
+	if (unlikely(timekeeping_suspended)) {
+		timestamp.tv_sec = 0;
+		timestamp.tv_usec = 0;
+	} else
+		do_gettimeofday(&timestamp);
+
 	hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
 		(long)timestamp.tv_sec, (long)timestamp.tv_usec);
 	WARN_ON_ONCE(!hdr);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
