Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab0FOOrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:47:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38139 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab0FOOrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:47:36 -0400
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page
 cache control
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: balbir@linux.vnet.ibm.com, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C1726C4.8050300@redhat.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
	 <4C10B3AF.7020908@redhat.com> <20100610142512.GB5191@balbir.in.ibm.com>
	 <1276214852.6437.1427.camel@nimitz>
	 <20100611045600.GE5191@balbir.in.ibm.com> <4C15E3C8.20407@redhat.com>
	 <20100614084810.GT5191@balbir.in.ibm.com> <4C16233C.1040108@redhat.com>
	 <20100614125010.GU5191@balbir.in.ibm.com> <4C162846.7030303@redhat.com>
	 <1276529596.6437.7216.camel@nimitz> <4C164E63.2020204@redhat.com>
	 <1276530932.6437.7259.camel@nimitz> <4C1659F8.3090300@redhat.com>
	 <1276538293.6437.7528.camel@nimitz>  <4C1726C4.8050300@redhat.com>
Content-Type: text/plain
Date: Tue, 15 Jun 2010 07:47:29 -0700
Message-Id: <1276613249.6437.11516.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 10:07 +0300, Avi Kivity wrote:
> On 06/14/2010 08:58 PM, Dave Hansen wrote:
> > On Mon, 2010-06-14 at 19:34 +0300, Avi Kivity wrote:
> >    
> >>> Again, this is useless when ballooning is being used.  But, I'm thinking
> >>> of a more general mechanism to force the system to both have MemFree
> >>> _and_ be acting as if it is under memory pressure.
> >>>
> >>>        
> >> If there is no memory pressure on the host, there is no reason for the
> >> guest to pretend it is under pressure.
> >>      
> > I can think of quite a few places where this would be beneficial.
> >
> > Ballooning is dangerous.  I've OOMed quite a few guests by
> > over-ballooning them.  Anything that's voluntary like this is safer than
> > things imposed by the host, although you do trade of effectiveness.
> 
> That's a bug that needs to be fixed.  Eventually the host will come 
> under pressure and will balloon the guest.  If that kills the guest, the 
> ballooning is not effective as a host memory management technique.

I'm not convinced that it's just a bug that can be fixed.  Consider a
case where a host sees a guest with 100MB of free memory at the exact
moment that a database app sees that memory.  The host tries to balloon
that memory away at the same time that the app goes and allocates it.
That can certainly lead to an OOM very quickly, even for very small
amounts of memory (much less than 100MB).  Where's the bug?

I think the issues are really fundamental to ballooning.

> > If all the guests do this, then it leaves that much more free memory on
> > the host, which can be used flexibly for extra host page cache, new
> > guests, etc...
> 
> If the host detects lots of pagecache misses it can balloon guests 
> down.  If pagecache is quiet, why change anything?

Page cache misses alone are not really sufficient.  This is the classic
problem where we try to differentiate streaming I/O (which we can't
effectively cache) from I/O which can be effectively cached.

> If the host wants to start new guests, it can balloon guests down.  If 
> no new guests are wanted, why change anything?

We're talking about an environment which we're always trying to
optimize.  Imagine that we're always trying to consolidate guests on to
smaller numbers of hosts.  We're effectively in a state where we
_always_ want new guests.

-- Dave

