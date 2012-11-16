Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2KPUjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:39:11 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:54387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2KPUjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:39:09 -0500
Message-ID: <1353098379.9490.22.camel@jlt4.sipsolutions.net>
Subject: Re: removal of sysfs wext extension broke on F16
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, John Linville <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bill Nottingham <notting@redhat.com>, linux-wireless@vger.kernel.org
Date: Fri, 16 Nov 2012 21:39:39 +0100
In-Reply-To: <1353098204.9490.21.camel@jlt4.sipsolutions.net> (sfid-20121116_213631_514198_885B62C5)
References: <CAPM=9twSHBet=vDY9q4BXKv7ZUPR-eme75tOzxrWf6Bsp4MMkw@mail.gmail.com>
	 <1352795227.9466.8.camel@jlt4.sipsolutions.net>
	 <CA+55aFw8Rx6TScXV_nsh4EFeCDTxsjn9mJPqo8VzPhbG9jC5Fw@mail.gmail.com>
	 (sfid-20121116_192027_176167_6DFB40B3) <1353098137.9490.20.camel@jlt4.sipsolutions.net>
	 (sfid-20121116_213518_404111_CB0441EC) <1353098204.9490.21.camel@jlt4.sipsolutions.net>
	 (sfid-20121116_213631_514198_885B62C5)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 21:36 +0100, Johannes Berg wrote:
> On Fri, 2012-11-16 at 21:35 +0100, Johannes Berg wrote:
> > On Fri, 2012-11-16 at 10:20 -0800, Linus Torvalds wrote:
> > > On Tue, Nov 13, 2012 at 12:27 AM, Johannes Berg
> > > <johannes@sipsolutions.net> wrote:
> > > >
> > > > Should I revert it and send it in my next pull request?
> > > 
> > > Please do. Or perhaps we could just add the directory back, without
> > > the actual entries, if that is sufficient..
> > 
> > Yeah, that does seem to be sufficient, I'll queue up the patch below.
> 
> Err, no, wishful thinking. I need a *little* bit more for sysfs to work.

This works, sorry about that.

>From 38c1a01cf10c6e4049b4ffbd4a6af655df2a46e1 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Fri, 16 Nov 2012 20:46:19 +0100
Subject: [PATCH] wireless: add back sysfs directory

commit 35b2a113cb0298d4f9a1263338b456094a414057 broke (at least)
Fedora's networking scripts, they check for the existence of the
wireless directory. As the files aren't used, add the directory
back and not the files. Also do it for both drivers based on the
old wireless extensions and cfg80211, regardless of whether the
compat code for wext is built into cfg80211 or not.

Cc: stable@vger.kernel.org [3.6]
Reported-by: Dave Airlie <airlied@gmail.com>
Reported-by: Bill Nottingham <notting@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/core/net-sysfs.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index bcf02f6..017a8ba 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -429,6 +429,17 @@ static struct attribute_group netstat_group = {
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
@@ -1409,6 +1420,15 @@ int netdev_register_kobject(struct net_device *net)
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
-- 
1.8.0



