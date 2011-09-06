Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1IFQeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:34:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43922 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1IFQeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:34:03 -0400
Date: Wed, 7 Sep 2011 01:33:55 +0900
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110906163355.GG18425@mtj.dyndns.org>
References: <20110610140155.GJ15235@htj.dyndns.org>
 <4DF25526.9010800@teksavvy.com>
 <20110611121957.GA7980@mtj.dyndns.org>
 <4DF4F30B.70702@teksavvy.com>
 <20110613104856.GC16021@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D984D03@gretna.indigovision.com>
 <20110902011305.GE2752@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D9854F7@gretna.indigovision.com>
 <20110906034544.GB18425@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8DA54B00@gretna.indigovision.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32D8DA54B00@gretna.indigovision.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 06, 2011 at 01:19:44PM +0100, Bruce Stenning wrote:
> ata4: EH complete
> Waking error handler thread
> scsi_eh_wakeup: succeeded
> scsi_schedule_eh: succeeded
> scsi_restart_operations: waking up host to restart
> Error handler scsi_eh_3 sleeping

I think the following should fix the problem.  The code there is from
the time when libata shared scsi_host->host_lock.  libata no longer
does that so, in the current state, host_eh_scheduled can be cleared
with actual pending EH condition.

You should be able to reproduce the problem more easily by adding
delay (something like mdelay(5)) before host_eh_scheduled clearing
without the following patch applied.

Thanks.

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index ed16fbe..e971784 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -771,6 +771,14 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 		/* process port suspend request */
 		ata_eh_handle_port_suspend(ap);
 
+		/*
+		 * Single iteration complete.  Clear SCSI EH scheduled
+		 * state and check whether another iteration is necessary.
+		 */
+		spin_lock_irqsave(host->host_lock, flags);
+		host->host_eh_scheduled = 0;
+		spin_unlock_irqrestore(host->host_lock, flags);
+
 		/* Exception might have happened after ->error_handler
 		 * recovered the port but before this point.  Repeat
 		 * EH in such case.
@@ -792,13 +800,6 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 		ata_for_each_link(link, ap, HOST_FIRST)
 			memset(&link->eh_info, 0, sizeof(link->eh_info));
 
-		/* Clear host_eh_scheduled while holding ap->lock such
-		 * that if exception occurs after this point but
-		 * before EH completion, SCSI midlayer will
-		 * re-initiate EH.
-		 */
-		host->host_eh_scheduled = 0;
-
 		spin_unlock_irqrestore(ap->lock, flags);
 		ata_eh_release(ap);
 	} else {
