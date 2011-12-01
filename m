Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1LAVjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:39:45 -0500
Received: from moh1-ve1.go2.pl ([193.17.41.131]:47211 "EHLO moh1-ve1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab1LAVjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:39:43 -0500
Message-ID: <4ED7F40A.4040001@o2.pl>
Date: Thu, 01 Dec 2011 22:39:22 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111101 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [SERIAL]fix serial_cs I/O windows for Argosy RS-COM 2P
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 60
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current serial_cs driver has a problem when trying to detect whether
a card has multiple ports: serial_config() calls pcmcia_loop_config()
which iterates over card CIS configurations by calling
serial_check_for_multi() for each of them.

This function wants to check (and select) a configuration
that has either one long I/O window spanning multiple ports or two 8-port
windows for two serial ports.

Problem is, that every pcmcia_loop_config() iteration only updates
the windows (via pcmcia_do_loop_config() in resource[0] and resource[1])
when CONF_AUTO_SET_IO flag is set on the device, which is set only later
in the code.

Fix it by setting this flag earlier.

In addition to this, when multi-port card is detected
and it does not have an one, long I/O window
multi_config_check_notpicky() tries to locate two I/O windows and assumes
they are continuous without checking.

On an Argosy RS-COM 2P this selects first configuration, which
unfortunately has two non-continuous I/O windows.
The net effect is that the second serial port on the card does not work.

Fix it by checking whether the windows are really continuous.

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/tty/serial/serial_cs.c b/drivers/tty/serial/serial_cs.c
index eef736f..8609060 100644
--- a/drivers/tty/serial/serial_cs.c
+++ b/drivers/tty/serial/serial_cs.c
@@ -317,7 +317,7 @@ static int serial_probe(struct pcmcia_device *link)
 	info->p_dev = link;
 	link->priv = info;
 
-	link->config_flags |= CONF_ENABLE_IRQ;
+	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 	if (do_sound)
 		link->config_flags |= CONF_ENABLE_SPKR;
 
@@ -445,7 +445,7 @@ static int simple_config(struct pcmcia_device *link)
 
 	/* First pass: look for a config entry that looks normal.
 	 * Two tries: without IO aliases, then with aliases */
-	link->config_flags |= CONF_AUTO_SET_VPP | CONF_AUTO_SET_IO;
+	link->config_flags |= CONF_AUTO_SET_VPP;
 	for (try = 0; try < 4; try++)
 		if (!pcmcia_loop_config(link, simple_config_check, &try))
 			goto found_port;
@@ -501,7 +501,8 @@ static int multi_config_check_notpicky(struct pcmcia_device *p_dev,
 {
 	int *base2 = priv_data;
 
-	if (!p_dev->resource[0]->end || !p_dev->resource[1]->end)
+	if (!p_dev->resource[0]->end || !p_dev->resource[1]->end ||
+		p_dev->resource[0]->start + 8 != p_dev->resource[1]->start)
 		return -ENODEV;
 
 	p_dev->resource[0]->end = p_dev->resource[1]->end = 8;
@@ -520,7 +521,6 @@ static int multi_config(struct pcmcia_device *link)
 	struct serial_info *info = link->priv;
 	int i, base2 = 0;
 
-	link->config_flags |= CONF_AUTO_SET_IO;
 	/* First, look for a generic full-sized window */
 	if (!pcmcia_loop_config(link, multi_config_check, &info->multi))
 		base2 = link->resource[0]->start + 8;
