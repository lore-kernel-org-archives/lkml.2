Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031110Ab2CNVsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:48:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50470 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761437Ab2CNVsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:48:47 -0400
Date: Wed, 14 Mar 2012 14:43:36 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
Git-Commit-ID: 31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 14 Mar 2012 14:43:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4
Gitweb:     http://git.kernel.org/tip/31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 14 Mar 2012 14:27:52 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 14 Mar 2012 14:27:52 -0700

x32: Fix alignment fail in struct compat_siginfo

Adding struct _sigchld_x32 caused a misalignment cascade in struct
siginfo, because union _sifields is located on an 4-byte boundary
(8-byte misaligned.)

Adding new fields that are 8-byte aligned caused the intermediate
structures to also be aligned to 8 bytes, thereby adding padding in
unexpected places.

Thus, change s64 to compat_s64 here, which makes it "misaligned on
paper".  In reality these fields *are* actually aligned (there are 3
preceeding ints outside the union and 3 inside struct _sigchld_x32),
but because of the intervening union and struct it is not possible for
gcc to avoid padding without breaking the ABI.

Reported-and-tested-by: H. J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1329696488-16970-1-git-send-email-hpa@zytor.com
---
 arch/x86/include/asm/ia32.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ia32.h b/arch/x86/include/asm/ia32.h
index 7d0c185..ee52760 100644
--- a/arch/x86/include/asm/ia32.h
+++ b/arch/x86/include/asm/ia32.h
@@ -130,8 +130,8 @@ typedef struct compat_siginfo {
 			unsigned int _pid;	/* which child */
 			unsigned int _uid;	/* sender's uid */
 			int _status;		/* exit code */
-			s64 _utime;
-			s64 _stime;
+			compat_s64 _utime;
+			compat_s64 _stime;
 		} _sigchld_x32;
 
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
