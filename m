Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab0IHFUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 01:20:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56157 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0IHFUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 01:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=vBA2G62aRlA6zsKHKzDkFam4OrxuVZxbA/EPnyB2Q6LT6vtK5KfK1KJoEX3dsVCRn8
         Bg9lcfSG8iBtK/yeaGbA0eSGHMpNBlLN7l61MO8HjBClx2cW8rXaG+lnWQA87ZtoRL5U
         C1jiHNDy1pUs9CeAkZAvlp4DMMdrH5GjkOq+A=
MIME-Version: 1.0
Date: Wed, 8 Sep 2010 13:13:57 +0800
Message-ID: <AANLkTikp0m8cQYfEBHP_E8XpGZqdMj6Cr4M=aWCnei=X@mail.gmail.com>
Subject: [PATCH] netlink: Fix kfree NULL pointer
From: jovi zhang <bookjovi@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will kfree NULL pointer if listeners is NULL. fix it.

Signed-off-by: bookjovi@gmail.com
net/netlink/af_netlink.c |    5 +++--
1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 980fe4a..1c7bf48 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1532,8 +1532,10 @@ netlink_kernel_create(struct net *net, int
unit, unsigned int groups,
       if (input)
               nlk_sk(sk)->netlink_rcv = input;

-       if (netlink_insert(sk, net, 0))
+       if (netlink_insert(sk, net, 0)) {
+               kfree(listeners);
               goto out_sock_release;
+       }

       nlk = nlk_sk(sk);
       nlk->flags |= NETLINK_KERNEL_SOCKET;
@@ -1553,7 +1555,6 @@ netlink_kernel_create(struct net *net, int unit,
unsigned int groups,
       return sk;

out_sock_release:
-       kfree(listeners);
       netlink_kernel_release(sk);
       return NULL;
