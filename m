Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1DDNxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:53:53 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55665 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1DDNxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:53:52 -0400
Date: Sun, 3 Apr 2011 22:02:35 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Charles Samuels <charles@cariden.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Queuing of disk writes
Message-ID: <20110404020235.GA4706@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Charles Samuels <charles@cariden.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201104011259.53936.charles@cariden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104011259.53936.charles@cariden.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 12:59:53PM -0700, Charles Samuels wrote:
> 
> I have an application that is writing large amounts of very
> fragmented data to harddrives. That is, I could write megabytes of
> data in blocks of a few bytes scattered around a multi-gigabyte
> file.

Doctor, doctor, it hurts when I do this....  any way you can avoid
doing this?  What is your application doing at the high level.

> Obviously, doing this causes the harddrive to seek a lot and takes a
> while.  From what I understand, if I allow linux to cache the
> writes, it will fill up the kernel's write cache, and then
> consequently the disk drive's DMA queue. As a result of that, the
> harddrive can pick the correct order to do these writes,
> significantly reducing seek times.

This is one way to avoid some of the seeks, yes.

> However, there's a major cost in allowing the write cache to fill:
> fsync takes *ages*. What's worse is that while fsync is proceeding,
> it seems *all* disk operations in the OS are blocked. This is really
> terrible for performance of my application: my application might
> want to do some reads (i.e. from another thread) from the disk
> preempting the fsync temporarily. It's also really terrible for me,
> because then my workstation becomes unresponsive for several
> minutes.

Who or what is calling fsync()?  Is it being called by your
application because you want to initiate writeout?  Or is it being
called by some completely unrelated process?

If it is being called by the application, one thing you can do is to
use the Linux-specific system call sync_file_range().  You can use
this to do asynchronous data flushes of the file, and control which
range of bytes are written out, which can also help avoid flooding the
disk with too many write requests.

If the fsync() is being called by some other process, then yeah, you
have a problem.  What I'd suggest is using a separate partition and
file system for this application of yours which needs to write
megabytes and megabytes of data at random locations in this
multi-gigabyte file of yours....

						- Ted
