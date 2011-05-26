Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab1EZTrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:47:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38356 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1EZTrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cKUK/6uPC441AFGe8WQbDauOjGRAjJllfcvNbyM/c+QWoCiCw+oXb4aP+sIiKZMOoj
         843A3nAnUIqWWeWOu0x3uCiZUsIuQsdd9HUMhne1RHcYR+w6SclJXa89XAoUAvp4qwuO
         rtVveDvGeWtin/pp97TISYHrqqbnpwmlQKZKM=
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, StuStaNet Vorstand <vorstand@stusta.mhn.de>
In-Reply-To: <4DDEAA3C.7020502@fb.com>
References: <201104250033.03401.maxi@daemonizer.de>
	 <1303878240.2699.41.camel@edumazet-laptop>
	 <1303878771.2699.44.camel@edumazet-laptop>
	 <201104271352.00601.maxi@daemonizer.de>
	 <20110512211033.GA3468@dev1756.snc6.facebook.com>
	 <1305234953.2831.2.camel@edumazet-laptop>
	 <20110524213327.GA3917@dev1756.snc6.facebook.com>
	 <1306291469.3305.11.camel@edumazet-laptop>
	 <20110525060609.GA32244@dev1756.snc6.facebook.com>
	 <1306305331.3305.22.camel@edumazet-laptop>  <4DDEAA3C.7020502@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 21:47:26 +0200
Message-ID: <1306439246.2543.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 mai 2011 à 12:30 -0700, Arun Sharma a écrit :
> On 5/24/11 11:35 PM, Eric Dumazet wrote:
> 
> >> Another possibility is to do the list_empty() check twice. Once without
> >> taking the lock and again with the spinlock held.
> >>
> >
> > Why ?
> >
> 
> Part of the problem is that I don't have a precise understanding of the 
> race condition that's causing the list to become corrupted.
> 
> All I know is that doing it under the lock fixes it. If it's slowing 
> things down, we do a check outside the lock (since it's cheap). But if 
> we get the wrong answer, we verify it again under the lock.
> 

You dont get the problem. Problem is : We can do the empty() test only
if protected by the lock.

If not locked, result can be wrong. [ false positive or negative ]


> > list_del_init(&p->unused); (done under lock of course) is safe, you can
> > call it twice, no problem.
> 
> Doing it twice is not a problem. But doing it when we shouldn't be doing 
> it could be the problem.
> 
> The list modification under unused_peers.lock looks generally safe. But 
> the control flow (based on refcnt) done outside the lock might have races.
> 

"might" is not a good word when dealing with this ;)

> Eg: inet_putpeer() might find the refcnt go to zero, but before it adds 
> it to the unused list, another thread may be doing inet_getpeer() and 
> set refcnt to 1. In the end, we end up with a node that's potentially in 
> use, but ends up on the unused list.
> 

Did you test my fix ?

Its doing the right thing : Using refcnt as the only marker to say if
the item must be removed from unused list (and lock the central lock
protecting this list only when needed)

Since we already must do an atomic operation on refcnt, using
atomic_inc_return [ or similar full barrier op ] is enough to tell us
the truth.



