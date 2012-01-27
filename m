Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2A0SzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:55:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51013 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2A0SzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:55:10 -0500
Message-ID: <1327690506.3159.7.camel@edumazet-laptop>
Subject: Re: [BUG] Regression on behavior of EPOLLET | EPOLLIN for AF_UNIX
 sockets in 3.2
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Nick Mathewson <nickm@freehaven.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Moiseytsev <himeraster@gmail.com>
Date: Fri, 27 Jan 2012 19:55:06 +0100
In-Reply-To: <4F22EA24.3030901@parallels.com>
References: <CAKDKvuzH14AZjDG3WSdrf5VtmiUgG0Y+EaC83qqSd0VFKzyitg@mail.gmail.com>
	 <1327686822.3159.3.camel@edumazet-laptop> <4F22EA24.3030901@parallels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 27 janvier 2012 à 22:17 +0400, Glauber Costa a écrit :
> On 01/27/2012 09:53 PM, Eric Dumazet wrote:
> > Le vendredi 27 janvier 2012 à 12:05 -0500, Nick Mathewson a écrit :
> >> [1.] One line summary of the problem:
> >>
> >
> > Hi
> >
> > Probably coming from commit 0884d7aa24e15e72b3c07f7da910a13bb7df3592
> > (AF_UNIX: Fix poll blocking problem when reading from a stream socket)
> >
> > When we requeue skb because not completely eaten, we call again
> >
> > sk->sk_data_ready(sk, skb->len);
> >
> For the record, I just confirmed this to be the case.

A fix would be to change unix_poll() and not call sk_data_ready() when
skb is requeued.

if (!skb_queue_empty(&sk->sk_receive_queue))
	mask |= POLLIN | POLLRDNORM;

Might be tricky if we want to keep unix_poll() lockless, but quite
possible.

Or... not dequeue skb from sk_received_queue unless fully consumed.


