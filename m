Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab0FDPOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:14:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23276 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab0FDPOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:14:36 -0400
MIME-Version: 1.0
Message-ID: <16b4dcd5-95d8-4cb0-885d-0189ef90c02b@default>
Date: Fri, 4 Jun 2010 08:13:14 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       adilger@Sun.COM, tytso@mit.edu, mfasheh@suse.com,
       joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
Subject: RE: [PATCH V2 3/7] Cleancache (was Transcendent Memory): VFS hooks
References: <20100528173610.GA12270@ca-server1.us.oracle.com
 20100604132948.GC1879@barrios-desktop>
In-Reply-To: <20100604132948.GC1879@barrios-desktop>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C091823.0098:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Dan.
> I reviewed quickly. So I may be wrong. :)

Hi Minchan --

Thanks for your thorough review!  I don't think anyone
else yet has examined the semantics of the cleancache
patch as deeply as you have.  Excellent!

> > +	/*
> > +	 * if we're uptodate, flush out into the cleancache, otherwise
> > +	 * invalidate any existing cleancache entries.  We can't leave
> > +	 * stale data around in the cleancache once our page is gone
> > +	 */
> > +	if (PageUptodate(page))
> > +		cleancache_put_page(page);
> > +	else
> > +		cleancache_flush_page(mapping, page);
> 
> I doubt it's right place related to PFRA.

I agree it doesn't seem to be the right place, but it does work
and there doesn't seem to be a better place.
 
> 1)
> You mentiond PFRA in you description and I understood cleancache has
> a cold clean page which is evicted by reclaimer.
> But __remove_from_page_cache can be called by other call sites.
> 
> For example, shmem_write page calls it for moving the page from page
> cache
> to swap cache. Although there isn't the page in page cache, it is in
> swap cache.
> So next read/write of shmem until swapout happens can be read/write in
> swap cache.
> 
> I didn't looked into whole of callsites. But please review again them.

I think the "if (PageUptodate(page))" eliminates all the cases
where bad things can happen.

Note that there may be cases where some unnecessary puts/flushes
occur.  The focus of the patch is on correctness first; it may
be possible to increase performance (marginally) in the future by
reducing unnecessary cases.

> 3) Please consider system memory pressure.
> And I hope Nitin consider this, too.

This is definitely very important but remember that cleancache
provides a great deal of flexibility:  Any page in cleancache
can be thrown away at any time as every page is clean!  It
can even accept a page and throw it away immediately.  Clearly
the backend needs to do this intelligently so this will
take some policy work.

Since I saw you sent a separate response to Nitin, I'll
let him answer for his in-kernel page cache compression
work.  The solution to the similar problem for Xen is
described in the tmem internals document that I think
I pointed to earlier here:
http://oss.oracle.com/projects/tmem/documentation/internals/ 

Thanks,
Dan

