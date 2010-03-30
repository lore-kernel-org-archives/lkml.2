Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0CaAWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:22:18 -0400
Received: from kroah.org ([198.145.64.141]:49123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab0C3XMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:45 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:45 2010
Message-Id: <20100330225845.117746432@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Eric Paris <eparis@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [59/89] inotify: fix coalesce duplicate events into a single event in special case
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wei Yongjun <yjwei@cn.fujitsu.com>

commit 3de0ef4f2067da58fa5126d821a56dcb98cdb565 upstream.

If we do rename a dir entry, like this:

  rename("/tmp/ino7UrgoJ.rename1", "/tmp/ino7UrgoJ.rename2")
  rename("/tmp/ino7UrgoJ.rename2", "/tmp/ino7UrgoJ")

The duplicate events should be coalesced into a single event. But those two
events do not be coalesced into a single event, due to some bad check in
event_compare(). It can not match the two NULL inodes as the same event.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/notification.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -143,7 +143,7 @@ static bool event_compare(struct fsnotif
 			/* remember, after old was put on the wait_q we aren't
 			 * allowed to look at the inode any more, only thing
 			 * left to check was if the file_name is the same */
-			if (old->name_len &&
+			if (!old->name_len ||
 			    !strcmp(old->file_name, new->file_name))
 				return true;
 			break;


