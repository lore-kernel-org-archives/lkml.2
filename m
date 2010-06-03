Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab0FCLG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 07:06:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:34296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0FCLG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 07:06:56 -0400
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: john cooper <john.cooper@third-harmonic.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de,
       tglx@linutronix.de, mtosatti@redhat.com,
       john cooper <john.cooper@redhat.com>
In-Reply-To: <20100601193659.GC11880@basil.fritz.box>
References: <20100601093515.GH24302@redhat.com>
	 <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com>
	 <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com>
	 <4C05493F.1040107@third-harmonic.com>
	 <20100601193659.GC11880@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 12:06:39 +0100
Message-ID: <1275563199.2383.1873.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 21:36 +0200, Andi Kleen wrote:
> > Collecting the contention/usage statistics on a per spinlock
> > basis seems complex.  I believe a practical approximation
> > to this are adaptive mutexes where upon hitting a spin
> > time threshold, punt and let the scheduler reconcile fairness.
> 
> That would probably work, except: how do you get the
> adaptive spinlock into a paravirt op without slowing
> down a standard kernel?

It only ever comes into play in the case where the spinlock is contended
anyway -- surely it shouldn't be _that_ much of a performance issue?

See the way that ppc64 handles it -- on a machine with overcommitted
virtual cpus, it will call __spin_yield (arch/powerpc/lib/locks.c) on
contention, which may cause the virtual CPU to donate its hypervisor
timeslice to the vCPU which is actually holding the lock in question.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

