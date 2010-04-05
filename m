Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0DEXFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:05:05 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:56973 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab0DEXE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:04:57 -0400
MIME-Version: 1.0
Message-ID: <9df0ea91-9bff-4038-99f1-fdb80aad7147@default>
Date: Mon, 5 Apr 2010 16:03:48 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Dmitry Torokhov <dtor@vmware.com>,
       linux-kernel@vger.kernel.org, pv-drivers@vmware.com
Subject: RE: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
 <20100405142419.2c9bea3d.akpm@linux-foundation.org> <4BBA5E1C.10706@goop.org>
 <20100405151720.8a6ac5e3.akpm@linux-foundation.org>
 <4BBA6383.7070601@redhat.com
 20100405154023.c7e4f877.akpm@linux-foundation.org>
In-Reply-To: <20100405154023.c7e4f877.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBA6C73.0105:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On 04/06/2010 01:17 AM, Andrew Morton wrote:
> > >> The basic idea of the driver is to allow a guest system to give up
> > >> memory it isn't using so it can be reused by other virtual
> machines (or
> > >> the host itself).
> > >>
> > > So...  does this differ in any fundamental way from what
> hibernation
> > > does, via shrink_all_memory()?
> > >
> >
> > Just the _all_ bit, and the fact that we need to report the freed
> page
> > numbers to the hypervisor.
> >
> 
> So...  why not tweak that, rather than implementing some parallel
> thing?

I think Avi was being facetious ("_all_").  Hibernation assumes
everything in the machine is going to stop for awhile.  Ballooning
assumes that the machine has lower memory need for awhile, but
is otherwise fully operational.  Think of it as hot-plug memory
at a page granularity.

Historically, all OS's had a (relatively) fixed amount of memory
and, since it was fixed in size, there was no sense wasting any of it.
In a virtualized world, OS's should be trained to be much more
flexible as one virtual machine's "waste" could/should be another
virtual machine's "want".  Ballooning is currently the mechanism
for this; it places memory pressure on the OS to encourage it
to get by with less memory.  Unfortunately, it is difficult even
within an OS to determine what memory is wasted and what memory
might be used imminently... because LRU is only an approximation of
the future.  Hypervisors have an even more difficult problem not
only because they must infer this information from external events,
but they can double the problem if they infer the opposite of what
the OS actually does.

As Jeremy mentioned, Transcendent Memory (and its Linux implementations
"cleancache" and "frontswap") allows a guest kernel to give up memory
for the broader good while still retaining a probability that it
can get the same data back quickly.  This results in more memory
fluidity. Transcendent Memory ("tmem") still uses ballooning as
the mechanism to create memory pressure... it just provides an
insurance policy for that memory pressure.

Avi will point out that it is not clear that tmem can make use of
or benefit from tmem, but we need not repeat that discussion here.

Dan
