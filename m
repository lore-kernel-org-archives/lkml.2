Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1AJNHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:07:50 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:47700 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab1AJNHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:07:44 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Russell Coker <russell@coker.com.au>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Rodolfo Giometti <giometti@linux.it>
Date: Mon, 10 Jan 2011 14:06:58 +0100
Message-Id: <1294664819-17960-2-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294664819-17960-1-git-send-email-giometti@linux.it>
References: <1294664819-17960-1-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 1/1] char nvtty: Network Virtual Terminal support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Network Virtual terminal (NVT tty) is a software device consisting
of one halves: a client device, which is identical to a physical
terminal, who, is turn, get connected with a remote server where real
tty devices are located.

These devices are specified by RFC 854 and RFC 2217 and ther name into
the system is /dev/nvttyX (by default you have 4 devices).

By using these devices and a proper compatible server (not included
here but you can use sredird) you can get access to a remote tty
device as the tty device itself was conneted with your local host.
All data and settings are sent and received through the network.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 Documentation/ABI/testing/sysfs-nvtty |   35 +
 drivers/char/Kconfig                  |   22 +
 drivers/char/Makefile                 |    1 +
 drivers/char/nvtty.c                  | 1557 +++++++++++++++++++++++++++++++++
 4 files changed, 1615 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-nvtty
 create mode 100644 drivers/char/nvtty.c

diff --git a/Documentation/ABI/testing/sysfs-nvtty b/Documentation/ABI/testing/sysfs-nvtty
new file mode 100644
index 0000000..a52d319
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-nvtty
@@ -0,0 +1,35 @@
+What:		/sys/class/tty/nvttyX/
+Date:		January 2011
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/tty/nvttyX/ directory is related to X-th
+		NVT tty device into the system. Each directory will
+		contain files to manage and control its NVT tty device.
+
+What:		/sys/class/tty/nvttyX/connection
+Date:		January 2011
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/tty/nvttyX/connection file reports 1 if the
+		related NVT tty device is connected with remote server and
+		0 otherwise.
+
+What:		/sys/class/tty/nvttyX/ip
+Date:		January 2011
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/tty/nvttyX/ip file reports the IP address
+		of the remote server where to connecto to.
+		User should change this value, when no connection is active,
+		in order to select a different remote server.
+		Default is localhost (127.0.0.1).
+
+What:		/sys/class/tty/nvttyX/port
+Date:		January 2011
+Contact:	Rodolfo Giometti <giometti@linux.it>
+Description:
+		The /sys/class/tty/nvttyX/port file reports the IP port number
+		of the remote server where to connecto to.
+		User should change this value, when no connection is active,
+		in order to select a different port.
+		Default is 32769.
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 43d3395..b0a1055 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -451,6 +451,28 @@ config UNIX98_PTYS
 	  All modern Linux systems use the Unix98 ptys.  Say Y unless
 	  you're on an embedded system and want to conserve memory.
 
+config NVT_TTY
+	tristate "Network Virtual Terminal"
+	default n
+	---help---
+	  A Network Virtual terminal (NVT tty) is a software device
+	  consisting of one halve: a client device, which is
+	  identical to a physical terminal, who, is turn, gets
+	  connected to a remote server where real tty devices are
+	  located.
+
+	  These devices are specified by RFC 854 and RFC 2217 and their
+	  name into the system is /dev/nvttyX (by default there are 4
+	  devices).
+
+	  By using these devices and a proper compatible server (not
+	  included here but you can use sredird) you can get access to
+	  a remote tty device as though the tty device itself was connected
+	  with your local host.  All data and settings are sent and
+	  received through the network.
+
+	  If unsure, say N.
+
 config DEVPTS_MULTIPLE_INSTANCES
 	bool "Support multiple instances of devpts"
 	depends on UNIX98_PTYS
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index ba53ec9..7deba37 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -4,6 +4,7 @@
 
 obj-y				+= mem.o random.o
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
+obj-$(CONFIG_NVT_TTY)		+= nvtty.o
 obj-y				+= misc.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
 obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
