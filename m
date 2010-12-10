Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0LJSkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:40:52 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:29858 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754055Ab0LJSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:40:51 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: x4EtqaIVM1kg.7D4_SLuSDahu8TCi5niCvq48YxXiuE2Tkc
 xDpimqXCp6Os.KJRLLwSeYvmlxLUmze4ICZtBSvNURS_eAti7pzNW3VpvyZ3
 jTlO3PBXtVqsXnJviNKu_9v4dReazzvcZxPH.KU53nwW7RBpyLaWjjTAgy.6
 qDSV.ivsRqKg2FrvokkvDCCbmoDr6jaz7lGQTC21aJvV439pan_Bb.9hrk2c
 fQvADVHudHiVWae5JzcC1swF7IuNyzvNZzven_NGNrfpYGTCWvykoiqz0UlT
 XP.PAq7Fw3F5pWfrVGG5CFTK0FrKgdnpFS4n7DruVM6zzF0Y-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 10 Dec 2010 12:39:39 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
In-Reply-To: <1292004859.3580.387.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1012101236300.13986@router.home>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>  <1291851079-27061-1-git-send-email-venki@google.com>  <1291899120.29292.7.camel@twins>  <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>  <1291917330.6803.7.camel@twins> 
 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>  <1291920939.6803.38.camel@twins>  <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>  <1291936593.13513.3.camel@laptop>  <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
  <1291975704.6803.59.camel@twins>  <1291987065.6803.151.camel@twins>  <1291987635.6803.161.camel@twins>  <1291988866.6803.171.camel@twins>  <1292001500.3580.268.camel@edumazet-laptop>  <1292003346.13513.30.camel@laptop>
 <1292004859.3580.387.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Eric Dumazet wrote:

> > Yeah, but that kinda defeats the purpose of having it implemented in
> > seqlock.h. Ideally we'd teach gcc about these long pointers and have
> > something like:
> >
> >   write_seqcount_begin(&this_cpu_read(irq_time_seq));
> >
> > do the right thing.
>
> gcc wont be able to do this yet (%fs/%gs selectors)

The kernel can do that using the __percpu annotation.

> But we can provide this_cpu_write_seqcount_{begin|end}()

No we cannot do hat. this_cpu ops are for per cpu data and not for locking
values shared between processors. We have a mechanism for passing per cpu
pointers with a corresponding annotation.

> static inline void this_cpu_write_seqcount_begin(seqcount_t *s)
				^^^ Would have to be seqcount_t __percpu *s

> {
> 	__this_cpu_inc(s->sequence);
> 	smp_wmb();
> }


