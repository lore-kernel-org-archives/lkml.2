Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2B1DDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 22:03:55 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33240 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab2B1DDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 22:03:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of john.r.moser@gmail.com designates 10.52.23.97 as permitted sender) smtp.mail=john.r.moser@gmail.com; dkim=pass header.i=john.r.moser@gmail.com
Message-ID: <4F4C4400.6070302@gmail.com>
Date: Mon, 27 Feb 2012 22:03:28 -0500
From: John Moser <john.r.moser@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120224 Thunderbird/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: What do you do when swap is faster than disk?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got into a weird situation today.

I limited my system RAM and used zram to make a swap device, then put up 
memory pressure.  What happened was I got 50MB of disk cache going on 
and an -extremely- slow system with lots and lots and LOTS of hard disk 
activity.

I found that around 130MB the system was fine, and around 200MB it was 
extremely fast.  I also found that it's extremely difficult to make the 
OS keep 200MB of disk cache around on 2GB of RAM when you have 600MB 
swapped out.

That raises some questions about if the tunables for this are adequate.  
I can't very well set vm.swappiness to 150, and even at 100 it's not 
really helpful.  I mean when you have more than a quarter of your RAM in 
swap, the tunable seems to have almost no impact.

It's also come to my mind that the kernel could, possibly, attempt some 
speed testing against the devices and determine how fast they are.  This 
could be as simple as worrying about it under pressure, splitting up 
swap among all swap devices and working out throughput and latency.  
Then prioritize them such that, under pressure, very old data in a very 
fast swap device gets swapped out to a slower swap device.

Disk cache could be ranked against the whole thing too to decide just 
how important disk cache is being--and how much time is being spent 
mucking about with re-loading flushed cache versus swapping.  You could 
keep some information about what was in RAM before aside, and push it 
out as it gets old--a particular area of cache 40MB wide was flushed, 
there's a 16 byte structure somewhere in RAM that makes note of that.  
After more time has been spent flushing swap than it takes to read in 
that 40MB, drop it.  If it's read back in, make note that too much disk 
cache flushing is happening and not enough swapping is going on.

This is more complex than it sounds, though, because you also have to 
consider reading things into cache.  Eventually you have to invalidate 
disk cache to make room for more cache, after all.  That or swap out 
even more.  So yes I understand this is hard.

Just thought I'd mention that the problem seems to be more complex than 
it's credited for at the moment.  (In my test case, simply locking 200MB 
for disk cache would have been fine... much better than what actually 
happened!)
