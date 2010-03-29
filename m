Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab0C2JBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:01:39 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44342 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0C2JBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=iDwhmWW6kUz2yrXKbo1bczUnxYgBGFB9V4Kes5YQiGjllPtRs39/LMVB7buCmfnnDy
         On1SOw7CGqUtQHHxzzikuKDfPb4cRqo3VllkyMzgEJBnRVcq3DTa1Q97HBjZK+0tC2J+
         hxAkhUw1PUU18IhJvT7mg2AxHPJwzbRgxGqlw=
Date: Mon, 29 Mar 2010 12:01:27 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Anand Gadiyar <gadiyar@ti.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] usb/oxu210hp: release spinlock on error path
Message-ID: <20100329090127.GE5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, Anand Gadiyar <gadiyar@ti.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complained about this missing spinlock.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Compile tested only.  :/

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 50f57f4..e62b30b 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -660,13 +660,13 @@ static struct ehci_qh *oxu_qh_alloc(struct oxu_hcd *oxu)
 		if (qh->dummy == NULL) {
 			oxu_dbg(oxu, "no dummy td\n");
 			oxu->qh_used[i] = 0;
-
-			return NULL;
+			qh = NULL;
+			goto unlock;
 		}
 
 		oxu->qh_used[i] = 1;
 	}
-
+unlock:
 	spin_unlock(&oxu->mem_lock);
 
 	return qh;
