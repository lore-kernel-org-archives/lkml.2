Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1EDC3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 22:29:34 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49966 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab1EDC3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 22:29:05 -0400
X-Nat-Received: from [202.181.97.72]:60423 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1304476106.7455
To: paul.moore@hp.com, sam@synack.fr
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        hadi@cyberus.ca, kaber@trash.net, zbr@ioremap.net, root@localdomain.pl
Subject: Re: [RFC v3 02/10] Revert "lsm: Remove the socket_post_accept() hook"
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1304432663-1575-1-git-send-email-sam@synack.fr>
	<1304432663-1575-3-git-send-email-sam@synack.fr>
	<201105031802.34724.paul.moore@hp.com>
In-Reply-To: <201105031802.34724.paul.moore@hp.com>
Message-Id: <201105041128.BAB13061.LMHVtOSOQOFFJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 4 May 2011 11:28:24 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 03052011 #5372073, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> On Tuesday, May 03, 2011 10:24:15 AM Samir Bellabes wrote:
> > snet needs to reintroduce this hook, as it was designed to be: a hook for
> > updating security informations on objects.
> 
> Looking at this and 5/10 again, it seems that you should be able to do what 
> you need with the sock_graft() hook.  Am I missing something?
> 
> My apologies if we've already discussed this approach previously ...

static void snet_socket_post_accept(struct socket *sock, struct socket *newsock)
{
	static void snet_do_send_event(struct snet_info *info)
	{
		int snet_nl_send_event(struct snet_info *info)
		{
			skb_rsp = genlmsg_new(size, GFP_KERNEL);
			genlmsg_unicast()
		}
	}
}

First problem with using snet_do_send_event() from security_sock_graft() is
that we have to use GFP_ATOMIC rather than GFP_KERNEL because we are inside
write_lock_bh()/write_unlock_bh().

static inline int genlmsg_unicast(struct net *net, struct sk_buff *skb, u32 pid)
{
	static inline int nlmsg_unicast(struct sock *sk, struct sk_buff *skb, u32 pid)
	{
		int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
			u32 pid, MSG_DONTWAIT)
		{
			int netlink_attachskb(struct sock *sk, struct sk_buff *skb,
				      long *timeo, struct sock *ssk)
			{
				if (!*timeo) {
					return -EAGAIN;
			}
		}
	}
}

Second problem is that genlmsg_unicast() might return -EAGAIN because we can't
sleep inside write_lock_bh()/write_unlock_bh().

Third problem (though independent with security_sock_graft()) is that
snet_do_send_event() ignores snet_nl_send_event() failure.
