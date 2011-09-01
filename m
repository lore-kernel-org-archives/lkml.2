Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1IATND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:13:03 -0400
Received: from ixia-3.edge2.lax012.pnap.net ([74.217.148.5]:41339 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757168Ab1IATNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:13:01 -0400
Message-ID: <4E5FD937.7050307@ixiacom.com>
Date: Thu, 1 Sep 2011 12:12:55 -0700
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "oleg@redhat.com" <oleg@redhat.com>
Subject: [PATCH 1/1 v2]: coredump: use current->group_leader->comm instead
 of current->comm
References: <4E5FBA73.2050108@ixiacom.com> <20110901195554.667c5e58@lxorguk.ukuu.org.uk>
In-Reply-To: <20110901195554.667c5e58@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In your view, but there is a better way to do this - add a new case and
> letter for the behaviour you want. That way you don't break anyone elses
> defaults and expectation and people can set a corepattern dependant upon
> the group leader.

Ok.


The patterns %n or %N are the same as %e and %E except that they 
use current->group_leader->comm instead of current->comm.


Signed-off-by: Earl Chew <echew@ixiacom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
--
--- fs/exec.c.orig	2011-08-28 21:16:01.000000000 -0700
+++ fs/exec.c	2011-09-01 12:03:50.622059092 -0700
@@ -1670,7 +1670,7 @@ static void cn_escape(char *str)
 			*str = '!';
 }
 
-static int cn_print_exe_file(struct core_name *cn)
+static int cn_print_exe_file(struct core_name *cn, const char *comm)
 {
 	struct file *exe_file;
 	char *pathbuf, *path;
@@ -1679,7 +1679,7 @@ static int cn_print_exe_file(struct core
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file) {
 		char *commstart = cn->corename + cn->used;
-		ret = cn_printf(cn, "%s (path unknown)", current->comm);
+		ret = cn_printf(cn, "%s (path unknown)", comm);
 		cn_escape(commstart);
 		return ret;
 	}
@@ -1777,6 +1777,18 @@ static int format_corename(struct core_n
 				cn_escape(namestart);
 				break;
 			}
+			/* task group executable */
+			case 'n': {
+				char *commstart = cn->corename + cn->used;
+				err = cn_printf(cn, "%s",
+					      current->group_leader->comm);
+				cn_escape(commstart);
+				break;
+			}
+			case 'N':
+				err = cn_print_exe_file(cn,
+					      current->group_leader->comm);
+				break;
 			/* executable */
 			case 'e': {
 				char *commstart = cn->corename + cn->used;
@@ -1785,7 +1797,7 @@ static int format_corename(struct core_n
 				break;
 			}
 			case 'E':
-				err = cn_print_exe_file(cn);
+				err = cn_print_exe_file(cn, current->comm);
 				break;
 			/* core limit size */
 			case 'c':


