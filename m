Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab0KKVOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:14:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54905 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab0KKVOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=diE3Q5lniBFOjFAxChtmSZZLjqDjKs3o68+8XoGimQr3xL/pHk4f8MMVvBY6AKpEf+
         bLnkDn3uQY+qCl0/DD5CvoG7ATKbeVLy3+rL0fqJ4yTioxOt0Iw3wvJMKaWoBOnNRpvl
         0rNV7eIVfKiQRBtpnIeN3zVREPKiMqXvGViYI=
Subject: Re: [RFC PATCH] network: return errors if we know tcp_connect
 failed
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
In-Reply-To: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 22:14:38 +0100
Message-ID: <1289510078.17691.1724.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 11 novembre 2010 à 16:03 -0500, Eric Paris a écrit :
> THIS PATCH IS VERY POSSIBLY WRONG!  But if it is I want some feedback.
> 
> Basically what I found was that if I added an iptables rule like so:
> 
> iptables -A OUTPUT -p tcp --dport 80 -j DROP
> 
> And then ran a web browser like links it would just hang on 'establishing
> connection.'  I expected that the application would immediately, or at least
> very quickly, get notified that the connect failed.   This waiting for timeout
> would be expected if something else dropped the SYN or if we were dropping the
> SYN/ACK packet coming back, but I figured if we knew we threw away the SYN we knew
> right away that the connection was denied and we should be able to indicate
> that to the application.  Yes, I realize this is little different than if the
> SYN was dropped in the first network device, but it is different because we
> know what happened!  We know that connect() call failed and that there isn't
> anything coming back.
> 
> What I discovered was that we actually had 2 problems in making it possible.
> For userspace to quickly realize the connect failed.  The first was a problem
> in the netfilter code which wasn't passing errors back up the stack correctly,
> due to what I believe to be a mistake in precedence rules.
> 
> http://marc.info/?l=netfilter-devel&m=128950262021804&w=2
> 
> And the second was that tcp_connect() was just ignoring the return value from
> tcp_transmit_skb().  Maybe this was intentional but I really wish we could
> find out that connect failed long before the minutes long timeout.  Once I
> fixed both of those issues I find that links gets denied (with EPERM)
> immediately when it calls connect().  Is this wrong?  Is this bad to tell
> userspace more quickly what happened?  Does passing this error code back up
> the stack here break something else?  Why do some functions seem to pay
> attention to tcp_transmit_skb() return codes and some functions just ignore
> it?  What do others think?
> 


I think its an interesting idea, but a temporary memory shortage would
abort the connect().

We could imagine some special handling of the first packet of a flow
being DROPED for whatever reason (flow control...)

So it needs some refinement I think.

SYN packets should be allowed to be re-transmitted before saying a TCP
connect() cannot succeed.



