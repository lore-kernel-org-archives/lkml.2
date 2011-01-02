Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1ABHZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:36981 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1ABHZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 224/260] bluetooth: Fix missing NULL check
Date: Sun,  2 Jan 2011 02:18:40 -0500
Message-Id: <1293952756-15010-225-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:14.0511 (UTC) FILETIME=[0EF21BF0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

commit c19483cc5e56ac5e22dd19cf25ba210ab1537773 upstream.

Fortunately this is only exploitable on very unusual hardware.

[Reported a while ago but nothing happened so just fixing it]

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/bluetooth/hci_ldisc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 76a1abb..283b127 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -258,9 +258,16 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 
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
-- 
1.7.3.3

