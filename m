Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0IQWxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:53:41 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:47848 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127Ab0IQWxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:53:40 -0400
Subject: [PATCH] drm/edid: Don't repeatedly log hex dumps of bad EDIDs by
 default
From: Andy Walls <awalls@md.metrocast.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 18:53:26 -0400
Message-ID: <1284764006.13604.21.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-17_11:2010-09-18,2010-09-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009170161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my system, every 10 seconds drm_edid_block_valid() gets called 4
times by radeon_dvi_detect().  This results in 4 instances of a
multi-line hex dump of the same EDID (non-)data being logged every 10
seconds.

Silence the hex dump from drm_edid_block_valid() unless a drm_debug
module parameter flag is set.

Signed-of-by: Andy Walls <awalls@md.metrocast.net>

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index dce5c4a..33a748c 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -173,9 +173,12 @@ drm_edid_block_valid(u8 *raw_edid)
 
 bad:
        if (raw_edid) {
-               DRM_ERROR("Raw EDID:\n");
-               print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE, raw_edid, EDID_LENGTH);
-               printk("\n");
+               DRM_DEBUG("Raw EDID:\n");
+               if (drm_debug & DRM_UT_CORE) {
+                       print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE,
+                                            raw_edid, EDID_LENGTH);
+                       printk("\n");
+               }
        }
        return 0;
 }


