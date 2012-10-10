Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab2JKARf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:17:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60770 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932986Ab2JKAR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:17:27 -0400
X-Sasl-enc: x1rAGOaefZC9zwAhhQAQTLFH9vwZgklDbz67mMVqT19Y 1349914644
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 130/133] JFFS2: fix unmount regression
Date: Thu, 11 Oct 2012 07:52:36 +0900
Message-Id: <20121010224917.951279038@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit a445f784ae5558a3da680aa6b39ed53c95a551c1 upstream.

This patch fixes regression introduced by
"8bdc81c jffs2: get rid of jffs2_sync_super". We submit a delayed work in order
to make sure the write-buffer is synchronized at some point. But we do not
flush it when we unmount, which causes an oops when we unmount the file-system
and then the delayed work is executed.

This patch fixes the issue by adding a "cancel_delayed_work_sync()" infocation
in the '->sync_fs()' handler. This will make sure the delayed work is canceled
on sync, unmount and re-mount. And because VFS always callse 'sync_fs()' before
unmounting or remounting, this fixes the issue.

Reported-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jffs2/super.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -100,6 +100,10 @@ static int jffs2_sync_fs(struct super_bl
 {
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 
+#ifdef CONFIG_JFFS2_FS_WRITEBUFFER
+	cancel_delayed_work_sync(&c->wbuf_dwork);
+#endif
+
 	mutex_lock(&c->alloc_sem);
 	jffs2_flush_wbuf_pad(c);
 	mutex_unlock(&c->alloc_sem);


