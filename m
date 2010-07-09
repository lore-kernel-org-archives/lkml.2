Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0GIDUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:20:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0GIDUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:20:10 -0400
Message-ID: <4C3694DC.8020403@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:17:48 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 06/11] blkiocg async: ext4_writepage not to overwrite
 iotrack info
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for ext4 to utilize iotrack.

ext4_writepage() calls block_commit_write() if the page doesn't
has buffer.  This overwrites original iotrack info who dirtied
the page.

To prevent this, this patch changes block_commit_write()
call into block_commit_write_noiotrack() call in ext4_writepage().

ToDo:
To check if there is fs which overwrites the info other than ext4.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 42272d6..45a2d51 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2737,7 +2737,7 @@ static int ext4_writepage(struct page *page,
 			return 0;
 		}
 		/* now mark the buffer_heads as dirty and uptodate */
-		block_commit_write(page, 0, len);
+		block_commit_write_noiotrack(page, 0, len);
 	}
 
 	if (PageChecked(page) && ext4_should_journal_data(inode)) {
-- 
1.6.2.5
