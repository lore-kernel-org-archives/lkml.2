Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab1CCRvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:51:04 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:63985 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1CCRvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:51:01 -0500
Subject: [PATCH] Make /proc/slabinfo 0400
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 12:50:52 -0500
Message-ID: <1299174652.2071.12.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing unprivileged users to read /proc/slabinfo represents a security
risk, since revealing details of slab allocations can expose information
that is useful when exploiting kernel heap corruption issues.  This is
evidenced by observing that nearly all recent public exploits for heap
issues rely on feedback from /proc/slabinfo to manipulate heap layout
into an exploitable state.

Changing the permissions on this file to 0400 by default will make heap
corruption issues more difficult to exploit.  Ordinary usage should not
require unprivileged users to debug the running kernel; if this ability
is required, an admin can always chmod the file appropriately.


Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
---
 mm/slab.c |    3 ++-
 mm/slub.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 37961d1..7f719f6 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4535,7 +4535,8 @@ static const struct file_operations proc_slabstats_operations = {
 
 static int __init slab_proc_init(void)
 {
-	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
+	proc_create("slabinfo", S_IWUSR|S_IRUSR, NULL,
+		    &proc_slabinfo_operations);
 #ifdef CONFIG_DEBUG_SLAB_LEAK
 	proc_create("slab_allocators", 0, NULL, &proc_slabstats_operations);
 #endif
diff --git a/mm/slub.c b/mm/slub.c
index e15aa7f..5f57834 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4691,7 +4691,7 @@ static const struct file_operations proc_slabinfo_operations = {
 
 static int __init slab_proc_init(void)
 {
-	proc_create("slabinfo", S_IRUGO, NULL, &proc_slabinfo_operations);
+	proc_create("slabinfo", S_IRUSR, NULL, &proc_slabinfo_operations);
 	return 0;
 }
 module_init(slab_proc_init);


