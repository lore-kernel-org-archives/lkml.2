Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1DMQE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:04:57 -0400
Received: from kroah.org ([198.145.64.141]:54391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757920Ab1DMPze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:46 2011
Message-Id: <20110413155146.821148720@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Patrick McHardy <kaber@trash.net>
Subject: [36/74] bridge: netfilter: fix information leak
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit d846f71195d57b0bbb143382647c2c6638b04c5a upstream.

Struct tmp is copied from userspace.  It is not checked whether the "name"
field is NULL terminated.  This may lead to buffer overflow and passing
contents of kernel stack as a module name to try_then_request_module() and,
consequently, to modprobe commandline.  It would be seen by all userspace
processes.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/netfilter/ebtables.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -979,6 +979,8 @@ static int do_replace(struct net *net, v
 	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
 		return -ENOMEM;
 
+	tmp.name[sizeof(tmp.name) - 1] = 0;
+
 	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
 	newinfo = vmalloc(sizeof(*newinfo) + countersize);
 	if (!newinfo)


