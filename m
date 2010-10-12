Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab0JLPln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573Ab0JLPll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:41:41 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/5] security: secid_to_secctx returns len when data is NULL
To: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
Cc: eparis@redhat.com, paul.moore@hp.com, jmorris@namei.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jengelh@medozas.de,
        linux-security-module@vger.kernel.org, mr.dash.four@googlemail.com,
        pablo@netfilter.org
Date: Tue, 12 Oct 2010 11:40:22 -0400
Message-ID: <20101012154022.26943.82444.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the (long ago) interface change to have the secid_to_secctx functions
do the string allocation instead of having the caller do the allocation we
lost the ability to query the security server for the length of the
upcoming string.  The SECMARK code would like to allocate a netlink skb
with enough length to hold the string but it is just too unclean to do the
string allocation twice or to do the allocation the first time and hold
onto the string and slen.  This patch adds the ability to call
security_secid_to_secctx() with a NULL data pointer and it will just set
the slen pointer.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/selinux/ss/services.c |   11 +++++++++--
 security/smack/smack_lsm.c     |    3 ++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 73508af..1d4955a 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -998,7 +998,8 @@ static int context_struct_to_string(struct context *context, char **scontext, u3
 {
 	char *scontextp;
 
-	*scontext = NULL;
+	if (scontext)
+		*scontext = NULL;
 	*scontext_len = 0;
 
 	if (context->len) {
@@ -1015,6 +1016,9 @@ static int context_struct_to_string(struct context *context, char **scontext, u3
 	*scontext_len += strlen(sym_name(&policydb, SYM_TYPES, context->type - 1)) + 1;
 	*scontext_len += mls_compute_context_len(context);
 
+	if (!scontext)
+		return 0;
+
 	/* Allocate space for the context; caller must free this space. */
 	scontextp = kmalloc(*scontext_len, GFP_ATOMIC);
 	if (!scontextp)
@@ -1054,7 +1058,8 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
 	struct context *context;
 	int rc = 0;
 
-	*scontext = NULL;
+	if (scontext)
+		*scontext = NULL;
 	*scontext_len  = 0;
 
 	if (!ss_initialized) {
@@ -1062,6 +1067,8 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
 			char *scontextp;
 
 			*scontext_len = strlen(initial_sid_to_string[sid]) + 1;
+			if (!scontext)
+				goto out;
 			scontextp = kmalloc(*scontext_len, GFP_ATOMIC);
 			if (!scontextp) {
 				rc = -ENOMEM;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 174aec4..bc39f40 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3004,7 +3004,8 @@ static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
 	char *sp = smack_from_secid(secid);
 
-	*secdata = sp;
+	if (secdata)
+		*secdata = sp;
 	*seclen = strlen(sp);
 	return 0;
 }

