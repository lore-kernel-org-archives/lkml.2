Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0LMBpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 20:45:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56501 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab0LMBpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 20:45:00 -0500
Message-ID: <4D057AB2.7010405@cn.fujitsu.com>
Date: Mon, 13 Dec 2010 09:45:22 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] blkio-cgroup: Document for blkio.use_hierarchy.
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D01C6AB.9040807@cn.fujitsu.com>
In-Reply-To: <4D01C6AB.9040807@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:44:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:45:00,
	Serialize complete at 2010-12-13 09:45:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document for blkio.use_hierarchy.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 Documentation/cgroups/blkio-controller.txt |   58 +++++++++++++++++++---------
 1 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 4ed7b5c..9c6dc9e 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -91,30 +91,44 @@ Throttling/Upper Limit policy
 
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
+  Consider the following CGroup hierarchy:
 
-			root
-			/  \
-		     test1 test2
-			|
-		     test3
+			  Root
+			/  |   \
+		     Grp1  Grp2 tsk1
+	            /  \
+		 Grp3 tsk2
 
-  CFQ and throttling will practically treat all groups at same level.
+  If flat mode is enabled, CFQ and throttling will practically treat all
+  groups at the same level.
 
-				pivot
-			     /  |   \  \
-			root  test1 test2  test3
+			     Pivot tree
+			    /  |   |   \
+			Root Grp1 Grp2 Grp3
+			 /     |
+			tsk1   tsk2
 
-  Down the line we can implement hierarchical accounting/control support
-  and also introduce a new cgroup file "use_hierarchy" which will control
-  whether cgroup hierarchy is viewed as flat or hierarchical by the policy..
-  This is how memory controller also has implemented the things.
+  If hierarchical mode is enabled, CFQ will treat groups and tasks as the same
+  view in CGroup hierarchy.
+
+			  Root
+		        /  |   \
+		    Grp1  Grp2 tsk1
+		    /  \
+		  Grp3 tsk2
+
+  Grp1, Grp2 and tsk1 are treated at the same level under Root group. Grp3 and
+  tsk2 are treated at the same level under Grp1. Below is the mapping between
+  task io priority and io weight:
+
+	    prio       0    1     2    3    4    5    6     7
+	    weight  1000  868   740  612  484  356  228   100
 
 Various user visible config options
 ===================================
@@ -169,6 +183,12 @@ Proportional weight policy files
 	  dev     weight
 	  8:16    300
 
+- blkio.use_hierarchy
+	- Switch between hierarchical mode and flat mode as stated above.
+	  blkio.use_hierarchy == 1 means hierarchical mode is enabled.
+	  blkio.use_hierarchy == 0 means flat mode is enabled.
+	  The default mode is flat mode.
+
 - blkio.time
 	- disk time allocated to cgroup per device in milliseconds. First
 	  two fields specify the major and minor number of the device and
-- 
1.6.5.2


