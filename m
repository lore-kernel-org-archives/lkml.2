Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0K3Q3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:29:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:54488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab0K3Q3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:29:41 -0500
Message-ID: <4CF52652.4030802@kernel.org>
Date: Tue, 30 Nov 2010 17:29:06 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
References: <20101022012302.GA7487@havoc.gtf.org> <20101129180755.GK15818@bombadil.infradead.org> <4CF506A6.4020200@kernel.org> <20101130153839.GM15818@bombadil.infradead.org>
In-Reply-To: <20101130153839.GM15818@bombadil.infradead.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Nov 2010 16:29:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 04:38 PM, Kyle McMartin wrote:
> On Tue, Nov 30, 2010 at 03:13:58PM +0100, Tejun Heo wrote:
>>> Tejun, any ideas how I can debug this?
>>
>> Hmm... DIPM commands are failing with AC_ERR_OTHER.  Other than DIPM
>> not being configured and speed capped at 1.5Gbps, the machine works
>> fine afterwards, right?  Are you up for applying debug patches?
>>
> 
> Yup, it's chugging along happily, though I notice kernel builds are
> taking a minute or two longer (but I don't bother to time them so it's
> purely subjective.)
> 
> Be happy to apply any debug patches, but I plan on replacing the drive
> with a faster one at some point in the next few weeks.

Can you please apply the following patch and report the resulting
kernel log?  You're on ahci, right?

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index ebc08d6..b1c39db 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1560,6 +1560,10 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	}

 	/* okay, let's hand over to EH */
+	if (active_qc && ata_tag_internal(active_qc->tag))
+		ata_dev_printk(active_qc->dev, KERN_WARNING,
+			       "ahci: internal command failure, irq_stat=0x%x\n",
+			       irq_stat);

 	if (irq_stat & PORT_IRQ_FREEZE)
 		ata_port_freeze(ap);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7f77c67..7cf236b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1668,6 +1668,10 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,

 	/* perform minimal error analysis */
 	if (qc->flags & ATA_QCFLAG_FAILED) {
+		ata_dev_printk(dev, KERN_WARNING,
+			       "internal command failure: stat=0x%x ehi_desc=\"%s\"\n",
+			       qc->tf.command, dev->link->eh_info.desc);
+
 		if (qc->result_tf.command & (ATA_ERR | ATA_DF))
 			qc->err_mask |= AC_ERR_DEV;

