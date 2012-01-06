Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2AFN2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 08:28:11 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:49806 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2AFN2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 08:28:09 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jan 2012 08:28:09 EST
Message-ID: <1325856086.17441.27.camel@osiris>
Subject: [PATCH] score: fix off-by-one index into syscall table
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: liqin.chen@sunplusct.com, lennox.wu@gmail.com
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Date: Fri, 06 Jan 2012 08:21:26 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the provided system call number is equal to __NR_syscalls, the
current check will pass and a function pointer just after the system
call table may be called, since sys_call_table is an array with total
size __NR_syscalls.  Whether or not this is a security bug depends on
what the compiler puts immediately after the system call table.  It's
likely that this won't do anything bad because there is an additional
NULL check on the syscall entry, but if there happens to be a non-NULL
value immediately after the system call table, this may result in local
privilege escalation.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: stable@kernel.org
Cc: security@kernel.org
---
 arch/score/kernel/entry.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/score/kernel/entry.S b/arch/score/kernel/entry.S
index 577abba..83bb960 100644
--- a/arch/score/kernel/entry.S
+++ b/arch/score/kernel/entry.S
@@ -408,7 +408,7 @@ ENTRY(handle_sys)
 	sw	r9, [r0, PT_EPC]
 
 	cmpi.c	r27, __NR_syscalls 	# check syscall number
-	bgtu	illegal_syscall
+	bgeu	illegal_syscall
 
 	slli	r8, r27, 2		# get syscall routine
 	la	r11, sys_call_table


