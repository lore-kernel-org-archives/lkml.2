Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2ICTNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:13:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44205 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab2ICTNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:13:36 -0400
Date: Mon, 3 Sep 2012 21:13:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Remove bogus memcpy in brcm80211 ai_detach
Message-ID: <20120903191335.GW16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.8 warns for this memcpy. While the copy size is correct, the whole
copy seems to be a nop because the destination is never used, and
there's no need to use memcpy to copy pointers anyways. And the 
type of the pointer was wrong, but at least those are always the same.

Just remove it.

/backup/lsrc/git/linux-lto-2.6/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: In function 'ai_detach':
/backup/lsrc/git/linux-lto-2.6/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c:539:32: warning: argument to 'sizeof' in 'memcpy' call is the same pointer type 'struct si_pub **' as the destination; expected 'struct si_pub *' or an explicit length [-Wsizeof-pointer-memaccess]
  memcpy(&si_local, &sih, sizeof(struct si_pub **));
                                ^

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 8c9345d..b89f127 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -535,9 +535,6 @@ void ai_detach(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	struct si_pub *si_local = NULL;
-	memcpy(&si_local, &sih, sizeof(struct si_pub **));
-
 	sii = container_of(sih, struct si_info, pub);
 
 	if (sii == NULL)

-- 
ak@linux.intel.com -- Speaking for myself only.
