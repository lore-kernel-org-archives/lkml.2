Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab2AKSki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 13:40:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:47022 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111Ab2AKSkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 13:40:37 -0500
Date: Wed, 11 Jan 2012 13:40:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: Regulator updates for 3.3
Message-ID: <20120111184026.GA23952@windriver.com>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
 <20120110184530.GE7164@opensource.wolfsonmicro.com>
 <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
 <20120110222711.GK7164@opensource.wolfsonmicro.com>
 <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: Regulator updates for 3.3] On 10/01/2012 (Tue 14:54) Linus Torvalds wrote:

[...]

> So right now "git merge" (and "git pull") make it too easy to make
> those meaningless merge commits. If instead of seven pointless merges

It looks like the editor-by-default solution is a go, but there still
might be value in increasing the visibility of the pointless merges
via. the patch below.

Paul.

> you had (say) had two merges that had messages about *why* they
> weren't pointless, I'd be perfectly happy.
> 
> Addid junio and git to the cc just to bring up this issue of bad UI
> once again. I realize it could break old scripts to start up an editor
> window, but still..
> 
>                        Linus


>From 1a548fa97b78cebcded15d2b00ee3d826f731abd Mon Sep 17 00:00:00 2001
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 11 Jan 2012 10:33:45 -0500
Subject: [PATCH] merge: Make merge strategy message follow the diffstat

One of the common problems I've seen with people who are
somewhat new to git is that they don't realize that a pull
is a fetch+merge.  They simply decide they want all the
latest stuff and issue a git pull without really thinking
if they are on a branch with local commits or on master,
where a fast forward can take place.

But the one line message that tells you whether you got a fast
forward or a real merge commit is usually pushed off the
screen by all the diffstat information.  So these users won't
even know that their pull has created a merge, and chances
are they will never change their workflow.

By moving the message after the diffstat, there is a better
chance that people will be aware they've done a pointless
merge commit.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/builtin/merge.c b/builtin/merge.c
index 3a45172..9471588 100644
--- a/builtin/merge.c
+++ b/builtin/merge.c
@@ -370,12 +370,12 @@ static void finish(struct commit *head_commit,
 {
 	struct strbuf reflog_message = STRBUF_INIT;
 	const unsigned char *head = head_commit->object.sha1;
+	int automsg = 0;
 
-	if (!msg)
+	if (!msg) {
+		automsg = 1;
 		strbuf_addstr(&reflog_message, getenv("GIT_REFLOG_ACTION"));
-	else {
-		if (verbosity >= 0)
-			printf("%s\n", msg);
+	} else {
 		strbuf_addf(&reflog_message, "%s: %s",
 			getenv("GIT_REFLOG_ACTION"), msg);
 	}
@@ -409,6 +409,9 @@ static void finish(struct commit *head_commit,
 		diff_flush(&opts);
 	}
 
+	if (!automsg && verbosity >= 0)
+		printf("%s\n", msg);
+
 	/* Run a post-merge hook */
 	run_hook(NULL, "post-merge", squash ? "1" : "0", NULL);
 
-- 
1.7.4.4

