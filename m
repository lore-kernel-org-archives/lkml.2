Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab1EZWBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:01:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61738 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab1EZWBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cU891bLBA6VIxURck2uJzuQdq1FVwspobrftKtEjVju1RsggqVd3fDGs1pd4SallwW
         e4X0RiDJebe6ylHz2PESZBN2mmihHSeJ79T6KwOKjYYmhZ/zDkDyRtPcEEgrAXS/BuEB
         JmNfD2FwN8Bhh3Sp694+XMnmt+Y5wsBpOyWqo=
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, StuStaNet Vorstand <vorstand@stusta.mhn.de>
In-Reply-To: <4DDECA9B.8080206@fb.com>
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
	 <1306439246.2543.10.camel@edumazet-laptop>  <4DDECA9B.8080206@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 00:01:32 +0200
Message-ID: <1306447292.2543.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 mai 2011 à 14:48 -0700, Arun Sharma a écrit :
> On 5/26/11 12:47 PM, Eric Dumazet wrote:
> 
> > You dont get the problem. Problem is : We can do the empty() test only
> > if protected by the lock.
> >
> > If not locked, result can be wrong. [ false positive or negative ]
> >
> 
> 
> Agreed. Failing to unlink from unused list when we should have sounds wrong.
> 
> >> The list modification under unused_peers.lock looks generally safe. But
> >> the control flow (based on refcnt) done outside the lock might have races.
> >>
> >
> > "might" is not a good word when dealing with this ;)
> 
> Potential race in the current code:
> 
> initial refcnt = 1
> 
>         T1:                                        T2
> 
> atomic_dec_and_lock(refcnt)
> // refcnt == 0
> 
>                                         atomic_add_unless(refcnt)
>                                         unlink_from_unused()
> 
> list_add_tail(unused)
>                                         // T2 using "unused" entry
> 
> 
> > Did you test my fix ?
> 
> I could try it on one or two machines - but it won't tell us anything 
> for weeks if not months. Unfortunately my next window to try a new 
> kernel on a large enough sample is several months away.
> 
> >
> > Its doing the right thing : Using refcnt as the only marker to say if
> > the item must be removed from unused list (and lock the central lock
> > protecting this list only when needed)
> >
> > Since we already must do an atomic operation on refcnt, using
> > atomic_inc_return [ or similar full barrier op ] is enough to tell us
> > the truth.
> 
> Yeah - using the refcnt seems better than list_empty(), but I'm not sure 
> that your patch addresses the race above.

It does.

It becomes

        T1:                                        T2
> 
> atomic_dec_and_lock(refcnt)
> // refcnt == 0
> 
>                          newref = atomic_add_unless_and_return(refcnt)
> 
> list_add_tail(unused)
  unlock();
>                                         
> 			   if (newref == 1) {
				   lock()
                                   unlink_from_unused()
				   unlock()
			   }



