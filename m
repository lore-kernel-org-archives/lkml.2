Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1CPUlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:41:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60231 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1CPUlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:41:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: scameron@beardog.cce.hp.com
Subject: Re: Question about driver ioctl, big kernel lock, mutexes
Date: Wed, 16 Mar 2011 21:40:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dab@hp.com,
        mike.miller@hp.com
References: <20110316155033.GQ12760@beardog.cce.hp.com> <201103162006.15084.arnd@arndb.de> <20110316194726.GY12760@beardog.cce.hp.com>
In-Reply-To: <20110316194726.GY12760@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103162140.34893.arnd@arndb.de>
X-Provags-ID: V02:K0:j9sr7ruZhQ3gskqXGvLYsB5ANad1rE+jqyAAG9qENWW
 qxnQ71HZFsFUx1HR/STTMMiM2zG/8+dyMFkEwBp0Hrp0N4TPLS
 rvgyPjESz6Ih7NYhlQSF0x8cf5gVB3fLptx5/tyAOLT1ubJF7c
 v0qPmPJLm+moeARAFse1ly3Grs4sxOQAp4Xw5YKO3ooFJbhinu
 8pman5POJRiohWZV3dsEg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 March 2011 20:47:26 scameron@beardog.cce.hp.com wrote:
> On Wed, Mar 16, 2011 at 08:06:14PM +0100, Arnd Bergmann wrote:

> > Absolutely. The best way forward would be to prove that the mutex
> > I introduced is actually pointless, or alternatively change the code
> > so that the mutex is only held in the places where it is really
> > required, if any.
> 
> Pretty sure the ioctl stuff is already thread safe, but I will look at it
> again.
> 
> There are a couple of other places the mutex is used, open, release, I think
> one other place, that I'm less sure about, only because I haven't thought
> about them.  It should be a safe assumption that nothing outside
> the driver depends on these mutexes (obviously, since they're declared
> only in the driver) so that should make it pretty easy to figure out.

Ah, right. The open/release functions use access the two usage_count
variables in an unsafe way. The mutex serializes between the two,
but there are other functions that look at the same data without
taking the mutex. It would be good to make this safer in some
way.

I think turning it into an atomic_t would be enough, unless the
two usage counts need to be strictly taken atomically or in the
context of something else.

The rest of open/close looks fine to me without the mutex.

> > When I submitted the patches, I always tried to make it clear that
> > most of the new mutexes are not required at all, but that proving
> > this for every single driver takes a lot of hard work. 
> > 
> > Having a mutex that should not be there causes a performance regression
> > or a deadlock, both of which are fairly easy to bisect and fix, but
> > missing a mutex because of a subtle BKL dependency would have meant
> > introducing a race condition that would be extremely hard to analyse.
> > 
> > Limiting the number of concurrent I/Os submitted to a device might
> > be a good idea, but I think that's a separate discussion.
> 
> Ok.  Thanks for the explanation and confirmation of what I was thinking.
> I'll start working on a fix for this.  May take me a little while as 
> there are a bunch of other things I have to work on, but it's been
> this way since June of 2010 so far with no complaints (that I know of),
> so I guess it won't hurt too much for it to be this way for a little
> while longer.

I'm curious: what is even the intention behind the passthru ioctls?
Do you have applications that use them a lot?

	Arnd
