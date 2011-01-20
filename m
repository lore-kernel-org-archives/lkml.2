Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1ATPRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:17:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab1ATPRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:17:04 -0500
Date: Thu, 20 Jan 2011 10:16:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "Shi, Alex" <alex.shi@intel.com>, jack@suse.cz, tytso@mit.edu,
        "czoccolo@gmail.com" <czoccolo@gmail.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs machine
Message-ID: <20110120151656.GC18875@redhat.com>
References: <1295402148.4773.143.camel@debian>
 <1295402606.1949.871.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295402606.1949.871.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:03:26AM +0800, Shaohua Li wrote:
> add Jan and Theodore to the loop.
> 
> On Wed, 2011-01-19 at 09:55 +0800, Shi, Alex wrote:
> > Shaohua and I tested kernel building performance on latest kernel. and
> > found it is drop about 15% on our 64 LCPUs NHM-EX machine on ext4 file
> > system. We find this performance dropping is due to commit
> > 749ef9f8423054e326f. If we revert this patch or just change the
> > WRITE_SYNC back to WRITE in jbd2/commit.c file. the performance can be
> > recovered. 
> > 
> > iostat report show with the commit, read request merge number increased
> > and write request merge dropped. The total request size increased and
> > queue length dropped. So we tested another patch: only change WRITE_SYNC
> > to WRITE_SYNC_PLUG in jbd2/commit.c, but nothing effected.
> since WRITE_SYNC_PLUG doesn't work, this isn't a simple no-write-merge issue.
> 

Yep, it does sound like reduce write merging. But moving journal commits
back to WRITE, then fsync performance will drop as there will be idling
introduced between fsync thread and journalling thread. So that does
not sound like a good idea either.

Secondly, in presence of mixed workload (some other sync read happening)
WRITES can get less bandwidth and sync workload much more. So by 
marking journal commits as WRITES you might increase the delay there
in completion in presence of other sync workload.

So Jan Kara's approach makes sense that if somebody is waiting on
commit then make it WRITE_SYNC otherwise make it WRITE. Not sure why
did it not work for you. Is it possible to run some traces and do
more debugging that figure out what's happening.

Thanks
Vivek
