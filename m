Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0LLXsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36968 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab0LLXsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:51 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: drosenberg@vsecurity.com, dan.j.rosenberg@gmail.com,
        torvalds@linux-foundation.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [222/223] Fix pktcdvd ioctl dev_minor range check
Message-Id: <20101212234850.563F1B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

Upstream 252a52aa4fa22a668f019e55b3aac3ff71ec1c29

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/block/pktcdvd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/block/pktcdvd.c
===================================================================
--- linux.orig/drivers/block/pktcdvd.c
+++ linux/drivers/block/pktcdvd.c
@@ -2368,7 +2368,7 @@ static void pkt_release_dev(struct pktcd
 	pkt_shrink_pktlist(pd);
 }
 
-static struct pktcdvd_device *pkt_find_dev_from_minor(int dev_minor)
+static struct pktcdvd_device *pkt_find_dev_from_minor(unsigned int dev_minor)
 {
 	if (dev_minor >= MAX_WRITERS)
 		return NULL;
