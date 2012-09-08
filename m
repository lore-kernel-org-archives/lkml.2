Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2IHPEN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:04:13 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56373 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab2IHPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:04:07 -0400
Date: Sat, 8 Sep 2012 11:02:40 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu
To: linux-kernel@vger.kernel.org
cc: viro@zeniv.linux.org.uk, eparis@redhat.com
Subject: [PATCH] Seccomp audit: Reduce unnecessary log spew
Message-ID: <alpine.DEB.2.02.1209081042390.6765@ubuntu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time I run Chrome from dev channel, which uses seccomp, logs are 
flooded with below repetitive entries -

 2093.889522] audit_printk_skb: 42 callbacks suppressed
[ 2093.889527] type=1701 audit(1347114113.889:62): auid=4294967295 
uid=1000 gid=1000 ses=4294967295 pid=5329 comm="chrome" reason="seccomp" 
sig=0 syscall=2 compat=0 ip=0x7f1a63b45d90 code=0x50000

Reduce the seemingly needless repetitive logging by honoring audit_enabled 
and checking if the signal is worth auditing.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4b96415..6c3012a 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2715,6 +2715,9 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
 {
 	struct audit_buffer *ab;
 
+	if (!audit_enabled || !signr || signr == SIGQUIT)
+		return;
+
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
 	audit_log_abend(ab, "seccomp", signr);
 	audit_log_format(ab, " syscall=%ld", syscall);
