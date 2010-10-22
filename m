Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0JVSh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:37:59 -0400
Received: from kroah.org ([198.145.64.141]:41887 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607Ab0JVSVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wang <jason77.wang@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/49] serial-core: skip call set_termios/console_start when no_console_suspend
Date: Fri, 22 Oct 2010 11:20:55 -0700
Message-Id: <1287771688-14805-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jason77.wang@gmail.com>

The commit 4547be7 rewrites suspend and resume functions, this
introduces a problem on the OMAP3EVM platoform. when the kernel boots
with no_console_suspend and we suspend the kernel, then resume it,
the serial console will be not usable. This problem should be common
for all platforms.
The cause for this problem is that when enter suspend, if we choose
no_console_suspend, the console_stop will be skiped. But in resume
function, the console port will be set to uninitialized state by
calling set_termios function and the console_start is called without
checking whether the no_console_suspend is set, Now fix it.

Signed-off-by: Jason Wang <jason77.wang@gmail.com>
Acked-by: Stanislav Brabec <sbrabec@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.2

