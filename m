Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab1KVOSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:18:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:22540 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab1KVOSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:18:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,553,1315206000"; 
   d="scan'208";a="77968622"
Date: Tue, 22 Nov 2011 22:18:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 8/8] readahead: dont do start-of-file readahead after
 lseek()
Message-ID: <20111122141829.GB29261@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121093847.015852579@intel.com>
 <20111121153624.dea4f320.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121153624.dea4f320.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- linux-next.orig/fs/read_write.c	2011-11-20 22:02:01.000000000 +0800
> > +++ linux-next/fs/read_write.c	2011-11-20 22:02:03.000000000 +0800
> > @@ -47,6 +47,10 @@ static loff_t lseek_execute(struct file 
> >  		file->f_pos = offset;
> >  		file->f_version = 0;
> >  	}
> > +
> > +	if (!(file->f_ra.ra_flags & READAHEAD_LSEEK))
> > +		file->f_ra.ra_flags |= READAHEAD_LSEEK;
> > +
> >  	return offset;
> >  }
> 
> Confused.  How does READAHEAD_LSEEK get cleared again?

I thought it's not necessary (at least for this case). But yeah, it's
good to clear it to make it more reasonable and avoid unexpected things.

And it would be simple to do, in ra_submit():

-       ra->ra_flags &= ~READAHEAD_MMAP;
+       ra->ra_flags &= ~(READAHEAD_MMAP | READAHEAD_LSEEK);

Thanks,
Fengguang
