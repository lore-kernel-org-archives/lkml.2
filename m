Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2BXNQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:16:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab2BXNQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:16:10 -0500
Date: Fri, 24 Feb 2012 05:15:06 -0800
From: tip-bot for David Howells <dhowells@redhat.com>
Message-ID: <tip-189017c25c8497760c89646c06297c37d6cde072@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, arve@android.com, hpa@zytor.com,
        mingo@redhat.com, dhowells@redhat.com, ralf@linux-mips.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arve@android.com,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, ralf@linux-mips.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20120224105707.32170.11550.stgit@warthog.procyon.org.uk>
References: <20120224105707.32170.11550.stgit@warthog.procyon.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] fs: Remove missed ->
 fds_bits from cessation use of fd_set structs internally
Git-Commit-ID: 189017c25c8497760c89646c06297c37d6cde072
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 24 Feb 2012 05:15:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  189017c25c8497760c89646c06297c37d6cde072
Gitweb:     http://git.kernel.org/tip/189017c25c8497760c89646c06297c37d6cde072
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Fri, 24 Feb 2012 10:57:07 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 24 Feb 2012 14:04:50 +0100

fs: Remove missed ->fds_bits from cessation use of fd_set structs internally

Stephen Rothwell reported that the following commit broke the
linux-next build:

  1fd36adcd98c: Replace the fd_sets in struct fdtable with an array of unsigned longs

Fix places where ->fds_bits needed to be removed as the core
kernel no longer uses fd_set internally for file descriptor
table management.  There are two places:

 (1) drivers/staging/android/binder.c

 (2) arch/mips/kernel/kspd.c

     Question: Should sp_cleanup() in the MIPS arch be using find_next_bit()
     or fls()?

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ralf Bächle <ralf@linux-mips.org>
cc: Arve Hjønnevåg <arve@android.com>
Link: http://lkml.kernel.org/r/20120224105707.32170.11550.stgit@warthog.procyon.org.uk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/mips/kernel/kspd.c          |    2 +-
 drivers/staging/android/binder.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/kspd.c b/arch/mips/kernel/kspd.c
index 29811f0..84d0639 100644
--- a/arch/mips/kernel/kspd.c
+++ b/arch/mips/kernel/kspd.c
@@ -326,7 +326,7 @@ static void sp_cleanup(void)
 		i = j * __NFDBITS;
 		if (i >= fdt->max_fds)
 			break;
-		set = fdt->open_fds->fds_bits[j++];
+		set = fdt->open_fds[j++];
 		while (set) {
 			if (set & 1) {
 				struct file * file = xchg(&fdt->fd[i], NULL);
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 35dd9c3..9446f01 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -379,8 +379,7 @@ int task_get_unused_fd_flags(struct binder_proc *proc, int flags)
 
 repeat:
 	fdt = files_fdtable(files);
-	fd = find_next_zero_bit(fdt->open_fds->fds_bits, fdt->max_fds,
-				files->next_fd);
+	fd = find_next_zero_bit(fdt->open_fds, fdt->max_fds, files->next_fd);
 
 	/*
 	 * N.B. For clone tasks sharing a files structure, this test
