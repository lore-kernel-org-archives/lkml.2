Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab0ERPev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:34:51 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41959 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755561Ab0ERPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:34:47 -0400
Date: Tue, 18 May 2010 11:34:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Unexpected splice "always copy" behavior observed
Message-ID: <20100518153440.GB7748@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:16:29 up 115 days, 17:53, 10 users,  load average: 0.18, 0.27,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently digging into the splice code to figure out why it's always in copy
mode even though I specified the SPLICE_F_MOVE flag and released the page
references from the LTTng ring buffer. I'm splicing to a pipe and then from the
pipe to an ext3 filesystem (2.6.33.4 kernel). I've got the feeling I'm missing
something and I don't like that.

My simple test case is to add a printk around the splice copy:

fs/splice.c: pipe_to_file()
       if (buf->page != page) {
                /*
                 * Careful, ->map() uses KM_USER0!
                 */
                char *src = buf->ops->map(pipe, buf, 1);
                char *dst = kmap_atomic(page, KM_USER1);

                printk(KERN_WARNING "SPLICE COPY!!!\n");
                memcpy(dst + offset, src + buf->offset, this_len);
                flush_dcache_page(page);
                kunmap_atomic(dst, KM_USER1);
                buf->ops->unmap(pipe, buf, src);
        }

I'll start with a disclaimer that I only recently improved my splice
understanding, so AFAIU:

* pipe_to_file() allocates a struct page *page on its stack.

* It is passed, uninitialized, to

        ret = pagecache_write_begin(file, mapping, sd->pos, this_len,
                                AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);

    that looks already odd to me, as I would expect pipe_to_file to populate
    this page pointer with buf->page initially if the proper conditions are met.

* Looking at the ext2 and ext3 write_begin code, neither are using the pagep
  parameter:

  ext2:

static int
ext2_write_begin(struct file *file, struct address_space *mapping,
                loff_t pos, unsigned len, unsigned flags,
                struct page **pagep, void **fsdata)
{
        *pagep = NULL;
        return __ext2_write_begin(file, mapping, pos, len, flags, pagep,fsdata);
}


  ext3:

static int ext3_write_begin(struct file *file, struct address_space *mapping,
                                loff_t pos, unsigned len, unsigned flags,
                                struct page **pagep, void **fsdata)
{
        struct page *page;
        ....

retry:
        page = grab_cache_page_write_begin(mapping, index, flags);
        if (!page)
                return -ENOMEM;
        *pagep = page;

* So, considering the test to check if the page content must be copied:

       if (buf->page != page) {

  how is it ever possible that buf->page == page ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
