Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab2BUWIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:08:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2BUWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:08:44 -0500
Date: Tue, 21 Feb 2012 14:08:01 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-a38449ef596b345e13a8f9b7d5cd9fedb8fcf921@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <CA+55aFxfAn9MWRgS3O5k2tqN5ys1XrhSFVO5_9ZAoZKDVgNfGA@mail.gmail.com>
References: <CA+55aFxfAn9MWRgS3O5k2tqN5ys1XrhSFVO5_9ZAoZKDVgNfGA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Specify a size for the cmp in the NMI handler
Git-Commit-ID: a38449ef596b345e13a8f9b7d5cd9fedb8fcf921
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Feb 2012 14:08:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a38449ef596b345e13a8f9b7d5cd9fedb8fcf921
Gitweb:     http://git.kernel.org/tip/a38449ef596b345e13a8f9b7d5cd9fedb8fcf921
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Mon, 20 Feb 2012 15:29:34 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 20 Feb 2012 19:45:26 -0500

x86: Specify a size for the cmp in the NMI handler

Linus noticed that the cmp used to check if the code segment is
__KERNEL_CS or not did not specify a size. Perhaps it does not matter
as H. Peter Anvin noted that user space can not set the bottom two
bits of the %cs register. But it's best not to let the assembly choose
and change things between different versions of gas, but instead just
pick the size.

Four bytes are used to compare the saved code segment against
__KERNEL_CS. Perhaps this might mess up Xen, but we can fix that when
the time comes.

Also I noticed that there was another non-specified cmp that checks
the special stack variable if it is 1 or 0. This too probably doesn't
matter what cmp is used, but this patch uses cmpl just to make it non
ambiguous.

Link: http://lkml.kernel.org/r/CA+55aFxfAn9MWRgS3O5k2tqN5ys1XrhSFVO5_9ZAoZKDVgNfGA@mail.gmail.com

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index debd851..1333d98 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1535,14 +1535,14 @@ ENTRY(nmi)
 	 * If %cs was not the kernel segment, then the NMI triggered in user
 	 * space, which means it is definitely not nested.
 	 */
-	cmp $__KERNEL_CS, 16(%rsp)
+	cmpl $__KERNEL_CS, 16(%rsp)
 	jne first_nmi
 
 	/*
 	 * Check the special variable on the stack to see if NMIs are
 	 * executing.
 	 */
-	cmp $1, -8(%rsp)
+	cmpl $1, -8(%rsp)
 	je nested_nmi
 
 	/*
