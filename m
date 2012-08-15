Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2HOTvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:36851 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab2HOTuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Milan Broz <mbroz@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 081/165] kobj_uevent: Ignore if some listeners cannot handle message
Date: Wed, 15 Aug 2012 15:47:05 -0400
Message-ID: <1345060109-9187-82-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ebf4127cd677e9781b450e44dfaaa1cc595efcaa upstream.

kobject_uevent() uses a multicast socket and should ignore
if one of listeners cannot handle messages or nobody is
listening at all.

Easily reproducible when a process in system is cloned
with CLONE_NEWNET flag.

(See also http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/5256)

Signed-off-by: Milan Broz <mbroz@redhat.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 lib/kobject_uevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 7b48d44..0273ead 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -236,7 +236,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			retval = netlink_broadcast(uevent_sock, skb, 0, 1,
 						   GFP_KERNEL);
 			/* ENOBUFS should be handled in userspace */
-			if (retval == -ENOBUFS)
+			if (retval == -ENOBUFS || retval == -ESRCH)
 				retval = 0;
 		} else
 			retval = -ENOMEM;
-- 
1.7.12.rc2

