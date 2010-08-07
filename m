Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762565Ab0HGJ4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 05:56:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33985 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762343Ab0HGJ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 05:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FU01FmoZzTd2CuyByQoryw/RC8rjqzKeNUi+lPXeRCOKtE0bUuqblqZPS0RpdvzzkS
         NS23td/O1oH65LqdPQXDWJtulZb45TjFDNMHRWMKtwEi9dXN1R31DvNQxlyIeVYSfzpu
         cDZax3qJXZP8FkCaEMV7gW4Fdv5KY6LT9tG/E=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] serport: place serport serio device correctly in the device tree
Date: Sat,  7 Aug 2010 13:55:39 +0400
Message-Id: <1281174939-6349-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100806165758.GA3364@suse.de>
References: <20100806165758.GA3364@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make serport serio device to be a child of corresponding tty device
instead of just hanging at /sys/devices/serioX.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/input/serio/serport.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 6d34511..d3d832a 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -148,6 +148,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 {
 	struct serport *serport = (struct serport*) tty->disc_data;
 	struct serio *serio;
+	struct device *parent;
 	char name[64];
 
 	if (test_and_set_bit(SERPORT_BUSY, &serport->flags))
@@ -157,6 +158,8 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	if (!serio)
 		return -ENOMEM;
 
+	parent = tty_get_device(tty);
+
 	strlcpy(serio->name, "Serial port", sizeof(serio->name));
 	snprintf(serio->phys, sizeof(serio->phys), "%s/serio0", tty_name(tty, name));
 	serio->id = serport->id;
@@ -165,6 +168,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	serio->open = serport_serio_open;
 	serio->close = serport_serio_close;
 	serio->port_data = serport;
+	serio->dev.parent = parent;
 
 	serio_register_port(serport->serio);
 	printk(KERN_INFO "serio: Serial port %s\n", tty_name(tty, name));
@@ -173,6 +177,8 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	serio_unregister_port(serport->serio);
 	serport->serio = NULL;
 
+	put_device(parent);
+
 	clear_bit(SERPORT_DEAD, &serport->flags);
 	clear_bit(SERPORT_BUSY, &serport->flags);
 
-- 
1.7.1

