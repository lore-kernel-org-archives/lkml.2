Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0HTPRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:17:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33180 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0HTPRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:17:39 -0400
MIME-Version: 1.0
Message-ID: <66336896-4396-458f-b8a5-51282a925816@default>
Date: Fri, 20 Aug 2010 08:14:59 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, ngupta@vflare.org,
        akpm@linux-foundation.org, Chris Mason <chris.mason@oracle.com>,
        viro@zeniv.linux.org.uk, Andreas Dilger <andreas.dilger@oracle.com>,
        tytso@mit.edu, mfasheh@suse.com, Joel Becker <joel.becker@oracle.com>,
        matthew@wil.cx, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mm@kvack.org, jeremy@goop.org, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@suse.de,
        Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com,
        Konrad Wilk <konrad.wilk@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        Ying Han <yinghan@google.com>, Greg Thelen <gthelen@google.com>
Subject: cleancache followup from LSF10/MM summit
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christophe (and others interested in cleancache progress) --

Thanks for taking some time to talk with me about cleancache
at LSF summit!  You had some interesting thoughts and suggestions
that I said I would investigate.  They are:

1) use inode kva as key instead of i_ino
2) eliminate cleancache shim and call zcache directly
3) fs's requiring key > inode_t (e.g. 64-bit-fs on 32-bit-kernel)
4) eliminate fs-specific code entirely (e.g. "opt-in")
5) eliminate global variable

Here's my conclusions:

1) You suggested using the inode kva as a "key" for cleancache.
   I think your goal was to make it more fs-independent and also
   to eliminate the need for using a per-fs enabler and "pool id".
   I looked at this but it will not work because cleancache
   retains page cache data pages persistently even when the
   inode has been pruned from the inode_unused_list and only
   flushes the data pages if the file gets removed/truncated.  If
   cleancache used the inode kva, there would be coherency issues
   when the inode kva is reused.  Alternately, if cleancache
   flushed the pages when the inode kva was freed, much of
   the value of cleancache would be lost because the cache
   of pages in cleancache is potentially much larger than
   the page cache and is most useful if the pages survive
   inode cache removal.

   If I misunderstood your proposal or if you disagree, please
   let me know.

2) You suggested eliminating the cleancache shim layer and just
   directly calling zcache, effectively eliminating Xen as
   a user.  During and after LSF summit, I talked to developers
   from Google who are interested in investigating the cleancache
   interface for use with cgroups, an IBM developer who was
   interested in cleancache for optimizing NUMA, and soon I
   will be talking to HP Labs about using it as an interface
   for "memory blades".  I also think Rik van Riel and Mel Gorman
   were intrigued about its use for collecting better memory
   utilization statistics to drive guest/host memory "rightsizing".
   While it is true that none of these are current users yet, even
   if you prefer to ignore Xen tmem as a user, it seems silly to
   throw away the cleanly-layered generic cleancache interface now,
   only to add it back later when more users are added.

3) You re-emphasized the problem where cleancache's use of
   the inode number as a key will cause problems on many 64-bit
   filesystems especially running on a 32-bit kernel.  With
   help from Andreas Dilger, I'm trying to work out a generic
   solution for this using s_export_op->encode_fh which would
   be used for any fs that provides it to guarantee a unique
   multi-word key for a file, while preserving the
   shorter i_ino as a key for fs's for which i_ino is unique.

4) Though you were out of the room during the cleancache
   lightning talk, other filesystem developers seemed OK
   with the "opt-in" approach (as documented in lwn.net)...
   one even asked "can't you just add a bit to the superblock?"
   to which I answered "that's essentially what the one
   line opt-in addition does".  Not sure if you are still
   objecting to that, but especially given that the 64-bit-fs-on
   32-bit-kernel issue above only affects some filesystems,
   I'm still thinking it is necessary.

5) You commented (before LSF) that the global variable should
   be avoided which is certainly valid, and I will try Nitin's
   suggestion to add a registration interface.

Did I miss anything?

I plan to submit a V4 for cleancache soon, and hope you will
be inclined to ack this time.

Thanks,
Dan
