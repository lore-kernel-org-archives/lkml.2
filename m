Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0JVOFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:05:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40062 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0JVOFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:05:44 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] bluetooth: Fix missing NULL check
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Fri, 22 Oct 2010 14:11:26 +0100
Message-ID: <20101022131035.5432.73129.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fortunately this is only exploitable on very unusual hardware.

[Reported a while ago but nothing happened so just fixing it]

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
---

 drivers/bluetooth/hci_ldisc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 74cb6f3..7201482 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -256,9 +256,16 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 
 	BT_DBG("tty %p", tty);
 
+	/* FIXME: This btw is bogus, nothing requires the old ldisc to clear
+	   the pointer */
 	if (hu)
 		return -EEXIST;
 
+	/* Error if the tty has no write op instead of leaving an exploitable
+	   hole */
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
 	if (!(hu = kzalloc(sizeof(struct hci_uart), GFP_KERNEL))) {
 		BT_ERR("Can't allocate control structure");
 		return -ENFILE;

