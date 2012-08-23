Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862Ab2HWKpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:45:47 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:58828 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758279Ab2HWKhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:09 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 01/23] serial: omap: define and use to_uart_omap_port()
Date: Thu, 23 Aug 2012 13:32:41 +0300
Message-Id: <1345717983-18179-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current code only works because struct uart_port
is the first member on the uart_omap_port structure.

If, for whatever reason, someone puts another
member as the first of the structure, that cast
won't work anymore. In order to be safe, let's use
a container_of() which, for now, gets optimized into
a cast anyway.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/plat-omap/include/plat/omap-serial.h |  2 ++
 drivers/tty/serial/omap-serial.c              | 36 +++++++++++++--------------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index 1a52725..f3b35d9 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -137,4 +137,6 @@ struct uart_omap_port {
 	struct work_struct	qos_work;
 };
 
+#define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
+
 #endif /* __OMAP_SERIAL_H__ */
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index d3cda0c..5c0d0bc 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -141,7 +141,7 @@ static void serial_omap_stop_rxdma(struct uart_omap_port *up)
 
 static void serial_omap_enable_ms(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 
 	dev_dbg(up->port.dev, "serial_omap_enable_ms+%d\n", up->port.line);
 
@@ -153,7 +153,7 @@ static void serial_omap_enable_ms(struct uart_port *port)
 
 static void serial_omap_stop_tx(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
 
 	if (up->use_dma &&
@@ -186,7 +186,7 @@ static void serial_omap_stop_tx(struct uart_port *port)
 
 static void serial_omap_stop_rx(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 
 	pm_runtime_get_sync(&up->pdev->dev);
 	if (up->use_dma)
@@ -307,7 +307,7 @@ static inline void serial_omap_enable_ier_thri(struct uart_omap_port *up)
 
 static void serial_omap_start_tx(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
 	struct circ_buf *xmit;
 	unsigned int start;
@@ -449,7 +449,7 @@ static inline irqreturn_t serial_omap_irq(int irq, void *dev_id)
 
 static unsigned int serial_omap_tx_empty(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned long flags = 0;
 	unsigned int ret = 0;
 
@@ -464,7 +464,7 @@ static unsigned int serial_omap_tx_empty(struct uart_port *port)
 
 static unsigned int serial_omap_get_mctrl(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned int status;
 	unsigned int ret = 0;
 
@@ -487,7 +487,7 @@ static unsigned int serial_omap_get_mctrl(struct uart_port *port)
 
 static void serial_omap_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned char mcr = 0;
 
 	dev_dbg(up->port.dev, "serial_omap_set_mctrl+%d\n", up->port.line);
@@ -511,7 +511,7 @@ static void serial_omap_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 static void serial_omap_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned long flags = 0;
 
 	dev_dbg(up->port.dev, "serial_omap_break_ctl+%d\n", up->port.line);
@@ -528,7 +528,7 @@ static void serial_omap_break_ctl(struct uart_port *port, int break_state)
 
 static int serial_omap_startup(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned long flags = 0;
 	int retval;
 
@@ -606,7 +606,7 @@ static int serial_omap_startup(struct uart_port *port)
 
 static void serial_omap_shutdown(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned long flags = 0;
 
 	dev_dbg(up->port.dev, "serial_omap_shutdown+%d\n", up->port.line);
@@ -721,7 +721,7 @@ static void
 serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 			struct ktermios *old)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned char cval = 0;
 	unsigned char efr = 0;
 	unsigned long flags = 0;
@@ -932,7 +932,7 @@ static void
 serial_omap_pm(struct uart_port *port, unsigned int state,
 	       unsigned int oldstate)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned char efr;
 
 	dev_dbg(up->port.dev, "serial_omap_pm+%d\n", up->port.line);
@@ -971,7 +971,7 @@ static int serial_omap_request_port(struct uart_port *port)
 
 static void serial_omap_config_port(struct uart_port *port, int flags)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 
 	dev_dbg(up->port.dev, "serial_omap_config_port+%d\n",
 							up->port.line);
@@ -989,7 +989,7 @@ serial_omap_verify_port(struct uart_port *port, struct serial_struct *ser)
 static const char *
 serial_omap_type(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 
 	dev_dbg(up->port.dev, "serial_omap_type+%d\n", up->port.line);
 	return up->name;
@@ -1032,7 +1032,7 @@ static inline void wait_for_xmitr(struct uart_omap_port *up)
 
 static void serial_omap_poll_put_char(struct uart_port *port, unsigned char ch)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 
 	pm_runtime_get_sync(&up->pdev->dev);
 	wait_for_xmitr(up);
@@ -1042,7 +1042,7 @@ static void serial_omap_poll_put_char(struct uart_port *port, unsigned char ch)
 
 static int serial_omap_poll_get_char(struct uart_port *port)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 	unsigned int status;
 
 	pm_runtime_get_sync(&up->pdev->dev);
@@ -1065,7 +1065,7 @@ static struct uart_driver serial_omap_reg;
 
 static void serial_omap_console_putchar(struct uart_port *port, int ch)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)port;
+	struct uart_omap_port *up = to_uart_omap_port(port);
 
 	wait_for_xmitr(up);
 	serial_out(up, UART_TX, ch);
@@ -1341,7 +1341,7 @@ static void serial_omap_continue_tx(struct uart_omap_port *up)
 
 static void uart_tx_dma_callback(int lch, u16 ch_status, void *data)
 {
-	struct uart_omap_port *up = (struct uart_omap_port *)data;
+	struct uart_omap_port *up = data;
 	struct circ_buf *xmit = &up->port.state->xmit;
 
 	xmit->tail = (xmit->tail + up->uart_dma.tx_buf_size) & \
-- 
1.7.12.rc3

