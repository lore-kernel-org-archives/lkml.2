Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab0ESBkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:40:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:41101 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab0ESBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 11/25] sh,sh-sci: Use NO_POLL_CHAR in the SCIF polled console code
Date: Tue, 18 May 2010 20:39:21 -0500
Message-Id: <1274233175-3675-12-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:50.0860 (UTC) FILETIME=[2C4430C0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sci_poll_get_char() needs to return immediately if there is no
input from the chip to process, and must return a value of
NO_POLL_CHAR.

This allows kgdboc to process multiple polled devices while kgdb is
active.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---
 drivers/serial/sh-sci.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 8eb094c..725301f 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -150,7 +150,11 @@ static int sci_poll_get_char(struct uart_port *port)
 			handle_error(port);
 			continue;
 		}
-	} while (!(status & SCxSR_RDxF(port)));
+		break;
+	} while (1);
+
+	if (!(status & SCxSR_RDxF(port)))
+		return NO_POLL_CHAR;
 
 	c = sci_in(port, SCxRDR);
 
-- 
1.6.3.3

