Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab0IHJvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:51:44 -0400
Received: from www.tglx.de ([62.245.132.106]:55529 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab0IHJvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:51:42 -0400
Date: Wed, 8 Sep 2010 11:51:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: slow nanosleep?
In-Reply-To: <OF2B75FA7C.7064BC41-ONC1257798.00318FDA-C1257798.00329AEF@transmode.se>
Message-ID: <alpine.LFD.2.00.1009081143200.2477@localhost6.localdomain6>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>  <1283932600.2880.1.camel@edumazet-laptop>  <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se> <1283934289.2880.12.camel@edumazet-laptop>
 <OF2B75FA7C.7064BC41-ONC1257798.00318FDA-C1257798.00329AEF@transmode.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1394950388-1283939474=:2477"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1394950388-1283939474=:2477
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 8 Sep 2010, Joakim Tjernlund wrote:

> Eric Dumazet <eric.dumazet@gmail.com> wrote on 2010/09/08 10:24:49:
> >
> > Le mercredi 08 septembre 2010 à 10:04 +0200, Joakim Tjernlund a écrit :
> >
> > > That makes litte difference:
> > > root@localhost ~ # ./nanosleep
> > > nanosleep
> > > req:0 :0
> > > tv_res:0 :112
> > >
> >
> > Here, result is 30 (with prctl())
> > instead of 95 (without)
> 
> On x86 I notice a difference:
>   7 vs 57.
> however select is still faster: 2
> The system call OH seems to be bigger for nanosleep than
> for select and on my ppc is is about 112 us. Can anything
> be done about that?

Hmm, the only reason I can see is that select calls finally
schedule_hrtimeout_range_clock() which optimizes the expiry = 0 case
while nanosleep does not. So the difference is only visiable when the
relative timeout is 0. For timeouts > 0 nanosleep and select should
behave the same way.

Thanks,

	tglx
---
 kernel/hrtimer.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1609,6 +1609,9 @@ SYSCALL_DEFINE2(nanosleep, struct timesp
 	if (!timespec_valid(&tu))
 		return -EINVAL;
 
+	if (!tu.tv_sec && !tu.tv_usec)
+		return 0;
+
 	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 }
 

---1463795968-1394950388-1283939474=:2477--
