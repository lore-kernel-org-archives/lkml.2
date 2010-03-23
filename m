Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0CWOvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0CWOut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:50:49 -0400
Date: Tue, 23 Mar 2010 15:48:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/2] keyctl_session_to_parent: use thread_group_empty()
	to check singlethreadness
Message-ID: <20100323144843.GA10431@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

keyctl_session_to_parent() is the only user of signal->count which needs
the correct value. Change it to use thread_group_empty() instead, this
must be strictly equivalent under tasklist, and imho looks better.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 security/keys/keyctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 34-rc1/security/keys/keyctl.c~MISC_2_KEYCTL	2009-12-18 19:05:38.000000000 +0100
+++ 34-rc1/security/keys/keyctl.c	2010-03-23 15:21:00.000000000 +0100
@@ -1269,7 +1269,7 @@ long keyctl_session_to_parent(void)
 		goto not_permitted;
 
 	/* the parent must be single threaded */
-	if (atomic_read(&parent->signal->count) != 1)
+	if (!thread_group_empty(parent))
 		goto not_permitted;
 
 	/* the parent and the child must have different session keyrings or

