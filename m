Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0IUT6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:58:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:54916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338Ab0IUT6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:58:46 -0400
Date: Tue, 21 Sep 2010 19:58:29 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4C7B05A6.4010801@kernel.org>
References: <4C7B05A6.4010801@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, setup: Fix earlyprintk=serial,0x3f8,115200
Message-ID: <tip-74b3c444a963ba55aef89b33a1bcaada9a4c206f@git.kernel.org>
Git-Commit-ID: 74b3c444a963ba55aef89b33a1bcaada9a4c206f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Sep 2010 19:58:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74b3c444a963ba55aef89b33a1bcaada9a4c206f
Gitweb:     http://git.kernel.org/tip/74b3c444a963ba55aef89b33a1bcaada9a4c206f
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 29 Aug 2010 18:13:10 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Sep 2010 10:18:33 -0700

x86, setup: Fix earlyprintk=serial,0x3f8,115200

earlyprintk can take and I/O port, so we need to handle this case in
the setup code too, otherwise 0x3f8 will be treated as a baud rate.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4C7B05A6.4010801@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/early_serial_console.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 407a8e2..5df2869 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -58,7 +58,19 @@ static void parse_earlyprintk(void)
 		if (arg[pos] == ',')
 			pos++;
 
-		if (!strncmp(arg + pos, "ttyS", 4)) {
+		/*
+		 * make sure we have
+		 *	"serial,0x3f8,115200"
+		 *	"serial,ttyS0,115200"
+		 *	"ttyS0,115200"
+		 */
+		if (pos == 7 && !strncmp(arg + pos, "0x", 2)) {
+			port = simple_strtoull(arg + pos, &e, 16);
+			if (port == 0 || arg + pos == e)
+				port = DEFAULT_SERIAL_PORT;
+			else
+				pos = e - arg;
+		} else if (!strncmp(arg + pos, "ttyS", 4)) {
 			static const int bases[] = { 0x3f8, 0x2f8 };
 			int idx = 0;
 
