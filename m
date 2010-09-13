Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0IMVmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:42:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561Ab0IMVmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:42:17 -0400
Date: Mon, 13 Sep 2010 14:41:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
        axboe@kernel.dk, linux-scsi@vger.kernel.org
Subject: Re: [Bug 18252] spinlock lockup in __make_request <- submit_bio <-
 ondemand_readahead
Message-Id: <20100913144139.b9e18133.akpm@linux-foundation.org>
In-Reply-To: <4C8B50F1.4020502@s5r6.in-berlin.de>
References: <bug-18252-4803@https.bugzilla.kernel.org/>
	<4C8B50F1.4020502@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Sep 2010 11:50:41 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Full quote for lkml:
> 
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=18252
> > 
> >            Summary: spinlock lockup in __make_request <- submit_bio <-
> >                     ondemand_readahead
> >            Product: IO/Storage
> >            Version: 2.5
> >     Kernel Version: 2.6.36-rc3
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Block Layer
> >         AssignedTo: axboe@kernel.dk
> >         ReportedBy: stefanr@s5r6.in-berlin.de
> >         Regression: No
> > 
> > 
> > Created an attachment (id=29562)
> >  --> (https://bugzilla.kernel.org/attachment.cgi?id=29562)
> > BUG screenshot
> > 
> > After a week uptime of 2.6.36-rc3 (I ran 2.6.35 before that),
> 
> Almost two weeks uptime actually.
> 
> > I was greeted by a black screen of death today in the morning:
> > 
> > (see screenshot in attachment; partial transcript:)
> > 
> > sending NMI to all CPUs:
> > BUG: soinlock lockup on CPU#0, ktorrent/4313, ffff8802...
> > PID: 4313, comm: ktorrent Tainted: G  M D W   2.6.36-rc3 #3
> > Call Trace:
> >  [...] do_raw_spin_lock+0x118/0x147
> >  [...] _raw_spin_lock_irq+0x44/0x49
> >  [...] ? __make_request+0x5c/0x400
> >  [...] __make_request+0x5c/0x400
> >  [...] generic_make_request+0x23a/0x2a9
> >  [...] submit_bio+0xad/b6
> >  [...] mpage_bio_submit...
> >  [...] do_mpage_readpage...
> >  [...] ? get_parent_ip...
> >  [...] ? sub_preempt_count...
> >  [...] ? __lru_cache_add...
> >  [...] mpage_readpages...
> >  [...] ? ext4_get_block...
> >  [...] ? __alloc_pages_nodemask...
> >  [...] ? ext4_get_block...
> >  [...] ext4_readpages...
> >  [...] __do_page_cache_readahead...
> >  [...] ? __do_page_cache_readahead...
> >  [...] ra_submit...
> >  [...] ondemand_readahead...
> > 
> > This is a system with Phenom II x4 and Radeon graphics.  Since kernel mode
> > setting is fairly new for radeon, it is possible that the lockup happened with
> > earlier kernels too but simply ended in a lockup without trace dump to the
> > screen.  IOW, it is not clear to me whether this is a regression or not.
> > 
> > The bug happened while kaffeine wrote an MPEG 2 TS to the same filesystem from
> > which ktorrent was reading.  Of course this kind of commonplace workload
> > happened without problem two or three times before during the week in which I
> > ran 2.6.36-rc3.
> > 
> 
> (The screenshot is a bit large, hence I reported in bugzilla instead of the list.)
> 

What you've quoted above appears to be just the aftermath. 
https://bugzilla.kernel.org/attachment.cgi?id=29562 indicates that the
kernel earlier crashed in scsi code, perhaps under
scsi_setup_fs_cmnd().

The question is: was that actually the first crash, or did an even
earlier one scroll off?

