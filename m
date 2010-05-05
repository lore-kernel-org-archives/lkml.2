Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0EESyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:54:20 -0400
Received: from havoc.gtf.org ([69.61.125.42]:56827 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab0EESyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:54:16 -0400
Date: Wed, 5 May 2010 14:54:13 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100505185413.GA4245@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A correction for an added-during-rc PCMCIA ID patch,
and a small doc update.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/DocBook/libata.tmpl |   49 ++++++++++++-------------------------
 drivers/ata/pata_pcmcia.c         |    4 +-
 drivers/ide/ide-cs.c              |    4 +-
 3 files changed, 20 insertions(+), 37 deletions(-)

Kristoffer Ericson (1):
      pata_pcmcia / ide-cs: Fix bad hashes for Transcend and kingston IDs

Sergei Shtylyov (1):
      libata: Fix several inaccuracies in developer's guide

diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
index ba99757..ff3e5be 100644
--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -107,10 +107,6 @@ void (*dev_config) (struct ata_port *, struct ata_device *);
 	issue of SET FEATURES - XFER MODE, and prior to operation.
 	</para>
 	<para>
-	Called by ata_device_add() after ata_dev_identify() determines
-	a device is present.
-	</para>
-	<para>
 	This entry may be specified as NULL in ata_port_operations.
 	</para>
 
@@ -154,8 +150,8 @@ unsigned int (*mode_filter) (struct ata_port *, struct ata_device *, unsigned in
 
 	<sect2><title>Taskfile read/write</title>
 	<programlisting>
-void (*tf_load) (struct ata_port *ap, struct ata_taskfile *tf);
-void (*tf_read) (struct ata_port *ap, struct ata_taskfile *tf);
+void (*sff_tf_load) (struct ata_port *ap, struct ata_taskfile *tf);
+void (*sff_tf_read) (struct ata_port *ap, struct ata_taskfile *tf);
 	</programlisting>
 
 	<para>
@@ -164,36 +160,35 @@ void (*tf_read) (struct ata_port *ap, struct ata_taskfile *tf);
 	hardware registers / DMA buffers, to obtain the current set of
 	taskfile register values.
 	Most drivers for taskfile-based hardware (PIO or MMIO) use
-	ata_tf_load() and ata_tf_read() for these hooks.
+	ata_sff_tf_load() and ata_sff_tf_read() for these hooks.
 	</para>
 
 	</sect2>
 
 	<sect2><title>PIO data read/write</title>
 	<programlisting>
-void (*data_xfer) (struct ata_device *, unsigned char *, unsigned int, int);
+void (*sff_data_xfer) (struct ata_device *, unsigned char *, unsigned int, int);
 	</programlisting>
 
 	<para>
 All bmdma-style drivers must implement this hook.  This is the low-level
 operation that actually copies the data bytes during a PIO data
 transfer.
-Typically the driver
-will choose one of ata_pio_data_xfer_noirq(), ata_pio_data_xfer(), or
-ata_mmio_data_xfer().
+Typically the driver will choose one of ata_sff_data_xfer_noirq(),
+ata_sff_data_xfer(), or ata_sff_data_xfer32().
 	</para>
 
 	</sect2>
 
 	<sect2><title>ATA command execute</title>
 	<programlisting>
-void (*exec_command)(struct ata_port *ap, struct ata_taskfile *tf);
+void (*sff_exec_command)(struct ata_port *ap, struct ata_taskfile *tf);
 	</programlisting>
 
 	<para>
 	causes an ATA command, previously loaded with
 	->tf_load(), to be initiated in hardware.
-	Most drivers for taskfile-based hardware use ata_exec_command()
+	Most drivers for taskfile-based hardware use ata_sff_exec_command()
 	for this hook.
 	</para>
 
@@ -218,8 +213,8 @@ command.
 
 	<sect2><title>Read specific ATA shadow registers</title>
 	<programlisting>
-u8   (*check_status)(struct ata_port *ap);
-u8   (*check_altstatus)(struct ata_port *ap);
+u8   (*sff_check_status)(struct ata_port *ap);
+u8   (*sff_check_altstatus)(struct ata_port *ap);
 	</programlisting>
 
 	<para>
@@ -227,20 +222,14 @@ u8   (*check_altstatus)(struct ata_port *ap);
 	hardware.  On some hardware, reading the Status register has
 	the side effect of clearing the interrupt condition.
 	Most drivers for taskfile-based hardware use
-	ata_check_status() for this hook.
-	</para>
-	<para>
-	Note that because this is called from ata_device_add(), at
-	least a dummy function that clears device interrupts must be
-	provided for all drivers, even if the controller doesn't
-	actually have a taskfile status register.
+	ata_sff_check_status() for this hook.
 	</para>
 
 	</sect2>
 
 	<sect2><title>Select ATA device on bus</title>
 	<programlisting>
-void (*dev_select)(struct ata_port *ap, unsigned int device);
+void (*sff_dev_select)(struct ata_port *ap, unsigned int device);
 	</programlisting>
 
 	<para>
@@ -251,9 +240,7 @@ void (*dev_select)(struct ata_port *ap, unsigned int device);
 	</para>
 	<para>
 	Most drivers for taskfile-based hardware use
-	ata_std_dev_select() for this hook.  Controllers which do not
-	support second drives on a port (such as SATA contollers) will
-	use ata_noop_dev_select().
+	ata_sff_dev_select() for this hook.
 	</para>
 
 	</sect2>
@@ -441,13 +428,13 @@ void (*irq_clear) (struct ata_port *);
 	to struct ata_host_set.
 	</para>
 	<para>
-	Most legacy IDE drivers use ata_interrupt() for the
+	Most legacy IDE drivers use ata_sff_interrupt() for the
 	irq_handler hook, which scans all ports in the host_set,
 	determines which queued command was active (if any), and calls
-	ata_host_intr(ap,qc).
+	ata_sff_host_intr(ap,qc).
 	</para>
 	<para>
-	Most legacy IDE drivers use ata_bmdma_irq_clear() for the
+	Most legacy IDE drivers use ata_sff_irq_clear() for the
 	irq_clear() hook, which simply clears the interrupt and error
 	flags in the DMA status register.
 	</para>
@@ -496,10 +483,6 @@ void (*host_stop) (struct ata_host_set *host_set);
 	data from port at this time.
 	</para>
 	<para>
-	Many drivers use ata_port_stop() as this hook, which frees the
-	PRD table.
-	</para>
-	<para>
 	->host_stop() is called after all ->port_stop() calls
 have completed.  The hook must finalize hardware shutdown, release DMA
 and other resources, etc.
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 4164dd2..d94b8f0 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -424,7 +424,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
-	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x3e520e17),
+	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x55d5bffb),
 	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 4GB", 0x2e6d1829, 0x531e7d10),
 	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
@@ -446,7 +446,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
-	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x9351e59d),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x7558f133),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS8GCF133", 0x709b1bf1, 0xb2f89b47),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index defce28..b854508 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -409,7 +409,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
-	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x3e520e17),
+	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x55d5bffb),
 	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 4GB", 0x2e6d1829, 0x531e7d10),
 	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
@@ -431,7 +431,7 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
-	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x9351e59d),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x7558f133),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS8GCF133", 0x709b1bf1, 0xb2f89b47),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
