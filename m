Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0LHA7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:20 -0500
Received: from kroah.org ([198.145.64.141]:48388 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808Ab0LHA7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:14 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:23 2010
Message-Id: <20101208005723.295279289@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Sameer Nanda <snanda@google.com>,
        Gabor Juhos <juhosg@openwrt.org>, Amod Bodas <amod.bodas@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [019/289] ath9k: fix regression which prevents chip sleep after CAB data
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit 3fac6dfdcd2b893c22b20a03dd1bf1af8b627c4b upstream.

The patch:

commit 293dc5dfdbcc16cde06e40a688394cc8ab083e48
Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Fri Jun 19 12:17:48 2009 +0200

    ath9k: remove ath_rx_ps_back_to_sleep helper

    This helper only clears the SC_OP_WAIT_FOR_{BEACON,CAB} flags.
    Remove it and clear these flags directly in the approptiate
    places instead.

    Changes-licensed-under: ISC
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

introduced a regression which forgot to lift the beacon flag
after we received all broadcast and multicast data. This meant
we never went to sleep consuming about ~650mW on idle. This pretty
much broke power save completely.

This patch has fixes for stable kernels [2.6.32+].

Cc: Paul Stewart <pstew@google.com>
Cc: Sameer Nanda <snanda@google.com>
Cc: Gabor Juhos <juhosg@openwrt.org>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -631,7 +631,7 @@ static void ath_rx_ps(struct ath_softc *
 		 * No more broadcast/multicast frames to be received at this
 		 * point.
 		 */
-		sc->ps_flags &= ~PS_WAIT_FOR_CAB;
+		sc->ps_flags &= ~(PS_WAIT_FOR_CAB | PS_WAIT_FOR_BEACON);
 		ath_print(common, ATH_DBG_PS,
 			  "All PS CAB frames received, back to sleep\n");
 	} else if ((sc->ps_flags & PS_WAIT_FOR_PSPOLL_DATA) &&


