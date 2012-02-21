Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2BUD3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 22:29:41 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52175 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761Ab2BUD3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 22:29:39 -0500
X-Sasl-enc: urV8CpWfR4HpCUPIgs+dGzReXf9xJVb/+Odeo7oyAYQzNjvmETSFcbPNVQ 1329794978
Message-ID: <1329794974.2226.11.camel@perseus.themaw.net>
Subject: Re: Linux 3.3-rc4
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Feb 2012 11:29:34 +0800
In-Reply-To: <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
	 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
	 <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
	 <20120219.144947.660678318380307878.davem@davemloft.net>
	 <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-19 at 12:02 -0800, Linus Torvalds wrote:
> On Sun, Feb 19, 2012 at 11:49 AM, David Miller <davem@davemloft.net> wrote:
> >
> > A real shame, this should have used "__aligned_u64" from the
> > beginning.
> 
> I agree. Sadly, this is exactly the kind of thing that is *really*
> easy to overlook, and once it is overlooked we're screwed because
> fixing it just breaks the native 32-bit case.
> 
> We probably should have made __u64 itself be marked as aligned, but
> that's too late now too, unless somebody wants to go through and fix
> any cases like this ;(
> 
> Binary compatibility is really important, and while arguably
> compat-compatibility is slightly less critical, I think we should aim
> to DTRT there too. I don't think we need to necessarily bend over
> quite as far backwards for the compat case, but in places like this
> where we are so close to being compatible - and not being compatible
> kills the boot sequence and isn't just some theoretical thing - I do
> think that it's worth

Not sure this is the way you'd like to go with this but here is a patch
that bumps the major autofs kernel communications version (as yet not
even compile tested).

The advantage of this is that users of the v5 protocol that use a
workaround like the one in list archive post (which includes autofs
itself) in the first post on this won't be broken and users can elect to
use the packed data structure from now on.

Comments please.

autofs4 - add packed autofs_v6_packet to avoid struct alignment problems.

From: Thomas Meyer <thomas@m3y3r.de>

Updated by Ian Kent <raven@themaw.net>

autofs_v5_packet is 300 bytes on archectures that are 32-bit aligned and
304 bytes on archectures that are 64-bit aligned. This leads to an error
in at least systemd when running a x86_64 kernel on an x86 userspace.

Fix this by adding a new protocol version 6 packet that is packed so that
it will have the same size on all archectures regardless of alignement.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Ian Kent <ikent@redhat.com>
---

 fs/autofs4/inode.c       |   36 ++++++++++++++++++++++++++++--------
 fs/autofs4/waitq.c       |   46 +++++++++++++++++++++++++++++++---------------
 include/linux/auto_fs4.h |   36 +++++++++++++++++++++++++++++++++---
 3 files changed, 92 insertions(+), 26 deletions(-)


diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index e16980b..18b5b89 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -197,6 +197,28 @@ static int parse_options(char *options, int *pipefd, uid_t *uid, gid_t *gid,
 	return (*pipefd < 0);
 }
 
+static bool check_protocol_version(int minproto, int maxproto)
+{
+	bool rc = true;
+
+	if (minproto > maxproto || maxproto < minproto) {
+		printk("autofs: protocol min(%d)/max(%d) version error!",
+			minproto, maxproto);
+		rc = false;
+	}
+
+	if (maxproto < AUTOFS_MIN_PROTO_VERSION ||
+	    minproto > AUTOFS_MAX_PROTO_VERSION) {
+		printk("autofs: kernel does not match daemon version "
+		       "daemon (%d, %d) kernel (%d, %d)\n",
+			minproto, maxproto,
+			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
+		rc = false;
+	}
+
+	return rc;
+}
+
 int autofs4_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct inode * root_inode;
@@ -270,21 +292,19 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	root_inode->i_op = &autofs4_dir_inode_operations;
 
 	/* Couldn't this be tested earlier? */
-	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
-	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
-		printk("autofs: kernel does not match daemon version "
-		       "daemon (%d, %d) kernel (%d, %d)\n",
-			sbi->min_proto, sbi->max_proto,
-			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
+	if(check_protocol_version(sbi->min_proto, sbi->max_proto) == false)
 		goto fail_dput;
-	}
 
 	/* Establish highest kernel protocol version */
 	if (sbi->max_proto > AUTOFS_MAX_PROTO_VERSION)
 		sbi->version = AUTOFS_MAX_PROTO_VERSION;
 	else
 		sbi->version = sbi->max_proto;
-	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
+
+	if (sbi->version == 5)
+		sbi->sub_version = AUTOFS_V5_PROTO_SUBVERSION;
+	else
+		sbi->sub_version = AUTOFS_MAX_PROTO_SUBVERSION;
 
 	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
 	pipe = fget(pipefd);
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index da8876d..361a9bf 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -100,6 +100,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 		struct autofs_packet_hdr hdr;
 		union autofs_packet_union v4_pkt;
 		union autofs_v5_packet_union v5_pkt;
+		struct autofs_v6_packet_union v6_pkt;
 	} pkt;
 	struct file *pipe = NULL;
 	size_t pktsz;
@@ -145,7 +146,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 		break;
 	}
 	/*
-	 * Kernel protocol v5 packet for handling indirect and direct
+	 * Kernel protocol v5/v6 packet for handling indirect and direct
 	 * mount missing and expire requests
 	 */
 	case autofs_ptype_missing_indirect:
