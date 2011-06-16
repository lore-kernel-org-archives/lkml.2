Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1FPHGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:06:10 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49139 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756615Ab1FPHGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:06:02 -0400
X-Sasl-enc: 9VyL+R3ErT2By1LuZzH1lBL49q+bngp3cSx8DUX4Aa/d 1308207961
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:14 2011
Message-Id: <20110616001614.466669841@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [53/91] UBIFS: fix shrinker object count reports
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit cf610bf4199770420629d3bc273494bd27ad6c1d upstream.

Sometimes VM asks the shrinker to return amount of objects it can shrink,
and we return the ubifs_clean_zn_cnt in that case. However, it is possible
that this counter is negative for a short period of time, due to the way
UBIFS TNC code updates it. And I can observe the following warnings sometimes:

shrink_slab: ubifs_shrinker+0x0/0x2b7 [ubifs] negative objects to delete nr=-8541616642706119788

This patch makes sure UBIFS never returns negative count of objects.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/shrinker.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ubifs/shrinker.c
+++ b/fs/ubifs/shrinker.c
@@ -283,7 +283,11 @@ int ubifs_shrinker(int nr, gfp_t gfp_mas
 	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
 
 	if (nr == 0)
-		return clean_zn_cnt;
+		/*
+		 * Due to the way UBIFS updates the clean znode counter it may
+		 * temporarily be negative.
+		 */
+		return clean_zn_cnt >= 0 ? clean_zn_cnt : 1;
 
 	if (!clean_zn_cnt) {
 		/*


