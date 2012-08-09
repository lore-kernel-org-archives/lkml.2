Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab2HINau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:30:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45189 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab2HINas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:30:48 -0400
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Eric Paris <eparis@parisplace.org>,
        John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
Date: Thu, 09 Aug 2012 09:30:42 -0400
Message-ID: <1695034.0lrQgQPOMT@sifl>
User-Agent: KMail/4.9 (Linux/3.4.7-gentoo; KDE/4.9.0; x86_64; ; )
In-Reply-To: <5022FD9A.4020603@schaufler-ca.com>
References: <50215A7E.8000701@linaro.org> <1344462889.28967.328.camel@edumazet-glaptop> <5022FD9A.4020603@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 08, 2012 05:00:26 PM Casey Schaufler wrote:
> On 8/8/2012 2:54 PM, Eric Dumazet wrote:
>
> By the way, once this proved to be an issue that involved
> more than just SELinux it needed to go onto the LSM list as
> well.

Yes, you're right.

> > On Wed, 2012-08-08 at 16:46 -0400, Paul Moore wrote:
> >> On Wednesday, August 08, 2012 10:32:52 PM Eric Dumazet wrote:
> >>> On Wed, 2012-08-08 at 22:09 +0200, Eric Dumazet wrote:
> >>> +static int smack_sk_alloc_security(struct sock *sk, int ...
> >>>  {
> >>>  	char *csp = smk_of_current();
> >>>  	struct socket_smack *ssp;
> >>> 
> >>> +	if (check && sk->sk_security)
> >>> +		return 0;
> >>> +
> >>> 
> >>>  	ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
> >>>  	if (ssp == NULL)
> >>>  	
> >>>  		return -ENOMEM;
> >> 
> >> In the case of Smack, when the kernel boolean is true I think the right
> >> solution is to use smack_net_ambient.
> 
> I confess that my understanding of unicast is limited.
> If the intention is to send an unlabeled packet then
> indeed smack_net_ambient is the way to go.

Well, the intention isn't necessarily to send an unlabeled packet, although 
that may be the end result.

In the case of a TCP reset the kernel/ambient label it is hard to argue that 
the kernel/ambient label is not the correct solution; in this case there was 
never an associated socket so the kernel itself needs to respond.

In the case of a TCP syn-recv and timewait ACK things are a little less clear.  
Eric (Dumazet), it looks like we have a socket in tcp_v4_reqsk_send_ack() and 
tcp_v4_timewait_ack(), any reason why we can't propagate the socket down to 
ip_send_unicast_reply()?

-- 
paul moore
www.paul-moore.com

