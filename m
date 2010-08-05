Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab0HEMcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:32:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab0HEMcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:32:42 -0400
Date: Thu, 5 Aug 2010 08:36:49 -0400
From: Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Valdis.Kletnieks@vt.edu, josef@redhat.com,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: direct-io regression [Was: How to track down abysmal
	performance ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
References: <20100804073546.GA7494@comet.dominikbrodowski.net> <20100804085039.GA11671@infradead.org> <20100804091317.GA27779@isilmar-3.linta.de> <20100804092122.GA2998@infradead.org> <20100804073546.GA7494@comet.dominikbrodowski.net> <201008041116.09822@zmi.at> <20100804102526.GB13766@isilmar-3.linta.de> <15446.1280953986@localhost> <20100805093100.GA3001@comet.dominikbrodowski.net> <20100805113240.GA29846@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805113240.GA29846@think>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 07:32:40AM -0400, Chris Mason wrote:
> On Thu, Aug 05, 2010 at 11:31:00AM +0200, Dominik Brodowski wrote:
> > Hey,
> > 
> > when attempting to track down insufficient I/O performance, I found the
> > following reression relating to direct-io on my notebook, where an
> > ata device, which consists of several partitions, is combined to a lvm
> > volume, and one logical volume is then encrypted using dm-crypt. Test case
> > was the following command:
> > 
> > $ dd if=/dev/mapper/vg0-root_crypt of=/dev/zero iflag=direct bs=8k count=131072
> > 
> > 2.6.34 results in ~16 MB/s,
> > 2.6.35 results in ~ 3.1 MB/s
> > 
> > The regression was bisected down to the follwoing commit:
> > 
> > commit c2c6ca417e2db7a519e6e92c82f4a933d940d076
> > Author: Josef Bacik <josef@redhat.com>
> > Date:   Sun May 23 11:00:55 2010 -0400
> > 
> >     direct-io: do not merge logically non-contiguous requests
> >     
> > ...
> > 
> > How to fix this? I do not use btrfs, but ext3 (and the access was down on
> > the block level, not on the fs level, so this btrs-related commit should not
> > cause such a regression).
> 
> Well, you've already bisected down to an offending if statement, that's
> a huge help.  I'll try to reproduce this and fix it up today.
> 
> But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> seems a little high.  
>

Hrm, I made sure there were no perf regressions when I wast testing this stuff,
though I think I only tested xfs and ext4.  Originally I had a test where if we
provided our own submit_io, so maybe as a workaround just make

if (dio->final_block_in_bio != dio->cur_page_block ||
                    cur_offset != bio_next_offset) 

look like this

if (dio->final_block_in_bio != dio->cur_page_block ||
    (dio->submit_io && cur_offset != bio_next_offset))

and that should limit my change to only btrfs.  I know why it could cause a
problem, but this change shouldn't be causing a 400% regression.  I suspect
something else is afoot here.  Thanks,

Josef
