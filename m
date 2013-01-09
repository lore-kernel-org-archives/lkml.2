Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab3AIUyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:54:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:43777 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933994Ab3AIUlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zdenek Kabelac <zkabelac@redhat.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 100/123] fs: Fix imbalance in freeze protection in mark_files_ro()
Date: Wed,  9 Jan 2013 12:35:39 -0800
Message-Id: <20130109201511.401004489@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 72651cac884b1e285fa8e8314b10e9f1b8458802 upstream.

File descriptors (even those for writing) do not hold freeze protection.
Thus mark_files_ro() must call __mnt_drop_write() to only drop protection
against remount read-only. Calling mnt_drop_write_file() as we do now
results in:

[ BUG: bad unlock balance detected! ]
3.7.0-rc6-00028-g88e75b6 #101 Not tainted
-------------------------------------
kworker/1:2/79 is trying to release lock (sb_writers) at:
[<ffffffff811b33b4>] mnt_drop_write+0x24/0x30
but there are no more locks to release!

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/file_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -458,8 +458,8 @@ void mark_files_ro(struct super_block *s
 		spin_unlock(&f->f_lock);
 		if (file_check_writeable(f) != 0)
 			continue;
+		__mnt_drop_write(f->f_path.mnt);
 		file_release_write(f);
-		mnt_drop_write_file(f);
 	} while_file_list_for_each_entry;
 	lg_global_unlock(&files_lglock);
 }


