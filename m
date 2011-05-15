Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1EOMQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 08:16:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:46818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab1EOMQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 08:16:55 -0400
Date: Sun, 15 May 2011 12:16:13 GMT
From: tip-bot for Julia Lawall <julia@diku.dk>
Message-ID: <tip-d9a5ac9ef306eb5cc874f285185a15c303c50009@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, julia@diku.dk, hpa@zytor.com,
        mingo@redhat.com, yinghai@kernel.org, andreas.herrmann3@amd.com,
        robert.richter@amd.com, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        andreas.herrmann3@amd.com, robert.richter@amd.com, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
In-Reply-To: <1305294731-12127-1-git-send-email-julia@diku.dk>
References: <1305294731-12127-1-git-send-email-julia@diku.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mce, AMD: Fix leaving freed data in a list
Git-Commit-ID: d9a5ac9ef306eb5cc874f285185a15c303c50009
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 15 May 2011 12:16:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9a5ac9ef306eb5cc874f285185a15c303c50009
Gitweb:     http://git.kernel.org/tip/d9a5ac9ef306eb5cc874f285185a15c303c50009
Author:     Julia Lawall <julia@diku.dk>
AuthorDate: Fri, 13 May 2011 15:52:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 May 2011 17:11:02 +0200

x86, mce, AMD: Fix leaving freed data in a list

b may be added to a list, but is not removed before being freed
in the case of an error.  This is done in the corresponding
deallocation function, so the code here has been changed to
follow that.

The sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E,E1,E2;
identifier l;
@@

*list_add(&E->l,E1);
... when != E1
    when != list_del(&E->l)
    when != list_del_init(&E->l)
    when != E = E2
*kfree(E);// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1305294731-12127-1-git-send-email-julia@diku.dk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 167f97b..bb0adad 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -509,6 +509,7 @@ recurse:
 out_free:
 	if (b) {
 		kobject_put(&b->kobj);
+		list_del(&b->miscj);
 		kfree(b);
 	}
 	return err;
