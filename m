Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2HMUdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:33:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53766 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab2HMUYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 13 Aug 2012 13:18:29 -0700
Message-Id: <1344889115-21610-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19u8aAoZzsoF372SS3cIZm5qs9m8FC7Lbs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 15/21] net sched: Pass the skb into change so it can access NETLINK_CB
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

cls_flow.c plays with uids and gids.  Unless I misread that
code it is possible for classifiers to depend on the specific uid and
gid values.  Therefore I need to know the user namespace of the
netlink socket that is installing the packet classifiers.  Pass
in the rtnetlink skb so I can access the NETLINK_CB of the passed
packet.  In particular I want access to sk_user_ns(NETLINK_CB(in_skb).ssk).

Pass in not the user namespace but the incomming rtnetlink skb into
the the classifier change routines as that is generally the more useful
parameter.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/net/sch_generic.h |    3 ++-
 net/sched/cls_api.c       |    2 +-
 net/sched/cls_basic.c     |    3 ++-
 net/sched/cls_cgroup.c    |    3 ++-
 net/sched/cls_flow.c      |    3 ++-
 net/sched/cls_fw.c        |    3 ++-
 net/sched/cls_route.c     |    3 ++-
 net/sched/cls_rsvp.h      |    3 ++-
 net/sched/cls_tcindex.c   |    3 ++-
 net/sched/cls_u32.c       |    3 ++-
 10 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d9611e0..4616f46 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -188,7 +188,8 @@ struct tcf_proto_ops {
 
 	unsigned long		(*get)(struct tcf_proto*, u32 handle);
 	void			(*put)(struct tcf_proto*, unsigned long);
-	int			(*change)(struct tcf_proto*, unsigned long,
+	int			(*change)(struct sk_buff *,
+					struct tcf_proto*, unsigned long,
 					u32 handle, struct nlattr **,
 					unsigned long *);
 	int			(*delete)(struct tcf_proto*, unsigned long);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 6dd1131..dc3ef5a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -319,7 +319,7 @@ replay:
 		}
 	}
 
-	err = tp->ops->change(tp, cl, t->tcm_handle, tca, &fh);
+	err = tp->ops->change(skb, tp, cl, t->tcm_handle, tca, &fh);
 	if (err == 0) {
 		if (tp_created) {
 			spin_lock_bh(root_lock);
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 590960a..344a11b 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -162,7 +162,8 @@ errout:
 	return err;
 }
 
-static int basic_change(struct tcf_proto *tp, unsigned long base, u32 handle,
+static int basic_change(struct sk_buff *in_skb,
+			struct tcf_proto *tp, unsigned long base, u32 handle,
 			struct nlattr **tca, unsigned long *arg)
 {
 	int err;
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 7743ea8..91de666 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -151,7 +151,8 @@ static const struct nla_policy cgroup_policy[TCA_CGROUP_MAX + 1] = {
 	[TCA_CGROUP_EMATCHES]	= { .type = NLA_NESTED },
 };
 
-static int cls_cgroup_change(struct tcf_proto *tp, unsigned long base,
+static int cls_cgroup_change(struct sk_buff *in_skb,
+			     struct tcf_proto *tp, unsigned long base,
 			     u32 handle, struct nlattr **tca,
 			     unsigned long *arg)
 {
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index ccd08c8..ae854f3 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -347,7 +347,8 @@ static const struct nla_policy flow_policy[TCA_FLOW_MAX + 1] = {
 	[TCA_FLOW_PERTURB]	= { .type = NLA_U32 },
 };
 
-static int flow_change(struct tcf_proto *tp, unsigned long base,
+static int flow_change(struct sk_buff *in_skb, 
+		       struct tcf_proto *tp, unsigned long base,
 		       u32 handle, struct nlattr **tca,
 		       unsigned long *arg)
 {
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index 8384a47..4075a0a 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -233,7 +233,8 @@ errout:
 	return err;
 }
 
-static int fw_change(struct tcf_proto *tp, unsigned long base,
+static int fw_change(struct sk_buff *in_skb,
+		     struct tcf_proto *tp, unsigned long base,
 		     u32 handle,
 		     struct nlattr **tca,
 		     unsigned long *arg)
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 44f405c..c10d57b 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -427,7 +427,8 @@ errout:
 	return err;
 }
 
-static int route4_change(struct tcf_proto *tp, unsigned long base,
+static int route4_change(struct sk_buff *in_skb,
+		       struct tcf_proto *tp, unsigned long base,
 		       u32 handle,
 		       struct nlattr **tca,
 		       unsigned long *arg)
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 18ab93e..494bbb9 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -416,7 +416,8 @@ static const struct nla_policy rsvp_policy[TCA_RSVP_MAX + 1] = {
 	[TCA_RSVP_PINFO]	= { .len = sizeof(struct tc_rsvp_pinfo) },
 };
 
-static int rsvp_change(struct tcf_proto *tp, unsigned long base,
+static int rsvp_change(struct sk_buff *in_skb,
+		       struct tcf_proto *tp, unsigned long base,
 		       u32 handle,
 		       struct nlattr **tca,
 		       unsigned long *arg)
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index fe29420..a1293b4 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -332,7 +332,8 @@ errout:
 }
 
 static int
-tcindex_change(struct tcf_proto *tp, unsigned long base, u32 handle,
+tcindex_change(struct sk_buff *in_skb,
+	       struct tcf_proto *tp, unsigned long base, u32 handle,
 	       struct nlattr **tca, unsigned long *arg)
 {
 	struct nlattr *opt = tca[TCA_OPTIONS];
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index d45373f..c7c27bc 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -544,7 +544,8 @@ errout:
 	return err;
 }
 
-static int u32_change(struct tcf_proto *tp, unsigned long base, u32 handle,
+static int u32_change(struct sk_buff *in_skb,
+		      struct tcf_proto *tp, unsigned long base, u32 handle,
 		      struct nlattr **tca,
 		      unsigned long *arg)
 {
-- 
1.7.5.4

