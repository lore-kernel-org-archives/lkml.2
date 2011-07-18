Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1GRN5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:57:43 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:55572 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1GRN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:57:41 -0400
Date: Mon, 18 Jul 2011 15:57:16 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110718155716.1b355f64@mschwide>
In-Reply-To: <20110714175532.GE6672@redhat.com>
References: <20110705202615.GJ24348@redhat.com>
	<1309944287.3937.39.camel@br98xy6r>
	<20110707193321.GE28850@redhat.com>
	<20110708110121.5acfc3c9@mschwide>
	<20110711144255.GE30674@redhat.com>
	<20110711175626.121dcc58@mschwide>
	<20110713160239.GE4426@redhat.com>
	<20110713184611.6dcb09b4@mschwide>
	<20110713200004.GG4426@redhat.com>
	<20110714091800.720da848@mschwide>
	<20110714175532.GE6672@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011 13:55:32 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Jul 14, 2011 at 09:18:00AM +0200, Martin Schwidefsky wrote:
> > On Wed, 13 Jul 2011 16:00:04 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Wed, Jul 13, 2011 at 06:46:11PM +0200, Martin Schwidefsky wrote:
> > > 
> > > [..]
> > > > > What I am suggesting is that stand alone dumper gets control only if
> > > > > kdump kernel is corrupted.
> > > > > 
> > > > > So following sequence.
> > > > > 
> > > > > Kernel Crash ---> purgatory --> either kdump kenrel/IPL stand alone tools
> > > > > 
> > > > > Here only drawback seems to be that we assume that purgatory code and
> > > > > pre-calculated checksum has not been corrupted. The big advantage is
> > > > > that s390 kdump support looks very similar to other arches and
> > > > > understaning and supporting kdump across architectures becomes easy.
> > > > 
> > > > My problem with that is the following: how do we get from the "Kernel Crash"
> > > > step to the purgatory code? It does work for "normal" panics, but it fails
> > > > miserably for a hard crash that does not even get as far as panic. That is
> > > > why we insist on a possible second order of things:
> > > 
> > > What is hard crash? How does that happen and what does x86 and s390
> > > do in that case?
> > 
> > E.g. an endless loop with interrupts disabled. To get out of this situation
> > we will IPL/boot a new system. That is either the production system itself
> > or the stand-alone dump tool. 
> 
> NMI hardware lockup detection will work in this situation and will lead
> to kdump trigger.

Ok, that reduces the problem to the code that is execution as a result of the
nmi interrupt. Only if that code got corrupted it will fail. Should be pretty
save.
 
> >  
> > > Though I don't have details but your argument seems to be that in s390
> > > we are always guranteed that we will jump to IPLing the stand alone
> > > tools code irresepective of the system state hence it is relatively
> > > safer to do checks in stand alone tools instead of purgatory where
> > > code is in memory.
> > 
> > Now you got it. That is the crux of the argument.
> > 
> > > If due to hard hang, code can not even make to purgatory, where would
> > > it go? Can't we do IPLing of stand alone tool then. 
> > 
> > It doesn't go anywhere. Basically the system is manually stopped and
> > restarted. But on s390 we can still get to all the required information
> > to generated a dump. That is one of the major differences to x86, if
> > you have to do a restart the registers on x86 will be gone, no?
> >  
> > > So we first try to take purgatory path which does the checksum and is
> > > consistent with other architectures. If that does not work in case
> > > of hard hang, you always have the option of IPLing the stand alone tool
> > > later manually.
> > 
> > How are we suddenly on the purgatory path again? The code that gets
> > control in case of a hard crash + IPL is the stand-alone dump tool,
> > not the purgatory code.
> 
> I think that's the biggest contetion point. From the start of discussion
> you have this hardcoded requirement that the moment panic() happens
> you are jumping to some IPL code and that's what I am questioning. Why
> can't you execute some more code after panic() (purgatory), before
> you jump to IPL code (only if you have to). 

No, if panic() happens and the code on the panic path is fine we do whatever
is configured as a panic action. For the kdump panic action this can be a
branch to the purgatory code.
The hardcoded requirement we have is a different one: if the automatic panic
action fails for some reason, then we still want to be able to get a dump,
preferably a kdump if the kdump kernel is still fine.

> > The first thing we want to do is to check if
> > the purgatory is still fine, that is do a checksum. If we have the
> > infrastructure in place to do one checksum then we can easily do the
> > other checksums as well.
> 
> Some piece of code you have to assume is fine. Are you not already
> assuming that IPL code you have in first 64K bytes is fine and no
> body has overwritten it. Are you not assuming that hook in panic()
> (I think you are calling it shutdown trigger) is fine so that it
> can help you jump to right place.

There is no IPL code in the first 64K byte at the time the production system
went bad. It is loaded by the IPL of the stand-alone dump tool. An IPL
always loads the code from a "safe" place before it gets executed.

> >  
> > > This will also get rid of requirement passing all the segment and cheksum
> > > info to stand alone tool with the help of meminfo (That's another sore
> > > point). 
> > 
> > No, it doesn't. We will still need to do the checksum for the purgatory
> > code and we already have the re-ipl information which won't go away.
> 
> It is a very small piece of code. The way you assume that your 8KB of
> IPL code is fine, I think we shall have to have this assumption here
> also.

That 8KB of IPL code has been freshly loaded from disk, you can not really
compare that to a setup where the purgatory code has been lying in memory
for almost the complete lifetime of the production system.

> >  
> > > Bottom line, even if you can't make to purgatory reliably, you always
> > > have the option of capturing dump manually using stand alone tools. We
> > > don't have to mix up kdump and stand alone mechanism. If kdump fails, we
> > > just need to have capability to still capture the dump using stand alone
> > > tools manually. I think that will make things simpler even for stand alone
> > > tools.
> > 
> > If we decide not to mix kdump and stand-alone dump then we loose something.
> > Consider a hard crash where the kdump segments are still intact. What our
> > customers do in that case is to start the stand-alone dump utility. Without
> > a way to find and verify the kdump setup we would have to do a full dump.
> > Which will take its time if the memory size is big. See?
> 
> This is a really-2 corner case where purgatory went bad. And even in
> corner case you capture the dump just that it is not filtered.

I beg to differ here. It is not only a problem if the purgatory code went
bad. It is a simple rule we follow on s390: if the system is unresponsive
IPL the stand-alone dumper. The new thing we are discussing here is that
we really want to have the benefits of the kdump mechanism in this case
as well, no only in the case of an automatic dump via panic().
 
> I really don't understand that to address the corner case why would
> you complicate the general kexec infrastructure and introduce new
> interfaces like meminfo.

Is it really such a complication to the general kexec infrastructure?
All we want is to know where the segments for the kdump kernel are to
be able to verify them and the entry point for the kdump kernel.
It is not like we are proposing the meminfo interface for all kdump
users. That is just for s390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

