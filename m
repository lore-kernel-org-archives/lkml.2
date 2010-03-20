Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0CTCAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 22:00:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab0CTCAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 22:00:48 -0400
Message-ID: <4BA42C05.3060800@kernel.org>
Date: Fri, 19 Mar 2010 18:59:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v5] x86: do not free zero sized per cpu areas
References: <4B914A61.20409@kernel.org> <4BA3F82D.5090807@kernel.org> <4BA3F8ED.2090600@zytor.com> <4BA407B8.7070503@kernel.org> <4BA408EE.5000001@zytor.com> <4BA40C83.1030202@kernel.org> <alpine.LFD.2.00.1003191758460.18017@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003191758460.18017@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

This avoids an infinite loop in free_early_partial().

Add a warning to free_early_partial to catch future problems.

-v5: put back start > end back into WARN_ONCE()

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/early_res.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/kernel/early_res.c
===================================================================
--- linux-2.6.orig/kernel/early_res.c
+++ linux-2.6/kernel/early_res.c
@@ -333,6 +333,14 @@ void __init free_early_partial(u64 start
 	struct early_res *r;
 	int i;
 
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end,
+		      "free_early_partial got wrong start/end %#llx/%#llx\n",
+		      start, end))
+		return;
+
 try_next:
 	i = find_overlapped_early(start, end);
 	if (i >= max_early_res)
