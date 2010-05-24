Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0EXUEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:04:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51919 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab0EXUEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:04:34 -0400
MIME-Version: 1.0
Message-ID: <1b84523f-a7df-4d6a-870f-b684bd012230@default>
Date: Mon, 24 May 2010 13:02:34 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: chris.mason@oracle.com, akpm@linux-foundation.org, adilger@sun.com,
       tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
       jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com,
       npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com
Subject: RE: Cleancache [PATCH 2/7] (was Transcendent Memory): core files
References: <20100422132809.GA27302@ca-server1.us.oracle.com
 20100514231815.GY30031@ZenIV.linux.org.uk>
In-Reply-To: <20100514231815.GY30031@ZenIV.linux.org.uk>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BFADBB7.0086:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Al Viro [mailto:viro@ZenIV.linux.org.uk]
> Subject: Re: Cleancache [PATCH 2/7] (was Transcendent Memory): core files

Hi Al!

Thanks for the feedback!  Sorry for the delayed response.

> ...again, use sane types...

Good point.  Will fix types for next rev (using size_t, ino_t,
and pgoff_t).

> > +	int (*get_page)(int, unsigned long, unsigned long, struct page *);
> 
> Ugh.  First of all, presumably you have some structure behind that
> index, don't you?  Might be a better way to do it.

Not quite sure what you mean here.  The index is really
just part of a unique handle for cleancache to identify
the (page of) data.

> What's more, use of ->i_ino is simply wrong.  How stable do you want that
> to be and how much do you want it to outlive struct address_space in question?
> From my reading of your code, it doesn't outlive that anyway, so...

Unless I misunderstand your point, no, the inode never outlives
the address space because the specification requires the kernel
to ensure coherency; if the inode were about to outlive the
address space, the cleancache_flush operations must be invoked
(and I think the patch covers all the necessary cases).

> The third one is pgoff_t; again, use sane types, _if_ you actually want
> the argument #3 at all - it can be derived from struct page you are
> passing there as well.

I thought it best to declare the _ops so that the struct page
is opaque to the "backend" (driver).  The kernel-side ("frontend")
defines the handle and ensures coherency, so the backend shouldn't
be allowed to derive or muck with the three-tuple passed by the
kernel. In the existing (Xen tmem) driver, the only operation
performed on the struct page parameter is page_to_pfn().  OTOH,
I could go one step further and pass a pfn_t instead of a
struct page, since it is really only the physical page frame that
the backend needs to know about and (synchronously) read/write from/to.

Thoughts?

Thanks again!
Dan

