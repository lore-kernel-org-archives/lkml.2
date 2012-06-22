Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762363Ab2FVPYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:24:34 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40738 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762296Ab2FVPYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:24:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 03/12] tty: note race we need to fix
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:40:20 +0100
Message-ID: <20120622153900.1405.47389.stgit@localhost.localdomain>
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was identified by Vincent Pillet with a high speed interface that uses
low latency mode. In the low latency case we have a tiny race but it can
be hit.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/n_tty.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index ee1c268..4f34491 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1432,6 +1432,12 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	 */
 	if (tty->receive_room < TTY_THRESHOLD_THROTTLE)
 		tty_throttle(tty);
+
+        /* FIXME: there is a tiny race here if the receive room check runs
+           before the other work executes and empties the buffer (upping
+           the receiving room and unthrottling. We then throttle and get
+           stuck. This has been observed and traced down by Vincent Pillet/
+           We need to address this when we sort out out the rx path locking */
 }
 
 int is_ignored(int sig)

