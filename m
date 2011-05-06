Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1EFA0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:26:07 -0400
Received: from kroah.org ([198.145.64.141]:37358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494Ab1EFA0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:18 2011
Message-Id: <20110506002218.246364506@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?R=C3=A9mi=20Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>
Subject: [132/143] Phonet: device notifier only runs on initial namespace
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

[bwh: This is only applicable to 2.6.32. Phonet was fixed upstream to
work with multiple net namespaces.]

This should really fix the OOPS when doing:

  unshare(CLONE_NEWNET);
  exit(0);

while the phonet module is loaded.

Signed-off-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/phonet/pn_dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -225,6 +225,9 @@ static int phonet_device_notify(struct n
 {
 	struct net_device *dev = arg;
 
+	if (!net_eq(dev_net(dev), &init_net))
+		return 0;
+
 	switch (what) {
 	case NETDEV_REGISTER:
 		if (dev->type == ARPHRD_PHONET)


