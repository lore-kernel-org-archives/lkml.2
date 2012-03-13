Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab2CMAvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:51:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:48029 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833Ab2CMAXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 094/196] kconfig: Avoid buffer underrun in choice input
Date: Mon, 12 Mar 2012 20:20:07 -0400
Message-Id: <1331598109-31424-49-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3ba41621156681afcdbcd624e3191cbc65eb94f4 upstream.

Commit 40aee729b350 ('kconfig: fix default value for choice input')
fixed some cases where kconfig would select the wrong option from a
choice with a single valid option and thus enter an infinite loop.

However, this broke the test for user input of the form 'N?', because
when kconfig selects the single valid option the input is zero-length
and the test will read the byte before the input buffer.  If this
happens to contain '?' (as it will in a mips build on Debian unstable
today) then kconfig again enters an infinite loop.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 scripts/kconfig/conf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 9960d1c..7f97e3f 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -330,7 +330,7 @@ static int conf_choice(struct menu *menu)
 		}
 		if (!child)
 			continue;
-		if (line[strlen(line) - 1] == '?') {
+		if (line[0] && line[strlen(line) - 1] == '?') {
 			print_help(child);
 			continue;
 		}
-- 
1.7.9.3

