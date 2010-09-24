Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab0IXQ15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:27:57 -0400
Received: from kroah.org ([198.145.64.141]:46023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472Ab0IXQ1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:27:55 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:15 2010
Message-Id: <20100924162615.420530786@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:23:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [06/80] irda: Correctly clean up self->ias_obj on irda_bind() failure.
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 628e300cccaa628d8fb92aa28cb7530a3d5f2257 ]

If irda_open_tsap() fails, the irda_bind() code tries to destroy
the ->ias_obj object by hand, but does so wrongly.

In particular, it fails to a) release the hashbin attached to the
object and b) reset the self->ias_obj pointer to NULL.

Fix both problems by using irias_delete_object() and explicitly
setting self->ias_obj to NULL, just as irda_release() does.

Reported-by: Tavis Ormandy <taviso@cmpxchg8b.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/irda/af_irda.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -824,8 +824,8 @@ static int irda_bind(struct socket *sock
 
 	err = irda_open_tsap(self, addr->sir_lsap_sel, addr->sir_name);
 	if (err < 0) {
-		kfree(self->ias_obj->name);
-		kfree(self->ias_obj);
+		irias_delete_object(self->ias_obj);
+		self->ias_obj = NULL;
 		goto out;
 	}
 


