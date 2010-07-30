Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0G3RFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:05:15 -0400
Received: from kroah.org ([198.145.64.141]:35540 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236Ab0G3RDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:38 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:54 2010
Message-Id: <20100730165954.720955876@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [10/17] SCSI: aacraid: Eliminate use after free
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit 8a52da632ceb9d8b776494563df579e87b7b586b upstream.

The debugging code using the freed structure is moved before the kfree.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@free@
expression E;
position p;
@@
kfree@p(E)

@@
expression free.E, subE<=free.E, E1;
position free.p;
@@

  kfree@p(E)
  ...
(
  subE = E1
|
* E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>

---
 drivers/scsi/aacraid/commctrl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -645,9 +645,9 @@ static int aac_send_raw_srb(struct aac_d
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
 				if(!p) {
-					kfree (usg);
-					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+					dprintk((KERN_DEBUG "aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  usg->sg[i].count,i,usg->count));
+					kfree(usg);
 					rcode = -ENOMEM;
 					goto cleanup;
 				}


