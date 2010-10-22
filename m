Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab0JVSVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:21:46 -0400
Received: from kroah.org ([198.145.64.141]:41890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559Ab0JVSVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wang <jason77.wang@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/49] serial-core: restore termios settings when resume console ports
Date: Fri, 22 Oct 2010 11:20:56 -0700
Message-Id: <1287771688-14805-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jason77.wang@gmail.com>

The commit 4547be7 rewrites suspend and resume functions. According
to this rewrite, when a serial port is a printk console device and
can suspend(without set no_console_suspend flag), it will definitely
call set_termios function during its resume, but parameter termios
isn't initialized, this will pass an unpredictable config to the
serial port. If this serial port is not a userspace opened tty device
, a suspend and resume action will make this serial port unusable.
I.E. ttyS0 is a printk console device, ttyS1 or keyboard+display is
userspace tty device, a suspend/resume action will make ttyS0
unusable.

If a serial port is both a printk console device and an opened tty
device, this issue can be overcome because it will call set_termios
again with the correct parameter in the uart_change_speed function.

Refer to the deleted content of commit 4547be7, revert parts relate
to restore settings into parameter termios. It is safe because if
a serial port is a printk console only device, the only meaningful
field in termios is c_cflag and its old config is saved in
uport->cons->cflag, if this port is also an opened tty device,
it will clear uport->cons->cflag in the uart_open and the old config
is saved in tty->termios.

Signed-off-by: Jason Wang <jason77.wang@gmail.com>
Acked-by: Stanislav Brabec <sbrabec@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index ff21200..bc6cddd 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2066,6 +2066,18 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 	 * Re-enable the console device after suspending.
 	 */
 	if (console_suspend_enabled && uart_console(uport)) {
+		/*
+		 * First try to use the console cflag setting.
+		 */
+		memset(&termios, 0, sizeof(struct ktermios));
+		termios.c_cflag = uport->cons->cflag;
+
+		/*
+		 * If that's unset, use the tty termios setting.
+		 */
+		if (port->tty && port->tty->termios && termios.c_cflag == 0)
+			termios = *(port->tty->termios);
+
 		uart_change_pm(state, 0);
 		uport->ops->set_termios(uport, &termios, NULL);
 		console_start(uport->cons);
-- 
1.7.2

