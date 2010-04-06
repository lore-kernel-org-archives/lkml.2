Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab0DFHi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 03:38:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:41795 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280Ab0DFHiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 03:38:23 -0400
Date: Tue, 6 Apr 2010 17:38:18 +1000
From: Nick Piggin <npiggin@suse.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@gmail.com>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Subject: Re: Is module refcounting racy?
Message-ID: <20100406073818.GE11191@laptop>
References: <20100318105533.GE25636@laptop>
 <201003291942.56706.rusty@rustcorp.com.au>
 <e619185d1003290958w23037176uc869c7dbc0a48bcc@mail.gmail.com>
 <201003311414.49364.rusty@rustcorp.com.au>
 <20100401080940.GA8356@laptop>
 <alpine.LFD.2.00.1004010852170.3707@i5.linux-foundation.org>
 <20100406050549.GA11191@laptop>
 <1270534763.9013.55.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1270534763.9013.55.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 08:19:23AM +0200, Eric Dumazet wrote:
> Le mardi 06 avril 2010 à 15:05 +1000, Nick Piggin a écrit :
> 
> > Also if anyone else is looking at a way to do _really_ scalable
> > refcounting elsewhere, this could be a good template (I certainly looked
> > here first when trying to get ideas for vfsmount refcounting).
> 
> Yes, nice trick Nick, I was thinking about it for network code :)
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> I confess the smp_wmb() in module_put() bothered me a bit until I saw it
> was only a barrier() on X86 (if !CONFIG_X86_OOSTORE)

Yep. smp_wmb() and smp_rmb() are both noops on x86 (OOSTORE is some
really obscure thing that we don't need to worry about really). On
POWER6/7 CPUs, it uses lwsync which is fairly cheap as well.

I think refcounting in _general_ needs a smp_wmb() (or, to be more
precise, probably a release barrier) before decrements because you don't
want previous futzing with the object to leak into after a final
decrement may be observed by another CPU. So it might be hard to avoid
anyway.

