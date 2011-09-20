Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab1ITTYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:24:46 -0400
Received: from nm22.bullet.mail.sp2.yahoo.com ([98.139.91.92]:31383 "HELO
	nm22.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751154Ab1ITTYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:24:42 -0400
X-Yahoo-Newman-Id: 512527.63536.bm@omp1019.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uIlCorQVM1lmMQqi8M4QNLpYA0CTuEjPGdZD00tKHF8.qMi
 2HRX34royqeDaKVCDXgc1Iv1cM9bdcmP1bPqEy7Zmy5iQlazq7OnsGGwAcEe
 AtO3WDfc_RPmvh6KCNui4L1l.Lea4vbkarAGfHR_1geC1_Uughim4NaZHKyc
 YFgMGnQxZqiAH6YfaRV2H6hxPfrhlwRgfZrqVreukusuJM0XjMoNn6QHyW22
 fVfjtsBp81LyIGcqILCfbOoqMbQDFu26YChc_iTb3GXdt6c2ksyhUL48dVrs
 xgFUYlaDnWEYNLfvNMoIZj7MFPikI1I6x1kQRDzM8H4NMf.MZqrRuo9tcLbD
 e_3Aqnry6vvhrdt4.QY7ebO787cfZfYSmVZAExROE6jFx_8G8QXSJE1LDSpl
 Jp7aHM74VoujY6Z1H6lsrCiIUI1FAF7T5Fnxpv9p3hmCFVM.f4b5sPaabFw-
 -
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E78E874.9060003@schaufler-ca.com>
Date: Tue, 20 Sep 2011 12:24:36 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Andi Kleen <andi@firstfloor.org>
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: Rule list lookup performance
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is targeted for the smack-next tree.

Smack access checks suffer from two significant performance
issues. In cases where there are large numbers of rules the
search of the single list of rules is wasteful. Comparing the
string values of the smack labels is less efficient than a
numeric comparison would.

These changes take advantage of the Smack label list, which
maintains the mapping of Smack labels to secids and optional
CIPSO labels. Because the labels are kept perpetually, an
access check can be done strictly based on the address of the
label in the list without ever looking at the label itself.
Rather than keeping one global list of rules the rules with
a particular subject label can be based off of that label
list entry. The access check need never look at entries that
do not use the current subject label.

This requires that packets coming off the network with
CIPSO direct Smack labels that have never been seen before
be treated carefully. The only case where they could be
delivered is where the receiving socket has an IPIN star
label, so that case is explicitly addressed.

On a system with 39,800 rules (200 labels in all permutations)
a system with this patch runs an access speed test in 5% of
the time of the old version. That should be a best case
improvement. If all of the rules are associated with the
same subject label and all of the accesses are for processes
with that label (unlikely) the improvement is about 30%.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/smack/smack.h        |   18 ++++--
 security/smack/smack_access.c |  113 ++++++++++++++++++------------------
 security/smack/smack_lsm.c    |  126 +++++++++++++++++++++++++----------------
 security/smack/smackfs.c      |   84 ++++++++++++++++++++++++---
 4 files changed, 220 insertions(+), 121 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 2b6c6a5..174d3be 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -41,9 +41,9 @@ struct superblock_smack {
 };
 
 struct socket_smack {
-	char		*smk_out;			/* outbound label */
-	char		*smk_in;			/* inbound label */
-	char		smk_packet[SMK_LABELLEN];	/* TCP peer label */
+	char		*smk_out;	/* outbound label */
+	char		*smk_in;	/* inbound label */
+	char		*smk_packet;	/* TCP peer label */
 };
 
 /*
@@ -116,13 +116,19 @@ struct smk_netlbladdr {
  * If there is a cipso value associated with the label it
  * gets stored here, too. This will most likely be rare as
  * the cipso direct mapping in used internally.
+ *
+ * Keep the access rules for this subject label here so that
+ * the entire set of rules does not need to be examined every
+ * time.
  */
 struct smack_known {
 	struct list_head	list;
 	char			smk_known[SMK_LABELLEN];
 	u32			smk_secid;
 	struct smack_cipso	*smk_cipso;
-	spinlock_t		smk_cipsolock; /* for changing cipso map */
+	spinlock_t		smk_cipsolock;	/* for changing cipso map */
+	struct list_head	smk_rules;	/* access rules */
+	struct mutex		smk_rules_lock;	/* lock for the rules */
 };
 
 /*
@@ -201,10 +207,11 @@ int smk_access_entry(char *, char *, struct list_head *);
 int smk_access(char *, char *, int, struct smk_audit_info *);
 int smk_curacc(char *, u32, struct smk_audit_info *);
 int smack_to_cipso(const char *, struct smack_cipso *);
-void smack_from_cipso(u32, char *, char *);
+char *smack_from_cipso(u32, char *);
 char *smack_from_secid(const u32);
 char *smk_import(const char *, int);
 struct smack_known *smk_import_entry(const char *, int);
+struct smack_known *smk_find_entry(const char *);
 u32 smack_to_secid(const char *);
 
 /*
@@ -223,7 +230,6 @@ extern struct smack_known smack_known_star;
 extern struct smack_known smack_known_web;
 
 extern struct list_head smack_known_list;
-extern struct list_head smack_rule_list;
 extern struct list_head smk_netlbladdr_list;
 
 extern struct security_operations smack_ops;
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 9637e10..a885f62 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -77,14 +77,19 @@ int log_policy = SMACK_AUDIT_DENIED;
  * entry is found returns -ENOENT.
  *
  * NOTE:
- * Even though Smack labels are usually shared on smack_list
- * labels that come in off the network can't be imported
- * and added to the list for locking reasons.
  *
- * Therefore, it is necessary to check the contents of the labels,
- * not just the pointer values. Of course, in most cases the labels
- * will be on the list, so checking the pointers may be a worthwhile
- * optimization.
+ * Earlier versions of this function allowed for labels that
+ * were not on the label list. This was done to allow for
+ * labels to come over the network that had never been seen
+ * before on this host. Unless the receiving socket has the
+ * star label this will always result in a failure check. The
+ * star labeled socket case is now handled in the networking
+ * hooks so there is no case where the label is not on the
+ * label list. Checking to see if the address of two labels
+ * is the same is now a reliable test.
+ *
+ * Do the object check first because that is more
+ * likely to differ.
  */
 int smk_access_entry(char *subject_label, char *object_label,
 			struct list_head *rule_list)
@@ -93,13 +98,10 @@ int smk_access_entry(char *subject_label, char *object_label,
 	struct smack_rule *srp;
 
 	list_for_each_entry_rcu(srp, rule_list, list) {
-		if (srp->smk_subject == subject_label ||
-		    strcmp(srp->smk_subject, subject_label) == 0) {
-			if (srp->smk_object == object_label ||
-			    strcmp(srp->smk_object, object_label) == 0) {
-				may = srp->smk_access;
-				break;
-			}
+		if (srp->smk_object == object_label &&
+		    srp->smk_subject == subject_label) {
+			may = srp->smk_access;
+			break;
 		}
 	}
 
@@ -117,18 +119,12 @@ int smk_access_entry(char *subject_label, char *object_label,
  * access rule list and returns 0 if the access is permitted,
  * non zero otherwise.
  *
- * Even though Smack labels are usually shared on smack_list
- * labels that come in off the network can't be imported
- * and added to the list for locking reasons.
- *
- * Therefore, it is necessary to check the contents of the labels,
- * not just the pointer values. Of course, in most cases the labels
- * will be on the list, so checking the pointers may be a worthwhile
- * optimization.
+ * Smack labels are shared on smack_list
  */
 int smk_access(char *subject_label, char *object_label, int request,
 	       struct smk_audit_info *a)
 {
+	struct smack_known *skp;
 	int may = MAY_NOT;
 	int rc = 0;
 
@@ -137,8 +133,7 @@ int smk_access(char *subject_label, char *object_label, int request,
 	 *
 	 * A star subject can't access any object.
 	 */
-	if (subject_label == smack_known_star.smk_known ||
-	    strcmp(subject_label, smack_known_star.smk_known) == 0) {
+	if (subject_label == smack_known_star.smk_known) {
 		rc = -EACCES;
 		goto out_audit;
 	}
@@ -148,33 +143,27 @@ int smk_access(char *subject_label, char *object_label, int request,
 	 * An internet subject can access any object.
 	 */
 	if (object_label == smack_known_web.smk_known ||
-	    subject_label == smack_known_web.smk_known ||
-	    strcmp(object_label, smack_known_web.smk_known) == 0 ||
-	    strcmp(subject_label, smack_known_web.smk_known) == 0)
+	    subject_label == smack_known_web.smk_known)
 		goto out_audit;
 	/*
 	 * A star object can be accessed by any subject.
 	 */
-	if (object_label == smack_known_star.smk_known ||
-	    strcmp(object_label, smack_known_star.smk_known) == 0)
+	if (object_label == smack_known_star.smk_known)
 		goto out_audit;
 	/*
 	 * An object can be accessed in any way by a subject
 	 * with the same label.
 	 */
-	if (subject_label == object_label ||
-	    strcmp(subject_label, object_label) == 0)
+	if (subject_label == object_label)
 		goto out_audit;
 	/*
 	 * A hat subject can read any object.
 	 * A floor object can be read by any subject.
 	 */
 	if ((request & MAY_ANYREAD) == request) {
-		if (object_label == smack_known_floor.smk_known ||
-		    strcmp(object_label, smack_known_floor.smk_known) == 0)
+		if (object_label == smack_known_floor.smk_known)
 			goto out_audit;
-		if (subject_label == smack_known_hat.smk_known ||
-		    strcmp(subject_label, smack_known_hat.smk_known) == 0)
+		if (subject_label == smack_known_hat.smk_known)
 			goto out_audit;
 	}
 	/*
@@ -184,8 +173,9 @@ int smk_access(char *subject_label, char *object_label, int request,
 	 * good. A negative response from smk_access_entry()
 	 * indicates there is no entry for this pair.
 	 */
+	skp = smk_find_entry(subject_label);
 	rcu_read_lock();
-	may = smk_access_entry(subject_label, object_label, &smack_rule_list);
+	may = smk_access_entry(subject_label, object_label, &skp->smk_rules);
 	rcu_read_unlock();
 
 	if (may > 0 && (request & may) == request)
@@ -344,6 +334,25 @@ void smack_log(char *subject_label, char *object_label, int request,
 static DEFINE_MUTEX(smack_known_lock);
 
 /**
+ * smk_find_entry - find a label on the list, return the list entry
+ * @string: a text string that might be a Smack label
+ *
+ * Returns a pointer to the entry in the label list that
+ * matches the passed string.
+ */
+struct smack_known *smk_find_entry(const char *string)
+{
+	struct smack_known *skp;
+
+	list_for_each_entry_rcu(skp, &smack_known_list, list) {
+		if (strncmp(skp->smk_known, string, SMK_MAXLEN) == 0)
+			return skp;
+	}
+
+	return NULL;
+}
+
+/**
  * smk_import_entry - import a label, return the list entry
  * @string: a text string that might be a Smack label
  * @len: the maximum size, or zero if it is NULL terminated.
@@ -378,21 +387,17 @@ struct smack_known *smk_import_entry(const char *string, int len)
 
 	mutex_lock(&smack_known_lock);
 
-	found = 0;
-	list_for_each_entry_rcu(skp, &smack_known_list, list) {
-		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
-			found = 1;
-			break;
-		}
-	}
+	skp = smk_find_entry(smack);
 
-	if (found == 0) {
+	if (skp == NULL) {
 		skp = kzalloc(sizeof(struct smack_known), GFP_KERNEL);
 		if (skp != NULL) {
 			strncpy(skp->smk_known, smack, SMK_MAXLEN);
 			skp->smk_secid = smack_next_secid++;
 			skp->smk_cipso = NULL;
+			INIT_LIST_HEAD(&skp->smk_rules);
 			spin_lock_init(&skp->smk_cipsolock);
+			mutex_init(&skp->smk_rules_lock);
 			/*
 			 * Make sure that the entry is actually
 			 * filled before putting it on the list.
@@ -480,19 +485,12 @@ u32 smack_to_secid(const char *smack)
  * smack_from_cipso - find the Smack label associated with a CIPSO option
  * @level: Bell & LaPadula level from the network
  * @cp: Bell & LaPadula categories from the network
- * @result: where to put the Smack value
  *
  * This is a simple lookup in the label table.
  *
- * This is an odd duck as far as smack handling goes in that
- * it sends back a copy of the smack label rather than a pointer
- * to the master list. This is done because it is possible for
- * a foreign host to send a smack label that is new to this
- * machine and hence not on the list. That would not be an
- * issue except that adding an entry to the master list can't
- * be done at that point.
+ * Return the matching label from the label list or NULL.
  */
-void smack_from_cipso(u32 level, char *cp, char *result)
+char *smack_from_cipso(u32 level, char *cp)
 {
 	struct smack_known *kp;
 	char *final = NULL;
@@ -509,12 +507,13 @@ void smack_from_cipso(u32 level, char *cp, char *result)
 			final = kp->smk_known;
 
 		spin_unlock_bh(&kp->smk_cipsolock);
+
+		if (final != NULL)
+			break;
 	}
 	rcu_read_unlock();
-	if (final == NULL)
-		final = smack_known_huh.smk_known;
-	strncpy(result, final, SMK_MAXLEN);
-	return;
+
+	return final;
 }
 
 /**
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index b9c5e14..fb91516 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -516,6 +516,8 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 				     const struct qstr *qstr, char **name,
 				     void **value, size_t *len)
 {
+	struct smack_known *skp;
+	char *csp = smk_of_current();
 	char *isp = smk_of_inode(inode);
 	char *dsp = smk_of_inode(dir);
 	int may;
@@ -527,8 +529,9 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	}
 
 	if (value) {
+		skp = smk_find_entry(csp);
 		rcu_read_lock();
-		may = smk_access_entry(smk_of_current(), dsp, &smack_rule_list);
+		may = smk_access_entry(csp, dsp, &skp->smk_rules);
 		rcu_read_unlock();
 
 		/*
@@ -1138,6 +1141,7 @@ static int smack_file_mmap(struct file *file,
 			   unsigned long flags, unsigned long addr,
 			   unsigned long addr_only)
 {
+	struct smack_known *skp;
 	struct smack_rule *srp;
 	struct task_smack *tsp;
 	char *sp;
@@ -1170,6 +1174,7 @@ static int smack_file_mmap(struct file *file,
 
 	tsp = current_security();
 	sp = smk_of_current();
+	skp = smk_find_entry(sp);
 	rc = 0;
 
 	rcu_read_lock();
@@ -1177,15 +1182,8 @@ static int smack_file_mmap(struct file *file,
 	 * For each Smack rule associated with the subject
 	 * label verify that the SMACK64MMAP also has access
 	 * to that rule's object label.
-	 *
-	 * Because neither of the labels comes
-	 * from the networking code it is sufficient
-	 * to compare pointers.
 	 */
-	list_for_each_entry_rcu(srp, &smack_rule_list, list) {
-		if (srp->smk_subject != sp)
-			continue;
-
+	list_for_each_entry_rcu(srp, &skp->smk_rules, list) {
 		osmack = srp->smk_object;
 		/*
 		 * Matching labels always allows access.
@@ -1214,7 +1212,8 @@ static int smack_file_mmap(struct file *file,
 		 * If there isn't one a SMACK64MMAP subject
 		 * can't have as much access as current.
 		 */
-		mmay = smk_access_entry(msmack, osmack, &smack_rule_list);
+		skp = smk_find_entry(msmack);
+		mmay = smk_access_entry(msmack, osmack, &skp->smk_rules);
 		if (mmay == -ENOENT) {
 			rc = -EACCES;
 			break;
@@ -1711,7 +1710,7 @@ static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 
 	ssp->smk_in = csp;
 	ssp->smk_out = csp;
-	ssp->smk_packet[0] = '\0';
+	ssp->smk_packet = NULL;
 
 	sk->sk_security = ssp;
 
@@ -2813,16 +2812,17 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 	return smack_netlabel_send(sock->sk, sip);
 }
 
-
 /**
  * smack_from_secattr - Convert a netlabel attr.mls.lvl/attr.mls.cat pair to smack
  * @sap: netlabel secattr
- * @sip: where to put the result
+ * @ssp: socket security information
  *
- * Copies a smack label into sip
+ * Returns a pointer to a Smack label found on the label list.
  */
-static void smack_from_secattr(struct netlbl_lsm_secattr *sap, char *sip)
+static char *smack_from_secattr(struct netlbl_lsm_secattr *sap,
+				struct socket_smack *ssp)
 {
+	struct smack_known *skp;
 	char smack[SMK_LABELLEN];
 	char *sp;
 	int pcat;
@@ -2852,15 +2852,43 @@ static void smack_from_secattr(struct netlbl_lsm_secattr *sap, char *sip)
 		 * we are already done. WeeHee.
 		 */
 		if (sap->attr.mls.lvl == smack_cipso_direct) {
-			memcpy(sip, smack, SMK_MAXLEN);
-			return;
+			/*
+			 * The label sent is usually on the label list.
+			 *
+			 * If it is not we may still want to allow the
+			 * delivery.
+			 *
+			 * If the recipient is accepting all packets
+			 * because it is using the star ("*") label
+			 * for SMACK64IPIN provide the web ("@") label
+			 * so that a directed response will succeed.
+			 * This is not very correct from a MAC point
+			 * of view, but gets around the problem that
+			 * locking prevents adding the newly discovered
+			 * label to the list.
+			 * The case where the recipient is not using
+			 * the star label should obviously fail.
+			 * The easy way to do this is to provide the
+			 * star label as the subject label.
+			 */
+			skp = smk_find_entry(smack);
+			if (skp != NULL)
+				return skp->smk_known;
+			if (ssp != NULL &&
+			    ssp->smk_in == smack_known_star.smk_known)
+				return smack_known_web.smk_known;
+			return smack_known_star.smk_known;
 		}
 		/*
 		 * Look it up in the supplied table if it is not
 		 * a direct mapping.
 		 */
-		smack_from_cipso(sap->attr.mls.lvl, smack, sip);
-		return;
+		sp = smack_from_cipso(sap->attr.mls.lvl, smack);
+		if (sp != NULL)
+			return sp;
+		if (ssp != NULL && ssp->smk_in == smack_known_star.smk_known)
+			return smack_known_web.smk_known;
+		return smack_known_star.smk_known;
 	}
 	if ((sap->flags & NETLBL_SECATTR_SECID) != 0) {
 		/*
@@ -2875,16 +2903,14 @@ static void smack_from_secattr(struct netlbl_lsm_secattr *sap, char *sip)
 		 * secid is from a fallback.
 		 */
 		BUG_ON(sp == NULL);
-		strncpy(sip, sp, SMK_MAXLEN);
-		return;
+		return sp;
 	}
 	/*
 	 * Without guidance regarding the smack value
 	 * for the packet fall back on the network
 	 * ambient value.
 	 */
-	strncpy(sip, smack_net_ambient, SMK_MAXLEN);
-	return;
+	return smack_net_ambient;
 }
 
 /**
@@ -2898,7 +2924,6 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct netlbl_lsm_secattr secattr;
 	struct socket_smack *ssp = sk->sk_security;
-	char smack[SMK_LABELLEN];
 	char *csp;
 	int rc;
 	struct smk_audit_info ad;
@@ -2911,10 +2936,9 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	netlbl_secattr_init(&secattr);
 
 	rc = netlbl_skbuff_getattr(skb, sk->sk_family, &secattr);
-	if (rc == 0) {
-		smack_from_secattr(&secattr, smack);
-		csp = smack;
-	} else
+	if (rc == 0)
+		csp = smack_from_secattr(&secattr, ssp);
+	else
 		csp = smack_net_ambient;
 
 	netlbl_secattr_destroy(&secattr);
@@ -2951,15 +2975,19 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
 					  int __user *optlen, unsigned len)
 {
 	struct socket_smack *ssp;
-	int slen;
+	char *rcp = "";
+	int slen = 1;
 	int rc = 0;
 
 	ssp = sock->sk->sk_security;
-	slen = strlen(ssp->smk_packet) + 1;
+	if (ssp->smk_packet != NULL) {
+		rcp = ssp->smk_packet;
+		slen = strlen(rcp) + 1;
+	}
 
 	if (slen > len)
 		rc = -ERANGE;
-	else if (copy_to_user(optval, ssp->smk_packet, slen) != 0)
+	else if (copy_to_user(optval, rcp, slen) != 0)
 		rc = -EFAULT;
 
 	if (put_user(slen, optlen) != 0)
@@ -2982,8 +3010,8 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
 
 {
 	struct netlbl_lsm_secattr secattr;
-	struct socket_smack *sp;
-	char smack[SMK_LABELLEN];
+	struct socket_smack *ssp = NULL;
+	char *sp;
 	int family = PF_UNSPEC;
 	u32 s = 0;	/* 0 is the invalid secid */
 	int rc;
@@ -2998,17 +3026,19 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
 		family = sock->sk->sk_family;
 
 	if (family == PF_UNIX) {
-		sp = sock->sk->sk_security;
-		s = smack_to_secid(sp->smk_out);
+		ssp = sock->sk->sk_security;
+		s = smack_to_secid(ssp->smk_out);
 	} else if (family == PF_INET || family == PF_INET6) {
 		/*
 		 * Translate what netlabel gave us.
 		 */
+		if (sock != NULL && sock->sk != NULL)
+			ssp = sock->sk->sk_security;
 		netlbl_secattr_init(&secattr);
 		rc = netlbl_skbuff_getattr(skb, family, &secattr);
 		if (rc == 0) {
-			smack_from_secattr(&secattr, smack);
-			s = smack_to_secid(smack);
+			sp = smack_from_secattr(&secattr, ssp);
+			s = smack_to_secid(sp);
 		}
 		netlbl_secattr_destroy(&secattr);
 	}
@@ -3056,7 +3086,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	struct netlbl_lsm_secattr secattr;
 	struct sockaddr_in addr;
 	struct iphdr *hdr;
-	char smack[SMK_LABELLEN];
+	char *sp;
 	int rc;
 	struct smk_audit_info ad;
 
@@ -3067,9 +3097,9 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	netlbl_secattr_init(&secattr);
 	rc = netlbl_skbuff_getattr(skb, family, &secattr);
 	if (rc == 0)
-		smack_from_secattr(&secattr, smack);
+		sp = smack_from_secattr(&secattr, ssp);
 	else
-		strncpy(smack, smack_known_huh.smk_known, SMK_MAXLEN);
+		sp = smack_known_huh.smk_known;
 	netlbl_secattr_destroy(&secattr);
 
 #ifdef CONFIG_AUDIT
@@ -3082,7 +3112,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	 * Receiving a packet requires that the other end be able to write
 	 * here. Read access is not required.
 	 */
-	rc = smk_access(smack, ssp->smk_in, MAY_WRITE, &ad);
+	rc = smk_access(sp, ssp->smk_in, MAY_WRITE, &ad);
 	if (rc != 0)
 		return rc;
 
@@ -3090,7 +3120,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	 * Save the peer's label in the request_sock so we can later setup
 	 * smk_packet in the child socket so that SO_PEERCRED can report it.
 	 */
-	req->peer_secid = smack_to_secid(smack);
+	req->peer_secid = smack_to_secid(sp);
 
 	/*
 	 * We need to decide if we want to label the incoming connection here
@@ -3103,7 +3133,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	if (smack_host_label(&addr) == NULL) {
 		rcu_read_unlock();
 		netlbl_secattr_init(&secattr);
-		smack_to_secattr(smack, &secattr);
+		smack_to_secattr(sp, &secattr);
 		rc = netlbl_req_setattr(req, &secattr);
 		netlbl_secattr_destroy(&secattr);
 	} else {
@@ -3125,13 +3155,11 @@ static void smack_inet_csk_clone(struct sock *sk,
 				 const struct request_sock *req)
 {
 	struct socket_smack *ssp = sk->sk_security;
-	char *smack;
 
-	if (req->peer_secid != 0) {
-		smack = smack_from_secid(req->peer_secid);
-		strncpy(ssp->smk_packet, smack, SMK_MAXLEN);
-	} else
-		ssp->smk_packet[0] = '\0';
+	if (req->peer_secid != 0)
+		ssp->smk_packet = smack_from_secid(req->peer_secid);
+	else
+		ssp->smk_packet = NULL;
 }
 
 /*
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index f4c28ee..76e520b 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -86,6 +86,16 @@ char *smack_onlycap;
  */
 
 LIST_HEAD(smk_netlbladdr_list);
+
+/*
+ * Rule lists are maintained for each label.
+ * This master list is just for reading /smack/load.
+ */
+struct smack_master_list {
+	struct list_head	list;
+	struct smack_rule	*smk_rule;
+};
+
 LIST_HEAD(smack_rule_list);
 
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
@@ -93,7 +103,10 @@ static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 const char *smack_cipso_option = SMACK_CIPSO_OPTION;
 
 
+#define	SEQ_READ_FINISHED	((loff_t)-1)
+/*
 #define	SEQ_READ_FINISHED	1
+*/
 
 /*
  * Values for parsing cipso rules
@@ -160,9 +173,13 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
 
 	mutex_lock(rule_lock);
 
+	/*
+	 * Because the object label is less likely to match
+	 * than the subject label check it first
+	 */
 	list_for_each_entry_rcu(sp, rule_list, list) {
-		if (sp->smk_subject == srp->smk_subject &&
-		    sp->smk_object == srp->smk_object) {
+		if (sp->smk_object == srp->smk_object &&
+		    sp->smk_subject == srp->smk_subject) {
 			found = 1;
 			sp->smk_access = srp->smk_access;
 			break;
@@ -273,9 +290,12 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 				struct list_head *rule_list,
 				struct mutex *rule_lock)
 {
+	struct smack_master_list *smlp;
+	struct smack_known *skp;
 	struct smack_rule *rule;
 	char *data;
 	int rc = -EINVAL;
+	int load = 0;
 
 	/*
 	 * No partial writes.
@@ -313,13 +333,27 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 	if (smk_parse_rule(data, rule))
 		goto out_free_rule;
 
+	if (rule_list == NULL) {
+		load = 1;
+		skp = smk_find_entry(rule->smk_subject);
+		rule_list = &skp->smk_rules;
+		rule_lock = &skp->smk_rules_lock;
+	}
+
 	rc = count;
 	/*
 	 * smk_set_access returns true if there was already a rule
 	 * for the subject/object pair, and false if it was new.
 	 */
-	if (!smk_set_access(rule, rule_list, rule_lock))
+	if (!smk_set_access(rule, rule_list, rule_lock)) {
+		smlp = kzalloc(sizeof(*smlp), GFP_KERNEL);
+		if (smlp != NULL) {
+			smlp->smk_rule = rule;
+			list_add_rcu(&smlp->list, &smack_rule_list);
+		} else
+			rc = -ENOMEM;
 		goto out;
+	}
 
 out_free_rule:
 	kfree(rule);
@@ -335,11 +369,24 @@ out:
 
 static void *load_seq_start(struct seq_file *s, loff_t *pos)
 {
-	if (*pos == SEQ_READ_FINISHED)
+	struct list_head *list;
+
+	/*
+	 * This is 0 the first time through.
+	 */
+	if (s->index == 0)
+		s->private = &smack_rule_list;
+
+	if (s->private == NULL)
 		return NULL;
-	if (list_empty(&smack_rule_list))
+
+	list = s->private;
+	if (list_empty(list))
 		return NULL;
-	return smack_rule_list.next;
+
+	if (s->index == 0)
+		return list->next;
+	return list;
 }
 
 static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
@@ -347,17 +394,19 @@ static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
 	struct list_head *list = v;
 
 	if (list_is_last(list, &smack_rule_list)) {
-		*pos = SEQ_READ_FINISHED;
+		s->private = NULL;
 		return NULL;
 	}
+	s->private = list->next;
 	return list->next;
 }
 
 static int load_seq_show(struct seq_file *s, void *v)
 {
 	struct list_head *list = v;
-	struct smack_rule *srp =
-		 list_entry(list, struct smack_rule, list);
+	struct smack_master_list *smlp =
+		 list_entry(list, struct smack_master_list, list);
+	struct smack_rule *srp = smlp->smk_rule;
 
 	seq_printf(s, "%s %s", (char *)srp->smk_subject,
 		   (char *)srp->smk_object);
@@ -426,8 +475,11 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
+/*
 	return smk_write_load_list(file, buf, count, ppos, &smack_rule_list,
 					&smack_list_lock);
+*/
+	return smk_write_load_list(file, buf, count, ppos, NULL, NULL);
 }
 
 static const struct file_operations smk_load_ops = {
@@ -1588,6 +1640,20 @@ static int __init init_smk_fs(void)
 	smk_cipso_doi();
 	smk_unlbl_ambient(NULL);
 
+	mutex_init(&smack_known_floor.smk_rules_lock);
+	mutex_init(&smack_known_hat.smk_rules_lock);
+	mutex_init(&smack_known_huh.smk_rules_lock);
+	mutex_init(&smack_known_invalid.smk_rules_lock);
+	mutex_init(&smack_known_star.smk_rules_lock);
+	mutex_init(&smack_known_web.smk_rules_lock);
+
+	INIT_LIST_HEAD(&smack_known_floor.smk_rules);
+	INIT_LIST_HEAD(&smack_known_hat.smk_rules);
+	INIT_LIST_HEAD(&smack_known_huh.smk_rules);
+	INIT_LIST_HEAD(&smack_known_invalid.smk_rules);
+	INIT_LIST_HEAD(&smack_known_star.smk_rules);
+	INIT_LIST_HEAD(&smack_known_web.smk_rules);
+
 	return err;
 }
 

