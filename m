Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab0IHIFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:05:10 -0400
Received: from gw1.transmode.se ([213.115.205.20]:34238 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab0IHIFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:05:07 -0400
In-Reply-To: <1283932600.2880.1.camel@edumazet-laptop>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se> <1283932600.2880.1.camel@edumazet-laptop>
Subject: Re: slow nanosleep?
X-KeepSent: 5074952F:1B97B2B8-C1257798:002C51D7;
 type=4; name=$KeepSent
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 8 Sep 2010 10:04:50 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1FP3|May 23, 2010) at
 2010-09-08 10:05:06
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote on 2010/09/08 09:56:40:
>
> Le mercredi 08 septembre 2010 à 09:45 +0200, Joakim Tjernlund a écrit :
> > Hi Thomas
> >
> > while playing with nanosleep I noticed that it is slow
> > compared to select. This little test program shows what
> > the effect:
> > #include <time.h>
> > #include <sys/time.h>
> > #include <stdio.h>
> > #define NANO_SLEEP 1
> > main()
> > {
> >    struct timespec req, rem;
> >    struct timeval tv1, tv2, tv_res;
> >    int res;
> >
> >    rem.tv_sec = 0;
> >    rem.tv_nsec = 0;
> >
> >    req.tv_sec = 0;
> >    req.tv_nsec = 0;
> >
> >    tv2.tv_sec = req.tv_sec;
> >    tv2.tv_usec = req.tv_nsec/1000;
> >
> >    gettimeofday(&tv1, NULL);
> > #ifdef NANO_SLEEP
> >    res = nanosleep(&req, &rem);
> > #else
> >    res = select(0, NULL,NULL,NULL, &tv2);
> > #endif
> >    gettimeofday(&tv2, NULL);
> >    timersub(&tv2, &tv1, &tv_res);
> > #ifdef NANO_SLEEP
> >    printf("nanosleep\n");
> > #else
> >    printf("selectsleep\n");
> > #endif
> >    printf("req:%d :%d\n", (int)req.tv_sec, (int)req.tv_nsec/1000);
> >    printf("tv_res:%d :%d\n", (int)tv_res.tv_sec, (int)tv_res.tv_usec);
> > }
> > root@localhost ~ # ./nanosleep
> > nanosleep
> > req:0 :0
> > tv_res:0 :119
> > root@localhost ~ # ./selectsleep
> > selectsleep
> > req:0 :0
> > tv_res:0 :36
> >
> >
> > Isn't nanosleep to slow here? The min time is about 120 us compared
> > to select which is 36 us. I would expect nanosleep to be better than
> > select.
> >
> > Kernel 2.6.35 with HIGH_RES timers on Powerpc(MPC8321, 266 MHz)
> > x86 shows the same effect.
> >
>
> You need :
>
> #define PR_SET_TIMERSLACK 29
>
> prctl(PR_SET_TIMERSLACK, 1); /* 1 nsec resolution, please */

That makes litte difference:
root@localhost ~ # ./nanosleep
nanosleep
req:0 :0
tv_res:0 :112

