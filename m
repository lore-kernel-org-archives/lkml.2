Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2ITCNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:13:06 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60601 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2ITCLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:35 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Sep 2012 18:52:28 -0700
Message-Id: <1348105949-25454-26-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1//Yn9Mn1fI/MIiVVoPI6VPD1xm4Y0jURQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1986]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 26/27] userns: Convert struct dquot_warn
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Convert w_dq_id to be a struct kquid and remove the now unncessary
w_dq_type.

This is a simple conversion and enough other places have already
been converted that this actually reduces the code complexity
by a little bit, when removing now unnecessary type conversions.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/quota/dquot.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index efaeed3..f3db845 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1132,8 +1132,7 @@ static void dquot_decr_space(struct dquot *dquot, qsize_t number)
 
 struct dquot_warn {
 	struct super_block *w_sb;
-	qid_t w_dq_id;
-	short w_dq_type;
+	struct kqid w_dq_id;
 	short w_type;
 };
 
@@ -1157,11 +1156,11 @@ static int need_print_warning(struct dquot_warn *warn)
 	if (!flag_print_warnings)
 		return 0;
 
-	switch (warn->w_dq_type) {
+	switch (warn->w_dq_id.type) {
 		case USRQUOTA:
-			return current_fsuid() == warn->w_dq_id;
+			return current_fsuid() == warn->w_dq_id.uid;
 		case GRPQUOTA:
-			return in_group_p(warn->w_dq_id);
+			return in_group_p(warn->w_dq_id.gid);
 	}
 	return 0;
 }
@@ -1187,7 +1186,7 @@ static void print_warning(struct dquot_warn *warn)
 		tty_write_message(tty, ": warning, ");
 	else
 		tty_write_message(tty, ": write failed, ");
-	tty_write_message(tty, quotatypes[warn->w_dq_type]);
+	tty_write_message(tty, quotatypes[warn->w_dq_id.type]);
 	switch (warntype) {
 		case QUOTA_NL_IHARDWARN:
 			msg = " file limit reached.\r\n";
@@ -1220,8 +1219,7 @@ static void prepare_warning(struct dquot_warn *warn, struct dquot *dquot,
 		return;
 	warn->w_type = warntype;
 	warn->w_sb = dquot->dq_sb;
-	warn->w_dq_id = from_kqid(&init_user_ns, dquot->dq_id);
-	warn->w_dq_type = dquot->dq_id.type;
+	warn->w_dq_id = dquot->dq_id;
 }
 
 /*
@@ -1239,7 +1237,7 @@ static void flush_warnings(struct dquot_warn *warn)
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 		print_warning(&warn[i]);
 #endif
-		quota_send_warning(make_kqid(&init_user_ns, warn[i].w_dq_type, warn[i].w_dq_id),
+		quota_send_warning(warn[i].w_dq_id,
 				   warn[i].w_sb->s_dev, warn[i].w_type);
 	}
 }
-- 
1.7.5.4

