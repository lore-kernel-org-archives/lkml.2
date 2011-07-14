Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1GNHSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 03:18:36 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:43635 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1GNHSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 03:18:34 -0400
Date: Thu, 14 Jul 2011 09:18:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110714091800.720da848@mschwide>
In-Reply-To: <20110713200004.GG4426@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
	<20110705202615.GJ24348@redhat.com>
	<1309944287.3937.39.camel@br98xy6r>
	<20110707193321.GE28850@redhat.com>
	<20110708110121.5acfc3c9@mschwide>
	<20110711144255.GE30674@redhat.com>
	<20110711175626.121dcc58@mschwide>
	<20110713160239.GE4426@redhat.com>
	<20110713184611.6dcb09b4@mschwide>
	<20110713200004.GG4426@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 16:00:04 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Jul 13, 2011 at 06:46:11PM +0200, Martin Schwidefsky wrote:
> 
> [..]
> > > What I am suggesting is that stand alone dumper gets control only if
> > > kdump kernel is corrupted.
> > > 
> > > So following sequence.
> > > 
> > > Kernel Crash ---> purgatory --> either kdump kenrel/IPL stand alone tools
> > > 
> > > Here only drawback seems to be that we assume that purgatory code and
> > > pre-calculated checksum has not been corrupted. The big advantage is
> > > that s390 kdump support looks very similar to other arches and
> > > understaning and supporting kdump across architectures becomes easy.
> > 
> > My problem with that is the following: how do we get from the "Kernel Crash"
> > step to the purgatory code? It does work for "normal" panics, but it fails
> > miserably for a hard crash that does not even get as far as panic. That is
> > why we insist on a possible second order of things:
> 
> What is hard crash? How does that happen and what does x86 and s390
> do in that case?

E.g. an endless loop with interrupts disabled. To get out of this situation
we will IPL/boot a new system. That is either the production system itself
or the stand-alone dump tool. 
 
> Though I don't have details but your argument seems to be that in s390
> we are always guranteed that we will jump to IPLing the stand alone
> tools code irresepective of the system state hence it is relatively
> safer to do checks in stand alone tools instead of purgatory where
> code is in memory.

Now you got it. That is the crux of the argument.

> If due to hard hang, code can not even make to purgatory, where would
> it go? Can't we do IPLing of stand alone tool then. 

It doesn't go anywhere. Basically the system is manually stopped and
restarted. But on s390 we can still get to all the required information
to generated a dump. That is one of the major differences to x86, if
you have to do a restart the registers on x86 will be gone, no?
 
> So we first try to take purgatory path which does the checksum and is
> consistent with other architectures. If that does not work in case
> of hard hang, you always have the option of IPLing the stand alone tool
> later manually.

How are we suddenly on the purgatory path again? The code that gets
control in case of a hard crash + IPL is the stand-alone dump tool,
not the purgatory code. The first thing we want to do is to check if
the purgatory is still fine, that is do a checksum. If we have the
infrastructure in place to do one checksum then we can easily do the
other checksums as well.
 
> This will also get rid of requirement passing all the segment and cheksum
> info to stand alone tool with the help of meminfo (That's another sore
> point). 

No, it doesn't. We will still need to do the checksum for the purgatory
code and we already have the re-ipl information which won't go away.
 
> Bottom line, even if you can't make to purgatory reliably, you always
> have the option of capturing dump manually using stand alone tools. We
> don't have to mix up kdump and stand alone mechanism. If kdump fails, we
> just need to have capability to still capture the dump using stand alone
> tools manually. I think that will make things simpler even for stand alone
> tools.

If we decide not to mix kdump and stand-alone dump then we loose something.
Consider a hard crash where the kdump segments are still intact. What our
customers do in that case is to start the stand-alone dump utility. Without
a way to find and verify the kdump setup we would have to do a full dump.
Which will take its time if the memory size is big. See?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

