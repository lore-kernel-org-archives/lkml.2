Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935475Ab1KJDci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:32:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935362Ab1KJDcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:32:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:23 2011
Message-Id: <20111109212723.732453808@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [230/262] powerpc/numa: Remove double of_node_put in hot_add_node_scn_to_nid
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 6083184269fd723affca4f6340e491950267622a upstream.

During memory hotplug testing, I got the following warning:

ERROR: Bad of_node_put() on /memory@0

of_node_release
kref_put
of_node_put
of_find_node_by_type
hot_add_node_scn_to_nid
hot_add_scn_to_nid
memory_add_physaddr_to_nid
...

of_find_node_by_type() loop does the of_node_put for us so we only
need the handle the case where we terminate the loop early.

As suggested by Stephen Rothwell we can do the of_node_put
unconditionally outside of the loop since of_node_put handles a
NULL argument fine.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/numa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1214,11 +1214,12 @@ int hot_add_node_scn_to_nid(unsigned lon
 			break;
 		}
 
-		of_node_put(memory);
 		if (nid >= 0)
 			break;
 	}
 
+	of_node_put(memory);
+
 	return nid;
 }
 


