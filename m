Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2HMW2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:28:19 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59891 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab2HMWQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:16:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: [ 24/65] ore: Fix out-of-bounds access in _ios_obj()
Date: Mon, 13 Aug 2012 15:14:08 -0700
Message-Id: <20120813221417.093549310@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 9e62bb4458ad2cf28bd701aa5fab380b846db326 upstream.

_ios_obj() is accessed by group_index not device_table index.

The oc->comps array is only a group_full of devices at a time
it is not like ore_comp_dev() which is indexed by a global
device_table index.

This did not BUG until now because exofs only uses a single
COMP for all devices. But with other FSs like PanFS this is
not true.

This bug was only in the write_path, all other users were
using it correctly

[This is a bug since 3.2 Kernel]

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exofs/ore.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -837,11 +837,11 @@ static int _write_mirror(struct ore_io_s
 				bio->bi_rw |= REQ_WRITE;
 			}
 
-			osd_req_write(or, _ios_obj(ios, dev), per_dev->offset,
-				      bio, per_dev->length);
+			osd_req_write(or, _ios_obj(ios, cur_comp),
+				      per_dev->offset, bio, per_dev->length);
 			ORE_DBGMSG("write(0x%llx) offset=0x%llx "
 				      "length=0x%llx dev=%d\n",
-				     _LLU(_ios_obj(ios, dev)->id),
+				     _LLU(_ios_obj(ios, cur_comp)->id),
 				     _LLU(per_dev->offset),
 				     _LLU(per_dev->length), dev);
 		} else if (ios->kern_buff) {
@@ -853,20 +853,20 @@ static int _write_mirror(struct ore_io_s
 			       (ios->si.unit_off + ios->length >
 				ios->layout->stripe_unit));
 
-			ret = osd_req_write_kern(or, _ios_obj(ios, per_dev->dev),
+			ret = osd_req_write_kern(or, _ios_obj(ios, cur_comp),
 						 per_dev->offset,
 						 ios->kern_buff, ios->length);
 			if (unlikely(ret))
 				goto out;
 			ORE_DBGMSG2("write_kern(0x%llx) offset=0x%llx "
 				      "length=0x%llx dev=%d\n",
-				     _LLU(_ios_obj(ios, dev)->id),
+				     _LLU(_ios_obj(ios, cur_comp)->id),
 				     _LLU(per_dev->offset),
 				     _LLU(ios->length), per_dev->dev);
 		} else {
-			osd_req_set_attributes(or, _ios_obj(ios, dev));
+			osd_req_set_attributes(or, _ios_obj(ios, cur_comp));
 			ORE_DBGMSG2("obj(0x%llx) set_attributes=%d dev=%d\n",
-				     _LLU(_ios_obj(ios, dev)->id),
+				     _LLU(_ios_obj(ios, cur_comp)->id),
 				     ios->out_attr_len, dev);
 		}
 


