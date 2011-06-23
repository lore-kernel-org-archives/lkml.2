Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab1FWBNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:13:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56376 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab1FWBNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=QLKOuAKDwsW32O7EExzbmB54i3muajSlcvaEOxhWd3GzrMlFAFd+wabLfE716KRBmj
         Xkti99hQ8c1fYM2R2Pqw==
Date: Wed, 22 Jun 2011 18:13:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch 2/2] mm, hotplug: protect zonelist building with
 zonelists_mutex
In-Reply-To: <alpine.DEB.2.00.1106221810130.23120@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1106221811500.23120@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1106221810130.23120@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

959ecc48fc75 ("mm/memory_hotplug.c: fix building of node hotplug 
zonelist") does not protect the build_all_zonelists() call with 
zonelists_mutex as needed.  This can lead to races in constructing 
zonelist ordering if a concurrent build is underway.  Protecting this with 
lock_memory_hotplug() is insufficient since zonelists can be rebuild 
though sysfs as well.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memory_hotplug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -498,7 +498,9 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 	 * The node we allocated has no zone fallback lists. For avoiding
 	 * to access not-initialized zonelist, build here.
 	 */
+	mutex_lock(&zonelists_mutex);
 	build_all_zonelists(NULL);
+	mutex_unlock(&zonelists_mutex);
 
 	return pgdat;
 }
