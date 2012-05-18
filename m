Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946848Ab2ERXIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:08:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946652Ab2ERXHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:07:43 -0400
Message-Id: <20120518212652.491290217@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sha Zhengju <handai.szj@taobao.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [ 36/47] memcg: free spare array to avoid memory leak
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sha Zhengju <handai.szj@taobao.com>

commit 8c7577637ca31385e92769a77e2ab5b428e8b99c upstream.

When the last event is unregistered, there is no need to keep the spare
array anymore.  So free it to avoid memory leak.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4480,6 +4480,12 @@ static void mem_cgroup_usage_unregister_
 swap_buffers:
 	/* Swap primary and spare array */
 	thresholds->spare = thresholds->primary;
+	/* If all events are unregistered, free the spare array */
+	if (!new) {
+		kfree(thresholds->spare);
+		thresholds->spare = NULL;
+	}
+
 	rcu_assign_pointer(thresholds->primary, new);
 
 	/* To be sure that nobody uses thresholds */


