Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab0HQC6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:58:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0HQC6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:58:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=NVj1ZSmjEMnE5/6QnYLS69js2rUyYF92NDt2+qzn7L4GJ7wx0vA4iqGqW4rP1cBpC
	7gCwbuOc2WwfPvYC+1ewA==
Date: Mon, 16 Aug 2010 19:58:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 4/6] jbd: remove dependency on __GFP_NOFAIL
In-Reply-To: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008161956190.17924@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
caller.

The error handling when kzalloc() returns NULL in start_this_handle()
was removed since it was unreachable.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/jbd/journal.c     |    5 ++++-
 fs/jbd/transaction.c |   14 ++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -301,7 +301,10 @@ int journal_write_metadata_buffer(transaction_t *transaction,
 	 */
 	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
 
-	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
+	do {
+		/* FIXME: this may potentially loop forever */
+		new_bh = alloc_buffer_head(GFP_NOFS);
+	} while (!new_bh);
 	/* keep subsequent assertions sane */
 	new_bh->b_state = 0;
 	init_buffer(new_bh, NULL, NULL);
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -98,14 +98,12 @@ static int start_this_handle(journal_t *journal, handle_t *handle)
 	}
 
 alloc_transaction:
-	if (!journal->j_running_transaction) {
-		new_transaction = kzalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
-		if (!new_transaction) {
-			ret = -ENOMEM;
-			goto out;
-		}
-	}
+	if (!journal->j_running_transaction)
+		do {
+			/* FIXME: this may potentially loop forever */
+			new_transaction = kzalloc(sizeof(*new_transaction),
+								GFP_NOFS);
+		} while (!new_transaction);
 
 	jbd_debug(3, "New handle %p going live.\n", handle);
 
