Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab0IHHuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:50:03 -0400
Received: from gw1.transmode.se ([213.115.205.20]:52794 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab0IHHuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:50:00 -0400
Subject: slow nanosleep?
X-KeepSent: 71DD00AE:26643E4D-C1257798:00250630;
 type=4; name=$KeepSent
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 8 Sep 2010 09:45:12 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1FP3|May 23, 2010) at
 2010-09-08 09:49:58
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas

while playing with nanosleep I noticed that it is slow
compared to select. This little test program shows what
the effect:
#include <time.h>
#include <sys/time.h>
#include <stdio.h>
#define NANO_SLEEP 1
main()
{
	struct timespec req, rem;
	struct timeval tv1, tv2, tv_res;
	int res;

	rem.tv_sec = 0;
	rem.tv_nsec = 0;

	req.tv_sec = 0;
	req.tv_nsec = 0;

	tv2.tv_sec = req.tv_sec;
	tv2.tv_usec = req.tv_nsec/1000;

	gettimeofday(&tv1, NULL);
#ifdef NANO_SLEEP
	res = nanosleep(&req, &rem);
#else
	res = select(0, NULL,NULL,NULL, &tv2);
#endif
	gettimeofday(&tv2, NULL);
	timersub(&tv2, &tv1, &tv_res);
#ifdef NANO_SLEEP
	printf("nanosleep\n");
#else
	printf("selectsleep\n");
#endif
	printf("req:%d :%d\n", (int)req.tv_sec, (int)req.tv_nsec/1000);
	printf("tv_res:%d :%d\n", (int)tv_res.tv_sec, (int)tv_res.tv_usec);
}
root@localhost ~ # ./nanosleep
nanosleep
req:0 :0
tv_res:0 :119
root@localhost ~ # ./selectsleep
selectsleep
req:0 :0
tv_res:0 :36


Isn't nanosleep to slow here? The min time is about 120 us compared
to select which is 36 us. I would expect nanosleep to be better than
select.

Kernel 2.6.35 with HIGH_RES timers on Powerpc(MPC8321, 266 MHz)
x86 shows the same effect.

    Jocke

