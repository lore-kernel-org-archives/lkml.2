Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0DEXGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:06:15 -0400
Received: from dm-mail01.mozilla.org ([63.245.208.150]:58771 "EHLO
	dm-mail01.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab0DEXGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:06:10 -0400
X-Greylist: delayed 1386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2010 19:06:10 EDT
Message-ID: <4BBA6776.5060804@mozilla.com>
Date: Mon, 05 Apr 2010 15:43:02 -0700
From: Taras Glek <tglek@mozilla.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Downsides to madvise/fadvise(willneed) for application startup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I am working on improving Mozilla startup times. It turns out that page 
faults(caused by lack of cooperation between user/kernelspace) are the 
main cause of slow startup. I need some insights from someone who 
understands linux vm behavior.

Current Situation:
The dynamic linker mmap()s  executable and data sections of our 
executable but it doesn't call madvise().
By default page faults trigger 131072byte reads. To make matters worse, 
the compile-time linker + gcc lay out code in a manner that does not 
correspond to how the resulting executable will be executed(ie the 
layout is basically random). This means that during startup 15-40mb 
binaries are read in basically random fashion. Even if one orders the 
binary optimally, throughput is still suboptimal due to the puny readahead.

IO Hints:
Fortunately when one specifies madvise(WILLNEED) pagefaults trigger 2mb 
reads and a binary that tends to take 110 page faults(ie program stops 
execution and waits for disk) can be reduced down to 6. This has the 
potential to double application startup of large apps without any clear 
downsides. Suse ships their glibc with a dynamic linker patch to 
fadvise() dynamic libraries(not sure why they switched from doing 
madvise before).

I filed a glibc bug about this at 
http://sourceware.org/bugzilla/show_bug.cgi?id=11431 . Uli commented 
with his concern about wasting memory resources. What is the impact of 
madvise(WILLNEED) or the fadvise equivalent on systems under memory 
pressure? Does the kernel simply start ignoring these hints?

Also, once an application is started is it reasonable to keep it 
madvise(WILLNEED)ed or should the madvise flags be reset?

Perhaps the kernel could monitor the page-in patterns to increase the 
readahead sizes? This may already happen, I've noticed that a handful of 
pagefaults trigger > 131072bytes of IO, perhaps this just needs tweaking.

Thanks,
Taras Glek

PS. For more details on this issue see my blog at 
https://blog.mozilla.com/tglek/
