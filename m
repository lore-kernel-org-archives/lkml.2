Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1A1XVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 18:21:12 -0500
Received: from moat.camk.edu.pl ([148.81.175.50]:58518 "EHLO moat.camk.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab1A1XVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 18:21:11 -0500
Date: Sat, 29 Jan 2011 00:21:04 +0100
From: Kacper Kornet <kornet@camk.edu.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2] Fix prlimit64 for suid/sgid processes
Message-ID: <20110128232104.GA22667@camk.edu.pl>
References: <20110127134710.GB519@camk.edu.pl>
 <AANLkTimOM7KDtFkU=CmXZ8J2FqekY=EjCuOdtZHQJQWT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
In-Reply-To: <AANLkTimOM7KDtFkU=CmXZ8J2FqekY=EjCuOdtZHQJQWT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since check_prlimit_permission always fails in the case of SUID/GUID
processes, such processes are not able to read or set their own limits.
This commit changes this by assuming that process can always read/change
its own limits.

Signed-off-by: Kacper Kornet <kornet@camk.edu.pl>
---
 kernel/sys.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e9ad444..03bead7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1375,7 +1375,8 @@ static int check_prlimit_permission(struct task_struct *task)
 	const struct cred *cred = current_cred(), *tcred;
 
 	tcred = __task_cred(task);
-	if ((cred->uid != tcred->euid ||
+	if (current != task &&
+	    (cred->uid != tcred->euid ||
 	     cred->uid != tcred->suid ||
 	     cred->uid != tcred->uid  ||
 	     cred->gid != tcred->egid ||
-- 
1.7.3.5

-- 
  Kacper 
