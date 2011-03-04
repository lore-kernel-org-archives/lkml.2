Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab1CDNkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:40:17 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:34502 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab1CDNkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:40:15 -0500
X-ASG-Debug-ID: 1299246013-01de284cf8047b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D70EBB9.302@fusionio.com>
Date: Fri, 4 Mar 2011 14:40:09 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-8-git-send-email-jaxboe@fusionio.com> <20110304040907.GB32404@redhat.com> <4D70E78D.9000402@fusionio.com> <20110304132551.GA2407@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 07/10] fs: make generic file read/write functions plug
In-Reply-To: <20110304132551.GA2407@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299246013
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.60
X-Barracuda-Spam-Status: No, SCORE=0.60 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=MARKETING_SUBJECT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57029
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.60 MARKETING_SUBJECT      Subject contains popular marketing words
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-04 14:25, hch@infradead.org wrote:
> On Fri, Mar 04, 2011 at 02:22:21PM +0100, Jens Axboe wrote:
>> Good catch, we need to modify that logic. If the task is currently
>> plugged, it should not dispatch until blk_finish_plug() is called.
>> Essentially SYNC will not control dispatch. Will allow us to clean up
>> that logic, too.
> 
> <broken-record-mode>
> 
> Time to use the opportunity to sort out what the various bio/request
> flags mean.
> 
> REQ_UNPLUG should simply go away with the explicit stack plugging.
> What's left for REQ_SYNC?  It'll control if the request goes into the
> sync bucket and some cfq tweaks.  We should clearly document what it
> does.

Yes, REQ_UNPLUG goes away, it has no meaning anymore since the plugging
is explicitly done by the caller.

With REQ_SYNC, lets make the sync/async thing apply to both reads and
writes. Right now reads are inherently sync, writes are sometimes
(O_DIRECT). So lets stop making it more murky by mixing up READ and
SYNC.

> REQ_META?  Maybe we should finally agree what it does and decide if it
> should be used consistenly.  Especially the priority over REQ_SYNC in
> cfq still looks somewhat odd, as does the totally inconsequent use.

For me it was primarily a blktrace hint, but yes it does have prio boost
properties in CFQ as well. I'm inclined to let those stay the way they
are. Not sure we can properly call it anything outside of a hint that
these IO have slightly higher priority, at least I would not want to
lock the IO scheduler into to something more concrete than that.

-- 
Jens Axboe

