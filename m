Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404Ab2JYM3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:29:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab2JYM3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:29:10 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC] edac: Fix the dimm filling for csrows-based layouts
Date: Thu, 25 Oct 2012 10:29:02 -0200
Message-Id: <24bef66e74d647aebd34e0bef7693512b7912029.1351168139.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is currently filling data in a wrong way, on drivers
for csrows-based memory controller, when the first layer is a
csrow.

This is not easily to notice, as, in general, memories are
filed in dual, interleaved, symetric mode, as very few memory
controllers support asymetric modes.

While digging into a bug for i82795_edac driver, the asymetric
mode there is now working, allowing us to fill the machine with
4x1GB ranks at channel 0, and 2x512GB at channel 1:

Channel 0 ranks:
EDAC DEBUG: i82975x_init_csrows: DIMM A0: from page 0x00000000 to 0x0003ffff (size: 0x00040000 pages)
EDAC DEBUG: i82975x_init_csrows: DIMM A1: from page 0x00040000 to 0x0007ffff (size: 0x00040000 pages)
EDAC DEBUG: i82975x_init_csrows: DIMM A2: from page 0x00080000 to 0x000bffff (size: 0x00040000 pages)
EDAC DEBUG: i82975x_init_csrows: DIMM A3: from page 0x000c0000 to 0x000fffff (size: 0x00040000 pages)

Channel 1 ranks:
EDAC DEBUG: i82975x_init_csrows: DIMM B0: from page 0x00100000 to 0x0011ffff (size: 0x00020000 pages)
EDAC DEBUG: i82975x_init_csrows: DIMM B1: from page 0x00120000 to 0x0013ffff (size: 0x00020000 pages)

Instead of properly showing the memories as such, before this patch, it
shows the memory layout as:

          +-----------------------------------+
          |                mc0                |
          |  csrow0   |  csrow1   |  csrow2   |
----------+-----------------------------------+
channel1: |  1024 MB  |  1024 MB  |   512 MB  |
channel0: |  1024 MB  |  1024 MB  |   512 MB  |
----------+-----------------------------------+

as if both channels were symetric, grouping the DIMMs on a wrong
layout.

After this patch, the memory is correctly represented.
So, for csrows at layers[0], it shows:

          +-----------------------------------------------+
          |                      mc0                      |
          |  csrow0   |  csrow1   |  csrow2   |  csrow3   |
----------+-----------------------------------------------+
channel1: |   512 MB  |   512 MB  |     0 MB  |     0 MB  |
channel0: |  1024 MB  |  1024 MB  |  1024 MB  |  1024 MB  |
----------+-----------------------------------------------+

For csrows at layers[1], it shows:

        +-----------------------+
        |          mc0          |
        | channel0  | channel1  |
--------+-----------------------+
csrow3: |  1024 MB  |     0 MB  |
csrow2: |  1024 MB  |     0 MB  |
--------+-----------------------+
csrow1: |  1024 MB  |   512 MB  |
csrow0: |  1024 MB  |   512 MB  |
--------+-----------------------+

So, no matter of what comes first, the information between
channel and csrow will be properly represented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d5dc9da..81eb9fd 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -416,10 +416,18 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 		dimm->cschannel = chn;
 
 		/* Increment csrow location */
-		row++;
-		if (row == tot_csrows) {
-			row = 0;
+		if (layers[0].is_virt_csrow) {
 			chn++;
+			if (chn == tot_channels) {
+				chn = 0;
+				row++;
+			}
+		} else {
+			row++;
+			if (row == tot_csrows) {
+				row = 0;
+				chn++;
+			}
 		}
 
 		/* Increment dimm location */
-- 
1.7.11.7

