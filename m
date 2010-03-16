Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937420Ab0CPDRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 23:17:06 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48561 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab0CPDRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 23:17:02 -0400
Date: Tue, 16 Mar 2010 08:46:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Chris Webb <chris@arachsys.com>
Cc: Avi Kivity <avi@redhat.com>, KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot
 parameter
Message-ID: <20100316031649.GG18054@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100315072214.GA18054@balbir.in.ibm.com>
 <4B9DE635.8030208@redhat.com>
 <20100315080726.GB18054@balbir.in.ibm.com>
 <4B9DEF81.6020802@redhat.com>
 <20100315202353.GJ3840@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100315202353.GJ3840@arachsys.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Webb <chris@arachsys.com> [2010-03-15 20:23:54]:

> Avi Kivity <avi@redhat.com> writes:
> 
> > On 03/15/2010 10:07 AM, Balbir Singh wrote:
> >
> > >Yes, it is a virtio call away, but is the cost of paying twice in
> > >terms of memory acceptable?
> > 
> > Usually, it isn't, which is why I recommend cache=off.
> 
> Hi Avi. One observation about your recommendation for cache=none:
> 
> We run hosts of VMs accessing drives backed by logical volumes carved out
> from md RAID1. Each host has 32GB RAM and eight cores, divided between (say)
> twenty virtual machines, which pretty much fill the available memory on the
> host. Our qemu-kvm is new enough that IDE and SCSI drives with writeback
> caching turned on get advertised to the guest as having a write-cache, and
> FLUSH gets translated to fsync() by qemu. (Consequently cache=writeback
> isn't acting as cache=neverflush like it would have done a year ago. I know
> that comparing performance for cache=none against that unsafe behaviour
> would be somewhat unfair!)
> 
> Wasteful duplication of page cache between guest and host notwithstanding,
> turning on cache=writeback is a spectacular performance win for our guests.
> For example, even IDE with cache=writeback easily beats virtio with
> cache=none in most of the guest filesystem performance tests I've tried. The
> anecdotal feedback from clients is also very strongly in favour of
> cache=writeback.
> 
> With a host full of cache=none guests, IO contention between guests is
> hugely problematic with non-stop seek from the disks to service tiny
> O_DIRECT writes (especially without virtio), many of which needn't have been
> synchronous if only there had been some way for the guest OS to tell qemu
> that. Running with cache=writeback seems to reduce the frequency of disk
> flush per guest to a much more manageable level, and to allow the host's
> elevator to optimise writing out across the guests in between these flushes.

Thanks for the inputs above, they are extremely useful. The goal of
these patches is that with cache != none, we allow double caching when
needed and then slowly take away unmapped pages, pushing the caching
to the host. There are knobs to control how much, etc and the whole
feature is enabled via a boot parameter.

-- 
	Three Cheers,
	Balbir
