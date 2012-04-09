Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2DIVyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:54:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17291 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2DIVye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:54:34 -0400
Date: Mon, 9 Apr 2012 17:49:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: david.vrabel@citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 6/7] xen/setup: Make dom0_mem=XGB behavior be
 similar to classic Xen kernels.
Message-ID: <20120409214940.GD12783@phenom.dumpdata.com>
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
 <1333139850-28456-7-git-send-email-konrad.wilk@oracle.com>
 <4F7ABBC4.4050106@citrix.com>
 <20120406205909.GA26309@phenom.dumpdata.com>
 <4F8322BB020000780008229D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8322BB020000780008229D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F835A94.0035,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 05:56:11PM +0100, Jan Beulich wrote:
> >>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> 04/06/12 11:04 PM >>>
> >> With your new behaviour it will no longer possible to specify an
> >> unlimited balloon but a limited number of initial pages.  This is
> >> behaviour that Jan said he used.
> >
> >I am not sure I see the problem - I mean if one uses:
> >
> >dom0_mem=min:8G,max:16G
> >
> >I understand that we want to start at 8GB and if the user
> >choose to - balloon up to 16GB.
> >
> >But doing this:
> >
> >dom0_mem=8G
> >
> >and allocating pagetables up to .. say 32GB, seems counter-intuive
> >as the effect is similar to having no 'dom0_mem' except that the initial
> >size is smaller.
> 
> What's counter intuitive here? There may not be a need - from the perspective
> of the kernel - for a hard upper limit enforced by Xen (i.e. the pseudo infinity
> we have right now may be quite fine).

Counter intuitive in that when one uses 'dom0_mem=8G' it implies some clipping.
And with the pvops kernel we don't do any clipping - we allocate pagetables
up to the the limit of the E820 space. So on a 32GB box, we end up with pagetables
addressing 32GB, of which 24GB are balloon space.

> 
> Anyway, as said in the other reply already - unless this is to address a bug, I
> don't see the point in changing behavior that has been that way for a pretty
> long time.

The bug here is that if you say 'dom0_mem=max:4G' the amount of memory
that dom0 boots is not the same. It actually is smaller (by about one 1GB since
that is the amount of memort that gets ballooned out from the E820 gaps and E820
RESERVED/ACPI PFN spots). The first set of patches did this a bit ineptly, but the
next version populate's the P2M and M2P so you actually end up with 4GB of memory
in dom0 instead of the 3GB.

This is what we end up with without any dom0_mem argument:

2.6.32 SLES:
Memory: 7538688k/8079432k available (3971k kernel code, 8192k absent, 532300k reserved, 2491k data, 348k init)
MemTotal:        8063140 kB
MemFree:         7421504 kB
DirectMap4k:     8071240 kB
Domain-0                                     0  7873     4     r-----     20.3

3.3:
Memory: 6486452k/9208688k available (5825k kernel code, 1136060k absent, 1586176k reserved, 2890k data, 692k init)
MemTotal:        6716156 kB
MemFree:         6365696 kB
DirectMap4k:     8078192 kB
Domain-0                                     0  6774     4     r-----     26.0

3.3+patches:
Memory: 7621460k/9208688k available (5817k kernel code, 1136060k absent, 451168k reserved, 2899k data, 692k init)
MemTotal:        7849924 kB
MemFree:         7500748 kB
DirectMap4k:     8078192 kB
Domain-0                                     0  7883     4     r-----     11.9


and .. hm, I lost the outputs I had with dom0_mem=X, but this is what I get
with 3.3 and 3.3+this patch:

dom0_mem=1G
-Memory: 610884k/9435136k available (5817k kernel code, 1136060k absent, 7688192k reserved, 2899k data, 696k init)
+Memory: 724184k/1053064k available (5817k kernel code, 4552k absent, 324328k reserved, 2899k data, 696k init)
   
I think the SLES kernel has the same behavior, but will have to wait
until next week when I am back to be double sure.


 
When it comes to "infinite" balloon - I think the work that Daniel did
on using the memory hotplug mechanism to add memory is preferable. That
way pagetables are put in the newly added memory space.


> 
> Jan
