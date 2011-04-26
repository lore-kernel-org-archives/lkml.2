Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1DZQCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:02:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62676 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1DZQCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:02:46 -0400
MIME-Version: 1.0
Message-ID: <e721b63e-5854-468b-bacb-3c7a75ee4321@default>
Date: Tue, 26 Apr 2011 09:00:44 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com,
        jlbec@evilplan.org, matthew@wil.cx, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mm@kvack.org, hch@infradead.org, ngupta@vflare.org,
        jeremy@goop.org, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com,
        avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org
Subject: RE: [PATCH V8 4/8] mm/fs: add hooks to support cleancache
References: <83ef8b69-f041-43e6-a5a9-880ff3da26f2@default>
 <871v135xvj.fsf@devron.myhome.or.jp>
 <040a7fa3-14dd-4960-a296-cfdd061e015f@default
 BANLkTikDQ_PuYPJEZRX_24uUi1DYWbvpzQ@mail.gmail.com>
In-Reply-To: <BANLkTikDQ_PuYPJEZRX_24uUi1DYWbvpzQ@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6555.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DB6EC51.00AB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan.kim@gmail.com]
> On Sat, Apr 16, 2011 at 3:53 AM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> >> From: OGAWA Hirofumi [mailto:hirofumi@mail.parknet.co.jp]
> >>
> >> Andrew Morton <akpm@linux-foundation.org> writes:
> >>
> > Andrew, I wonder if you would be so kind as to read the following
> > and make a "ruling".  If you determine a preferable set of names,
> > I will abide by your decision and repost (if necessary).
> >
> > The problem is this: The English language has a limited number
> > of words that can be used to represent data motion and mapping
> > and most/all of them are already used in the kernel, often,
> > to quote Andrew, "in confusing ways."  Complicating this, I
> > think the semantics of the cleancache operations are different
> > from the semantics of any other kernel operation... intentionally
> > so, because the value of cleancache is a direct result of those
> > differing semantics.  And the cleancache semantics
> > are fairly complex (again intentionally) so a single function
> > name can't possibly describe the semantics.
> >
> > The cleancache operations are:
> > - put (page)
> > - get (page)
> > - flush page
> > - flush inode
> > - init fs
> > - flush fs
> >
> > I think these names are reasonable representations of the
> > semantics of the operations performed... but I'm not a kernel
> > expert so there is certainly room for disagreement.  Though I
> > absolutely recognize the importance of a "name", I am primarily
> > interested in merging the semantics of the operations and
> > would happily accept any name that kernel developers could
> > agree on.  However, I fear that there will be NO name that
> > will satisfy all, so would prefer to keep the existing names.
> > If some renaming is eventually agreed upon, this could be done
> > post-merge.
> >
> > Here's a brief description of the semantics:
> >     :
> >  <semantics for other operations elided>
> >     :
> > The cleancache operation currently known as "get" has the
> > following semantics:  Derive the filesystem-determined handle
> > from this struct page.  If cleancache contains a page matching
> > that handle, recreate the page of data from cleancache and
> > place the results in the pageframe referred to by the
> > struct page.  Then delete in cleancache any record of the
> > handle and any data associated with it, so that a
> > subsequent "get" will no longer find a match for the handle;
> > any space used for the data can also be freed.
> >     :
> >  <semantics for other operations elided>
> >     :
> 
> At least, I didn't confused your semantics except just flush. That's
> why I suggested only flush but after seeing your explaining, there is
> another thing I want to change. The get/put is common semantic of
> reference counting in kernel but in POV your semantics, it makes sense
> to me but get has a exclusive semantic so I want to represent it with
> API name. Maybe cleancache_get_page_exclusive.
> 
> The summary is that I don't want to change all API name. Just two
> thing.
> (I am not sure you and others agree on me. It's just suggestion).
> 
> 1. cleancache_flush_page -> cleancache_[invalidate|remove]_page
> 2. cleancache_get_page -> cleancache_get_page_exclusive
> 

Hi Minchan --

Thanks for continuing to be interested in this and sorry for my
delayed response.

Actually, your comment about "get_page_exclusive" points out an
incompleteness in my description of the semantics for
cleancache_get_page.

First, I forgot to list cleancache_init_shared_fs, which is
the equivalent of cleancache_init_fs but used for clustered
filesystems.  (Support is included in the patch for ocfs2 but
I haven't played with it in quite some time and my focus has
been on the other filesystems, so it slipped my mind :-}

The cleancache_get_page operation has a slightly different semantics
depending on which of the init_fs calls was used.  However, the
location of the cleancache_get_page hook is the same regardless
of the fs, so the name of the operation must represent both
semantics.  In the case of init_fs (non-shared), the behavior
of cleancache_get_page is that the get is "destructive"; the page
is removed from cleancache on a successful get.  In the case of
a init_shared_fs, however, the get is "non-destructive"; the
page is NOT removed from cleancache.  When cleancache contains
pages from multiple kernels (e.g. Xen guests or different machines
in a RAMster cluster), this semantic difference can make a big
performance difference for a clustered filesystem.  Since zcache
only contains pages for a single kernel, the difference is moot.

Because of this, I am hesitant to add "exclusive" to the
end of the name of the operation.

> BTW, Nice description.
> Please include it in documentation if we can't reach the conclusion.
> It will help others to understand semantic of cleancache.

Thanks!  Nearly all of the description already exists in various
places in the patch but I agree that it would be good if I add
a new section to the Documentation file with the exact semantics.

Dan
