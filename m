Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0KHUcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:32:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0KHUcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:32:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=AbR20/1mhqIjyswtnu1PNIqnEKkZHOUfKr0bLIZzTEc7WfHAtCuTQiwdt7DQTriqa
	C0MIL4/gVh9pJKwrllzNw==
Subject: [PATCH v2 01/23] netconsole: Remove unneeded reference counting
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Date: Mon, 08 Nov 2010 12:31:42 -0800
Message-ID: <20101108203141.22479.74390.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loops that iterate through the list of targets for emitting console
messages in the netconsole driver operating with interrupts disabled and
the list-protecting lock held.  There is no way for the elements of the
list to disappear, so we don't need to grab references to them.

This patch keeps the definitions however of netconsole_target_get() and
netconsole_target_put() as they are used in a subsequent patch.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/net/netconsole.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 94255f0..c87a49e 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -671,7 +671,6 @@ static int netconsole_netdev_event(struct notifier_block *this,
 
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_for_each_entry(nt, &target_list, list) {
-		netconsole_target_get(nt);
 		if (nt->np.dev == dev) {
 			switch (event) {
 			case NETDEV_CHANGENAME:
@@ -693,7 +692,6 @@ static int netconsole_netdev_event(struct notifier_block *this,
 				break;
 			}
 		}
-		netconsole_target_put(nt);
 	}
 	spin_unlock_irqrestore(&target_list_lock, flags);
 	if (event == NETDEV_UNREGISTER || event == NETDEV_BONDING_DESLAVE)
@@ -722,7 +720,6 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_for_each_entry(nt, &target_list, list) {
-		netconsole_target_get(nt);
 		if (nt->enabled && netif_running(nt->np.dev)) {
 			/*
 			 * We nest this inside the for-each-target loop above
@@ -738,7 +735,6 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 				left -= frag;
 			}
 		}
-		netconsole_target_put(nt);
 	}
 	spin_unlock_irqrestore(&target_list_lock, flags);
 }

