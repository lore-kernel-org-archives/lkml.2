Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0GJJxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 05:53:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41035 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0GJJxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 05:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=qqSlcG7bDyVCpCUBwko36RqePL208OVfylhheKdPJ7IzpfnHwph/yE47Dm0elr1hXP
         Q3XPcpWNYVLejiLfl5ogwhIWSkHhwNSVPBG3PjPqeTPP6Bz74wyqg86ZZSPGdh4dmcXj
         jzQiV1UcFKmyT9yRv70Enu1wkRskqliIoPebg=
Date: Sat, 10 Jul 2010 11:51:54 +0200
From: Dan Carpenter <error27@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>,
       Venkateswararao Jujjuri <jvrao@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tilman Sauerbeck <tilman@code-monkey.de>,
       netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] 9p: strlen() doesn't count the terminator
Message-ID: <20100710095154.GU19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Abhishek Kulkarni <adkulkar@umail.iu.edu>,
	Venkateswararao Jujjuri <jvrao@us.ibm.com>,
	linux-kernel@vger.kernel.org,
	Tilman Sauerbeck <tilman@code-monkey.de>, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an off by one bug because strlen() doesn't count the NULL
terminator.  We strcpy() addr into a fixed length array of size
UNIX_PATH_MAX later on.

The addr variable is the name of the device being mounted.

CC: stable@kernel.org
Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 98ce9bc..c85109d 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -948,7 +948,7 @@ p9_fd_create_unix(struct p9_client *client, const char *addr, char *args)
 
 	csocket = NULL;
 
-	if (strlen(addr) > UNIX_PATH_MAX) {
+	if (strlen(addr) >= UNIX_PATH_MAX) {
 		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
 			addr);
 		return -ENAMETOOLONG;
