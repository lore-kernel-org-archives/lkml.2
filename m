Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2BTGT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:19:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60584 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2BTGT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:19:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gnehzuil.liu@gmail.com designates 10.68.217.67 as permitted sender) smtp.mail=gnehzuil.liu@gmail.com; dkim=pass header.i=gnehzuil.liu@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120220062006.GA5028@gmail.com>
References: <20120217092205.GA9462@gmail.com>
	<4F3EB675.9030702@openvz.org>
	<20120220062006.GA5028@gmail.com>
Date: Mon, 20 Feb 2012 14:19:28 +0800
Message-ID: <CANWLp03Rmj4TNQx56W9etkJc-LNReBywEO6ZDy+LGrCLa17Jgw@mail.gmail.com>
Subject: Fwd: Fine granularity page reclaim
From: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Zheng Liu <gnehzuil.liu@gmail.com>
Date: Mon, Feb 20, 2012 at 2:20 PM
Subject: Re: Fine granularity page reclaim
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-kernl@vger.kernel.org


Cc linux-kernel mailing list.

On Sat, Feb 18, 2012 at 12:20:05AM +0400, Konstantin Khlebnikov wrote:
> Zheng Liu wrote:
> >Hi all,
> >
> >Currently, we encounter a problem about page reclaim. In our product
> > system,
> >there is a lot of applictions that manipulate a number of files. In these
> >files, they can be divided into two categories. One is index file,
> > another is
> >block file. The number of index files is about 15,000, and the number of
> >block files is about 23,000 in a 2TB disk. The application accesses index
> >file using mmap(2), and read/write block file using pread(2)/pwrite(2).
> > We hope
> >to hold index file in memory as much as possible, and it works well in
> > Redhat
> >2.6.18-164. It is about 60-70% of index files that can be hold in memory.
> >However, it doesn't work well in Redhat 2.6.32-133. I know in 2.6.18 that
> > the
> >linux uses an active list and an inactive list to handle page reclaim,
> > and in
> >2.6.32 that they are divided into anonymous list and file list. So I am
> >curious about why most of index files can be hold in 2.6.18? The index
> > file
> >should be replaced because mmap doesn't impact the lru list.
>
> There was my patch for fixing similar problem with shared/executable
> mapped pages
> "vmscan: promote shared file mapped pages" commit 34dbc67a644f and commit
> c909e99364c
> maybe it will help in your case.

Hi Konstantin,

Thank you for your reply.  I have tested it in upstream kernel.  These
patches are useful for multi-processes applications.  But, in our product
system, there are some applications that are multi-thread.  So
'references_ptes > 1' cannot help these applications to hold the data in
memory.

Regards,
Zheng

>
> >
> >BTW, I have some problems that need to be discussed.
> >
> >1. I want to let index and block files are separately reclaimed. Is there
> > any
> >ways to satisify me in current upstream?
> >
> >2. Maybe we can provide a mechansim to let different files to be mapped
> > into
> >differnet nodes. we can provide a ioctl(2) to tell kernel that this file
> > should
> >be mapped into a specific node id. A nid member is added into
> > addpress_space
> >struct. When alloc_page is called, the page can be allocated from that
> > specific
> >node id.
> >
> >3. Currently the page can be reclaimed according to pid in memcg. But it
> > is too
> >coarse. I don't know whether memcg could provide a fine granularity page
> >reclaim mechansim. For example, the page is reclaimed according to inode
> > number.
> >
> >I don't subscribe this mailing list, So please Cc me. Thank you.
> >
> >Regards,
> >Zheng
> >
> >--
> >To unsubscribe, send a message with 'unsubscribe linux-mm' in
> >the body to majordomo@kvack.org.  For more info on Linux MM,
> >see: http://www.linux-mm.org/ .
> >Fight unfair telecom internet charges in Canada: sign
> > http://stopthemeter.ca/
> >Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>
>
