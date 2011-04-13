Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab1DMPzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:55:45 -0400
Received: from kroah.org ([198.145.64.141]:54427 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138Ab1DMPzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:47 2011
Message-Id: <20110413155147.558050437@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>, Changli Gao <xiaosuo@gmail.com>,
        Patrick McHardy <kaber@trash.net>
Subject: [43/74] netfilter: ipt_CLUSTERIP: fix buffer overflow
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 961ed183a9fd080cf306c659b8736007e44065a5 upstream.

'buffer' string is copied from userspace.  It is not checked whether it is
zero terminated.  This may lead to overflow inside of simple_strtoul().
Changli Gao suggested to copy not more than user supplied 'size' bytes.

It was introduced before the git epoch.  Files "ipt_CLUSTERIP/*" are
root writable only by default, however, on some setups permissions might be
relaxed to e.g. network admin user.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -666,8 +666,11 @@ static ssize_t clusterip_proc_write(stru
 	struct clusterip_config *c = pde->data;
 	unsigned long nodenum;
 
-	if (copy_from_user(buffer, input, PROC_WRITELEN))
+	if (size > PROC_WRITELEN)
+		return -EIO;
+	if (copy_from_user(buffer, input, size))
 		return -EFAULT;
+	buffer[size] = 0;
 
 	if (*buffer == '+') {
 		nodenum = simple_strtoul(buffer+1, NULL, 10);


