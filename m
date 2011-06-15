Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1FOTSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:18:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54397 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1FOTST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:18:19 -0400
Date: Wed, 15 Jun 2011 12:17:47 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: jgarzik@pobox.com
Cc: mbizon@freebox.fr, tj@kernel.org, benh@kernel.crashing.org,
        wayneb@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: libata/ipr/powerpc: regression between 2.6.39-rc4 and 2.6.39-rc5
Message-ID: <20110615191747.GA6324@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.6.38-8-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

It appears that commit 7b3a24c57d2eeda8dba9c205342b12689c4679f9 broke
CD-ROMs on the IPR SATA bus on powerpc machines:

 ata_port_alloc: ENTER
 ata_port_probe: ata1: bus probe begin
 ata1.00: ata_dev_read_id: ENTER
 ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
 ata1.00: ata_dev_read_id: ENTER
 ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
 ata1.00: limiting speed to UDMA7:PIO5
 ata1.00: ata_dev_read_id: ENTER
 ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
 ata1.00: disabled
 ata_port_probe: ata1: bus probe end
 scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured

The commit in question is tagged as AHCI, but does touch the libata
core. I'm not well-versed with this code, but here's what I think I know
:)

>From __scsi_add_device, we first allocate the target:

 scsi_alloc_target ->
  shost->hostt->target_alloc ->
   ipr_target_alloc ->
    ata_port_alloc ->
     sets FROZEN

We error out when we allocate the sdev:

 scsi_alloc_sdev ->
  shost->hostt->slave_alloc ->
   ipr_slave_alloc ->
    ipr_ata_slave_alloc ->
     ata_sas_port_init ->
      ata_port_probe

>From what I can tell, the only place that explicitly clears the FROZEN
flag is the error-handling code via ata_eh_thaw_port().

So I thought either we're not invoking the error-handler at probe time
correctly to kick the port or perhaps the SAS code is not clearing the
flag?

I tried the following patch:

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d51f979..abd0e0b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3797,6 +3797,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
  */
 int ata_sas_port_start(struct ata_port *ap)
 {
+       ap->pflags &= ~ATA_PFLAG_FROZEN;
        return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_start);

and the CD-ROM drive works, but I have no idea if it's the right thing
to do. I chose this particular change, FWIW, because we call
ata_sas_port_start before we probe in ata_sas_port_init and it seems
like we need to mark the port as not frozen before we init it? Perhaps
that should really be a call to a thaw function, not sure. Let's just
say the ATA/SAS/SCSI interactions are a bit hard to follow at first :)

Any insight you can provide would be great!

Thanks,
Nish


-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
