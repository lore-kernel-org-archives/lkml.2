Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0DIAWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:22:53 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50359 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0DIAWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qAQ6lsnrZlVuoKZk5FGcwyxwYSYYWKGH+3Vd4v6bsdMxu50pt2CuVx4idcBBKCBlsb
         LG2wNfZBX1egXgYmEhvtt8zyzObKVXCtDsOi+DsoFLjLIzmxDX34QRnq6PtdHaCD1rSa
         XsGJMH7pavz2ouwO/9vyk+A/itxMc8ZztUUVE=
Date: Fri, 9 Apr 2010 02:22:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100409002243.GD6672@nowhere>
References: <20100323213338.GA29170@redhat.com> <20100406141321.GA8416@nowhere> <20100406185938.GT15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406185938.GT15159@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 02:59:38PM -0400, Don Zickus wrote:
> > I fear the cpu clock is not going to help you detecting any hard lockups.
> > If you're stuck in an interrupt or an irq disabled loop, your cpu clock is
> > not going to fire.
> 
> Yup.  I put that in the changelog of some nmi code I posted a few weeks
> ago.  I believe Ingo was looking to have a fallback plan in case hw perf
> events wasn't available.


I'm not sure a fallback plan is welcome. What we want is a single
implementation.
If archs already have their own hardlockup detectors, then good
for them as they have this fallback implementation already.

For those who haven't it or who want to profit from a generic
code that does a good deal of the error prone work for them already,
they can just implement a basic perf support for the cpu-cycle
events.

Perf events gives a chance to provide a generic support for hardlockup
detection and supporting a fallback solution from generic code would
be a waste of time.

 
> With this code, moving to sw perf events, kinda kills the ability to
> detect hard lockups, but you can still detect softlockups.


Totally. Actually the hardlockup part should be even ifdef'ed.
What is not nice is that we have a dependency to CONFIG_PERF_EVENT
for the softlockup detector now while that could be avoided easily.

You have the following layer:

- A task that updates softlockup last touch
- An hrtimer that wakes up this task and logs the irq progression
- A (in the best case) NMI that checks the irq progression and the softlockup
  last touch progression.

Why not moving the softlockup last touch progression check from the hrtimer too?
This way you avoid the perf events dependency for the softlockup detector.
The new layer can then be:

- The task
- hrtimer: check softlockup last touch progression (is_softlockup()) and
  then wake up the task again. Log irq progression.
- NMI: check irq progression.

This way can just ifdef all the perf events related things, only useful
for the hardlockup detector. And the softlockup detector can still be used
by archs that don't have perf events support.

