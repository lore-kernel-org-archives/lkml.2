Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0CPW3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:29:39 -0400
Received: from mail.perches.com ([173.55.12.10]:1726 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0CPW3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:29:33 -0400
Subject: [PATCH] fs/cifs: Neaten cERROR and cFYI macros, reduce text space
 ~2.5K
From: Joe Perches <joe@perches.com>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 15:29:31 -0700
Message-ID: <1268778571.1652.8.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert '__FILE__ ": " fmt' to '"%s: " fmt', __FILE__' to save text space
Surround macros with do {} while
Add parentheses to macros
Make statement expression macro from macro with assign
Remove now unnecessary parentheses from cFYI and cERROR uses

defconfig with CIFS support old
$ size fs/cifs/built-in.o
   text	   data	    bss	    dec	    hex	filename
 156012	   1760	    148	 157920	  268e0	fs/cifs/built-in.o

defconfig with CIFS support old
$ size fs/cifs/built-in.o
   text	   data	    bss	    dec	    hex	filename
 153508	   1760	    148	 155416	  25f18	fs/cifs/built-in.o

allyesconfig old:
$ size fs/cifs/built-in.o
   text	   data	    bss	    dec	    hex	filename
 309138	   3864	  74824	 387826	  5eaf2	fs/cifs/built-in.o

allyesconfig new
$ size fs/cifs/built-in.o
   text	   data	    bss	    dec	    hex	filename
 305655	   3864	  74824	 384343	  5dd57	fs/cifs/built-in.o

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/asn1.c         |   73 ++++-----
 fs/cifs/cifs_debug.c   |   34 ++--
 fs/cifs/cifs_debug.h   |   42 ++++--
 fs/cifs/cifs_dfs_ref.c |   34 ++--
 fs/cifs/cifs_spnego.c  |    2 +-
 fs/cifs/cifs_unicode.c |    5 +-
 fs/cifs/cifsacl.c      |   76 +++++-----
 fs/cifs/cifsencrypt.c  |    8 +-
 fs/cifs/cifsfs.c       |   37 ++---
 fs/cifs/cifsproto.h    |   16 ++-
 fs/cifs/cifssmb.c      |  401 ++++++++++++++++++++++++------------------------
 fs/cifs/connect.c      |  254 +++++++++++++++----------------
 fs/cifs/dir.c          |   43 +++---
 fs/cifs/dns_resolve.c  |   16 +-
 fs/cifs/export.c       |    2 +-
 fs/cifs/file.c         |  174 ++++++++++-----------
 fs/cifs/inode.c        |   98 ++++++------
 fs/cifs/ioctl.c        |   10 +-
 fs/cifs/link.c         |   10 +-
 fs/cifs/misc.c         |   81 +++++-----
 fs/cifs/netmisc.c      |   16 +-
 fs/cifs/readdir.c      |   85 +++++-----
 fs/cifs/sess.c         |   58 ++++----
 fs/cifs/transport.c    |   91 ++++++------
 fs/cifs/xattr.c        |   40 +++---
 25 files changed, 858 insertions(+), 848 deletions(-)

diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index a20bea5..6d555c0 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -510,11 +510,11 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 
 	/* GSSAPI header */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, ("Error decoding negTokenInit header"));
+		cFYI(1, "Error decoding negTokenInit header");
 		return 0;
 	} else if ((cls != ASN1_APL) || (con != ASN1_CON)
 		   || (tag != ASN1_EOC)) {
-		cFYI(1, ("cls = %d con = %d tag = %d", cls, con, tag));
+		cFYI(1, "cls = %d con = %d tag = %d", cls, con, tag);
 		return 0;
 	}
 
@@ -535,56 +535,52 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 
 	/* SPNEGO OID not present or garbled -- bail out */
 	if (!rc) {
-		cFYI(1, ("Error decoding negTokenInit header"));
+		cFYI(1, "Error decoding negTokenInit header");
 		return 0;
 	}
 
 	/* SPNEGO */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, ("Error decoding negTokenInit"));
+		cFYI(1, "Error decoding negTokenInit");
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
 		   || (tag != ASN1_EOC)) {
-		cFYI(1,
-		     ("cls = %d con = %d tag = %d end = %p (%d) exit 0",
-		      cls, con, tag, end, *end));
+		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 0",
+		     cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* negTokenInit */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, ("Error decoding negTokenInit"));
+		cFYI(1, "Error decoding negTokenInit");
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
 		   || (tag != ASN1_SEQ)) {
-		cFYI(1,
-		     ("cls = %d con = %d tag = %d end = %p (%d) exit 1",
-		      cls, con, tag, end, *end));
+		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 1",
+		     cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* sequence */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, ("Error decoding 2nd part of negTokenInit"));
+		cFYI(1, "Error decoding 2nd part of negTokenInit");
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
 		   || (tag != ASN1_EOC)) {
-		cFYI(1,
-		     ("cls = %d con = %d tag = %d end = %p (%d) exit 0",
-		      cls, con, tag, end, *end));
+		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 0",
+		     cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* sequence of */
 	if (asn1_header_decode
 	    (&ctx, &sequence_end, &cls, &con, &tag) == 0) {
-		cFYI(1, ("Error decoding 2nd part of negTokenInit"));
+		cFYI(1, "Error decoding 2nd part of negTokenInit");
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
 		   || (tag != ASN1_SEQ)) {
-		cFYI(1,
-		     ("cls = %d con = %d tag = %d end = %p (%d) exit 1",
-		      cls, con, tag, end, *end));
+		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 1",
+		     cls, con, tag, end, *end);
 		return 0;
 	}
 
@@ -592,16 +588,15 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 	while (!asn1_eoc_decode(&ctx, sequence_end)) {
 		rc = asn1_header_decode(&ctx, &end, &cls, &con, &tag);
 		if (!rc) {
-			cFYI(1,
-			     ("Error decoding negTokenInit hdr exit2"));
+			cFYI(1, "Error decoding negTokenInit hdr exit2");
 			return 0;
 		}
 		if ((tag == ASN1_OJI) && (con == ASN1_PRI)) {
 			if (asn1_oid_decode(&ctx, end, &oid, &oidlen)) {
 
-				cFYI(1, ("OID len = %d oid = 0x%lx 0x%lx "
-					 "0x%lx 0x%lx", oidlen, *oid,
-					 *(oid + 1), *(oid + 2), *(oid + 3)));
+				cFYI(1, "OID len = %d oid = 0x%lx 0x%lx "
+					"0x%lx 0x%lx", oidlen, *oid,
+					*(oid + 1), *(oid + 2), *(oid + 3));
 
 				if (compare_oid(oid, oidlen, MSKRB5_OID,
 						MSKRB5_OID_LEN) &&
@@ -622,7 +617,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 				kfree(oid);
 			}
 		} else {
-			cFYI(1, ("Should be an oid what is going on?"));
+			cFYI(1, "Should be an oid what is going on?");
 		}
 	}
 
@@ -632,47 +627,47 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 		   no mechListMic (e.g. NTLMSSP instead of KRB5) */
 		if (ctx.error == ASN1_ERR_DEC_EMPTY)
 			goto decode_negtoken_exit;
-		cFYI(1, ("Error decoding last part negTokenInit exit3"));
+		cFYI(1, "Error decoding last part negTokenInit exit3");
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
 		/* tag = 3 indicating mechListMIC */
-		cFYI(1, ("Exit 4 cls = %d con = %d tag = %d end = %p (%d)",
-			 cls, con, tag, end, *end));
+		cFYI(1, "Exit 4 cls = %d con = %d tag = %d end = %p (%d)",
+			cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* sequence */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, ("Error decoding last part negTokenInit exit5"));
+		cFYI(1, "Error decoding last part negTokenInit exit5");
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
 		   || (tag != ASN1_SEQ)) {
-		cFYI(1, ("cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end));
+		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d)",
+			cls, con, tag, end, *end);
 	}
 
 	/* sequence of */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, ("Error decoding last part negTokenInit exit 7"));
+		cFYI(1, "Error decoding last part negTokenInit exit 7");
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
-		cFYI(1, ("Exit 8 cls = %d con = %d tag = %d end = %p (%d)",
-			 cls, con, tag, end, *end));
+		cFYI(1, "Exit 8 cls = %d con = %d tag = %d end = %p (%d)",
+			cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* general string */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, ("Error decoding last part negTokenInit exit9"));
+		cFYI(1, "Error decoding last part negTokenInit exit9");
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_PRI)
 		   || (tag != ASN1_GENSTR)) {
-		cFYI(1, ("Exit10 cls = %d con = %d tag = %d end = %p (%d)",
-			 cls, con, tag, end, *end));
+		cFYI(1, "Exit10 cls = %d con = %d tag = %d end = %p (%d)",
+			cls, con, tag, end, *end);
 		return 0;
 	}
-	cFYI(1, ("Need to call asn1_octets_decode() function for %s",
-		 ctx.pointer));	/* is this UTF-8 or ASCII? */
+	cFYI(1, "Need to call asn1_octets_decode() function for %s",
+		ctx.pointer);	/* is this UTF-8 or ASCII? */
 decode_negtoken_exit:
 	if (use_kerberos)
 		*secType = Kerberos;
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 42cec2a..5495180 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -60,10 +60,10 @@ cifs_dump_mem(char *label, void *data, int length)
 #ifdef CONFIG_CIFS_DEBUG2
 void cifs_dump_detail(struct smb_hdr *smb)
 {
-	cERROR(1, ("Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
+	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
 		  smb->Command, smb->Status.CifsError,
-		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid));
-	cERROR(1, ("smb buf %p len %d", smb, smbCalcSize_LE(smb)));
+		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
+	cERROR(1, "smb buf %p len %d", smb, smbCalcSize_LE(smb));
 }
 
 
@@ -75,25 +75,25 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 	if (server == NULL)
 		return;
 
