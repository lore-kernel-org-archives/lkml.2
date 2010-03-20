Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0CTMYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 08:24:15 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56443 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0CTMYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 08:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=QUkd5L4AFA7JvQRpKBZUBH15ajdK+KEmrp/ItCtlqhilAcXXHsSjbKZagwPQbbrRG+
         /RF1cK1wPoq6O2vg46z4RJVDfQB0MvPFFPPIk8WMh/Ki3t7YQkSq9ygTcorsf3WUFzBr
         UU55Ui60yNqToHOGrnmz1KunoBCt6eRWvyGq0=
Date: Sat, 20 Mar 2010 15:24:03 +0300
From: Dan Carpenter <error27@gmail.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ajay Kumar Gupta <ajay.gupta@ti.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] musb: potential use after free
Message-ID: <20100320122403.GC5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Felipe Balbi <felipe.balbi@nokia.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Sergei Shtylyov <sshtylyov@ru.mvista.com>,
	Ajay Kumar Gupta <ajay.gupta@ti.com>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We assign "urb->hcpriv = qh;" a few lines down.  I'm pretty sure we 
want it "urb->hcpriv" to be NULL not a freed value.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Found with a static checker.  I don't have the hardware to test this.

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index dec896e..877d20b 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -2042,6 +2042,7 @@ static int musb_urb_enqueue(
 		 * odd, rare, error prone, but legal.
 		 */
 		kfree(qh);
+		qh = NULL;
 		ret = 0;
 	} else
 		ret = musb_schedule(musb, qh,
