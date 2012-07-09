Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2GIXcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:32:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43214 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031Ab2GIXcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:32:17 -0400
Message-ID: <1341876736.6118.70.camel@joe2Laptop>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Mon, 09 Jul 2012 16:32:16 -0700
In-Reply-To: <CAPXgP12wrORpTdzMFW0QKr0j1VqZy_PRBFRM2P=qRqPFMQ=zUA@mail.gmail.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
	 <20120625150722.8cd4f45d.akpm@linux-foundation.org>
	 <20120625235531.GB3652@kroah.com>
	 <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
	 <20120626002307.GA4389@kroah.com>
	 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
	 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
	 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
	 <1340726856.977.6.camel@mop> <22482.1341471787@neuling.org>
	 <CAPXgP11=o5WB4WejaQCSCL-+5e4sL7tfVz_r3Khyrq3SyrMvsA@mail.gmail.com>
	 <CAPXgP13u769nSvUdS1iqiVCsxG5nsQd7bNT1=-eNw156U-kPkQ@mail.gmail.com>
	 <16043.1341483625@neuling.org>
	 <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com>
	 <1341492628.834.3.camel@mop> <30233.1341535279@neuling.org>
	 <CAPXgP12_F_H2XPpo2wFmb-u3jBdV__=h67R-LVYbqHuLh7tqLg@mail.gmail.com>
	 <29711.1341545979@neuling.org> <30343.1341546469@neuling.org>
	 <CAPXgP10JthGjZyqD6gqn2n1rPu1uP+=mem_T-iOritXAQMstRQ@mail.gmail.com>
	 <21892.1341608647@neuling.org> <1341770155.1011.27.camel@mop>
	 <1341870165.6118.42.camel@joe2Laptop>
	 <CAPXgP11Qsj9yGM5nSbRJ_YPFZcr2Km6w4R8wPGU1AytyQChYXQ@mail.gmail.com>
	 <1341872984.6118.54.camel@joe2Laptop>
	 <CAPXgP12wrORpTdzMFW0QKr0j1VqZy_PRBFRM2P=qRqPFMQ=zUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 00:40 +0200, Kay Sievers wrote:
