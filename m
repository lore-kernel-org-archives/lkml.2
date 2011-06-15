Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab1FPHlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:41:31 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59498 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755053Ab1FPHAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:19 -0400
X-Sasl-enc: enu/Cg3k1RVe7+Nt3wtibRME+eKmWtENZgbzAtdK+rQc 1308207619
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:30 2011
Message-Id: <20110616000230.273942561@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [13/89] UBIFS: fix memory leak on error path
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 812eb258311f89bcd664a34a620f249d54a2cd83 upstream.

UBIFS leaks memory on error path in 'ubifs_jnl_update()' in case of write
failure because it forgets to free the 'struct ubifs_dent_node *dent' object.
Although the object is small, the alignment can make it large - e.g., 2KiB
if the min. I/O unit is 2KiB.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/journal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -666,6 +666,7 @@ out_free:
 
 out_release:
 	release_head(c, BASEHD);
+	kfree(dent);
 out_ro:
 	ubifs_ro_mode(c, err);
 	if (last_reference)


