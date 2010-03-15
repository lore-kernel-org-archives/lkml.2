Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936684Ab0COUpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:45:35 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:55120 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab0COUpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:45:34 -0400
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 16:45:33 EDT
Date: Mon, 15 Mar 2010 20:23:54 +0000
From: Chris Webb <chris@arachsys.com>
To: Avi Kivity <avi@redhat.com>
Cc: balbir@linux.vnet.ibm.com, KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot
 parameter
Message-ID: <20100315202353.GJ3840@arachsys.com>
References: <20100315072214.GA18054@balbir.in.ibm.com>
 <4B9DE635.8030208@redhat.com>
 <20100315080726.GB18054@balbir.in.ibm.com>
 <4B9DEF81.6020802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9DEF81.6020802@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> On 03/15/2010 10:07 AM, Balbir Singh wrote:
>
> >Yes, it is a virtio call away, but is the cost of paying twice in
> >terms of memory acceptable?
> 
> Usually, it isn't, which is why I recommend cache=off.

Hi Avi. One observation about your recommendation for cache=none:

We run hosts of VMs accessing drives backed by logical volumes carved out
from md RAID1. Each host has 32GB RAM and eight cores, divided between (say)
twenty virtual machines, which pretty much fill the available memory on the
host. Our qemu-kvm is new enough that IDE and SCSI drives with writeback
caching turned on get advertised to the guest as having a write-cache, and
FLUSH gets translated to fsync() by qemu. (Consequently cache=writeback
isn't acting as cache=neverflush like it would have done a year ago. I know
that comparing performance for cache=none against that unsafe behaviour
would be somewhat unfair!)

Wasteful duplication of page cache between guest and host notwithstanding,
turning on cache=writeback is a spectacular performance win for our guests.
For example, even IDE with cache=writeback easily beats virtio with
cache=none in most of the guest filesystem performance tests I've tried. The
anecdotal feedback from clients is also very strongly in favour of
cache=writeback.

With a host full of cache=none guests, IO contention between guests is
hugely problematic with non-stop seek from the disks to service tiny
O_DIRECT writes (especially without virtio), many of which needn't have been
synchronous if only there had been some way for the guest OS to tell qemu
that. Running with cache=writeback seems to reduce the frequency of disk
flush per guest to a much more manageable level, and to allow the host's
elevator to optimise writing out across the guests in between these flushes.

Cheers,

Chris.
