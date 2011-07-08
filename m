Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1GHFOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:14:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab1GHFD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:58 2011
Message-Id: <20110708001658.160164119@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Rientjes <rientjes@google.com>
Subject: [056/107] mm, hotplug: fix error handling in mem_online_node()
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Rientjes <rientjes@google.com>

commit 7553e8f2d5161a2b7a9b7a9f37be1b77e735552f upstream.

The error handling in mem_online_node() is incorrect: hotadd_new_pgdat()
returns NULL if the new pgdat could not have been allocated and a pointer
to it otherwise.

mem_online_node() should fail if hotadd_new_pgdat() fails, not the
inverse.  This fixes an issue when memoryless nodes are not onlined and
their sysfs interface is not registered when their first cpu is brought
up.

The bug was introduced by commit cf23422b9d76 ("cpu/mem hotplug: enable
CPUs online before local memory online") iow v2.6.35.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -518,7 +518,7 @@ int mem_online_node(int nid)
 
 	lock_memory_hotplug();
 	pgdat = hotadd_new_pgdat(nid, 0);
-	if (pgdat) {
+	if (!pgdat) {
 		ret = -ENOMEM;
 		goto out;
 	}


