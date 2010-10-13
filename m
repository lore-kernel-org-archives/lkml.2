Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0JMF6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:58:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56997 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0JMF6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:58:08 -0400
Date: Wed, 13 Oct 2010 14:58:06 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] Serial: BUGFIX: uart_resume_port has an omitted condition.
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@gmail.com, kyungmin.park@samsung.com,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andr Goddard Rosa <andre.goddard@gmail.com>,
        Stanislav Brabec <sbrabec@suse.cz>
Message-id: <1286949486-2446-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.6.3.3
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 13 Oct 2010 05:58:06.0850 (UTC)
 FILETIME=[9B51DE20:01CB6A9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When console_suspend_enabled == 0, console_stop() was not called at
suspend; thus, it does not need to call console_start() when resume.
Besides, calling console_start() without calling console_stop() before
had been incurring kernel hang with console_suspend_enabled == 0 in a
machine with drivers/serial/samsung.c and s5pc210.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/serial/serial_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index cd85112..ff21200 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2065,7 +2065,7 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 	/*
 	 * Re-enable the console device after suspending.
 	 */
-	if (uart_console(uport)) {
+	if (console_suspend_enabled && uart_console(uport)) {
 		uart_change_pm(state, 0);
 		uport->ops->set_termios(uport, &termios, NULL);
 		console_start(uport->cons);
-- 
1.6.3.3

