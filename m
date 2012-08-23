Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab2HWKV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:21:29 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:43640 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab2HWKVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:21:08 -0400
X-ASG-Debug-ID: 1345717267-0421b5402c89090001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <503603DE.5060905@fusionio.com>
Date: Thu, 23 Aug 2012 12:20:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: "Richard W.M. Jones" <rjones@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Josh Boyer <jwboyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: replace __getblk_slow misfix by grow_dev_page
 fix
References: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils> <20120822115243.GU1448@rhmail.home.annexia.org> <alpine.LSU.2.00.1208222143440.1917@eggly.anvils>
X-ASG-Orig-Subj: Re: [PATCH] block: replace __getblk_slow misfix by grow_dev_page
 fix
In-Reply-To: <alpine.LSU.2.00.1208222143440.1917@eggly.anvils>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1345717267
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.106474
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 06:56 AM, Hugh Dickins wrote:
> [PATCH] block: replace __getblk_slow misfix by grow_dev_page fix
> 
> Commit 91f68c89d8f3 ("block: fix infinite loop in __getblk_slow")
> is not good: a successful call to grow_buffers() cannot guarantee
> that the page won't be reclaimed before the immediate next call to
> __find_get_block(), which is why there was always a loop there.
> 
> Yesterday I got "EXT4-fs error (device loop0): __ext4_get_inode_loc:3595:
> inode #19278: block 664: comm cc1: unable to read itable block" on console,
> which pointed to this commit.
> 
> I've been trying to bisect for weeks, why kbuild-on-ext4-on-loop-on-tmpfs
> sometimes fails from a missing header file, under memory pressure on
> ppc G5.  I've never seen this on x86, and I've never seen it on 3.5-rc7
> itself, despite that commit being in there: bisection pointed to an
> irrelevant pinctrl merge, but hard to tell when failure takes between
> 18 minutes and 38 hours (but so far it's happened quicker on 3.6-rc2).
> 
> (I've since found such __ext4_get_inode_loc errors in /var/log/messages
> from previous weeks: why the message never appeared on console until
> yesterday morning is a mystery for another day.)
> 
> Revert 91f68c89d8f3, restoring __getblk_slow() to how it was (plus
> a checkpatch nitfix).  Simplify the interface between grow_buffers()
> and grow_dev_page(), and avoid the infinite loop beyond end of device
> by instead checking init_page_buffers()'s end_block there (I presume
> that's more efficient than a repeated call to blkdev_max_block()),
> returning -ENXIO to __getblk_slow() in that case.
> 
> And remove akpm's ten-year-old "__getblk() cannot fail ... weird"
> comment, but that is worrying: are all users of __getblk() really
> now prepared for a NULL bh beyond end of device, or will some oops??

Hugh, I tentatively applied this one, awaiting some test feedback before
pushing it upstream this cycle.


-- 
Jens Axboe

