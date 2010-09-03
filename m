Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0ICRVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:21:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58877 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab0ICRVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=xh7aR1o/hXYq+mHxf1Tg9OBElLNlwVYXX30EKtIDRvSuwalFIiVj3+o/Hgov72zsWm
         VWZ6y2/3mZ+PBSJ3CJ73nFO8WR/NdmkrFr1YTsEUmakg0NqrfgMoynkuM8CEdpC+qmco
         6DKziq0hBtPFcKUNXZlk0IHGKUc6eUKHYXgKM=
MIME-Version: 1.0
Date: Fri, 3 Sep 2010 13:21:46 -0400
Message-ID: <AANLkTimtTXpeywA64xUDHZP2RrrtrswyvEB9KeYqhrgU@mail.gmail.com>
Subject: [PATCH v2] sctp: prevent reading out-of-bounds memory
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
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

--- linux-2.6.35.4.orig/net/sctp/socket.c       2010-09-03
08:58:48.127080114 -0400
+++ linux-2.6.35.4/net/sctp/socket.c    2010-09-03 11:52:28.239595395 -0400
@@ -916,6 +916,12 @@ SCTP_STATIC int sctp_setsockopt_bindx(st
       /* Walk through the addrs buffer and count the number of addresses. */
       addr_buf = kaddrs;
       while (walk_size < addrs_size) {
+
+               if (walk_size + sizeof(sa_family_t) > addrs_size) {
+                       kfree(kaddrs);
+                       return -EINVAL;
+               }
+
               sa_addr = (struct sockaddr *)addr_buf;
               af = sctp_get_af_specific(sa_addr->sa_family);

@@ -1002,9 +1008,14 @@ static int __sctp_connect(struct sock* s
       /* Walk through the addrs buffer and count the number of addresses. */
       addr_buf = kaddrs;
       while (walk_size < addrs_size) {
+
+               if (walk_size + sizeof(sa_family_t) > addrs_size) {
+                       err = -EINVAL;
+                       goto out_free;
+               }
+
               sa_addr = (union sctp_addr *)addr_buf;
               af = sctp_get_af_specific(sa_addr->sa.sa_family);
-               port = ntohs(sa_addr->v4.sin_port);

               /* If the address family is not supported or if this address
                * causes the address buffer to overflow return EINVAL.
@@ -1013,6 +1024,8 @@ static int __sctp_connect(struct sock* s
                       err = -EINVAL;
                       goto out_free;
               }
+
+               port = ntohs(sa_addr->v4.sin_port);

               /* Save current address so we can work with it */
               memcpy(&to, sa_addr, af->sockaddr_len);
