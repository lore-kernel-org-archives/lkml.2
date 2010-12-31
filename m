Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0LaMAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 07:00:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32899 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab0LaMAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 07:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j6vjWa97aABS0/TlXd02zoPIvwQi7xr1wOZtHiZUV14QmHWI7WsWTwpq2nFB0fl3LF
         g4m1MB4PZS9Mb3XiiFihYAHyY8Cle5tnbfNHulFxtELnC4GcW3J/sZ+jCNSCzjVS3mvr
         NrGO2UTKkzIA9wlJO5N94A7TAICuHPf/hUdmY=
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293794758.2973.49.camel@edumazet-laptop>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
	 <1293794758.2973.49.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 13:00:05 +0100
Message-ID: <1293796805.2973.62.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 31 décembre 2010 à 12:25 +0100, Eric Dumazet a écrit :
> Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
> écrit :
> > +		if (!list_empty(&usk->destlist)) {
> > +			state->sk = (struct sock *)usk;
> > +			state->dest = list_first_entry(&usk->destlist,
> > +					struct udpcp_dest, list);
> > +			sock_hold(state->sk);
> > +
> > +			if (atomic_read(&state->sk->sk_refcnt) != 1) {
> > +				spin_unlock_irqrestore(&spinlock, flags);
> > +				return state;
> > +			}
> > +			atomic_dec(&state->sk->sk_refcnt);
> > +		}
> > +
> 
> I am trying to understand what you are doing here.
> 
> It seems racy to me.
> 
> Apparently, what you want is to take a reference only if actual
> sk_refcnt is not zero.
> 
> I suggest using atomic_inc_notzero(&state->sk->sk_refcnt) to avoid the
> race in atomic_dec().
> 
> 

Before you ask why its racy, this is because UDP sockets are RCU
protected, and RCU lookups depend on sk_refcnt being zero or not.

Doing an sk_refcnt increment/decrement opens a race window for the
concurrent lookups.




