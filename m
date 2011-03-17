Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1CQLci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:32:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63897 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1CQLcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V+QnGPbB6rvHg1skhZK5+iqdjMtlqJKj0JWaSym1qYCuTjbI+wj/4ciFGm9cpLaAIx
         JksF0vCf0aC2mmihi4zouodhDq8kpwcHWLREnZs6PTDrmhtqp8TZU2+V0WZpVOy2mOWj
         atrW+UbNVo0gW6cmdL/0ygWxEdxJ5lsHZgn/I=
Date: Thu, 17 Mar 2011 14:32:29 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Changli Gao <xiaosuo@gmail.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH v2] ipv4: netfilter: ipt_CLUSTERIP: fix buffer overflow
Message-ID: <20110317113229.GA7710@albatros>
References: <1299780740-32652-1-git-send-email-segoon@openwall.com>
 <AANLkTimPZJoCzz386e-4m0Y4khWGZirZguGFmuFYCrry@mail.gmail.com>
 <4D7F5CAC.6070006@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7F5CAC.6070006@trash.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'buffer' string is copied from userspace.  It is not checked whether it is
zero terminated.  This may lead to overflow inside of simple_strtoul().
Changli Gao suggested to copy not more than user supplied 'size' bytes.

It was introduced before the git epoch.  Files "ipt_CLUSTERIP/*" are
root writable only by default, however, on some setups permissions might be
relaxed to e.g. network admin user.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1e26a48..af7dec6 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -669,8 +669,11 @@ static ssize_t clusterip_proc_write(struct file *file, const char __user *input,
 	char buffer[PROC_WRITELEN+1];
 	unsigned long nodenum;
 
-	if (copy_from_user(buffer, input, PROC_WRITELEN))
+	if (size > PROC_WRITELEN)
+		return -EIO;
+	if (copy_from_user(buffer, input, size))
 		return -EFAULT;
+	buffer[size] = 0;
 
 	if (*buffer == '+') {
 		nodenum = simple_strtoul(buffer+1, NULL, 10);
-- 
1.7.0.4
