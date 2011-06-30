Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1F3PGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:06:18 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:59830 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1F3PGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:06:15 -0400
Date: Thu, 30 Jun 2011 17:06:08 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 8/8] blk-throttle: enable throttling of task while
 dirtying pages
Message-ID: <20110630150608.GA2068@thinkpad>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
 <1309275309-12889-9-git-send-email-vgoyal@redhat.com>
 <20110630145229.GA1655@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630145229.GA1655@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 04:52:29PM +0200, Andrea Righi wrote:
> On Tue, Jun 28, 2011 at 11:35:09AM -0400, Vivek Goyal wrote:
> > Put the blk_throtl_dirty_pages() hook in
> > balance_dirty_pages_ratelimited_nr() to enable task throttling.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  include/linux/blkdev.h |    5 +++++
> >  mm/page-writeback.c    |    3 +++
> >  2 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 4ce6e68..5d4a57e 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -1180,12 +1180,17 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
> >  extern int blk_throtl_init(struct request_queue *q);
> >  extern void blk_throtl_exit(struct request_queue *q);
> >  extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
> > +extern void blk_throtl_dirty_pages(struct address_space *mapping,
> > +				unsigned long nr_dirty);
> >  #else /* CONFIG_BLK_DEV_THROTTLING */
> >  static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
> >  {
> >  	return 0;
> >  }
> >  
> > +static inline void blk_throtl_dirty_pages(struct address_space *mapping,
> > +				unsigned long nr_dirty) {}
> > +
> >  static inline int blk_throtl_init(struct request_queue *q) { return 0; }
> >  static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
> >  #endif /* CONFIG_BLK_DEV_THROTTLING */
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 31f6988..943e551 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -629,6 +629,9 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
> >  	unsigned long ratelimit;
> >  	unsigned long *p;
> >  
> > +	/* Subject writes to IO controller throttling */
> > +	blk_throtl_dirty_pages(mapping, nr_pages_dirtied);
> > +
> 
> mmmh.. in this way we throttle also tasks that are re-writing dirty pages
> multiple times.
> 
> From the controller perspective what is actually generating I/O on block
> devices is the generation of _new_ dirty pages. Multiple re-writes in page
> cache should never be throttled IMHO.
> 
> I would re-write this patch in the following way. What do you think?
> 
> Thanks,
> -Andrea
> 
> ---
> Subject: [PATCH 8/8] blk-throttle: enable throttling of task while dirtying pages
> 
> From: Andrea Righi <andrea@betterlinux.com>
> 
> Put the blk_throtl_dirty_pages() hook in balance_dirty_pages_ratelimited_nr()
> to enable task throttling.
> 
> Moreover, modify balance_dirty_pages_ratelimited_nr() to accept the additional
> parameter "redirty". This parameter can be used to notify if the pages have
> been dirtied for the first time or re-dirtied.
> 
> This information can be used by the blkio.throttle controller to distinguish
> between a WRITE in the page cache, that will eventually generates I/O activity
> on block device by the writeback code, and a re-WRITE operation that most of
> the time will not generate additional I/O activity.
> 
> This means that a task that re-writes multiple times the same blocks of a file
> is affected by the blkio limitations only for the actual I/O that will be
> performed to the underlying block devices during the writeback process.
> 
> Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

A simple test (see rewrite.c below):

 # echo 8:0 1000000 > /sys/fs/cgroup/blkio/foo/blkio.throttle.write_bps_device

- before:

 $ ./rewrite 
 0: 4s <-- first write
 1: 4s \
 2: 4s |
 3: 5s |
 4: 4s |
 5: 4s | <-- re-writes (not generating additional I/O)
 6: 4s |
 7: 4s |
 8: 5s |
 9: 4s /

- after:

 $ ./rewrite 
 0: 4s <-- first write
 1: 0s \
 2: 0s |
 3: 0s |
 4: 0s |
 5: 0s | <-- re-writes (not generating additional I/O)
 6: 0s |
 7: 0s |
 8: 0s |
 9: 0s /

-Andrea

---
/*
 * rewrite.c
 */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <fcntl.h>
#include <sys/types.h>

static char buf[4 * 1024 * 1024];

int main(int argc, char **argv)
{
	int fd, i;

	fd = open("junk", O_WRONLY | O_CREAT, 0600);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	for (i = 0; i < 10; i++) {
		time_t start, end;

		lseek(fd, 0, SEEK_SET);
		start = time(NULL);
		if (write(fd, buf, sizeof(buf)) < 0) {
			perror("write");
			exit(1);
		}
		end = time(NULL);

		printf("%d: %zus\n", i, end - start);
		fflush(stdout);
	}
	unlink("junk");
	return 0;
}
