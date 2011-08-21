Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1HUDYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 23:24:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54810 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HUDYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 23:24:48 -0400
From: bookjovi@gmail.com
To: bookjovi@gmail.com
Cc: oleg@redhat.com, dhowells@redhat.com, nhorman@tuxdriver.com,
        roland@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] coredump: fix pipe coredump when core limit is 0
Date: Sun, 21 Aug 2011 07:25:04 -0400
Message-Id: <1313925904-5935-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

Regressing from 2.6.35

In pipe coredump case, normally core limits are irrelevant,
since we're not writing to the file system, but core limit 0
is a special value, kernel should skip the dump when limit is 0.

Note that most Linux distribution set default core file limit as 0,
because many user don't want to get core file even process crash,
wahtever pipe coredump pattern used or not.

This error intruduced by commit c71354 in 2.6.35, that commit put
core limit zero check into non-pipe code branch.

    commit c713541125002b8bc9e681af3b09118e771e2d8a
    Author: Oleg Nesterov <oleg@redhat.com>
    Date:   Wed May 26 14:43:05 2010 -0700

    coredump: factor out the not-ispipe file checks

For non-pipe case, limit 0 also means drop the coredump, so just put
the zero limit check at do_coredump function begining.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 fs/exec.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..c33085d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2119,6 +2119,10 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	if (!__get_dumpable(cprm.mm_flags))
 		goto fail;
 
+	/* Core limit as 0 should skip the dump */
+	if (cprm.limit == 0)
+		goto fail;
+
 	cred = prepare_creds();
 	if (!cred)
 		goto fail;
-- 
1.7.2.3

