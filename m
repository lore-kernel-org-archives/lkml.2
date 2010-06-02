Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab0FBQI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:08:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60986 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab0FBQIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:08:54 -0400
MIME-Version: 1.0
Message-ID: <28f2e0a1-dfb5-4bcc-b0d7-238b5eea3e92@default>
Date: Wed, 2 Jun 2010 09:07:10 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
       joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
Subject: RE: [PATCH V2 0/7] Cleancache (was Transcendent Memory): overview
References: <20100528173510.GA12166@ca-server1.us.oracle.com
 20100602132427.GA32110@infradead.org>
In-Reply-To: <20100602132427.GA32110@infradead.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C0681DA.0202:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Christoph Hellwig [mailto:hch@infradead.org]
> Subject: Re: [PATCH V2 0/7] Cleancache (was Transcendent Memory):
> overview

Hi Christophe --

Thanks for your feedback!

> >  fs/btrfs/super.c           |    2
> >  fs/buffer.c                |    5 +
> >  fs/ext3/super.c            |    2
> >  fs/ext4/super.c            |    2
> >  fs/mpage.c                 |    7 +
> >  fs/ocfs2/super.c           |    3
> >  fs/super.c                 |    8 +
> 
> This is missing out a whole lot of filesystems.  Even more so why the
> hell do you need hooks into the filesystem?

Let me rephrase/regroup your question.  Let me know if
I missed anything...

1) Why is the VFS layer involved at all?

VFS hooks are necessary to avoid a disk read when a page
is already in cleancache and to maintain coherency (via
cleancache_flush operations) between cleancache, the
page cache, and disk.  This very small, very clean set
of hooks (placed by Chris Mason) all compile into
nothingness if cleancache is config'ed off, and turn
into "if (*p == NULL)" if config'ed on but no "backend"
claims cleancache_ops or if an fs doesn't opt-in
(see below).

2) Why do the individual filesystems need to be modified?

Some filesystems are built entirely on top of VFS and
the hooks in VFS are sufficient, so don't require an
fs "cleancache_init" hook; the initial implementation
of cleancache didn't provide this hook.   But for some
fs (such as btrfs) the VFS hooks are incomplete and
one or more hooks in the fs-specific code is required.
For some other fs's (such as tmpfs), cleancache may even
be counterproductive.

So it seemed prudent to require an fs to "opt in" to
use cleancache, which requires at least one hook in
any fs.

3) Why are filesystems missing?
 
Only because they haven't been tested.  The existence
proof of four fs's (ext3/ext4/ocfs2/btfrs) should be
sufficient to validate the concept, the opt-in approach
means that untested filesystems are not affected, and
the hooks in the four fs's should serve as examples to
show that it should be very easy to add more fs's in the
future.

> Please give your patches some semi-resonable subject line.

Not sure what you mean... are the subject lines too short?
Or should I leave off the back-reference to Transcendent Memory?
Or please suggest something you think is more reasonable?

Thanks,
Dan