@@ -153,20 +154,35 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	case autofs_ptype_missing_direct:
 	case autofs_ptype_expire_direct:
 	{
-		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
-
-		pktsz = sizeof(*packet);
-
-		packet->wait_queue_token = wq->wait_queue_token;
-		packet->len = wq->name.len;
-		memcpy(packet->name, wq->name.name, wq->name.len);
-		packet->name[wq->name.len] = '\0';
-		packet->dev = wq->dev;
-		packet->ino = wq->ino;
-		packet->uid = wq->uid;
-		packet->gid = wq->gid;
-		packet->pid = wq->pid;
-		packet->tgid = wq->tgid;
+		if(sbi->version == 5) {
+			struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
+
+			packet->wait_queue_token = wq->wait_queue_token;
+			packet->len = wq->name.len;
+			memcpy(packet->name, wq->name.name, wq->name.len);
+			packet->name[wq->name.len] = '\0';
+			packet->dev = wq->dev;
+			packet->ino = wq->ino;
+			packet->uid = wq->uid;
+			packet->gid = wq->gid;
+			packet->pid = wq->pid;
+			packet->tgid = wq->tgid;
+			pktsz = sizeof(packet);
+		} else { /* all other versions, currently only version 6 */
+			struct autofs_v6_packet *packet = &pkt.v6_pkt.v6_packet;
+
+			packet->wait_queue_token = wq->wait_queue_token;
+			packet->len = wq->name.len;
+			memcpy(packet->name, wq->name.name, wq->name.len);
+			packet->name[wq->name.len] = '\0';
+			packet->dev = wq->dev;
+			packet->ino = wq->ino;
+			packet->uid = wq->uid;
+			packet->gid = wq->gid;
+			packet->pid = wq->pid;
+			packet->tgid = wq->tgid;
+			pktsz = sizeof(packet);
+		}
 		break;
 	}
 	default:
diff --git a/include/linux/auto_fs4.h b/include/linux/auto_fs4.h
index e02982f..e8c644a 100644
--- a/include/linux/auto_fs4.h
+++ b/include/linux/auto_fs4.h
@@ -20,11 +20,12 @@
 #undef AUTOFS_MIN_PROTO_VERSION
 #undef AUTOFS_MAX_PROTO_VERSION
 
-#define AUTOFS_PROTO_VERSION		5
+#define AUTOFS_PROTO_VERSION		6
 #define AUTOFS_MIN_PROTO_VERSION	3
-#define AUTOFS_MAX_PROTO_VERSION	5
+#define AUTOFS_MAX_PROTO_VERSION	6
 
-#define AUTOFS_PROTO_SUBVERSION		2
+#define AUTOFS_V5_PROTO_SUBVERSION	2
+#define AUTOFS_MAX_PROTO_SUBVERSION	0
 
 /* Mask for expire behaviour */
 #define AUTOFS_EXP_IMMEDIATE		1
@@ -154,6 +155,35 @@ union autofs_v5_packet_union {
 	autofs_packet_expire_direct_t expire_direct;
 };
 
+/* autofs v6 common packet struct */
+/* packed structure for same packet size on all archs */
+struct autofs_v6_packet {
+	struct autofs_packet_hdr hdr;
+	autofs_wqt_t wait_queue_token;
+	__u32 dev;
+	__u64 ino;
+	__u32 uid;
+	__u32 gid;
+	__u32 pid;
+	__u32 tgid;
+	__u32 len;
+	char name[NAME_MAX+1];
+} __attribute__ ((packed));
+
+typedef struct autofs_v6_packet autofs_v6_packet_missing_indirect_t;
+typedef struct autofs_v6_packet autofs_v6_packet_expire_indirect_t;
+typedef struct autofs_v6_packet autofs_v6_packet_missing_direct_t;
+typedef struct autofs_v6_packet autofs_v6_packet_expire_direct_t;
+
+union autofs_v6_packet_union {
+	struct autofs_packet_hdr hdr;
+	struct autofs_v6_packet v6_packet;
+	autofs_v6_packet_missing_indirect_t missing_indirect;
+	autofs_v6_packet_expire_indirect_t expire_indirect;
+	autofs_v6_packet_missing_direct_t missing_direct;
+	autofs_v6_packet_expire_direct_t expire_direct;
+};
+
 #define AUTOFS_IOC_EXPIRE_MULTI		_IOW(0x93,0x66,int)
 #define AUTOFS_IOC_EXPIRE_INDIRECT	AUTOFS_IOC_EXPIRE_MULTI
 #define AUTOFS_IOC_EXPIRE_DIRECT	AUTOFS_IOC_EXPIRE_MULTI


