Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1D3OBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:01:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58474 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1D3OBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 10:01:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GQBOeB6qXma+2PdQmlEi5E9MnJVlUHGw1x/RRLYkJ8xxQ56k+Vp4oCadObd8PAggZx
         APIcbn7m8Al6TzZaU6C3jNU/CX/YEjABK9tQiWVYuCbYfszIDgCBsIaxDhzFK6Msfh/o
         UMoTEjvQ9q0Mdr7aKgk0gkphBQrLgDhFKbw20=
Date: Sat, 30 Apr 2011 16:01:09 +0200
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110430140109.GJ29280@htj.dyndns.org>
References: <4DA45CA7.9040102@teksavvy.com>
 <4DA467FB.6020905@teksavvy.com>
 <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
 <20110425162242.GB30828@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
 <20110426135027.GI878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com>
 <20110426155229.GM878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 26, 2011 at 05:05:45PM +0100, Bruce Stenning wrote:
> > Yeah, it makes sense.  Hmm... it seems I wasn't thinking straight when
> > I added that work around.  Not sure how to fix it properly at this
> > moment.  I'll think about it.  Can you please keep me posted if you
> > find something while testing?
> 
> I'm away for two and a bit weeks so I'm not sure what progress (if any)
> I will make during that time.  But yes, I shall certainly keep you posted
> as soon as I find anything else.  Thank you very much for your inputs.

So, here's the patch which should fix the problem you're seeing and
doesn't break the controllers which generate spurious hotplug events
during reset.  Please test this when you come back and let me know the
result.

Thank you.

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f26f2fe..a57845d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2802,10 +2802,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	}
 
 	/*
-	 * Some controllers can't be frozen very well and may set
-	 * spuruious error conditions during reset.  Clear accumulated
-	 * error information.  As reset is the final recovery action,
-	 * nothing is lost by doing this.
+	 * Some controllers can't be frozen very well and may set spuruious
+	 * error conditions during reset.  Clear accumulated error
+	 * information and re-thaw the port if frozen.  As reset is the
+	 * final recovery action and we cross check link onlineness against
+	 * device classification later, no hotplug event is lost by this.
 	 */
 	spin_lock_irqsave(link->ap->lock, flags);
 	memset(&link->eh_info, 0, sizeof(link->eh_info));
@@ -2814,6 +2815,9 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ap->pflags &= ~ATA_PFLAG_EH_PENDING;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
+	if (ap->pflags & ATA_PFLAG_FROZEN)
+		ata_eh_thaw_port(ap);
+
 	/*
 	 * Make sure onlineness and classification result correspond.
 	 * Hotplug could have happened during reset and some
