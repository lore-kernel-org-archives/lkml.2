Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1DAUFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 16:05:03 -0400
Received: from mail.cariden.com ([204.2.128.131]:33835 "EHLO mail.cariden.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252Ab1DAUFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 16:05:01 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Apr 2011 16:05:01 EDT
From: Charles Samuels <charles@cariden.com>
Organization: Cariden Technologies
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Queuing of disk writes
Date: Fri, 1 Apr 2011 12:59:53 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <201104011259.53936.charles@cariden.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel hackers,

I have an application that is writing large amounts of very fragmented data to 
harddrives. That is, I could write megabytes of data in blocks of a few bytes 
scattered around a multi-gigabyte file.

Obviously, doing this causes the harddrive to seek a lot and takes a while. 
>From what I understand, if I allow linux to cache the writes, it will fill up 
the kernel's write cache, and then consequently the disk drive's DMA queue. As 
a result of that, the harddrive can pick the correct order to do these writes, 
significantly reducing seek times.

However, there's a major cost in allowing the write cache to fill: fsync takes 
*ages*. What's worse is that while fsync is proceeding, it seems *all* disk 
operations in the OS are blocked. This is really terrible for performance of 
my application: my application might want to do some reads (i.e. from another 
thread) from the disk preempting the fsync temporarily. It's also really 
terrible for me, because then my workstation becomes unresponsive for several 
minutes.

My general question is how to mitigate this. Is it possible to get a signal 
for when a file is out of the disk cache. Or can I ask linux approximately how 
much data is in the write queue for that specific file, and just do a sleep()-
loop checking until it goes down to something managable at which point I do 
the fsync? Or, does aio support this scenario well, and if so, from what 
version of Linux? (I've determined that there are some scenarios in which it 
does, but it still requires O_DIRECT, apparently, which is weird considering 
how I've heard Linux kernel hackers feel about that particular flag).

And yes, I *know* fsync is a poor method to determine if data is actually 
committed to something non-volatile. :)

Thanks for the help,

Charles

