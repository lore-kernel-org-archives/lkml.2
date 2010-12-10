Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0LJRt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:49:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:42054 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0LJRtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:49:25 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1292001500.3580.268.camel@edumazet-laptop>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	 <1291851079-27061-1-git-send-email-venki@google.com>
	 <1291899120.29292.7.camel@twins>
	 <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	 <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
	 <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
	 <1291936593.13513.3.camel@laptop>
	 <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
	 <1291975704.6803.59.camel@twins>  <1291987065.6803.151.camel@twins>
	 <1291987635.6803.161.camel@twins>  <1291988866.6803.171.camel@twins>
	 <1292001500.3580.268.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 18:49:06 +0100
Message-ID: <1292003346.13513.30.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 18:18 +0100, Eric Dumazet wrote:
> Le vendredi 10 décembre 2010 à 14:47 +0100, Peter Zijlstra a écrit :

> Also irq_time_write_begin() and irq_time_write_end() could be faster
> (called for current cpu)
> 
> static inline void irq_time_write_begin(void)
> {
> 	__this_cpu_inc(irq_time_seq.sequence);
> 	smp_wmb();
> }
>  
> static inline void irq_time_write_end(void)
> {
> 	smp_wmb();
> 	__this_cpu_inc(irq_time_seq.sequence);
> }

Yeah, but that kinda defeats the purpose of having it implemented in
seqlock.h. Ideally we'd teach gcc about these long pointers and have
something like: 

  write_seqcount_begin(&this_cpu_read(irq_time_seq));

do the right thing.
