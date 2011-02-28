Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1B1Qg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:36:57 -0500
Received: from kroah.org ([198.145.64.141]:41179 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab1B1Qgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:36:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:06 2011
Message-Id: <20110228162406.273179231@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>
Subject: [06/68] Fix pktcdvd ioctl dev_minor range check
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


