Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2GLTzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:55:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47283 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2GLTzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:55:12 -0400
MIME-Version: 1.0
Message-ID: <367d9a88-7819-401a-8210-c32503cdd458@default>
Date: Thu, 12 Jul 2012 12:54:54 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>, Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH 3/4] zsmalloc: add details to zs_map_object boiler plate
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1341263752-10210-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <4FFB94FF.8030401@kernel.org> <4FFC478C.4050505@linux.vnet.ibm.com>
 <4FFD2E65.5080307@kernel.org> <4FFD8A8F.6030603@linux.vnet.ibm.com>
 <20120712011555.GB5503@bbox>
In-Reply-To: <20120712011555.GB5503@bbox>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> Subject: Re: [PATCH 3/4] zsmalloc: add details to zs_map_object boiler plate
> 
> On Wed, Jul 11, 2012 at 09:15:43AM -0500, Seth Jennings wrote:
> > On 07/11/2012 02:42 AM, Minchan Kim wrote:
> > > On 07/11/2012 12:17 AM, Seth Jennings wrote:
> > >> On 07/09/2012 09:35 PM, Minchan Kim wrote:
> > >>> Maybe we need local_irq_save/restore in zs_[un]map_object path.
> > >>
> > >> I'd rather not disable interrupts since that will create
> > >> unnecessary interrupt latency for all users, even if they
> > >
> > > Agreed.
> > > Although we guide k[un]map atomic is so fast, it isn't necessary
> > > to force irq_[enable|disable]. Okay.
> > >
> > >> don't need interrupt protection.  If a particular user uses
> > >> zs_map_object() in an interrupt path, it will be up to that
> > >> user to disable interrupts to ensure safety.
> > >
> > > Nope. It shouldn't do that.
> > > Any user in interrupt context can't assume that there isn't any other user using per-cpu buffer
> > > right before interrupt happens.
> > >
> > > The concern is that if such bug happens, it's very hard to find a bug.
> > > So, how about adding this?
> > >
> > > void zs_map_object(...)
> > > {
> > > 	BUG_ON(in_interrupt());
> > > }
> >
> > I not completely following you, but I think I'm following
> > enough.  Your point is that the per-cpu buffers are shared
> > by all zsmalloc users and one user doesn't know if another
> > user is doing a zs_map_object() in an interrupt path.
> 
> And vise versa is yes.
> 
> > However, I think what you are suggesting is to disallow
> > mapping in interrupt context.  This is a problem for zcache
> > as it already does mapping in interrupt context, namely for
> > page decompression in the page fault handler.
> 
> I don't get it.
> Page fault handler isn't interrupt context.
> 
> > What do you think about making the per-cpu buffers local to
> > each zsmalloc pool? That way each user has their own per-cpu
> > buffers and don't step on each other's toes.
> 
> Maybe, It could be a solution if you really need it in interrupt context.
> But the concern is it could hurt zsmalloc's goal which is memory
> space efficiency if your system has lots of CPUs.

Sorry to be so far behind on this thread.

For frontswap and zram, the "put" calls are not in interrupt
context.  For cleancache, the put call IS in interrupt context.
So if you want to use zsmalloc for zcache+cleancache, interrupt
context is a concern.  As discussed previously in a separate
thread though, zsmalloc will take a lot of work to support the full
needs of zcache.  So, pick your poison.

The x86 architecture is far ahead of ARM on many CPU optimizations
including fast copying.  Most x86 systems are also now 64-bit,
which means 64-bit+ data buses.  These differences probably account
for the difference in copy-vs-TLBmapping performance between (64-bit)
x86 and (32-bit ARM).  However, ARM may eventually catch up, especially
when 64-bit ARM chips are more common, so
it would be nice if zsmalloc could determine at runtime which
is faster and use it.

Dan
