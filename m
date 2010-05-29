Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0E2TJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 15:09:19 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:58065 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0E2TJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 15:09:18 -0400
Date: Sat, 29 May 2010 12:09:16 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       tytso@mit.edu, jens.axboe@oracle.com
Subject: Re: [PATCH 2/4] add the new generic kfifo API
Message-ID: <20100529190916.GA18696@ovro.caltech.edu>
References: <1273654167-31067-1-git-send-email-stefani@seibold.net>
 <1273654167-31067-3-git-send-email-stefani@seibold.net>
 <20100529183059.GA9773@ovro.caltech.edu>
 <1275158894.9189.6.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275158894.9189.6.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Sat, 29 May 2010 12:09:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 08:48:14PM +0200, Stefani Seibold wrote:
> Hi Ira,
> 
> please don't send me back the hole patch. If you want enhance something,
> please write a clean patch which can i apply against the generic API
> patch.
> 

If you looked down far enough, I put my comments inline. I should have
snipped out the extra noise, sorry.

Here is a completely untested patch that should fix kfifo when used with
chained scatterlists (AKA struct sg_table). Feel free to roll it into
the main patch.

Ira

>From 01d90fc6fb35e16b034f0893cd717af51c690cc7 Mon Sep 17 00:00:00 2001
From: Ira W. Snyder <kernel@irasnyder.com>
Date: Sat, 29 May 2010 12:02:47 -0700
Subject: [PATCH] kfifo: fix scatterlist usage

The current kfifo scatterlist implementation will not work with chained
scatterlists. It assumes that struct scatterlist arrays are allocated
contiguously, which is not the case when chained scatterlists (struct
sg_table) are in use.

Signed-off-by: Ira W. Snyder <kernel@irasnyder.com>
---
 kernel/kfifo.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 02192dd..bd4e083 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -333,17 +333,16 @@ static int setup_sgl_buf(struct scatterlist *sgl, void *buf,
 		buf += PAGE_SIZE;
 		npage = virt_to_page(buf);
 		if (page_to_phys(page) != page_to_phys(npage) - l) {
-			sgl->page_link = 0;
-			sg_set_page(sgl++, page, l - off, off);
-			if (++n == nents)
+			sg_set_page(sgl, page, l - off, off);
+			sgl = sg_next(sgl);
+			if (++n == nents || sgl == NULL)
 				return n;
 			page = npage;
 			len -= l - off;
 			l = off = 0;
 		}
 	}
-	sgl->page_link = 0;
-	sg_set_page(sgl++, page, len, off);
+	sg_set_page(sgl, page, len, off);
 	return n + 1;
 }
 
-- 
1.7.1

