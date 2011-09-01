Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1IARBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:01:43 -0400
Received: from ixia-3.edge2.lax012.pnap.net ([74.217.148.5]:51920 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753298Ab1IARBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:01:42 -0400
Message-ID: <4E5FBA73.2050108@ixiacom.com>
Date: Thu, 1 Sep 2011 10:01:39 -0700
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: <alan@lxorguk.ukuu.org.uk>, <viro@zeniv.linux.org.uk>,
        <andi@firstfloor.org>, <oleg@redhat.com>
Subject: [ PATCH 1/1 ] coredump: use current->group_leader->comm instead of
 current->comm
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change corepattern %e and %E to use current->group_leader->comm instead of current->comm.

Multithreaded processes can use PR_SET_NAME (or the corresponding pthread_setname_np)
to configure the name of each thread.

A core dump can be triggered from any task in a group, and substituting current->comm
means that the name of the core file for a process can vary in surprising ways.

Using current->group_leader->comm makes the name of the core file more consistent
for a process when used with %e or %E.

Signed-off-by: Earl Chew <echew@ixiacom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
--
--- fs/exec.c.orig	2011-08-28 21:16:01.000000000 -0700
+++ fs/exec.c	2011-09-01 09:58:42.032116998 -0700
@@ -1679,7 +1679,8 @@ static int cn_print_exe_file(struct core
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file) {
 		char *commstart = cn->corename + cn->used;
-		ret = cn_printf(cn, "%s (path unknown)", current->comm);
+		ret = cn_printf(cn, "%s (path unknown)",
+				current->group_leader->comm);
 		cn_escape(commstart);
 		return ret;
 	}
@@ -1780,7 +1781,8 @@ static int format_corename(struct core_n
 			/* executable */
 			case 'e': {
 				char *commstart = cn->corename + cn->used;
-				err = cn_printf(cn, "%s", current->comm);
+				err = cn_printf(cn, "%s",
+					      current->group_leader->comm);
 				cn_escape(commstart);
 				break;
 			}

