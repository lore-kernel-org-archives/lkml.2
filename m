Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0L1XE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 18:04:58 -0500
Received: from mailfilter10.ihug.co.nz ([203.109.136.10]:54278 "EHLO
	mailfilter10.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab0L1XE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 18:04:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAK/7GU12XLpw/2dsb2JhbACkMXS/AYVKBIsEh3w
X-IronPort-AV: E=Sophos;i="4.60,241,1291546800"; 
   d="scan'208";a="92631184"
Date: Wed, 29 Dec 2010 12:04:54 +1300
From: Ralph Loader <suckfish@ihug.co.nz>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Fix some incorrect use of positive error codes.
Message-Id: <20101229120454.1dbc9651.suckfish@ihug.co.nz>
In-Reply-To: <20101229120116.9eeb9261.suckfish@ihug.co.nz>
References: <20101226185718.aa60e0cd.suckfish@ihug.co.nz>
	<alpine.LNX.2.00.1012271227260.16569@pobox.suse.cz>
	<20101229120116.9eeb9261.suckfish@ihug.co.nz>
X-Mailer: Sylpheed 3.1.0beta5 (GTK+ 2.23.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Reposting after staging fixes separated out, as requested.]

A few functions were incorrectly returning positive error code values
where negative error code values were expected.

fs/cifs/cifsencrypt.c: Trivial.

net/caif/cfrfml.c: err is correctly initialised to -EPROTO and then
later incorrectly set to EPROTO.  So just delete the second
assignment.

arch/ppc/pseries/cmm.c: cmm_mem_going_offline() was returning a
positive error code to cmm_memory_cb() which then passed the value to
notifier_from_errno() which expects negative values.  Resolve the
inconsistency by returning the 'notifier' value from
cmm_mem_going_offline() in the first place.

These were found using coccinelle to grep for returning positive EFOO,
and then going through the 300 or so hits to find a dozen or so that
were obviously wrong.  XFS appears to intentionally use both positive
and negative error codes, I made no attempt to check that code for
consistency.

Signed-off-by: Ralph Loader <suckfish@ihug.co.nz>
---
 arch/powerpc/platforms/pseries/cmm.c |   18 +++++-------------
 fs/cifs/cifsencrypt.c                |    2 +-
 net/caif/cfrfml.c                    |    1 -
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index f480386..3542fdc 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -526,7 +526,7 @@ static struct notifier_block cmm_mem_isolate_nb = {
  * @arg: memory_notify structure with page range to be offlined
  *
  * Return value:
- *	0 on success
+ *	NOTIFY_OK on success
  **/
 static int cmm_mem_going_offline(void *arg)
 {
@@ -581,7 +581,7 @@ static int cmm_mem_going_offline(void *arg)
 				cmm_dbg("Failed to allocate memory for list "
 						"management. Memory hotplug "
 						"failed.\n");
-				return ENOMEM;
+				return notifier_from_errno(-ENOMEM);
 			}
 			memcpy(npa, pa_curr, PAGE_SIZE);
 			if (pa_curr == cmm_page_list)
@@ -600,7 +600,7 @@ static int cmm_mem_going_offline(void *arg)
 	spin_unlock(&cmm_lock);
 	cmm_dbg("Released %ld pages in the search range.\n", freed);
 
-	return 0;
+	return NOTIFY_OK;
 }
 
 /**
@@ -616,14 +616,11 @@ static int cmm_mem_going_offline(void *arg)
 static int cmm_memory_cb(struct notifier_block *self,
 			unsigned long action, void *arg)
 {
-	int ret = 0;
-
 	switch (action) {
 	case MEM_GOING_OFFLINE:
 		mutex_lock(&hotplug_mutex);
 		hotplug_occurred = 1;
-		ret = cmm_mem_going_offline(arg);
-		break;
+		return cmm_mem_going_offline(arg);
 	case MEM_OFFLINE:
 	case MEM_CANCEL_OFFLINE:
 		mutex_unlock(&hotplug_mutex);
@@ -635,12 +632,7 @@ static int cmm_memory_cb(struct notifier_block *self,
 		break;
 	}
 
-	if (ret)
-		ret = notifier_from_errno(ret);
-	else
-		ret = NOTIFY_OK;
-
-	return ret;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block cmm_mem_nb = {
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index f856732..76df22b 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -585,7 +585,7 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 
 	ses->auth_key.response = kmalloc(baselen + tilen, GFP_KERNEL);
 	if (!ses->auth_key.response) {
-		rc = ENOMEM;
+		rc = -ENOMEM;
 		ses->auth_key.len = 0;
 		cERROR(1, "%s: Can't allocate auth blob", __func__);
 		goto setup_ntlmv2_rsp_ret;
diff --git a/net/caif/cfrfml.c b/net/caif/cfrfml.c
index e2fb5fa..f5531c6 100644
--- a/net/caif/cfrfml.c
+++ b/net/caif/cfrfml.c
@@ -162,7 +162,6 @@ static int cfrfml_receive(struct cflayer *layr, struct cfpkt *pkt)
 		tmppkt = NULL;
 
 		/* Verify that length is correct */
-		err = EPROTO;
 		if (rfml->pdu_size != cfpkt_getlen(pkt) - RFM_HEAD_SIZE + 1)
 			goto out;
 	}
-- 
1.7.3.4

