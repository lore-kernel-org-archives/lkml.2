Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1FNNdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:33:46 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56518 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1FNNdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:33:44 -0400
Date: Tue, 14 Jun 2011 15:33:24 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
Message-ID: <20110614133323.GB2830@aftab>
References: <BANLkTi=-A5PYj8zpjGB4Xb-_VNq0qr+CGQ@mail.gmail.com>
 <4DF5C36A.1040707@redhat.com>
 <20110613095521.GA26316@aftab>
 <4DF5F729.4060609@redhat.com>
 <20110613124003.GA27918@aftab>
 <4DF606C9.90308@redhat.com>
 <20110613151208.GA29045@aftab>
 <4DF63B7A.1030805@redhat.com>
 <BANLkTinUEqRni2u0DaMfSc45b3DmMMyYvA@mail.gmail.com>
 <4DF748C2.10009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF748C2.10009@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 07:40:50AM -0400, Avi Kivity wrote:
> > >  So I think the best choice here is MCE ->  irq_work ->  realtime kernel thread
> > >  (or work queue)
> >
> > In the AO (action optional case (e.g. patrol scrubber) - there isn't much rush.
> > We'd like to process things "soon" (before someone hits the corrupt location)
> > but we don't need to take extraordinary efforts to make "soon" happen.
> >
> > In the AR (action required - instruction or data fetch from a corrupted
> > memory location) our main priority is making sure that we don't continue
> > the task that hit the error - because we don't want to hit it again (as Boris
> > said, on Intel cpus this is very disruptive to the system as every cpu is
> > sent the machine check signal - and the code has to read a large number
> > of slow "msr" registers to figure out what happened. If we can guarantee
> > that we won't run this task - then the time pressure is greatly reduced.
> 
> Aren't these events extraordinarily rare?  I think we can afford a 
> little inefficiency there.
>
> Even with mce -> irq_work -> rt thread, we're unlikely to return to
> the task as the rt thread will displace the task. It may be migrated
> to an idle cpu, but even then we may be able to drop the page before
> it gets back to userspace.

This doesn't give you the guarantee that the realtime task manages to
unmap the page from all pagetables before another process running on
another core accesses it.

I think your previous suggestion of making the memory failure handling
code reentrant would cover all holes.

Even marking all processes mapping a faulty page STOPPED or
UNINTERRUPTIBLE won't work in all cases since you have to go out and
find which those processes are. And this is what the rt thread will do.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
