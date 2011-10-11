Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1JKREW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:04:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab1JKRET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:04:19 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:09 2011
Message-Id: <20111011165709.839594109@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:20 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [10/38] ide-disk: Fix request requeuing
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <bp@alien8.de>

commit 2c8fc867602e385fd2abe76da0b6bda8ed907547 upstream.

Simon Kirby reported that on his RAID setup with idedisk underneath
the box OOMs after a couple of days of runtime. Running with
CONFIG_DEBUG_KMEMLEAK pointed to idedisk_prep_fn() which unconditionally
allocates an ide_cmd struct. However, ide_requeue_and_plug() can be
called more than once per request, either from the request issue or the
IRQ handler path and do blk_peek_request() ends up in idedisk_prep_fn()
repeatedly, allocating a struct ide_cmd everytime and "forgetting" the
previous pointer.

Make sure the code reuses the old allocated chunk.

Reported-and-tested-by: Simon Kirby <sim@hostway.ca>
Link: http://marc.info/?l=linux-kernel&m=131667641517919
Link: http://lkml.kernel.org/r/20110922072643.GA27232@hostway.ca
Signed-off-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-disk.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -435,7 +435,12 @@ static int idedisk_prep_fn(struct reques
 	if (!(rq->cmd_flags & REQ_FLUSH))
 		return BLKPREP_OK;
 
-	cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
+	if (rq->special) {
+		cmd = rq->special;
+		memset(cmd, 0, sizeof(*cmd));
+	} else {
+		cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
+	}
 
 	/* FIXME: map struct ide_taskfile on rq->cmd[] */
 	BUG_ON(cmd == NULL);


