Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0IDCNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:13:38 -0400
Received: from kroah.org ([198.145.64.141]:48240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab0IDCNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:13:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nathael Pajani <nathael.pajani@ed3l.fr>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] tty: fix tty_line must not be equal to number of allocated tty pointers in tty driver
Date: Fri,  3 Sep 2010 19:13:22 -0700
Message-Id: <1283566402-28832-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100904020937.GA28645@kroah.com>
References: <20100904020937.GA28645@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathael Pajani <nathael.pajani@ed3l.fr>

I found a bug "by chance" in drivers/char/tty_io.c

I mean "by chance" because I was just reading the code of the
tty_find_polling_driver() to make a new tty_find_by_name() function.

In tty_find_polling_driver() the driver actually test "tty_line <=
p->num" while num refers to the number of struct tty_struct pointers
allocated for the p->ttys (p is a tty_driver), and tty_line is scanned
in a tty name, which can be for example ttyS2. Then tty_line equals 2.
And if p->num is 2, we have only p->ttys[0] and p->ttys[1], but no
p->ttys[2].

This is actually unharmful, for tty_find_polling_driver() is used only
in drivers/serial/kgdboc.c, and there's a test over there to find a
console with a matching index, which will never happen.

This is still a bug anyway.

Signed-off-by: Nathael Pajani <nathael.pajani@ed3l.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 949067a..613c852 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -355,7 +355,7 @@ struct tty_driver *tty_find_polling_driver(char *name, int *line)
 		if (*stp == '\0')
 			stp = NULL;
 
-		if (tty_line >= 0 && tty_line <= p->num && p->ops &&
+		if (tty_line >= 0 && tty_line < p->num && p->ops &&
 		    p->ops->poll_init && !p->ops->poll_init(p, tty_line, stp)) {
 			res = tty_driver_kref_get(p);
 			*line = tty_line;
-- 
1.7.2

