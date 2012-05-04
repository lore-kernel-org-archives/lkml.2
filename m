Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab2EDVPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:15:08 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2EDUpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:45:19 -0400
Message-Id: <20120504204226.709970381@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/75] nl80211: ensure interface is up in various APIs
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 2b5f8b0b44e17e625cfba1e7b88db44f4dcc0441 upstream.
[backported by Ben Greear]

The nl80211 handling code should ensure as much as
it can that the interface is in a valid state, it
can certainly ensure the interface is running.

Not doing so can cause calls through mac80211 into
the driver that result in warnings and unspecified
behaviour in the driver.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1293,6 +1293,11 @@ static int nl80211_set_wiphy(struct sk_b
 			goto bad_res;
 		}
 
+		if (!netif_running(netdev)) {
+			result = -ENETDOWN;
+			goto bad_res;
+		}
+
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {
@@ -6262,7 +6267,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_get_key,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6294,7 +6299,7 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.doit = nl80211_addset_beacon,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6302,7 +6307,7 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.doit = nl80211_addset_beacon,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6326,7 +6331,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_set_station,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6342,7 +6347,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_del_station,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6375,7 +6380,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_del_mpath,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6383,7 +6388,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_set_bss,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6409,7 +6414,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_get_mesh_config,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6542,7 +6547,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_setdel_pmksa,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6550,7 +6555,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_setdel_pmksa,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6558,7 +6563,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_flush_pmksa,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -6718,7 +6723,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_probe_client,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{


