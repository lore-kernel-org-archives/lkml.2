Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0LHAs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:48:57 -0500
Received: from kroah.org ([198.145.64.141]:58778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab0LHAs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:27 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:37 2010
Message-Id: <20101208004437.025789226@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:45:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [127/127] x86: uv: xpc NULL deref when mesq becomes empty
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robin Holt <holt@sgi.com>

commit 15b87d67ff3dc042bee42f991858d6b121b3b3ca upstream.

Under heavy load conditions, our set of xpc messages may become exhausted.
 The code handles this correctly with the exception of the management code
which hits a NULL pointer dereference.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sgi-xp/xpc_uv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -965,11 +965,13 @@ xpc_get_fifo_entry_uv(struct xpc_fifo_he
 		head->first = first->next;
 		if (head->first == NULL)
 			head->last = NULL;
+
+		head->n_entries--;
+		BUG_ON(head->n_entries < 0);
+
+		first->next = NULL;
 	}
-	head->n_entries--;
-	BUG_ON(head->n_entries < 0);
 	spin_unlock_irqrestore(&head->lock, irq_flags);
-	first->next = NULL;
 	return first;
 }
 


