Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935610Ab1KJEsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:48:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935547Ab1KJDdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:33:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:24 2011
Message-Id: <20111109212724.527336663@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [238/262] mac80211: fix remain_off_channel regression
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit eaa7af2ae582c9a8c51b374c48d5970b748a5ce2 upstream.

The offchannel code is currently broken - we should
remain_off_channel if the work was started, and
the work's channel and channel_type are the same
as local->tmp_channel and local->tmp_channel_type.

However, if wk->chan_type and local->tmp_channel_type
coexist (e.g. have the same channel type), we won't
remain_off_channel.

This behavior was introduced by commit da2fd1f
("mac80211: Allow work items to use existing
channel type.")

Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/work.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1060,8 +1060,8 @@ static void ieee80211_work_work(struct w
 			continue;
 		if (wk->chan != local->tmp_channel)
 			continue;
-		if (ieee80211_work_ct_coexists(wk->chan_type,
-					       local->tmp_channel_type))
+		if (!ieee80211_work_ct_coexists(wk->chan_type,
+						local->tmp_channel_type))
 			continue;
 		remain_off_channel = true;
 	}


