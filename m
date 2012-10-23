Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab2JWUBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:01:53 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:49915 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab2JWT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:59:14 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 16/23] cx88: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:19 -0300
Message-Id: <1351022246-8201-16-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Found by coccinelle. Hand patched and reviewed.
Tested by compilation only.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier struct_name;
struct struct_name to;
struct struct_name from;
expression E;
@@
-memcpy(&(to), &(from), E);
+to = from;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/pci/cx88/cx88-cards.c      |    2 +-
 drivers/media/pci/cx88/cx88-i2c.c        |    3 +--
 drivers/media/pci/cx88/cx88-vp3054-i2c.c |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 0c25524..e2e0b8f 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -3743,7 +3743,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 		cx88_card_list(core, pci);
 	}
 
-	memcpy(&core->board, &cx88_boards[core->boardnr], sizeof(core->board));
+	core->board = cx88_boards[core->boardnr];
 
 	if (!core->board.num_frontends && (core->board.mpeg & CX88_MPEG_DVB))
 		core->board.num_frontends = 1;
diff --git a/drivers/media/pci/cx88/cx88-i2c.c b/drivers/media/pci/cx88/cx88-i2c.c
index de0f1af..cf2d696 100644
--- a/drivers/media/pci/cx88/cx88-i2c.c
+++ b/drivers/media/pci/cx88/cx88-i2c.c
@@ -139,8 +139,7 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 	if (i2c_udelay<5)
 		i2c_udelay=5;
 
-	memcpy(&core->i2c_algo, &cx8800_i2c_algo_template,
-	       sizeof(core->i2c_algo));
+	core->i2c_algo = cx8800_i2c_algo_template;
 
 
 	core->i2c_adap.dev.parent = &pci->dev;
diff --git a/drivers/media/pci/cx88/cx88-vp3054-i2c.c b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
index d77f8ec..deede6e 100644
--- a/drivers/media/pci/cx88/cx88-vp3054-i2c.c
+++ b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
@@ -118,8 +118,7 @@ int vp3054_i2c_probe(struct cx8802_dev *dev)
 		return -ENOMEM;
 	dev->vp3054 = vp3054_i2c;
 
-	memcpy(&vp3054_i2c->algo, &vp3054_i2c_algo_template,
-	       sizeof(vp3054_i2c->algo));
+	vp3054_i2c->algo = vp3054_i2c_algo_template;
 
 	vp3054_i2c->adap.dev.parent = &dev->pci->dev;
 	strlcpy(vp3054_i2c->adap.name, core->name,
-- 
1.7.4.4

