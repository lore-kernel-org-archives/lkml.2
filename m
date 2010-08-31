Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0HaAvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:51:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20844 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab0HaAvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:51:08 -0400
MIME-Version: 1.0
Message-ID: <37115137-2233-4b7f-b4d7-6d8ee07210e0@default>
Date: Mon, 30 Aug 2010 17:48:17 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
        mfasheh@suse.com, Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@kernel.dk, Dave Mccracken <dave.mccracken@oracle.com>,
        riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>,
        mel@csn.ul.ie, yinghan@google.com, gthelen@google.com
Subject: RE: [PATCH V4 4/8] Cleancache: VFS hooks for cleancache
References: <20100830223203.GA1296@ca-server1.us.oracle.com
 4C7C35F5.6040508@goop.org>
In-Reply-To: <4C7C35F5.6040508@goop.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		if (s->cleancache_poolid >= 0) {
> > +			int cleancache_poolid = s->cleancache_poolid;
> 
> That's a lot of characters for a local in a 3-line scope.

:-) OK.
 
> > +			s->cleancache_poolid = -1; /* avoid races */
> 
> Races with what?  Something else sneaking something into the pool after
> the flush?  Is the filesystem dead at this stage or not?

If there are any inodes in the page cache that point to
this superblock, a cleancache_put_page may happen asynchronously
that grabs from page->...->i_sb->cleancache_poolid.
If the cleancache_flush_fs races with it and another
cleancache_init_fs happens after the cleancache_put_page
gets the poolid, the poolid could be stale.

Highly unlikely, but I thought it best to be safe.

> > +	/* 99% of the time, we don't need to flush the cleancache on the
> bdev.
> > +	 * But, for the strange corners, lets be cautious
> > +	 */
> 
> This comment-style is... unconventional for the kernel.

Yeah, I decided to defer to Chris Mason's wisdom and left it. :-)

