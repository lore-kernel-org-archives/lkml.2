Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2CWQme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:42:34 -0400
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:45045 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752294Ab2CWQmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:42:33 -0400
From: Roland Dreier <roland@kernel.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] setlocalversion: Use "grep -q" instead of piping output to "read dummy"
Date: Fri, 23 Mar 2012 09:42:27 -0700
Message-Id: <1332520947-22172-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

In some circumstances (eg when running a build in an emacs shell
buffer), I get a spew of messages like

    grep: writing output: Broken pipe

from setlocalversion, because the "read" subshell apparently exits as
soon as it reads one line and gives EPIPE to grep.  It's not clear to
me why this way of writing the check was used instead of just using
grep -q to suppress output, but unless there is some deep reason I
don't know, this way looks cleaner to me anyway, and gets rid of the
ugly message spew.

(I double checked at http://pubs.opengroup.org/onlinepubs/009604499/utilities/grep.html
and "grep -q" is specified in POSIX / SuS, so hopefully even people
cross-compiling the kernel on some bizarre host OS can't complain
about this change)

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 scripts/setlocalversion |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 4d40384..bd6dca8 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -75,8 +75,7 @@ scm_version()
 		[ -w . ] && git update-index --refresh --unmerged > /dev/null
 
 		# Check for uncommitted changes
-		if git diff-index --name-only HEAD | grep -v "^scripts/package" \
-		    | read dummy; then
+		if git diff-index --name-only HEAD | grep -qv "^scripts/package"; then
 			printf '%s' -dirty
 		fi
 
-- 
1.7.9.1

