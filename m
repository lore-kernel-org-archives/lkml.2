Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1FPHGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:06:48 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53840 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756620Ab1FPHGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:06:04 -0400
X-Sasl-enc: Z4Dm351cCpBWs+G/IQ8egVl27bSh3bh98Cka/N4yHtHy 1308207963
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:14 2011
Message-Id: <20110616001614.573622193@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [54/91] UBIFS: fix memory leak on error path
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -665,6 +665,7 @@ out_free:
 
 out_release:
 	release_head(c, BASEHD);
+	kfree(dent);
 out_ro:
 	ubifs_ro_mode(c, err);
 	if (last_reference)


