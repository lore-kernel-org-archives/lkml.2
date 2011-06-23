Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab1FWBNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:13:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30997 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab1FWBNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=mc680+eu9VZ9Jy7jx60C0yE7k2WaUbpUSP7phPOn7DdXjLSjO1NbBMIdnYLzR/N0fC
         B11YJYu+q9miaLApaBNQ==
Date: Wed, 22 Jun 2011 18:13:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch 1/2] mm, hotplug: fix error handling in mem_online_node()
Message-ID: <alpine.DEB.2.00.1106221810130.23120@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error handling in mem_online_node() is incorrect: hotadd_new_pgdat() 
returns NULL if the new pgdat could not have been allocated and a pointer 
to it otherwise.

mem_online_node() should fail if hotadd_new_pgdat() fails, not the 
inverse.  This fixes an issue when memoryless nodes are not onlined and 
their sysfs interface is not registered when their first cpu is brought 
up.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memory_hotplug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -521,7 +521,7 @@ int mem_online_node(int nid)
 
 	lock_memory_hotplug();
 	pgdat = hotadd_new_pgdat(nid, 0);
-	if (pgdat) {
+	if (!pgdat) {
 		ret = -ENOMEM;
 		goto out;
 	}
