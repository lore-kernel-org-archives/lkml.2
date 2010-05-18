Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0ERPvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:51:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab0ERPvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:51:42 -0400
Date: Wed, 19 May 2010 01:51:35 +1000
From: Nick Piggin <npiggin@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unexpected splice "always copy" behavior observed
Message-ID: <20100518155135.GJ2516@laptop>
References: <20100518153440.GB7748@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518153440.GB7748@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The basic problem is that the filesystem APIs were never designed with
this usage in mind, so we had to disable the SPLICE_F_MOVE support by
default.

So short answer is that this is expected.

What would be needed is to have filesystem maintainers go through and
enable it on a case by case basis. It's trivial for tmpfs/ramfs type
filesystems and I have a patch for those, but I never posted it on.yet.
Even basic buffer head filesystems IIRC get a little more complex --
but we may get some milage just out of invalidating the existing
pagecache rather than getting fancy and trying to move buffers over
to the new page.

Nick

On Tue, May 18, 2010 at 11:34:40AM -0400, Mathieu Desnoyers wrote:
> Hi,
> 
> I'm currently digging into the splice code to figure out why it's always in copy
> mode even though I specified the SPLICE_F_MOVE flag and released the page
> references from the LTTng ring buffer. I'm splicing to a pipe and then from the
> pipe to an ext3 filesystem (2.6.33.4 kernel). I've got the feeling I'm missing
> something and I don't like that.
> 
> My simple test case is to add a printk around the splice copy:
> 
> fs/splice.c: pipe_to_file()
>        if (buf->page != page) {
>                 /*
>                  * Careful, ->map() uses KM_USER0!
>                  */
>                 char *src = buf->ops->map(pipe, buf, 1);
>                 char *dst = kmap_atomic(page, KM_USER1);
> 
>                 printk(KERN_WARNING "SPLICE COPY!!!\n");
>                 memcpy(dst + offset, src + buf->offset, this_len);
>                 flush_dcache_page(page);
>                 kunmap_atomic(dst, KM_USER1);
>                 buf->ops->unmap(pipe, buf, src);
>         }
> 
> I'll start with a disclaimer that I only recently improved my splice
> understanding, so AFAIU:
> 
> * pipe_to_file() allocates a struct page *page on its stack.
> 
> * It is passed, uninitialized, to
> 
>         ret = pagecache_write_begin(file, mapping, sd->pos, this_len,
>                                 AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
> 
>     that looks already odd to me, as I would expect pipe_to_file to populate
>     this page pointer with buf->page initially if the proper conditions are met.
> 
> * Looking at the ext2 and ext3 write_begin code, neither are using the pagep
>   parameter:
> 
>   ext2:
> 
> static int
> ext2_write_begin(struct file *file, struct address_space *mapping,
>                 loff_t pos, unsigned len, unsigned flags,
>                 struct page **pagep, void **fsdata)
> {
>         *pagep = NULL;
>         return __ext2_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
> }
> 
> 
>   ext3:
> 
> static int ext3_write_begin(struct file *file, struct address_space *mapping,
>                                 loff_t pos, unsigned len, unsigned flags,
>                                 struct page **pagep, void **fsdata)
> {
>         struct page *page;
>         ....
> 
> retry:
>         page = grab_cache_page_write_begin(mapping, index, flags);
>         if (!page)
>                 return -ENOMEM;
>         *pagep = page;
> 
> * So, considering the test to check if the page content must be copied:
> 
>        if (buf->page != page) {
> 
>   how is it ever possible that buf->page == page ?
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
