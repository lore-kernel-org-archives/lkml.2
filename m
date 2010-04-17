Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab0DQDHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 23:07:12 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:45426 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758615Ab0DQDHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 23:07:10 -0400
Date: Sat, 17 Apr 2010 13:06:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, suleiman@google.com
Subject: Re: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if
 current is kswapd
Message-ID: <20100417030648.GH2493@dastard>
References: <20100415013436.GO2493@dastard>
 <20100415130212.D16E.A69D9226@jp.fujitsu.com>
 <20100415131106.D174.A69D9226@jp.fujitsu.com>
 <64BE60A8-EEF9-4AC6-AF0A-0ED3CB544726@freebsd.org>
 <20100415093214.GV2493@dastard>
 <85DB7083-8E78-4884-9E76-5BD803C530EF@freebsd.org>
 <20100415233339.GW2493@dastard>
 <20100416105002.191adeb1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416105002.191adeb1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 10:50:02AM +0100, Alan Cox wrote:
> > No. If you are doing full disk seeks between random chunks, then you
> > still lose a large amount of throughput. e.g. if the seek time is
> > 10ms and your IO time is 10ms for each 4k page, then increasing the
> > size ito 64k makes it 10ms seek and 12ms for the IO. We might increase
> > throughput but we are still limited to 100 IOs per second. We've
> > gone from 400kB/s to 6MB/s, but that's still an order of magnitude
> > short of the 100MB/s full size IOs with little in way of seeks
> > between them will acheive on the same spindle...
> 
> The usual armwaving numbers for ops/sec for an ATA disk are in the 200
> ops/sec range so that seems horribly credible.

Yeah, in my experience 7200rpm SATA will get you 200 ops/s when you
are doing really small seeks as the typical minimum seek time is
around 4-5ms. Average seek time, however, is usually in the range of
10ms, because full head sweep + spindle rotation seeks take in the
order of 15ms.

Hence small random IO tends to result in seek times nearer the
average seek time than the minimum, so that's what i tend to use for
determining the number of ops/s a disk will sustain.

> But then I've never quite understood why our anonymous paging isn't
> sorting stuff as best it can and then using the drive as a log structure
> with in memory metadata so it can stream the pages onto disk. Read
> performance is goig to be similar (maybe better if you have a log tidy
> when idle), write ought to be far better.

Sounds like a worthy project for someone to sink their teeth into.
Lots of people would like to have a system that can page out at
hundreds of megabytes a second....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
