Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1DSU2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:28:32 -0400
Received: from kroah.org ([198.145.64.141]:47651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab1DSURG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:45 2011
Message-Id: <20110419201045.486120877@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [22/70] net ipv6: Fix duplicate /proc/sys/net/ipv6/neigh directory entries.
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric W. Biederman <ebiederm@aristanetworks.com>

[ Upstream commit 9d2a8fa96a44ba242de3a6f56acaef7a40a97b97 ]

When I was fixing issues with unregisgtering tables under /proc/sys/net/ipv6/neigh
by adding a mount point it appears I missed a critical ordering issue, in the
ipv6 initialization.  I had not realized that ipv6_sysctl_register is called
at the very end of the ipv6 initialization and in particular after we call
neigh_sysctl_register from ndisc_init.

"neigh" needs to be initialized in ipv6_static_sysctl_register which is
the first ipv6 table to initialized, and definitely before ndisc_init.
This removes the weirdness of duplicate tables while still providing a
"neigh" mount point which prevents races in sysctl unregistering.

This was initially reported at https://bugzilla.kernel.org/show_bug.cgi?id=31232
Reported-by: sunkan@zappa.cx
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/sysctl_net_ipv6.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -17,6 +17,16 @@
 
 static struct ctl_table empty[1];
 
+static ctl_table ipv6_static_skeleton[] = {
+	{
+		.procname	= "neigh",
+		.maxlen		= 0,
+		.mode		= 0555,
+		.child		= empty,
+	},
+	{ }
+};
+
 static ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "route",
@@ -37,12 +47,6 @@ static ctl_table ipv6_table_template[] =
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
-	{
-		.procname	= "neigh",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= empty,
-	},
 	{ }
 };
 
@@ -160,7 +164,7 @@ static struct ctl_table_header *ip6_base
 
 int ipv6_static_sysctl_register(void)
 {
-	ip6_base = register_sysctl_paths(net_ipv6_ctl_path, empty);
+	ip6_base = register_sysctl_paths(net_ipv6_ctl_path, ipv6_static_skeleton);
 	if (ip6_base == NULL)
 		return -ENOMEM;
 	return 0;


