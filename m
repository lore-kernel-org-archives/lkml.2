Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2DHFXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:23:12 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:44007 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751985Ab2DHFMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:17 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Patrick McHardy <kaber@trash.net>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Howells <dhowells@redhat.com>
Date: Sat,  7 Apr 2012 22:14:59 -0700
Message-Id: <1333862139-31737-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/sPl700aznWNTze6U5CXWog8QOzAxD56A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0018]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 03/43] userns: Replace netlink uses of cap_raised with capable.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

In 2009 Philip Reiser notied that a few users of netlink connector
interface needed a capability check and added the idiom
cap_raised(nsp->eff_cap, CAP_SYS_ADMIN) to a few of them, on the premise
that netlink was asynchronous.

In 2011 Patrick McHardy noticed we were being silly because netlink is
synchronous and removed eff_cap from the netlink_skb_params and changed
the idiom to cap_raised(current_cap(), CAP_SYS_ADMIN).

Looking at those spots with a fresh eye we should be calling
capable(CAP_SYS_ADMIN).  The only reason I can see for not calling
capable is that it once appeared we were not in the same task as the
caller which would have made calling capable() impossible.

In the initial user_namespace the only difference between  between
cap_raised(current_cap(), CAP_SYS_ADMIN) and capable(CAP_SYS_ADMIN)
are a few sanity checks and the fact that capable(CAP_SYS_ADMIN)
sets PF_SUPERPRIV if we use the capability.

Since we are going to be using root privilege setting PF_SUPERPRIV
seems the right thing to do.

The motivation for this that patch is that in a child user namespace
cap_raised(current_cap(),...) tests your capabilities with respect to
that child user namespace not capabilities in the initial user namespace
and thus will allow processes that should be unprivielged to use the
kernel services that are only protected with
cap_raised(current_cap(),..).

To fix possible user_namespace issues and to just clean up the code
replace cap_raised(current_cap(), CAP_SYS_ADMIN) with
capable(CAP_SYS_ADMIN).

Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Reviewed-by: James Morris <james.l.morris@oracle.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/block/drbd/drbd_nl.c           |    2 +-
 drivers/md/dm-log-userspace-transfer.c |    2 +-
 drivers/video/uvesafb.c                |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index abfaaca..946166e 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2297,7 +2297,7 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
 		return;
 	}
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
+	if (!capable(CAP_SYS_ADMIN)) {
 		retcode = ERR_PERM;
 		goto fail;
 	}
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 1f23e04..08d9a20 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -134,7 +134,7 @@ static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN))
 		return;
 
 	spin_lock(&receiving_list_lock);
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 260cca7..9f7d27a 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -73,7 +73,7 @@ static void uvesafb_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *ns
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
 
-	if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN))
 		return;
 
 	if (msg->seq >= UVESAFB_TASKS_MAX)
-- 
1.7.2.5

