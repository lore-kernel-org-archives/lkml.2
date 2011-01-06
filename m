Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1AFApb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:45:31 -0500
Received: from kroah.org ([198.145.64.141]:35861 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab1AFAa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:28 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:05 2011
Message-Id: <20110106002305.126195006@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>
Subject: [088/152] inotify: stop kernel memory leak on file creation failure
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit a2ae4cc9a16e211c8a128ba10d22a85431f093ab upstream.

If inotify_init is unable to allocate a new file for the new inotify
group we leak the new group.  This patch drops the reference on the
group on file allocation failure.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/inotify/inotify_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -751,6 +751,7 @@ SYSCALL_DEFINE1(inotify_init1, int, flag
 	if (ret >= 0)
 		return ret;
 
+	fsnotify_put_group(group);
 	atomic_dec(&user->inotify_devs);
 out_free_uid:
 	free_uid(user);


