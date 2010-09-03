Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0ICNsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:48:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57273 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0ICNsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=D25qd0PPM04eucbXnBgI8bmc9OjQrvGHbHTI5obaBP58PE1BBf4eAQ1R+zTQTgudZ8
         zF1Tsdzv3e7tMaov6sMvFaQX90EicVYc0wIka+o9sE7oCo6evMRwXZqaabEKghhJar4T
         3K22Ij9Fmyk2hpPRaaGepiJ02Losw5uziO/GQ=
MIME-Version: 1.0
Date: Fri, 3 Sep 2010 09:48:18 -0400
Message-ID: <AANLkTineCKfL-UvqfQBTZPDFeqm3Nrpb=pFnZpkSqbEQ@mail.gmail.com>
Subject: [PATCH] sctp: prevent reading out-of-bounds memory
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
To: vladislav.yasevich@hp.com, sri@us.ibm.com
Cc: linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two user-controlled allocations in SCTP are subsequently dereferenced
as sockaddr structs, without checking if the dereferenced struct
members fall beyond the end of the allocated chunk.  There doesn't
appear to be any information leakage here based on how these members
are used and additional checking, but it's still worth fixing.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/net/sctp/socket.c	2010-09-03 08:58:48.127080114 -0400
+++ linux-2.6.35.4/net/sctp/socket.c	2010-09-03 09:22:06.337096825 -0400
@@ -889,6 +889,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
 	int err;
 	int addrcnt = 0;
 	int walk_size = 0;
+	unsigned int remaining = addrs_size;
 	struct sockaddr *sa_addr;
 	void *addr_buf;
 	struct sctp_af *af;
@@ -916,6 +917,13 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
+
+		/* Don't read out-of-bounds memory */
+		if (remaining < sizeof(struct sockaddr)) {
+			kfree(kaddrs);
+			return -EINVAL;
+		}
+
 		sa_addr = (struct sockaddr *)addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa_family);

@@ -929,6 +937,7 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
 		addrcnt++;
 		addr_buf += af->sockaddr_len;
 		walk_size += af->sockaddr_len;
+		remaining -= af->sockaddr_len;
 	}

 	/* Do the work. */
@@ -984,6 +993,7 @@ static int __sctp_connect(struct sock* s
 	void *addr_buf;
 	unsigned short port;
 	unsigned int f_flags = 0;
+	unsigned int remaining = addrs_size;

 	sp = sctp_sk(sk);
 	ep = sp->ep;
@@ -1002,6 +1012,13 @@ static int __sctp_connect(struct sock* s
 	/* Walk through the addrs buffer and count the number of addresses. */
 	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
+
+		/* Don't read out-of-bounds memory */
+		if (remaining < sizeof(union sctp_addr)) {
+			err = -EINVAL;
+			goto out_free;
+		}
+
 		sa_addr = (union sctp_addr *)addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa.sa_family);
 		port = ntohs(sa_addr->v4.sin_port);
@@ -1101,6 +1118,7 @@ static int __sctp_connect(struct sock* s
 		addrcnt++;
 		addr_buf += af->sockaddr_len;
 		walk_size += af->sockaddr_len;
+		remaining -= af->sockaddr_len;
 	}

 	/* In case the user of sctp_connectx() wants an association
