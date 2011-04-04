Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab1DDRuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:50:15 -0400
Received: from mail.cariden.com ([204.2.128.131]:31294 "EHLO mail.cariden.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab1DDRuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:50:13 -0400
From: Charles Samuels <charles@cariden.com>
Organization: Cariden Technologies
To: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Queuing of disk writes
Date: Mon, 4 Apr 2011 10:50:12 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201104011259.53936.charles@cariden.com> <20110404020235.GA4706@thunk.org>
In-Reply-To: <20110404020235.GA4706@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <201104041050.12731.charles@cariden.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the reply.

On Sunday, April 03, 2011 7:02:35 pm Ted Ts'o wrote:
> On Fri, Apr 01, 2011 at 12:59:53PM -0700, Charles Samuels wrote:
> > I have an application that is writing large amounts of very
> > fragmented data to harddrives. That is, I could write megabytes of
> > data in blocks of a few bytes scattered around a multi-gigabyte
> > file.
> 
> Doctor, doctor, it hurts when I do this....  any way you can avoid
> doing this?  What is your application doing at the high level.
Not really, I need the on-disk data organized in this pattern, so that the 
reads are optimized nicely. It's a database application.

> 
> > Obviously, doing this causes the harddrive to seek a lot and takes a
> > while.  From what I understand, if I allow linux to cache the
> > writes, it will fill up the kernel's write cache, and then
> > consequently the disk drive's DMA queue. As a result of that, the
> > harddrive can pick the correct order to do these writes,
> > significantly reducing seek times.
> 
> This is one way to avoid some of the seeks, yes.

What's another way? Other than not doing it :)

> Who or what is calling fsync()?  Is it being called by your
> application because you want to initiate writeout?  Or is it being
> called by some completely unrelated process?

It's being called by my own process. When fsync finishes, I update another file 
with some offset counters, fsync that, and with some luck, my writes are 
transactional.

> If it is being called by the application, one thing you can do is to
> use the Linux-specific system call sync_file_range().  You can use
> this to do asynchronous data flushes of the file, and control which
> range of bytes are written out, which can also help avoid flooding the
> disk with too many write requests.

What would be good use of sync_file_range? It looks pretty useful, but I don't 
know how to make good use of it.

For example, SYNC_FILE_RANGE_WRITE, wouldn't linux start this pretty much 
immediately? And wouldn't I really not want to give it a suggestion for what 
order it does it in?

Would calling sync_file_range with a flag that allows blocking have a 
performance benefit compared to fsync? Specifically, can I expect Linux to not 
totally block all reads and writes to other files?

Charles
