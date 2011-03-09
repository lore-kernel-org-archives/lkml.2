Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1CISbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:31:42 -0500
Received: from 29.mail-out.ovh.net ([87.98.216.213]:33207 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752596Ab1CISbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:31:39 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH v2 1/2] n_gsm: add a documentation
Date: Wed,  9 Mar 2011 19:24:48 +0100
Message-Id: <1299695089-2994-1-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14264588871616605464
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* this documentation gives some details on how to get the n_gsm
line discipline to work with modems supporting 07.10 basic option.

* it was tested on Telit and Simcom modems.

Signed-off-by: Eric Bénard <eric@eukrea.com>
---
v2 : small updates following Michal's review

 Documentation/serial/n_gsm.txt |   89 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/serial/n_gsm.txt

diff --git a/Documentation/serial/n_gsm.txt b/Documentation/serial/n_gsm.txt
new file mode 100644
index 0000000..397f41a
--- /dev/null
+++ b/Documentation/serial/n_gsm.txt
@@ -0,0 +1,89 @@
+n_gsm.c GSM 0710 tty multiplexor HOWTO
+===================================================
+
+This line discipline implements the GSM 07.10 multiplexing protocol
+detailed in the following 3GPP document :
+http://www.3gpp.org/ftp/Specs/archive/07_series/07.10/0710-720.zip
+
+This document give some hints on how to use this driver with GPRS and 3G
+modems connected to a physical serial port.
+
+How to use it
+-------------
+1- initialize the modem in 0710 mux mode (usually AT+CMUX= command) through
+its serial port. Depending on the modem used, you can pass more or less
+parameters to this command,
+2- switch the serial line to using the n_gsm line discipline by using
+TIOCSETD ioctl,
+3- configure the mux using GSMIOC_GETCONF / GSMIOC_SETCONF ioctl,
+
+Major parts of the initialization program :
+(a good starting point is util-linux-ng/sys-utils/ldattach.c)
+#include <linux/gsmmux.h>
+#define N_GSM0710	21	/* GSM 0710 Mux */
+#define DEFAULT_SPEED	B115200
+#define SERIAL_PORT	/dev/ttyS0
+
+	int ldisc = N_GSM0710;
+	struct gsm_config c;
+	struct termios configuration;
+
+	/* open the serial port connected to the modem */
+	fd = open(SERIAL_PORT, O_RDWR | O_NOCTTY | O_NDELAY);
+
+	/* configure the serial port : speed, flow control ... */
+
+	/* send the AT commands to switch the modem to CMUX mode
+	   and check that it's succesful (should return OK) */
+	write(fd, "AT+CMUX=0\r", 10);
+
+	/* experience showed that some modems need some time before
+	   being able to answer to the first MUX packet so a delay
+	   may be needed here in some case */
+	sleep(3);
+
+	/* use n_gsm line discipline */
+	ioctl(fd, TIOCSETD, &ldisc);
+
+	/* get n_gsm configuration */
+	ioctl(fd, GSMIOC_GETCONF, &c);
+	/* we are initiator and need encoding 0 (basic) */
+	c.initiator = 1;
+	c.encapsulation = 0;
+	/* our modem defaults to a maximum size of 127 bytes */
+	c.mru = 127;
+	c.mtu = 127;
+	/* set the new configuration */
+	ioctl(fd, GSMIOC_SETCONF, &c);
+
+	/* and wait for ever to keep the line discipline enabled */
+	daemon(0,0);
+	pause();
+
+4- create the devices corresponding to the "virtual" serial ports (take care,
+each modem has its configuration and some DLC have dedicated functions,
+for example GPS), starting with minor 1 (DLC0 is reserved for the management
+of the mux)
+
+MAJOR=`cat /proc/devices |grep gsmtty | awk '{print $1}`
+for i in `seq 1 4`; do
+	mknod /dev/ttygsm$i c $MAJOR $i
+done
+
+5- use these devices as plain serial ports.
+for example, it's possible :
+- and to use gnokii to send / receive SMS on ttygsm1
+- to use ppp to establish a datalink on ttygsm2
+
+6- first close all virtual ports before closing the physical port.
+
+Additional Documentation
+------------------------
+More practical details on the protocol and how it's supported by industrial
+modems can be found in the following documents :
+http://www.telit.com/module/infopool/download.php?id=616
+http://www.u-blox.com/images/downloads/Product_Docs/LEON-G100-G200-MuxImplementation_ApplicationNote_%28GSM%20G1-CS-10002%29.pdf
+http://www.sierrawireless.com/Support/Downloads/AirPrime/WMP_Series/~/media/Support_Downloads/AirPrime/Application_notes/CMUX_Feature_Application_Note-Rev004.ashx
+http://wm.sim.com/sim/News/photo/2010721161442.pdf
+
+11-03-08 - Eric Bénard - <eric@eukrea.com>
-- 
1.7.4

