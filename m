Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2JBT74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:59:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab2JBT7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:59:54 -0400
Date: Wed, 3 Oct 2012 05:59:34 +1000
From: Dave Chinner <dchinner@redhat.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: Limit the number of requests in the bio list
Message-ID: <20121002195934.GA2657@devil.redhat.com>
References: <1348767205-17230-1-git-send-email-lczerner@redhat.com>
 <x49ipaukud8.fsf@segfault.boston.devel.redhat.com>
 <alpine.LFD.2.00.1210021042580.21903@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1210021042580.21903@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 10:52:05AM +0200, Lukáš Czerner wrote:
> On Mon, 1 Oct 2012, Jeff Moyer wrote:
> > Date: Mon, 01 Oct 2012 12:52:19 -0400
> > From: Jeff Moyer <jmoyer@redhat.com>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
> >     Dave Chinner <dchinner@redhat.com>
> > Subject: Re: [PATCH] loop: Limit the number of requests in the bio list
> > 
> > Lukas Czerner <lczerner@redhat.com> writes:
> > 
> > > Currently there is not limitation of number of requests in the loop bio
> > > list. This can lead into some nasty situations when the caller spawns
> > > tons of bio requests taking huge amount of memory. This is even more
> > > obvious with discard where blkdev_issue_discard() will submit all bios
> > > for the range and wait for them to finish afterwards. On really big loop
> > > devices this can lead to OOM situation as reported by Dave Chinner.
> > >
> > > With this patch we will wait in loop_make_request() if the number of
> > > bios in the loop bio list would exceed 'nr_requests' number of requests.
> > > We'll wake up the process as we process the bios form the list.
> > 
> > I think you might want to do something similar to what is done for
> > request_queues by implementing a congestion on and off threshold.  As
> > Jens writes in this commit (predating the conversion to git):
> 
> Right, I've had the same idea. However my first proof-of-concept
> worked quite well without this and my simple performance testing did
> not show any regression.
> 
> I've basically done just fstrim, and blkdiscard on huge loop device
> measuring time to finish and dd bs=4k throughput. None of those showed
> any performance regression. I've chosen those for being quite simple
> and supposedly issuing quite a lot of bios. Any better
> recommendation to test this ?
> 
> Also I am still unable to reproduce the problem Dave originally
> experienced and I was hoping that he can test whether this helps or
> not.
> 
> Dave could you give it a try please ? By creating huge (500T, 1000T,
> 1500T) loop device on machine with 2GB memory I was not able to reproduce
> that. Maybe it's that xfs punch hole implementation is so damn fast
> :). Please let me know.

Try a file with a few hundred thousand extents in it (preallocate
them). I found this while testing large block devices on loopback
devices, not with empty files.

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com
