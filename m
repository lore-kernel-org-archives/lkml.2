Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab2KNJPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:15:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38870 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab2KNJPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:15:21 -0500
Date: Wed, 14 Nov 2012 01:15:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch 1/4] mm, oom: ensure sysrq+f always passes valid zonelist
Message-ID: <alpine.DEB.2.00.1211140111190.32125@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With hotpluggable and memoryless nodes, it's possible that node 0 will
not be online, so use the first online node's zonelist rather than
hardcoding node 0 to pass a zonelist with all zones to the oom killer.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/tty/sysrq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -346,7 +346,8 @@ static struct sysrq_key_op sysrq_term_op = {
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0, NULL, true);
+	out_of_memory(node_zonelist(first_online_node, GFP_KERNEL), GFP_KERNEL,
+		      0, NULL, true);
 }
 
 static DECLARE_WORK(moom_work, moom_callback);
