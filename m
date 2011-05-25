Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab1EYJlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:41:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47268 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab1EYJlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=canFQTchwEcHfmMknzx6AUd93xIAsdWIDs+wRzR+ve1ATWcx/s+hLPQiznXXQXzvxr
         uIyzS9C0uaFyXlpxJbvVzwy3DMz7xKcYlv2oD8jtJ8plOi06oTE2K+6S1FerBrgGQysa
         wDVEo+zMIvP4cdKwuLkyQlC3ISuPopjgfFEgg=
Date: Wed, 25 May 2011 11:41:27 +0200
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110525094127.GF10146@htj.dyndns.org>
References: <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
 <20110425162242.GB30828@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
 <20110426135027.GI878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
 <20110426155229.GM878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com>
 <20110430140109.GJ29280@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, sorry about the long delay.

On Tue, May 17, 2011 at 04:30:20PM +0100, Bruce Stenning wrote:
> __ata_port_freeze: ata4 port frozen
> ata4: hard resetting link
> sata_link_hardreset: ENTER
> ata4: COMRESET failed (errno=-32)
> sata_link_hardreset: EXIT, rc=-32
> ata4: reset failed (errno=-32), retrying in 33 secs
> __ata_port_freeze: ata4 port frozen
> ata4: hard resetting link
> sata_link_hardreset: ENTER
> ata4: COMRESET failed (errno=-32)
> sata_link_hardreset: EXIT, rc=-32
> ata4: reset failed, giving up
> ata_eh_recover: EXIT, rc=-32
> ata4.00: disabled
> ata4: EH complete
> ata_scsi_error: EXIT
> 
> The IRQ for that port is masked off afterwards.

This is a different issue.  libata EH plugs the port if reset fails
repeatedly.  This behavior was implemented to avoid causing continuous
resets on a port in case it has flaky PHY state reporting; however, it
seems to cause more trouble than fixing issues - ie. plugging in a
broken device may end up plugging the port even after the offending
device is removed until manual rescan or reboot.  I've been pondering
about changing the behavior like the following.

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index dfb6e9d..05797fe 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2885,8 +2885,17 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	    sata_scr_read(link, SCR_STATUS, &sstatus))
 		rc = -ERESTART;
 
-	if (rc == -ERESTART || try >= max_tries)
+	if (rc == -ERESTART || try >= max_tries) {
+		/*
+		 * Thaw host port even if reset failed, so that the port
+		 * can be retried on the next phy event.  This risks
+		 * repeated EH runs but seems to be a better tradeoff than
+		 * shutting down a port after a botched hotplug attempt.
+		 */
+		if (ata_is_host_link(link))
+			ata_eh_thaw_port(ap);
 		goto out;
+	}
 
 	now = jiffies;
 	if (time_before(now, deadline)) {
