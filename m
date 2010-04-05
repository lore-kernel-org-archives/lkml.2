Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab0DEJas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 05:30:48 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54226 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0DEJan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 05:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qTWa3yTnleIT1FcoihPLCLsqq4Xx6UDe4B65c/l1Q2qrOrzoiLC8H0AqWIqt2S2VNz
         lvelSTry+o7ErkqHvUX1hCObWVuelKTksgx60UFVdTmdCUCy7DON2OYnuY8i8ECwFqHn
         ponXXwors3viJ/s3GpoUlqsGgoUZXyDPikA6g=
Subject: Re: Reading entropy_avail file appears to consume entropy
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: Alexander Konovalenko <alexkon@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4BB99654.4090203@computer.org>
References: <epOXE-4EU-7@gated-at.bofh.it>
	 <b7822cd7-97f3-489e-a16b-686b0419d3f2@k19g2000yqn.googlegroups.com>
	 <4BB99654.4090203@computer.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Apr 2010 11:30:37 +0200
Message-ID: <1270459837.4722.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 05 avril 2010 à 09:50 +0200, Jan Ceuleers a écrit :
> Alexander Konovalenko wrote:
> > On Mar 19, Jan Ceuleers wrote:
> >> I'm using the 2.6.31 kernel that comes with Ubuntu 9.10.
> >>
> >> If I
> >>
> >>    # watch cat /proc/sys/kernel/random/entropy_avail
> >>
> >> then the size of the entropy pool falls rapidly (by more than 200 bytes per 2s interval).
> >> It settles down around 160 bytes.
> > 
> > Jan, did you find out anything interesting about this issue?
> > 
> > I have a wild guess, although I have no idea whether it can be
> > correct. I couldn't catch any user-space /dev/random or /dev/urandom
> > readers with fuser, so I think something in the kernel is using up the
> > entropy. If I remember correctly, recent Ubuntu releases were supposed
> > to include a security feature that randomizes memory layout in order
> > to mitigate some kinds of security vulnerabilities. What if each time
> > a new process is started the kernel needs to obtain a significant
> > number of random bytes? Here is some supporting evidence. I can
> > reproduce the behavior you describe on a vanilla Ubuntu 9.10 system
> > (without latest updates). But if I watch entropy_avail using a Python
> > script that does not start a new process every time, then the
> > available entropy amount won't decrease. (The system is otherwise
> > idle.) Give it a try:
> > 
> > $ python
> > import sys, time
> > while True:
> >   sys.stdout.write(open('/proc/sys/kernel/random/entropy_avail',
> > 'r').read())
> >   time.sleep(1)
> > 
> > It would be great if someone with knowledge about this could confirm
> > or refute my guess.
> > 
> >  -- Alexander
> > 
> 
> Alexander,
> 
> Thanks, this never made it out to LKML so I'm forwarding it now.
> 
> This does sound quite plausible; does anyone from Ubuntu want to chip in?
> 

Nothing related to Ubuntu I guess


commit f06295b44c296c8fb08823a3118468ae343b60f2
Author: Kees Cook <kees.cook@canonical.com>
Date:   Wed Jan 7 18:08:52 2009 -0800

    ELF: implement AT_RANDOM for glibc PRNG seeding
    
    While discussing[1] the need for glibc to have access to random bytes
    during program load, it seems that an earlier attempt to implement
    AT_RANDOM got stalled.  This implements a random 16 byte string, available
    to every ELF program via a new auxv AT_RANDOM vector.
    
    [1] http://sourceware.org/ml/libc-alpha/2008-10/msg00006.html
    
    Ulrich said:
    
    glibc needs right after startup a bit of random data for internal
    protections (stack canary etc).  What is now in upstream glibc is that we
    always unconditionally open /dev/urandom, read some data, and use it.  For
    every process startup.  That's slow.
    
    ...
    
    The solution is to provide a limited amount of random data to the
    starting process in the aux vector.  I suggested 16 bytes and this is
    what the patch implements.  If we need only 16 bytes or less we use the
    data directly.  If we need more we'll use the 16 bytes to see a PRNG.
    This avoids the costly /dev/urandom use and it allows the kernel to use
    the most adequate source of random data for this purpose.  It might not
    be the same pool as that for /dev/urandom.
    
    Concerns were expressed about the depletion of the randomness pool.  But
    this patch doesn't make the situation worse, it doesn't deplete entropy
    more than happens now.
    
    Signed-off-by: Kees Cook <kees.cook@canonical.com>
    Cc: Jakub Jelinek <jakub@redhat.com>
    Cc: Andi Kleen <andi@firstfloor.org>
    Cc: Ulrich Drepper <drepper@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


