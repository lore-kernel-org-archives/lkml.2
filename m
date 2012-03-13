Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315Ab2CMA0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:26:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:49303 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965048Ab2CMA0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:26:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Julia Lawall <julia@diku.dk>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Robert Richter <robert.richter@amd.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 185/196] x86, mce, AMD: Fix leaving freed data in a list
Date: Mon, 12 Mar 2012 20:21:38 -0400
Message-Id: <1331598109-31424-140-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d9a5ac9ef306eb5cc874f285185a15c303c50009 upstream.

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
Link: http://lkml.kernel.org/r/1305294731-12127-1-git-send-email-julia@diku.dk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f80ff85..1bdce34 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -469,6 +469,7 @@ recurse:
 out_free:
 	if (b) {
 		kobject_put(&b->kobj);
+		list_del(&b->miscj);
 		kfree(b);
 	}
 	return err;
-- 
1.7.9.3

