Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab2JAXbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:31:06 -0400
Received: from 1wt.eu ([62.212.114.60]:35186 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664Ab2JAXAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:35 -0400
Message-Id: <20121001225159.604631641@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 047/180] fcaps: clear the same personality flags as suid when fcaps are used
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Paris <eparis@redhat.com>

commit d52fc5dde171f030170a6cb78034d166b13c9445 upstream

If a process increases permissions using fcaps all of the dangerous
personality flags which are cleared for suid apps should also be cleared.
Thus programs given priviledge with fcaps will continue to have address space
randomization enabled even if the parent tried to disable it to make it
easier to attack.

Signed-off-by: Eric Paris <eparis@redhat.com>
Reviewed-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 security/commoncap.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index fe30751..30972d6 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -511,6 +511,11 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 	}
 skip:
 
+	/* if we have fs caps, clear dangerous personality flags */
+	if (!cap_issubset(new->cap_permitted, old->cap_permitted))
+		bprm->per_clear |= PER_CLEAR_ON_SETID;
+
+
 	/* Don't let someone trace a set[ug]id/setpcap binary with the revised
 	 * credentials unless they have the appropriate permit
 	 */
-- 
1.7.2.1.45.g54fbc