-	cERROR(1, ("Dump pending requests:"));
+	cERROR(1, "Dump pending requests:");
 	spin_lock(&GlobalMid_Lock);
 	list_for_each(tmp, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-		cERROR(1, ("State: %d Cmd: %d Pid: %d Tsk: %p Mid %d",
+		cERROR(1, "State: %d Cmd: %d Pid: %d Tsk: %p Mid %d",
 			mid_entry->midState,
 			(int)mid_entry->command,
 			mid_entry->pid,
 			mid_entry->tsk,
-			mid_entry->mid));
+			mid_entry->mid);
 #ifdef CONFIG_CIFS_STATS2
-		cERROR(1, ("IsLarge: %d buf: %p time rcv: %ld now: %ld",
+		cERROR(1, "IsLarge: %d buf: %p time rcv: %ld now: %ld",
 			mid_entry->largeBuf,
 			mid_entry->resp_buf,
 			mid_entry->when_received,
-			jiffies));
+			jiffies);
 #endif /* STATS2 */
-		cERROR(1, ("IsMult: %d IsEnd: %d", mid_entry->multiRsp,
-			  mid_entry->multiEnd));
+		cERROR(1, "IsMult: %d IsEnd: %d", mid_entry->multiRsp,
+			  mid_entry->multiEnd);
 		if (mid_entry->resp_buf) {
 			cifs_dump_detail(mid_entry->resp_buf);
 			cifs_dump_mem("existing buf: ",
@@ -750,7 +750,7 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 			extended_security = CIFSSEC_MAX;
 			return count;
 		} else if (!isdigit(c)) {
-			cERROR(1, ("invalid flag %c", c));
+			cERROR(1, "invalid flag %c", c);
 			return -EINVAL;
 		}
 	}
@@ -758,16 +758,16 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 
 	flags = simple_strtoul(flags_string, NULL, 0);
 
-	cFYI(1, ("sec flags 0x%x", flags));
+	cFYI(1, "sec flags 0x%x", flags);
 
 	if (flags <= 0)  {
-		cERROR(1, ("invalid security flags %s", flags_string));
+		cERROR(1, "invalid security flags %s", flags_string);
 		return -EINVAL;
 	}
 
 	if (flags & ~CIFSSEC_MASK) {
-		cERROR(1, ("attempt to set unsupported security flags 0x%x",
-			flags & ~CIFSSEC_MASK));
+		cERROR(1, "attempt to set unsupported security flags 0x%x",
+			flags & ~CIFSSEC_MASK);
 		return -EINVAL;
 	}
 	/* flags look ok - update the global security flags for cifs module */
@@ -775,9 +775,9 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	if (extended_security & CIFSSEC_MUST_SIGN) {
 		/* requiring signing implies signing is allowed */
 		extended_security |= CIFSSEC_MAY_SIGN;
-		cFYI(1, ("packet signing now required"));
+		cFYI(1, "packet signing now required");
 	} else if ((extended_security & CIFSSEC_MAY_SIGN) == 0) {
-		cFYI(1, ("packet signing disabled"));
+		cFYI(1, "packet signing disabled");
 	}
 	/* BB should we turn on MAY flags for other MUST options? */
 	return count;
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 5eb3b83..aa31689 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -43,34 +43,54 @@ void dump_smb(struct smb_hdr *, int);
  */
 #ifdef CIFS_DEBUG
 
-
 /* information message: e.g., configuration, major event */
 extern int cifsFYI;
-#define cifsfyi(format,arg...) if (cifsFYI & CIFS_INFO) printk(KERN_DEBUG " " __FILE__ ": " format "\n" "" , ## arg)
+#define cifsfyi(fmt, arg...)						\
+do {									\
+	if (cifsFYI & CIFS_INFO)					\
+		printk(KERN_DEBUG "%s: " fmt "\n", __FILE__, ##arg);	\
+} while (0)
 
-#define cFYI(button,prspec) if (button) cifsfyi prspec
+#define cFYI(set, fmt, arg...)			\
+do {						\
+	if (set)				\
+		cifsfyi(fmt, ##arg);		\
+} while (0)
 
-#define cifswarn(format, arg...) printk(KERN_WARNING ": " format "\n" , ## arg)
+#define cifswarn(fmt, arg...)			\
+	printk(KERN_WARNING fmt "\n", ##arg)
 
 /* debug event message: */
 extern int cifsERROR;
 
-#define cEVENT(format,arg...) if (cifsERROR) printk(KERN_EVENT __FILE__ ": " format "\n" , ## arg)
+#define cEVENT(fmt, arg...)						\
+do {									\
+	if (cifsERROR)							\
+		printk(KERN_EVENT "%s: " fmt "\n", __FILE__, ##arg);	\
+} while (0)
 
 /* error event message: e.g., i/o error */
-#define cifserror(format,arg...) if (cifsERROR) printk(KERN_ERR " CIFS VFS: " format "\n" "" , ## arg)
+#define cifserror(fmt, arg...)					\
+do {								\
+	if (cifsERROR)						\
+		printk(KERN_ERR "CIFS VFS: " fmt "\n", ##arg);	\
+} while (0)
 
-#define cERROR(button, prspec) if (button) cifserror prspec
+#define cERROR(set, fmt, arg...)		\
+do {						\
+	if (set)				\
+		cifserror(fmt, ##arg);		\
+} while (0)
 
 /*
  *	debug OFF
  *	---------
  */
 #else		/* _CIFS_DEBUG */
-#define cERROR(button, prspec)
-#define cEVENT(format, arg...)
-#define cFYI(button, prspec)
-#define cifserror(format, arg...)
+#define cERROR(set, fmt, arg...)
+#define cEVENT(fmt, arg...)
+#define cFYI(set, fmt, arg...)
+#define cifserror(fmt, arg...)
 #endif		/* _CIFS_DEBUG */
 
 #endif				/* _H_CIFS_DEBUG */
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index b1d61d0..ff5a4cb 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -84,8 +84,8 @@ static char *cifs_get_share_name(const char *node_name)
 	/* find server name end */
 	pSep = memchr(UNC+2, '\\', len-2);
 	if (!pSep) {
-		cERROR(1, ("%s: no server name end in node name: %s",
-			__func__, node_name));
+		cERROR(1, "%s: no server name end in node name: %s",
+			__func__, node_name);
 		kfree(UNC);
 		return ERR_PTR(-EINVAL);
 	}
@@ -141,8 +141,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc != 0) {
-		cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
-			  __func__, *devname, rc));
+		cERROR(1, "%s: Failed to resolve server part of %s to IP: %d",
+			  __func__, *devname, rc);
 		goto compose_mount_options_err;
 	}
 	/* md_len = strlen(...) + 12 for 'sep+prefixpath='
@@ -216,8 +216,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		strcat(mountdata, fullpath + ref->path_consumed);
 	}
 
-	/*cFYI(1,("%s: parent mountdata: %s", __func__,sb_mountdata));*/
-	/*cFYI(1, ("%s: submount mountdata: %s", __func__, mountdata ));*/
+	/*cFYI(1, "%s: parent mountdata: %s", __func__,sb_mountdata);*/
+	/*cFYI(1, "%s: submount mountdata: %s", __func__, mountdata );*/
 
 compose_mount_options_out:
 	kfree(srvIP);
@@ -293,11 +293,11 @@ static int add_mount_helper(struct vfsmount *newmnt, struct nameidata *nd,
 
 static void dump_referral(const struct dfs_info3_param *ref)
 {
-	cFYI(1, ("DFS: ref path: %s", ref->path_name));
-	cFYI(1, ("DFS: node path: %s", ref->node_name));
-	cFYI(1, ("DFS: fl: %hd, srv_type: %hd", ref->flags, ref->server_type));
-	cFYI(1, ("DFS: ref_flags: %hd, path_consumed: %hd", ref->ref_flag,
-				ref->path_consumed));
+	cFYI(1, "DFS: ref path: %s", ref->path_name);
+	cFYI(1, "DFS: node path: %s", ref->node_name);
+	cFYI(1, "DFS: fl: %hd, srv_type: %hd", ref->flags, ref->server_type);
+	cFYI(1, "DFS: ref_flags: %hd, path_consumed: %hd", ref->ref_flag,
+				ref->path_consumed);
 }
 
 
@@ -313,7 +313,7 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 	int rc = 0;
 	struct vfsmount *mnt = ERR_PTR(-ENOENT);
 
-	cFYI(1, ("in %s", __func__));
+	cFYI(1, "in %s", __func__);
 	BUG_ON(IS_ROOT(dentry));
 
 	xid = GetXid();
@@ -351,15 +351,15 @@ cifs_dfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 		/* connect to a node */
 		len = strlen(referrals[i].node_name);
 		if (len < 2) {
-			cERROR(1, ("%s: Net Address path too short: %s",
-					__func__, referrals[i].node_name));
+			cERROR(1, "%s: Net Address path too short: %s",
+					__func__, referrals[i].node_name);
 			rc = -EINVAL;
 			goto out_err;
 		}
 		mnt = cifs_dfs_do_refmount(nd->path.mnt,
 				nd->path.dentry, referrals + i);
-		cFYI(1, ("%s: cifs_dfs_do_refmount:%s , mnt:%p", __func__,
-					referrals[i].node_name, mnt));
+		cFYI(1, "%s: cifs_dfs_do_refmount:%s , mnt:%p", __func__,
+					referrals[i].node_name, mnt);
 
 		/* complete mount procedure if we accured submount */
 		if (!IS_ERR(mnt))
@@ -377,7 +377,7 @@ out:
 	FreeXid(xid);
 	free_dfs_info_array(referrals, num_referrals);
 	kfree(full_path);
-	cFYI(1, ("leaving %s" , __func__));
+	cFYI(1, "leaving %s" , __func__);
 	return ERR_PTR(rc);
 out_err:
 	path_put(&nd->path);
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 8ec7736..69b11a6 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -148,7 +148,7 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
 	dp = description + strlen(description);
 	sprintf(dp, ";pid=0x%x", current->pid);
 
-	cFYI(1, ("key description = %s", description));
+	cFYI(1, "key description = %s", description);
 	spnego_key = request_key(&cifs_spnego_key_type, description, "");
 
 #ifdef CONFIG_CIFS_DEBUG2
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 714a542..6de3139 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -199,9 +199,8 @@ cifs_strtoUCS(__le16 *to, const char *from, int len,
 		/* works for 2.4.0 kernel or later */
 		charlen = codepage->char2uni(from, len, &wchar_to[i]);
 		if (charlen < 1) {
-			cERROR(1,
-			       ("strtoUCS: char2uni of %d returned %d",
-				(int)*from, charlen));
+			cERROR(1, "strtoUCS: char2uni of %d returned %d",
+				(int)*from, charlen);
 			/* A question mark */
 			to[i] = cpu_to_le16(0x003f);
 			charlen = 1;
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 7dfe084..174c308 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -86,11 +86,11 @@ int match_sid(struct cifs_sid *ctsid)
 				continue; /* all sub_auth values do not match */
 		}
 
-		cFYI(1, ("matching sid: %s\n", wksidarr[i].sidname));
+		cFYI(1, "matching sid: %s\n", wksidarr[i].sidname);
 		return 0; /* sids compare/match */
 	}
 
-	cFYI(1, ("No matching sid"));
+	cFYI(1, "No matching sid");
 	return -1;
 }
 
@@ -207,14 +207,14 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 			*pbits_to_set &= ~S_IXUGO;
 		return;
 	} else if (type != ACCESS_ALLOWED) {
-		cERROR(1, ("unknown access control type %d", type));
+		cERROR(1, "unknown access control type %d", type);
 		return;
 	}
 	/* else ACCESS_ALLOWED type */
 
 	if (flags & GENERIC_ALL) {
 		*pmode |= (S_IRWXUGO & (*pbits_to_set));
-		cFYI(DBG2, ("all perms"));
+		cFYI(DBG2, "all perms");
 		return;
 	}
 	if ((flags & GENERIC_WRITE) ||
@@ -227,7 +227,7 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 			((flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
 		*pmode |= (S_IXUGO & (*pbits_to_set));
 
-	cFYI(DBG2, ("access flags 0x%x mode now 0x%x", flags, *pmode));
+	cFYI(DBG2, "access flags 0x%x mode now 0x%x", flags, *pmode);
 	return;
 }
 
@@ -256,7 +256,7 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 	if (mode & S_IXUGO)
 		*pace_flags |= SET_FILE_EXEC_RIGHTS;
 
-	cFYI(DBG2, ("mode: 0x%x, access flags now 0x%x", mode, *pace_flags));
+	cFYI(DBG2, "mode: 0x%x, access flags now 0x%x", mode, *pace_flags);
 	return;
 }
 
@@ -296,24 +296,24 @@ static void dump_ace(struct cifs_ace *pace, char *end_of_acl)
 	/* validate that we do not go past end of acl */
 
 	if (le16_to_cpu(pace->size) < 16) {
-		cERROR(1, ("ACE too small, %d", le16_to_cpu(pace->size)));
+		cERROR(1, "ACE too small %d", le16_to_cpu(pace->size));
 		return;
 	}
 
 	if (end_of_acl < (char *)pace + le16_to_cpu(pace->size)) {
-		cERROR(1, ("ACL too small to parse ACE"));
+		cERROR(1, "ACL too small to parse ACE");
 		return;
 	}
 
 	num_subauth = pace->sid.num_subauth;
 	if (num_subauth) {
 		int i;
-		cFYI(1, ("ACE revision %d num_auth %d type %d flags %d size %d",
+		cFYI(1, "ACE revision %d num_auth %d type %d flags %d size %d",
 			pace->sid.revision, pace->sid.num_subauth, pace->type,
-			pace->flags, le16_to_cpu(pace->size)));
+			pace->flags, le16_to_cpu(pace->size));
 		for (i = 0; i < num_subauth; ++i) {
-			cFYI(1, ("ACE sub_auth[%d]: 0x%x", i,
-				le32_to_cpu(pace->sid.sub_auth[i])));
+			cFYI(1, "ACE sub_auth[%d]: 0x%x", i,
+				le32_to_cpu(pace->sid.sub_auth[i]));
 		}
 
 		/* BB add length check to make sure that we do not have huge
@@ -346,13 +346,13 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 
 	/* validate that we do not go past end of acl */
 	if (end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
-		cERROR(1, ("ACL too small to parse DACL"));
+		cERROR(1, "ACL too small to parse DACL");
 		return;
 	}
 
-	cFYI(DBG2, ("DACL revision %d size %d num aces %d",
+	cFYI(DBG2, "DACL revision %d size %d num aces %d",
 		le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
-		le32_to_cpu(pdacl->num_aces)));
+		le32_to_cpu(pdacl->num_aces));
 
 	/* reset rwx permissions for user/group/other.
 	   Also, if num_aces is 0 i.e. DACL has no ACEs,
@@ -436,25 +436,25 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 	/* validate that we do not go past end of ACL - sid must be at least 8
 	   bytes long (assuming no sub-auths - e.g. the null SID */
 	if (end_of_acl < (char *)psid + 8) {
-		cERROR(1, ("ACL too small to parse SID %p", psid));
+		cERROR(1, "ACL too small to parse SID %p", psid);
 		return -EINVAL;
 	}
 
 	if (psid->num_subauth) {
 #ifdef CONFIG_CIFS_DEBUG2
 		int i;
-		cFYI(1, ("SID revision %d num_auth %d",
-			psid->revision, psid->num_subauth));
+		cFYI(1, "SID revision %d num_auth %d",
+			psid->revision, psid->num_subauth);
 
 		for (i = 0; i < psid->num_subauth; i++) {
-			cFYI(1, ("SID sub_auth[%d]: 0x%x ", i,
-				le32_to_cpu(psid->sub_auth[i])));
+			cFYI(1, "SID sub_auth[%d]: 0x%x ", i,
+				le32_to_cpu(psid->sub_auth[i]));
 		}
 
 		/* BB add length check to make sure that we do not have huge
 			num auths and therefore go off the end */
-		cFYI(1, ("RID 0x%x",
-			le32_to_cpu(psid->sub_auth[psid->num_subauth-1])));
+		cFYI(1, "RID 0x%x",
+			le32_to_cpu(psid->sub_auth[psid->num_subauth-1]));
 #endif
 	}
 
@@ -481,11 +481,11 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
 				le32_to_cpu(pntsd->gsidoffset));
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
-	cFYI(DBG2, ("revision %d type 0x%x ooffset 0x%x goffset 0x%x "
+	cFYI(DBG2, "revision %d type 0x%x ooffset 0x%x goffset 0x%x "
 		 "sacloffset 0x%x dacloffset 0x%x",
 		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
 		 le32_to_cpu(pntsd->gsidoffset),
-		 le32_to_cpu(pntsd->sacloffset), dacloffset));
+		 le32_to_cpu(pntsd->sacloffset), dacloffset);
 /*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
 	rc = parse_sid(owner_sid_ptr, end_of_acl);
 	if (rc)
@@ -499,7 +499,7 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
 		parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
 			   group_sid_ptr, fattr);
 	else
-		cFYI(1, ("no ACL")); /* BB grant all or default perms? */
+		cFYI(1, "no ACL"); /* BB grant all or default perms? */
 
 /*	cifscred->uid = owner_sid_ptr->rid;
 	cifscred->gid = group_sid_ptr->rid;
@@ -562,7 +562,7 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 	FreeXid(xid);
 
 
-	cFYI(1, ("GetCIFSACL rc = %d ACL len %d", rc, *pacllen));
+	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
 	return pntsd;
 }
 
@@ -580,12 +580,12 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 			 &fid, &oplock, NULL, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
-		cERROR(1, ("Unable to open file to get ACL"));
+		cERROR(1, "Unable to open file to get ACL");
 		goto out;
 	}
 
 	rc = CIFSSMBGetCIFSACL(xid, cifs_sb->tcon, fid, &pntsd, pacllen);
-	cFYI(1, ("GetCIFSACL rc = %d ACL len %d", rc, *pacllen));
+	cFYI(1, "GetCIFSACL rc = %d ACL len %d", rc, *pacllen);
 
 	CIFSSMBClose(xid, cifs_sb->tcon, fid);
  out:
@@ -620,7 +620,7 @@ static int set_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb, __u16 fid,
 	rc = CIFSSMBSetCIFSACL(xid, cifs_sb->tcon, fid, pnntsd, acllen);
 	FreeXid(xid);
 
-	cFYI(DBG2, ("SetCIFSACL rc = %d", rc));
+	cFYI(DBG2, "SetCIFSACL rc = %d", rc);
 	return rc;
 }
 
@@ -637,12 +637,12 @@ static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const char *path,
 			 &fid, &oplock, NULL, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
-		cERROR(1, ("Unable to open file to set ACL"));
+		cERROR(1, "Unable to open file to set ACL");
 		goto out;
 	}
 
 	rc = CIFSSMBSetCIFSACL(xid, cifs_sb->tcon, fid, pnntsd, acllen);
-	cFYI(DBG2, ("SetCIFSACL rc = %d", rc));
+	cFYI(DBG2, "SetCIFSACL rc = %d", rc);
 
 	CIFSSMBClose(xid, cifs_sb->tcon, fid);
  out:
@@ -658,7 +658,7 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 	struct cifsFileInfo *open_file;
 	int rc;
 
-	cFYI(DBG2, ("set ACL for %s from mode 0x%x", path, inode->i_mode));
+	cFYI(DBG2, "set ACL for %s from mode 0x%x", path, inode->i_mode);
 
 	open_file = find_readable_file(CIFS_I(inode));
 	if (!open_file)
@@ -678,7 +678,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	u32 acllen = 0;
 	int rc = 0;
 
-	cFYI(DBG2, ("converting ACL to mode for %s", path));
+	cFYI(DBG2, "converting ACL to mode for %s", path);
 
 	if (pfid)
 		pntsd = get_cifs_acl_by_fid(cifs_sb, *pfid, &acllen);
@@ -689,7 +689,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	if (pntsd)
 		rc = parse_sec_desc(pntsd, acllen, fattr);
 	if (rc)
-		cFYI(1, ("parse sec desc failed rc = %d", rc));
+		cFYI(1, "parse sec desc failed rc = %d", rc);
 
 	kfree(pntsd);
 	return;
@@ -703,7 +703,7 @@ int mode_to_acl(struct inode *inode, const char *path, __u64 nmode)
 	struct cifs_ntsd *pntsd = NULL; /* acl obtained from server */
 	struct cifs_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
 
-	cFYI(DBG2, ("set ACL from mode for %s", path));
+	cFYI(DBG2, "set ACL from mode for %s", path);
 
 	/* Get the security descriptor */
 	pntsd = get_cifs_acl(CIFS_SB(inode->i_sb), inode, path, &secdesclen);
@@ -720,19 +720,19 @@ int mode_to_acl(struct inode *inode, const char *path, __u64 nmode)
 					DEFSECDESCLEN : secdesclen;
 		pnntsd = kmalloc(secdesclen, GFP_KERNEL);
 		if (!pnntsd) {
-			cERROR(1, ("Unable to allocate security descriptor"));
+			cERROR(1, "Unable to allocate security descriptor");
 			kfree(pntsd);
 			return -ENOMEM;
 		}
 
 		rc = build_sec_desc(pntsd, pnntsd, inode, nmode);
 
-		cFYI(DBG2, ("build_sec_desc rc: %d", rc));
+		cFYI(DBG2, "build_sec_desc rc: %d", rc);
 
 		if (!rc) {
 			/* Set the security descriptor */
 			rc = set_cifs_acl(pnntsd, secdesclen, inode, path);
-			cFYI(DBG2, ("set_cifs_acl rc: %d", rc));
+			cFYI(DBG2, "set_cifs_acl rc: %d", rc);
 		}
 
 		kfree(pnntsd);
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 7efe174..0cb77c9 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -102,7 +102,7 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 		if (iov[i].iov_len == 0)
 			continue;
 		if (iov[i].iov_base == NULL) {
-			cERROR(1, ("null iovec entry"));
+			cERROR(1, "null iovec entry");
 			return -EIO;
 		}
 		/* The first entry includes a length field (which does not get
@@ -180,8 +180,8 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 
 	/* Do not need to verify session setups with signature "BSRSPYL "  */
 	if (memcmp(cifs_pdu->Signature.SecuritySignature, "BSRSPYL ", 8) == 0)
-		cFYI(1, ("dummy signature received for smb command 0x%x",
-			cifs_pdu->Command));
+		cFYI(1, "dummy signature received for smb command 0x%x",
+			cifs_pdu->Command);
 
 	/* save off the origiginal signature so we can modify the smb and check
 		its signature against what the server sent */
@@ -397,7 +397,7 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 	/* calculate buf->ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, nls_cp);
 	if (rc)
-		cERROR(1, ("could not get v2 hash rc %d", rc));
+		cERROR(1, "could not get v2 hash rc %d", rc);
 	CalcNTLMv2_response(ses, resp_buf);
 
 	/* now calculate the MAC key for NTLMv2 */
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8c6a036..bec4ae7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -128,8 +128,7 @@ cifs_read_super(struct super_block *sb, void *data,
 
 	if (rc) {
 		if (!silent)
-			cERROR(1,
-			       ("cifs_mount failed w/return code = %d", rc));
+			cERROR(1, "cifs_mount failed w/return code = %d", rc);
 		goto out_mount_failed;
 	}
 
@@ -160,7 +159,7 @@ cifs_read_super(struct super_block *sb, void *data,
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
-		cFYI(1, ("export ops supported"));
+		cFYI(1, "export ops supported");
 		sb->s_export_op = &cifs_export_ops;
 	}
 #endif /* EXPERIMENTAL */
@@ -168,7 +167,7 @@ cifs_read_super(struct super_block *sb, void *data,
 	return 0;
 
 out_no_root:
-	cERROR(1, ("cifs_read_super: get root inode failed"));
+	cERROR(1, "cifs_read_super: get root inode failed");
 	if (inode)
 		iput(inode);
 
@@ -194,10 +193,10 @@ cifs_put_super(struct super_block *sb)
 	int rc = 0;
 	struct cifs_sb_info *cifs_sb;
 
-	cFYI(1, ("In cifs_put_super"));
+	cFYI(1, "In cifs_put_super");
 	cifs_sb = CIFS_SB(sb);
 	if (cifs_sb == NULL) {
-		cFYI(1, ("Empty cifs superblock info passed to unmount"));
+		cFYI(1, "Empty cifs superblock info passed to unmount");
 		return;
 	}
 
@@ -205,7 +204,7 @@ cifs_put_super(struct super_block *sb)
 
 	rc = cifs_umount(sb, cifs_sb);
 	if (rc)
-		cERROR(1, ("cifs_umount failed with return code %d", rc));
+		cERROR(1, "cifs_umount failed with return code %d", rc);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	if (cifs_sb->mountdata) {
 		kfree(cifs_sb->mountdata);
@@ -438,7 +437,7 @@ int cifs_xquota_set(struct super_block *sb, int quota_type, qid_t qid,
 
 	xid = GetXid();
 	if (pTcon) {
-		cFYI(1, ("set type: 0x%x id: %d", quota_type, qid));
+		cFYI(1, "set type: 0x%x id: %d", quota_type, qid);
 	} else
 		rc = -EIO;
 
@@ -461,7 +460,7 @@ int cifs_xquota_get(struct super_block *sb, int quota_type, qid_t qid,
 
 	xid = GetXid();
 	if (pTcon) {
-		cFYI(1, ("set type: 0x%x id: %d", quota_type, qid));
+		cFYI(1, "set type: 0x%x id: %d", quota_type, qid);
 	} else
 		rc = -EIO;
 
@@ -483,7 +482,7 @@ int cifs_xstate_set(struct super_block *sb, unsigned int flags, int operation)
 
 	xid = GetXid();
 	if (pTcon) {
-		cFYI(1, ("flags: 0x%x operation: 0x%x", flags, operation));
+		cFYI(1, "flags: 0x%x operation: 0x%x", flags, operation);
 	} else
 		rc = -EIO;
 
@@ -505,7 +504,7 @@ int cifs_xstate_get(struct super_block *sb, struct fs_quota_stat *qstats)
 
 	xid = GetXid();
 	if (pTcon) {
-		cFYI(1, ("pqstats %p", qstats));
+		cFYI(1, "pqstats %p", qstats);
 	} else
 		rc = -EIO;
 
@@ -547,7 +546,7 @@ static void cifs_umount_begin(struct super_block *sb)
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
 	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {
-		cFYI(1, ("wake up tasks now - umount begin not complete"));
+		cFYI(1, "wake up tasks now - umount begin not complete");
 		wake_up_all(&tcon->ses->server->request_q);
 		wake_up_all(&tcon->ses->server->response_q);
 		msleep(1); /* yield */
@@ -598,7 +597,7 @@ cifs_get_sb(struct file_system_type *fs_type,
 	int rc;
 	struct super_block *sb = sget(fs_type, NULL, set_anon_super, NULL);
 
-	cFYI(1, ("Devname: %s flags: %d ", dev_name, flags));
+	cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
 
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
@@ -866,7 +865,7 @@ cifs_init_request_bufs(void)
 	} else {
 		CIFSMaxBufSize &= 0x1FE00; /* Round size to even 512 byte mult*/
 	}
-/*	cERROR(1,("CIFSMaxBufSize %d 0x%x",CIFSMaxBufSize,CIFSMaxBufSize)); */
+/*	cERROR(1, "CIFSMaxBufSize %d 0x%x",CIFSMaxBufSize,CIFSMaxBufSize); */
 	cifs_req_cachep = kmem_cache_create("cifs_request",
 					    CIFSMaxBufSize +
 					    MAX_CIFS_HDR_SIZE, 0,
@@ -878,7 +877,7 @@ cifs_init_request_bufs(void)
 		cifs_min_rcv = 1;
 	else if (cifs_min_rcv > 64) {
 		cifs_min_rcv = 64;
-		cERROR(1, ("cifs_min_rcv set to maximum (64)"));
+		cERROR(1, "cifs_min_rcv set to maximum (64)");
 	}
 
 	cifs_req_poolp = mempool_create_slab_pool(cifs_min_rcv,
@@ -909,7 +908,7 @@ cifs_init_request_bufs(void)
 		cifs_min_small = 2;
 	else if (cifs_min_small > 256) {
 		cifs_min_small = 256;
-		cFYI(1, ("cifs_min_small set to maximum (256)"));
+		cFYI(1, "cifs_min_small set to maximum (256)");
 	}
 
 	cifs_sm_req_poolp = mempool_create_slab_pool(cifs_min_small,
@@ -1007,10 +1006,10 @@ init_cifs(void)
 
 	if (cifs_max_pending < 2) {
 		cifs_max_pending = 2;
-		cFYI(1, ("cifs_max_pending set to min of 2"));
+		cFYI(1, "cifs_max_pending set to min of 2");
 	} else if (cifs_max_pending > 256) {
 		cifs_max_pending = 256;
-		cFYI(1, ("cifs_max_pending set to max of 256"));
+		cFYI(1, "cifs_max_pending set to max of 256");
 	}
 
 	rc = cifs_init_inodecache();
@@ -1068,7 +1067,7 @@ init_cifs(void)
 static void __exit
 exit_cifs(void)
 {
-	cFYI(DBG2, ("exit_cifs"));
+	cFYI(DBG2, "exit_cifs");
 	cifs_proc_clean();
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	cifs_dfs_release_automount_timer();
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 88e2bc4..d35d8f7 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -39,8 +39,20 @@ extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
 			unsigned int /* length */);
 extern unsigned int _GetXid(void);
 extern void _FreeXid(unsigned int);
-#define GetXid() (int)_GetXid(); cFYI(1,("CIFS VFS: in %s as Xid: %d with uid: %d",__func__, xid,current_fsuid()));
-#define FreeXid(curr_xid) {_FreeXid(curr_xid); cFYI(1,("CIFS VFS: leaving %s (xid = %d) rc = %d",__func__,curr_xid,(int)rc));}
+#define GetXid()						\
+({								\
+	int __xid = (int)_GetXid();				\
+	cFYI(1, "CIFS VFS: in %s as Xid: %d with uid: %d",	\
+	     __func__, __xid, current_fsuid());			\
+	__xid;							\
+})
+
+#define FreeXid(curr_xid)					\
+do {								\
+	_FreeXid(curr_xid);					\
+	cFYI(1, "CIFS VFS: leaving %s (xid = %d) rc = %d",	\
+	     __func__, curr_xid, (int)rc);			\
+} while (0)
 extern char *build_path_from_dentry(struct dentry *);
 extern char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6118358..80371e6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -129,8 +129,8 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, int smb_command)
 		if (smb_command != SMB_COM_WRITE_ANDX &&
 		    smb_command != SMB_COM_OPEN_ANDX &&
 		    smb_command != SMB_COM_TREE_DISCONNECT) {
-			cFYI(1, ("can not send cmd %d while umounting",
-				smb_command));
+			cFYI(1, "can not send cmd %d while umounting",
+				smb_command);
 			return -ENODEV;
 		}
 	}
@@ -156,7 +156,7 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, int smb_command)
 		 * back on-line
 		 */
 		if (!tcon->retry || ses->status == CifsExiting) {
-			cFYI(1, ("gave up waiting on reconnect in smb_init"));
+			cFYI(1, "gave up waiting on reconnect in smb_init");
 			return -EHOSTDOWN;
 		}
 	}
@@ -183,7 +183,7 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, int smb_command)
 	mark_open_files_invalid(tcon);
 	rc = CIFSTCon(0, ses, tcon->treeName, tcon, nls_codepage);
 	mutex_unlock(&ses->session_mutex);
-	cFYI(1, ("reconnect tcon rc = %d", rc));
+	cFYI(1, "reconnect tcon rc = %d", rc);
 
 	if (rc)
 		goto out;
@@ -373,7 +373,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 	else /* if override flags set only sign/seal OR them with global auth */
 		secFlags = extended_security | ses->overrideSecFlg;
 
-	cFYI(1, ("secFlags 0x%x", secFlags));
+	cFYI(1, "secFlags 0x%x", secFlags);
 
 	pSMB->hdr.Mid = GetNextMid(server);
 	pSMB->hdr.Flags2 |= (SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS);
@@ -381,14 +381,14 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 	if ((secFlags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_KRB5) {
-		cFYI(1, ("Kerberos only mechanism, enable extended security"));
+		cFYI(1, "Kerberos only mechanism, enable extended security");
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	}
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	else if ((secFlags & CIFSSEC_MUST_NTLMSSP) == CIFSSEC_MUST_NTLMSSP)
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_NTLMSSP) {
-		cFYI(1, ("NTLMSSP only mechanism, enable extended security"));
+		cFYI(1, "NTLMSSP only mechanism, enable extended security");
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	}
 #endif
@@ -408,7 +408,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 		goto neg_err_exit;
 
 	dialect = le16_to_cpu(pSMBr->DialectIndex);
-	cFYI(1, ("Dialect: %d", dialect));
+	cFYI(1, "Dialect: %d", dialect);
 	/* Check wct = 1 error case */
 	if ((pSMBr->hdr.WordCount < 13) || (dialect == BAD_PROT)) {
 		/* core returns wct = 1, but we do not ask for core - otherwise
@@ -427,8 +427,8 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 			(secFlags & CIFSSEC_MAY_PLNTXT))
 			server->secType = LANMAN;
 		else {
-			cERROR(1, ("mount failed weak security disabled"
-				   " in /proc/fs/cifs/SecurityFlags"));
+			cERROR(1, "mount failed weak security disabled"
+				   " in /proc/fs/cifs/SecurityFlags");
 			rc = -EOPNOTSUPP;
 			goto neg_err_exit;
 		}
@@ -461,9 +461,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 			utc = CURRENT_TIME;
 			ts = cnvrtDosUnixTm(rsp->SrvTime.Date,
 					    rsp->SrvTime.Time, 0);
-			cFYI(1, ("SrvTime %d sec since 1970 (utc: %d) diff: %d",
+			cFYI(1, "SrvTime %d sec since 1970 (utc: %d) diff: %d",
 				(int)ts.tv_sec, (int)utc.tv_sec,
-				(int)(utc.tv_sec - ts.tv_sec)));
+				(int)(utc.tv_sec - ts.tv_sec));
 			val = (int)(utc.tv_sec - ts.tv_sec);
 			seconds = abs(val);
 			result = (seconds / MIN_TZ_ADJ) * MIN_TZ_ADJ;
@@ -477,7 +477,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 			server->timeAdj = (int)tmp;
 			server->timeAdj *= 60; /* also in seconds */
 		}
-		cFYI(1, ("server->timeAdj: %d seconds", server->timeAdj));
+		cFYI(1, "server->timeAdj: %d seconds", server->timeAdj);
 
 
 		/* BB get server time for time conversions and add
@@ -492,14 +492,14 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 			goto neg_err_exit;
 		}
 
-		cFYI(1, ("LANMAN negotiated"));
+		cFYI(1, "LANMAN negotiated");
 		/* we will not end up setting signing flags - as no signing
 		was in LANMAN and server did not return the flags on */
 		goto signing_check;
 #else /* weak security disabled */
 	} else if (pSMBr->hdr.WordCount == 13) {
-		cERROR(1, ("mount failed, cifs module not built "
-			  "with CIFS_WEAK_PW_HASH support"));
+		cERROR(1, "mount failed, cifs module not built "
+			  "with CIFS_WEAK_PW_HASH support");
 			rc = -EOPNOTSUPP;
 #endif /* WEAK_PW_HASH */
 		goto neg_err_exit;
@@ -511,14 +511,14 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 	/* else wct == 17 NTLM */
 	server->secMode = pSMBr->SecurityMode;
 	if ((server->secMode & SECMODE_USER) == 0)
-		cFYI(1, ("share mode security"));
+		cFYI(1, "share mode security");
 
 	if ((server->secMode & SECMODE_PW_ENCRYPT) == 0)
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 		if ((secFlags & CIFSSEC_MAY_PLNTXT) == 0)
 #endif /* CIFS_WEAK_PW_HASH */
-			cERROR(1, ("Server requests plain text password"
-				  " but client support disabled"));
+			cERROR(1, "Server requests plain text password"
+				  " but client support disabled");
 
 	if ((secFlags & CIFSSEC_MUST_NTLMV2) == CIFSSEC_MUST_NTLMV2)
 		server->secType = NTLMv2;
@@ -538,7 +538,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 #endif */
 	else {
 		rc = -EOPNOTSUPP;
-		cERROR(1, ("Invalid security type"));
+		cERROR(1, "Invalid security type");
 		goto neg_err_exit;
 	}
 	/* else ... any others ...? */
@@ -550,7 +550,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 	server->maxBuf = min(le32_to_cpu(pSMBr->MaxBufferSize),
 			(__u32) CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
-	cFYI(DBG2, ("Max buf = %d", ses->server->maxBuf));
+	cFYI(DBG2, "Max buf = %d", ses->server->maxBuf);
 	GETU32(ses->server->sessid) = le32_to_cpu(pSMBr->SessionKey);
 	server->capabilities = le32_to_cpu(pSMBr->Capabilities);
 	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
@@ -581,7 +581,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 			if (memcmp(server->server_GUID,
 				   pSMBr->u.extended_response.
 				   GUID, 16) != 0) {
-				cFYI(1, ("server UID changed"));
+				cFYI(1, "server UID changed");
 				memcpy(server->server_GUID,
 					pSMBr->u.extended_response.GUID,
 					16);
@@ -613,22 +613,21 @@ signing_check:
 	if ((secFlags & CIFSSEC_MAY_SIGN) == 0) {
 		/* MUST_SIGN already includes the MAY_SIGN FLAG
 		   so if this is zero it means that signing is disabled */
-		cFYI(1, ("Signing disabled"));
+		cFYI(1, "Signing disabled");
 		if (server->secMode & SECMODE_SIGN_REQUIRED) {
-			cERROR(1, ("Server requires "
+			cERROR(1, "Server requires "
 				   "packet signing to be enabled in "
-				   "/proc/fs/cifs/SecurityFlags."));
+				   "/proc/fs/cifs/SecurityFlags.");
 			rc = -EOPNOTSUPP;
 		}
 		server->secMode &=
 			~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
 	} else if ((secFlags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
 		/* signing required */
-		cFYI(1, ("Must sign - secFlags 0x%x", secFlags));
+		cFYI(1, "Must sign - secFlags 0x%x", secFlags);
 		if ((server->secMode &
 			(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED)) == 0) {
-			cERROR(1,
-				("signing required but server lacks support"));
+			cERROR(1, "signing required but server lacks support");
 			rc = -EOPNOTSUPP;
 		} else
 			server->secMode |= SECMODE_SIGN_REQUIRED;
@@ -642,7 +641,7 @@ signing_check:
 neg_err_exit:
 	cifs_buf_release(pSMB);
 
-	cFYI(1, ("negprot rc %d", rc));
+	cFYI(1, "negprot rc %d", rc);
 	return rc;
 }
 
@@ -652,7 +651,7 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon)
 	struct smb_hdr *smb_buffer;
 	int rc = 0;
 
-	cFYI(1, ("In tree disconnect"));
+	cFYI(1, "In tree disconnect");
 
 	/* BB: do we need to check this? These should never be NULL. */
 	if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
@@ -674,7 +673,7 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon)
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, smb_buffer, 0);
 	if (rc)
-		cFYI(1, ("Tree disconnect failed %d", rc));
+		cFYI(1, "Tree disconnect failed %d", rc);
 
 	/* No need to return error on this operation if tid invalidated and
 	   closed on server already e.g. due to tcp session crashing */
@@ -690,7 +689,7 @@ CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
 	LOGOFF_ANDX_REQ *pSMB;
 	int rc = 0;
 
-	cFYI(1, ("In SMBLogoff for session disconnect"));
+	cFYI(1, "In SMBLogoff for session disconnect");
 
 	/*
 	 * BB: do we need to check validity of ses and server? They should
@@ -743,7 +742,7 @@ CIFSPOSIXDelFile(const int xid, struct cifsTconInfo *tcon, const char *fileName,
 	int bytes_returned = 0;
 	__u16 params, param_offset, offset, byte_count;
 
-	cFYI(1, ("In POSIX delete"));
+	cFYI(1, "In POSIX delete");
 PsxDelete:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -795,7 +794,7 @@ PsxDelete:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, ("Posix delete returned %d", rc));
+		cFYI(1, "Posix delete returned %d", rc);
 	cifs_buf_release(pSMB);
 
 	cifs_stats_inc(&tcon->num_deletes);
@@ -842,7 +841,7 @@ DelFileRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_deletes);
 	if (rc)
-		cFYI(1, ("Error in RMFile = %d", rc));
+		cFYI(1, "Error in RMFile = %d", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -861,7 +860,7 @@ CIFSSMBRmDir(const int xid, struct cifsTconInfo *tcon, const char *dirName,
 	int bytes_returned;
 	int name_len;
 
-	cFYI(1, ("In CIFSSMBRmDir"));
+	cFYI(1, "In CIFSSMBRmDir");
 RmDirRetry:
 	rc = smb_init(SMB_COM_DELETE_DIRECTORY, 0, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -886,7 +885,7 @@ RmDirRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_rmdirs);
 	if (rc)
-		cFYI(1, ("Error in RMDir = %d", rc));
+		cFYI(1, "Error in RMDir = %d", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -904,7 +903,7 @@ CIFSSMBMkDir(const int xid, struct cifsTconInfo *tcon,
 	int bytes_returned;
 	int name_len;
 
-	cFYI(1, ("In CIFSSMBMkDir"));
+	cFYI(1, "In CIFSSMBMkDir");
 MkDirRetry:
 	rc = smb_init(SMB_COM_CREATE_DIRECTORY, 0, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -929,7 +928,7 @@ MkDirRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_mkdirs);
 	if (rc)
-		cFYI(1, ("Error in Mkdir = %d", rc));
+		cFYI(1, "Error in Mkdir = %d", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -952,7 +951,7 @@ CIFSPOSIXCreate(const int xid, struct cifsTconInfo *tcon, __u32 posix_flags,
 	OPEN_PSX_REQ *pdata;
 	OPEN_PSX_RSP *psx_rsp;
 
-	cFYI(1, ("In POSIX Create"));
+	cFYI(1, "In POSIX Create");
 PsxCreat:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -1006,11 +1005,11 @@ PsxCreat:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Posix create returned %d", rc));
+		cFYI(1, "Posix create returned %d", rc);
 		goto psx_create_err;
 	}
 
-	cFYI(1, ("copying inode info"));
+	cFYI(1, "copying inode info");
 	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 	if (rc || (pSMBr->ByteCount < sizeof(OPEN_PSX_RSP))) {
@@ -1032,11 +1031,11 @@ PsxCreat:
 	/* check to make sure response data is there */
 	if (psx_rsp->ReturnedLevel != cpu_to_le16(SMB_QUERY_FILE_UNIX_BASIC)) {
 		pRetData->Type = cpu_to_le32(-1); /* unknown */
-		cFYI(DBG2, ("unknown type"));
+		cFYI(DBG2, "unknown type");
 	} else {
 		if (pSMBr->ByteCount < sizeof(OPEN_PSX_RSP)
 					+ sizeof(FILE_UNIX_BASIC_INFO)) {
-			cERROR(1, ("Open response data too small"));
+			cERROR(1, "Open response data too small");
 			pRetData->Type = cpu_to_le32(-1);
 			goto psx_create_err;
 		}
@@ -1083,7 +1082,7 @@ static __u16 convert_disposition(int disposition)
 			ofun = SMBOPEN_OCREATE | SMBOPEN_OTRUNC;
 			break;
 		default:
-			cFYI(1, ("unknown disposition %d", disposition));
+			cFYI(1, "unknown disposition %d", disposition);
 			ofun =  SMBOPEN_OAPPEND; /* regular open */
 	}
 	return ofun;
@@ -1174,7 +1173,7 @@ OldOpenRetry:
 			(struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP);
 	cifs_stats_inc(&tcon->num_opens);
 	if (rc) {
-		cFYI(1, ("Error in Open = %d", rc));
+		cFYI(1, "Error in Open = %d", rc);
 	} else {
 	/* BB verify if wct == 15 */
 
@@ -1287,7 +1286,7 @@ openRetry:
 			(struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP);
 	cifs_stats_inc(&tcon->num_opens);
 	if (rc) {
-		cFYI(1, ("Error in Open = %d", rc));
+		cFYI(1, "Error in Open = %d", rc);
 	} else {
 		*pOplock = pSMBr->OplockLevel; /* 1 byte no need to le_to_cpu */
 		*netfid = pSMBr->Fid;	/* cifs fid stays in le */
@@ -1325,7 +1324,7 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
 	int resp_buf_type = 0;
 	struct kvec iov[1];
 
-	cFYI(1, ("Reading %d bytes on fid %d", count, netfid));
+	cFYI(1, "Reading %d bytes on fid %d", count, netfid);
 	if (tcon->ses->capabilities & CAP_LARGE_FILES)
 		wct = 12;
 	else {
@@ -1370,7 +1369,7 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
 	cifs_stats_inc(&tcon->num_reads);
 	pSMBr = (READ_RSP *)iov[0].iov_base;
 	if (rc) {
-		cERROR(1, ("Send error in read = %d", rc));
+		cERROR(1, "Send error in read = %d", rc);
 	} else {
 		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
 		data_length = data_length << 16;
@@ -1380,15 +1379,15 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
 		/*check that DataLength would not go beyond end of SMB */
 		if ((data_length > CIFSMaxBufSize)
 				|| (data_length > count)) {
-			cFYI(1, ("bad length %d for count %d",
-				 data_length, count));
+			cFYI(1, "bad length %d for count %d",
+				 data_length, count);
 			rc = -EIO;
 			*nbytes = 0;
 		} else {
 			pReadData = (char *) (&pSMBr->hdr.Protocol) +
 					le16_to_cpu(pSMBr->DataOffset);
 /*			if (rc = copy_to_user(buf, pReadData, data_length)) {
-				cERROR(1,("Faulting on read rc = %d",rc));
+				cERROR(1, "Faulting on read rc = %d",rc);
 				rc = -EFAULT;
 			}*/ /* can not use copy_to_user when using page cache*/
 			if (*buf)
@@ -1430,7 +1429,7 @@ CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
 	__u32 bytes_sent;
 	__u16 byte_count;
 
-	/* cFYI(1, ("write at %lld %d bytes", offset, count));*/
+	/* cFYI(1, "write at %lld %d bytes", offset, count);*/
 	if (tcon->ses == NULL)
 		return -ECONNABORTED;
 
@@ -1511,7 +1510,7 @@ CIFSSMBWrite(const int xid, struct cifsTconInfo *tcon,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, long_op);
 	cifs_stats_inc(&tcon->num_writes);
 	if (rc) {
-		cFYI(1, ("Send error in write = %d", rc));
+		cFYI(1, "Send error in write = %d", rc);
 		*nbytes = 0;
 	} else {
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
@@ -1541,7 +1540,7 @@ CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
 
 	*nbytes = 0;
 
-	cFYI(1, ("write2 at %lld %d bytes", (long long)offset, count));
+	cFYI(1, "write2 at %lld %d bytes", (long long)offset, count);
 
 	if (tcon->ses->capabilities & CAP_LARGE_FILES) {
 		wct = 14;
@@ -1596,7 +1595,7 @@ CIFSSMBWrite2(const int xid, struct cifsTconInfo *tcon,
 			  long_op);
 	cifs_stats_inc(&tcon->num_writes);
 	if (rc) {
-		cFYI(1, ("Send error Write2 = %d", rc));
+		cFYI(1, "Send error Write2 = %d", rc);
 	} else if (resp_buf_type == 0) {
 		/* presumably this can not happen, but best to be safe */
 		rc = -EIO;
@@ -1633,7 +1632,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	int timeout = 0;
 	__u16 count;
 
-	cFYI(1, ("CIFSSMBLock timeout %d numLock %d", (int)waitFlag, numLock));
+	cFYI(1, "CIFSSMBLock timeout %d numLock %d", (int)waitFlag, numLock);
 	rc = small_smb_init(SMB_COM_LOCKING_ANDX, 8, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -1681,7 +1680,7 @@ CIFSSMBLock(const int xid, struct cifsTconInfo *tcon,
 	}
 	cifs_stats_inc(&tcon->num_locks);
 	if (rc)
-		cFYI(1, ("Send error in Lock = %d", rc));
+		cFYI(1, "Send error in Lock = %d", rc);
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
 	since file handle passed in no longer valid */
@@ -1704,7 +1703,7 @@ CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 	__u16 params, param_offset, offset, byte_count, count;
 	struct kvec iov[1];
 
-	cFYI(1, ("Posix Lock"));
+	cFYI(1, "Posix Lock");
 
 	if (pLockData == NULL)
 		return -EINVAL;
@@ -1774,7 +1773,7 @@ CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 	}
 
 	if (rc) {
-		cFYI(1, ("Send error in Posix Lock = %d", rc));
+		cFYI(1, "Send error in Posix Lock = %d", rc);
 	} else if (get_flag) {
 		/* lock structure can be returned on get */
 		__u16 data_offset;
@@ -1818,7 +1817,7 @@ CIFSSMBClose(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
 {
 	int rc = 0;
 	CLOSE_REQ *pSMB = NULL;
-	cFYI(1, ("In CIFSSMBClose"));
+	cFYI(1, "In CIFSSMBClose");
 
 /* do not retry on dead session on close */
 	rc = small_smb_init(SMB_COM_CLOSE, 3, tcon, (void **) &pSMB);
@@ -1835,7 +1834,7 @@ CIFSSMBClose(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
 	if (rc) {
 		if (rc != -EINTR) {
 			/* EINTR is expected when user ctl-c to kill app */
-			cERROR(1, ("Send error in Close = %d", rc));
+			cERROR(1, "Send error in Close = %d", rc);
 		}
 	}
 
@@ -1851,7 +1850,7 @@ CIFSSMBFlush(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
 {
 	int rc = 0;
 	FLUSH_REQ *pSMB = NULL;
-	cFYI(1, ("In CIFSSMBFlush"));
+	cFYI(1, "In CIFSSMBFlush");
 
 	rc = small_smb_init(SMB_COM_FLUSH, 1, tcon, (void **) &pSMB);
 	if (rc)
@@ -1862,7 +1861,7 @@ CIFSSMBFlush(const int xid, struct cifsTconInfo *tcon, int smb_file_id)
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
 	cifs_stats_inc(&tcon->num_flushes);
 	if (rc)
-		cERROR(1, ("Send error in Flush = %d", rc));
+		cERROR(1, "Send error in Flush = %d", rc);
 
 	return rc;
 }
@@ -1879,7 +1878,7 @@ CIFSSMBRename(const int xid, struct cifsTconInfo *tcon,
 	int name_len, name_len2;
 	__u16 count;
 
-	cFYI(1, ("In CIFSSMBRename"));
+	cFYI(1, "In CIFSSMBRename");
 renameRetry:
 	rc = smb_init(SMB_COM_RENAME, 1, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -1925,7 +1924,7 @@ renameRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_renames);
 	if (rc)
-		cFYI(1, ("Send error in rename = %d", rc));
+		cFYI(1, "Send error in rename = %d", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -1949,7 +1948,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifsTconInfo *pTcon,
 	int len_of_str;
 	__u16 params, param_offset, offset, count, byte_count;
 
-	cFYI(1, ("Rename to File by handle"));
+	cFYI(1, "Rename to File by handle");
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, pTcon, (void **) &pSMB,
 			(void **) &pSMBr);
 	if (rc)
@@ -2004,7 +2003,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct cifsTconInfo *pTcon,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&pTcon->num_t2renames);
 	if (rc)
-		cFYI(1, ("Send error in Rename (by file handle) = %d", rc));
+		cFYI(1, "Send error in Rename (by file handle) = %d", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -2026,7 +2025,7 @@ CIFSSMBCopy(const int xid, struct cifsTconInfo *tcon, const char *fromName,
 	int name_len, name_len2;
 	__u16 count;
 
-	cFYI(1, ("In CIFSSMBCopy"));
+	cFYI(1, "In CIFSSMBCopy");
 copyRetry:
 	rc = smb_init(SMB_COM_COPY, 1, tcon, (void **) &pSMB,
 			(void **) &pSMBr);
@@ -2071,8 +2070,8 @@ copyRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in copy = %d with %d files copied",
-			rc, le16_to_cpu(pSMBr->CopyCount)));
+		cFYI(1, "Send error in copy = %d with %d files copied",
+			rc, le16_to_cpu(pSMBr->CopyCount));
 	}
 	cifs_buf_release(pSMB);
 
@@ -2096,7 +2095,7 @@ CIFSUnixCreateSymLink(const int xid, struct cifsTconInfo *tcon,
 	int bytes_returned = 0;
 	__u16 params, param_offset, offset, byte_count;
 
-	cFYI(1, ("In Symlink Unix style"));
+	cFYI(1, "In Symlink Unix style");
 createSymLinkRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -2161,7 +2160,7 @@ createSymLinkRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_symlinks);
 	if (rc)
-		cFYI(1, ("Send error in SetPathInfo create symlink = %d", rc));
+		cFYI(1, "Send error in SetPathInfo create symlink = %d", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -2185,7 +2184,7 @@ CIFSUnixCreateHardLink(const int xid, struct cifsTconInfo *tcon,
 	int bytes_returned = 0;
 	__u16 params, param_offset, offset, byte_count;
 
-	cFYI(1, ("In Create Hard link Unix style"));
+	cFYI(1, "In Create Hard link Unix style");
 createHardLinkRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -2247,7 +2246,7 @@ createHardLinkRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_hardlinks);
 	if (rc)
-		cFYI(1, ("Send error in SetPathInfo (hard link) = %d", rc));
+		cFYI(1, "Send error in SetPathInfo (hard link) = %d", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -2268,7 +2267,7 @@ CIFSCreateHardLink(const int xid, struct cifsTconInfo *tcon,
 	int name_len, name_len2;
 	__u16 count;
 
-	cFYI(1, ("In CIFSCreateHardLink"));
+	cFYI(1, "In CIFSCreateHardLink");
 winCreateHardLinkRetry:
 
 	rc = smb_init(SMB_COM_NT_RENAME, 4, tcon, (void **) &pSMB,
@@ -2319,7 +2318,7 @@ winCreateHardLinkRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_hardlinks);
 	if (rc)
-		cFYI(1, ("Send error in hard link (NT rename) = %d", rc));
+		cFYI(1, "Send error in hard link (NT rename) = %d", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -2342,7 +2341,7 @@ CIFSSMBUnixQuerySymLink(const int xid, struct cifsTconInfo *tcon,
 	__u16 params, byte_count;
 	char *data_start;
 
-	cFYI(1, ("In QPathSymLinkInfo (Unix) for path %s", searchName));
+	cFYI(1, "In QPathSymLinkInfo (Unix) for path %s", searchName);
 
 querySymLinkRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -2389,7 +2388,7 @@ querySymLinkRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QuerySymLinkInfo = %d", rc));
+		cFYI(1, "Send error in QuerySymLinkInfo = %d", rc);
 	} else {
 		/* decode response */
 
@@ -2490,21 +2489,21 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
 
 	/* should we also check that parm and data areas do not overlap? */
 	if (*ppparm > end_of_smb) {
-		cFYI(1, ("parms start after end of smb"));
+		cFYI(1, "parms start after end of smb");
 		return -EINVAL;
 	} else if (parm_count + *ppparm > end_of_smb) {
-		cFYI(1, ("parm end after end of smb"));
+		cFYI(1, "parm end after end of smb");
 		return -EINVAL;
 	} else if (*ppdata > end_of_smb) {
-		cFYI(1, ("data starts after end of smb"));
+		cFYI(1, "data starts after end of smb");
 		return -EINVAL;
 	} else if (data_count + *ppdata > end_of_smb) {
-		cFYI(1, ("data %p + count %d (%p) ends after end of smb %p start %p",
+		cFYI(1, "data %p + count %d (%p) ends after end of smb %p start %p",
 			*ppdata, data_count, (data_count + *ppdata),
-			end_of_smb, pSMBr));
+			end_of_smb, pSMBr);
 		return -EINVAL;
 	} else if (parm_count + data_count > pSMBr->ByteCount) {
-		cFYI(1, ("parm count and data count larger than SMB"));
+		cFYI(1, "parm count and data count larger than SMB");
 		return -EINVAL;
 	}
 	*pdatalen = data_count;
@@ -2523,7 +2522,7 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
 	struct smb_com_transaction_ioctl_req *pSMB;
 	struct smb_com_transaction_ioctl_rsp *pSMBr;
 
-	cFYI(1, ("In Windows reparse style QueryLink for path %s", searchName));
+	cFYI(1, "In Windows reparse style QueryLink for path %s", searchName);
 	rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
 	if (rc)
@@ -2552,7 +2551,7 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QueryReparseLinkInfo = %d", rc));
+		cFYI(1, "Send error in QueryReparseLinkInfo = %d", rc);
 	} else {		/* decode response */
 		__u32 data_offset = le32_to_cpu(pSMBr->DataOffset);
 		__u32 data_count = le32_to_cpu(pSMBr->DataCount);
@@ -2576,7 +2575,7 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
 			if ((reparse_buf->LinkNamesBuf +
 				reparse_buf->TargetNameOffset +
 				reparse_buf->TargetNameLen) > end_of_smb) {
-				cFYI(1, ("reparse buf beyond SMB"));
+				cFYI(1, "reparse buf beyond SMB");
 				rc = -EIO;
 				goto qreparse_out;
 			}
@@ -2597,12 +2596,12 @@ CIFSSMBQueryReparseLinkInfo(const int xid, struct cifsTconInfo *tcon,
 			}
 		} else {
 			rc = -EIO;
-			cFYI(1, ("Invalid return data count on "
-				 "get reparse info ioctl"));
+			cFYI(1, "Invalid return data count on "
+				 "get reparse info ioctl");
 		}
 		symlinkinfo[buflen] = 0; /* just in case so the caller
 					does not go off the end of the buffer */
-		cFYI(1, ("readlink result - %s", symlinkinfo));
+		cFYI(1, "readlink result - %s", symlinkinfo);
 	}
 
 qreparse_out:
@@ -2625,7 +2624,7 @@ static void cifs_convert_ace(posix_acl_xattr_entry *ace,
 	ace->e_perm = cpu_to_le16(cifs_ace->cifs_e_perm);
 	ace->e_tag  = cpu_to_le16(cifs_ace->cifs_e_tag);
 	ace->e_id   = cpu_to_le32(le64_to_cpu(cifs_ace->cifs_uid));
-	/* cFYI(1,("perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id)); */
+	/* cFYI(1, "perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id); */
 
 	return;
 }
@@ -2651,8 +2650,8 @@ static int cifs_copy_posix_acl(char *trgt, char *src, const int buflen,
 		size += sizeof(struct cifs_posix_ace) * count;
 		/* check if we would go beyond end of SMB */
 		if (size_of_data_area < size) {
-			cFYI(1, ("bad CIFS POSIX ACL size %d vs. %d",
-				size_of_data_area, size));
+			cFYI(1, "bad CIFS POSIX ACL size %d vs. %d",
+				size_of_data_area, size);
 			return -EINVAL;
 		}
 	} else if (acl_type & ACL_TYPE_DEFAULT) {
@@ -2699,7 +2698,7 @@ static __u16 convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
 		cifs_ace->cifs_uid = cpu_to_le64(-1);
 	} else
 		cifs_ace->cifs_uid = cpu_to_le64(le32_to_cpu(local_ace->e_id));
-	/*cFYI(1,("perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id));*/
+	/*cFYI(1, "perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id);*/
 	return rc;
 }
 
@@ -2717,12 +2716,12 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
 		return 0;
 
 	count = posix_acl_xattr_count((size_t)buflen);
-	cFYI(1, ("setting acl with %d entries from buf of length %d and "
+	cFYI(1, "setting acl with %d entries from buf of length %d and "
 		"version of %d",
-		count, buflen, le32_to_cpu(local_acl->a_version)));
+		count, buflen, le32_to_cpu(local_acl->a_version));
 	if (le32_to_cpu(local_acl->a_version) != 2) {
-		cFYI(1, ("unknown POSIX ACL version %d",
-		     le32_to_cpu(local_acl->a_version)));
+		cFYI(1, "unknown POSIX ACL version %d",
+		     le32_to_cpu(local_acl->a_version));
 		return 0;
 	}
 	cifs_acl->version = cpu_to_le16(1);
@@ -2731,7 +2730,7 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
 	else if (acl_type == ACL_TYPE_DEFAULT)
 		cifs_acl->default_entry_count = cpu_to_le16(count);
 	else {
-		cFYI(1, ("unknown ACL type %d", acl_type));
+		cFYI(1, "unknown ACL type %d", acl_type);
 		return 0;
 	}
 	for (i = 0; i < count; i++) {
@@ -2764,7 +2763,7 @@ CIFSSMBGetPosixACL(const int xid, struct cifsTconInfo *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In GetPosixACL (Unix) for path %s", searchName));
+	cFYI(1, "In GetPosixACL (Unix) for path %s", searchName);
 
 queryAclRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -2816,7 +2815,7 @@ queryAclRetry:
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_acl_get);
 	if (rc) {
-		cFYI(1, ("Send error in Query POSIX ACL = %d", rc));
+		cFYI(1, "Send error in Query POSIX ACL = %d", rc);
 	} else {
 		/* decode response */
 
@@ -2853,7 +2852,7 @@ CIFSSMBSetPosixACL(const int xid, struct cifsTconInfo *tcon,
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
 
-	cFYI(1, ("In SetPosixACL (Unix) for path %s", fileName));
+	cFYI(1, "In SetPosixACL (Unix) for path %s", fileName);
 setAclRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -2908,7 +2907,7 @@ setAclRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, ("Set POSIX ACL returned %d", rc));
+		cFYI(1, "Set POSIX ACL returned %d", rc);
 
 setACLerrorExit:
 	cifs_buf_release(pSMB);
@@ -2928,7 +2927,7 @@ CIFSGetExtAttr(const int xid, struct cifsTconInfo *tcon,
 	int bytes_returned;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In GetExtAttr"));
+	cFYI(1, "In GetExtAttr");
 	if (tcon == NULL)
 		return -ENODEV;
 
@@ -2967,7 +2966,7 @@ GetExtAttrRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("error %d in GetExtAttr", rc));
+		cFYI(1, "error %d in GetExtAttr", rc);
 	} else {
 		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -2982,7 +2981,7 @@ GetExtAttrRetry:
 			struct file_chattr_info *pfinfo;
 			/* BB Do we need a cast or hash here ? */
 			if (count != 16) {
-				cFYI(1, ("Illegal size ret in GetExtAttr"));
+				cFYI(1, "Illegal size ret in GetExtAttr");
 				rc = -EIO;
 				goto GetExtAttrOut;
 			}
@@ -3012,7 +3011,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 	QUERY_SEC_DESC_REQ *pSMB;
 	struct kvec iov[1];
 
-	cFYI(1, ("GetCifsACL"));
+	cFYI(1, "GetCifsACL");
 
 	*pbuflen = 0;
 	*acl_inf = NULL;
@@ -3037,7 +3036,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 			 CIFS_STD_OP);
 	cifs_stats_inc(&tcon->num_acl_get);
 	if (rc) {
-		cFYI(1, ("Send error in QuerySecDesc = %d", rc));
+		cFYI(1, "Send error in QuerySecDesc = %d", rc);
 	} else {                /* decode response */
 		__le32 *parm;
 		__u32 parm_len;
@@ -3052,7 +3051,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 			goto qsec_out;
 		pSMBr = (struct smb_com_ntransact_rsp *)iov[0].iov_base;
 
-		cFYI(1, ("smb %p parm %p data %p", pSMBr, parm, *acl_inf));
+		cFYI(1, "smb %p parm %p data %p", pSMBr, parm, *acl_inf);
 
 		if (le32_to_cpu(pSMBr->ParameterCount) != 4) {
 			rc = -EIO;      /* bad smb */
@@ -3064,8 +3063,8 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 
 		acl_len = le32_to_cpu(*parm);
 		if (acl_len != *pbuflen) {
-			cERROR(1, ("acl length %d does not match %d",
-				   acl_len, *pbuflen));
+			cERROR(1, "acl length %d does not match %d",
+				   acl_len, *pbuflen);
 			if (*pbuflen > acl_len)
 				*pbuflen = acl_len;
 		}
@@ -3074,7 +3073,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 		   header followed by the smallest SID */
 		if ((*pbuflen < sizeof(struct cifs_ntsd) + 8) ||
 		    (*pbuflen >= 64 * 1024)) {
-			cERROR(1, ("bad acl length %d", *pbuflen));
+			cERROR(1, "bad acl length %d", *pbuflen);
 			rc = -EINVAL;
 			*pbuflen = 0;
 		} else {
@@ -3148,9 +3147,9 @@ setCifsAclRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 
-	cFYI(1, ("SetCIFSACL bytes_returned: %d, rc: %d", bytes_returned, rc));
+	cFYI(1, "SetCIFSACL bytes_returned: %d, rc: %d", bytes_returned, rc);
 	if (rc)
-		cFYI(1, ("Set CIFS ACL returned %d", rc));
+		cFYI(1, "Set CIFS ACL returned %d", rc);
 	cifs_buf_release(pSMB);
 
 	if (rc == -EAGAIN)
@@ -3174,7 +3173,7 @@ int SMBQueryInformation(const int xid, struct cifsTconInfo *tcon,
 	int bytes_returned;
 	int name_len;
 
-	cFYI(1, ("In SMBQPath path %s", searchName));
+	cFYI(1, "In SMBQPath path %s", searchName);
 QInfRetry:
 	rc = smb_init(SMB_COM_QUERY_INFORMATION, 0, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -3200,7 +3199,7 @@ QInfRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QueryInfo = %d", rc));
+		cFYI(1, "Send error in QueryInfo = %d", rc);
 	} else if (pFinfo) {
 		struct timespec ts;
 		__u32 time = le32_to_cpu(pSMBr->last_write_time);
@@ -3248,7 +3247,7 @@ CIFSSMBQPathInfo(const int xid, struct cifsTconInfo *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-/* cFYI(1, ("In QPathInfo path %s", searchName)); */
+/* cFYI(1, "In QPathInfo path %s", searchName); */
 QPathInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -3298,7 +3297,7 @@ QPathInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QPathInfo = %d", rc));
+		cFYI(1, "Send error in QPathInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -3348,7 +3347,7 @@ CIFSSMBUnixQPathInfo(const int xid, struct cifsTconInfo *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In QPathInfo (Unix) the path %s", searchName));
+	cFYI(1, "In QPathInfo (Unix) the path %s", searchName);
 UnixQPathInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -3395,14 +3394,14 @@ UnixQPathInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QPathInfo = %d", rc));
+		cFYI(1, "Send error in QPathInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 		if (rc || (pSMBr->ByteCount < sizeof(FILE_UNIX_BASIC_INFO))) {
-			cERROR(1, ("Malformed FILE_UNIX_BASIC_INFO response.\n"
+			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response.\n"
 				   "Unix Extensions can be disabled on mount "
-				   "by specifying the nosfu mount option."));
+				   "by specifying the nosfu mount option.");
 			rc = -EIO;	/* bad smb */
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -3436,7 +3435,7 @@ CIFSFindFirst(const int xid, struct cifsTconInfo *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In FindFirst for %s", searchName));
+	cFYI(1, "In FindFirst for %s", searchName);
 
 findFirstRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -3513,7 +3512,7 @@ findFirstRetry:
 	if (rc) {/* BB add logic to retry regular search if Unix search
 			rejected unexpectedly by server */
 		/* BB Add code to handle unsupported level rc */
-		cFYI(1, ("Error in FindFirst = %d", rc));
+		cFYI(1, "Error in FindFirst = %d", rc);
 
 		cifs_buf_release(pSMB);
 
@@ -3552,7 +3551,7 @@ findFirstRetry:
 			lnoff = le16_to_cpu(parms->LastNameOffset);
 			if (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE <
 			      lnoff) {
-				cERROR(1, ("ignoring corrupt resume name"));
+				cERROR(1, "ignoring corrupt resume name");
 				psrch_inf->last_entry = NULL;
 				return rc;
 			}
@@ -3580,7 +3579,7 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
 	int bytes_returned, name_len;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In FindNext"));
+	cFYI(1, "In FindNext");
 
 	if (psrch_inf->endOfSearch)
 		return -ENOENT;
@@ -3644,7 +3643,7 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
 			cifs_buf_release(pSMB);
 			rc = 0; /* search probably was closed at end of search*/
 		} else
-			cFYI(1, ("FindNext returned = %d", rc));
+			cFYI(1, "FindNext returned = %d", rc);
 	} else {                /* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -3680,15 +3679,15 @@ int CIFSFindNext(const int xid, struct cifsTconInfo *tcon,
 			lnoff = le16_to_cpu(parms->LastNameOffset);
 			if (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE <
 			      lnoff) {
-				cERROR(1, ("ignoring corrupt resume name"));
+				cERROR(1, "ignoring corrupt resume name");
 				psrch_inf->last_entry = NULL;
 				return rc;
 			} else
 				psrch_inf->last_entry =
 					psrch_inf->srch_entries_start + lnoff;
 
-/*  cFYI(1,("fnxt2 entries in buf %d index_of_last %d",
-	    psrch_inf->entries_in_buffer, psrch_inf->index_of_last_entry)); */
+/*  cFYI(1, "fnxt2 entries in buf %d index_of_last %d",
+	    psrch_inf->entries_in_buffer, psrch_inf->index_of_last_entry); */
 
 			/* BB fixme add unlock here */
 		}
@@ -3713,7 +3712,7 @@ CIFSFindClose(const int xid, struct cifsTconInfo *tcon,
 	int rc = 0;
 	FINDCLOSE_REQ *pSMB = NULL;
 
-	cFYI(1, ("In CIFSSMBFindClose"));
+	cFYI(1, "In CIFSSMBFindClose");
 	rc = small_smb_init(SMB_COM_FIND_CLOSE2, 1, tcon, (void **)&pSMB);
 
 	/* no sense returning error if session restarted
@@ -3727,7 +3726,7 @@ CIFSFindClose(const int xid, struct cifsTconInfo *tcon,
 	pSMB->ByteCount = 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
 	if (rc)
-		cERROR(1, ("Send error in FindClose = %d", rc));
+		cERROR(1, "Send error in FindClose = %d", rc);
 
 	cifs_stats_inc(&tcon->num_fclose);
 
@@ -3750,7 +3749,7 @@ CIFSGetSrvInodeNumber(const int xid, struct cifsTconInfo *tcon,
 	int name_len, bytes_returned;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In GetSrvInodeNum for %s", searchName));
+	cFYI(1, "In GetSrvInodeNum for %s", searchName);
 	if (tcon == NULL)
 		return -ENODEV;
 
@@ -3800,7 +3799,7 @@ GetInodeNumberRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("error %d in QueryInternalInfo", rc));
+		cFYI(1, "error %d in QueryInternalInfo", rc);
 	} else {
 		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -3815,7 +3814,7 @@ GetInodeNumberRetry:
 			struct file_internal_info *pfinfo;
 			/* BB Do we need a cast or hash here ? */
 			if (count < 8) {
-				cFYI(1, ("Illegal size ret in QryIntrnlInf"));
+				cFYI(1, "Illegal size ret in QryIntrnlInf");
 				rc = -EIO;
 				goto GetInodeNumOut;
 			}
@@ -3856,16 +3855,16 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 	*num_of_nodes = le16_to_cpu(pSMBr->NumberOfReferrals);
 
 	if (*num_of_nodes < 1) {
-		cERROR(1, ("num_referrals: must be at least > 0,"
-			"but we get num_referrals = %d\n", *num_of_nodes));
+		cERROR(1, "num_referrals: must be at least > 0,"
+			"but we get num_referrals = %d\n", *num_of_nodes);
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
 	}
 
 	ref = (struct dfs_referral_level_3 *) &(pSMBr->referrals);
 	if (ref->VersionNumber != cpu_to_le16(3)) {
-		cERROR(1, ("Referrals of V%d version are not supported,"
-			"should be V3", le16_to_cpu(ref->VersionNumber)));
+		cERROR(1, "Referrals of V%d version are not supported,"
+			"should be V3", le16_to_cpu(ref->VersionNumber));
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
 	}
@@ -3874,14 +3873,14 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 	data_end = (char *)(&(pSMBr->PathConsumed)) +
 				le16_to_cpu(pSMBr->t2.DataCount);
 
-	cFYI(1, ("num_referrals: %d dfs flags: 0x%x ... \n",
+	cFYI(1, "num_referrals: %d dfs flags: 0x%x ... \n",
 			*num_of_nodes,
-			le32_to_cpu(pSMBr->DFSFlags)));
+			le32_to_cpu(pSMBr->DFSFlags));
 
 	*target_nodes = kzalloc(sizeof(struct dfs_info3_param) *
 			*num_of_nodes, GFP_KERNEL);
 	if (*target_nodes == NULL) {
-		cERROR(1, ("Failed to allocate buffer for target_nodes\n"));
+		cERROR(1, "Failed to allocate buffer for target_nodes\n");
 		rc = -ENOMEM;
 		goto parse_DFS_referrals_exit;
 	}
@@ -3957,7 +3956,7 @@ CIFSGetDFSRefer(const int xid, struct cifsSesInfo *ses,
 	*num_of_nodes = 0;
 	*target_nodes = NULL;
 
-	cFYI(1, ("In GetDFSRefer the path %s", searchName));
+	cFYI(1, "In GetDFSRefer the path %s", searchName);
 	if (ses == NULL)
 		return -ENODEV;
 getDFSRetry:
@@ -4024,7 +4023,7 @@ getDFSRetry:
 	rc = SendReceive(xid, ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in GetDFSRefer = %d", rc));
+		cFYI(1, "Send error in GetDFSRefer = %d", rc);
 		goto GetDFSRefExit;
 	}
 	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -4035,9 +4034,9 @@ getDFSRetry:
 		goto GetDFSRefExit;
 	}
 
-	cFYI(1, ("Decoding GetDFSRefer response BCC: %d  Offset %d",
+	cFYI(1, "Decoding GetDFSRefer response BCC: %d  Offset %d",
 				pSMBr->ByteCount,
-				le16_to_cpu(pSMBr->t2.DataOffset)));
+				le16_to_cpu(pSMBr->t2.DataOffset));
 
 	/* parse returned result into more usable form */
 	rc = parse_DFS_referrals(pSMBr, num_of_nodes,
@@ -4065,7 +4064,7 @@ SMBOldQFSInfo(const int xid, struct cifsTconInfo *tcon, struct kstatfs *FSData)
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, ("OldQFSInfo"));
+	cFYI(1, "OldQFSInfo");
 oldQFSInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		(void **) &pSMBr);
@@ -4098,7 +4097,7 @@ oldQFSInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QFSInfo = %d", rc));
+		cFYI(1, "Send error in QFSInfo = %d", rc);
 	} else {                /* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4106,8 +4105,8 @@ oldQFSInfoRetry:
 			rc = -EIO;      /* bad smb */
 		else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
-			cFYI(1, ("qfsinf resp BCC: %d  Offset %d",
-				 pSMBr->ByteCount, data_offset));
+			cFYI(1, "qfsinf resp BCC: %d  Offset %d",
+				 pSMBr->ByteCount, data_offset);
 
 			response_data = (FILE_SYSTEM_ALLOC_INFO *)
 				(((char *) &pSMBr->hdr.Protocol) + data_offset);
@@ -4119,11 +4118,10 @@ oldQFSInfoRetry:
 			       le32_to_cpu(response_data->TotalAllocationUnits);
 			FSData->f_bfree = FSData->f_bavail =
 				le32_to_cpu(response_data->FreeAllocationUnits);
-			cFYI(1,
-			     ("Blocks: %lld  Free: %lld Block size %ld",
-			      (unsigned long long)FSData->f_blocks,
-			      (unsigned long long)FSData->f_bfree,
-			      FSData->f_bsize));
+			cFYI(1, "Blocks: %lld  Free: %lld Block size %ld",
+			     (unsigned long long)FSData->f_blocks,
+			     (unsigned long long)FSData->f_bfree,
+			     FSData->f_bsize);
 		}
 	}
 	cifs_buf_release(pSMB);
@@ -4145,7 +4143,7 @@ CIFSSMBQFSInfo(const int xid, struct cifsTconInfo *tcon, struct kstatfs *FSData)
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In QFSInfo"));
+	cFYI(1, "In QFSInfo");
 QFSInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4178,7 +4176,7 @@ QFSInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QFSInfo = %d", rc));
+		cFYI(1, "Send error in QFSInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4199,11 +4197,10 @@ QFSInfoRetry:
 			    le64_to_cpu(response_data->TotalAllocationUnits);
 			FSData->f_bfree = FSData->f_bavail =
 			    le64_to_cpu(response_data->FreeAllocationUnits);
-			cFYI(1,
-			     ("Blocks: %lld  Free: %lld Block size %ld",
-			      (unsigned long long)FSData->f_blocks,
-			      (unsigned long long)FSData->f_bfree,
-			      FSData->f_bsize));
+			cFYI(1, "Blocks: %lld  Free: %lld Block size %ld",
+			     (unsigned long long)FSData->f_blocks,
+			     (unsigned long long)FSData->f_bfree,
+			     FSData->f_bsize);
 		}
 	}
 	cifs_buf_release(pSMB);
@@ -4225,7 +4222,7 @@ CIFSSMBQFSAttributeInfo(const int xid, struct cifsTconInfo *tcon)
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In QFSAttributeInfo"));
+	cFYI(1, "In QFSAttributeInfo");
 QFSAttributeRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4259,7 +4256,7 @@ QFSAttributeRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cERROR(1, ("Send error in QFSAttributeInfo = %d", rc));
+		cERROR(1, "Send error in QFSAttributeInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4295,7 +4292,7 @@ CIFSSMBQFSDeviceInfo(const int xid, struct cifsTconInfo *tcon)
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In QFSDeviceInfo"));
+	cFYI(1, "In QFSDeviceInfo");
 QFSDeviceRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4330,7 +4327,7 @@ QFSDeviceRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QFSDeviceInfo = %d", rc));
+		cFYI(1, "Send error in QFSDeviceInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4365,7 +4362,7 @@ CIFSSMBQFSUnixInfo(const int xid, struct cifsTconInfo *tcon)
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In QFSUnixInfo"));
+	cFYI(1, "In QFSUnixInfo");
 QFSUnixRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4399,7 +4396,7 @@ QFSUnixRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cERROR(1, ("Send error in QFSUnixInfo = %d", rc));
+		cERROR(1, "Send error in QFSUnixInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4434,7 +4431,7 @@ CIFSSMBSetFSUnixInfo(const int xid, struct cifsTconInfo *tcon, __u64 cap)
 	int bytes_returned = 0;
 	__u16 params, param_offset, offset, byte_count;
 
-	cFYI(1, ("In SETFSUnixInfo"));
+	cFYI(1, "In SETFSUnixInfo");
 SETFSUnixRetry:
 	/* BB switch to small buf init to save memory */
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -4482,7 +4479,7 @@ SETFSUnixRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cERROR(1, ("Send error in SETFSUnixInfo = %d", rc));
+		cERROR(1, "Send error in SETFSUnixInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 		if (rc)
@@ -4510,7 +4507,7 @@ CIFSSMBQFSPosixInfo(const int xid, struct cifsTconInfo *tcon,
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, ("In QFSPosixInfo"));
+	cFYI(1, "In QFSPosixInfo");
 QFSPosixRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4544,7 +4541,7 @@ QFSPosixRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QFSUnixInfo = %d", rc));
+		cFYI(1, "Send error in QFSUnixInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4604,7 +4601,7 @@ CIFSSMBSetEOF(const int xid, struct cifsTconInfo *tcon, const char *fileName,
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
 
-	cFYI(1, ("In SetEOF"));
+	cFYI(1, "In SetEOF");
 SetEOFRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4670,7 +4667,7 @@ SetEOFRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, ("SetPathInfo (file size) returned %d", rc));
+		cFYI(1, "SetPathInfo (file size) returned %d", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -4690,8 +4687,8 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
 	int rc = 0;
 	__u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, ("SetFileSize (via SetFileInfo) %lld",
-			(long long)size));
+	cFYI(1, "SetFileSize (via SetFileInfo) %lld",
+			(long long)size);
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -4750,9 +4747,7 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
 	if (rc) {
-		cFYI(1,
-		     ("Send error in SetFileInfo (SetFileSize) = %d",
-		      rc));
+		cFYI(1, "Send error in SetFileInfo (SetFileSize) = %d", rc);
 	}
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
@@ -4776,7 +4771,7 @@ CIFSSMBSetFileInfo(const int xid, struct cifsTconInfo *tcon,
 	int rc = 0;
 	__u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, ("Set Times (via SetFileInfo)"));
+	cFYI(1, "Set Times (via SetFileInfo)");
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -4821,7 +4816,7 @@ CIFSSMBSetFileInfo(const int xid, struct cifsTconInfo *tcon,
 	memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
 	if (rc)
-		cFYI(1, ("Send error in Set Time (SetFileInfo) = %d", rc));
+		cFYI(1, "Send error in Set Time (SetFileInfo) = %d", rc);
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
 		since file handle passed in no longer valid */
@@ -4838,7 +4833,7 @@ CIFSSMBSetFileDisposition(const int xid, struct cifsTconInfo *tcon,
 	int rc = 0;
 	__u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, ("Set File Disposition (via SetFileInfo)"));
+	cFYI(1, "Set File Disposition (via SetFileInfo)");
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -4880,7 +4875,7 @@ CIFSSMBSetFileDisposition(const int xid, struct cifsTconInfo *tcon,
 	*data_offset = delete_file ? 1 : 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
 	if (rc)
-		cFYI(1, ("Send error in SetFileDisposition = %d", rc));
+		cFYI(1, "Send error in SetFileDisposition = %d", rc);
 
 	return rc;
 }
@@ -4898,7 +4893,7 @@ CIFSSMBSetPathInfo(const int xid, struct cifsTconInfo *tcon,
 	char *data_offset;
 	__u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, ("In SetTimes"));
+	cFYI(1, "In SetTimes");
 
 SetTimesRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -4954,7 +4949,7 @@ SetTimesRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, ("SetPathInfo (times) returned %d", rc));
+		cFYI(1, "SetPathInfo (times) returned %d", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -4979,7 +4974,7 @@ CIFSSMBSetAttrLegacy(int xid, struct cifsTconInfo *tcon, char *fileName,
 	int bytes_returned;
 	int name_len;
 
-	cFYI(1, ("In SetAttrLegacy"));
+	cFYI(1, "In SetAttrLegacy");
 
 SetAttrLgcyRetry:
 	rc = smb_init(SMB_COM_SETATTR, 8, tcon, (void **) &pSMB,
@@ -5005,7 +5000,7 @@ SetAttrLgcyRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, ("Error in LegacySetAttr = %d", rc));
+		cFYI(1, "Error in LegacySetAttr = %d", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -5067,7 +5062,7 @@ CIFSSMBUnixSetFileInfo(const int xid, struct cifsTconInfo *tcon,
 	int rc = 0;
 	u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, ("Set Unix Info (via SetFileInfo)"));
+	cFYI(1, "Set Unix Info (via SetFileInfo)");
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -5112,7 +5107,7 @@ CIFSSMBUnixSetFileInfo(const int xid, struct cifsTconInfo *tcon,
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr *) pSMB, 0);
 	if (rc)
-		cFYI(1, ("Send error in Set Time (SetFileInfo) = %d", rc));
+		cFYI(1, "Send error in Set Time (SetFileInfo) = %d", rc);
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
 		since file handle passed in no longer valid */
@@ -5133,7 +5128,7 @@ CIFSSMBUnixSetPathInfo(const int xid, struct cifsTconInfo *tcon, char *fileName,
 	FILE_UNIX_BASIC_INFO *data_offset;
 	__u16 params, param_offset, offset, count, byte_count;
 
-	cFYI(1, ("In SetUID/GID/Mode"));
+	cFYI(1, "In SetUID/GID/Mode");
 setPermsRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -5189,7 +5184,7 @@ setPermsRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, ("SetPathInfo (perms) returned %d", rc));
+		cFYI(1, "SetPathInfo (perms) returned %d", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -5208,7 +5203,7 @@ int CIFSSMBNotify(const int xid, struct cifsTconInfo *tcon,
 	struct dir_notify_req *dnotify_req;
 	int bytes_returned;
 
-	cFYI(1, ("In CIFSSMBNotify for file handle %d", (int)netfid));
+	cFYI(1, "In CIFSSMBNotify for file handle %d", (int)netfid);
 	rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
 	if (rc)
@@ -5242,7 +5237,7 @@ int CIFSSMBNotify(const int xid, struct cifsTconInfo *tcon,
 			 (struct smb_hdr *)pSMBr, &bytes_returned,
 			 CIFS_ASYNC_OP);
 	if (rc) {
-		cFYI(1, ("Error in Notify = %d", rc));
+		cFYI(1, "Error in Notify = %d", rc);
 	} else {
 		/* Add file to outstanding requests */
 		/* BB change to kmem cache alloc */
@@ -5298,7 +5293,7 @@ CIFSSMBQAllEAs(const int xid, struct cifsTconInfo *tcon,
 	char *end_of_smb;
 	__u16 params, byte_count, data_offset;
 
-	cFYI(1, ("In Query All EAs path %s", searchName));
+	cFYI(1, "In Query All EAs path %s", searchName);
 QAllEAsRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -5345,7 +5340,7 @@ QAllEAsRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, ("Send error in QueryAllEAs = %d", rc));
+		cFYI(1, "Send error in QueryAllEAs = %d", rc);
 		goto QAllEAsOut;
 	}
 
@@ -5373,16 +5368,16 @@ QAllEAsRetry:
 				(((char *) &pSMBr->hdr.Protocol) + data_offset);
 
 	list_len = le32_to_cpu(ea_response_data->list_len);
-	cFYI(1, ("ea length %d", list_len));
+	cFYI(1, "ea length %d", list_len);
 	if (list_len <= 8) {
-		cFYI(1, ("empty EA list returned from server"));
+		cFYI(1, "empty EA list returned from server");
 		goto QAllEAsOut;
 	}
 
 	/* make sure list_len doesn't go past end of SMB */
 	end_of_smb = (char *)pByteArea(&pSMBr->hdr) + BCC(&pSMBr->hdr);
 	if ((char *)ea_response_data + list_len > end_of_smb) {
-		cFYI(1, ("EA list appears to go beyond SMB"));
+		cFYI(1, "EA list appears to go beyond SMB");
 		rc = -EIO;
 		goto QAllEAsOut;
 	}
@@ -5399,7 +5394,7 @@ QAllEAsRetry:
 		temp_ptr += 4;
 		/* make sure we can read name_len and value_len */
 		if (list_len < 0) {
-			cFYI(1, ("EA entry goes beyond length of list"));
+			cFYI(1, "EA entry goes beyond length of list");
 			rc = -EIO;
 			goto QAllEAsOut;
 		}
@@ -5408,7 +5403,7 @@ QAllEAsRetry:
 		value_len = le16_to_cpu(temp_fea->value_len);
 		list_len -= name_len + 1 + value_len;
 		if (list_len < 0) {
-			cFYI(1, ("EA entry goes beyond length of list"));
+			cFYI(1, "EA entry goes beyond length of list");
 			rc = -EIO;
 			goto QAllEAsOut;
 		}
@@ -5475,7 +5470,7 @@ CIFSSMBSetEA(const int xid, struct cifsTconInfo *tcon, const char *fileName,
 	int bytes_returned = 0;
 	__u16 params, param_offset, byte_count, offset, count;
 
-	cFYI(1, ("In SetEA"));
+	cFYI(1, "In SetEA");
 SetEARetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -5557,7 +5552,7 @@ SetEARetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, ("SetPathInfo (EA) returned %d", rc));
+		cFYI(1, "SetPathInfo (EA) returned %d", rc);
 
 	cifs_buf_release(pSMB);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 45eb6cb..5614715 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -134,7 +134,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	spin_unlock(&GlobalMid_Lock);
 	server->maxBuf = 0;
 
-	cFYI(1, ("Reconnecting tcp session"));
+	cFYI(1, "Reconnecting tcp session");
 
 	/* before reconnecting the tcp session, mark the smb session (uid)
 		and the tid bad so they are not used until reconnected */
@@ -152,12 +152,12 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	/* do not want to be sending data on a socket we are freeing */
 	mutex_lock(&server->srv_mutex);
 	if (server->ssocket) {
-		cFYI(1, ("State: 0x%x Flags: 0x%lx", server->ssocket->state,
-			server->ssocket->flags));
+		cFYI(1, "State: 0x%x Flags: 0x%lx", server->ssocket->state,
+			server->ssocket->flags);
 		kernel_sock_shutdown(server->ssocket, SHUT_WR);
-		cFYI(1, ("Post shutdown state: 0x%x Flags: 0x%lx",
+		cFYI(1, "Post shutdown state: 0x%x Flags: 0x%lx",
 			server->ssocket->state,
-			server->ssocket->flags));
+			server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
 	}
@@ -186,7 +186,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		else
 			rc = ipv4_connect(server);
 		if (rc) {
-			cFYI(1, ("reconnect error %d", rc));
+			cFYI(1, "reconnect error %d", rc);
 			msleep(3000);
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
@@ -222,7 +222,7 @@ static int check2ndT2(struct smb_hdr *pSMB, unsigned int maxBufSize)
 	/* check for plausible wct, bcc and t2 data and parm sizes */
 	/* check for parm and data offset going beyond end of smb */
 	if (pSMB->WordCount != 10) { /* coalesce_t2 depends on this */
-		cFYI(1, ("invalid transact2 word count"));
+		cFYI(1, "invalid transact2 word count");
 		return -EINVAL;
 	}
 
@@ -236,15 +236,15 @@ static int check2ndT2(struct smb_hdr *pSMB, unsigned int maxBufSize)
 	if (remaining == 0)
 		return 0;
 	else if (remaining < 0) {
-		cFYI(1, ("total data %d smaller than data in frame %d",
-			total_data_size, data_in_this_rsp));
+		cFYI(1, "total data %d smaller than data in frame %d",
+			total_data_size, data_in_this_rsp);
 		return -EINVAL;
 	} else {
-		cFYI(1, ("missing %d bytes from transact2, check next response",
-			remaining));
+		cFYI(1, "missing %d bytes from transact2, check next response",
+			remaining);
 		if (total_data_size > maxBufSize) {
-			cERROR(1, ("TotalDataSize %d is over maximum buffer %d",
-				total_data_size, maxBufSize));
+			cERROR(1, "TotalDataSize %d is over maximum buffer %d",
+				total_data_size, maxBufSize);
 			return -EINVAL;
 		}
 		return remaining;
@@ -266,7 +266,7 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	total_data_size = le16_to_cpu(pSMBt->t2_rsp.TotalDataCount);
 
 	if (total_data_size != le16_to_cpu(pSMB2->t2_rsp.TotalDataCount)) {
-		cFYI(1, ("total data size of primary and secondary t2 differ"));
+		cFYI(1, "total data size of primary and secondary t2 differ");
 	}
 
 	total_in_buf = le16_to_cpu(pSMBt->t2_rsp.DataCount);
@@ -281,7 +281,7 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 
 	total_in_buf2 = le16_to_cpu(pSMB2->t2_rsp.DataCount);
 	if (remaining < total_in_buf2) {
-		cFYI(1, ("transact2 2nd response contains too much data"));
+		cFYI(1, "transact2 2nd response contains too much data");
 	}
 
 	/* find end of first SMB data area */
@@ -310,7 +310,7 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 	pTargetSMB->smb_buf_length = byte_count;
 
 	if (remaining == total_in_buf2) {
-		cFYI(1, ("found the last secondary response"));
+		cFYI(1, "found the last secondary response");
 		return 0; /* we are done */
 	} else /* more responses to go */
 		return 1;
@@ -338,7 +338,7 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 	int reconnect;
 
 	current->flags |= PF_MEMALLOC;
-	cFYI(1, ("Demultiplex PID: %d", task_pid_nr(current)));
+	cFYI(1, "Demultiplex PID: %d", task_pid_nr(current));
 
 	length = atomic_inc_return(&tcpSesAllocCount);
 	if (length > 1)
@@ -352,7 +352,7 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 		if (bigbuf == NULL) {
 			bigbuf = cifs_buf_get();
 			if (!bigbuf) {
-				cERROR(1, ("No memory for large SMB response"));
+				cERROR(1, "No memory for large SMB response");
 				msleep(3000);
 				/* retry will check if exiting */
 				continue;
@@ -365,7 +365,7 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 		if (smallbuf == NULL) {
 			smallbuf = cifs_small_buf_get();
 			if (!smallbuf) {
-				cERROR(1, ("No memory for SMB response"));
+				cERROR(1, "No memory for SMB response");
 				msleep(1000);
 				/* retry will check if exiting */
 				continue;
@@ -390,9 +390,9 @@ incomplete_rcv:
 		if (server->tcpStatus == CifsExiting) {
 			break;
 		} else if (server->tcpStatus == CifsNeedReconnect) {
-			cFYI(1, ("Reconnect after server stopped responding"));
+			cFYI(1, "Reconnect after server stopped responding");
 			cifs_reconnect(server);
-			cFYI(1, ("call to reconnect done"));
+			cFYI(1, "call to reconnect done");
 			csocket = server->ssocket;
 			continue;
 		} else if ((length == -ERESTARTSYS) || (length == -EAGAIN)) {
@@ -410,7 +410,7 @@ incomplete_rcv:
 				continue;
 		} else if (length <= 0) {
 			if (server->tcpStatus == CifsNew) {
-				cFYI(1, ("tcp session abend after SMBnegprot"));
+				cFYI(1, "tcp session abend after SMBnegprot");
 				/* some servers kill the TCP session rather than
 				   returning an SMB negprot error, in which
 				   case reconnecting here is not going to help,
@@ -418,18 +418,18 @@ incomplete_rcv:
 				break;
 			}
 			if (!try_to_freeze() && (length == -EINTR)) {
-				cFYI(1, ("cifsd thread killed"));
+				cFYI(1, "cifsd thread killed");
 				break;
 			}
-			cFYI(1, ("Reconnect after unexpected peek error %d",
-				length));
+			cFYI(1, "Reconnect after unexpected peek error %d",
+				length);
 			cifs_reconnect(server);
 			csocket = server->ssocket;
 			wake_up(&server->response_q);
 			continue;
 		} else if (length < pdu_length) {
-			cFYI(1, ("requested %d bytes but only got %d bytes",
-				  pdu_length, length));
+			cFYI(1, "requested %d bytes but only got %d bytes",
+				  pdu_length, length);
 			pdu_length -= length;
 			msleep(1);
 			goto incomplete_rcv;
@@ -449,18 +449,18 @@ incomplete_rcv:
 		pdu_length = be32_to_cpu((__force __be32)smb_buffer->smb_buf_length);
 		smb_buffer->smb_buf_length = pdu_length;
 
-		cFYI(1, ("rfc1002 length 0x%x", pdu_length+4));
+		cFYI(1, "rfc1002 length 0x%x", pdu_length+4);
 
 		if (temp == (char) RFC1002_SESSION_KEEP_ALIVE) {
 			continue;
 		} else if (temp == (char)RFC1002_POSITIVE_SESSION_RESPONSE) {
-			cFYI(1, ("Good RFC 1002 session rsp"));
+			cFYI(1, "Good RFC 1002 session rsp");
 			continue;
 		} else if (temp == (char)RFC1002_NEGATIVE_SESSION_RESPONSE) {
 			/* we get this from Windows 98 instead of
 			   an error on SMB negprot response */
-			cFYI(1, ("Negative RFC1002 Session Response Error 0x%x)",
-				pdu_length));
+			cFYI(1, "Negative RFC1002 Session Response Error 0x%x)",
+				pdu_length);
 			if (server->tcpStatus == CifsNew) {
 				/* if nack on negprot (rather than
 				ret of smb negprot error) reconnecting
@@ -483,7 +483,7 @@ incomplete_rcv:
 				continue;
 			}
 		} else if (temp != (char) 0) {
-			cERROR(1, ("Unknown RFC 1002 frame"));
+			cERROR(1, "Unknown RFC 1002 frame");
 			cifs_dump_mem(" Received Data: ", (char *)smb_buffer,
 				      length);
 			cifs_reconnect(server);
@@ -494,8 +494,8 @@ incomplete_rcv:
 		/* else we have an SMB response */
 		if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) ||
 			    (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
-			cERROR(1, ("Invalid size SMB length %d pdu_length %d",
-					length, pdu_length+4));
+			cERROR(1, "Invalid size SMB length %d pdu_length %d",
+					length, pdu_length+4);
 			cifs_reconnect(server);
 			csocket = server->ssocket;
 			wake_up(&server->response_q);
@@ -538,8 +538,8 @@ incomplete_rcv:
 				length = 0;
 				continue;
 			} else if (length <= 0) {
-				cERROR(1, ("Received no data, expecting %d",
-					      pdu_length - total_read));
+				cERROR(1, "Received no data, expecting %d",
+					      pdu_length - total_read);
 				cifs_reconnect(server);
 				csocket = server->ssocket;
 				reconnect = 1;
@@ -587,7 +587,7 @@ incomplete_rcv:
 						}
 					} else {
 						if (!isLargeBuf) {
-							cERROR(1,("1st trans2 resp needs bigbuf"));
+							cERROR(1, "1st trans2 resp needs bigbuf");
 					/* BB maybe we can fix this up,  switch
 					   to already allocated large buffer? */
 						} else {
@@ -629,8 +629,8 @@ multi_t2_fnd:
 			wake_up_process(task_to_wake);
 		} else if (!is_valid_oplock_break(smb_buffer, server) &&
 			   !isMultiRsp) {
-			cERROR(1, ("No task to wake, unknown frame received! "
-				   "NumMids %d", midCount.counter));
+			cERROR(1, "No task to wake, unknown frame received! "
+				   "NumMids %d", midCount.counter);
 			cifs_dump_mem("Received Data is: ", (char *)smb_buffer,
 				      sizeof(struct smb_hdr));
 #ifdef CONFIG_CIFS_DEBUG2
@@ -707,8 +707,8 @@ multi_t2_fnd:
 		list_for_each(tmp, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			if (mid_entry->midState == MID_REQUEST_SUBMITTED) {
-				cFYI(1, ("Clearing Mid 0x%x - waking up ",
-					 mid_entry->mid));
+				cFYI(1, "Clearing Mid 0x%x - waking up ",
+					 mid_entry->mid);
 				task_to_wake = mid_entry->tsk;
 				if (task_to_wake)
 					wake_up_process(task_to_wake);
@@ -727,7 +727,7 @@ multi_t2_fnd:
 		to wait at least 45 seconds before giving up
 		on a request getting a response and going ahead
 		and killing cifsd */
-		cFYI(1, ("Wait for exit from demultiplex thread"));
+		cFYI(1, "Wait for exit from demultiplex thread");
 		msleep(46000);
 		/* if threads still have not exited they are probably never
 		coming home not much else we can do but free the memory */
@@ -848,7 +848,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 			separator[0] = options[4];
 			options += 5;
 		} else {
-			cFYI(1, ("Null separator not allowed"));
+			cFYI(1, "Null separator not allowed");
 		}
 	}
 
@@ -973,7 +973,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 			}
 		} else if (strnicmp(data, "sec", 3) == 0) {
 			if (!value || !*value) {
-				cERROR(1, ("no security value specified"));
+				cERROR(1, "no security value specified");
 				continue;
 			} else if (strnicmp(value, "krb5i", 5) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_KRB5 |
@@ -981,7 +981,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 			} else if (strnicmp(value, "krb5p", 5) == 0) {
 				/* vol->secFlg |= CIFSSEC_MUST_SEAL |
 					CIFSSEC_MAY_KRB5; */
-				cERROR(1, ("Krb5 cifs privacy not supported"));
+				cERROR(1, "Krb5 cifs privacy not supported");
 				return 1;
 			} else if (strnicmp(value, "krb5", 4) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_KRB5;
@@ -1013,7 +1013,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 			} else if (strnicmp(value, "none", 4) == 0) {
 				vol->nullauth = 1;
 			} else {
-				cERROR(1, ("bad security option: %s", value));
+				cERROR(1, "bad security option: %s", value);
 				return 1;
 			}
 		} else if ((strnicmp(data, "unc", 3) == 0)
@@ -1052,7 +1052,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 			a domain name and need special handling? */
 			if (strnlen(value, 256) < 256) {
 				vol->domainname = value;
-				cFYI(1, ("Domain name set"));
+				cFYI(1, "Domain name set");
 			} else {
 				printk(KERN_WARNING "CIFS: domain name too "
 						    "long\n");
@@ -1075,7 +1075,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 					strcpy(vol->prepath+1, value);
 				} else
 					strcpy(vol->prepath, value);
-				cFYI(1, ("prefix path %s", vol->prepath));
+				cFYI(1, "prefix path %s", vol->prepath);
 			} else {
 				printk(KERN_WARNING "CIFS: prefix too long\n");
 				return 1;
@@ -1091,7 +1091,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 					vol->iocharset = value;
 				/* if iocharset not set then load_nls_default
 				   is used by caller */
-				cFYI(1, ("iocharset set to %s", value));
+				cFYI(1, "iocharset set to %s", value);
 			} else {
 				printk(KERN_WARNING "CIFS: iocharset name "
 						    "too long.\n");
@@ -1143,14 +1143,14 @@ cifs_parse_mount_options(char *options, const char *devname,
 			}
 		} else if (strnicmp(data, "sockopt", 5) == 0) {
 			if (!value || !*value) {
-				cERROR(1, ("no socket option specified"));
+				cERROR(1, "no socket option specified");
 				continue;
 			} else if (strnicmp(value, "TCP_NODELAY", 11) == 0) {
 				vol->sockopt_tcp_nodelay = 1;
 			}
 		} else if (strnicmp(data, "netbiosname", 4) == 0) {
 			if (!value || !*value || (*value == ' ')) {
-				cFYI(1, ("invalid (empty) netbiosname"));
+				cFYI(1, "invalid (empty) netbiosname");
 			} else {
 				memset(vol->source_rfc1001_name, 0x20, 15);
 				for (i = 0; i < 15; i++) {
@@ -1174,7 +1174,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 		} else if (strnicmp(data, "servern", 7) == 0) {
 			/* servernetbiosname specified override *SMBSERVER */
 			if (!value || !*value || (*value == ' ')) {
-				cFYI(1, ("empty server netbiosname specified"));
+				cFYI(1, "empty server netbiosname specified");
 			} else {
 				/* last byte, type, is 0x20 for servr type */
 				memset(vol->target_rfc1001_name, 0x20, 16);
@@ -1433,7 +1433,7 @@ cifs_find_tcp_session(struct sockaddr_storage *addr, unsigned short int port)
 
 		++server->srv_count;
 		write_unlock(&cifs_tcp_ses_lock);
-		cFYI(1, ("Existing tcp session with server found"));
+		cFYI(1, "Existing tcp session with server found");
 		return server;
 	}
 	write_unlock(&cifs_tcp_ses_lock);
@@ -1474,7 +1474,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	memset(&addr, 0, sizeof(struct sockaddr_storage));
 
-	cFYI(1, ("UNC: %s ip: %s", volume_info->UNC, volume_info->UNCip));
+	cFYI(1, "UNC: %s ip: %s", volume_info->UNC, volume_info->UNCip);
 
 	if (volume_info->UNCip && volume_info->UNC) {
 		rc = cifs_convert_address(volume_info->UNCip, &addr);
@@ -1486,13 +1486,12 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	} else if (volume_info->UNCip) {
 		/* BB using ip addr as tcp_ses name to connect to the
 		   DFS root below */
-		cERROR(1, ("Connecting to DFS root not implemented yet"));
+		cERROR(1, "Connecting to DFS root not implemented yet");
 		rc = -EINVAL;
 		goto out_err;
 	} else /* which tcp_sess DFS root would we conect to */ {
-		cERROR(1,
-		       ("CIFS mount error: No UNC path (e.g. -o "
-			"unc=//192.168.1.100/public) specified"));
+		cERROR(1, "CIFS mount error: No UNC path (e.g. -o "
+			"unc=//192.168.1.100/public) specified");
 		rc = -EINVAL;
 		goto out_err;
 	}
@@ -1539,7 +1538,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	++tcp_ses->srv_count;
 
 	if (addr.ss_family == AF_INET6) {
-		cFYI(1, ("attempting ipv6 connect"));
+		cFYI(1, "attempting ipv6 connect");
 		/* BB should we allow ipv6 on port 139? */
 		/* other OS never observed in Wild doing 139 with v6 */
 		sin_server6->sin6_port = htons(volume_info->port);
@@ -1553,7 +1552,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		rc = ipv4_connect(tcp_ses);
 	}
 	if (rc < 0) {
-		cERROR(1, ("Error connecting to socket. Aborting operation"));
+		cERROR(1, "Error connecting to socket. Aborting operation");
 		goto out_err;
 	}
 
@@ -1566,7 +1565,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 				  tcp_ses, "cifsd");
 	if (IS_ERR(tcp_ses->tsk)) {
 		rc = PTR_ERR(tcp_ses->tsk);
-		cERROR(1, ("error %d create cifsd thread", rc));
+		cERROR(1, "error %d create cifsd thread", rc);
 		module_put(THIS_MODULE);
 		goto out_err;
 	}
@@ -1702,8 +1701,7 @@ get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
 		strcpy(temp_unc + 2, pSesInfo->serverName);
 		strcpy(temp_unc + 2 + strlen(pSesInfo->serverName), "\\IPC$");
 		rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
-		cFYI(1,
-		     ("CIFS Tcon rc = %d ipc_tid = %d", rc, pSesInfo->ipc_tid));
+		cFYI(1, "CIFS Tcon rc = %d ipc_tid = %d", rc, pSesInfo->ipc_tid);
 		kfree(temp_unc);
 	}
 	if (rc == 0)
@@ -1776,12 +1774,12 @@ ipv4_connect(struct TCP_Server_Info *server)
 		rc = sock_create_kern(PF_INET, SOCK_STREAM,
 				      IPPROTO_TCP, &socket);
 		if (rc < 0) {
-			cERROR(1, ("Error %d creating socket", rc));
+			cERROR(1, "Error %d creating socket", rc);
 			return rc;
 		}
 
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
-		cFYI(1, ("Socket created"));
+		cFYI(1, "Socket created");
 		server->ssocket = socket;
 		socket->sk->sk_allocation = GFP_NOFS;
 		cifs_reclassify_socket4(socket);
@@ -1826,7 +1824,7 @@ ipv4_connect(struct TCP_Server_Info *server)
 	if (!connected) {
 		if (orig_port)
 			server->addr.sockAddr.sin_port = orig_port;
-		cFYI(1, ("Error %d connecting to server via ipv4", rc));
+		cFYI(1, "Error %d connecting to server via ipv4", rc);
 		sock_release(socket);
 		server->ssocket = NULL;
 		return rc;
@@ -1854,12 +1852,12 @@ ipv4_connect(struct TCP_Server_Info *server)
 		rc = kernel_setsockopt(socket, SOL_TCP, TCP_NODELAY,
 				(char *)&val, sizeof(val));
 		if (rc)
-			cFYI(1, ("set TCP_NODELAY socket option error %d", rc));
+			cFYI(1, "set TCP_NODELAY socket option error %d", rc);
 	}
 
-	 cFYI(1, ("sndbuf %d rcvbuf %d rcvtimeo 0x%lx",
+	 cFYI(1, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx",
 		 socket->sk->sk_sndbuf,
-		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo));
+		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
 
 	/* send RFC1001 sessinit */
 	if (server->addr.sockAddr.sin_port == htons(RFC1001_PORT)) {
@@ -1937,13 +1935,13 @@ ipv6_connect(struct TCP_Server_Info *server)
 		rc = sock_create_kern(PF_INET6, SOCK_STREAM,
 				      IPPROTO_TCP, &socket);
 		if (rc < 0) {
-			cERROR(1, ("Error %d creating ipv6 socket", rc));
+			cERROR(1, "Error %d creating ipv6 socket", rc);
 			socket = NULL;
 			return rc;
 		}
 
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
-		cFYI(1, ("ipv6 Socket created"));
+		cFYI(1, "ipv6 Socket created");
 		server->ssocket = socket;
 		socket->sk->sk_allocation = GFP_NOFS;
 		cifs_reclassify_socket6(socket);
@@ -1987,7 +1985,7 @@ ipv6_connect(struct TCP_Server_Info *server)
 	if (!connected) {
 		if (orig_port)
 			server->addr.sockAddr6.sin6_port = orig_port;
-		cFYI(1, ("Error %d connecting to server via ipv6", rc));
+		cFYI(1, "Error %d connecting to server via ipv6", rc);
 		sock_release(socket);
 		server->ssocket = NULL;
 		return rc;
@@ -2006,7 +2004,7 @@ ipv6_connect(struct TCP_Server_Info *server)
 		rc = kernel_setsockopt(socket, SOL_TCP, TCP_NODELAY,
 				(char *)&val, sizeof(val));
 		if (rc)
-			cFYI(1, ("set TCP_NODELAY socket option error %d", rc));
+			cFYI(1, "set TCP_NODELAY socket option error %d", rc);
 	}
 
 	server->ssocket = socket;
@@ -2031,13 +2029,13 @@ void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
 	if (vol_info && vol_info->no_linux_ext) {
 		tcon->fsUnixInfo.Capability = 0;
 		tcon->unix_ext = 0; /* Unix Extensions disabled */
-		cFYI(1, ("Linux protocol extensions disabled"));
+		cFYI(1, "Linux protocol extensions disabled");
 		return;
 	} else if (vol_info)
 		tcon->unix_ext = 1; /* Unix Extensions supported */
 
 	if (tcon->unix_ext == 0) {
-		cFYI(1, ("Unix extensions disabled so not set on reconnect"));
+		cFYI(1, "Unix extensions disabled so not set on reconnect");
 		return;
 	}
 
@@ -2053,12 +2051,11 @@ void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
 				cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
 			if ((saved_cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
 				if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
-					cERROR(1, ("POSIXPATH support change"));
+					cERROR(1, "POSIXPATH support change");
 				cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
 			} else if ((cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
-				cERROR(1, ("possible reconnect error"));
-				cERROR(1,
-					("server disabled POSIX path support"));
+				cERROR(1, "possible reconnect error");
+				cERROR(1, "server disabled POSIX path support");
 			}
 		}
 
@@ -2066,7 +2063,7 @@ void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
 		if (vol_info && vol_info->no_psx_acl)
 			cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
 		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
-			cFYI(1, ("negotiated posix acl support"));
+			cFYI(1, "negotiated posix acl support");
 			if (sb)
 				sb->s_flags |= MS_POSIXACL;
 		}
@@ -2074,7 +2071,7 @@ void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
 		if (vol_info && vol_info->posix_paths == 0)
 			cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
 		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
-			cFYI(1, ("negotiate posix pathnames"));
+			cFYI(1, "negotiate posix pathnames");
 			if (sb)
 				CIFS_SB(sb)->mnt_cifs_flags |=
 					CIFS_MOUNT_POSIX_PATHS;
@@ -2089,39 +2086,38 @@ void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
 		if (sb && (CIFS_SB(sb)->rsize > 127 * 1024)) {
 			if ((cap & CIFS_UNIX_LARGE_READ_CAP) == 0) {
 				CIFS_SB(sb)->rsize = 127 * 1024;
-				cFYI(DBG2,
-					("larger reads not supported by srv"));
+				cFYI(DBG2, "larger reads not supported by srv");
 			}
 		}
 
 
-		cFYI(1, ("Negotiate caps 0x%x", (int)cap));
+		cFYI(1, "Negotiate caps 0x%x", (int)cap);
 #ifdef CONFIG_CIFS_DEBUG2
 		if (cap & CIFS_UNIX_FCNTL_CAP)
-			cFYI(1, ("FCNTL cap"));
+			cFYI(1, "FCNTL cap");
 		if (cap & CIFS_UNIX_EXTATTR_CAP)
-			cFYI(1, ("EXTATTR cap"));
+			cFYI(1, "EXTATTR cap");
 		if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
-			cFYI(1, ("POSIX path cap"));
+			cFYI(1, "POSIX path cap");
 		if (cap & CIFS_UNIX_XATTR_CAP)
-			cFYI(1, ("XATTR cap"));
+			cFYI(1, "XATTR cap");
 		if (cap & CIFS_UNIX_POSIX_ACL_CAP)
-			cFYI(1, ("POSIX ACL cap"));
+			cFYI(1, "POSIX ACL cap");
 		if (cap & CIFS_UNIX_LARGE_READ_CAP)
-			cFYI(1, ("very large read cap"));
+			cFYI(1, "very large read cap");
 		if (cap & CIFS_UNIX_LARGE_WRITE_CAP)
-			cFYI(1, ("very large write cap"));
+			cFYI(1, "very large write cap");
 #endif /* CIFS_DEBUG2 */
 		if (CIFSSMBSetFSUnixInfo(xid, tcon, cap)) {
 			if (vol_info == NULL) {
-				cFYI(1, ("resetting capabilities failed"));
+				cFYI(1, "resetting capabilities failed");
 			} else
-				cERROR(1, ("Negotiating Unix capabilities "
+				cERROR(1, "Negotiating Unix capabilities "
 					   "with the server failed.  Consider "
 					   "mounting with the Unix Extensions\n"
 					   "disabled, if problems are found, "
 					   "by specifying the nounix mount "
-					   "option."));
+					   "option.");
 
 		}
 	}
@@ -2151,8 +2147,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 			  struct cifs_sb_info *cifs_sb)
 {
 	if (pvolume_info->rsize > CIFSMaxBufSize) {
-		cERROR(1, ("rsize %d too large, using MaxBufSize",
-			pvolume_info->rsize));
+		cERROR(1, "rsize %d too large, using MaxBufSize",
+			pvolume_info->rsize);
 		cifs_sb->rsize = CIFSMaxBufSize;
 	} else if ((pvolume_info->rsize) &&
 			(pvolume_info->rsize <= CIFSMaxBufSize))
@@ -2161,8 +2157,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->rsize = CIFSMaxBufSize;
 
 	if (pvolume_info->wsize > PAGEVEC_SIZE * PAGE_CACHE_SIZE) {
-		cERROR(1, ("wsize %d too large, using 4096 instead",
-			  pvolume_info->wsize));
+		cERROR(1, "wsize %d too large, using 4096 instead",
+			  pvolume_info->wsize);
 		cifs_sb->wsize = 4096;
 	} else if (pvolume_info->wsize)
 		cifs_sb->wsize = pvolume_info->wsize;
@@ -2180,7 +2176,7 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 	if (cifs_sb->rsize < 2048) {
 		cifs_sb->rsize = 2048;
 		/* Windows ME may prefer this */
-		cFYI(1, ("readsize set to minimum: 2048"));
+		cFYI(1, "readsize set to minimum: 2048");
 	}
 	/* calculate prepath */
 	cifs_sb->prepath = pvolume_info->prepath;
@@ -2198,8 +2194,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 	cifs_sb->mnt_gid = pvolume_info->linux_gid;
 	cifs_sb->mnt_file_mode = pvolume_info->file_mode;
 	cifs_sb->mnt_dir_mode = pvolume_info->dir_mode;
-	cFYI(1, ("file mode: 0x%x  dir mode: 0x%x",
-		cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode));
+	cFYI(1, "file mode: 0x%x  dir mode: 0x%x",
+		cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
 
 	if (pvolume_info->noperm)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
@@ -2228,13 +2224,13 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 	if (pvolume_info->dynperm)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
 	if (pvolume_info->direct_io) {
-		cFYI(1, ("mounting share using direct i/o"));
+		cFYI(1, "mounting share using direct i/o");
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
 	}
 
 	if ((pvolume_info->cifs_acl) && (pvolume_info->dynperm))
-		cERROR(1, ("mount option dynperm ignored if cifsacl "
-			   "mount option supported"));
+		cERROR(1, "mount option dynperm ignored if cifsacl "
+			   "mount option supported");
 }
 
 static int
@@ -2343,11 +2339,11 @@ try_mount_again:
 	}
 
 	if (volume_info->nullauth) {
-		cFYI(1, ("null user"));
+		cFYI(1, "null user");
 		volume_info->username = "";
 	} else if (volume_info->username) {
 		/* BB fixme parse for domain name here */
-		cFYI(1, ("Username: %s", volume_info->username));
+		cFYI(1, "Username: %s", volume_info->username);
 	} else {
 		cifserror("No username specified");
 	/* In userspace mount helper we can get user name from alternate
@@ -2364,8 +2360,8 @@ try_mount_again:
 	} else {
 		cifs_sb->local_nls = load_nls(volume_info->iocharset);
 		if (cifs_sb->local_nls == NULL) {
-			cERROR(1, ("CIFS mount error: iocharset %s not found",
-				 volume_info->iocharset));
+			cERROR(1, "CIFS mount error: iocharset %s not found",
+				 volume_info->iocharset);
 			rc = -ELIBACC;
 			goto out;
 		}
@@ -2380,8 +2376,8 @@ try_mount_again:
 
 	pSesInfo = cifs_find_smb_ses(srvTcp, volume_info->username);
 	if (pSesInfo) {
-		cFYI(1, ("Existing smb sess found (status=%d)",
-			pSesInfo->status));
+		cFYI(1, "Existing smb sess found (status=%d)",
+			pSesInfo->status);
 		/*
 		 * The existing SMB session already has a reference to srvTcp,
 		 * so we can put back the extra one we got before
@@ -2390,13 +2386,13 @@ try_mount_again:
 
 		mutex_lock(&pSesInfo->session_mutex);
 		if (pSesInfo->need_reconnect) {
-			cFYI(1, ("Session needs reconnect"));
+			cFYI(1, "Session needs reconnect");
 			rc = cifs_setup_session(xid, pSesInfo,
 						cifs_sb->local_nls);
 		}
 		mutex_unlock(&pSesInfo->session_mutex);
 	} else if (!rc) {
-		cFYI(1, ("Existing smb sess not found"));
+		cFYI(1, "Existing smb sess not found");
 		pSesInfo = sesInfoAlloc();
 		if (pSesInfo == NULL) {
 			rc = -ENOMEM;
@@ -2451,12 +2447,12 @@ try_mount_again:
 
 		tcon = cifs_find_tcon(pSesInfo, volume_info->UNC);
 		if (tcon) {
-			cFYI(1, ("Found match on UNC path"));
+			cFYI(1, "Found match on UNC path");
 			/* existing tcon already has a reference */
 			cifs_put_smb_ses(pSesInfo);
 			if (tcon->seal != volume_info->seal)
-				cERROR(1, ("transport encryption setting "
-					   "conflicts with existing tid"));
+				cERROR(1, "transport encryption setting "
+					   "conflicts with existing tid");
 		} else {
 			tcon = tconInfoAlloc();
 			if (tcon == NULL) {
@@ -2476,7 +2472,7 @@ try_mount_again:
 
 			if ((strchr(volume_info->UNC + 3, '\\') == NULL)
 			    && (strchr(volume_info->UNC + 3, '/') == NULL)) {
-				cERROR(1, ("Missing share name"));
+				cERROR(1, "Missing share name");
 				rc = -ENODEV;
 				goto mount_fail_check;
 			} else {
@@ -2485,11 +2481,11 @@ try_mount_again:
 				 * we do on SessSetup and reconnect? */
 				rc = CIFSTCon(xid, pSesInfo, volume_info->UNC,
 					      tcon, cifs_sb->local_nls);
-				cFYI(1, ("CIFS Tcon rc = %d", rc));
+				cFYI(1, "CIFS Tcon rc = %d", rc);
 				if (volume_info->nodfs) {
 					tcon->Flags &= ~SMB_SHARE_IS_IN_DFS;
-					cFYI(1, ("DFS disabled (%d)",
-						tcon->Flags));
+					cFYI(1, "DFS disabled (%d)",
+						tcon->Flags);
 				}
 			}
 			if (rc)
@@ -2543,7 +2539,7 @@ try_mount_again:
 
 	if ((tcon->unix_ext == 0) && (cifs_sb->rsize > (1024 * 127))) {
 		cifs_sb->rsize = 1024 * 127;
-		cFYI(DBG2, ("no very large read support, rsize now 127K"));
+		cFYI(DBG2, "no very large read support, rsize now 127K");
 	}
 	if (!(tcon->ses->capabilities & CAP_LARGE_WRITE_X))
 		cifs_sb->wsize = min(cifs_sb->wsize,
@@ -2592,7 +2588,7 @@ remote_path_check:
 			goto mount_fail_check;
 		}
 
-		cFYI(1, ("Getting referral for: %s", full_path));
+		cFYI(1, "Getting referral for: %s", full_path);
 		rc = get_dfs_path(xid, pSesInfo , full_path + 1,
 			cifs_sb->local_nls, &num_referrals, &referrals,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
@@ -2777,13 +2773,13 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 		if (length == 3) {
 			if ((bcc_ptr[0] == 'I') && (bcc_ptr[1] == 'P') &&
 			    (bcc_ptr[2] == 'C')) {
-				cFYI(1, ("IPC connection"));
+				cFYI(1, "IPC connection");
 				tcon->ipc = 1;
 			}
 		} else if (length == 2) {
 			if ((bcc_ptr[0] == 'A') && (bcc_ptr[1] == ':')) {
 				/* the most common case */
-				cFYI(1, ("disk share connection"));
+				cFYI(1, "disk share connection");
 			}
 		}
 		bcc_ptr += length + 1;
@@ -2796,7 +2792,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 						      bytes_left, is_unicode,
 						      nls_codepage);
 
-		cFYI(1, ("nativeFileSystem=%s", tcon->nativeFileSystem));
+		cFYI(1, "nativeFileSystem=%s", tcon->nativeFileSystem);
 
 		if ((smb_buffer_response->WordCount == 3) ||
 			 (smb_buffer_response->WordCount == 7))
@@ -2804,7 +2800,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 			tcon->Flags = le16_to_cpu(pSMBr->OptionalSupport);
 		else
 			tcon->Flags = 0;
-		cFYI(1, ("Tcon flags: 0x%x ", tcon->Flags));
+		cFYI(1, "Tcon flags: 0x%x ", tcon->Flags);
 	} else if ((rc == 0) && tcon == NULL) {
 		/* all we need to save for IPC$ connection */
 		ses->ipc_tid = smb_buffer_response->Tid;
@@ -2868,14 +2864,14 @@ int cifs_setup_session(unsigned int xid, struct cifsSesInfo *pSesInfo,
 	if (linuxExtEnabled == 0)
 		pSesInfo->capabilities &= (~CAP_UNIX);
 
-	cFYI(1, ("Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d",
-		 server->secMode, server->capabilities, server->timeAdj));
+	cFYI(1, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d",
+		 server->secMode, server->capabilities, server->timeAdj);
 
 	rc = CIFS_SessSetup(xid, pSesInfo, first_time, nls_info);
 	if (rc) {
-		cERROR(1, ("Send error in SessSetup = %d", rc));
+		cERROR(1, "Send error in SessSetup = %d", rc);
 	} else {
-		cFYI(1, ("CIFS Session Established successfully"));
+		cFYI(1, "CIFS Session Established successfully");
 		spin_lock(&GlobalMid_Lock);
 		pSesInfo->status = CifsGood;
 		pSesInfo->need_reconnect = false;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6ccf726..09db5d6 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -73,7 +73,7 @@ cifs_bp_rename_retry:
 		namelen += (1 + temp->d_name.len);
 		temp = temp->d_parent;
 		if (temp == NULL) {
-			cERROR(1, ("corrupt dentry"));
+			cERROR(1, "corrupt dentry");
 			return NULL;
 		}
 	}
@@ -90,19 +90,18 @@ cifs_bp_rename_retry:
 			full_path[namelen] = dirsep;
 			strncpy(full_path + namelen + 1, temp->d_name.name,
 				temp->d_name.len);
-			cFYI(0, ("name: %s", full_path + namelen));
+			cFYI(0, "name: %s", full_path + namelen);
 		}
 		temp = temp->d_parent;
 		if (temp == NULL) {
-			cERROR(1, ("corrupt dentry"));
+			cERROR(1, "corrupt dentry");
 			kfree(full_path);
 			return NULL;
 		}
 	}
 	if (namelen != pplen + dfsplen) {
-		cERROR(1,
-		       ("did not end path lookup where expected namelen is %d",
-			namelen));
+		cERROR(1, "did not end path lookup where expected namelen is %d",
+			namelen);
 		/* presumably this is only possible if racing with a rename
 		of one of the parent directories  (we can not lock the dentries
 		above us to prevent this, but retrying should be harmless) */
@@ -173,7 +172,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 		if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
 			pCifsInode->clientCanCacheAll = true;
 			pCifsInode->clientCanCacheRead = true;
-			cFYI(1, ("Exclusive Oplock inode %p", newinode));
+			cFYI(1, "Exclusive Oplock inode %p", newinode);
 		} else if ((oplock & 0xF) == OPLOCK_READ)
 				pCifsInode->clientCanCacheRead = true;
 	}
@@ -192,7 +191,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(mnt->mnt_sb);
 	struct cifs_fattr fattr;
 
-	cFYI(1, ("posix open %s", full_path));
+	cFYI(1, "posix open %s", full_path);
 
 	presp_data = kzalloc(sizeof(FILE_UNIX_BASIC_INFO), GFP_KERNEL);
 	if (presp_data == NULL)
@@ -358,7 +357,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 		else if ((oflags & O_CREAT) == O_CREAT)
 			disposition = FILE_OPEN_IF;
 		else
-			cFYI(1, ("Create flag not set in create function"));
+			cFYI(1, "Create flag not set in create function");
 	}
 
 	/* BB add processing to set equivalent of mode - e.g. via CreateX with
@@ -394,7 +393,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	}
 	if (rc) {
-		cFYI(1, ("cifs_create returned 0x%x", rc));
+		cFYI(1, "cifs_create returned 0x%x", rc);
 		goto cifs_create_out;
 	}
 
@@ -457,7 +456,7 @@ cifs_create_set_dentry:
 	if (rc == 0)
 		setup_cifs_dentry(tcon, direntry, newinode);
 	else
-		cFYI(1, ("Create worked, get_inode_info failed rc = %d", rc));
+		cFYI(1, "Create worked, get_inode_info failed rc = %d", rc);
 
 	/* nfsd case - nfs srv does not set nd */
 	if ((nd == NULL) || (!(nd->flags & LOOKUP_OPEN))) {
@@ -531,7 +530,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 			u16 fileHandle;
 			FILE_ALL_INFO *buf;
 
-			cFYI(1, ("sfu compat create special file"));
+			cFYI(1, "sfu compat create special file");
 
 			buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 			if (buf == NULL) {
@@ -616,8 +615,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
 	xid = GetXid();
 
-	cFYI(1, ("parent inode = 0x%p name is: %s and dentry = 0x%p",
-	      parent_dir_inode, direntry->d_name.name, direntry));
+	cFYI(1, "parent inode = 0x%p name is: %s and dentry = 0x%p",
+	      parent_dir_inode, direntry->d_name.name, direntry);
 
 	/* check whether path exists */
 
@@ -632,7 +631,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		int i;
 		for (i = 0; i < direntry->d_name.len; i++)
 			if (direntry->d_name.name[i] == '\\') {
-				cFYI(1, ("Invalid file name"));
+				cFYI(1, "Invalid file name");
 				FreeXid(xid);
 				return ERR_PTR(-EINVAL);
 			}
@@ -657,11 +656,11 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	}
 
 	if (direntry->d_inode != NULL) {
-		cFYI(1, ("non-NULL inode in lookup"));
+		cFYI(1, "non-NULL inode in lookup");
 	} else {
-		cFYI(1, ("NULL inode in lookup"));
+		cFYI(1, "NULL inode in lookup");
 	}
-	cFYI(1, ("Full path: %s inode = 0x%p", full_path, direntry->d_inode));
+	cFYI(1, "Full path: %s inode = 0x%p", full_path, direntry->d_inode);
 
 	/* Posix open is only called (at lookup time) for file create now.
 	 * For opens (rather than creates), because we do not know if it
@@ -723,7 +722,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	/*	if it was once a directory (but how can we tell?) we could do
 		shrink_dcache_parent(direntry); */
 	} else if (rc != -EACCES) {
-		cERROR(1, ("Unexpected lookup error %d", rc));
+		cERROR(1, "Unexpected lookup error %d", rc);
 		/* We special case check for Access Denied - since that
 		is a common return code */
 	}
@@ -742,8 +741,8 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 		if (cifs_revalidate(direntry))
 			return 0;
 	} else {
-		cFYI(1, ("neg dentry 0x%p name = %s",
-			 direntry, direntry->d_name.name));
+		cFYI(1, "neg dentry 0x%p name = %s",
+			 direntry, direntry->d_name.name);
 		if (time_after(jiffies, direntry->d_time + HZ) ||
 			!lookupCacheEnabled) {
 			d_drop(direntry);
@@ -758,7 +757,7 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 {
 	int rc = 0;
 
-	cFYI(1, ("In cifs d_delete, name = %s", direntry->d_name.name));
+	cFYI(1, "In cifs d_delete, name = %s", direntry->d_name.name);
 
 	return rc;
 }     */
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 8794814..d9e5e2d 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -105,14 +105,14 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 	/* search for server name delimiter */
 	len = strlen(unc);
 	if (len < 3) {
-		cFYI(1, ("%s: unc is too short: %s", __func__, unc));
+		cFYI(1, "%s: unc is too short: %s", __func__, unc);
 		return -EINVAL;
 	}
 	len -= 2;
 	name = memchr(unc+2, '\\', len);
 	if (!name) {
-		cFYI(1, ("%s: probably server name is whole unc: %s",
-					__func__, unc));
+		cFYI(1, "%s: probably server name is whole unc: %s",
+					__func__, unc);
 	} else {
 		len = (name - unc) - 2/* leading // */;
 	}
@@ -126,8 +126,8 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 	name[len] = 0;
 
 	if (is_ip(name)) {
-		cFYI(1, ("%s: it is IP, skipping dns upcall: %s",
-					__func__, name));
+		cFYI(1, "%s: it is IP, skipping dns upcall: %s",
+					__func__, name);
 		data = name;
 		goto skip_upcall;
 	}
@@ -137,7 +137,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 		len = rkey->type_data.x[0];
 		data = rkey->payload.data;
 	} else {
-		cERROR(1, ("%s: unable to resolve: %s", __func__, name));
+		cERROR(1, "%s: unable to resolve: %s", __func__, name);
 		goto out;
 	}
 
@@ -147,10 +147,10 @@ skip_upcall:
 		if (*ip_addr) {
 			memcpy(*ip_addr, data, len + 1);
 			if (!IS_ERR(rkey))
-				cFYI(1, ("%s: resolved: %s to %s", __func__,
+				cFYI(1, "%s: resolved: %s to %s", __func__,
 							name,
 							*ip_addr
-					));
+					);
 			rc = 0;
 		} else {
 			rc = -ENOMEM;
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
index 6177f7c..993f820 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -49,7 +49,7 @@
 static struct dentry *cifs_get_parent(struct dentry *dentry)
 {
 	/* BB need to add code here eventually to enable export via NFSD */
-	cFYI(1, ("get parent for %p", dentry));
+	cFYI(1, "get parent for %p", dentry);
 	return ERR_PTR(-EACCES);
 }
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 3d8f8a9..5c46a94 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -135,15 +135,15 @@ cifs_posix_open_inode_helper(struct inode *inode, struct file *file,
 	if (timespec_equal(&file->f_path.dentry->d_inode->i_mtime, &temp) &&
 			   (file->f_path.dentry->d_inode->i_size ==
 			    (loff_t)le64_to_cpu(buf->EndOfFile))) {
-		cFYI(1, ("inode unchanged on server"));
+		cFYI(1, "inode unchanged on server");
 	} else {
 		if (file->f_path.dentry->d_inode->i_mapping) {
 			rc = filemap_write_and_wait(file->f_path.dentry->d_inode->i_mapping);
 			if (rc != 0)
 				CIFS_I(file->f_path.dentry->d_inode)->write_behind_rc = rc;
 		}
-		cFYI(1, ("invalidating remote inode since open detected it "
-			 "changed"));
+		cFYI(1, "invalidating remote inode since open detected it "
+			 "changed");
 		invalidate_remote_inode(file->f_path.dentry->d_inode);
 	} */
 
@@ -151,8 +151,8 @@ psx_client_can_cache:
 	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
 		pCifsInode->clientCanCacheAll = true;
 		pCifsInode->clientCanCacheRead = true;
-		cFYI(1, ("Exclusive Oplock granted on inode %p",
-			 file->f_path.dentry->d_inode));
+		cFYI(1, "Exclusive Oplock granted on inode %p",
+			 file->f_path.dentry->d_inode);
 	} else if ((oplock & 0xF) == OPLOCK_READ)
 		pCifsInode->clientCanCacheRead = true;
 
@@ -189,8 +189,8 @@ cifs_fill_filedata(struct file *file)
 	if (file->private_data != NULL) {
 		return pCifsFile;
 	} else if ((file->f_flags & O_CREAT) && (file->f_flags & O_EXCL))
-			cERROR(1, ("could not find file instance for "
-				   "new file %p", file));
+			cERROR(1, "could not find file instance for "
+				   "new file %p", file);
 	return NULL;
 }
 
@@ -216,7 +216,7 @@ static inline int cifs_open_inode_helper(struct inode *inode, struct file *file,
 	if (timespec_equal(&file->f_path.dentry->d_inode->i_mtime, &temp) &&
 			   (file->f_path.dentry->d_inode->i_size ==
 			    (loff_t)le64_to_cpu(buf->EndOfFile))) {
-		cFYI(1, ("inode unchanged on server"));
+		cFYI(1, "inode unchanged on server");
 	} else {
 		if (file->f_path.dentry->d_inode->i_mapping) {
 		/* BB no need to lock inode until after invalidate
@@ -225,8 +225,8 @@ static inline int cifs_open_inode_helper(struct inode *inode, struct file *file,
 			if (rc != 0)
 				CIFS_I(file->f_path.dentry->d_inode)->write_behind_rc = rc;
 		}
-		cFYI(1, ("invalidating remote inode since open detected it "
-			 "changed"));
+		cFYI(1, "invalidating remote inode since open detected it "
+			 "changed");
 		invalidate_remote_inode(file->f_path.dentry->d_inode);
 	}
 
@@ -241,8 +241,8 @@ client_can_cache:
 	if ((*oplock & 0xF) == OPLOCK_EXCLUSIVE) {
 		pCifsInode->clientCanCacheAll = true;
 		pCifsInode->clientCanCacheRead = true;
-		cFYI(1, ("Exclusive Oplock granted on inode %p",
-			 file->f_path.dentry->d_inode));
+		cFYI(1, "Exclusive Oplock granted on inode %p",
+			 file->f_path.dentry->d_inode);
 	} else if ((*oplock & 0xF) == OPLOCK_READ)
 		pCifsInode->clientCanCacheRead = true;
 
@@ -284,8 +284,8 @@ int cifs_open(struct inode *inode, struct file *file)
 		return rc;
 	}
 
-	cFYI(1, ("inode = 0x%p file flags are 0x%x for %s",
-		 inode, file->f_flags, full_path));
+	cFYI(1, "inode = 0x%p file flags are 0x%x for %s",
+		 inode, file->f_flags, full_path);
 
 	if (oplockEnabled)
 		oplock = REQ_OPLOCK;
@@ -302,7 +302,7 @@ int cifs_open(struct inode *inode, struct file *file)
 				     cifs_sb->mnt_file_mode /* ignored */,
 				     oflags, &oplock, &netfid, xid);
 		if (rc == 0) {
-			cFYI(1, ("posix open succeeded"));
+			cFYI(1, "posix open succeeded");
 			/* no need for special case handling of setting mode
 			   on read only files needed here */
 
@@ -312,12 +312,12 @@ int cifs_open(struct inode *inode, struct file *file)
 			goto out;
 		} else if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			if (tcon->ses->serverNOS)
-				cERROR(1, ("server %s of type %s returned"
+				cERROR(1, "server %s of type %s returned"
 					   " unexpected error on SMB posix open"
 					   ", disabling posix open support."
 					   " Check if server update available.",
 					   tcon->ses->serverName,
-					   tcon->ses->serverNOS));
+					   tcon->ses->serverNOS);
 			tcon->broken_posix_open = true;
 		} else if ((rc != -EIO) && (rc != -EREMOTE) &&
 			 (rc != -EOPNOTSUPP)) /* path not found or net err */
@@ -385,7 +385,7 @@ int cifs_open(struct inode *inode, struct file *file)
 				& CIFS_MOUNT_MAP_SPECIAL_CHR);
 	}
 	if (rc) {
-		cFYI(1, ("cifs_open returned 0x%x", rc));
+		cFYI(1, "cifs_open returned 0x%x", rc);
 		goto out;
 	}
 
@@ -468,7 +468,7 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 	}
 
 	if (file->f_path.dentry == NULL) {
-		cERROR(1, ("no valid name if dentry freed"));
+		cERROR(1, "no valid name if dentry freed");
 		dump_stack();
 		rc = -EBADF;
 		goto reopen_error_exit;
@@ -476,7 +476,7 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 
 	inode = file->f_path.dentry->d_inode;
 	if (inode == NULL) {
-		cERROR(1, ("inode not valid"));
+		cERROR(1, "inode not valid");
 		dump_stack();
 		rc = -EBADF;
 		goto reopen_error_exit;
@@ -498,8 +498,8 @@ reopen_error_exit:
 		return rc;
 	}
 
-	cFYI(1, ("inode = 0x%p file flags 0x%x for %s",
-		 inode, file->f_flags, full_path));
+	cFYI(1, "inode = 0x%p file flags 0x%x for %s",
+		 inode, file->f_flags, full_path);
 
 	if (oplockEnabled)
 		oplock = REQ_OPLOCK;
@@ -515,7 +515,7 @@ reopen_error_exit:
 				     cifs_sb->mnt_file_mode /* ignored */,
 				     oflags, &oplock, &netfid, xid);
 		if (rc == 0) {
-			cFYI(1, ("posix reopen succeeded"));
+			cFYI(1, "posix reopen succeeded");
 			goto reopen_success;
 		}
 		/* fallthrough to retry open the old way on errors, especially
@@ -536,8 +536,8 @@ reopen_error_exit:
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
 		mutex_unlock(&pCifsFile->fh_mutex);
-		cFYI(1, ("cifs_open returned 0x%x", rc));
-		cFYI(1, ("oplock: %d", oplock));
+		cFYI(1, "cifs_open returned 0x%x", rc);
+		cFYI(1, "oplock: %d", oplock);
 	} else {
 reopen_success:
 		pCifsFile->netfid = netfid;
@@ -569,8 +569,8 @@ reopen_success:
 			if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
 				pCifsInode->clientCanCacheAll = true;
 				pCifsInode->clientCanCacheRead = true;
-				cFYI(1, ("Exclusive Oplock granted on inode %p",
-					 file->f_path.dentry->d_inode));
+				cFYI(1, "Exclusive Oplock granted on inode %p",
+					 file->f_path.dentry->d_inode);
 			} else if ((oplock & 0xF) == OPLOCK_READ) {
 				pCifsInode->clientCanCacheRead = true;
 				pCifsInode->clientCanCacheAll = false;
@@ -618,8 +618,7 @@ int cifs_close(struct inode *inode, struct file *file)
 					the struct would be in each open file,
 					but this should give enough time to
 					clear the socket */
-					cFYI(DBG2,
-						("close delay, write pending"));
+					cFYI(DBG2, "close delay, write pending");
 					msleep(timeout);
 					timeout *= 4;
 				}
@@ -652,7 +651,7 @@ int cifs_close(struct inode *inode, struct file *file)
 
 	read_lock(&GlobalSMBSeslock);
 	if (list_empty(&(CIFS_I(inode)->openFileList))) {
-		cFYI(1, ("closing last open instance for inode %p", inode));
+		cFYI(1, "closing last open instance for inode %p", inode);
 		/* if the file is not open we do not know if we can cache info
 		   on this inode, much less write behind and read ahead */
 		CIFS_I(inode)->clientCanCacheRead = false;
@@ -673,7 +672,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	    (struct cifsFileInfo *)file->private_data;
 	char *ptmp;
 
-	cFYI(1, ("Closedir inode = 0x%p", inode));
+	cFYI(1, "Closedir inode = 0x%p", inode);
 
 	xid = GetXid();
 
@@ -684,22 +683,22 @@ int cifs_closedir(struct inode *inode, struct file *file)
 
 		pTcon = cifs_sb->tcon;
 
-		cFYI(1, ("Freeing private data in close dir"));
+		cFYI(1, "Freeing private data in close dir");
 		write_lock(&GlobalSMBSeslock);
 		if (!pCFileStruct->srch_inf.endOfSearch &&
 		    !pCFileStruct->invalidHandle) {
 			pCFileStruct->invalidHandle = true;
 			write_unlock(&GlobalSMBSeslock);
 			rc = CIFSFindClose(xid, pTcon, pCFileStruct->netfid);
-			cFYI(1, ("Closing uncompleted readdir with rc %d",
-				 rc));
+			cFYI(1, "Closing uncompleted readdir with rc %d",
+				 rc);
 			/* not much we can do if it fails anyway, ignore rc */
 			rc = 0;
 		} else
 			write_unlock(&GlobalSMBSeslock);
 		ptmp = pCFileStruct->srch_inf.ntwrk_buf_start;
 		if (ptmp) {
-			cFYI(1, ("closedir free smb buf in srch struct"));
+			cFYI(1, "closedir free smb buf in srch struct");
 			pCFileStruct->srch_inf.ntwrk_buf_start = NULL;
 			if (pCFileStruct->srch_inf.smallBuf)
 				cifs_small_buf_release(ptmp);
@@ -747,49 +746,49 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 	rc = -EACCES;
 	xid = GetXid();
 
-	cFYI(1, ("Lock parm: 0x%x flockflags: "
+	cFYI(1, "Lock parm: 0x%x flockflags: "
 		 "0x%x flocktype: 0x%x start: %lld end: %lld",
 		cmd, pfLock->fl_flags, pfLock->fl_type, pfLock->fl_start,
-		pfLock->fl_end));
+		pfLock->fl_end);
 
 	if (pfLock->fl_flags & FL_POSIX)
-		cFYI(1, ("Posix"));
+		cFYI(1, "Posix");
 	if (pfLock->fl_flags & FL_FLOCK)
-		cFYI(1, ("Flock"));
+		cFYI(1, "Flock");
 	if (pfLock->fl_flags & FL_SLEEP) {
-		cFYI(1, ("Blocking lock"));
+		cFYI(1, "Blocking lock");
 		wait_flag = true;
 	}
 	if (pfLock->fl_flags & FL_ACCESS)
-		cFYI(1, ("Process suspended by mandatory locking - "
-			 "not implemented yet"));
+		cFYI(1, "Process suspended by mandatory locking - "
+			 "not implemented yet");
 	if (pfLock->fl_flags & FL_LEASE)
-		cFYI(1, ("Lease on file - not implemented yet"));
+		cFYI(1, "Lease on file - not implemented yet");
 	if (pfLock->fl_flags &
 	    (~(FL_POSIX | FL_FLOCK | FL_SLEEP | FL_ACCESS | FL_LEASE)))
-		cFYI(1, ("Unknown lock flags 0x%x", pfLock->fl_flags));
+		cFYI(1, "Unknown lock flags 0x%x", pfLock->fl_flags);
 
 	if (pfLock->fl_type == F_WRLCK) {
-		cFYI(1, ("F_WRLCK "));
+		cFYI(1, "F_WRLCK ");
 		numLock = 1;
 	} else if (pfLock->fl_type == F_UNLCK) {
-		cFYI(1, ("F_UNLCK"));
+		cFYI(1, "F_UNLCK");
 		numUnlock = 1;
 		/* Check if unlock includes more than
 		one lock range */
 	} else if (pfLock->fl_type == F_RDLCK) {
-		cFYI(1, ("F_RDLCK"));
+		cFYI(1, "F_RDLCK");
 		lockType |= LOCKING_ANDX_SHARED_LOCK;
 		numLock = 1;
 	} else if (pfLock->fl_type == F_EXLCK) {
-		cFYI(1, ("F_EXLCK"));
+		cFYI(1, "F_EXLCK");
 		numLock = 1;
 	} else if (pfLock->fl_type == F_SHLCK) {
-		cFYI(1, ("F_SHLCK"));
+		cFYI(1, "F_SHLCK");
 		lockType |= LOCKING_ANDX_SHARED_LOCK;
 		numLock = 1;
 	} else
-		cFYI(1, ("Unknown type of lock"));
+		cFYI(1, "Unknown type of lock");
 
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	tcon = cifs_sb->tcon;
@@ -832,8 +831,8 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 					 0 /* wait flag */ );
 			pfLock->fl_type = F_UNLCK;
 			if (rc != 0)
-				cERROR(1, ("Error unlocking previously locked "
-					   "range %d during test of lock", rc));
+				cERROR(1, "Error unlocking previously locked "
+					   "range %d during test of lock", rc);
 			rc = 0;
 
 		} else {
@@ -963,9 +962,8 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 
 	pTcon = cifs_sb->tcon;
 
-	/* cFYI(1,
-	   (" write %d bytes to offset %lld of %s", write_size,
-	   *poffset, file->f_path.dentry->d_name.name)); */
+	/* cFYI(1, " write %d bytes to offset %lld of %s", write_size,
+	   *poffset, file->f_path.dentry->d_name.name); */
 
 	if (file->private_data == NULL)
 		return -EBADF;
@@ -1066,8 +1064,8 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 
 	pTcon = cifs_sb->tcon;
 
-	cFYI(1, ("write %zd bytes to offset %lld of %s", write_size,
-	   *poffset, file->f_path.dentry->d_name.name));
+	cFYI(1, "write %zd bytes to offset %lld of %s", write_size,
+	   *poffset, file->f_path.dentry->d_name.name);
 
 	if (file->private_data == NULL)
 		return -EBADF;
@@ -1208,7 +1206,7 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode)
 	it being zero) during stress testcases so we need to check for it */
 
 	if (cifs_inode == NULL) {
-		cERROR(1, ("Null inode passed to cifs_writeable_file"));
+		cERROR(1, "Null inode passed to cifs_writeable_file");
 		dump_stack();
 		return NULL;
 	}
@@ -1252,7 +1250,7 @@ refind_writable:
 			again. Note that it would be bad
 			to hold up writepages here (rather than
 			in caller) with continuous retries */
-			cFYI(1, ("wp failed on reopen file"));
+			cFYI(1, "wp failed on reopen file");
 			read_lock(&GlobalSMBSeslock);
 			/* can not use this handle, no write
 			   pending on this one after all */
@@ -1328,7 +1326,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 		else if (bytes_written < 0)
 			rc = bytes_written;
 	} else {
-		cFYI(1, ("No writeable filehandles for inode"));
+		cFYI(1, "No writeable filehandles for inode");
 		rc = -EIO;
 	}
 
@@ -1500,7 +1498,7 @@ retry:
 			 */
 			open_file = find_writable_file(CIFS_I(mapping->host));
 			if (!open_file) {
-				cERROR(1, ("No writable handles for inode"));
+				cERROR(1, "No writable handles for inode");
 				rc = -EBADF;
 			} else {
 				long_op = cifs_write_timeout(cifsi, offset);
@@ -1513,8 +1511,8 @@ retry:
 				cifs_update_eof(cifsi, offset, bytes_written);
 
 				if (rc || bytes_written < bytes_to_write) {
-					cERROR(1, ("Write2 ret %d, wrote %d",
-						  rc, bytes_written));
+					cERROR(1, "Write2 ret %d, wrote %d",
+						  rc, bytes_written);
 					/* BB what if continued retry is
 					   requested via mount flags? */
 					if (rc == -ENOSPC)
@@ -1575,7 +1573,7 @@ static int cifs_writepage(struct page *page, struct writeback_control *wbc)
 /* BB add check for wbc flags */
 	page_cache_get(page);
 	if (!PageUptodate(page))
-		cFYI(1, ("ppw - page not up to date"));
+		cFYI(1, "ppw - page not up to date");
 
 	/*
 	 * Set the "writeback" flag, and clear "dirty" in the radix tree.
@@ -1604,8 +1602,8 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	int rc;
 	struct inode *inode = mapping->host;
 
-	cFYI(1, ("write_end for page %p from pos %lld with %d bytes",
-		 page, pos, copied));
+	cFYI(1, "write_end for page %p from pos %lld with %d bytes",
+		 page, pos, copied);
 
 	if (PageChecked(page)) {
 		if (copied == len)
@@ -1661,8 +1659,8 @@ int cifs_fsync(struct file *file, struct dentry *dentry, int datasync)
 
 	xid = GetXid();
 
-	cFYI(1, ("Sync file - name: %s datasync: 0x%x",
-		dentry->d_name.name, datasync));
+	cFYI(1, "Sync file - name: %s datasync: 0x%x",
+		dentry->d_name.name, datasync);
 
 	rc = filemap_write_and_wait(inode->i_mapping);
 	if (rc == 0) {
@@ -1686,7 +1684,7 @@ int cifs_fsync(struct file *file, struct dentry *dentry, int datasync)
 	unsigned int rpages = 0;
 	int rc = 0;
 
-	cFYI(1, ("sync page %p",page));
+	cFYI(1, "sync page %p",page);
 	mapping = page->mapping;
 	if (!mapping)
 		return 0;
@@ -1697,7 +1695,7 @@ int cifs_fsync(struct file *file, struct dentry *dentry, int datasync)
 /*	fill in rpages then
 	result = cifs_pagein_inode(inode, index, rpages); */ /* BB finish */
 
-/*	cFYI(1, ("rpages is %d for sync page of Index %ld", rpages, index));
+/*	cFYI(1, "rpages is %d for sync page of Index %ld", rpages, index);
 
 #if 0
 	if (rc < 0)
@@ -1731,7 +1729,7 @@ int cifs_flush(struct file *file, fl_owner_t id)
 		CIFS_I(inode)->write_behind_rc = 0;
 	}
 
-	cFYI(1, ("Flush inode %p file %p rc %d", inode, file, rc));
+	cFYI(1, "Flush inode %p file %p rc %d", inode, file, rc);
 
 	return rc;
 }
@@ -1763,7 +1761,7 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 	open_file = (struct cifsFileInfo *)file->private_data;
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		cFYI(1, ("attempting read on write only file instance"));
+		cFYI(1, "attempting read on write only file instance");
 
 	for (total_read = 0, current_offset = read_data;
 	     read_size > total_read;
@@ -1844,7 +1842,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	open_file = (struct cifsFileInfo *)file->private_data;
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		cFYI(1, ("attempting read on write only file instance"));
+		cFYI(1, "attempting read on write only file instance");
 
 	for (total_read = 0, current_offset = read_data;
 	     read_size > total_read;
@@ -1896,7 +1894,7 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	xid = GetXid();
 	rc = cifs_revalidate(dentry);
 	if (rc) {
-		cFYI(1, ("Validation prior to mmap failed, error=%d", rc));
+		cFYI(1, "Validation prior to mmap failed, error=%d", rc);
 		FreeXid(xid);
 		return rc;
 	}
@@ -1923,7 +1921,7 @@ static void cifs_copy_cache_pages(struct address_space *mapping,
 		if (add_to_page_cache(page, mapping, page->index,
 				      GFP_KERNEL)) {
 			page_cache_release(page);
-			cFYI(1, ("Add page cache failed"));
+			cFYI(1, "Add page cache failed");
 			data += PAGE_CACHE_SIZE;
 			bytes_read -= PAGE_CACHE_SIZE;
 			continue;
@@ -1981,7 +1979,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	pTcon = cifs_sb->tcon;
 
 	pagevec_init(&lru_pvec, 0);
-	cFYI(DBG2, ("rpages: num pages %d", num_pages));
+	cFYI(DBG2, "rpages: num pages %d", num_pages);
 	for (i = 0; i < num_pages; ) {
 		unsigned contig_pages;
 		struct page *tmp_page;
@@ -2014,8 +2012,8 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		/* Read size needs to be in multiples of one page */
 		read_size = min_t(const unsigned int, read_size,
 				  cifs_sb->rsize & PAGE_CACHE_MASK);
-		cFYI(DBG2, ("rpages: read size 0x%x  contiguous pages %d",
-				read_size, contig_pages));
+		cFYI(DBG2, "rpages: read size 0x%x  contiguous pages %d",
+				read_size, contig_pages);
 		rc = -EAGAIN;
 		while (rc == -EAGAIN) {
 			if ((open_file->invalidHandle) &&
@@ -2042,7 +2040,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 			}
 		}
 		if ((rc < 0) || (smb_read_data == NULL)) {
-			cFYI(1, ("Read error in readpages: %d", rc));
+			cFYI(1, "Read error in readpages: %d", rc);
 			break;
 		} else if (bytes_read > 0) {
 			task_io_account_read(bytes_read);
@@ -2065,9 +2063,9 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 				/* break; */
 			}
 		} else {
-			cFYI(1, ("No bytes read (%d) at offset %lld . "
-				 "Cleaning remaining pages from readahead list",
-				 bytes_read, offset));
+			cFYI(1, "No bytes read (%d) at offset %lld . "
+			        "Cleaning remaining pages from readahead list",
+				bytes_read, offset);
 			/* BB turn off caching and do new lookup on
 			   file size at server? */
 			break;
@@ -2112,7 +2110,7 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 	if (rc < 0)
 		goto io_error;
 	else
-		cFYI(1, ("Bytes read %d", rc));
+		cFYI(1, "Bytes read %d", rc);
 
 	file->f_path.dentry->d_inode->i_atime =
 		current_fs_time(file->f_path.dentry->d_inode->i_sb);
@@ -2144,8 +2142,8 @@ static int cifs_readpage(struct file *file, struct page *page)
 		return rc;
 	}
 
-	cFYI(1, ("readpage %p at offset %d 0x%x\n",
-		 page, (int)offset, (int)offset));
+	cFYI(1, "readpage %p at offset %d 0x%x\n",
+		 page, (int)offset, (int)offset);
 
 	rc = cifs_readpage_worker(file, page, &offset);
 
@@ -2215,7 +2213,7 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 	struct page *page;
 	int rc = 0;
 
-	cFYI(1, ("write_begin from %lld len %d", (long long)pos, len));
+	cFYI(1, "write_begin from %lld len %d", (long long)pos, len);
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
@@ -2302,7 +2300,7 @@ cifs_oplock_break(struct slow_work *work)
 			rc = waitrc;
 		if (rc)
 			cinode->write_behind_rc = rc;
-		cFYI(1, ("Oplock flush inode %p rc %d", inode, rc));
+		cFYI(1, "Oplock flush inode %p rc %d", inode, rc);
 	}
 
 	/*
@@ -2314,7 +2312,7 @@ cifs_oplock_break(struct slow_work *work)
 	if (!cfile->closePend && !cfile->oplock_break_cancelled) {
 		rc = CIFSSMBLock(0, cifs_sb->tcon, cfile->netfid, 0, 0, 0, 0,
 				 LOCKING_ANDX_OPLOCK_RELEASE, false);
-		cFYI(1, ("Oplock release rc = %d", rc));
+		cFYI(1, "Oplock release rc = %d", rc);
 	}
 }
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 8bdbc81..dbe1fc7 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -106,8 +106,8 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 	else
 		cifs_i->time = jiffies;
 
-	cFYI(1, ("inode 0x%p old_time=%ld new_time=%ld", inode,
-		 oldtime, cifs_i->time));
+	cFYI(1, "inode 0x%p old_time=%ld new_time=%ld", inode,
+		 oldtime, cifs_i->time);
 
 	cifs_i->delete_pending = fattr->cf_flags & CIFS_FATTR_DELETE_PENDING;
 
@@ -189,7 +189,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 		/* safest to call it a file if we do not know */
 		fattr->cf_mode |= S_IFREG;
 		fattr->cf_dtype = DT_REG;
-		cFYI(1, ("unknown type %d", le32_to_cpu(info->Type)));
+		cFYI(1, "unknown type %d", le32_to_cpu(info->Type));
 		break;
 	}
 
@@ -218,7 +218,7 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	cFYI(1, ("creating fake fattr for DFS referral"));
+	cFYI(1, "creating fake fattr for DFS referral");
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
@@ -242,7 +242,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
 	tcon = cifs_sb->tcon;
-	cFYI(1, ("Getting info on %s", full_path));
+	cFYI(1, "Getting info on %s", full_path);
 
 	/* could have done a find first instead but this returns more info */
 	rc = CIFSSMBUnixQPathInfo(xid, tcon, full_path, &find_data,
@@ -310,7 +310,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 				 &bytes_read, &pbuf, &buf_type);
 		if ((rc == 0) && (bytes_read >= 8)) {
 			if (memcmp("IntxBLK", pbuf, 8) == 0) {
-				cFYI(1, ("Block device"));
+				cFYI(1, "Block device");
 				fattr->cf_mode |= S_IFBLK;
 				fattr->cf_dtype = DT_BLK;
 				if (bytes_read == 24) {
@@ -322,7 +322,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 					fattr->cf_rdev = MKDEV(mjr, mnr);
 				}
 			} else if (memcmp("IntxCHR", pbuf, 8) == 0) {
-				cFYI(1, ("Char device"));
+				cFYI(1, "Char device");
 				fattr->cf_mode |= S_IFCHR;
 				fattr->cf_dtype = DT_CHR;
 				if (bytes_read == 24) {
@@ -334,7 +334,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 					fattr->cf_rdev = MKDEV(mjr, mnr);
 				}
 			} else if (memcmp("IntxLNK", pbuf, 7) == 0) {
-				cFYI(1, ("Symlink"));
+				cFYI(1, "Symlink");
 				fattr->cf_mode |= S_IFLNK;
 				fattr->cf_dtype = DT_LNK;
 			} else {
@@ -376,10 +376,10 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 	else if (rc > 3) {
 		mode = le32_to_cpu(*((__le32 *)ea_value));
 		fattr->cf_mode &= ~SFBITS_MASK;
-		cFYI(1, ("special bits 0%o org mode 0%o", mode,
-			 fattr->cf_mode));
+		cFYI(1, "special bits 0%o org mode 0%o", mode,
+			 fattr->cf_mode);
 		fattr->cf_mode = (mode & SFBITS_MASK) | fattr->cf_mode;
-		cFYI(1, ("special mode bits 0%o", mode));
+		cFYI(1, "special mode bits 0%o", mode);
 	}
 
 	return 0;
@@ -444,11 +444,11 @@ int cifs_get_inode_info(struct inode **pinode,
 	struct cifs_fattr fattr;
 
 	pTcon = cifs_sb->tcon;
-	cFYI(1, ("Getting info on %s", full_path));
+	cFYI(1, "Getting info on %s", full_path);
 
 	if ((pfindData == NULL) && (*pinode != NULL)) {
 		if (CIFS_I(*pinode)->clientCanCacheRead) {
-			cFYI(1, ("No need to revalidate cached inode sizes"));
+			cFYI(1, "No need to revalidate cached inode sizes");
 			return rc;
 		}
 	}
@@ -514,7 +514,7 @@ int cifs_get_inode_info(struct inode **pinode,
 					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 			if (rc1 || !fattr.cf_uniqueid) {
-				cFYI(1, ("GetSrvInodeNum rc %d", rc1));
+				cFYI(1, "GetSrvInodeNum rc %d", rc1);
 				fattr.cf_uniqueid = iunique(sb, ROOT_I);
 				cifs_autodisable_serverino(cifs_sb);
 			}
@@ -530,13 +530,13 @@ int cifs_get_inode_info(struct inode **pinode,
 	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
 		tmprc = cifs_sfu_type(&fattr, full_path, cifs_sb, xid);
 		if (tmprc)
-			cFYI(1, ("cifs_sfu_type failed: %d", tmprc));
+			cFYI(1, "cifs_sfu_type failed: %d", tmprc);
 	}
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	/* fill in 0777 bits from ACL */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
-		cFYI(1, ("Getting mode bits from ACL"));
+		cFYI(1, "Getting mode bits from ACL");
 		cifs_acl_to_fattr(cifs_sb, &fattr, *pinode, full_path, pfid);
 	}
 #endif
@@ -630,7 +630,7 @@ cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
 	unsigned long hash;
 	struct inode *inode;
 
-	cFYI(1, ("looking for uniqueid=%llu", fattr->cf_uniqueid));
+	cFYI(1, "looking for uniqueid=%llu", fattr->cf_uniqueid);
 
 	/* hash down to 32-bits on 32-bit arch */
 	hash = cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
@@ -676,7 +676,7 @@ struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
 		return ERR_PTR(-ENOMEM);
 
 	if (rc && cifs_sb->tcon->ipc) {
-		cFYI(1, ("ipc connection - fake read inode"));
+		cFYI(1, "ipc connection - fake read inode");
 		inode->i_mode |= S_IFDIR;
 		inode->i_nlink = 2;
 		inode->i_op = &cifs_ipc_inode_ops;
@@ -738,7 +738,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
 	 * server times.
 	 */
 	if (set_time && (attrs->ia_valid & ATTR_CTIME)) {
-		cFYI(1, ("CIFS - CTIME changed"));
+		cFYI(1, "CIFS - CTIME changed");
 		info_buf.ChangeTime =
 		    cpu_to_le64(cifs_UnixTimeToNT(attrs->ia_ctime));
 	} else
@@ -773,8 +773,8 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
 			goto out;
 	}
 
-	cFYI(1, ("calling SetFileInfo since SetPathInfo for "
-		 "times not supported by this server"));
+	cFYI(1, "calling SetFileInfo since SetPathInfo for "
+		 "times not supported by this server");
 	rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_OPEN,
 			 SYNCHRONIZE | FILE_WRITE_ATTRIBUTES,
 			 CREATE_NOT_DIR, &netfid, &oplock,
@@ -932,7 +932,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	struct iattr *attrs = NULL;
 	__u32 dosattr = 0, origattr = 0;
 
-	cFYI(1, ("cifs_unlink, dir=0x%p, dentry=0x%p", dir, dentry));
+	cFYI(1, "cifs_unlink, dir=0x%p, dentry=0x%p", dir, dentry);
 
 	xid = GetXid();
 
@@ -951,7 +951,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 		rc = CIFSPOSIXDelFile(xid, tcon, full_path,
 			SMB_POSIX_UNLINK_FILE_TARGET, cifs_sb->local_nls,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-		cFYI(1, ("posix del rc %d", rc));
+		cFYI(1, "posix del rc %d", rc);
 		if ((rc == 0) || (rc == -ENOENT))
 			goto psx_del_no_retry;
 	}
@@ -1025,7 +1025,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 	struct inode *newinode = NULL;
 	struct cifs_fattr fattr;
 
-	cFYI(1, ("In cifs_mkdir, mode = 0x%x inode = 0x%p", mode, inode));
+	cFYI(1, "In cifs_mkdir, mode = 0x%x inode = 0x%p", mode, inode);
 
 	xid = GetXid();
 
@@ -1060,7 +1060,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 			kfree(pInfo);
 			goto mkdir_retry_old;
 		} else if (rc) {
-			cFYI(1, ("posix mkdir returned 0x%x", rc));
+			cFYI(1, "posix mkdir returned 0x%x", rc);
 			d_drop(direntry);
 		} else {
 			if (pInfo->Type == cpu_to_le32(-1)) {
@@ -1086,12 +1086,12 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 			d_instantiate(direntry, newinode);
 
 #ifdef CONFIG_CIFS_DEBUG2
-			cFYI(1, ("instantiated dentry %p %s to inode %p",
-				direntry, direntry->d_name.name, newinode));
+			cFYI(1, "instantiated dentry %p %s to inode %p",
+				direntry, direntry->d_name.name, newinode);
 
 			if (newinode->i_nlink != 2)
-				cFYI(1, ("unexpected number of links %d",
-					newinode->i_nlink));
+				cFYI(1, "unexpected number of links %d",
+					newinode->i_nlink);
 #endif
 		}
 		kfree(pInfo);
@@ -1102,7 +1102,7 @@ mkdir_retry_old:
 	rc = CIFSSMBMkDir(xid, pTcon, full_path, cifs_sb->local_nls,
 			  cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
-		cFYI(1, ("cifs_mkdir returned 0x%x", rc));
+		cFYI(1, "cifs_mkdir returned 0x%x", rc);
 		d_drop(direntry);
 	} else {
 mkdir_get_info:
@@ -1205,7 +1205,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	char *full_path = NULL;
 	struct cifsInodeInfo *cifsInode;
 
-	cFYI(1, ("cifs_rmdir, inode = 0x%p", inode));
+	cFYI(1, "cifs_rmdir, inode = 0x%p", inode);
 
 	xid = GetXid();
 
@@ -1424,10 +1424,10 @@ int cifs_revalidate(struct dentry *direntry)
 		FreeXid(xid);
 		return rc;
 	}
-	cFYI(1, ("Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
+	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
 		 "jiffies %ld", full_path, direntry->d_inode,
 		 direntry->d_inode->i_count.counter, direntry,
-		 direntry->d_time, jiffies));
+		 direntry->d_time, jiffies);
 
 	if (cifsInode->time == 0) {
 		/* was set to zero previously to force revalidate */
@@ -1439,7 +1439,7 @@ int cifs_revalidate(struct dentry *direntry)
 			FreeXid(xid);
 			return rc;
 		} else {
-			cFYI(1, ("Have to revalidate file due to hardlinks"));
+			cFYI(1, "Have to revalidate file due to hardlinks");
 		}
 	}
 
@@ -1451,7 +1451,7 @@ int cifs_revalidate(struct dentry *direntry)
 		rc = cifs_get_inode_info_unix(&direntry->d_inode, full_path,
 					      direntry->d_sb, xid);
 		if (rc) {
-			cFYI(1, ("error on getting revalidate info %d", rc));
+			cFYI(1, "error on getting revalidate info %d", rc);
 /*			if (rc != -ENOENT)
 				rc = 0; */	/* BB should we cache info on
 						   certain errors? */
@@ -1460,7 +1460,7 @@ int cifs_revalidate(struct dentry *direntry)
 		rc = cifs_get_inode_info(&direntry->d_inode, full_path, NULL,
 					 direntry->d_sb, xid, NULL);
 		if (rc) {
-			cFYI(1, ("error on getting revalidate info %d", rc));
+			cFYI(1, "error on getting revalidate info %d", rc);
 /*			if (rc != -ENOENT)
 				rc = 0; */	/* BB should we cache info on
 						   certain errors? */
@@ -1473,7 +1473,7 @@ int cifs_revalidate(struct dentry *direntry)
 
 	if (timespec_equal(&local_mtime, &direntry->d_inode->i_mtime) &&
 	    (local_size == direntry->d_inode->i_size)) {
-		cFYI(1, ("cifs_revalidate - inode unchanged"));
+		cFYI(1, "cifs_revalidate - inode unchanged");
 	} else {
 		/* file may have changed on server */
 		if (cifsInode->clientCanCacheRead) {
@@ -1511,8 +1511,8 @@ int cifs_revalidate(struct dentry *direntry)
 			/* may eventually have to do this for open files too */
 			if (list_empty(&(cifsInode->openFileList))) {
 				/* changed on server - flush read ahead pages */
-				cFYI(1, ("Invalidating read ahead data on "
-					 "closed file"));
+				cFYI(1, "Invalidating read ahead data on "
+					 "closed file");
 				invalidate_remote_inode(direntry->d_inode);
 			}
 		}
@@ -1601,12 +1601,12 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		rc = CIFSSMBSetFileSize(xid, pTcon, attrs->ia_size, nfid,
 					npid, false);
 		cifsFileInfo_put(open_file);
-		cFYI(1, ("SetFSize for attrs rc = %d", rc));
+		cFYI(1, "SetFSize for attrs rc = %d", rc);
 		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			unsigned int bytes_written;
 			rc = CIFSSMBWrite(xid, pTcon, nfid, 0, attrs->ia_size,
 					  &bytes_written, NULL, NULL, 1);
-			cFYI(1, ("Wrt seteof rc %d", rc));
+			cFYI(1, "Wrt seteof rc %d", rc);
 		}
 	} else
 		rc = -EINVAL;
@@ -1620,7 +1620,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 				   false, cifs_sb->local_nls,
 				   cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
-		cFYI(1, ("SetEOF by path (setattrs) rc = %d", rc));
+		cFYI(1, "SetEOF by path (setattrs) rc = %d", rc);
 		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			__u16 netfid;
 			int oplock = 0;
@@ -1637,7 +1637,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 						  attrs->ia_size,
 						  &bytes_written, NULL,
 						  NULL, 1);
-				cFYI(1, ("wrt seteof rc %d", rc));
+				cFYI(1, "wrt seteof rc %d", rc);
 				CIFSSMBClose(xid, pTcon, netfid);
 			}
 		}
@@ -1665,8 +1665,8 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	struct cifs_unix_set_info_args *args = NULL;
 	struct cifsFileInfo *open_file;
 
-	cFYI(1, ("setattr_unix on file %s attrs->ia_valid=0x%x",
-		 direntry->d_name.name, attrs->ia_valid));
+	cFYI(1, "setattr_unix on file %s attrs->ia_valid=0x%x",
+		 direntry->d_name.name, attrs->ia_valid);
 
 	xid = GetXid();
 
@@ -1796,8 +1796,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 
 	xid = GetXid();
 
-	cFYI(1, ("setattr on file %s attrs->iavalid 0x%x",
-		 direntry->d_name.name, attrs->ia_valid));
+	cFYI(1, "setattr on file %s attrs->iavalid 0x%x",
+		 direntry->d_name.name, attrs->ia_valid);
 
 	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) == 0) {
 		/* check if we have permission to change attrs */
@@ -1854,7 +1854,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 		attrs->ia_valid &= ~ATTR_MODE;
 
 	if (attrs->ia_valid & ATTR_MODE) {
-		cFYI(1, ("Mode changed to 0%o", attrs->ia_mode));
+		cFYI(1, "Mode changed to 0%o", attrs->ia_mode);
 		mode = attrs->ia_mode;
 	}
 
@@ -1940,7 +1940,7 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 #if 0
 void cifs_delete_inode(struct inode *inode)
 {
-	cFYI(1, ("In cifs_delete_inode, inode = 0x%p", inode));
+	cFYI(1, "In cifs_delete_inode, inode = 0x%p", inode);
 	/* may have to add back in if and when safe distributed caching of
 	   directories added e.g. via FindNotify */
 }
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index f946506..505926f 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -47,7 +47,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 
 	xid = GetXid();
 
-	cFYI(1, ("ioctl file %p  cmd %u  arg %lu", filep, command, arg));
+	cFYI(1, "ioctl file %p  cmd %u  arg %lu", filep, command, arg);
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
@@ -64,12 +64,12 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 
 	switch (command) {
 		case CIFS_IOC_CHECKUMOUNT:
-			cFYI(1, ("User unmount attempted"));
+			cFYI(1, "User unmount attempted");
 			if (cifs_sb->mnt_uid == current_uid())
 				rc = 0;
 			else {
 				rc = -EACCES;
-				cFYI(1, ("uids do not match"));
+				cFYI(1, "uids do not match");
 			}
 			break;
 #ifdef CONFIG_CIFS_POSIX
@@ -97,11 +97,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 				/* rc= CIFSGetExtAttr(xid,tcon,pSMBFile->netfid,
 					extAttrBits, &ExtAttrMask);*/
 			}
-			cFYI(1, ("set flags not implemented yet"));
+			cFYI(1, "set flags not implemented yet");
 			break;
 #endif /* CONFIG_CIFS_POSIX */
 		default:
-			cFYI(1, ("unsupported ioctl"));
+			cFYI(1, "unsupported ioctl");
 			break;
 	}
 
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index fc1e048..b2cfa41 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -138,7 +138,7 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	if (!full_path)
 		goto out;
 
-	cFYI(1, ("Full path: %s inode = 0x%p", full_path, inode));
+	cFYI(1, "Full path: %s inode = 0x%p", full_path, inode);
 
 	rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
 				     cifs_sb->local_nls);
@@ -177,8 +177,8 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 		return rc;
 	}
 
-	cFYI(1, ("Full path: %s", full_path));
-	cFYI(1, ("symname is %s", symname));
+	cFYI(1, "Full path: %s", full_path);
+	cFYI(1, "symname is %s", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
 	if (pTcon->unix_ext)
@@ -197,8 +197,8 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 						 inode->i_sb, xid, NULL);
 
 		if (rc != 0) {
-			cFYI(1, ("Create symlink ok, getinodeinfo fail rc = %d",
-			      rc));
+			cFYI(1, "Create symlink ok, getinodeinfo fail rc = %d",
+			      rc);
 		} else {
 			if (pTcon->nocase)
 				direntry->d_op = &cifs_ci_dentry_ops;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d147499..1394aa3 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -51,7 +51,7 @@ _GetXid(void)
 	if (GlobalTotalActiveXid > GlobalMaxActiveXid)
 		GlobalMaxActiveXid = GlobalTotalActiveXid;
 	if (GlobalTotalActiveXid > 65000)
-		cFYI(1, ("warning: more than 65000 requests active"));
+		cFYI(1, "warning: more than 65000 requests active");
 	xid = GlobalCurrentXid++;
 	spin_unlock(&GlobalMid_Lock);
 	return xid;
@@ -88,7 +88,7 @@ void
 sesInfoFree(struct cifsSesInfo *buf_to_free)
 {
 	if (buf_to_free == NULL) {
-		cFYI(1, ("Null buffer passed to sesInfoFree"));
+		cFYI(1, "Null buffer passed to sesInfoFree");
 		return;
 	}
 
@@ -126,7 +126,7 @@ void
 tconInfoFree(struct cifsTconInfo *buf_to_free)
 {
 	if (buf_to_free == NULL) {
-		cFYI(1, ("Null buffer passed to tconInfoFree"));
+		cFYI(1, "Null buffer passed to tconInfoFree");
 		return;
 	}
 	atomic_dec(&tconInfoAllocCount);
@@ -166,7 +166,7 @@ void
 cifs_buf_release(void *buf_to_free)
 {
 	if (buf_to_free == NULL) {
-		/* cFYI(1, ("Null buffer passed to cifs_buf_release"));*/
+		/* cFYI(1, "Null buffer passed to cifs_buf_release");*/
 		return;
 	}
 	mempool_free(buf_to_free, cifs_req_poolp);
@@ -202,7 +202,7 @@ cifs_small_buf_release(void *buf_to_free)
 {
 
 	if (buf_to_free == NULL) {
-		cFYI(1, ("Null buffer passed to cifs_small_buf_release"));
+		cFYI(1, "Null buffer passed to cifs_small_buf_release");
 		return;
 	}
 	mempool_free(buf_to_free, cifs_sm_req_poolp);
@@ -345,19 +345,19 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 		/*      with userid/password pairs found on the smb session   */
 		/*	for other target tcp/ip addresses 		BB    */
 				if (current_fsuid() != treeCon->ses->linux_uid) {
-					cFYI(1, ("Multiuser mode and UID "
-						 "did not match tcon uid"));
+					cFYI(1, "Multiuser mode and UID "
+						 "did not match tcon uid");
 					read_lock(&cifs_tcp_ses_lock);
 					list_for_each(temp_item, &treeCon->ses->server->smb_ses_list) {
 						ses = list_entry(temp_item, struct cifsSesInfo, smb_ses_list);
 						if (ses->linux_uid == current_fsuid()) {
 							if (ses->server == treeCon->ses->server) {
-								cFYI(1, ("found matching uid substitute right smb_uid"));
+								cFYI(1, "found matching uid substitute right smb_uid");
 								buffer->Uid = ses->Suid;
 								break;
 							} else {
 				/* BB eventually call cifs_setup_session here */
-								cFYI(1, ("local UID found but no smb sess with this server exists"));
+								cFYI(1, "local UID found but no smb sess with this server exists");
 							}
 						}
 					}
@@ -394,17 +394,16 @@ checkSMBhdr(struct smb_hdr *smb, __u16 mid)
 			if (smb->Command == SMB_COM_LOCKING_ANDX)
 				return 0;
 			else
-				cERROR(1, ("Received Request not response"));
+				cERROR(1, "Received Request not response");
 		}
 	} else { /* bad signature or mid */
 		if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff))
-			cERROR(1,
-			       ("Bad protocol string signature header %x",
-				*(unsigned int *) smb->Protocol));
+			cERROR(1, "Bad protocol string signature header %x",
+				*(unsigned int *) smb->Protocol);
 		if (mid != smb->Mid)
-			cERROR(1, ("Mids do not match"));
+			cERROR(1, "Mids do not match");
 	}
-	cERROR(1, ("bad smb detected. The Mid=%d", smb->Mid));
+	cERROR(1, "bad smb detected. The Mid=%d", smb->Mid);
 	return 1;
 }
 
@@ -413,7 +412,7 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 {
 	__u32 len = smb->smb_buf_length;
 	__u32 clc_len;  /* calculated length */
-	cFYI(0, ("checkSMB Length: 0x%x, smb_buf_length: 0x%x", length, len));
+	cFYI(0, "checkSMB Length: 0x%x, smb_buf_length: 0x%x", length, len);
 
 	if (length < 2 + sizeof(struct smb_hdr)) {
 		if ((length >= sizeof(struct smb_hdr) - 1)
@@ -437,15 +436,15 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 				tmp[sizeof(struct smb_hdr)+1] = 0;
 				return 0;
 			}
-			cERROR(1, ("rcvd invalid byte count (bcc)"));
+			cERROR(1, "rcvd invalid byte count (bcc)");
 		} else {
-			cERROR(1, ("Length less than smb header size"));
+			cERROR(1, "Length less than smb header size");
 		}
 		return 1;
 	}
 	if (len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, ("smb length greater than MaxBufSize, mid=%d",
-				   smb->Mid));
+		cERROR(1, "smb length greater than MaxBufSize, mid=%d",
+				   smb->Mid);
 		return 1;
 	}
 
@@ -454,8 +453,8 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 	clc_len = smbCalcSize_LE(smb);
 
 	if (4 + len != length) {
-		cERROR(1, ("Length read does not match RFC1001 length %d",
-			   len));
+		cERROR(1, "Length read does not match RFC1001 length %d",
+			   len);
 		return 1;
 	}
 
@@ -466,8 +465,8 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 			if (((4 + len) & 0xFFFF) == (clc_len & 0xFFFF))
 				return 0; /* bcc wrapped */
 		}
-		cFYI(1, ("Calculated size %d vs length %d mismatch for mid %d",
-				clc_len, 4 + len, smb->Mid));
+		cFYI(1, "Calculated size %d vs length %d mismatch for mid %d",
+				clc_len, 4 + len, smb->Mid);
 		/* Windows XP can return a few bytes too much, presumably
 		an illegal pad, at the end of byte range lock responses
 		so we allow for that three byte pad, as long as actual
@@ -482,8 +481,8 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 		if ((4+len > clc_len) && (len <= clc_len + 512))
 			return 0;
 		else {
-			cERROR(1, ("RFC1001 size %d bigger than SMB for Mid=%d",
-					len, smb->Mid));
+			cERROR(1, "RFC1001 size %d bigger than SMB for Mid=%d",
+					len, smb->Mid);
 			return 1;
 		}
 	}
@@ -501,7 +500,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 	struct cifsFileInfo *netfile;
 	int rc;
 
-	cFYI(1, ("Checking for oplock break or dnotify response"));
+	cFYI(1, "Checking for oplock break or dnotify response");
 	if ((pSMB->hdr.Command == SMB_COM_NT_TRANSACT) &&
 	   (pSMB->hdr.Flags & SMBFLG_RESPONSE)) {
 		struct smb_com_transaction_change_notify_rsp *pSMBr =
@@ -513,15 +512,15 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 
 			pnotify = (struct file_notify_information *)
 				((char *)&pSMBr->hdr.Protocol + data_offset);
-			cFYI(1, ("dnotify on %s Action: 0x%x",
-				 pnotify->FileName, pnotify->Action));
+			cFYI(1, "dnotify on %s Action: 0x%x",
+				 pnotify->FileName, pnotify->Action);
 			/*   cifs_dump_mem("Rcvd notify Data: ",buf,
 				sizeof(struct smb_hdr)+60); */
 			return true;
 		}
 		if (pSMBr->hdr.Status.CifsError) {
-			cFYI(1, ("notify err 0x%d",
-				pSMBr->hdr.Status.CifsError));
+			cFYI(1, "notify err 0x%d",
+				pSMBr->hdr.Status.CifsError);
 			return true;
 		}
 		return false;
@@ -535,7 +534,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 		   large dirty files cached on the client */
 		if ((NT_STATUS_INVALID_HANDLE) ==
 		   le32_to_cpu(pSMB->hdr.Status.CifsError)) {
-			cFYI(1, ("invalid handle on oplock break"));
+			cFYI(1, "invalid handle on oplock break");
 			return true;
 		} else if (ERRbadfid ==
 		   le16_to_cpu(pSMB->hdr.Status.DosError.Error)) {
@@ -547,8 +546,8 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 	if (pSMB->hdr.WordCount != 8)
 		return false;
 
-	cFYI(1, ("oplock type 0x%d level 0x%d",
-		 pSMB->LockType, pSMB->OplockLevel));
+	cFYI(1, "oplock type 0x%d level 0x%d",
+		 pSMB->LockType, pSMB->OplockLevel);
 	if (!(pSMB->LockType & LOCKING_ANDX_OPLOCK_RELEASE))
 		return false;
 
@@ -579,15 +578,15 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 					return true;
 				}
 
-				cFYI(1, ("file id match, oplock break"));
+				cFYI(1, "file id match, oplock break");
 				pCifsInode = CIFS_I(netfile->pInode);
 				pCifsInode->clientCanCacheAll = false;
 				if (pSMB->OplockLevel == 0)
 					pCifsInode->clientCanCacheRead = false;
 				rc = slow_work_enqueue(&netfile->oplock_break);
 				if (rc) {
-					cERROR(1, ("failed to enqueue oplock "
-						   "break: %d\n", rc));
+					cERROR(1, "failed to enqueue oplock "
+						   "break: %d\n", rc);
 				} else {
 					netfile->oplock_break_cancelled = false;
 				}
@@ -597,12 +596,12 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 			}
 			read_unlock(&GlobalSMBSeslock);
 			read_unlock(&cifs_tcp_ses_lock);
-			cFYI(1, ("No matching file for oplock break"));
+			cFYI(1, "No matching file for oplock break");
 			return true;
 		}
 	}
 	read_unlock(&cifs_tcp_ses_lock);
-	cFYI(1, ("Can not process oplock break for non-existent connection"));
+	cFYI(1, "Can not process oplock break for non-existent connection");
 	return true;
 }
 
@@ -721,11 +720,11 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
-		cERROR(1, ("Autodisabling the use of server inode numbers on "
+		cERROR(1, "Autodisabling the use of server inode numbers on "
 			   "%s. This server doesn't seem to support them "
 			   "properly. Hardlinks will not be recognized on this "
 			   "mount. Consider mounting with the \"noserverino\" "
 			   "option to silence this message.",
-			   cifs_sb->tcon->treeName));
+			   cifs_sb->tcon->treeName);
 	}
 }
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index bd6d689..d35d528 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -149,7 +149,7 @@ cifs_inet_pton(const int address_family, const char *cp, void *dst)
 	else if (address_family == AF_INET6)
 		ret = in6_pton(cp, -1 /* len */, dst , '\\', NULL);
 
-	cFYI(DBG2, ("address conversion returned %d for %s", ret, cp));
+	cFYI(DBG2, "address conversion returned %d for %s", ret, cp);
 	if (ret > 0)
 		ret = 1;
 	return ret;
@@ -870,8 +870,8 @@ map_smb_to_linux_error(struct smb_hdr *smb, int logErr)
 	}
 	/* else ERRHRD class errors or junk  - return EIO */
 
-	cFYI(1, ("Mapping smb error code %d to POSIX err %d",
-		 smberrcode, rc));
+	cFYI(1, "Mapping smb error code %d to POSIX err %d",
+		 smberrcode, rc);
 
 	/* generic corrective action e.g. reconnect SMB session on
 	 * ERRbaduid could be added */
@@ -940,20 +940,20 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 	SMB_TIME *st = (SMB_TIME *)&time;
 	SMB_DATE *sd = (SMB_DATE *)&date;
 
-	cFYI(1, ("date %d time %d", date, time));
+	cFYI(1, "date %d time %d", date, time);
 
 	sec = 2 * st->TwoSeconds;
 	min = st->Minutes;
 	if ((sec > 59) || (min > 59))
-		cERROR(1, ("illegal time min %d sec %d", min, sec));
+		cERROR(1, "illegal time min %d sec %d", min, sec);
 	sec += (min * 60);
 	sec += 60 * 60 * st->Hours;
 	if (st->Hours > 24)
-		cERROR(1, ("illegal hours %d", st->Hours));
+		cERROR(1, "illegal hours %d", st->Hours);
 	days = sd->Day;
 	month = sd->Month;
 	if ((days > 31) || (month > 12)) {
-		cERROR(1, ("illegal date, month %d day: %d", month, days));
+		cERROR(1, "illegal date, month %d day: %d", month, days);
 		if (month > 12)
 			month = 12;
 	}
@@ -979,7 +979,7 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 
 	ts.tv_sec = sec + offset;
 
-	/* cFYI(1,("sec after cnvrt dos to unix time %d",sec)); */
+	/* cFYI(1, "sec after cnvrt dos to unix time %d",sec); */
 
 	ts.tv_nsec = 0;
 	return ts;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index c343b14..d2f93af 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -46,15 +46,15 @@ static void dump_cifs_file_struct(struct file *file, char *label)
 	if (file) {
 		cf = file->private_data;
 		if (cf == NULL) {
-			cFYI(1, ("empty cifs private file data"));
+			cFYI(1, "empty cifs private file data");
 			return;
 		}
 		if (cf->invalidHandle)
-			cFYI(1, ("invalid handle"));
+			cFYI(1, "invalid handle");
 		if (cf->srch_inf.endOfSearch)
-			cFYI(1, ("end of search"));
+			cFYI(1, "end of search");
 		if (cf->srch_inf.emptyDir)
-			cFYI(1, ("empty dir"));
+			cFYI(1, "empty dir");
 	}
 }
 #else
@@ -75,7 +75,7 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 	struct inode *inode;
 	struct super_block *sb = parent->d_inode->i_sb;
 
-	cFYI(1, ("For %s", name->name));
+	cFYI(1, "For %s", name->name);
 
 	if (parent->d_op && parent->d_op->d_hash)
 		parent->d_op->d_hash(parent, name);
@@ -213,7 +213,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
 				fid,
 				cifs_sb->local_nls);
 		if (CIFSSMBClose(xid, ptcon, fid)) {
-			cFYI(1, ("Error closing temporary reparsepoint open)"));
+			cFYI(1, "Error closing temporary reparsepoint open");
 		}
 	}
 }
@@ -251,7 +251,7 @@ static int initiate_cifs_search(const int xid, struct file *file)
 	if (full_path == NULL)
 		return -ENOMEM;
 
-	cFYI(1, ("Full path: %s start at: %lld", full_path, file->f_pos));
+	cFYI(1, "Full path: %s start at: %lld", full_path, file->f_pos);
 
 ffirst_retry:
 	/* test for Unix extensions */
@@ -296,7 +296,7 @@ static int cifs_unicode_bytelen(char *str)
 		if (ustr[len] == 0)
 			return len << 1;
 	}
-	cFYI(1, ("Unicode string longer than PATH_MAX found"));
+	cFYI(1, "Unicode string longer than PATH_MAX found");
 	return len << 1;
 }
 
@@ -313,19 +313,18 @@ static char *nxt_dir_entry(char *old_entry, char *end_of_smb, int level)
 				pfData->FileNameLength;
 	} else
 		new_entry = old_entry + le32_to_cpu(pDirInfo->NextEntryOffset);
-	cFYI(1, ("new entry %p old entry %p", new_entry, old_entry));
+	cFYI(1, "new entry %p old entry %p", new_entry, old_entry);
 	/* validate that new_entry is not past end of SMB */
 	if (new_entry >= end_of_smb) {
-		cERROR(1,
-		      ("search entry %p began after end of SMB %p old entry %p",
-			new_entry, end_of_smb, old_entry));
+		cERROR(1, "search entry %p began after end of SMB %p old entry %p",
+			new_entry, end_of_smb, old_entry);
 		return NULL;
 	} else if (((level == SMB_FIND_FILE_INFO_STANDARD) &&
 		    (new_entry + sizeof(FIND_FILE_STANDARD_INFO) > end_of_smb))
 		  || ((level != SMB_FIND_FILE_INFO_STANDARD) &&
 		   (new_entry + sizeof(FILE_DIRECTORY_INFO) > end_of_smb)))  {
-		cERROR(1, ("search entry %p extends after end of SMB %p",
-			new_entry, end_of_smb));
+		cERROR(1, "search entry %p extends after end of SMB %p",
+			new_entry, end_of_smb);
 		return NULL;
 	} else
 		return new_entry;
@@ -379,8 +378,8 @@ static int cifs_entry_is_dot(char *current_entry, struct cifsFileInfo *cfile)
 		filename = &pFindData->FileName[0];
 		len = pFindData->FileNameLength;
 	} else {
-		cFYI(1, ("Unknown findfirst level %d",
-			 cfile->srch_inf.info_level));
+		cFYI(1, "Unknown findfirst level %d",
+			 cfile->srch_inf.info_level);
 	}
 
 	if (filename) {
@@ -480,7 +479,7 @@ static int cifs_save_resume_key(const char *current_entry,
 		len = (unsigned int)pFindData->FileNameLength;
 		cifsFile->srch_inf.resume_key = pFindData->ResumeKey;
 	} else {
-		cFYI(1, ("Unknown findfirst level %d", level));
+		cFYI(1, "Unknown findfirst level %d", level);
 		return -EINVAL;
 	}
 	cifsFile->srch_inf.resume_name_len = len;
@@ -524,7 +523,7 @@ static int find_cifs_entry(const int xid, struct cifsTconInfo *pTcon,
 	     is_dir_changed(file)) ||
 	   (index_to_find < first_entry_in_buffer)) {
 		/* close and restart search */
-		cFYI(1, ("search backing up - close and restart search"));
+		cFYI(1, "search backing up - close and restart search");
 		write_lock(&GlobalSMBSeslock);
 		if (!cifsFile->srch_inf.endOfSearch &&
 		    !cifsFile->invalidHandle) {
@@ -534,7 +533,7 @@ static int find_cifs_entry(const int xid, struct cifsTconInfo *pTcon,
 		} else
 			write_unlock(&GlobalSMBSeslock);
 		if (cifsFile->srch_inf.ntwrk_buf_start) {
-			cFYI(1, ("freeing SMB ff cache buf on search rewind"));
+			cFYI(1, "freeing SMB ff cache buf on search rewind");
 			if (cifsFile->srch_inf.smallBuf)
 				cifs_small_buf_release(cifsFile->srch_inf.
 						ntwrk_buf_start);
@@ -545,8 +544,8 @@ static int find_cifs_entry(const int xid, struct cifsTconInfo *pTcon,
 		}
 		rc = initiate_cifs_search(xid, file);
 		if (rc) {
-			cFYI(1, ("error %d reinitiating a search on rewind",
-				 rc));
+			cFYI(1, "error %d reinitiating a search on rewind",
+				 rc);
 			return rc;
 		}
 		cifs_save_resume_key(cifsFile->srch_inf.last_entry, cifsFile);
@@ -554,7 +553,7 @@ static int find_cifs_entry(const int xid, struct cifsTconInfo *pTcon,
 
 	while ((index_to_find >= cifsFile->srch_inf.index_of_last_entry) &&
 	      (rc == 0) && !cifsFile->srch_inf.endOfSearch) {
-		cFYI(1, ("calling findnext2"));
+		cFYI(1, "calling findnext2");
 		rc = CIFSFindNext(xid, pTcon, cifsFile->netfid,
 				  &cifsFile->srch_inf);
 		cifs_save_resume_key(cifsFile->srch_inf.last_entry, cifsFile);
@@ -574,7 +573,7 @@ static int find_cifs_entry(const int xid, struct cifsTconInfo *pTcon,
 		first_entry_in_buffer = cifsFile->srch_inf.index_of_last_entry
 					- cifsFile->srch_inf.entries_in_buffer;
 		pos_in_buf = index_to_find - first_entry_in_buffer;
-		cFYI(1, ("found entry - pos_in_buf %d", pos_in_buf));
+		cFYI(1, "found entry - pos_in_buf %d", pos_in_buf);
 
 		for (i = 0; (i < (pos_in_buf)) && (current_entry != NULL); i++) {
 			/* go entry by entry figuring out which is first */
@@ -583,19 +582,19 @@ static int find_cifs_entry(const int xid, struct cifsTconInfo *pTcon,
 		}
 		if ((current_entry == NULL) && (i < pos_in_buf)) {
 			/* BB fixme - check if we should flag this error */
-			cERROR(1, ("reached end of buf searching for pos in buf"
+			cERROR(1, "reached end of buf searching for pos in buf"
 			  " %d index to find %lld rc %d",
-			  pos_in_buf, index_to_find, rc));
+			  pos_in_buf, index_to_find, rc);
 		}
 		rc = 0;
 		*ppCurrentEntry = current_entry;
 	} else {
-		cFYI(1, ("index not in buffer - could not findnext into it"));
+		cFYI(1, "index not in buffer - could not findnext into it");
 		return 0;
 	}
 
 	if (pos_in_buf >= cifsFile->srch_inf.entries_in_buffer) {
-		cFYI(1, ("can not return entries pos_in_buf beyond last"));
+		cFYI(1, "can not return entries pos_in_buf beyond last");
 		*num_to_ret = 0;
 	} else
 		*num_to_ret = cifsFile->srch_inf.entries_in_buffer - pos_in_buf;
@@ -655,12 +654,12 @@ static int cifs_get_name_from_search_buf(struct qstr *pqst,
 		/* one byte length, no name conversion */
 		len = (unsigned int)pFindData->FileNameLength;
 	} else {
-		cFYI(1, ("Unknown findfirst level %d", level));
+		cFYI(1, "Unknown findfirst level %d", level);
 		return -EINVAL;
 	}
 
 	if (len > max_len) {
-		cERROR(1, ("bad search response length %d past smb end", len));
+		cERROR(1, "bad search response length %d past smb end", len);
 		return -EINVAL;
 	}
 
@@ -753,7 +752,7 @@ static int cifs_filldir(char *pfindEntry, struct file *file, filldir_t filldir,
 	 * case already. Why should we be clobbering other errors from it?
 	 */
 	if (rc) {
-		cFYI(1, ("filldir rc = %d", rc));
+		cFYI(1, "filldir rc = %d", rc);
 		rc = -EOVERFLOW;
 	}
 	dput(tmp_dentry);
@@ -785,7 +784,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	case 0:
 		if (filldir(direntry, ".", 1, file->f_pos,
 		     file->f_path.dentry->d_inode->i_ino, DT_DIR) < 0) {
-			cERROR(1, ("Filldir for current dir failed"));
+			cERROR(1, "Filldir for current dir failed");
 			rc = -ENOMEM;
 			break;
 		}
@@ -793,7 +792,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	case 1:
 		if (filldir(direntry, "..", 2, file->f_pos,
 		     file->f_path.dentry->d_parent->d_inode->i_ino, DT_DIR) < 0) {
-			cERROR(1, ("Filldir for parent dir failed"));
+			cERROR(1, "Filldir for parent dir failed");
 			rc = -ENOMEM;
 			break;
 		}
@@ -806,7 +805,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 
 		if (file->private_data == NULL) {
 			rc = initiate_cifs_search(xid, file);
-			cFYI(1, ("initiate cifs search rc %d", rc));
+			cFYI(1, "initiate cifs search rc %d", rc);
 			if (rc) {
 				FreeXid(xid);
 				return rc;
@@ -820,7 +819,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		cifsFile = file->private_data;
 		if (cifsFile->srch_inf.endOfSearch) {
 			if (cifsFile->srch_inf.emptyDir) {
-				cFYI(1, ("End of search, empty dir"));
+				cFYI(1, "End of search, empty dir");
 				rc = 0;
 				break;
 			}
@@ -832,16 +831,16 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		rc = find_cifs_entry(xid, pTcon, file,
 				&current_entry, &num_to_fill);
 		if (rc) {
-			cFYI(1, ("fce error %d", rc));
+			cFYI(1, "fce error %d", rc);
 			goto rddir2_exit;
 		} else if (current_entry != NULL) {
-			cFYI(1, ("entry %lld found", file->f_pos));
+			cFYI(1, "entry %lld found", file->f_pos);
 		} else {
-			cFYI(1, ("could not find entry"));
+			cFYI(1, "could not find entry");
 			goto rddir2_exit;
 		}
-		cFYI(1, ("loop through %d times filling dir for net buf %p",
-			num_to_fill, cifsFile->srch_inf.ntwrk_buf_start));
+		cFYI(1, "loop through %d times filling dir for net buf %p",
+			num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
 		max_len = smbCalcSize((struct smb_hdr *)
 				cifsFile->srch_inf.ntwrk_buf_start);
 		end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
@@ -850,8 +849,8 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
 			if (current_entry == NULL) {
 				/* evaluate whether this case is an error */
-				cERROR(1, ("past SMB end,  num to fill %d i %d",
-					  num_to_fill, i));
+				cERROR(1, "past SMB end,  num to fill %d i %d",
+					  num_to_fill, i);
 				break;
 			}
 			/* if buggy server returns . and .. late do
@@ -866,8 +865,8 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 			file->f_pos++;
 			if (file->f_pos ==
 				cifsFile->srch_inf.index_of_last_entry) {
-				cFYI(1, ("last entry in buf at pos %lld %s",
-					file->f_pos, tmp_buf));
+				cFYI(1, "last entry in buf at pos %lld %s",
+					file->f_pos, tmp_buf);
 				cifs_save_resume_key(current_entry, cifsFile);
 				break;
 			} else
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index aaa9c1c..9e72f84 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -283,7 +283,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifsSesInfo *ses,
 	int len;
 	char *data = *pbcc_area;
 
-	cFYI(1, ("bleft %d", bleft));
+	cFYI(1, "bleft %d", bleft);
 
 	/*
 	 * Windows servers do not always double null terminate their final
@@ -300,7 +300,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifsSesInfo *ses,
 
 	kfree(ses->serverOS);
 	ses->serverOS = cifs_strndup_from_ucs(data, bleft, true, nls_cp);
-	cFYI(1, ("serverOS=%s", ses->serverOS));
+	cFYI(1, "serverOS=%s", ses->serverOS);
 	len = (UniStrnlen((wchar_t *) data, bleft / 2) * 2) + 2;
 	data += len;
 	bleft -= len;
@@ -309,7 +309,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifsSesInfo *ses,
 
 	kfree(ses->serverNOS);
 	ses->serverNOS = cifs_strndup_from_ucs(data, bleft, true, nls_cp);
-	cFYI(1, ("serverNOS=%s", ses->serverNOS));
+	cFYI(1, "serverNOS=%s", ses->serverNOS);
 	len = (UniStrnlen((wchar_t *) data, bleft / 2) * 2) + 2;
 	data += len;
 	bleft -= len;
@@ -318,7 +318,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifsSesInfo *ses,
 
 	kfree(ses->serverDomain);
 	ses->serverDomain = cifs_strndup_from_ucs(data, bleft, true, nls_cp);
-	cFYI(1, ("serverDomain=%s", ses->serverDomain));
+	cFYI(1, "serverDomain=%s", ses->serverDomain);
 
 	return;
 }
@@ -331,7 +331,7 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
 	int len;
 	char *bcc_ptr = *pbcc_area;
 
-	cFYI(1, ("decode sessetup ascii. bleft %d", bleft));
+	cFYI(1, "decode sessetup ascii. bleft %d", bleft);
 
 	len = strnlen(bcc_ptr, bleft);
 	if (len >= bleft)
@@ -343,7 +343,7 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
 	if (ses->serverOS)
 		strncpy(ses->serverOS, bcc_ptr, len);
 	if (strncmp(ses->serverOS, "OS/2", 4) == 0) {
-			cFYI(1, ("OS/2 server"));
+			cFYI(1, "OS/2 server");
 			ses->flags |= CIFS_SES_OS2;
 	}
 
@@ -372,7 +372,7 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
 	/* BB For newer servers which do not support Unicode,
 	   but thus do return domain here we could add parsing
 	   for it later, but it is not very important */
-	cFYI(1, ("ascii: bytes left %d", bleft));
+	cFYI(1, "ascii: bytes left %d", bleft);
 
 	return rc;
 }
@@ -383,16 +383,16 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)bcc_ptr;
 
 	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
-		cERROR(1, ("challenge blob len %d too small", blob_len));
+		cERROR(1, "challenge blob len %d too small", blob_len);
 		return -EINVAL;
 	}
 
 	if (memcmp(pblob->Signature, "NTLMSSP", 8)) {
-		cERROR(1, ("blob signature incorrect %s", pblob->Signature));
+		cERROR(1, "blob signature incorrect %s", pblob->Signature);
 		return -EINVAL;
 	}
 	if (pblob->MessageType != NtLmChallenge) {
-		cERROR(1, ("Incorrect message type %d", pblob->MessageType));
+		cERROR(1, "Incorrect message type %d", pblob->MessageType);
 		return -EINVAL;
 	}
 
@@ -582,7 +582,7 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses, int first_time,
 
 	type = ses->server->secType;
 
-	cFYI(1, ("sess setup type %d", type));
+	cFYI(1, "sess setup type %d", type);
 ssetup_ntlmssp_authenticate:
 	if (phase == NtLmChallenge)
 		phase = NtLmAuthenticate; /* if ntlmssp, now final phase */
@@ -663,7 +663,7 @@ ssetup_ntlmssp_authenticate:
 		changed to do higher than lanman dialect and
 		we reconnected would we ever calc signing_key? */
 
-		cFYI(1, ("Negotiating LANMAN setting up strings"));
+		cFYI(1, "Negotiating LANMAN setting up strings");
 		/* Unicode not allowed for LANMAN dialects */
 		ascii_ssetup_strings(&bcc_ptr, ses, nls_cp);
 #endif
@@ -757,17 +757,17 @@ ssetup_ntlmssp_authenticate:
 		/* check version field to make sure that cifs.upcall is
 		   sending us a response in an expected form */
 		if (msg->version != CIFS_SPNEGO_UPCALL_VERSION) {
-			cERROR(1, ("incorrect version of cifs.upcall (expected"
+			cERROR(1, "incorrect version of cifs.upcall (expected"
 				   " %d but got %d)",
-				   CIFS_SPNEGO_UPCALL_VERSION, msg->version));
+				   CIFS_SPNEGO_UPCALL_VERSION, msg->version);
 			rc = -EKEYREJECTED;
 			goto ssetup_exit;
 		}
 		/* bail out if key is too long */
 		if (msg->sesskey_len >
 		    sizeof(ses->server->mac_signing_key.data.krb5)) {
-			cERROR(1, ("Kerberos signing key too long (%u bytes)",
-				msg->sesskey_len));
+			cERROR(1, "Kerberos signing key too long (%u bytes)",
+				msg->sesskey_len);
 			rc = -EOVERFLOW;
 			goto ssetup_exit;
 		}
@@ -795,7 +795,7 @@ ssetup_ntlmssp_authenticate:
 		/* BB: is this right? */
 			ascii_ssetup_strings(&bcc_ptr, ses, nls_cp);
 #else /* ! CONFIG_CIFS_UPCALL */
-		cERROR(1, ("Kerberos negotiated but upcall support disabled!"));
+		cERROR(1, "Kerberos negotiated but upcall support disabled!");
 		rc = -ENOSYS;
 		goto ssetup_exit;
 #endif /* CONFIG_CIFS_UPCALL */
@@ -803,12 +803,12 @@ ssetup_ntlmssp_authenticate:
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 		if (type == RawNTLMSSP) {
 			if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
-				cERROR(1, ("NTLMSSP requires Unicode support"));
+				cERROR(1, "NTLMSSP requires Unicode support");
 				rc = -ENOSYS;
 				goto ssetup_exit;
 			}
 
-			cFYI(1, ("ntlmssp session setup phase %d", phase));
+			cFYI(1, "ntlmssp session setup phase %d", phase);
 			pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
 			capabilities |= CAP_EXTENDED_SECURITY;
 			pSMB->req.Capabilities |= cpu_to_le32(capabilities);
@@ -826,7 +826,7 @@ ssetup_ntlmssp_authenticate:
 				   on the response (challenge) */
 				smb_buf->Uid = ses->Suid;
 			} else {
-				cERROR(1, ("invalid phase %d", phase));
+				cERROR(1, "invalid phase %d", phase);
 				rc = -ENOSYS;
 				goto ssetup_exit;
 			}
@@ -838,12 +838,12 @@ ssetup_ntlmssp_authenticate:
 			}
 			unicode_oslm_strings(&bcc_ptr, nls_cp);
 		} else {
-			cERROR(1, ("secType %d not supported!", type));
+			cERROR(1, "secType %d not supported!", type);
 			rc = -ENOSYS;
 			goto ssetup_exit;
 		}
 #else
-		cERROR(1, ("secType %d not supported!", type));
+		cERROR(1, "secType %d not supported!", type);
 		rc = -ENOSYS;
 		goto ssetup_exit;
 #endif
@@ -861,7 +861,7 @@ ssetup_ntlmssp_authenticate:
 			  CIFS_STD_OP /* not long */ | CIFS_LOG_ERROR);
 	/* SMB request buf freed in SendReceive2 */
 
-	cFYI(1, ("ssetup rc from sendrecv2 is %d", rc));
+	cFYI(1, "ssetup rc from sendrecv2 is %d", rc);
 
 	pSMB = (SESSION_SETUP_ANDX *)iov[0].iov_base;
 	smb_buf = (struct smb_hdr *)iov[0].iov_base;
@@ -869,7 +869,7 @@ ssetup_ntlmssp_authenticate:
 	if ((type == RawNTLMSSP) && (smb_buf->Status.CifsError ==
 			cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))) {
 		if (phase != NtLmNegotiate) {
-			cERROR(1, ("Unexpected more processing error"));
+			cERROR(1, "Unexpected more processing error");
 			goto ssetup_exit;
 		}
 		/* NTLMSSP Negotiate sent now processing challenge (response) */
@@ -881,14 +881,14 @@ ssetup_ntlmssp_authenticate:
 
 	if ((smb_buf->WordCount != 3) && (smb_buf->WordCount != 4)) {
 		rc = -EIO;
-		cERROR(1, ("bad word count %d", smb_buf->WordCount));
+		cERROR(1, "bad word count %d", smb_buf->WordCount);
 		goto ssetup_exit;
 	}
 	action = le16_to_cpu(pSMB->resp.Action);
 	if (action & GUEST_LOGIN)
-		cFYI(1, ("Guest login")); /* BB mark SesInfo struct? */
+		cFYI(1, "Guest login"); /* BB mark SesInfo struct? */
 	ses->Suid = smb_buf->Uid;   /* UID left in wire format (le) */
-	cFYI(1, ("UID = %d ", ses->Suid));
+	cFYI(1, "UID = %d ", ses->Suid);
 	/* response can have either 3 or 4 word count - Samba sends 3 */
 	/* and lanman response is 3 */
 	bytes_remaining = BCC(smb_buf);
@@ -898,7 +898,7 @@ ssetup_ntlmssp_authenticate:
 		__u16 blob_len;
 		blob_len = le16_to_cpu(pSMB->resp.SecurityBlobLength);
 		if (blob_len > bytes_remaining) {
-			cERROR(1, ("bad security blob length %d", blob_len));
+			cERROR(1, "bad security blob length %d", blob_len);
 			rc = -EINVAL;
 			goto ssetup_exit;
 		}
@@ -932,7 +932,7 @@ ssetup_exit:
 	}
 	kfree(str_area);
 	if (resp_buf_type == CIFS_SMALL_BUFFER) {
-		cFYI(1, ("ssetup freeing small buf %p", iov[0].iov_base));
+		cFYI(1, "ssetup freeing small buf %p", iov[0].iov_base);
 		cifs_small_buf_release(iov[0].iov_base);
 	} else if (resp_buf_type == CIFS_LARGE_BUFFER)
 		cifs_buf_release(iov[0].iov_base);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 07b8e71..2eca41c 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -42,7 +42,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	struct mid_q_entry *temp;
 
 	if (server == NULL) {
-		cERROR(1, ("Null TCP session in AllocMidQEntry"));
+		cERROR(1, "Null TCP session in AllocMidQEntry");
 		return NULL;
 	}
 
@@ -54,7 +54,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 		temp->mid = smb_buffer->Mid;	/* always LE */
 		temp->pid = current->pid;
 		temp->command = smb_buffer->Command;
-		cFYI(1, ("For smb_command %d", temp->command));
+		cFYI(1, "For smb_command %d", temp->command);
 	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
 		/* when mid allocated can be before when sent */
 		temp->when_alloc = jiffies;
@@ -139,7 +139,7 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 		total_len += iov[i].iov_len;
 
 	smb_buffer->smb_buf_length = cpu_to_be32(smb_buffer->smb_buf_length);
-	cFYI(1, ("Sending smb:  total_len %d", total_len));
+	cFYI(1, "Sending smb:  total_len %d", total_len);
 	dump_smb(smb_buffer, len);
 
 	i = 0;
@@ -167,9 +167,8 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 			   reconnect which may clear the network problem.
 			*/
 			if ((i >= 14) || (!server->noblocksnd && (i > 2))) {
-				cERROR(1,
-				   ("sends on sock %p stuck for 15 seconds",
-				    ssocket));
+				cERROR(1, "sends on sock %p stuck for 15 seconds",
+				    ssocket);
 				rc = -EAGAIN;
 				break;
 			}
@@ -183,13 +182,13 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 			total_len = 0;
 			break;
 		} else if (rc > total_len) {
-			cERROR(1, ("sent %d requested %d", rc, total_len));
+			cERROR(1, "sent %d requested %d", rc, total_len);
 			break;
 		}
 		if (rc == 0) {
 			/* should never happen, letting socket clear before
 			   retrying is our only obvious option here */
-			cERROR(1, ("tcp sent no data"));
+			cERROR(1, "tcp sent no data");
 			msleep(500);
 			continue;
 		}
@@ -212,8 +211,8 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	}
 
 	if ((total_len > 0) && (total_len != smb_buf_length + 4)) {
-		cFYI(1, ("partial send (%d remaining), terminating session",
-			total_len));
+		cFYI(1, "partial send (%d remaining), terminating session",
+			total_len);
 		/* If we have only sent part of an SMB then the next SMB
 		   could be taken as the remainder of this one.  We need
 		   to kill the socket so the server throws away the partial
@@ -222,7 +221,7 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	}
 
 	if (rc < 0) {
-		cERROR(1, ("Error %d sending data on socket to server", rc));
+		cERROR(1, "Error %d sending data on socket to server", rc);
 	} else
 		rc = 0;
 
@@ -295,7 +294,7 @@ static int allocate_mid(struct cifsSesInfo *ses, struct smb_hdr *in_buf,
 	}
 
 	if (ses->server->tcpStatus == CifsNeedReconnect) {
-		cFYI(1, ("tcp session dead - return to caller to retry"));
+		cFYI(1, "tcp session dead - return to caller to retry");
 		return -EAGAIN;
 	}
 
@@ -347,7 +346,7 @@ static int wait_for_response(struct cifsSesInfo *ses,
 			lrt += time_to_wait;
 			if (time_after(jiffies, lrt)) {
 				/* No replies for time_to_wait. */
-				cERROR(1, ("server not responding"));
+				cERROR(1, "server not responding");
 				return -1;
 			}
 		} else {
@@ -378,7 +377,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifsSesInfo *ses,
 	iov[0].iov_len = in_buf->smb_buf_length + 4;
 	flags |= CIFS_NO_RESP;
 	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags);
-	cFYI(DBG2, ("SendRcvNoRsp flags %d rc %d", flags, rc));
+	cFYI(DBG2, "SendRcvNoRsp flags %d rc %d", flags, rc);
 
 	return rc;
 }
@@ -401,7 +400,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 
 	if ((ses == NULL) || (ses->server == NULL)) {
 		cifs_small_buf_release(in_buf);
-		cERROR(1, ("Null session"));
+		cERROR(1, "Null session");
 		return -EIO;
 	}
 
@@ -470,7 +469,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	else if (long_op == CIFS_BLOCKING_OP)
 		timeout = 0x7FFFFFFF; /*  large, but not so large as to wrap */
 	else {
-		cERROR(1, ("unknown timeout flag %d", long_op));
+		cERROR(1, "unknown timeout flag %d", long_op);
 		rc = -EIO;
 		goto out;
 	}
@@ -489,8 +488,8 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	spin_lock(&GlobalMid_Lock);
 
 	if (midQ->resp_buf == NULL) {
-		cERROR(1, ("No response to cmd %d mid %d",
-			midQ->command, midQ->mid));
+		cERROR(1, "No response to cmd %d mid %d",
+			midQ->command, midQ->mid);
 		if (midQ->midState == MID_REQUEST_SUBMITTED) {
 			if (ses->server->tcpStatus == CifsExiting)
 				rc = -EHOSTDOWN;
@@ -503,7 +502,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		if (rc != -EHOSTDOWN) {
 			if (midQ->midState == MID_RETRY_NEEDED) {
 				rc = -EAGAIN;
-				cFYI(1, ("marking request for retry"));
+				cFYI(1, "marking request for retry");
 			} else {
 				rc = -EIO;
 			}
@@ -520,8 +519,8 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 	receive_len = midQ->resp_buf->smb_buf_length;
 
 	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
-		cERROR(1, ("Frame too large received.  Length: %d  Xid: %d",
-			receive_len, xid));
+		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
+			receive_len, xid);
 		rc = -EIO;
 		goto out;
 	}
@@ -547,7 +546,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 						&ses->server->mac_signing_key,
 						midQ->sequence_number+1);
 			if (rc) {
-				cERROR(1, ("Unexpected SMB signature"));
+				cERROR(1, "Unexpected SMB signature");
 				/* BB FIXME add code to kill session */
 			}
 		}
@@ -568,7 +567,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 						   DeleteMidQEntry */
 	} else {
 		rc = -EIO;
-		cFYI(1, ("Bad MID state?"));
+		cFYI(1, "Bad MID state?");
 	}
 
 out:
@@ -590,11 +589,11 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 	struct mid_q_entry *midQ;
 
 	if (ses == NULL) {
-		cERROR(1, ("Null smb session"));
+		cERROR(1, "Null smb session");
 		return -EIO;
 	}
 	if (ses->server == NULL) {
-		cERROR(1, ("Null tcp session"));
+		cERROR(1, "Null tcp session");
 		return -EIO;
 	}
 
@@ -606,8 +605,8 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 	   use ses->maxReq */
 
 	if (in_buf->smb_buf_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, ("Illegal length, greater than maximum frame, %d",
-			   in_buf->smb_buf_length));
+		cERROR(1, "Illegal length, greater than maximum frame, %d",
+			   in_buf->smb_buf_length);
 		return -EIO;
 	}
 
@@ -664,7 +663,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 	else if (long_op == CIFS_BLOCKING_OP)
 		timeout = 0x7FFFFFFF; /* large but no so large as to wrap */
 	else {
-		cERROR(1, ("unknown timeout flag %d", long_op));
+		cERROR(1, "unknown timeout flag %d", long_op);
 		rc = -EIO;
 		goto out;
 	}
@@ -680,8 +679,8 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 
 	spin_lock(&GlobalMid_Lock);
 	if (midQ->resp_buf == NULL) {
-		cERROR(1, ("No response for cmd %d mid %d",
-			  midQ->command, midQ->mid));
+		cERROR(1, "No response for cmd %d mid %d",
+			  midQ->command, midQ->mid);
 		if (midQ->midState == MID_REQUEST_SUBMITTED) {
 			if (ses->server->tcpStatus == CifsExiting)
 				rc = -EHOSTDOWN;
@@ -694,7 +693,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		if (rc != -EHOSTDOWN) {
 			if (midQ->midState == MID_RETRY_NEEDED) {
 				rc = -EAGAIN;
-				cFYI(1, ("marking request for retry"));
+				cFYI(1, "marking request for retry");
 			} else {
 				rc = -EIO;
 			}
@@ -711,8 +710,8 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 	receive_len = midQ->resp_buf->smb_buf_length;
 
 	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
-		cERROR(1, ("Frame too large received.  Length: %d  Xid: %d",
-			receive_len, xid));
+		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
+			receive_len, xid);
 		rc = -EIO;
 		goto out;
 	}
@@ -735,7 +734,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 						&ses->server->mac_signing_key,
 						midQ->sequence_number+1);
 			if (rc) {
-				cERROR(1, ("Unexpected SMB signature"));
+				cERROR(1, "Unexpected SMB signature");
 				/* BB FIXME add code to kill session */
 			}
 		}
@@ -752,7 +751,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 			BCC(out_buf) = le16_to_cpu(BCC_LE(out_buf));
 	} else {
 		rc = -EIO;
-		cERROR(1, ("Bad MID state?"));
+		cERROR(1, "Bad MID state?");
 	}
 
 out:
@@ -823,13 +822,13 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 	struct cifsSesInfo *ses;
 
 	if (tcon == NULL || tcon->ses == NULL) {
-		cERROR(1, ("Null smb session"));
+		cERROR(1, "Null smb session");
 		return -EIO;
 	}
 	ses = tcon->ses;
 
 	if (ses->server == NULL) {
-		cERROR(1, ("Null tcp session"));
+		cERROR(1, "Null tcp session");
 		return -EIO;
 	}
 
@@ -841,8 +840,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 	   use ses->maxReq */
 
 	if (in_buf->smb_buf_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, ("Illegal length, greater than maximum frame, %d",
-			   in_buf->smb_buf_length));
+		cERROR(1, "Illegal length, greater than maximum frame, %d",
+			   in_buf->smb_buf_length);
 		return -EIO;
 	}
 
@@ -932,8 +931,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 		spin_unlock(&GlobalMid_Lock);
 		receive_len = midQ->resp_buf->smb_buf_length;
 	} else {
-		cERROR(1, ("No response for cmd %d mid %d",
-			  midQ->command, midQ->mid));
+		cERROR(1, "No response for cmd %d mid %d",
+			  midQ->command, midQ->mid);
 		if (midQ->midState == MID_REQUEST_SUBMITTED) {
 			if (ses->server->tcpStatus == CifsExiting)
 				rc = -EHOSTDOWN;
@@ -946,7 +945,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 		if (rc != -EHOSTDOWN) {
 			if (midQ->midState == MID_RETRY_NEEDED) {
 				rc = -EAGAIN;
-				cFYI(1, ("marking request for retry"));
+				cFYI(1, "marking request for retry");
 			} else {
 				rc = -EIO;
 			}
@@ -957,8 +956,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 	}
 
 	if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
-		cERROR(1, ("Frame too large received.  Length: %d  Xid: %d",
-			receive_len, xid));
+		cERROR(1, "Frame too large received.  Length: %d  Xid: %d",
+			receive_len, xid);
 		rc = -EIO;
 		goto out;
 	}
@@ -967,7 +966,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 
 	if ((out_buf == NULL) || (midQ->midState != MID_RESPONSE_RECEIVED)) {
 		rc = -EIO;
-		cERROR(1, ("Bad MID state?"));
+		cERROR(1, "Bad MID state?");
 		goto out;
 	}
 
@@ -985,7 +984,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 					   &ses->server->mac_signing_key,
 					   midQ->sequence_number+1);
 		if (rc) {
-			cERROR(1, ("Unexpected SMB signature"));
+			cERROR(1, "Unexpected SMB signature");
 			/* BB FIXME add code to kill session */
 		}
 	}
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 3e2ef0d..e6721ec 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -69,12 +69,12 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 		return rc;
 	}
 	if (ea_name == NULL) {
-		cFYI(1, ("Null xattr names not supported"));
+		cFYI(1, "Null xattr names not supported");
 	} else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5)
 		&& (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4))) {
 		cFYI(1,
-		    ("illegal xattr request %s (only user namespace supported)",
-			ea_name));
+		     "illegal xattr request %s (only user namespace supported)",
+		     ea_name);
 		/* BB what if no namespace prefix? */
 		/* Should we just pass them to server, except for
 		system and perhaps security prefixes? */
