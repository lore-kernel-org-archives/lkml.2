Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0IWJll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 05:41:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52104 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab0IWJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 05:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IwqeXtH0QGzyph4BN6ODcu0deiXKxrK2DJU8bpP2Ucc8yvg2M/JWLJpJmKuoP4p/5Y
         gjoasADlDCNGQQ8cRrMlnnA+vr8G5wRQwlIx7PkPD/ACK8MPNLQOcc+H2myXheVe7WWe
         RYERsh+/EElrQQWdMmY+50+Lj8uAfiueN9XwM=
Subject: Re: [PATCH 7/8] net: Allow setting the network namespace by fd
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jamal <hadi@cyberus.ca>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
In-Reply-To: <m1hbhgq1v1.fsf@fess.ebiederm.org>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1hbhgq1v1.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 11:41:25 +0200
Message-ID: <1285234885.2864.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 23 septembre 2010 à 01:51 -0700, Eric W. Biederman a écrit :
> Take advantage of the new abstraction and allow network devices
> to be placed in any network namespace that we have a fd to talk
> about.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  include/linux/if_link.h     |    1 +
>  include/net/net_namespace.h |    1 +
>  net/core/net_namespace.c    |   26 ++++++++++++++++++++++++++
>  net/core/rtnetlink.c        |    4 +++-
>  4 files changed, 31 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/if_link.h b/include/linux/if_link.h
> index 2fc66dd..ae73d5e 100644
> --- a/include/linux/if_link.h
> +++ b/include/linux/if_link.h
> @@ -116,6 +116,7 @@ enum {
>  	IFLA_STATS64,
>  	IFLA_VF_PORTS,
>  	IFLA_PORT_SELF,
> +	IFLA_NET_NS_FD,
>  	__IFLA_MAX
>  };
>  
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index bd10a79..68672ce 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -114,6 +114,7 @@ static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
>  extern struct list_head net_namespace_list;
>  
>  extern struct net *get_net_ns_by_pid(pid_t pid);
> +extern struct net *get_net_ns_by_fd(int pid);
>  
>  #ifdef CONFIG_NET_NS
>  extern void __put_net(struct net *net);
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 581a088..a9b54a7 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -8,6 +8,8 @@
>  #include <linux/idr.h>
>  #include <linux/rculist.h>
>  #include <linux/nsproxy.h>
> +#include <linux/proc_fs.h>
> +#include <linux/file.h>
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
>  
> @@ -341,6 +343,30 @@ struct net *get_net_ns_by_pid(pid_t pid)
>  }
>  EXPORT_SYMBOL_GPL(get_net_ns_by_pid);
>  
> +struct net *get_net_ns_by_fd(int fd)
> +{
> +	struct proc_inode *ei;
> +	struct file *file;
> +	struct net *net;
> +
> +	file = NULL;
> +	net = ERR_PTR(-EINVAL);
> +	file = proc_ns_fget(fd);
> +	if (!fd)
> +		goto out;
> +		return ERR_PTR(-EINVAL);
> +
> +	ei = PROC_I(file->f_dentry->d_inode);
> +	if (ei->ns_ops != &netns_operations)
> +		goto out;
> +
> +	net = get_net(ei->ns);
> +out:
> +	if (file)
> +		fput(file);
> +	return net;
> +}
> +
>  static int __init net_ns_init(void)
>  {
>  	struct net_generic *ng;
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index f78d821..771d8be 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1003,6 +1003,8 @@ struct net *rtnl_link_get_net(struct net *src_net, struct nlattr *tb[])
>  	 */
>  	if (tb[IFLA_NET_NS_PID])
>  		net = get_net_ns_by_pid(nla_get_u32(tb[IFLA_NET_NS_PID]));
> +	else if (tb[IFLA_NET_NS_FD])
> +		net = get_net_ns_by_fd(nla_get_u32(tb[IFLA_NET_NS_FD]));
>  	else
>  		net = get_net(src_net);
>  	return net;
> @@ -1077,7 +1079,7 @@ static int do_setlink(struct net_device *dev, struct ifinfomsg *ifm,
>  	int send_addr_notify = 0;
>  	int err;
>  
> -	if (tb[IFLA_NET_NS_PID]) {
> +	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD]) {
>  		struct net *net = rtnl_link_get_net(dev_net(dev), tb);
>  		if (IS_ERR(net)) {
>  			err = PTR_ERR(net);

You probably want to add following chunk :

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index b2a718d..35bb6de 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -927,6 +927,7 @@ const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_LINKMODE]		= { .type = NLA_U8 },
 	[IFLA_LINKINFO]		= { .type = NLA_NESTED },
 	[IFLA_NET_NS_PID]	= { .type = NLA_U32 },
+	[IFLA_NET_NS_FD]	= { .type = NLA_U32 },
 	[IFLA_IFALIAS]	        = { .type = NLA_STRING, .len = IFALIASZ-1 },
 	[IFLA_VFINFO_LIST]	= {. type = NLA_NESTED },
 	[IFLA_VF_PORTS]		= { .type = NLA_NESTED },


