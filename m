Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993378Ab2K3TKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:10:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:59598 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993017Ab2K3TCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@gmail.com>, Bill Nottingham <notting@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 01/54] wireless: add back sysfs directory
Date: Fri, 30 Nov 2012 10:55:32 -0800
Message-Id: <20121130185208.038570845@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 38c1a01cf10c6e4049b4ffbd4a6af655df2a46e1 upstream.

commit 35b2a113cb0298d4f9a1263338b456094a414057 broke (at least)
Fedora's networking scripts, they check for the existence of the
wireless directory. As the files aren't used, add the directory
back and not the files. Also do it for both drivers based on the
old wireless extensions and cfg80211, regardless of whether the
compat code for wext is built into cfg80211 or not.

Reported-by: Dave Airlie <airlied@gmail.com>
Reported-by: Bill Nottingham <notting@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/net-sysfs.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -417,6 +417,17 @@ static struct attribute_group netstat_gr
 	.name  = "statistics",
 	.attrs  = netstat_attrs,
 };
+
+#if IS_ENABLED(CONFIG_WIRELESS_EXT) || IS_ENABLED(CONFIG_CFG80211)
+static struct attribute *wireless_attrs[] = {
+	NULL
+};
+
+static struct attribute_group wireless_group = {
+	.name = "wireless",
+	.attrs = wireless_attrs,
+};
+#endif
 #endif /* CONFIG_SYSFS */
 
 #ifdef CONFIG_RPS
@@ -1397,6 +1408,15 @@ int netdev_register_kobject(struct net_d
 		groups++;
 
 	*groups++ = &netstat_group;
+
+#if IS_ENABLED(CONFIG_WIRELESS_EXT) || IS_ENABLED(CONFIG_CFG80211)
+	if (net->ieee80211_ptr)
+		*groups++ = &wireless_group;
+#if IS_ENABLED(CONFIG_WIRELESS_EXT)
+	else if (net->wireless_handlers)
+		*groups++ = &wireless_group;
+#endif
+#endif
 #endif /* CONFIG_SYSFS */
 
 	error = device_add(dev);


