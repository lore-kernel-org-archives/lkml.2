Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab0HCP2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:28:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61986 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab0HCP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=VQn1cAGJxqLhcY0bo3VCvr7JPsJEFk4esyQLYgTEHwVqT9gqCgyG3gGzKXaJvL/kzp
         QEw541MEXrOneNBrjV2mHunYRcP6TOxjEemZ/Uv0dsGUD15dAJjSkJ8iQrV9CYtR5s+G
         umvWFq8vike/cl9Wp4kAfZfDWKgsV2k+n3ig4=
Date: Tue, 3 Aug 2010 17:27:47 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: [patch] pata_winbond: fix module init
Message-ID: <20100803152549.GQ26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	alan@lxorguk.ukuu.org.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

winbond_init_one() returns 0 on success and an error code on failure.
In the original code, we always just released the regions and return
-ENODEV.  This was introduce in 2006 by 7e45b0e5f6f6 "[PATCH] libata:
Winbond support".

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Compile tested.

diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 6d8619b..b34b594 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -248,9 +248,10 @@ static __init int winbond_init(void)
 
 			if (request_region(port, 2, "pata_winbond")) {
 				ret = winbond_init_one(port);
-				if (ret <= 0)
+				if (ret < 0)
 					release_region(port, 2);
-				else ct+= ret;
+				else
+					ct++;
 			}
 		}
 	}
