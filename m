Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0IXQ2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:10 -0400
Received: from kroah.org ([198.145.64.141]:46099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528Ab0IXQ2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:08 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:16 2010
Message-Id: <20100924162616.564823869@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [19/80] drivers/net/cxgb3/cxgb3_main.c: prevent reading uninitialized stack memory
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 49c37c0334a9b85d30ab3d6b5d1acb05ef2ef6de upstream.

Fixed formatting (tabs and line breaks).

The CHELSIO_GET_QSET_NUM device ioctl allows unprivileged users to read
4 bytes of uninitialized stack memory, because the "addr" member of the
ch_reg struct declared on the stack in cxgb_extension_ioctl() is not
altered or zeroed before being copied back to the user.  This patch
takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cxgb3/cxgb3_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -2296,6 +2296,8 @@ static int cxgb_extension_ioctl(struct n
 	case CHELSIO_GET_QSET_NUM:{
 		struct ch_reg edata;
 
+		memset(&edata, 0, sizeof(struct ch_reg));
+
 		edata.cmd = CHELSIO_GET_QSET_NUM;
 		edata.val = pi->nqsets;
 		if (copy_to_user(useraddr, &edata, sizeof(edata)))


