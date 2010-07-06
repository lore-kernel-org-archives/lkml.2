Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0GFHLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:11:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59249 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab0GFHLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:11:31 -0400
Date: Tue, 6 Jul 2010 00:09:19 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 2/2] ocfs2: No need to zero pages past i_size. i_size v2
Message-ID: <20100706070918.GD13023@mail.oracle.com>
Mail-Followup-To: Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
References: <20100702224912.GC5800@mail.oracle.com>
 <20100703213219.GB21262@mail.oracle.com>
 <20100703213343.GC21262@mail.oracle.com>
 <4C30A4FD.4030900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C30A4FD.4030900@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C32D701.009F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 11:13:01PM +0800, Tao Ma wrote:
> On 07/04/2010 05:33 AM, Joel Becker wrote:
> >@@ -1142,11 +1143,17 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
> >  	/*
> >  	 * Figure out how many pages we'll be manipulating here. For
> >  	 * non allocating write, we just change the one
> >-	 * page. Otherwise, we'll need a whole clusters worth.
> >+	 * page. Otherwise, we'll need a whole clusters worth.  If we're
> >+	 * writing past i_size, we only need enough pages to cover the
> >+	 * last page of the write.
> The comments for the whole function before the function name also
> needs this change accordingly?

	Not really.  That comment set a limit, this comment is more
detailed.

> >  	if (new) {
> >  		wc->w_num_pages = ocfs2_pages_per_cluster(inode->i_sb);
> >  		start = ocfs2_align_clusters_to_page_index(inode->i_sb, cpos);
> >+		/* This is the index *past* the write */
> >+		end_index = ((user_pos + user_len)>>  PAGE_CACHE_SHIFT) + 1;
> should it be
> 		end_index = ((user_pos + user_len - 1) >> PAGE_CACHE_SHIFT) + 1?

	Maybe.  Gotta think about it and test.

Joel

-- 

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
