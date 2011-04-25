Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab1DYUzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:55:20 -0400
Received: from 1wt.eu ([62.212.114.60]:33918 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788Ab1DYUYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:09 -0400
Message-Id: <20110425200234.557148317@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 036/173] Fix pktcdvd ioctl dev_minor range check
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 252a52aa4fa22a668f019e55b3aac3ff71ec1c29 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/pktcdvd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2408,7 +2408,7 @@ static void pkt_release_dev(struct pktcd
 	pkt_shrink_pktlist(pd);
 }
 
-static struct pktcdvd_device *pkt_find_dev_from_minor(int dev_minor)
+static struct pktcdvd_device *pkt_find_dev_from_minor(unsigned int dev_minor)
 {
 	if (dev_minor >= MAX_WRITERS)
 		return NULL;


