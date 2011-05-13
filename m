Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1EMNwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:52:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38800 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069Ab1EMNwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:52:16 -0400
From: Julia Lawall <julia@diku.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel-janitors@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Robert Richter <robert.richter@amd.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] arch/x86/kernel/cpu/mcheck/mce_amd.c: Avoid leaving freed data in a list
Date: Fri, 13 May 2011 15:52:09 +0200
Message-Id: <1305294731-12127-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

b may be added to a list, but is not removed before being freed in the case
of an error.  This is done in the corresponding deallocation function, so
the code here has been changed to follow that.

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

---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    1 +
 1 file changed, 1 insertion(+)

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

