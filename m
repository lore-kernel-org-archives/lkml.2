Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1FIX5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:57:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50277 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab1FIX5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=M7ICEHvFVVq+e6ITaicJ2OkfDmP3YyThl2RgvjFnLaQiXQL8E7tgENjlBmxD2mePYz
         mqghGo2PDkx5kc2+sn6w==
Date: Thu, 9 Jun 2011 16:57:29 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
In-Reply-To: <20110609140714.fc9ea187.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1106091655560.2710@sister.anvils>
References: <20110609130647.937204592@chello.nl> <20110609131307.493181962@chello.nl> <20110609130617.f8aca966.akpm@linux-foundation.org> <20110609202707.GA28951@elte.hu> <1307652883.2497.1028.camel@laptop>
 <20110609140714.fc9ea187.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011, Andrew Morton wrote:
> On Thu, 09 Jun 2011 22:54:43 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2011-06-09 at 22:27 +0200, Ingo Molnar wrote:
> > 
> > > > > @@ -1271,8 +1273,8 @@ void console_unlock(void)
> > > > >  	if (unlikely(exclusive_console))
> > > > >  		exclusive_console = NULL;
> > > > >  
> > > > > -	up(&console_sem);
> > > > >  	spin_unlock_irqrestore(&logbuf_lock, flags);
> > > > > +	up(&console_sem);
> > > > >  	if (wake_klogd)
> > > > >  		wake_up_klogd();
> > > > >  }
> > > > 
> > > > I have a horrible feeling that I put the up() inside logbuf_lock for
> > > > Special And Cunning Reasons.  But I'm struggling to work out what they
> > > > might have been and my archives only go back to October 2000(!).
> > > > 
> > > > Hate it when that happens.
> > > 
> > > Heh, here's what i told Peter two days ago when i saw that chunk:
> > > 
> > >   => Subject: printk: Release console_sem after logbuf_lock
> > >   => i have some vague memories about some sort of complication in that area ...
> > >   => but don't remember the specifics
> > >   => only a 'there be dragons' mental marker
> > 
> > Right, my reply was that I couldn't convince myself unlock order could
> > make a difference, but clearly I can easily have missed something
> > subtle.
> 
> I wish I could find the darned patch.  I have a file here
> no-console-lock-2.patch which was last diffed on October 7, 1999 but it
> has no changelog :(
> 
> But this:
> http://lkml.indiana.edu/hypermail/linux/kernel/0109.2/0127.html is Sep
> 2001 and I have an earlier (unchangelogged) no-console-lock.patch diffed
> against 2.4.2 in March 2001.
> 
> It's odd that the patch (and changelog) don't appear in my lkml
> archives.  Sigh, http://www.youtube.com/watch?v=oO3YmT2d-8k

Does your mail below stir any useful memories?

>From andrewm@uow.edu.au Sun Mar  4 11:19:14 2001
Date: Sun, 04 Mar 2001 18:31:56 +1100
From: Andrew Morton <andrewm@uow.edu.au>
To: linux-fbdev-devel@sourceforge.net, lkml <linux-kernel@vger.kernel.org>, lad <linux-audio-dev@ginette.musique.umontreal.ca>, James Simmons <jsimmons@linux-fbdev.org>, Brad Douglas <brad@neruo.com>
Subject: [prepatches] removal of console_lock


All console-related activity curently happens under spin_lock_irqsave(&console_lock). 
This causes interrutps to be blocked for 1-2 milliseconds with vgacon, and for
hundreds of milliseconds with fbdevs.  This results in network overruns, audio
dropouts, dropped characters on serial ports and other such nice things.

This patch fixes it.  Interrupts are enabled across all console operations.

It's still somewhat a work-in-progress.

- There are (pre-existing) races around the timer functions in
  console.c. The dirty fix is to push all this stuff into keventd
  context and to use acquire_cosole_sem().  The clean fix is to
  rewrite the timer state machine.

  Or do nothing.  This thing only fires four times a day, the race
  doesn't look like it'll crash the machine and there have been no
  bug reports...

- console_print().   blah.  What's this for?  I just mapped it
  onto printk().  My preferred option is to kill it off altogether.


I'm putting this out now for comments, and for interested parties to
test.  Please.  I'm serious.


Patches against 2.4.3-pre1 and 2.4.2-ac9 are at

	http://www.uow.edu.au/~andrewm/linux/console.html

These patches are ~1600 lines and touch 35 files.



Some notes:

- show_console() had been removed.  It's unused.

- console_tasklet has been replaced with a keventd callback,
  `console_callback'.

- unblank_console() has gone.  It was only used by panic(),
  and...

- ... the call to poke_blanked_console() in vt_console_print() has
  been restored.  It doesn't deadlock during oopses now.

- arch/s390x/kernel/cpprintk.c has been removed.

- bust_spinlocks() has been enhanced (x86 and mips64).

- Major revamp of printk().  The approach taken in printk() is to try
  to acquire the (new) console_sem.  If we succeed, the output is
  placed into the log buffer and is printed to the consoles.  If we fail
  to acquire the semaphore we just buffer the output in the log buffer
  and the current holder of the console_sem will do the printing for us
  prior to releasing console_sem.

  If an oops is in progress we simply reset the locking and print
  things immediately.

- Added a new syslog() mode: syslog(9, ...).  It returns the number
  of characters which are currently queued in the log buffer.  Needed
  to do this for kmsg_poll().

- Being heartily sick of reverse-engineering interface information
  from implementations, I have gratuitously added comments in several
  random parts of the kernel.  Shoot me.

- Several video drivers are using spin_lock() in a timer
  handler.  There's a remote possibility that these can
  deadlock (say, the timer fires again while the lock is held).
  These have been changed to use _irqsave.

- The various low-level drivers have been reviewed to ensure that
  they are safe when interrupts are enabled.  Looks OK.

-
