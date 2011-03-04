Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281Ab1CDWH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:07:57 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:55364 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760159Ab1CDWH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:07:56 -0500
X-ASG-Debug-ID: 1299276475-03d6a54f630bd00001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D7162B7.20101@fusionio.com>
Date: Fri, 4 Mar 2011 23:07:51 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-8-git-send-email-jaxboe@fusionio.com> <20110304040907.GB32404@redhat.com> <4D70E78D.9000402@fusionio.com> <20110304132551.GA2407@infradead.org> <4D70EBB9.302@fusionio.com> <20110304140814.GA28953@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 07/10] fs: make generic file read/write functions plug
In-Reply-To: <20110304140814.GA28953@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299276475
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57062
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-04 15:08, hch@infradead.org wrote:
> On Fri, Mar 04, 2011 at 02:40:09PM +0100, Jens Axboe wrote:
>>> REQ_META?  Maybe we should finally agree what it does and decide if it
>>> should be used consistenly.  Especially the priority over REQ_SYNC in
>>> cfq still looks somewhat odd, as does the totally inconsequent use.
>>
>> For me it was primarily a blktrace hint, but yes it does have prio boost
>> properties in CFQ as well. I'm inclined to let those stay the way they
>> are. Not sure we can properly call it anything outside of a hint that
>> these IO have slightly higher priority, at least I would not want to
>> lock the IO scheduler into to something more concrete than that.
> 
> The problem is that these two meanings are inherently conflicting.
> Metadata updates do not have to be synchronous or have any kind of
> priority.  In fact for XFS they normall aren't, and I'd be surprised it
> the same isn't true for other journalled filesystems.
> 
> Priority metadata goes into the log, which for XFS is always written as
> a FLUSH+FUA bio.  Writeback of metadata happens asynchronously in the
> background, and only becomes a priority if the journal is full and we'll
> need to make space available.
> 
> So giving plain REQ_META a priority boost makes it impossible to use it
> for the blktrace annotation use case.  One could only apply the boost
> for the REQ_SYNC + REQ_META combination, but even that seems rather
> hackish to me.  I'd really love to see numbers where the additional
> boost of REQ_META over REQ_SYNC makes any difference.

Seems only gfs2 actually sets the flag now. So how about we remove the
prio boost for meta data and just retain it as an information attribute?

If there's a need for this slight boosts, it is probably best done
explicitly being signalled from the caller.

-- 
Jens Axboe

