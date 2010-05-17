Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0EQJxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:53:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:38367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab0EQJxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:53:01 -0400
Message-ID: <4BF111F8.1080106@kernel.org>
Date: Mon, 17 May 2010 11:52:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: coptang@gmail.com
CC: linux-kernel@vger.kernel.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Intermittent SATA failures ("link offline, clearing class 1 to
 	NONE")
References: <r2qf7a305db1004270252le438bd88vb3ca3d9b753651a9@mail.gmail.com> <g2lf7a305db1004270255t5d50de0n1dc21fdc7b191d92@mail.gmail.com>
In-Reply-To: <g2lf7a305db1004270255t5d50de0n1dc21fdc7b191d92@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------060601010709000602010700"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 17 May 2010 09:52:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060601010709000602010700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

(cc'ing linux-ide)

On 04/27/2010 11:55 AM, coptang@gmail.com wrote:
> Hi,
> 
> Further to emails from November and December last year that Tejun Heo
> was investigating:
> http://markmail.org/message/l3g3s27rwj6iuhje#query:Intermittent%20SATA%20failures%20%22%28link%20offline%2C%20clearing%20class%201%20to%20NONE%29%22+page:1+mid:g6ujvdfz4om2rnvf+state:results
> 
> I'm having the exact same problem, see below excerpt from dmesg. Note
> that the disk that fails is seemingly random:
> ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.01: SATA link up <unknown> (SStatus 300 SControl 123)
> ata2.00: link offline, clearing class 1 to NONE
> ata1.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> 
> I have attached a good and bad boot.
> 
> lspci -v shows:
> 
> 00:1f.2 IDE interface: Intel Corporation Ibex Peak 4 port SATA IDE
> Controller (rev 05) (prog-if 8f [Master SecP SecO PriP PriO])
>         Subsystem: Dell Device 02a4
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 20
>         I/O ports at eca0 [size=8]
>         I/O ports at ec90 [size=4]
>         I/O ports at eca8 [size=8]
>         I/O ports at ec94 [size=4]
>         I/O ports at ecc0 [size=16]
>         I/O ports at ecd0 [size=16]
>         Capabilities: [70] Power Management version 3
>         Capabilities: [b0] PCI Advanced Features
>         Kernel driver in use: ata_piix
>         Kernel modules: pata_acpi, ata_piix
> 
> 00:1f.5 IDE interface: Intel Corporation Ibex Peak 2 port SATA IDE
> Controller (rev 05) (prog-if 85 [Master SecO PriO])
>         Subsystem: Dell Device 02a4
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 21
>         I/O ports at ecb0 [size=8]
>         I/O ports at ec98 [size=4]
>         I/O ports at ecb8 [size=8]
>         I/O ports at ec9c [size=4]
>         I/O ports at ece0 [size=16]
>         I/O ports at ecf0 [size=16]
>         Capabilities: [70] Power Management version 3
>         Capabilities: [b0] PCI Advanced Features
>         Kernel driver in use: ata_piix
>         Kernel modules: pata_acpi, ata_piix
> 
> I'm currently running linux-2.6.32-gentoo-r7 on amd64 but I've tried
> linux-2.6.31-gentoo-r6 and linux-2.6.31-gentoo-r10 with the same
> results. libata.force=nohrst makes no appreciable difference
> 
> As before 'echo "- - -" > /sys/class/scsi_host/hostX/scan' where X is
> 0 or 1 brings the drive back online.
> 
> As the original chat petered out I was hoping that this had since been
> fixed. Anyone have any suggestions please?

Well, the problem was never properly diagnosed.  Can you please apply
the attached patch on top of 2.6.34, see whether the problem can be
reproduced and if so report the failing boot log?

Thank you.

-- 
tejun

--------------060601010709000602010700
Content-Type: text/x-patch;
 name="debounce-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="debounce-debug.patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 83bc49f..6e6b593 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -174,7 +174,8 @@ static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val);
 static int piix_sidpr_scr_write(struct ata_link *link,
 				unsigned int reg, u32 val);
-static bool piix_irq_check(struct ata_port *ap);
+static int piix_sidpr_hardreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline);static bool piix_irq_check(struct ata_port *ap);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
@@ -345,9 +346,9 @@ static struct ata_port_operations ich_pata_ops = {
 
 static struct ata_port_operations piix_sidpr_sata_ops = {
 	.inherits		= &piix_sata_ops,
-	.hardreset		= sata_std_hardreset,
 	.scr_read		= piix_sidpr_scr_read,
 	.scr_write		= piix_sidpr_scr_write,
+	.hardreset		= piix_sidpr_hardreset,
 };
 
 static const struct piix_map_db ich5_map_db = {
@@ -981,6 +982,18 @@ static bool piix_irq_check(struct ata_port *ap)
 	return ap->ops->bmdma_status(ap) & ATA_DMA_INTR;
 }
 
+static int piix_sidpr_hardreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	const unsigned long *timing = sata_deb_timing_long;
+	bool online;
+	int rc;
+
+	/* do hardreset */
+	rc = sata_link_hardreset(link, timing, deadline, &online, NULL);
+	return online ? -EAGAIN : rc;
+}
+
 #ifdef CONFIG_PM
 static int piix_broken_suspend(void)
 {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 49cffb6..2ba4284 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3738,7 +3738,7 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 	unsigned long interval = params[0];
 	unsigned long duration = params[1];
 	unsigned long last_jiffies, t;
-	u32 last, cur;
+	u32 last, cur, xxx;
 	int rc;
 
 	t = ata_deadline(jiffies, params[2]);
@@ -3747,7 +3747,9 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 
 	if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
 		return rc;
+	xxx = cur;
 	cur &= 0xf;
+	ata_link_printk(link, KERN_INFO, "XXX debounce start, SStatus=%x\n", xxx);
 
 	last = cur;
 	last_jiffies = jiffies;
@@ -3756,6 +3758,7 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 		msleep(interval);
 		if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
 			return rc;
+		xxx = cur;
 		cur &= 0xf;
 
 		/* DET stable? */
@@ -3763,8 +3766,12 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 			if (cur == 1 && time_before(jiffies, deadline))
 				continue;
 			if (time_after(jiffies,
-				       ata_deadline(last_jiffies, duration)))
+				       ata_deadline(last_jiffies, duration))) {
+				ata_link_printk(link, KERN_INFO,
+						"XXX debounce done, SStatus=%x, DET stable for %u msecs\n",
+						xxx, jiffies_to_msecs(jiffies - last_jiffies));
 				return 0;
+			}
 			continue;
 		}
 

--------------060601010709000602010700--