> On Tue, Jul 10, 2012 at 12:29 AM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2012-07-10 at 00:10 +0200, Kay Sievers wrote:
> >> On Mon, Jul 9, 2012 at 11:42 PM, Joe Perches <joe@perches.com> wrote:
> >> > On Sun, 2012-07-08 at 19:55 +0200, Kay Sievers wrote:
> >> >
> >> >> At the same time the CPU#2 prints the same warning with a continuation
> >> >> line, but the buffer from CPU#1 can not be flushed to the console, nor
> >> >> can the continuation line printk()s from CPU#2 be merged at this point.
> >> >> The consoles are still locked and busy with replaying the old log
> >> >> messages, so the new continuation data is just stored away in the record
> >> >> buffer as it is coming in.
> >> >> If the console would be registered a bit earlier, or the warning would
> >> >> happen a bit later, we would probably not see any of this.
> >> >>
> >> >> I can fake something like this just by holding the console semaphore
> >> >> over a longer time and printing continuation lines with different CPUs
> >> >> in a row.
> >> >>
> >> >> The patch below seems to work for me. It is also here:
> >> >>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-merge-cont.patch;hb=HEAD
> >> >>
> >> >> It only applies cleanly on top of this patch:
> >> >>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-syslog-1-byte-read.patch;hb=HEAD
> >> >>
> >> >
> >> > Hi Kay.
> >> >
> >> > I just ran a test with what's in Greg's driver-core -for-linus branch.
> >> >
> >> > One of the differences in dmesg is timestamping of consecutive
> >> >         pr_<level>("foo...)
> >> > followed directly by
> >> >         pr_cont("bar...")
> >> >
> >> > For instance: (dmesg is 3.4, dmesg.0 is 3.5-rc6+)
> >> >
> >> > # grep MAP /var/log/dm* -A1
> >> > dmesg:[    0.781687] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> >> > dmesg-[    0.781707] ata2: port disabled--ignoring
> >> > --
> >> > dmesg.0:[    0.948881] ata_piix 0000:00:1f.2: MAP [
> >> > dmesg.0-[    0.948883]  P0 P2 P1 P3 ]
> >> >
> >> > These messages originate starting at
> >> > drivers/ata/ata_piix.c:1354
> >> >
> >> > All the continuations are emitted with pr_cont.
> >> >
> >> > I think this output should still be coalesced without
> >> > timestamp deltas.  Perhaps the timestamping code can
> >> > still be reworked to avoid too small a delta producing
> >> > a new timestamp and another dmesg line.
> >>
> >> Hmm, I don't see that.
> >>
> >> If I do:
> >>   pr_info("[");
> >>   for (i = 0; i < 4; i++)
> >>        pr_cont("%i ", i);
> >>   pr_cont("]\n");
> >>
> >> I get:
> >>   6,173,0;[0 1 2 3 ]
> >>
> >> And if I fill the cont buffer and forcefully hold the console sem
> >> during all that, and we can't merge anymore, I get:
> >>   6,167,0;[
> >>   4,168,0;0
> >>   4,169,0;1
> >>   4,170,0;2
> >>   4,171,0;3
> >>   4,172,0;]
> >>
> >> But the output is still all fine for both lines:
> >>   [    0.000000] [0 1 2 3 ]
> >>   [    0.000000] [0 1 2 3 ]
> >>
> >> What do I miss?
> >
> > In this case the initial line is dev_info not pr_info
> > so there are the additional dict descriptors output to
> > /dev/kmsg as well.
> >
> > Maybe that interferes with continuations.  Dunno.
> 
> Yes, it does. Annotated records dev_printk() must be reliable in the
> data storage and for the consumers. We can not expose them to the racy
> continuation printk()s. We need to be able to trust the data they
> print and not possibly merge unrelated things into it.
> 
> If it's needed, we can try to set the flags accordingly, that they
> *look* like a line in the classic byte-stream output, but the
> interface in /dev/kmsg must not export them that way, because
> continuation lines can never be trusted to be correct.

Then you've changed semantics and I think you need to
fix it.

A dev_<level> call is not guaranteed to be a complete
message.

There are dev_<level> and netdev_<level> calls
followed by pr_cont.

Maybe these could be fixed up and then they could be
always integral.  There don't look to be too many.

This may be most (all?) of them:

 drivers/ata/ata_piix.c               |   16 +++++++++-----
 drivers/media/rc/redrat3.c           |   36 ++++++++++++++++-----------------
 drivers/net/ethernet/broadcom/bnx2.c |   26 ++++++++++++++----------
 3 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3c809bf..f51962f 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1346,38 +1346,42 @@ static const int *__devinit piix_init_sata_map(struct pci_dev *pdev,
 	const int *map;
 	int i, invalid_map = 0;
 	u8 map_value;
+	char maps[50] = {0};
+	int len = 0;
 
 	pci_read_config_byte(pdev, ICH5_PMR, &map_value);
 
 	map = map_db->map[map_value & map_db->mask];
 
-	dev_info(&pdev->dev, "MAP [");
 	for (i = 0; i < 4; i++) {
 		switch (map[i]) {
 		case RV:
 			invalid_map = 1;
-			pr_cont(" XX");
+			len += snprintf(maps + len, sizeof(maps) - len, " XX");
 			break;
 
 		case NA:
-			pr_cont(" --");
+			len += snprintf(maps + len, sizeof(maps) - len, " --");
 			break;
 
 		case IDE:
 			WARN_ON((i & 1) || map[i + 1] != IDE);
 			pinfo[i / 2] = piix_port_info[ich_pata_100];
 			i++;
-			pr_cont(" IDE IDE");
+			len += snprintf(maps + len, sizeof(maps) - len,
+					" IDE IDE");
 			break;
 
 		default:
-			pr_cont(" P%d", map[i]);
+			len += snprintf(maps + len, sizeof(maps) - len,
+					" P%d", map[i]);
 			if (i & 1)
 				pinfo[i / 2].flags |= ATA_FLAG_SLAVE_POSS;
 			break;
 		}
 	}
-	pr_cont(" ]\n");
+
+	dev_info(&pdev->dev, "MAP [%s ]\n", maps);
 
 	if (invalid_map)
 		dev_err(&pdev->dev, "invalid MAP value %u\n", map_value);
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 2878b0e..636a245 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -296,41 +296,36 @@ static void redrat3_issue_async(struct redrat3_dev *rr3)
 
 static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 {
-	if (!rr3->transmitting && (code != 0x40))
-		dev_info(rr3->dev, "fw error code 0x%02x: ", code);
+	const char *msg = "";
 
 	switch (code) {
 	case 0x00:
-		pr_cont("No Error\n");
+		msg = "No Error";
 		break;
 
 	/* Codes 0x20 through 0x2f are IR Firmware Errors */
 	case 0x20:
-		pr_cont("Initial signal pulse not long enough "
-			"to measure carrier frequency\n");
+		msg = "Initial signal pulse not long enough to measure carrier frequency";
 		break;
 	case 0x21:
-		pr_cont("Not enough length values allocated for signal\n");
+		msg = "Not enough length values allocated for signal";
 		break;
 	case 0x22:
-		pr_cont("Not enough memory allocated for signal data\n");
+		msg = "Not enough memory allocated for signal data";
 		break;
 	case 0x23:
-		pr_cont("Too many signal repeats\n");
+		msg = "Too many signal repeats";
 		break;
 	case 0x28:
-		pr_cont("Insufficient memory available for IR signal "
-			"data memory allocation\n");
+		msg = "Insufficient memory available for IR signal data memory allocation";
 		break;
 	case 0x29:
-		pr_cont("Insufficient memory available "
-			"for IrDa signal data memory allocation\n");
+		msg = "Insufficient memory available for IrDa signal data memory allocation";
 		break;
 
 	/* Codes 0x30 through 0x3f are USB Firmware Errors */
 	case 0x30:
-		pr_cont("Insufficient memory available for bulk "
-			"transfer structure\n");
+		msg = "Insufficient memory available for bulk transfer structure";
 		break;
 
 	/*
@@ -339,20 +334,23 @@ static void redrat3_dump_fw_error(struct redrat3_dev *rr3, int code)
 	 */
 	case 0x40:
 		if (!rr3->transmitting)
-			pr_cont("Signal capture has been terminated\n");
+			msg = "Signal capture has been terminated";
 		break;
 	case 0x41:
-		pr_cont("Attempt to set/get and unknown signal I/O "
-			"algorithm parameter\n");
+		msg = "Attempt to set/get and unknown signal I/O algorithm parameter";
 		break;
 	case 0x42:
-		pr_cont("Signal capture already started\n");
+		msg = "Signal capture already started";
 		break;
 
 	default:
-		pr_cont("Unknown Error\n");
+		msg = "Unknown Error";
 		break;
 	}
+
+	if (!rr3->transmitting && (code != 0x40))
+		dev_info(rr3->dev, "fw error code 0x%02x: %s\n", code, msg);
+
 }
 
 static u32 redrat3_val_to_mod_freq(struct redrat3_signal_header *ph)
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 1901da1..f5dd19f 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -987,24 +987,28 @@ static void
 bnx2_report_link(struct bnx2 *bp)
 {
 	if (bp->link_up) {
+		const char *fc_type = "";
+		const char *fc_on = "";
 		netif_carrier_on(bp->dev);
-		netdev_info(bp->dev, "NIC %s Link is Up, %d Mbps %s duplex",
-			    bnx2_xceiver_str(bp),
-			    bp->line_speed,
-			    bp->duplex == DUPLEX_FULL ? "full" : "half");
 
 		if (bp->flow_ctrl) {
 			if (bp->flow_ctrl & FLOW_CTRL_RX) {
-				pr_cont(", receive ");
 				if (bp->flow_ctrl & FLOW_CTRL_TX)
-					pr_cont("& transmit ");
-			}
-			else {
-				pr_cont(", transmit ");
+					fc_type = ", receive & transmit";
+				else
+					fc_type = ", receive";
+
+			} else {
+				fc_type = ", transmit";
 			}
-			pr_cont("flow control ON");
+			fc_on = " flow control ON";
 		}
-		pr_cont("\n");
+		netdev_info(bp->dev, "NIC %s Link is Up, %d Mbps %s duplex%s%s\n",
+			    bnx2_xceiver_str(bp),
+			    bp->line_speed,
+			    bp->duplex == DUPLEX_FULL ? "full" : "half",
+			    fc_type, fc_on);
+
 	} else {
 		netif_carrier_off(bp->dev);
 		netdev_err(bp->dev, "NIC %s Link is Down\n",


