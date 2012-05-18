Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab2ERMO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:14:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41839 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2ERMO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:14:57 -0400
Date: Fri, 18 May 2012 05:14:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120518121401.GF2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120428034257.GA2495@linux.vnet.ibm.com>
 <20120501000245.GA4329@linux.vnet.ibm.com>
 <4F9FA50C.9070600@wanadoo.fr>
 <20120501154513.GD2441@linux.vnet.ibm.com>
 <4FA3EAEE.9030601@wanadoo.fr>
 <20120504150411.GC2411@linux.vnet.ibm.com>
 <4FA44CF9.7050604@wanadoo.fr>
 <20120504231442.GT2411@linux.vnet.ibm.com>
 <20120514223255.GA5719@linux.vnet.ibm.com>
 <4FB62C15.7080703@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB62C15.7080703@wanadoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051812-1780-0000-0000-000005AF8E4A
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000275; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00140228; UDB=6.00032469; UTC=2012-05-18
 12:14:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 01:01:41PM +0200, Pascal Chapperon wrote:
> Le 15/05/2012 00:32, Paul E. McKenney a écrit :
> >On Fri, May 04, 2012 at 04:14:42PM -0700, Paul E. McKenney wrote:
> >>On Fri, May 04, 2012 at 11:41:13PM +0200, Pascal Chapperon wrote:
> >>>Le 04/05/2012 17:04, Paul E. McKenney a écrit :
> >>>>On Fri, May 04, 2012 at 04:42:54PM +0200, Pascal Chapperon wrote:
> >>>>>Le 01/05/2012 17:45, Paul E. McKenney a écrit :
> >>>>>
> >>>>>>Here is my RCU_FAST_NO_HZ patch stack on top of v3.4-rc4.
> >>>>>>
> >>>>>>Or you can pull branch fnh.2012.05.01a from:
> >>>>>>
> >>>>>>	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> >>>>>>
> >>>>>>							Thanx, Paul
> >>>>>>
> >>>>>I applied your global patch on top of v3.4-rc4. But the slowdown is
> >>>>>worse than before : boot sequence took 80s instead 20-30s (12s for
> >>>>>initramfs instead of 2s).
> >>>>>
> >>>>>I'll send you rcu tracing log in a second mail.
> >>>>
> >>>>Hmmm...  Well, I guess I am glad that I finally did something that
> >>>>had an effect, but I sure wish that the effect had been in the other
> >>>>direction!
> >>>>
> >>>>Just to make sure I understand: the difference between the 20-30s and
> >>>>the 80s is exactly the patch I sent you?
> >>>>
> >>>>							Thanx, Paul
> >>>>
> >>>>
> >>>Yes. Exactly same kernel config as in previous results, I applied
> >>>your patch against v3.4-rc4, and sorry, the result is exactly what I
> >>>said;
> >>>I saw that your global patch was quite huge, and addresses things which
> >>>are not directly related with the initial patch (commit
> >>>7cb92499000e3c86dae653077b1465458a039ef6); maybe a side effect?
> >>>
> >>>However, I'm ready to try this patch on my smaller laptop which
> >>>supports well CONFIG_FAST_NO_HZ=y and systemd, if you think it can
> >>>help ?
> >>>
> >>>Another thought: this issue as nothing to do with i7 Hyper-threading
> >>>capacities ? (as I test core2duo, Pentium ulv in same conditions and I
> >>>don't encountered any slowdown ?)
> >>
> >>Well, one possibility is that your setup starts the jiffies counter
> >>at some interesting value.  The attached patch (also against v3.4-rc4)
> >>applies a bit more paranoia to the initialization to handle this
> >>and other possibilities.
> >
> >This patchset fixes the problem where RCU_FAST_NO_HZ's timers were
> >being ignored due to the dyntick-idle code having already calculated
> >the CPU's wakeup time (which I sent earlier, mistakenly offlist), but
> >also fixes a botched check in my workaround.
> >
> >Could you please try it out?  This patch is against 3.4-rc4.
> >
> >							Thanx, Paul
> >
> Hi Paul,
> 
> < +     if (!rcu_cpu_has_nonlazy_callbacks(cpu))
> ---
> > +     if (rcu_cpu_has_nonlazy_callbacks(cpu))
> 
> I was a little disappointed by the previous patch (boot sequence still
> took 72 s.), but this one makes a huge difference ;-)
> Slowdown during boot or shutdown with CONFIG_RCU_FAST_NO_HZ has
> disappeared (~ 10 attempts) :
> # systemd-analyze
> Startup finished in 1990ms (kernel) + 1174ms (initramfs) + 3121ms
> (userspace) = 6285ms
> .

Very good!  And thank you very much for all your testing efforts and
for bearing with me through this!

Does this mean that I can add your Tested-by?

> Do you want the rcu tracing log for this patch ?

Could you please?  Just in case there is some other surprise that
I should know about that might not be visible.  ;-)

							Thanx, Paul

