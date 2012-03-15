Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031354Ab2COAnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:43:51 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:37720 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760625Ab2COAns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:43:48 -0400
Date: Thu, 15 Mar 2012 09:43:45 +0900
From: Simon Horman <horms@verge.net.au>
To: Don Zickus <dzickus@redhat.com>
Cc: Fernando Luis =?utf-8?Q?V=C3=A1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
        akpm@linux-foundation.org, linux-tip-commits@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        torvalds@linux-foundation.org, mingo@elte.hu, vgoyal@redhat.com
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
Message-ID: <20120315004344.GA16806@verge.net.au>
References: <4F5A6D87.4050809@zytor.com>
 <4F5D8D0E.8060702@oss.ntt.co.jp>
 <4F5D8E63.60606@zytor.com>
 <4F5D943C.5020403@oss.ntt.co.jp>
 <4F5E431D.8010305@zytor.com>
 <m1zkblmvw7.fsf@fess.ebiederm.org>
 <4F5E56EB.1090807@zytor.com>
 <4F5E59AC.7090708@zytor.com>
 <4F5EACE5.8080202@oss.ntt.co.jp>
 <20120313133350.GS24378@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120313133350.GS24378@redhat.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 09:33:50AM -0400, Don Zickus wrote:
> On Tue, Mar 13, 2012 at 11:11:49AM +0900, Fernando Luis Vázquez Cao wrote:
> > On 03/13/2012 05:16 AM, H. Peter Anvin wrote:
> > >On 03/12/2012 01:04 PM, H. Peter Anvin wrote:
> > >>On 03/12/2012 01:01 PM, Eric W. Biederman wrote:
> > >>>The basic problem is which source do we block this at?  How many
> > >>>sources are their?  And architecturally last I looked x86 no longer
> > >>>has a NMI disable EFI and similar systems want to get away without
> > >>>a CMOS legacy clock because designers so often get them wrong.
> > >>>
> > >>On all processors which have an LAPIC you can block all NMI sources at
> > >>the LAPIC.  I think it's safe to assume that if you don't have an LAPIC
> > >>-- an ancient system by now -- you have port 70h.
> > >>
> > >One thing: *disabling* the LAPIC will allow external NMIs coming in on
> > >LINT1 through, since the LAPIC in the disabled state tries to mimic the
> > >no-LAPIC configuration.  So I don't think you want to disable LAPIC as
> > >much as disable the interrupt vectors within.
> > 
> > Does this sound like a plan to get the ball rolling?:
> > 
> > 1.- Merge Don's patch to disable the LAPIC in kdump reboot path (this
> >   fixes a real issue seen in the field, is a net win and certainly not a
> >   regression - indeed it makes the code simpler because the I/O
> >   APICs are left untouched).
> 
> I think you mean my patch to stop disabling the I/O APIC.  That patch
> hasn't seen any new issues.  It was the piece that stopped disabling the
> LAPIC that opened the doors for NMIs to fault the system.
> 
> > 
> > 2.- Merge my patch set to ignore early NMIs (this brings the behavior
> >   of the boot code in line with what we do in the rest of the kernel
> >   a we can avoid situations were a spurious NMI causes the kernel
> >   to halt). The early NMI handler is temporary and the final NMI
> >   handler installed shortly afterwards will take care of subsequent
> >   NMIs.
> > 
> > 3.- Make sure that spurious NMIs (i.e. NMIs that for whatever reason
> >   could not be stopped at the source) received during the reboot
> >   path to the kdump kernel do not cause a triple fault or a system
> >   lockup. This is under testing.
> 
> This will require changes in kexec-tools as the purgatory code zaps the
> GDT I believe.  This is going to make a 'complete solution' dependent on
> a version of kexec-tools.  Not sure what we want to do there.

Ouch. I guess that in the event that purgatory needs to be modified
some backwards-compatibility will need to be provided, possibly
by allowing purgatory to switch between two behaviours based on
e.g. a command line parameter.

> > 4.- Identify all the NMI sources and keep them from reaching the CPU
> >   when it can be done in a race-free way.
