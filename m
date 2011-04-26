Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1DZFVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:21:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41858 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1DZFVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:21:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=w6A8a5PDC90hPXW6/aeorzn2S/RzCv05spznPDIqH5ZmtDweybJtkUKptLJy/R0xn3
         WlmqXjugHx2BPQHOMLs2ISbRYvh1uVXqnDaooKcyRcSVC0zH+emfiGCxJy8qVGkZNd7g
         3g7opFfNcXp5xptm3WdODfOBm3oWVdnH0jeFM=
Date: Tue, 26 Apr 2011 13:31:50 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH 2/2] use oom_killer_disabled in page fault oom path
Message-ID: <20110426053150.GA11949@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently oom_killer_disabled is only used in __alloc_pages_slowpath,
For page fault oom case it is not considered. One use case is
virtio balloon driver, when memory pressure is high, virtio ballooning
will cause oom killing due to such as page fault oom.

Thus add oom_killer_disabled checking in pagefault_out_of_memory.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 mm/oom_kill.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.orig/mm/oom_kill.c	2011-04-26 11:32:21.446452686 +0800
+++ linux-2.6/mm/oom_kill.c	2011-04-26 11:33:05.426452586 +0800
@@ -747,6 +747,9 @@ out:
  */
 void pagefault_out_of_memory(void)
 {
+	if (oom_killer_disabled)
+		return;
+
 	if (try_set_system_oom()) {
 		out_of_memory(NULL, 0, 0, NULL);
 		clear_system_oom();
