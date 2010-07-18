Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0GRI22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 04:28:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33793 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0GRI20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 04:28:26 -0400
Date: Sun, 18 Jul 2010 10:26:40 +0200
From: =?UTF-8?B?TWljaGHFgiBHw7Nybnk=?= <gentoo@mgorny.alt.pl>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] KERNEL BUILD: Make the setlocalversion script
 POSIX-compliant.
Message-ID: <20100718102640.01729af9@pomiocik.lan>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'source' builtin is a bash alias to the '.' (dot) builtin. While the
former is supported only by bash, the latter is specified in POSIX and
works fine with all POSIX-compliant shells I am aware of.

The '$_' special parameter is specific to bash. It is partially
supported in dash too but it always evaluates to the current script path
(which causes the script to enter a loop recursively re-executing
itself). This is why I have replaced the two occurences of '$_' with the
explicit parameter.

The 'local' builtin is another example of bash-specific code. Although
it is supported by all POSIX-compliant shells I am aware of, it is not
part of POSIX specification and thus the code should not rely on it
assigning a specific value to the local variable. Moreover, the 'posh'
shell has a limited version of 'local' builtin not supporting direct
variable assignments. Thus, I have broken one of the 'local'
declarations down into a (non-POSIX) 'local' declaration and a plain
(POSIX-compliant) variable assignment.

Signed-off-by: Michał Górny <gentoo@mgorny.alt.pl>
---

There is one 'bashism' left which I wasn't able to fix -- the use of
'test -ef'. I'm not aware of any POSIX equivalent of that.

 scripts/setlocalversion |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index d6a866e..a7b9f76 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -30,11 +30,12 @@ fi
 
 scm_version()
 {
-	local short=false
+	local short
+	short=false
 
 	cd "$srctree"
 	if test -e .scmversion; then
-		cat "$_"
+		cat .scmversion
 		return
 	fi
 	if test "$1" = "--short"; then
@@ -136,7 +137,7 @@ if $scm_only; then
 fi
 
 if test -e include/config/auto.conf; then
-	source "$_"
+	. include/config/auto.conf
 else
 	echo "Error: kernelrelease not valid - run 'make prepare' to update it"
 	exit 1
-- 
1.7.1.1