diff --git a/drivers/char/nvtty.c b/drivers/char/nvtty.c
new file mode 100644
index 0000000..14b9fb9
--- /dev/null
+++ b/drivers/char/nvtty.c
@@ -0,0 +1,1557 @@
+/*
+ * Network Virtual Terminal (RFC 854) with Com Port option (RFC 2217)
+ *
+ * Copyright (C) 2011   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * This code has been derived from cyclades-serial-client by Cyclades and
+ * Russell Coker <russell@coker.com.au>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/kthread.h>
+#include <linux/net.h>
+#include <linux/in.h>
+
+/*
+ * Printing stuff
+ */
+
+#if defined(DEBUG)
+#define nvtty_info(info, fmt, args...)	dev_info((info)->tty->dev, \
+				"%s[%d]: " fmt "\n", __func__, __LINE__ , \
+								## args)
+#define nvtty_err(info, fmt, args...)	dev_err((info)->tty->dev, \
+				"%s[%d]: " fmt "\n", __func__, __LINE__ , \
+								## args)
+#define nvtty_dbg(info, fmt, args...)	dev_dbg((info)->tty->dev, \
+				"%s[%d]: " fmt "\n", __func__, __LINE__ , \
+								## args)
+#else
+#define nvtty_info(info, fmt, args...)	dev_info((info)->tty->dev, \
+				"%s: " fmt "\n" , __func__ , ## args)
+#define nvtty_err(info, fmt, args...)	dev_err((info)->tty->dev, \
+				"%s: " fmt "\n" , __func__ , ## args)
+#define nvtty_dbg(info, fmt, args...)	dev_dbg((info)->tty->dev, \
+				"%s: " fmt "\n" , __func__ , ## args)
+#endif
+
+/*
+ * RFC stuff
+ */
+
+/* Telnet Special chars */
+#define IAC				255
+#define WILL				251
+#define WONT				252
+#define DO				253
+#define DONT				254
+#define SE				240
+#define SB				250
+
+/* Telnet receiver substates */
+enum s_state {
+	S_DATA,
+	S_IAC,
+	S_WILL,
+	S_WONT,
+	S_DO,
+	S_DONT,
+	S_SB,
+	S_SE
+};
+
+/* Telnet Options stuff */
+enum nvt_opt {
+	NVT_BINARY			= 0,
+	NVT_ECHO			= 1,
+	NVT_SUPP_GO_AHEAD		= 3,
+	NVT_COM_PORT_OPTION		= 44,
+	__NVT_NUMOPTS
+};
+
+#define I_WILL				0x01 /* I desire to support it */
+#define I_DO				0x02 /* I do support it */
+#define I_SENT				0x04 /* I desire and already sent it */
+#define HE_WILL				0x10 /* I want he supports it */
+#define HE_DOES				0x20 /* He supports it */
+#define HE_RECV				0x40 /* He recv my response */
+
+#define I_WANT_TO_SUPPORT(info, opt)	((info)->option[opt] & I_WILL)
+#define I_DO_SUPPORT(info, opt)		((info)->option[opt] & I_DO)
+#define I_SENT_IT(info, opt)		((info)->option[opt] & I_SENT)
+
+#define HE_MAY_SUPPORT(info, opt)	((info)->option[opt] & HE_WILL)
+#define HE_DOES_SUPPORT(info, opt)	((info)->option[opt] & HE_DOES)
+#define HE_RECV_IT(info, opt)		((info)->option[opt] & HE_RECV)
+
+#define SET_I_WANT_TO_SUPPORT(info, opt)((info)->option[opt] |= I_WILL)
+#define SET_I_DO_SUPPORT(info, opt)	((info)->option[opt] |= I_DO)
+#define SET_I_SENT_IT(info, opt)	((info)->option[opt] |= I_SENT)
+
+#define SET_HE_MAY_SUPPORT(info, opt)	((info)->option[opt] |= HE_WILL)
+#define SET_HE_DOES_SUPPORT(info, opt)	((info)->option[opt] |= HE_DOES)
+#define SET_HE_RECV_IT(info, opt)	((info)->option[opt] |= HE_RECV)
+
+#define CLR_I_WANT_TO_SUPPORT(info, opt)((info)->option[opt] &= ~I_WILL)
+#define CLR_I_DO_SUPPORT(info, opt)	((info)->option[opt] &= ~I_DO)
+#define CLR_I_SENT_IT(info, opt)	((info)->option[opt] &= ~I_SENT)
+
+#define CLR_HE_MAY_SUPPORT(info, opt)	((info)->option[opt] &= ~HE_WILL)
+#define CLR_HE_DOES_SUPPORT(info, opt)	((info)->option[opt] &= ~HE_DOES)
+#define CLR_HE_RECV_IT(info, opt)	((info)->option[opt] &= ~HE_RECV)
+
+/* Com port commands and notifications */
+
+/* Client codes  */
+enum nvt_c_code {
+	USR_COM_SIGNATURE,		/* none, RFC2217 says */
+	USR_COM_SET_BAUDRATE,
+	USR_COM_SET_DATASIZE,
+	USR_COM_SET_PARITY,
+	USR_COM_SET_STOPSIZE,
+	USR_COM_SET_CONTROL,
+	USR_COM_NOTIFY_LINESTATE,
+	USR_COM_NOTIFY_MODEMSTATE,
+	USR_COM_FLOWCONTROL_SUSPEND,
+	USR_COM_FLOWCONTROL_RESUME,
+	USR_COM_SET_LINESTATE_MASK,
+	USR_COM_SET_MODEMSTATE_MASK,
+	USR_COM_PURGE_DATA,
+	__USR_NUMCOMS
+};
+
+#define SET_CMD_ACTIVE(info, n)		\
+		init_completion(&((info)->cmd[n]))
+#define CLR_CMD_ACTIVE(info, n)		\
+		complete_all(&((info)->cmd[n]))
+#define WAIT_CMD_ACTIVE(info, n)	\
+		wait_for_completion_interruptible((&(info)->cmd[n]))
+
+/*
+ * State control of NVT Com Port Commands
+ */
+
+/* SET-BAUDRATE Stuff */
+# define COM_BAUD_REQ			0
+# define COM_BAUD(x)			(x)
+
+/* SET-DATASIZE Stuff */
+# define COM_DSIZE_REQ			0
+# define COM_DSIZE(x)			(x)
+
+/* SET-PARITY Stuff */
+enum parity_set {
+	COM_PARITY_REQ,
+	COM_PARITY_NONE,
+	COM_PARITY_ODD,
+	COM_PARITY_EVEN,
+	COM_PARITY_MARK,
+	COM_PARITY_SPACE
+};
+
+/* COM-STOPSIZE Stuff */
+enum stopsize_set {
+	COM_SSIZE_REQ,
+	COM_SSIZE_ONE,
+	COM_SSIZE_TWO,
+	COM_SSIZE_1DOT5
+};
+
+/* SET-CONTROL Stuff */
+enum control_set {
+	COM_OFLOW_REQ,
+	COM_OFLOW_NONE,
+	COM_OFLOW_SOFT,
+	COM_OFLOW_HARD,
+
+	COM_BREAK_REQ,
+	COM_BREAK_ON,
+	COM_BREAK_OFF,
+
+	COM_DTR_REQ,
+	COM_DTR_ON,
+	COM_DTR_OFF,
+
+	COM_RTS_REQ,
+	COM_RTS_ON,
+	COM_RTS_OFF,
+
+	COM_IFLOW_REQ,
+	COM_IFLOW_NONE,
+	COM_IFLOW_SOFT,
+	COM_IFLOW_HARD,
+
+	COM_DCD_FLOW,
+	COM_DTR_FLOW,
+	COM_DSR_FLOW
+};
+
+#define COM_FLOW_REQ			COM_OFLOW_REQ
+#define COM_FLOW_NONE			COM_OFLOW_NONE
+#define COM_FLOW_SOFT			COM_OFLOW_SOFT
+#define COM_FLOW_HARD			COM_OFLOW_HARD
+
+/* LINESTATE MASK (COM-LINESTATE-MASK command / NOTIFY-LINESTATE notification*/
+#define LINE_TIMEOUT_ERROR		128
+#define LINE_SHIFTREG_EMPTY		64
+#define LINE_HOLDREG_EMPTY		32
+#define LINE_BREAK_ERROR		16
+#define LINE_FRAME_ERROR		8
+#define LINE_PARITY_ERROR		4
+#define LINE_OVERRUN_ERROR		2
+#define LINE_DATA_READY			1
+
+/* MODEMSTATE MASK (SET-MODEMSTATE-MASK / NOTIFY-MODEMSTATE */
+#define MODEM_DCD			128
+#define MODEM_RI			64
+#define MODEM_DSR			32
+#define MODEM_CTS			16
+#define MODEM_DELTA_DCD			8
+#define MODEM_TRAIL_RI			4
+#define MODEM_DELTA_DSR			2
+#define MODEM_DELTA_CTS			1
+
+/* PURGE-DATA Stuff */
+enum purgedata_set {
+	COM_PURGE_RECV			= 1,
+	COM_PURGE_XMIT,
+	COM_PURGE_BOTH
+};
+
+/*
+ * Driver defines & structs
+ */
+
+#define DRIVER_NAME			"nvtty"
+#define DRIVER_VERSION			"1.0.0"
+
+#define NVTTY_MAJOR			240
+#define NVTTY_MINORS			4
+#define NVTTY_TCP_ADDR			INADDR_LOOPBACK
+#define NVTTY_TCP_PORT			32769
+
+#define PUTDATA_MAXSIZE			512
+#define SUBOPT_MAXSIZE			64
+
+static int major = NVTTY_MAJOR;
+module_param(major, int, 0644);
+MODULE_PARM_DESC(major, "NVT devices' major number (default: " \
+			__stringify(NVTTY_MAJOR) ")");
+static int minors = NVTTY_MINORS;
+module_param(minors, int, 0644);
+MODULE_PARM_DESC(minors, "number of NVT devices to initialize (default: " \
+			__stringify(NVTTY_MINORS) ")");
+
+
+struct nvtty_serial {
+	struct tty_struct *tty;
+	struct device *dev;
+	int open_count;
+	struct mutex mutex;
+	int index;
+
+	struct task_struct *task;
+	unsigned int task_is_running:1;
+
+	struct socket *sock;
+	u32 addr;
+	u16 port;
+	unsigned int connection_ok:1;
+
+	struct completion init_done;
+
+	enum s_state state;
+	enum nvt_opt option[__NVT_NUMOPTS];
+	u8 subopt[SUBOPT_MAXSIZE];
+	int subopt_size;
+
+	struct completion cmd[__USR_NUMCOMS];
+	int arg[__USR_NUMCOMS];
+
+	u8 modemstate;
+};
+
+static struct nvtty_serial *nvtty_info;
+
+/*
+ * Network functions
+ */
+
+static int net_recv(struct nvtty_serial *info,
+				unsigned char *buf, int size, unsigned flags)
+{
+	struct msghdr msg = { NULL, };
+	struct kvec iov = { (void *) buf, size };
+	int ret = kernel_recvmsg(info->sock, &msg, &iov, 1, size, flags);
+
+	return ret;
+}
+
+static int net_send(struct nvtty_serial *info,
+			const unsigned char *buf, int size, unsigned flags)
+{
+	struct msghdr msg = { .msg_flags = flags };
+	struct kvec iov = { (void *) buf, size };
+
+	return kernel_sendmsg(info->sock, &msg, &iov, 1, size);
+}
+
+static int net_connect(struct nvtty_serial *info)
+{
+	struct sockaddr_in src, dest;
+	int ret;
+
+	ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &info->sock);
+	if (ret < 0)
+		goto exit;
+
+	src.sin_family = AF_INET;
+	src.sin_addr.s_addr = htonl(INADDR_ANY);
+	src.sin_port = htons(0);
+
+	ret = kernel_bind(info->sock, (struct sockaddr *) &src, sizeof(src));
+	if (ret) {
+		nvtty_err(info, "bind failed with %08x at address %08lx",
+			 ret, INADDR_ANY);
+		sock_release(info->sock);
+		goto exit;
+	}
+
+	dest.sin_family = AF_INET;
+	dest.sin_addr.s_addr = htonl(info->addr);
+	dest.sin_port = htons(info->port);
+
+	nvtty_dbg(info, "trying to connect with %d.%d.%d.%d:%d",
+				(info->addr & 0xff000000) >> 24,
+				(info->addr & 0x00ff0000) >> 16,
+				(info->addr & 0x0000ff00) >> 8,
+				info->addr & 0x000000ff, info->port);
+	ret = kernel_connect(info->sock,
+			(struct sockaddr *) &dest, sizeof(dest), 0);
+	if (ret == -EINPROGRESS)
+		ret = 0;
+
+exit:
+	return ret;
+}
+
+static void net_disconnect(struct nvtty_serial *info)
+{
+	kernel_sock_shutdown(info->sock, SHUT_RDWR);
+}
+
+/*
+ * Local TTY functionsSIZE
+ */
+
+#define TEST_SET_BAUDRATE(b)	case b: tty->termios->c_cflag |= B ## b ; break
+static void nvtty_set_baudrate(struct nvtty_serial *info, unsigned int baudrate)
+{
+	struct tty_struct *tty = info->tty;
+
+	nvtty_dbg(info, "baudrate=%d", baudrate);
+
+	tty->termios->c_cflag &= ~CBAUD;
+	switch (baudrate) {
+	TEST_SET_BAUDRATE(50);
+	TEST_SET_BAUDRATE(75);
+	TEST_SET_BAUDRATE(110);
+	TEST_SET_BAUDRATE(134);
+	TEST_SET_BAUDRATE(150);
+	TEST_SET_BAUDRATE(200);
+	TEST_SET_BAUDRATE(300);
+	TEST_SET_BAUDRATE(600);
+	TEST_SET_BAUDRATE(1200);
+	TEST_SET_BAUDRATE(1800);
+	TEST_SET_BAUDRATE(2400);
+	TEST_SET_BAUDRATE(4800);
+	TEST_SET_BAUDRATE(9600);
+	TEST_SET_BAUDRATE(19200);
+	TEST_SET_BAUDRATE(38400);
+	TEST_SET_BAUDRATE(57600);
+	TEST_SET_BAUDRATE(115200);
+	TEST_SET_BAUDRATE(230400);
+	TEST_SET_BAUDRATE(460800);
+	TEST_SET_BAUDRATE(500000);
+	TEST_SET_BAUDRATE(576000);
+	TEST_SET_BAUDRATE(921600);
+	TEST_SET_BAUDRATE(1000000);
+	TEST_SET_BAUDRATE(1152000);
+	TEST_SET_BAUDRATE(1500000);
+	TEST_SET_BAUDRATE(2000000);
+	TEST_SET_BAUDRATE(2500000);
+	TEST_SET_BAUDRATE(3000000);
+	TEST_SET_BAUDRATE(3500000);
+	TEST_SET_BAUDRATE(4000000);
+	default:
+		tty->termios->c_cflag = B0;
+	}
+}
+#undef TEST_SET_BAUDRATE
+
+#define TEST_SET_DATASIZE(b)	case b: tty->termios->c_cflag |= CS ## b ; break
+static void nvtty_set_datasize(struct nvtty_serial *info, unsigned int datasize)
+{
+	struct tty_struct *tty = info->tty;
+
+	nvtty_dbg(info, "datasize=%d", datasize);
+
+	tty->termios->c_cflag &= ~CSIZE;
+	switch (datasize) {
+	TEST_SET_DATASIZE(5);
+	TEST_SET_DATASIZE(6);
+	TEST_SET_DATASIZE(7);
+	TEST_SET_DATASIZE(8);
+	default:
+		tty->termios->c_cflag = CS5;
+	}
+}
+#undef TEST_SET_DATASIZE
+
+static void nvtty_set_parity(struct nvtty_serial *info, unsigned int parity)
+{
+	struct tty_struct *tty = info->tty;
+
+	nvtty_dbg(info, "parity=%d", parity);
+
+	tty->termios->c_cflag &= ~(PARENB | PARODD);
+	switch (parity) {
+	case COM_PARITY_ODD:
+		tty->termios->c_cflag |= PARENB | PARODD;
+		break;
+	case COM_PARITY_EVEN:
+		tty->termios->c_cflag |= PARENB;
+		break;
+	case COM_PARITY_NONE:
+	default:
+		/* nop */;
+	}
+}
+
+static void nvtty_set_stopsize(struct nvtty_serial *info, unsigned int stopsize)
+{
+	struct tty_struct *tty = info->tty;
+
+	nvtty_dbg(info, "stopsize=%d", stopsize);
+
+	tty->termios->c_cflag &= ~CSTOPB;
+	switch (stopsize) {
+	case COM_SSIZE_TWO:
+		tty->termios->c_cflag |= CSTOPB;
+		break;
+	default:
+	case COM_SSIZE_ONE:
+		/* nop */;
+	}
+}
+
+static void nvtty_set_control(struct nvtty_serial *info, unsigned int control)
+{
+	struct tty_struct *tty = info->tty;
+
+	nvtty_dbg(info, "control=%d", control);
+
+		tty->termios->c_cflag &= ~CRTSCTS;
+		switch (control) {
+		case COM_OFLOW_SOFT:
+		case COM_OFLOW_HARD:
+			tty->termios->c_cflag |= CRTSCTS;
+			break;
+		default:
+		case COM_OFLOW_NONE:
+			/* nop */;
+		}
+	}
+
+/*
+ * TTY push function
+ */
+
+static void nvtty_push(struct nvtty_serial *info, u8 rx)
+{
+	struct tty_struct *tty = info->tty;
+
+	tty_insert_flip_char(tty, rx, TTY_NORMAL);
+	tty_schedule_flip(tty);
+}
+
+/*
+ * Telnet Protocol Internal Routines
+ */
+
+static int send_option(struct nvtty_serial *info, int type, int opt)
+{
+	u8 buf[] = { IAC, type, opt };
+
+	return net_send(info, buf, ARRAY_SIZE(buf), 0);
+}
+
+#define send_do(info, opt)		send_option(info, DO, opt)
+#define send_dont(info, opt)		send_option(info, DONT, opt)
+#define send_will(info, opt)		send_option(info, WILL, opt)
+#define send_wont(info, opt)		send_option(info, WONT, opt)
+
+static int do_option(struct nvtty_serial *info, int opt)
+{
+	int ret;
+
+	if (I_WANT_TO_SUPPORT(info, opt)) {
+		SET_I_DO_SUPPORT(info, opt);
+		if (!I_SENT_IT(info, opt)) {
+			ret = send_will(info, opt);
+			if (ret < 0) {
+				nvtty_err(info, "error sending WILL %d", opt);
+				return ret;
+			}
+			SET_I_SENT_IT(info, opt);
+		}
+	} else {
+		ret = send_wont(info, opt);
+		if (ret < 0) {
+			nvtty_err(info, "error sending WONT %d", opt);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void dont_option(struct nvtty_serial *info, int opt)
+{
+	CLR_I_DO_SUPPORT(info, opt);
+}
+
+static int will_option(struct nvtty_serial *info, int opt)
+{
+	int ret;
+
+	if (HE_MAY_SUPPORT(info, opt)) {
+		SET_HE_DOES_SUPPORT(info, opt);
+		if (!HE_RECV_IT(info, opt)) {
+			ret = send_do(info, opt);
+			if (ret < 0) {
+				nvtty_err(info, "error sending DO %d", opt);
+				return ret;
+			}
+			SET_HE_RECV_IT(info, opt);
+		}
+	} else {
+		ret = send_dont(info, opt);
+		if (ret < 0) {
+			nvtty_err(info, "error sending DONT %d", opt);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void wont_option(struct nvtty_serial *info, int opt)
+{
+	CLR_HE_DOES_SUPPORT(info, opt);
+}
+
+static int handle_comport_command(struct nvtty_serial *info)
+{
+	struct tty_struct *tty = info->tty;
+	int idx = 1;
+	u8 cmd = info->subopt[idx++];
+	int data, is_async = 0;
+
+	nvtty_dbg(info, "cmd=%d", cmd);
+	if (cmd < 100) {
+		nvtty_err(info, "invalid remote command %d!", cmd);
+		return -1;
+	}
+	cmd -= 100;
+
+	switch (cmd) {
+	case USR_COM_SIGNATURE:
+	case USR_COM_FLOWCONTROL_SUSPEND:
+	case USR_COM_FLOWCONTROL_RESUME:
+		nvtty_dbg(info, "SIGNATURE/FLOWCONTROL_xxx");
+		/* nop */
+		break;
+
+	case USR_COM_SET_BAUDRATE:
+		if (idx + 4 > info->subopt_size) {
+			nvtty_err(info, "invalid BAUDRATE data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = ntohl(*((u32 *) &info->subopt[idx]));
+		nvtty_set_baudrate(info, data);
+
+		break;
+
+	case USR_COM_SET_DATASIZE:
+		if (idx + 1 > info->subopt_size) {
+			nvtty_err(info, "invalid DATASIZE data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = info->subopt[idx];
+		nvtty_set_datasize(info, data);
+
+		break;
+
+	case USR_COM_SET_PARITY:
+		if (idx + 1 > info->subopt_size) {
+			nvtty_err(info, "invalid PARITY data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = info->subopt[idx];
+		nvtty_set_parity(info, data);
+
+		break;
+
+	case USR_COM_SET_STOPSIZE:
+		if (idx + 1 > info->subopt_size) {
+			nvtty_err(info, "invalid STOPSIZE data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = info->subopt[idx];
+		nvtty_set_stopsize(info, data);
+
+		break;
+
+	case USR_COM_SET_CONTROL:
+		if (idx + 1 > info->subopt_size) {
+			nvtty_err(info, "invalid CONTROL data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = info->subopt[idx];
+		nvtty_set_control(info, data);
+
+		break;
+
+	case USR_COM_NOTIFY_LINESTATE:
+		if (idx + 1 > info->subopt_size) {
+			nvtty_err(info, "invalid LINESTATE data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = info->subopt[idx];
+		nvtty_dbg(info, "linestate=%x", data);
+
+		if (data & LINE_BREAK_ERROR)
+			tty_insert_flip_char(tty, 0, TTY_BREAK);
+		if (data & LINE_PARITY_ERROR)
+			tty_insert_flip_char(tty, 0, TTY_PARITY);
+
+		is_async = 1;
+
+		break;
+
+	case USR_COM_SET_LINESTATE_MASK:
+		if (idx + 1 > info->subopt_size) {
+			nvtty_err(info, "invalid LINESTATE MASK data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = info->subopt[idx];
+		nvtty_dbg(info, "linestate_mask=%x", data);
+
+		break;
+
+	case USR_COM_NOTIFY_MODEMSTATE:
+		if (idx + 1 > info->subopt_size) {
+			nvtty_err(info, "invalid MODEMSTATE data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = info->subopt[idx];
+		nvtty_dbg(info, "modemstate=%x", data);
+
+		if ((data ^ info->modemstate) & MODEM_DCD) {
+			if (info->modemstate & MODEM_DCD)
+				info->modemstate &= ~MODEM_DCD;
+			else
+				info->modemstate |= MODEM_DCD;
+		}
+
+		is_async = 1;
+
+		break;
+
+	case USR_COM_SET_MODEMSTATE_MASK:
+		if (idx + 1 > info->subopt_size) {
+			nvtty_err(info, "invalid MODEMSTATE MASK data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = info->subopt[idx];
+		nvtty_dbg(info, "modemstate_mask=%x", data);
+
+		break;
+
+	case USR_COM_PURGE_DATA:
+		if (idx + 1 > info->subopt_size) {
+			nvtty_err(info, "invalid PURGE_DATA data!");
+			return -1;
+		}
+
+		info->arg[cmd] = data = info->subopt[idx];
+		nvtty_dbg(info, "purgedata=%x", data);
+
+		break;
+
+	default:
+		nvtty_err(info, "unknow comport command %d", cmd);
+		break;
+	}
+
+	/* Complete synchronous operation */
+	if (!is_async) {
+		nvtty_dbg(info, "deactivate command %d", cmd);
+		CLR_CMD_ACTIVE(info, cmd);
+	}
+
+	return 0;
+}
+
+static int handle_suboption(struct nvtty_serial *info)
+{
+	u8 subopt = info->subopt[0];
+
+	switch (subopt) {
+	case NVT_COM_PORT_OPTION:
+		return handle_comport_command(info);
+
+	default:
+		nvtty_err(info, "unkown suboption %d", subopt);
+	}
+
+	return 0;
+}
+
+static int getdata(struct nvtty_serial *info)
+{
+	u8 c, buf[128];
+	int i, len;
+	int ret;
+
+	ret = net_recv(info, buf, ARRAY_SIZE(buf), 0);
+	if (ret <= 0)
+		return ret == 0 ? -EIO : ret;
+	len = ret;
+
+	for (i = 0; i < len; i++) {
+		c = buf[i];
+
+		switch (info->state) {
+		case S_DATA:
+			if (c == IAC)
+				info->state = S_IAC;
+			else
+				nvtty_push(info, c);
+			break;
+
+		case S_IAC:
+			switch (c) {
+			case DO:
+				info->state = S_DO;
+				break;
+
+			case DONT:
+				info->state = S_DONT;
+				break;
+
+			case WILL:
+				info->state = S_WILL;
+				break;
+
+			case WONT:
+				info->state = S_WONT;
+				break;
+
+			case SB:
+				info->state = S_SB;
+				info->subopt_size = 0;
+				break;
+
+			case IAC:
+			default:
+				info->state = S_DATA;
+				nvtty_push(info, c);
+				break;
+
+			}
+			break;
+
+		case S_DO:
+			info->state = S_DATA;
+			do_option(info, c);
+			break;
+
+		case S_DONT:
+			info->state = S_DATA;
+			dont_option(info, c);
+			break;
+
+		case S_WILL:
+			info->state = S_DATA;
+			will_option(info, c);
+			break;
+
+		case S_WONT:
+			info->state = S_DATA;
+			wont_option(info, c);
+			break;
+
+		case S_SB:
+			if (c == IAC)
+				info->state = S_SE;
+			else {
+				if (info->subopt_size > SUBOPT_MAXSIZE)
+					nvtty_err(info, "suboption too large!");
+				else {
+					info->subopt[info->subopt_size] = c;
+					info->subopt_size++;
+				}
+			}
+			break;
+
+		case S_SE:
+			if (c == SE) {
+				info->state = S_DATA;
+				handle_suboption(info);
+				info->subopt_size = 0;
+			} else {
+				info->state = S_DATA;
+				nvtty_err(info, "suboption not terminated!");
+			}
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int putdata(struct nvtty_serial *info,
+			const unsigned char *buf, int count)
+{
+	unsigned char buf2[PUTDATA_MAXSIZE * 2]; /* in case of all IAC chars */
+	int i, n;
+
+	/* This should NOT happen due write_room()... */
+	BUG_ON(count > PUTDATA_MAXSIZE);
+
+	/* Must escape IAC... */
+	for (i = n = 0; i < count; i++, n++) {
+		if (buf[i] == IAC)
+			buf2[n++] = IAC;
+		buf2[n] = buf[i];
+	}
+
+	return net_send(info, buf2, n, 0);
+}
+
+static int comport_command(struct nvtty_serial *info,
+				unsigned int cmd, unsigned int arg)
+{
+	u8 buf[16] = { IAC, SB, NVT_COM_PORT_OPTION, cmd, } ;
+	int size = 4;
+	int i, ret;
+
+	switch (cmd) {
+	case USR_COM_SET_BAUDRATE:
+		*((u32 *) &buf[size]) = htonl(arg);
+		size += 4;
+		break;
+
+	default:
+		buf[size++] = (u8) arg;
+		break;
+	}
+	buf[size++] = IAC;
+	buf[size++] = SE;
+
+	i = 0;
+	while (i < size) {
+		ret = net_send(info, &buf[i], size - i, 0);
+		if (ret < 0)
+			return ret;
+
+		i += ret;
+	}
+
+	return 0;
+}
+
+static int sync_comport_command(struct nvtty_serial *info,
+				unsigned int cmd, unsigned int arg)
+{
+	int ret;
+
+	nvtty_dbg(info, "cmd=%d arg=%d", cmd, arg);
+	SET_CMD_ACTIVE(info, cmd);
+	ret = comport_command(info, cmd, arg);
+	if (ret < 0) {
+		nvtty_err(info, "unable to send comport command %d!", cmd);
+		return ret;
+	}
+
+	nvtty_dbg(info, "command %d - start", cmd);
+	ret = WAIT_CMD_ACTIVE(info, cmd);
+	if (ret < 0) {
+		nvtty_err(info, "unable to receive comport command %d!", cmd);
+		return ret;
+	}
+	nvtty_dbg(info, "command %d - ret=%d", cmd, info->arg[cmd]);
+
+	return info->arg[cmd];
+}
+
+static int comport_config(struct nvtty_serial *info)
+{
+	int mask;
+	int ret;
+
+	/* Get configuration values */
+	ret = sync_comport_command(info, USR_COM_SET_BAUDRATE, COM_BAUD_REQ);
+	if (ret < 0)
+		return ret;
+	ret = sync_comport_command(info, USR_COM_SET_DATASIZE, COM_DSIZE_REQ);
+	if (ret < 0)
+		return ret;
+	ret = sync_comport_command(info, USR_COM_SET_PARITY, COM_PARITY_REQ);
+	if (ret < 0)
+		return ret;
+	ret = sync_comport_command(info, USR_COM_SET_STOPSIZE, COM_SSIZE_REQ);
+	if (ret < 0)
+		return ret;
+	ret = sync_comport_command(info, USR_COM_SET_CONTROL, COM_FLOW_REQ);
+	if (ret < 0)
+		return ret;
+
+	/* Set port events mask */
+	mask = MODEM_DCD;
+	ret = sync_comport_command(info, USR_COM_SET_MODEMSTATE_MASK, mask);
+	if (ret < 0)
+		return ret;
+	mask = LINE_BREAK_ERROR | LINE_PARITY_ERROR;
+	ret = sync_comport_command(info, USR_COM_SET_LINESTATE_MASK, mask);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int comport_init(struct nvtty_serial *info)
+{
+	unsigned long timeout;
+	int ret;
+
+	SET_I_WANT_TO_SUPPORT(info, NVT_COM_PORT_OPTION);
+	ret = send_will(info, NVT_COM_PORT_OPTION);
+	if (ret < 0) {
+		nvtty_err(info, "error sending WILL %d", NVT_COM_PORT_OPTION);
+		return ret;
+	}
+	SET_I_SENT_IT(info, NVT_COM_PORT_OPTION);
+
+	SET_HE_MAY_SUPPORT(info, NVT_SUPP_GO_AHEAD);
+	ret = send_do(info, NVT_SUPP_GO_AHEAD);
+	if (ret < 0) {
+		nvtty_err(info, "error sending DO %d\n", NVT_SUPP_GO_AHEAD);
+		return ret;
+	}
+	SET_HE_RECV_IT(info, NVT_SUPP_GO_AHEAD);
+
+	timeout = jiffies + 5 * HZ;
+	do {
+		schedule();
+	} while (!I_DO_SUPPORT(info, NVT_COM_PORT_OPTION) &&
+					time_before(jiffies, timeout));
+
+	if (I_DO_SUPPORT(info, NVT_COM_PORT_OPTION)) {
+		ret = comport_config(info);
+		if (ret < 0) {
+			nvtty_err(info, "unable to configure port");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * The NVT task
+ */
+
+static int task_body(void *ptr)
+{
+	struct nvtty_serial *info = (struct nvtty_serial *) ptr;
+	int ret = 0;
+
+	/* Se should kill this task in some way... */
+	allow_signal(SIGTERM);
+	allow_signal(SIGKILL);
+
+	nvtty_dbg(info, "main loop started...");
+	while (!kthread_should_stop()) {
+		ret = getdata(info);
+		if (ret < 0) {
+			nvtty_dbg(info, "error on getting data");
+			break;
+		}
+	}
+	nvtty_dbg(info, "task is now exiting...");
+
+	/* Before exiting we should wait the last device's close... */
+	while (!kthread_should_stop())
+		schedule();
+
+	return 0;
+}
+
+/*
+ * TTY methods
+ */
+
+static int nvtty_tiocmget(struct tty_struct *tty, struct file *file)
+{
+	struct nvtty_serial *info = tty->driver_data;
+	int status, ret;
+
+	ret = wait_for_completion_interruptible(&info->init_done);
+	if (ret < 0) {
+		nvtty_err(info, "warning! Port not initialized");
+		return ret;
+	}
+
+	mutex_lock(&info->mutex);
+
+	status = (info->modemstate & MODEM_DCD) ? TIOCM_CD : 0;
+	nvtty_dbg(info, "status=%x", status);
+
+	mutex_unlock(&info->mutex);
+
+	return status;
+}
+
+static int nvtty_tiocmset(struct tty_struct *tty, struct file *file,
+			   unsigned int set, unsigned int clear)
+{
+	struct nvtty_serial *info = tty->driver_data;
+	int ret;
+
+	nvtty_dbg(info, "set=%x clear=%x", set, clear);
+
+	ret = wait_for_completion_interruptible(&info->init_done);
+	if (ret < 0) {
+		nvtty_err(info, "warning! Port not initialized");
+		return ret;
+	}
+
+	mutex_lock(&info->mutex);
+
+	if (set & TIOCM_RTS) {
+		ret = sync_comport_command(info,
+				USR_COM_SET_CONTROL, COM_RTS_ON);
+		if (ret < 0) {
+			nvtty_err(info, "unable to set RTS on");
+			goto exit;
+		}
+	}
+	if (set & TIOCM_DTR) {
+		ret = sync_comport_command(info,
+				USR_COM_SET_CONTROL, COM_DTR_ON);
+		if (ret < 0) {
+			nvtty_err(info, "unable to set DTR on");
+			goto exit;
+		}
+	}
+	if (clear & TIOCM_RTS) {
+		ret = sync_comport_command(info,
+				USR_COM_SET_CONTROL, COM_RTS_OFF);
+		if (ret < 0) {
+			nvtty_err(info, "unable to set RTS off");
+			goto exit;
+		}
+	}
+	if (clear & TIOCM_DTR) {
+		ret = sync_comport_command(info,
+				USR_COM_SET_CONTROL, COM_DTR_OFF);
+		if (ret < 0) {
+			nvtty_err(info, "unable to set DTR off");
+			goto exit;
+		}
+	}
+
+exit:
+	mutex_unlock(&info->mutex);
+
+	return 0;
+}
+
+#define RELEVANT_IFLAG(iflag) ((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
+
+static void nvtty_set_termios(struct tty_struct *tty, struct ktermios *old)
+{
+	struct nvtty_serial *info = tty->driver_data;
+	unsigned int cflag;
+	int tmp, ret;
+
+	ret = wait_for_completion_interruptible(&info->init_done);
+	if (ret < 0) {
+		nvtty_err(info, "warning! Port not initialized");
+		return;
+	}
+
+	mutex_lock(&info->mutex);
+
+	cflag = tty->termios->c_cflag;
+
+	/* Check that they really want us to change something */
+	if (old) {
+		if ((cflag == old->c_cflag) &&
+				(RELEVANT_IFLAG(tty->termios->c_iflag) ==
+				RELEVANT_IFLAG(old->c_iflag))) {
+			nvtty_dbg(info, "nothing to change...");
+			goto exit;
+		}
+	}
+
+	/* Set the byte size */
+	switch (cflag & CSIZE) {
+	case CS5:
+		tmp = 5;
+		break;
+	case CS6:
+		tmp = 6;
+		break;
+	case CS7:
+		tmp = 7;
+		break;
+	default:
+	case CS8:
+		tmp = 8;
+		break;
+	}
+	ret = sync_comport_command(info, USR_COM_SET_DATASIZE, COM_DSIZE(tmp));
+	if (ret < 0 || tmp != ret) {
+		nvtty_err(info, "unable to set datasize to %d", tmp);
+		ret = ret >= 0 ? ret : 8;
+		nvtty_info(info, "reset datasize to %d", ret);
+		nvtty_set_datasize(info, ret);
+	}
+
+	/* Set the parity */
+	if (cflag & PARENB) {
+		if (cflag & PARODD)
+			tmp = COM_PARITY_ODD;
+		else
+			tmp = COM_PARITY_EVEN;
+	} else
+		tmp = COM_PARITY_NONE;
+	ret = sync_comport_command(info, USR_COM_SET_PARITY, tmp);
+	if (ret < 0 || tmp != ret) {
+		nvtty_err(info, "unable to set parity to %d", tmp);
+		ret = ret >= 0 ? ret : COM_PARITY_NONE;
+		nvtty_info(info, "reset parity to %d", ret);
+		nvtty_set_parity(info, ret);
+	}
+
+	/* Set the stop bits */
+	if (cflag & CSTOPB)
+		tmp = COM_SSIZE_TWO;
+	else
+		tmp = COM_SSIZE_ONE;
+	ret = sync_comport_command(info, USR_COM_SET_STOPSIZE, tmp);
+	if (ret < 0 || tmp != ret) {
+		nvtty_err(info, "unable to set stopsize to %d", tmp);
+		ret = ret >= 0 ? ret : COM_SSIZE_ONE;
+		nvtty_info(info, "reset stopsize to %d", ret);
+		nvtty_set_stopsize(info, ret);
+	}
+
+	/* Set the flow control */
+	if (cflag & CRTSCTS)
+		tmp = COM_OFLOW_HARD;
+	else
+		tmp = COM_OFLOW_NONE;
+	ret = sync_comport_command(info, USR_COM_SET_CONTROL, tmp);
+	if (ret < 0 || tmp != ret) {
+		nvtty_err(info, "unable to set control to %d", tmp);
+		ret = ret >= 0 ? ret : COM_OFLOW_NONE;
+		nvtty_info(info, "reset control to %d", ret);
+		nvtty_set_control(info, ret);
+	}
+
+	/* Set the baud rate */
+	tmp = tty_get_baud_rate(tty);
+	ret = sync_comport_command(info, USR_COM_SET_BAUDRATE, COM_BAUD(tmp));
+	if (ret < 0 || tmp != ret) {
+		nvtty_err(info, "unable to set baudrate to %d", tmp);
+		ret = ret >= 0 ? ret : 9600;
+		nvtty_info(info, "reset baudrate to %d", ret);
+		nvtty_set_baudrate(info, ret);
+	}
+
+exit:
+	mutex_unlock(&info->mutex);
+
+	return;
+}
+
+static int nvtty_write_room(struct tty_struct *tty)
+{
+	/* This value should be ok for any communication... */
+	return PUTDATA_MAXSIZE;
+}
+
+static int nvtty_write(struct tty_struct *tty,
+		      const unsigned char *buf, int count)
+{
+	struct nvtty_serial *info = tty->driver_data;
+	int ret;
+
+	ret = wait_for_completion_interruptible(&info->init_done);
+	if (ret < 0) {
+		nvtty_err(info, "warning! Port not initialized");
+		return ret == 0 ? -EIO : ret;
+	}
+
+	ret = putdata(info, buf, count);
+
+	return ret;
+}
+
+static int nvtty_open(struct tty_struct *tty, struct file *file)
+{
+	struct nvtty_serial *info;
+	int line;
+	int ret = 0;
+
+	line = tty->index;
+	if (line > minors || line < 0)
+		return -ENODEV;
+
+	info = &nvtty_info[line];
+
+	mutex_lock(&info->mutex);
+
+	info->open_count++;
+	tty->driver_data = info;
+	info->tty = tty;
+
+	if (info->open_count == 1) {
+		init_completion(&info->init_done);
+
+		/* First get connected with remote server... */
+		ret = net_connect(info);
+		if (ret < 0) {
+			nvtty_err(info, "unable to connect with server");
+			goto unlock;
+		}
+		info->connection_ok = 1;
+
+		/* ... then start main kthread to get remote data... */
+		info->task = kthread_run(task_body, info,
+						DRIVER_NAME "%d", tty->index);
+		if (IS_ERR(info->task)) {
+			nvtty_err(info, "unable to create thread");
+			ret = PTR_ERR(info->task);
+			goto unlock;
+		}
+		info->task_is_running = 1;
+
+		/* ... in the end configure the nvtty port */
+		ret = comport_init(info);
+		if (ret < 0) {
+			info->connection_ok = 0;
+			goto unlock;
+		}
+
+		nvtty_dbg(info, "init_done");
+		complete_all(&info->init_done);
+	}
+
+unlock:
+	mutex_unlock(&info->mutex);
+
+	return ret;
+}
+
+static void nvtty_close(struct tty_struct *tty, struct file *file)
+{
+	struct nvtty_serial *info = tty->driver_data;
+
+	mutex_lock(&info->mutex);
+
+	info->open_count--;
+	if (info->open_count <= 0) {
+		nvtty_dbg(info, "last close");
+		net_disconnect(info);
+		info->connection_ok = 0;
+
+		if (info->task_is_running) {
+			kthread_stop(info->task);
+			info->task_is_running = 0;
+		}
+		sock_release(info->sock);
+	}
+
+	mutex_unlock(&info->mutex);
+
+	return;
+}
+
+static const struct tty_operations nvtty_serial_ops = {
+	.tiocmget	= nvtty_tiocmget,
+	.tiocmset	= nvtty_tiocmset,
+	.set_termios	= nvtty_set_termios,
+	.write_room	= nvtty_write_room,
+	.write		= nvtty_write,
+	.open		= nvtty_open,
+	.close		= nvtty_close,
+};
+
+/*
+ * sysfs stuff
+ */
+
+static ssize_t connection_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct nvtty_serial *info = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", info->connection_ok);
+}
+
+static ssize_t ip_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct nvtty_serial *info = dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&info->mutex);
+	ret = sprintf(buf, "%d.%d.%d.%d\n",
+				(info->addr & 0xff000000) >> 24,
+				(info->addr & 0x00ff0000) >> 16,
+				(info->addr & 0x0000ff00) >> 8,
+				info->addr & 0x000000ff);
+	mutex_unlock(&info->mutex);
+
+	return ret;
+}
+
+static ssize_t ip_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t n)
+{
+	struct nvtty_serial *info = dev_get_drvdata(dev);
+	int i1, i2, i3, i4;
+	int ret;
+
+	ret = sscanf(buf, "%d.%d.%d.%d", &i1, &i2, &i3, &i4);
+	if (ret != 4 ||
+			i1 < 0 || i1 > 255 || i2 < 0 || i2 > 255 ||
+			i3 < 0 || i3 > 255 || i4 < 0 || i4 > 255)
+		return -EINVAL;
+
+	mutex_lock(&info->mutex);
+
+	if (info->connection_ok) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	info->addr = (i1 << 24) | (i2 << 16) | (i3 << 8) | i4;
+
+exit:
+	mutex_unlock(&info->mutex);
+
+	return n;
+}
+
+static ssize_t port_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct nvtty_serial *info = dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&info->mutex);
+	ret = sprintf(buf, "%d\n", info->port);
+	mutex_unlock(&info->mutex);
+
+	return ret;
+}
+
+static ssize_t port_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t n)
+{
+	struct nvtty_serial *info = dev_get_drvdata(dev);
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 0, &val);
+	if (ret)
+		return -EINVAL;
+
+	if (val > 0xffff)
+		return -EINVAL;
+
+	mutex_lock(&info->mutex);
+
+	if (info->connection_ok) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	info->port = val;
+
+exit:
+	mutex_unlock(&info->mutex);
+
+	return n;
+}
+
+static DEVICE_ATTR(connection, 0444, connection_show, NULL);
+static DEVICE_ATTR(ip, 0644, ip_show, ip_store);
+static DEVICE_ATTR(port, 0644, port_show, port_store);
+
+static const struct attribute *nvtty_attr[] = {
+	&dev_attr_connection.attr,
+	&dev_attr_ip.attr,
+	&dev_attr_port.attr,
+	NULL
+};
+
+/*
+ * Module stuff
+ */
+
+static struct tty_driver *drv;
+
+static int __init nvtty_init(void)
+{
+	struct device *dev;
+	int i, ret;
+
+	/* Allocate main struct the tty driver */
+	nvtty_info = kzalloc(minors * sizeof(struct nvtty_serial), GFP_KERNEL);
+	if (!nvtty_info)
+		return -ENOMEM;
+	drv = alloc_tty_driver(minors);
+	if (!drv) {
+		ret = -ENOMEM;
+		goto unalloc_main_struct;
+	}
+
+	/* initialize the tty driver */
+	drv->owner = THIS_MODULE;
+	drv->driver_name = DRIVER_NAME "_tty";
+	drv->name = DRIVER_NAME;
+	drv->major = major,
+	drv->type = TTY_DRIVER_TYPE_SERIAL,
+	drv->subtype = SERIAL_TYPE_NORMAL,
+	drv->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV,
+	drv->init_termios = tty_std_termios;
+	drv->init_termios.c_cflag = CREAD | HUPCL | CLOCAL;
+	tty_set_operations(drv, &nvtty_serial_ops);
+
+	/* register the tty driver */
+	ret = tty_register_driver(drv);
+	if (ret) {
+		pr_err("failed to register nvtty tty driver");
+		goto unalloc_tty_driver;
+	}
+
+	for (i = 0; i < minors; i++) {
+		dev = tty_register_device(drv, i, NULL);
+		if (IS_ERR(dev)) {
+			pr_warning("failed to register device nvtty%d", i);
+			goto unregister_tty_device;
+		}
+
+		/* Init main data struct */
+		nvtty_info[i].addr = NVTTY_TCP_ADDR;
+		nvtty_info[i].port = NVTTY_TCP_PORT;
+		mutex_init(&nvtty_info[i].mutex);
+
+		/* Double link main data struct with each tty driver */
+		dev_set_drvdata(dev, &nvtty_info[i]);
+		nvtty_info[i].dev = dev;
+
+		ret = sysfs_create_files(&dev->kobj, nvtty_attr);
+		if (ret < 0) {
+			pr_warning("failed to register device nvtty%d", i);
+			goto unregister_tty_device;
+		}
+	}
+
+	pr_info(DRIVER_NAME ": serial port driver loaded (%d ports)\n", minors);
+
+	return 0;
+
+unregister_tty_device:
+	for ( ; i >= 0; i--) {
+		dev = nvtty_info[i].dev;
+		tty_unregister_device(drv, i);
+
+		sysfs_remove_files(&dev->kobj, nvtty_attr);
+	}
+
+unalloc_tty_driver:
+	put_tty_driver(drv);
+unalloc_main_struct:
+	kfree(nvtty_info);
+
+	return ret;
+}
+
+static void __exit nvtty_exit(void)
+{
+	struct device *dev;
+	int i;
+
+	for (i = 0; i < minors; i++) {
+		dev = nvtty_info[i].dev;
+		tty_unregister_device(drv, i);
+
+		sysfs_remove_files(&dev->kobj, nvtty_attr);
+	}
+
+	tty_unregister_driver(drv);
+	put_tty_driver(drv);
+	kfree(nvtty_info);
+
+	pr_info(DRIVER_NAME ": serial port driver removed\n");
+}
+
+module_init(nvtty_init);
+module_exit(nvtty_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("Network Virtual Terminal (RFC 854) "
+			"with Com Port option (RFC 2217)");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

