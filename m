Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab2JSOi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:38:29 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:41709 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab2JSOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:38:21 -0400
Date: Fri, 19 Oct 2012 16:38:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Mel Gorman <mgorman@suse.de>, linux-s390@vger.kernel.org
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
 s390
Message-ID: <20121019163814.55b3590e@mschwide>
In-Reply-To: <alpine.LSU.2.00.1210091600450.30446@eggly.anvils>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
	<alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
	<20121009101822.79bdcb65@mschwide>
	<alpine.LSU.2.00.1210091600450.30446@eggly.anvils>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12101914-2966-0000-0000-00000598A146
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012 16:21:24 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> > 
> > I am seriously tempted to switch to pure software dirty bits by using
> > page protection for writable but clean pages. The worry is the number of
> > additional protection faults we would get. But as we do software dirty
> > bit tracking for the most part anyway this might not be as bad as it
> > used to be.  
> 
> That's exactly the same reason why tmpfs opts out of dirty tracking, fear
> of unnecessary extra faults.  Anomalous as s390 is here, tmpfs is being
> anomalous too, and I'd be a hypocrite to push for you to make that change.

I tested the waters with the software dirty bit idea. Using kernel compile
as test case I got these numbers:

disk backing, swdirty: 10,023,870 minor-faults 18 major-faults
disk backing, hwdirty: 10,023,829 minor-faults 21 major-faults                          

tmpfs backing, swdirty: 10,019,552 minor-faults 49 major-faults
tmpfs backing, hwdirty: 10,032,909 minor-faults 81 major-faults

That does not look bad at all. One test I found that shows an effect is
lat_mmap from LMBench:

disk backing, hwdirty: 30,894 minor-faults 0 major-faults
disk backing, swdirty: 30,894 minor-faults 0 major-faults

tmpfs backing, hwdirty: 22,574 minor-faults 0 major-faults
tmpfs backing, swdirty: 36,652 minor-faults 0 major-faults 

The runtime between the hwdirty vs. the swdirty setup is very similar,
encouraging enough for me to ask our performance team to run a larger test.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

