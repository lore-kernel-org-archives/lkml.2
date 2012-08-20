Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2HTR3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:29:40 -0400
Received: from mx.meyering.net ([88.168.87.75]:44788 "EHLO hx.meyering.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753596Ab2HTR30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:29:26 -0400
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Jim Meyering <meyering@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org
Subject: [PATCH] kmemleak: avoid buffer overrun: NUL-terminate strncpy-copied command
Date: Mon, 20 Aug 2012 18:55:22 +0200
Message-Id: <1345481724-30108-4-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345481724-30108-1-git-send-email-jim@meyering.net>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Meyering <meyering@redhat.com>

strncpy NUL-terminates only when the length of the source string
is smaller than the size of the destination buffer.
The two other strncpy uses (just preceding) happen to be ok
with the current TASK_COMM_LEN (16), because the literals
"hardirq" and "softirq" are both shorter than 16.  However,
technically it'd be better to use strcpy along with a
compile-time assertion that they fit in the buffer.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 mm/kmemleak.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 45eb621..947257f 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -555,6 +555,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 		 * case, the command line is not correct.
 		 */
 		strncpy(object->comm, current->comm, sizeof(object->comm));
+		object->comm[sizeof(object->comm) - 1] = 0;
 	}

 	/* kernel backtrace */
-- 
1.7.12

