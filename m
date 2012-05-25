Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab2EYPaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:30:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41910 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2EYPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <1337934071-29342-1-git-send-email-qasimj@gmail.com>
References: <1337934071-29342-1-git-send-email-qasimj@gmail.com>
Date: Fri, 25 May 2012 23:30:36 +0800
Message-ID: <CAEFj985HxSrOwOoevDjG1jxPxobLda-X_LZUtj6LgwXZwozBog@mail.gmail.com>
Subject: Re: [RFC] mac80211: Use correct originator sequence number in a Path Reply
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: devel@lists.open80211s.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ravip@utdallas.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Qasim Javed

I think that you are referring to the target HWMP sequence number in
PREP element.

Based on the 802.11s standard, it has specified that
dot11MeshHWMPnetDiameterTraversalTime is only applied to original HWMP
sequence number for PREQ as mentioned in the "Contents of a PREQ
element" in section 11C.

For PREP element, it should be based on the description in section 11C.9.8.3:
"If it is a target mesh STA, it shall update its own HWMP sequence
number to maximum (current HWMP sequence number, target HWMP sequence
number in the PREQ) + 1 immediately before it generates a PREP in
response to a PREQ. The target HWMP sequence number of the PREQ is
relevant when a link was broken along the path and the stored sequence
number was increased at an intermediate mesh STA."

So the target HWMP sequence number should be modified as follow:

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 70ac7d1..5988e82 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -538,12 +538,10 @@ static void hwmp_preq_frame_process(struct
ieee80211_sub_if_data *sdata,
                forward = false;
                reply = true;
                metric = 0;
-               if (time_after(jiffies, ifmsh->last_sn_update +
-                                       net_traversal_jiffies(sdata)) ||
-                   time_before(jiffies, ifmsh->last_sn_update)) {
-                       target_sn = ++ifmsh->sn;
-                       ifmsh->last_sn_update = jiffies;
-               }
+               if (SN_LT(ifmsh->sn, target_sn))
+                       ifmsh->sn = target_sn;
+               target_sn = ++ifmsh->sn;
+               ifmsh->last_sn_update = jiffies;

Comments.

Regards,
Chun-Yeow
