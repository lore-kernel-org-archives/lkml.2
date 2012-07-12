Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161819Ab2GLWkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:40:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161803Ab2GLWkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        William Dauchy <wdauchy@gmail.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 085/187] xen/blkback: Copy id field when doing BLKIF_DISCARD.
Date: Thu, 12 Jul 2012 15:34:01 -0700
Message-Id: <20120712191530.279801293@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 8c9ce606a60e4a0cb447bdc082ce383b96b227b4 upstream.

We weren't copying the id field so when we sent the response
back to the frontend (especially with a 64-bit host and 32-bit
guest), we ended up using a random value. This lead to the
frontend crashing as it would try to pass to __blk_end_request_all
a NULL 'struct request' (b/c it would use the 'id' to find the
proper 'struct request' in its shadow array) and end up crashing:

BUG: unable to handle kernel NULL pointer dereference at 000000e4
IP: [<c0646d4c>] __blk_end_request_all+0xc/0x40
.. snip..
EIP is at __blk_end_request_all+0xc/0x40
.. snip..
 [<ed95db72>] blkif_interrupt+0x172/0x330 [xen_blkfront]

This fixes the bug by passing in the proper id for the response.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=824641

Tested-by: William Dauchy <wdauchy@gmail.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/common.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -257,6 +257,7 @@ static inline void blkif_get_x86_32_req(
 		break;
 	case BLKIF_OP_DISCARD:
 		dst->u.discard.flag = src->u.discard.flag;
+		dst->u.discard.id = src->u.discard.id;
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
@@ -287,6 +288,7 @@ static inline void blkif_get_x86_64_req(
 		break;
 	case BLKIF_OP_DISCARD:
 		dst->u.discard.flag = src->u.discard.flag;
+		dst->u.discard.id = src->u.discard.id;
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;


