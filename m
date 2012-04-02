Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2DBXvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:51:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44146 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2DBXvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:51:02 -0400
Date: Mon, 2 Apr 2012 19:50:50 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs io errors on 3.4rc1
Message-ID: <20120402235021.GA20070@shiny.msi.event>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
 <20120402211622.GA2487@redhat.com>
 <20120402212608.GA14958@shiny.msi.event>
 <20120402214051.GB2487@redhat.com>
 <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
 <20120402223350.GA16907@redhat.com>
 <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402225131.GB16907@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F7A3B5E.004B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 06:51:31PM -0400, Dave Jones wrote:
> On Mon, Apr 02, 2012 at 06:39:19PM -0400, Chris Mason wrote:
>  > On Mon, Apr 02, 2012 at 06:33:50PM -0400, Dave Jones wrote:
>  > > On Mon, Apr 02, 2012 at 06:28:02PM -0400, Chris Mason wrote:
>  > >  
>  > >  > > x86-64.
>  > >  > > 
>  > >  > > dmesg below.  (ignore the rpc oops, reported elsewhere, it's unrelated)
>  > >  > 
>  > >  > Well, there really are no btrfs messages in there at all.  Do you have
>  > >  > free space for a clean copy of the btrfs partition?  Trying to figure
>  > >  > out if you have a stale corruption (on two boxes seems really unlikely).
>  > >  > I definitely can't reproduce it here.
>  > > 
>  > > Don't really have any free space for it (It's the / partition on both)
>  > > 
>  > > Is there a wip btrfs.fsck yet ? One of the machines is just a scratch testbox,
>  > > so I'm happy to run it even if it'll potentially make things worse.
>  > 
>  > The current btrfsck repair mode will fix problems in the extent
>  > allocation tree, but that probably isn't what you're seeing.  I'd just
>  > run it read only and see if it finds any problems.
>  > 
>  > (You'll need the FS completely unmounted though).
> 
> I'll start a bisect later to see if I can narrow it down at least.

Ok, a directed bisect of the major suspects.  Josef changed the extent
buffer eio code in this commit (jump to the commit before it):

commit ea466794084f55d8fcc100711cf17923bf57e962
Author: Josef Bacik <josef@redhat.com>
Date:   Mon Mar 26 21:57:36 2012 -0400

    Btrfs: deal with read errors on extent buffers differently

You can jump to the commit before my big blocks change:

commit 727011e07cbdf87772fcc1999cccd15cc915eb62
Author: Chris Mason <chris.mason@oracle.com>
Date:   Fri Aug 6 13:21:20 2010 -0400

    Btrfs: allow metadata blocks larger than the page size

The SUSE code would be my other suspect.  It came from this commit:

commit 1d4284bd6e8d7dd1d5521a6747bdb6dc1caf0225
Merge: b5d67f6 65139ed
Author: Chris Mason <chris.mason@oracle.com>
Date:   Wed Mar 28 20:31:37 2012 -0400

    Merge branch 'error-handling' into for-linus

commit 65139ed99234d8505948cdb7a835452eb5c191f9
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Feb 17 12:26:09 2012 +0100

    btrfs: disallow unequal data/metadata blocksize for mixed block
groups

So if you git reset --hard b5d67f6, you'll get rid of the suse code.

Thanks Dave!

-chris
