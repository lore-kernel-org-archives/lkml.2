Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2EHQgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:36:01 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:46446 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756594Ab2EHQf6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:35:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAB+TZU8FNWuHrf6Hqnjs5fwH8yMJgd=CLPB0iUkrs2a-fgehtQ@mail.gmail.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
 <1336054995-22988-2-git-send-email-svenkatr@ti.com> <20120506233117.GU5091@dastard>
 <CAB+TZU8FNWuHrf6Hqnjs5fwH8yMJgd=CLPB0iUkrs2a-fgehtQ@mail.gmail.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Tue, 8 May 2012 22:05:32 +0530
Message-ID: <CANfBPZ9dzzamHe=O+Zi0w+Romk8WPerp6qF+3KsRvv+U_ZBFYA@mail.gmail.com>
Subject: Re: [PATCH v2 01/16] FS: Added demand paging markers to filesystem
To: mani <manishrma@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-mmc@vger.kernel.org,
        cjb@laptop.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd.bergmann@linaro.org, alex.lemberg@sandisk.com,
        ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 11:58 AM, mani <manishrma@gmail.com> wrote:
> How about adding the AS_DMPG flag in the file -> address_space when getting
> a filemap_fault()
> so that we can treat the page fault pages as the high priority pages over
> normal read requests.
> How about changing below lines for the support of the pages those are
> requested for the page fault ?
>
>
> --- a/fs/mpage.c 2012-05-04 12:59:12.000000000 +0530
> +++ b/fs/mpage.c 2012-05-07 13:13:49.000000000 +0530
> @@ -408,6 +408,8 @@ mpage_readpages(struct address_space *ma
>                     &last_block_in_bio, &map_bh,
>                     &first_logical_block,
>                     get_block);
> +           if(test_bit(AS_DMPG, &mapping->flags) && bio)
>
> +                 bio->bi_rw |= REQ_RW_DMPG
>         }
>         page_cache_release(page);
>     }
> --- a/include/linux/pagemap.h    2012-05-04 12:57:35.000000000 +0530
> +++ b/include/linux/pagemap.h    2012-05-07 13:15:24.000000000 +0530
> @@ -27,6 +27,7 @@ enum mapping_flags {
>  #if defined (CONFIG_BD_CACHE_ENABLED)
>     AS_DIRECT  =   __GFP_BITS_SHIFT + 4,  /* DIRECT_IO specified on file op
> */
>  #endif
> +   AS_DMPG  =   __GFP_BITS_SHIFT + 5,  /* DEMAND PAGE specified on file op
> */
>  };
>
>  static inline void mapping_set_error(struct address_space *mapping, int
> error)
>
> --- a/mm/filemap.c   2012-05-04 12:58:49.000000000 +0530
> +++ b/mm/filemap.c   2012-05-07 13:15:03.000000000 +0530
> @@ -1646,6 +1646,7 @@ int filemap_fault(struct vm_area_struct
>     if (offset >= size)
>         return VM_FAULT_SIGBUS;
>
> +   set_bit(AS_DMPG, &file->f_mapping->flags);
>     /*
>      * Do we have something in the page cache already?
>      */
>
> Will these changes have any adverse effect ?
>

Thanks for the example but I can't judge which of the two is the most
elegant or acceptable to maintainers.
I can test with your change and inform if it works.

> Thanks & Regards
> Manish
>
> On Mon, May 7, 2012 at 5:01 AM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> On Thu, May 03, 2012 at 07:53:00PM +0530, Venkatraman S wrote:
>> > From: Ilan Smith <ilan.smith@sandisk.com>
>> >
>> > Add attribute to identify demand paging requests.
>> > Mark readpages with demand paging attribute.
>> >
>> > Signed-off-by: Ilan Smith <ilan.smith@sandisk.com>
>> > Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>
>> > Signed-off-by: Venkatraman S <svenkatr@ti.com>
>> > ---
>> >  fs/mpage.c                |    2 ++
>> >  include/linux/bio.h       |    7 +++++++
>> >  include/linux/blk_types.h |    2 ++
>> >  3 files changed, 11 insertions(+)
>> >
>> > diff --git a/fs/mpage.c b/fs/mpage.c
>> > index 0face1c..8b144f5 100644
>> > --- a/fs/mpage.c
>> > +++ b/fs/mpage.c
>> > @@ -386,6 +386,8 @@ mpage_readpages(struct address_space *mapping,
>> > struct list_head *pages,
>> >                                       &last_block_in_bio, &map_bh,
>> >                                       &first_logical_block,
>> >                                       get_block);
>> > +                     if (bio)
>> > +                             bio->bi_rw |= REQ_RW_DMPG;
>>
>> Have you thought about the potential for DOSing a machine
>> with this? That is, user data reads can now preempt writes of any
>> kind, effectively stalling writeback and memory reclaim which will
>> lead to OOM situations. Or, alternatively, journal flushing will get
>> stalled and no new modifications can take place until the read
>> stream stops.
>>
>> This really seems like functionality that belongs in an IO
>> scheduler so that write starvation can be avoided, not in high-level
>> data read paths where we have no clue about anything else going on
>> in the IO subsystem....
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
