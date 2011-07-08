Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1GHFTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:19:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab1GHFBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:54 2011
Message-Id: <20110708001654.632520870@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: [019/107] migrate: dont account swapcache as shmem
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit 99a15e21d96f6857dafab1e5167e5e8183215c9c upstream.

swapcache will reach the below code path in migrate_page_move_mapping,
and swapcache is accounted as NR_FILE_PAGES but it's not accounted as
NR_SHMEM.

Hugh pointed out we must use PageSwapCache instead of comparing
mapping to &swapper_space, to avoid build failure with CONFIG_SWAP=n.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -288,7 +288,7 @@ static int migrate_page_move_mapping(str
 	 */
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
-	if (PageSwapBacked(page)) {
+	if (!PageSwapCache(page) && PageSwapBacked(page)) {
 		__dec_zone_page_state(page, NR_SHMEM);
 		__inc_zone_page_state(newpage, NR_SHMEM);
 	}


