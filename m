Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1DZNue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:50:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43980 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab1DZNuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lCkHPwHWlAs3CM1NLfxaaY/LU1QZ21KUn+22rI1hSMwrQnf4NCyWxb5kt5BebNwVCP
         lIkuZUV6Cd5PIE6/9/GFkkFz6gcuWIgi5uQNJ6FMEFMqGzhfxCinaZMc9tkzbjjwUTUq
         PGlAlMXx5j4GdlzRzTYYttq6DqItzABJGx3GU=
Date: Tue, 26 Apr 2011 15:50:27 +0200
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110426135027.GI878@htj.dyndns.org>
References: <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA45CA7.9040102@teksavvy.com>
 <4DA467FB.6020905@teksavvy.com>
 <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
 <20110425162242.GB30828@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:13:22PM +0100, Bruce Stenning wrote:
> Tejun wrote:
> > ata4 is reporting link down and the device is detached and port
> > disabled afterwards.  Doesn't seem to have much to do with
> > freezing/thawing?
> 
> After all processing of a normal unplug event has completed, the port is left
> thawed (and the irq enabled) to allow future hotplug events on this port to be
> actioned.  In the case of the port lockups that I have seen the port appears
> to be left frozen, with the irq disabled, and I am hypothesising that this is
> due to a race between the freeze and the thaw.
> 
> Below is some additional tracing leading up to a port lockup, with some more
> DPRINTK statements added.  The port freeze appears to be happening after the
> port thaw.  The irq mask writes that are output by mv_set_main_irq_mask seem
> to show the irqs left masked off.

Does the following patch resolve the problem?

Thanks.

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 88cd22f..73f0589 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2802,19 +2802,6 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	}
 
 	/*
-	 * Some controllers can't be frozen very well and may set
-	 * spuruious error conditions during reset.  Clear accumulated
-	 * error information.  As reset is the final recovery action,
-	 * nothing is lost by doing this.
-	 */
-	spin_lock_irqsave(link->ap->lock, flags);
-	memset(&link->eh_info, 0, sizeof(link->eh_info));
-	if (slave)
-		memset(&slave->eh_info, 0, sizeof(link->eh_info));
-	ap->pflags &= ~ATA_PFLAG_EH_PENDING;
-	spin_unlock_irqrestore(link->ap->lock, flags);
-
-	/*
 	 * Make sure onlineness and classification result correspond.
 	 * Hotplug could have happened during reset and some
 	 * controllers fail to wait while a drive is spinning up after
