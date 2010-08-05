Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab0HEJbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:31:15 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:38797 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759050Ab0HEJbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:31:11 -0400
Date: Thu, 5 Aug 2010 11:31:00 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Valdis.Kletnieks@vt.edu, josef@redhat.com, chris.mason@oracle.com
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: direct-io regression [Was: How to track down abysmal performance
 ata - raid1 - crypto - vg/lv - xfs]
Message-ID: <20100805093100.GA3001@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Valdis.Kletnieks@vt.edu, josef@redhat.com, chris.mason@oracle.com,
	Michael Monnerie <michael.monnerie@is.it-management.at>,
	Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
 <20100804085039.GA11671@infradead.org>
 <20100804091317.GA27779@isilmar-3.linta.de>
 <20100804092122.GA2998@infradead.org>
 <20100804073546.GA7494@comet.dominikbrodowski.net>
 <201008041116.09822@zmi.at>
 <20100804102526.GB13766@isilmar-3.linta.de>
 <15446.1280953986@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15446.1280953986@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

when attempting to track down insufficient I/O performance, I found the
following reression relating to direct-io on my notebook, where an
ata device, which consists of several partitions, is combined to a lvm
volume, and one logical volume is then encrypted using dm-crypt. Test case
was the following command:

$ dd if=/dev/mapper/vg0-root_crypt of=/dev/zero iflag=direct bs=8k count=131072

2.6.34 results in ~16 MB/s,
2.6.35 results in ~ 3.1 MB/s

The regression was bisected down to the follwoing commit:

commit c2c6ca417e2db7a519e6e92c82f4a933d940d076
Author: Josef Bacik <josef@redhat.com>
Date:   Sun May 23 11:00:55 2010 -0400

    direct-io: do not merge logically non-contiguous requests
    
...

How to fix this? I do not use btrfs, but ext3 (and the access was down on
the block level, not on the fs level, so this btrs-related commit should not
cause such a regression).

Best,

	Dominik
