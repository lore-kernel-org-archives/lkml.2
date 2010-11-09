Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0KIVko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:40:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45288 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0KIVkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:40:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kWevnH2DXSCG4kxdUHZ2zw4J7cF3LeR37IU7uShkV7wG/97r5ytNwW9ci43Jso2k8z
         ltTE2sCWAJ9xNLDwxNdOrgm6eGMCH4dfgCJQDSzrwxxfm7bBok/A/wnCZlDPaAtnW6R0
         CB+03/Ku0q0RmdwWlx3kgE7lO7iJutA5mgFWY=
Message-ID: <4CD9C322.2080503@gmail.com>
Date: Tue, 09 Nov 2010 13:54:42 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/6] serial/ce4100: Add PCI UART support for the ce4100
References: <cover.1289331834.git.dirk.brandewie@gmail.com> <654d0e8f80dd959fd9c871ad1644126d58b2445b.1289331834.git.dirk.brandewie@gmail.com> <20101109211418.GA15802@kroah.com>
In-Reply-To: <20101109211418.GA15802@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 01:14 PM, Greg KH wrote:
> On Tue, Nov 09, 2010 at 12:08:06PM -0800, dirk.brandewie@gmail.com wrote:
>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>
>> This patch adds support for the PCI UART on the ce4100.
>>
>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>> CC: linux-serial@vger.kernel.org
>> ---
>>   drivers/serial/8250_pci.c |   35 +++++++++++++++++++++++++++++++++++
>>   include/linux/pci_ids.h   |    1 +
> 
> You did read the top of pci_ids.h right?  Why are you adding new ids
> that are only used by one file?
> 
I have now. Here is a replacement patch for the UART. I will update the 
USB patch as well.

--Dirk

Subject: [PATCH] serial/ce4100: Add PCI UART support for the ce4100

This patch adds support for the PCI UART on the ce4100.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: linux-serial@vger.kernel.org
---
 drivers/serial/8250_pci.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 53be4d3..12e6f81 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -957,6 +957,22 @@ pci_default_setup(struct serial_private *priv,
 	return setup_port(priv, port, bar, offset, board->reg_shift);
 }
 
+static int
+ce4100_serial_setup(struct serial_private *priv,
+		  const struct pciserial_board *board,
+		  struct uart_port *port, int idx)
+{
+	int ret;
+
+	ret = setup_port(priv, port, 0, 0, board->reg_shift);
+	port->iotype = UPIO_MEM32;
+	port->type = PORT_XSCALE;
+	port->flags = (port->flags | UPF_FIXED_PORT | UPF_FIXED_TYPE);
+	port->regshift = 2;
+
+	return ret;
+}
+
 static int skip_tx_en_setup(struct serial_private *priv,
 			const struct pciserial_board *board,
 			struct uart_port *port, int idx)
@@ -1072,6 +1088,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice	= PCI_ANY_ID,
 		.setup		= skip_tx_en_setup,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= 0x2e66,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= ce4100_serial_setup,
+	},
 	/*
 	 * ITE
 	 */
@@ -1592,6 +1615,7 @@ enum pci_board_num_t {
 	pbn_ADDIDATA_PCIe_2_3906250,
 	pbn_ADDIDATA_PCIe_4_3906250,
 	pbn_ADDIDATA_PCIe_8_3906250,
+	pbn_ce4100_1_115200,
 };
 
 /*
@@ -2281,6 +2305,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.uart_offset	= 0x200,
 		.first_offset	= 0x1000,
 	},
+	[pbn_ce4100_1_115200] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.reg_shift      = 2,
+	},
 };
 
 static const struct pci_device_id softmodem_blacklist[] = {
@@ -3760,6 +3790,11 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
 		0xA000, 0x3004,
 		0, 0, pbn_b0_bt_4_115200 },
+	/* Intel CE4100 */
+	{	PCI_VENDOR_ID_INTEL, 0x2e66,
+		PCI_ANY_ID,  PCI_ANY_ID, 0, 0,
+		pbn_ce4100_1_115200 },
+
 
 	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
-- 
1.7.2.3

