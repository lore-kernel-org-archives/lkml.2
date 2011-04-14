Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851Ab1DNR6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:58:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:41582 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825Ab1DNR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:53 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 131/209] Fix pktcdvd ioctl dev_minor range check
Date: Thu, 14 Apr 2011 13:54:49 -0400
Message-Id: <1302803767-9715-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 252a52aa4fa22a668f019e55b3aac3ff71ec1c29 upstream

The PKT_CTRL_CMD_STATUS device ioctl retrieves a pointer to a
pktcdvd_device from the global pkt_devs array.  The index into this
array is provided directly by the user and is a signed integer, so the
comparison to ensure that it falls within the bounds of this array will
fail when provided with a negative index.

This can be used to read arbitrary kernel memory or cause a crash due to
an invalid pointer dereference.  This can be exploited by users with
permission to open /dev/pktcdvd/control (on many distributions, this is
readable by group "cdrom").

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
[ Rather than add a cast, just make the function take the right type -Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/block/pktcdvd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 8a549db..8403fd5 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2368,7 +2368,7 @@ static void pkt_release_dev(struct pktcdvd_device *pd, int flush)
 	pkt_shrink_pktlist(pd);
 }
 
-static struct pktcdvd_device *pkt_find_dev_from_minor(int dev_minor)
+static struct pktcdvd_device *pkt_find_dev_from_minor(unsigned int dev_minor)
 {
 	if (dev_minor >= MAX_WRITERS)
 		return NULL;
-- 
1.7.4.4