@@ -130,19 +130,19 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 		search server for EAs or streams to
 		returns as xattrs */
 	if (value_size > MAX_EA_VALUE_SIZE) {
-		cFYI(1, ("size of EA value too large"));
+		cFYI(1, "size of EA value too large");
 		kfree(full_path);
 		FreeXid(xid);
 		return -EOPNOTSUPP;
 	}
 
 	if (ea_name == NULL) {
-		cFYI(1, ("Null xattr names not supported"));
+		cFYI(1, "Null xattr names not supported");
 	} else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto set_ea_exit;
 		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0)
-			cFYI(1, ("attempt to set cifs inode metadata"));
+			cFYI(1, "attempt to set cifs inode metadata");
 
 		ea_name += 5; /* skip past user. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
@@ -168,9 +168,9 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 					ACL_TYPE_ACCESS, cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
-			cFYI(1, ("set POSIX ACL rc %d", rc));
+			cFYI(1, "set POSIX ACL rc %d", rc);
 #else
-			cFYI(1, ("set POSIX ACL not supported"));
+			cFYI(1, "set POSIX ACL not supported");
 #endif
 		} else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
 				   strlen(POSIX_ACL_XATTR_DEFAULT)) == 0) {
@@ -181,13 +181,13 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 					ACL_TYPE_DEFAULT, cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
-			cFYI(1, ("set POSIX default ACL rc %d", rc));
+			cFYI(1, "set POSIX default ACL rc %d", rc);
 #else
-			cFYI(1, ("set default POSIX ACL not supported"));
+			cFYI(1, "set default POSIX ACL not supported");
 #endif
 		} else {
-			cFYI(1, ("illegal xattr request %s (only user namespace"
-				 " supported)", ea_name));
+			cFYI(1, "illegal xattr request %s (only user namespace"
+				" supported)", ea_name);
 		  /* BB what if no namespace prefix? */
 		  /* Should we just pass them to server, except for
 		  system and perhaps security prefixes? */
