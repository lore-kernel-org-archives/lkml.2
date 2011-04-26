Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab1DZVgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:36:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:60280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758737Ab1DZVNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914748443"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segoon@openwall.com, kaber@trash.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [25/106] bridge: netfilter: fix information leak
Message-Id: <20110426211304.136CA3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/bridge/netfilter/ebtables.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/net/bridge/netfilter/ebtables.c
===================================================================
--- linux-2.6.35.y.orig/net/bridge/netfilter/ebtables.c
+++ linux-2.6.35.y/net/bridge/netfilter/ebtables.c
@@ -1098,6 +1098,8 @@ static int do_replace(struct net *net, c
 	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
 		return -ENOMEM;
 
+	tmp.name[sizeof(tmp.name) - 1] = 0;
+
 	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
 	newinfo = vmalloc(sizeof(*newinfo) + countersize);
 	if (!newinfo)
