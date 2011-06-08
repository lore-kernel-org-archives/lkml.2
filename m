Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1FHIXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:23:07 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:57385 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1FHIXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:23:05 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
Date: Wed,  8 Jun 2011 10:23:03 +0200
Message-Id: <1307521383-25939-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <BANLkTinwMyVsR-pvimeVkcqQrCuNDK4zKw@mail.gmail.com>
References: <BANLkTinwMyVsR-pvimeVkcqQrCuNDK4zKw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 4:00 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> That said, that commit (it's commit ID 4095b99c09e3d in tglx's tree)
> predates the "real" BK history too: it's part of the (limited) 2.4.x
> history that was imported from the release patches into BK at the
> beginning of the use of BK. So at that point we didn't do indivual
> commits, it's just the import of the v2.4.3.7 -> v2.4.3.8 patch.
>
> But yeah, it's old and crufty. And I agree that usually the correct
> fix is to remove the set_fs() calls entirely.

So here it is. Solves the problem for me.

Mathias

-- >8 --
Subject: [PATCH] exec: keep address limit on exec errors

Unconditionally changing the address limit to USER_DS and not restoring
it to its old value in the error path is wrong because it prevents us using
kernel memory on repeated calls to this function. This, in fact, breaks
the fallback of hard coded paths to the init program from being ever
successful if the first candidate fails to load.

With this patch applied it is possible to have a multi-arch rootfs
having one arch specific init binary for each of the (hard coded) probed
paths.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 fs/exec.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ea5f748..31df75f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1357,10 +1357,6 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	if (retval)
 		return retval;
 
-	/* kernel module loader fixup */
-	/* so we don't try to load run modprobe in kernel space. */
-	set_fs(USER_DS);
-
 	retval = audit_bprm(bprm);
 	if (retval)
 		return retval;
-- 
1.5.6.5