@@ -234,13 +234,13 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 	/* return dos attributes as pseudo xattr */
 	/* return alt name if available as pseudo attr */
 	if (ea_name == NULL) {
-		cFYI(1, ("Null xattr names not supported"));
+		cFYI(1, "Null xattr names not supported");
 	} else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto get_ea_exit;
 
 		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0) {
-			cFYI(1, ("attempt to query cifs inode metadata"));
+			cFYI(1, "attempt to query cifs inode metadata");
 			/* revalidate/getattr then populate from inode */
 		} /* BB add else when above is implemented */
 		ea_name += 5; /* skip past user. prefix */
@@ -286,7 +286,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 		}
 #endif /* EXPERIMENTAL */
 #else
-		cFYI(1, ("query POSIX ACL not supported yet"));
+		cFYI(1, "query POSIX ACL not supported yet");
 #endif /* CONFIG_CIFS_POSIX */
 	} else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
 			  strlen(POSIX_ACL_XATTR_DEFAULT)) == 0) {
@@ -298,18 +298,18 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 				cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 #else
-		cFYI(1, ("query POSIX default ACL not supported yet"));
+		cFYI(1, "query POSIX default ACL not supported yet");
 #endif
 	} else if (strncmp(ea_name,
 		  CIFS_XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
-		cFYI(1, ("Trusted xattr namespace not supported yet"));
+		cFYI(1, "Trusted xattr namespace not supported yet");
 	} else if (strncmp(ea_name,
 		  CIFS_XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) == 0) {
-		cFYI(1, ("Security xattr namespace not supported yet"));
+		cFYI(1, "Security xattr namespace not supported yet");
 	} else
 		cFYI(1,
-		    ("illegal xattr request %s (only user namespace supported)",
-			ea_name));
+		    "illegal xattr request %s (only user namespace supported)",
+		     ea_name);
 
 	/* We could add an additional check for streams ie
 	    if proc/fs/cifs/streamstoxattr is set then


