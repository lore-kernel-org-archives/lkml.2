Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1LAUbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:31:31 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60958 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1LAUb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:31:29 -0500
Date: Thu, 1 Dec 2011 12:31:22 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH v5.2 00/14] crc32c: Add faster algorithm and self-test
	code
Message-ID: <20111201203122.GC23175@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201202053.GG1495@noexit.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201202053.GG1495@noexit.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11120120-3534-0000-0000-0000032DF750
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 12:20:53PM -0800, Joel Becker wrote:
> On Thu, Dec 01, 2011 at 12:13:41PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This patchset (re)uses Bob Pearson's crc32 slice-by-8 code to stamp out a
> > software crc32c implementation.  It removes the crc32c implementation in
> > crypto/ in favor of using the stamped-out one in lib/.  There is also a change
> > to Kconfig so that the kernel builder can pick an implementation best suited
> > for the hardware.
> > 
> > The motivation for this patchset is that I am working on adding full metadata
> > checksumming to ext4.  As far as performance impact of adding checksumming
> > goes, I see nearly no change with a standard mail server ffsb simulation.  On a
> > test that involves only file creation and deletion and extent tree writes, I
> > see a drop of about 50 pcercent with the current kernel crc32c implementation;
> > this improves to a drop of about 20 percent with the enclosed crc32c code.
> > 
> > When metadata is usually a small fraction of total IO, this new implementation
> > doesn't help much because metadata is usually a small fraction of total IO.
> > However, when we are doing IO that is almost all metadata (such as rm -rf'ing a
> > tree), then this patch speeds up the operation substantially.
> > 
> > Incidentally, given that iscsi, sctp, and btrfs also use crc32c, this patchset
> > should improve their speed as well.  I have not yet quantified that, however.
> 
> 	I thought they usually used the SSE instruction for crc32 or
> equivalent.

They seem to call crc32c(), which is in crypto/crc32c.  If you're interested in
hardware accelerated crc32c on Intel, it is still the case that the wrapper for
that can be loaded via crc32c-intel.

--D
> 
> Joel
> 
> -- 
> 
> "I almost ran over an angel
>  He had a nice big fat cigar.
>  'In a sense,' he said, 'You're alone here
>  So if you jump, you'd best jump far.'"
> 
> 			http://www.jlbec.org/
> 			jlbec@evilplan.org
> 

