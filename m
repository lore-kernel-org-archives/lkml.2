Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2GAJCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 05:02:37 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:37264 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2GAJCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 05:02:35 -0400
X-Greylist: delayed 1556 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jul 2012 05:02:35 EDT
Date: Sun, 1 Jul 2012 04:36:05 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: john stultz <johnstul@us.ibm.com>
Cc: Jan Engelhardt <jengelh@inai.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        simon@fire.lp0.eu, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Leap second insertion causes futex to repeatedly timeout
Message-ID: <20120701083605.GA2692@ghc17.ghc.andrew.cmu.edu>
References: <alpine.LNX.2.01.1207010247430.7313@frira.zrqbmnf.qr>
 <CANcMJZBcpWzJWCdV8XN6cOUsbykZ-0dre=FBP-zRDhHfi1MwrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANcMJZBcpWzJWCdV8XN6cOUsbykZ-0dre=FBP-zRDhHfi1MwrQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1800_1899 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 01:16:13AM -0700, john stultz wrote:
> On Sat, Jun 30, 2012 at 5:57 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> >
> > This year's leap second insertion has had the strange effect on at least
> > Linux versions 3.4.4 (my end) and 3.5-rc4 (Simon's box, Cc) that certain
> > processes use up all CPU power, because of futexes repeatedly timing
> > out. This seems to only affect certain processes.
> >
> > Simon observes - http://s85.org/owXfmLvt - that
> > Firefox/Thunderbird/Chrome/Java are affected.
> >
> > As for me, it affects VirtualBox, mysqld and ksoftirqd. The processes
> > continue to run and respond. Most weird: I can stop-start mysqld and the
> > issue persists. (I would have expected it to go away because the leap
> > second event would then be in the past that mysqld does not know about
> > anymore.)
> >
> >
> > Is this a kernel issue? glibc?
> 
> Some of the reports that the issue is resolved by calling:
>        $ date -s "`date`"
> suggests that it might be due to clock_was_set() not being called
> after the leap second was added, causing some hrtimer confusion.
> 
> Thomas: does that sound about right?
> 
> I've got an initial patch to add the clock_was_set() calls where
> needed, but so far have not been able to reproduce the issue (tried
> firefox and some simpler futex tests).  I'll keep trying and hopefully
> have something to send out tomorrow.
> 
> Again, my apologies for the trouble.

I can't vouch for whether this is the problem or not, but be very
careful with clock_was_set()! See this commit:

http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg15039.html

In short, clock_was_set() calls on_each_cpu() which is not allowed to be
called in atomic context. Watch out for xtime_lock.

Ben
