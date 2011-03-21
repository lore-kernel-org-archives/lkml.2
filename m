Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1CUXsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:48:02 -0400
Received: from kroah.org ([198.145.64.141]:49386 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab1CUXPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:12 2011
Message-Id: <20110321230712.777322760@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        James Morris <jmorris@namei.org>
Subject: [35/87] TOMOYO: Fix memory leak upon file open.
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit eae61f3c829439f8f9121b5cd48a14be04df451f upstream.

In tomoyo_check_open_permission() since 2.6.36, TOMOYO was by error
recalculating already calculated pathname when checking allow_rewrite
permission. As a result, memory will leak whenever a file is opened for writing
without O_APPEND flag. Also, performance will degrade because TOMOYO is
calculating pathname regardless of profile configuration.
This patch fixes the leak and performance degrade.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/tomoyo/file.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/security/tomoyo/file.c
+++ b/security/tomoyo/file.c
@@ -927,7 +927,7 @@ int tomoyo_check_open_permission(struct
 				 struct path *path, const int flag)
 {
 	const u8 acc_mode = ACC_MODE(flag);
-	int error = -ENOMEM;
+	int error = 0;
 	struct tomoyo_path_info buf;
 	struct tomoyo_request_info r;
 	int idx;
@@ -938,9 +938,6 @@ int tomoyo_check_open_permission(struct
 	buf.name = NULL;
 	r.mode = TOMOYO_CONFIG_DISABLED;
 	idx = tomoyo_read_lock();
-	if (!tomoyo_get_realpath(&buf, path))
-		goto out;
-	error = 0;
 	/*
 	 * If the filename is specified by "deny_rewrite" keyword,
 	 * we need to check "allow_rewrite" permission when the filename is not


