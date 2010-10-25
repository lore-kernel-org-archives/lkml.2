Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0JYHpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:45:18 -0400
Received: from smtp.nokia.com ([147.243.1.47]:29305 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab0JYHpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:45:16 -0400
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" 
	<remi.denis-courmont@nokia.com>
Organization: Maemo Devices - Nokia
To: ext Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [64/66] Phonet: disable network namespace support
Date: Mon, 25 Oct 2010 10:43:32 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.35.7; KDE/4.5.1; i686; ; )
Cc: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20101022183601.910822183@clark.site> <1287782553.20865.253.camel@localhost>
In-Reply-To: <1287782553.20865.253.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010251043.32952.remi.denis-courmont@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 October 2010 00:22:33 ext Ben Hutchings, you wrote:
> On Fri, 2010-10-22 at 11:35 -0700, Greg KH wrote:
> I've had one report today that the bug is still reproducible in the
> current Debian kernel, which includes this change.  Rémi, how have you
> tested this fix?

I don´t actually remember, but I obviously missed something :-(
With similar problem reports in Nokia/MeeGo, that´ s what I added last week:

From: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Subject: [PATCH] Phonet: device notifier only runs on initial namespace

This should really fix the OOPS when doing:

  unshare(CLONE_NEWNET);
  exit(0);

while the phonet module is loaded.

Signed-off-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
---
 net/phonet/pn_dev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 5a2275c..d94ca91 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -225,6 +225,9 @@ static int phonet_device_notify(struct notifier_block *me, unsigned long what,
 {
 	struct net_device *dev = arg;
 
+	if (!net_eq(dev_net(dev), &init_net))
+		return 0;
+
 	switch (what) {
 	case NETDEV_REGISTER:
 		if (dev->type == ARPHRD_PHONET)
-- 
1.7.1
