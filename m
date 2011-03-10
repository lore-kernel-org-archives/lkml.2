Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1CJSMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:12:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48933 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1CJSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:12:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=yBSDQhPjfyiFHh2EzH1VRKM0OMPr4DYMGBIXX20aK9i2ZB0AbT68y1BorV9ayIrAqV
         ofpisIfTdj+8+KNVN8WdEDI8jckHGvHWZp/F//96zMEeRXm9c43kSYEuUCVjt4AW7Uu0
         VCXr+eiCP+FFTIqZQ4EVq6JCAxpZtQlLITBb0=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH] ipv4: netfilter: ipt_CLUSTERIP: fix buffer overflow
Date: Thu, 10 Mar 2011 21:12:19 +0300
Message-Id: <1299780740-32652-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buffer string is copied from userspace.  It is not checked whether it is
zero terminated.  This may lead to overflow inside of simple_strtoul().

It was introduced before the git epoch.  Files "ipt_CLUSTERIP/*" are
root writable only by default, however, on some setups permissions might be
relaxed to e.g. network admin user.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 403ca57..7aabf9a 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -666,6 +666,7 @@ static ssize_t clusterip_proc_write(struct file *file, const char __user *input,
 
 	if (copy_from_user(buffer, input, PROC_WRITELEN))
 		return -EFAULT;
+	buffer[sizeof(buffer)-1] = 0;
 
 	if (*buffer == '+') {
 		nodenum = simple_strtoul(buffer+1, NULL, 10);
-- 
1.7.0.4

