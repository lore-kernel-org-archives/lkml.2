Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab0KLQ4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:56:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab0KLQ4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:56:42 -0500
Subject: Re: [RFC PATCH] network: return errors if we know tcp_connect
 failed
From: Eric Paris <eparis@redhat.com>
To: David Lamparter <equinox@diac24.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Hua Zhong <hzhong@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        paul.moore@hp.com
In-Reply-To: <20101112163543.GB122902@jupiter.n2.diac24.net>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com>
	 <00c201cb81eb$84e18160$8ea48420$@com>
	 <1289578108.3083.95.camel@localhost.localdomain>
	 <1289578532.3185.265.camel@edumazet-laptop>
	 <20101112163543.GB122902@jupiter.n2.diac24.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 11:53:56 -0500
Message-ID: <1289580836.3083.105.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 17:35 +0100, David Lamparter wrote:
> On Fri, Nov 12, 2010 at 05:15:32PM +0100, Eric Dumazet wrote:
> > Le vendredi 12 novembre 2010 à 11:08 -0500, Eric Paris a écrit :
> > 
> > > 2) What should the generic TCP code (tcp_connect()) do if the skb failed
> > > to send.  Should it return error codes back up the stack somehow or
> > > should they continue to be ignored?  Obviously continuing to just ignore
> > > information we have doesn't make me happy (otherwise I wouldn't have
> > > started scratching this itch).  But the point about ENOBUFS is well
> > > taken.  Maybe I should make tcp_connect(), or the caller to
> > > tcp_connect() more intelligent about specific error codes?
> > > 
> > > I'm looking for a path forward.  If SELinux is rejecting the SYN packets
> > > on connect() I want to pass that info to userspace rather than just
> > > hanging.  What's the best way to accomplish that?
> > > 
> > 
> > Eric, if you can differentiate a permanent reject, instead of a
> > temporary one (congestion, or rate limiting, or ENOBUF, or ...), then
> > yes, you could make tcp_connect() report to user the permanent error,
> > and ignore the temporary one.
> 
> If the netfilter targets DROP/REJECT match the NF_DROP/NF_REJECT
> counterparts, which i guess they do but i didn't read the source ;),
> then SELinux should use NF_REJECT in my opinion.

As it stands today there is no NF_REJECT.  NF_DROP is the only (related)
permitted return value from a netfilter hook.  Maybe I need to change
that fact though.

> NF_DROP does exactly what the name says, it drops the packet aka
> basically puts it in /dev/null. As with writing to /dev/null, you don't
> get an error for that. Even more, if in the meantime the DROP rule does
> not match anymore, the 2nd or 3rd SYN from the connect() can come
> through and establish a connection (think of "-m statistic" & co.)
> 
> This is very different from REJECT.
> 
> If REJECT doesn't immediately get reported to the application, that *is*
> a bug, but last time i checked i got EPERM immediately. I would fix
> SELinux to use the same mechanism.

I haven't looked at what -j REJECT does (or was intended to do) but it
most certainly does not return an error to sys_connect().  Try it out.

iptables -A OUTPUT -p tcp --dport 80 -j REJECT
links www.google.com

it just hangs on 'making connection'  (exact same for -j DROP)

If everyone agrees that's the wrong behavior (for -j REJECT) I'll work
on fixing that (however is appropriate) and will change the SELinux code
if needed after we've fixed the -j REJECT code.  Obviously there's
problems with my original way to fix the lack of error returns (namely
that I would immediately EACCES for DROP as well as REJECT).

I'm glad to hear that others seem to believe the current code is buggy
and I'm not completely off my rocker to think that applications should
be able to learn somehow that things fell down...

-Eric

