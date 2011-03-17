Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1CQUF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:05:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48224 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1CQUF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:05:28 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=_zN6tvs7zQ8A:10 a=8nJEP1OIZ-IA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=tIf7s-yrhHochpXFCKoA:9 a=9XWP2n6pjZNLSbgtSBQA:7 a=D6xIzAhUfG7A9phUs0s93zKQpKkA:4 a=wPNLvfGTeEIA:10 a=0kPLrQdw3YYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 17 Mar 2011 16:05:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, Knut Petersen <Knut_Petersen@t-online.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Chris Wilson <chris@chris-wilson.co.uk>, jesse.barnes@intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        David =?iso-8859-1?Q?M=FCller?= <d.mueller@elsoft.ch>
Subject: Re: [BUG][2.6.38] IRQ Lock Inversion / i915 fails
Message-ID: <20110317200526.GE14675@home.goodmis.org>
References: <4D81D6F9.3040304@t-online.de>
 <AANLkTim=R7GVDY0Nt-6q1mjO3vas-qRy7=VxqgWWtz_s@mail.gmail.com>
 <s5haagtvfc2.wl%tiwai@suse.de>
 <AANLkTi=ZSS=gDtGOcKBdE0BfJLpu0Ye1UhuNcbkz70Vs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=ZSS=gDtGOcKBdE0BfJLpu0Ye1UhuNcbkz70Vs@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 10:33:04AM -0700, Linus Torvalds wrote:
> On Thu, Mar 17, 2011 at 10:15 AM, Takashi Iwai <tiwai@suse.de> wrote:
> >
> > The trigger callback should be called always in irq-disabled context,
> > so this should be OK.
> 
> Oh, ok. I missed the snd_pcm_action_lock_irq() thing disabling
> interrupts in that call sequence..
> 
> > But loopback_pos_update() is called in the
> > timer callback, and this can be the issue.
> 
> Hmm. If the timer callback is the only other case doing that, then
> that should be ok.
> 
> In fact, now that I look at that lockdep thing, I'm confused. Where
> does the hard irq come in at all for that lock? It seems to come from
> self_group.lock, but I don't see why/how they nest.

Here's the issue. It's quite subtle.


	CPU0			CPU1
	----			----
				spin_lock(cable->lock);
spin_lock(group->lock);
spin_lock(cable->lock);
	<blocked>
				<interrupt>
				spin_lock(group->lock);
				<deadlock>

If any lock is taken while holding a lock that can be used in interrupt
context, then that lock must also be protected from interrupts as well,
even if that lock has nothing to do with interrupts.

Lockdep reported that the cable->lock was held while holding the
substream->self_group->lock, and it looks like that substream->self_group->lock
can also be taken in interrupt context.

-- Steve

> 
> That said, the sound locking is odd, I'm sure you see it. But a
> commentary about how this came about in the changelog would be good.

