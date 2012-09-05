Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab2IEKeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:34:36 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54380 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab2IEKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:34:35 -0400
Subject: [PATCH] [mcelog] Start using the new sysfs tunables location
To: ak@linux.intel.com, tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        ananth@in.ibm.com
Date: Wed, 05 Sep 2012 16:02:37 +0530
Message-ID: <20120905103237.9726.56131.stgit@localhost.localdomain>
In-Reply-To: <20120905102156.9423.27806.stgit@localhost.localdomain>
References: <20120905102156.9423.27806.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12090510-7014-0000-0000-000001D85760
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the current mce tunables are now available under
/sys/devices/system/machinecheck. Start using this new location, but fall back
to the older per-cpu location so that we continue working with older kernels.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 README      |    2 +-
 mcelog.init |    5 ++++-
 tests/test  |    7 ++++++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/README b/README
index 08184ed..0426460 100644
--- a/README
+++ b/README
@@ -18,7 +18,7 @@ significantly (upto 10 minutes) and does not allow mcelog to keep extended state
 
 trigger is a newer method where the kernel runs mcelog on a error.
 This is configured with 
-echo /usr/sbin/mcelog > /sys/devices/system/machinecheck/machinecheck0/trigger
+echo /usr/sbin/mcelog > /sys/devices/system/machinecheck/trigger
 This is faster, but still doesn't allow mcelog to keep state,
 and has relatively high overhead for each error because a program has
 to be initialized from scratch.
diff --git a/mcelog.init b/mcelog.init
index 0abe786..5f32ba7 100755
--- a/mcelog.init
+++ b/mcelog.init
@@ -31,7 +31,10 @@ MCELOG_OPTIONS=""
 
 # private settings
 MCELOG=${MCELOG:-/usr/sbin/mcelog}
-TRIGGER=/sys/devices/system/machinecheck/machinecheck0/trigger
+TRIGGER=/sys/devices/system/machinecheck/trigger
+if [ ! -e $TRIGGER ] ; then
+	TRIGGER=/sys/devices/system/machinecheck/machinecheck0/trigger
+fi
 [ ! -x $MCELOG ] && ( echo "mcelog not found" ; exit 1 )
 [ ! -r /dev/mcelog ] && ( echo "/dev/mcelog not active" ; exit 0 )
 
diff --git a/tests/test b/tests/test
index c673eb2..52daf01 100755
--- a/tests/test
+++ b/tests/test
@@ -17,10 +17,15 @@ if [ "$(whoami)" != "root" ] ; then
 	exit 1
 fi
 
+TRIGGER=/sys/devices/system/machinecheck/trigger
+if [ ! -e $TRIGGER ] ; then
+	TRIGGER=/sys/devices/system/machinecheck/machinecheck0/trigger
+fi
+
 echo "++++++++++++ running $1 test +++++++++++++++++++"
 
 # disable trigger
-echo -n "" > /sys/devices/system/machinecheck/machinecheck0/trigger
+echo -n "" > $TRIGGER
 killall mcelog || true
 
 #killwatchdog() { 

