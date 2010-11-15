Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab0KOTZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:25:39 -0500
Received: from netnation.com ([204.174.223.2]:50392 "EHLO peace.netnation.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0KOTZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:25:38 -0500
X-Greylist: delayed 1045 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2010 14:25:38 EST
Date: Mon, 15 Nov 2010 11:08:08 -0800
From: Simon Kirby <sim@hostway.ca>
To: "J.H." <warthog9@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jaxboe@fusionio.com,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: More XFS resource starvation?
Message-ID: <20101115190808.GA17387@hostway.ca>
References: <4CE17C4E.7010206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE17C4E.7010206@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 10:30:38AM -0800, J.H. wrote:

> So apparently I'm having fun tripping over all kinds of bugs lately.
> I've seen this a couple of times now on the box in question.  Usually
> happens after a few days, or after particularly heavy rsync traffic on
> the box.
> 
> http://pastebin.osuosl.org/36014
> 
> Christoph seemed to think it's a memory exhaustion problem, so I've
> included the /proc/meminfo and as you can see there's plenty of memory
> around on the system.
> 
> Loads have, expectedly, climbed currently around 1250.05 but growing slowly.
> 
> Quick overview of the underlying storage:
> 
> xfs -> md (raid 0) -+--> P812 hardware raid6 (cciss driver)
>                     |
>                     +--> P812 hardware raid6 (cciss driver)
> 
> This is running on an HP DL380 G7.
> 
> I saw this both on an older 2.6.30.10-105.2.23.fc11.x86_64, and
> currently on 2.6.34.7-61.fc13.x86_64 (both being Fedora stock kernels)
> 
> I have not seen this on a very similar DL380 G6, with the same storage
> setup and it is currently running the 2.6.30 kernel from above.
> 
> Christoph suggest increasing the nr_request values for each of the
> underlying devices, but this didn't seem to change anything
> significantly on the system.
> 
> Anyone have any ideas on what's going on?

What does this show?

	iostat -x -k 1

In particular, "avgqu-sz" aka "average queue size" would be non-zero if
there are requests pending.  If r/s and w/s are zero over a long time
with the queue size being non-zero, the issuing of commands to the
hardware raid controller is stuck for some reason.

Since your Dirty and Writeback is pretty high, it sounds like this is the
issue.  Not sure where to go from there.

Simon-
