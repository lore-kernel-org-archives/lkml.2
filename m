Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab0KSWSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:18:41 -0500
Received: from kroah.org ([198.145.64.141]:52838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972Ab0KSWEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:06 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:23 2010
Message-Id: <20101119220123.008175412@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>
Subject: [10/66] bluetooth: Fix missing NULL check
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit c19483cc5e56ac5e22dd19cf25ba210ab1537773 upstream.

Fortunately this is only exploitable on very unusual hardware.

[Reported a while ago but nothing happened so just fixing it]

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/hci_ldisc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -256,9 +256,16 @@ static int hci_uart_tty_open(struct tty_
 
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


