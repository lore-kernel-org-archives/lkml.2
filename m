Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0ERPQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:16:16 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:21483 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab0ERPQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:16:14 -0400
MIME-Version: 1.0
Message-ID: <d8d6ecc0-144a-4d7f-a1a0-5c6f290a12ca@default>
Date: Tue, 18 May 2010 08:13:34 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com>
 <87tyq9mqrz.fsf@basil.nowhere.org>
 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
 <20100515121424.38f5b389@infradead.org>
 <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
 <20100515224305.17a04022@infradead.org>
 <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>
 <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>
 <20100516220638.2baf315d@infradead.org> <1274176698.5605.7358.camel@twins>
 <20100518112509.GD22675@basil.fritz.box 1274183935.5605.7726.camel@twins>
In-Reply-To: <1274183935.5605.7726.camel@twins>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BF2AF21.000B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Subject: Re: [PATCH] x86: Export tsc related information in sysfs
> 
> On Tue, 2010-05-18 at 13:25 +0200, Andi Kleen wrote:
> > On Tue, May 18, 2010 at 11:58:18AM +0200, Peter Zijlstra wrote:
> > > On Sun, 2010-05-16 at 22:06 -0700, Arjan van de Ven wrote:
> > > > look we're not disabling ring 3 tsc. We could, but we don't.
> > >
> > > Maybe we should.
> >
> > That would kill the vsyscall too. Remember it's running in ring 3.
> >
> > That is in theory you could disable it on systems where the vsyscall
> > doesn't use it, but then you would likely break huge amounts of
> software,
> > unless you emulate it.
> 
> Well, software shouldn't use it, so breaking it sounds like a fine
> idea ;-)

Last fall, I discovered that EVERY program on RHEL5 (U2?) uses rdtsc
because RHEL5 ld.so uses rdtsc.  The uses are few and harmless but
are there nonetheless.  Clearly that can be fixed, but you might
be surprised how big "huge amounts of software" is.

> Also, a slow emulation is an incentive to actually do the right thing.

Emulation is not particularly slow, especially compared to accessing
the HPET.  If the kernel deems TSC is unsafe, the ring 3 vsyscall
shouldn't be using rdtsc either so the additional trap overhead
might be in the noise.

As long as there is a sysfs file that can override the setting
and there is a counter (accessible via sysfs) that can count
the number of emulated rdtsc/rdtscp instructions (possibly
optionally by pid so the "offending" userland threads can
be tracked down), setting CR4.TSD whenever the kernel deems
TSC is unsafe and emulating rdtsc might be a reasonable solution.
Infrequent rdtsc users won't know or care, and frequent users
will at least be able to learn the frequency of their "sin".

And to help Thomas/Arjan/Ingo/Andi educate users, every read
or write to any of these sysfs files could also result in a
printk of "Use of rdtsc is deprecated... use vsyscalls instead.
See Documentation/friends_dont_let_friends_use_rdtsc."
(Half ;-)

And the sysfs file could have a "strict" setting which kills any
thread that uses rdtsc, so Thomas can tell future problem
reporters: "Set the rdtsc setting to strict and if you still
have problems, call me back."  (Other half of ;-)
