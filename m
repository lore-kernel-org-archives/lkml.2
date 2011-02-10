Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1BJHsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 02:48:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58627 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1BJHsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 02:48:11 -0500
Message-ID: <4D53982F.3030009@cn.fujitsu.com>
Date: Thu, 10 Feb 2011 15:47:59 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: [PATCH 6/6 v4] blkio-cgroup: Document for blkio.use_hierarchy interface
References: <4D51ED26.8050809@cn.fujitsu.com>
In-Reply-To: <4D51ED26.8050809@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 15:47:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 15:47:08,
	Serialize complete at 2011-02-10 15:47:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document for blkio.use_hierarchy interface

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 Documentation/cgroups/blkio-controller.txt |   81 +++++++++++++++++++++-------
 1 files changed, 62 insertions(+), 19 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 4ed7b5c..24399f4 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -91,30 +91,62 @@ Throttling/Upper Limit policy
 
 Hierarchical Cgroups
 ====================
-- Currently none of the IO control policy supports hierarhical groups. But
-  cgroup interface does allow creation of hierarhical cgroups and internally
-  IO policies treat them as flat hierarchy.
+- Cgroup interface allows creation of hierarchical cgroups. Currently,
+  internally IO policies are able to treat them as flat hierarchy or
+  hierarchical hierarchy. Both hierarchical bandwidth division and flat
+  bandwidth division are supported. "blkio.use_hierarchy" can be used to
+  switch between flat mode and hierarchical mode.
 
-  So this patch will allow creation of cgroup hierarhcy but at the backend
-  everything will be treated as flat. So if somebody created a hierarchy like
-  as follows.
+  Note: Currently, "blkio.use_hierarchy" only effects proportional bandwidth
+  division. For Throttling logic, it still continues to treat everything as flat.
 
-			root
-			/  \
-		     test1 test2
-			|
-		     test3
+  Consider the following CGroup hierarchy:
 
-  CFQ and throttling will practically treat all groups at same level.
+			  Root
+			/  |   \
+		     Grp1  Grp2 tsk1
+	            /  \
+		 Grp3 tsk2
 
-				pivot
-			     /  |   \  \
-			root  test1 test2  test3
+  If blkio.use_hierarchy is disabled in all CGroups, CFQ will practically treat all groups
+  at the same level.
 
-  Down the line we can implement hierarchical accounting/control support
-  and also introduce a new cgroup file "use_hierarchy" which will control
-  whether cgroup hierarchy is viewed as flat or hierarchical by the policy..
-  This is how memory controller also has implemented the things.
+			     Pivot tree
+			    /  |   |   \
+			Root Grp1 Grp2 Grp3
+			 /     |
+			tsk1  tsk2
+
+  If blkio.use_hierarchy is enabled in Root group, then all children will inherit it, thus
+  all children group have use_hierarchy=1 set automatically and looks as follows.
+
+		       Pivot tree
+			   |
+			  Root
+			/  |   \
+		     Grp1  Grp2 tsk1
+	            /  \
+		 Grp3 tsk2
+
+  If blkio.use_hierarchy is enabled in Grp1 and Grp3, CFQ will treat groups and tasks as the
+  same view in CGroup hierarchy, it looks as follows.
+
+
+			     Pivot tree
+			    /    |    \
+			  Root  Grp1  Grp2
+			  /     /  \
+		       tsk1   Grp3 tsk2
+
+  Root, Grp1 and Grp2 are treated at the same level under Pivot tree. tsk1 stays under Root.
+  Grp3 and tsk2 are treated at the same level under Grp1. Below is the mapping between
+  task io priority and io weight:
+
+	    prio       0    1     2    3    4    5    6     7
+	    weight  1000  868   740  612  484  356  228   100
+
+  Note: Regardless of the use_hierarchy setting in Root group, Root group is always put onto
+  Pivot tree.
 
 Various user visible config options
 ===================================
@@ -169,6 +201,17 @@ Proportional weight policy files
 	  dev     weight
 	  8:16    300
 
+- blkio.use_hierarchy
+	- Switch between hierarchical mode and flat mode as stated above.
+	  blkio.use_hierarchy == 1 means hierarchical mode is enabled.
+	  blkio.use_hierarchy == 0 means flat mode is enabled.
+	  You can set this interface only if there isn't any child CGroup under
+	  this CGroup. If one CGroup's blkio.use_hierarchy is set, the created
+	  children will inherit it. it's not allowed to unset it in children.
+	  The default mode in Root CGroup is flat.
+	  blkio.use_hierarchy only works for proportional bandwidth division
+	  as of today and doesn't have any effect on throttling logic.
+
 - blkio.time
 	- disk time allocated to cgroup per device in milliseconds. First
 	  two fields specify the major and minor number of the device and
-- 
1.7.1




