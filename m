Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab2JKBYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:24:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48313 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933970Ab2JKBYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:24:37 -0400
X-Sasl-enc: ny4zgFUZN8WSLbSOyo/F/3fbyHJaxXsu6qA8ybVJhTfQ 1349918676
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        "Theodore Tso" <tytso@mit.edu>, Brad Figg <brad.figg@canonical.com>
Subject: [ 068/120] ext4: fix crash when accessing /proc/mounts concurrently
Date: Thu, 11 Oct 2012 10:00:20 +0900
Message-Id: <20121011005838.563369335@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit 50df9fd55e4271e89a7adf3b1172083dd0ca199d upstream.

The crash was caused by a variable being erronously declared static in
token2str().

In addition to /proc/mounts, the problem can also be easily replicated
by accessing /proc/fs/ext4/<partition>/options in parallel:

$ cat /proc/fs/ext4/<partition>/options > options.txt

... and then running the following command in two different terminals:

$ while diff /proc/fs/ext4/<partition>/options options.txt; do true; done

This is also the cause of the following a crash while running xfstests
#234, as reported in the following bug reports:

	https://bugs.launchpad.net/bugs/1053019
	https://bugzilla.kernel.org/show_bug.cgi?id=47731

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Brad Figg <brad.figg@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1692,7 +1692,7 @@ static inline void ext4_show_quota_optio
 
 static const char *token2str(int token)
 {
-	static const struct match_token *t;
+	const struct match_token *t;
 
 	for (t = tokens; t->token != Opt_err; t++)
 		if (t->token == token && !strchr(t->pattern, '='))


