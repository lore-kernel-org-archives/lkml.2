Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414Ab0IHH4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:56:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39373 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab0IHH4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pE4JQioSz0nrtl2x0MVuSTPnQX8dn7fHkqH4pzJ9woINBJyVaB085Py2tTOkF/Y7wO
         7Rf51Q99AyQrnyMwsiEdk2wBQiEOSl08boBwQz5yTWlDIZM8zLNWc3Hjn78/M17J9F3J
         ZECd2Fo7dbmqDVj5YWTpxg/CfOt4tKx6UNpLE=
Subject: Re: slow nanosleep?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 09:56:40 +0200
Message-ID: <1283932600.2880.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 septembre 2010 à 09:45 +0200, Joakim Tjernlund a écrit :
> Hi Thomas
> 
> while playing with nanosleep I noticed that it is slow
> compared to select. This little test program shows what
> the effect:
> #include <time.h>
> #include <sys/time.h>
> #include <stdio.h>
> #define NANO_SLEEP 1
> main()
> {
> 	struct timespec req, rem;
> 	struct timeval tv1, tv2, tv_res;
> 	int res;
> 
> 	rem.tv_sec = 0;
> 	rem.tv_nsec = 0;
> 
> 	req.tv_sec = 0;
> 	req.tv_nsec = 0;
> 
> 	tv2.tv_sec = req.tv_sec;
> 	tv2.tv_usec = req.tv_nsec/1000;
> 
> 	gettimeofday(&tv1, NULL);
> #ifdef NANO_SLEEP
> 	res = nanosleep(&req, &rem);
> #else
> 	res = select(0, NULL,NULL,NULL, &tv2);
> #endif
> 	gettimeofday(&tv2, NULL);
> 	timersub(&tv2, &tv1, &tv_res);
> #ifdef NANO_SLEEP
> 	printf("nanosleep\n");
> #else
> 	printf("selectsleep\n");
> #endif
> 	printf("req:%d :%d\n", (int)req.tv_sec, (int)req.tv_nsec/1000);
> 	printf("tv_res:%d :%d\n", (int)tv_res.tv_sec, (int)tv_res.tv_usec);
> }
> root@localhost ~ # ./nanosleep
> nanosleep
> req:0 :0
> tv_res:0 :119
> root@localhost ~ # ./selectsleep
> selectsleep
> req:0 :0
> tv_res:0 :36
> 
> 
> Isn't nanosleep to slow here? The min time is about 120 us compared
> to select which is 36 us. I would expect nanosleep to be better than
> select.
> 
> Kernel 2.6.35 with HIGH_RES timers on Powerpc(MPC8321, 266 MHz)
> x86 shows the same effect.
> 

You need :

#define PR_SET_TIMERSLACK 29

prctl(PR_SET_TIMERSLACK, 1); /* 1 nsec resolution, please */



