Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab0IHMoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:44:14 -0400
Received: from www.tglx.de ([62.245.132.106]:46836 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758714Ab0IHMoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:44:00 -0400
Date: Wed, 8 Sep 2010 14:43:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: slow nanosleep?
In-Reply-To: <OF82705D74.3C13AE80-ONC1257798.00427DAB-C1257798.0042F243@transmode.se>
Message-ID: <alpine.LFD.2.00.1009081442390.2477@localhost6.localdomain6>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>  <1283932600.2880.1.camel@edumazet-laptop>  <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se> <1283934289.2880.12.camel@edumazet-laptop>
 <OF2B75FA7C.7064BC41-ONC1257798.00318FDA-C1257798.00329AEF@transmode.se> <alpine.LFD.2.00.1009081143200.2477@localhost6.localdomain6> <OF82705D74.3C13AE80-ONC1257798.00427DAB-C1257798.0042F243@transmode.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-642736268-1283949820=:2477"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-642736268-1283949820=:2477
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 8 Sep 2010, Joakim Tjernlund wrote:

> Thomas Gleixner <tglx@linutronix.de> wrote on 2010/09/08 11:51:13:
> >
> > On Wed, 8 Sep 2010, Joakim Tjernlund wrote:
> >
> > > Eric Dumazet <eric.dumazet@gmail.com> wrote on 2010/09/08 10:24:49:
> > > >
> > > > Le mercredi 08 septembre 2010 à 10:04 +0200, Joakim Tjernlund a écrit :
> > > >
> > > > > That makes litte difference:
> > > > > root@localhost ~ # ./nanosleep
> > > > > nanosleep
> > > > > req:0 :0
> > > > > tv_res:0 :112
> > > > >
> > > >
> > > > Here, result is 30 (with prctl())
> > > > instead of 95 (without)
> > >
> > > On x86 I notice a difference:
> > >   7 vs 57.
> > > however select is still faster: 2
> > > The system call OH seems to be bigger for nanosleep than
> > > for select and on my ppc is is about 112 us. Can anything
> > > be done about that?
> >
> > Hmm, the only reason I can see is that select calls finally
> > schedule_hrtimeout_range_clock() which optimizes the expiry = 0 case
> > while nanosleep does not. So the difference is only visiable when the
> > relative timeout is 0. For timeouts > 0 nanosleep and select should
> > behave the same way.
> 
> Yes, that is it. Thanks
> 
> However nanosleep with 1 ns and prctl(PR_SET_TIMERSLACK, 1) takes
> about 8 us on x86(Intel(R) Core(TM)2 Duo CPU E8500  @ 3.16GHz)
> and 20 us on my slower ppc board. Is that system call overhead
> or possibly some error?

That's overhead I fear. We go way up to enqueue/arm the timer until we
figure out that the timeout already happened.

Thanks,

	tglx
---1463795968-642736268-1283949820=:2477--
