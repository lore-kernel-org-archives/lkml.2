Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0KGL7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:59:30 -0500
Received: from home.kolivas.org ([59.167.196.135]:36019 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab0KGL72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:59:28 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: Linux kernel compression with lrzip
Date: Sun, 7 Nov 2010 22:59:25 +1100
User-Agent: KMail/1.13.5 (Linux/2.6.36-ck1; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
X-Length: 5137
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011072259.25625.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Let's do this backwards. Data first.


tarball of every 3 point linux kernel from 2.6.0 to 2.6.36

9748285440 linux-2.6.0-2.6.36.tar


compressed file

136516013 linux-2.6.0-2.6.36.tar.lrz


Compressed size: 1.4%


Compression time:

00:19:22.086


Decompression time:

00:03:02.564


http://lrzip.kolivas.org


Now for the introduction

Lrzip is a compression application I've been working on that is based on the 
original excellent application rzip by Andrew Tridgell. Rzip worked by having 
a preprocessor stage with a massive compression window up to 900MB for long 
distance redundancy compaction and then compressing the data with bz2. Lrzip 
was a project I began based on rzip which tried to extend the initial 
compression window beyond 900MB and to use lzma as the back end for the 2nd 
stage compression. The idea was that as file sizes got bigger, and machines 
had more ram, it would keep getting more and more useful.

After many iterations on lrzip, I've been able to significantly expand on this 
idea and make it address 64 bit sized files, ram sizes, and bigger windows. 
Previously the limit was based on available ram and how much of the file being 
compressed could be mmapped. The current version (0.5.2) is able to use 
unlimited sized compression windows for the preprocessor stage using two 
sliding mmap windows I invented to match the hash search algorithm of rzip 
which can go beyond the size of the ram available. Basically the larger the 
file, and the more redundant information in the file, the more the compression 
is you can achieve.

Anyway the relevance of this to kernel folk is that the linux kernel is a 
perfect test case for long distance redundancy when multiple kernel trees are 
compressed.

So here's the lowdown. All of these results were conducted on a 3GHz quad core 
64 bit machine with 8GB ram on a 160GB SSD so hard drive speed is a 
(relatively) insignificant part of the times.


Starting with linux kernel 2.6.36

413511680 linux-2.6.36.tar
70277083 linux-2.6.36.tar.bz2
59905365 linux-2.6.36.tar.lrz

Compression:
Compression Ratio: 6.903. Average Compression Speed:  1.582MB/s.           
Total time: 00:04:08.896

Decompression:
Average DeCompression Speed: 17.130MB/s
Total time: 00:00:22.557


So trying my best to show off what lrzip is good at, I grabbed every 3 point 
2.6 linux kernel release. That's every release from 2.6.0 to 2.6.36 as a 
tarball, not as patches. It came to a 9.1GB file. Now each kernel tree is 
going to be repeating an -awful- lot of data, but given that they have gotten 
progressively larger, and span gigabytes, normal compression doesn't really 
offer much. This is where the rzip compaction stage over the full size of the 
file comes in handy. The more redundant information there is over large 
distances, the better. [insert joke about the linux kernel and redundant 
information here]. (-MU means Maximum Unlimited; maximum ram and unlimited 
window size).


9748285440 linux-2.6.0-2.6.36.tar

lrzip -MU linux-2.6.0-2.6.36.tar

136516013 linux-2.6.0-2.6.36.tar.lrz

Compression:
Compression Ratio: 71.408. Average Compression Speed:  8.000MB/s.
Total time: 00:19:22.086

That's 9.1GB to 130MB (1.4%) in 20 minutes.

Decompression:
Average DeCompression Speed: 51.359MB/s
Total time: 00:03:02.564


At 130MB, it's small enough for me to even offer the entire 3 point stable 
release for download from my piddly little server. So here's the file, if 
anyone wanted to confirm its validity, or just to download them all :)

http://ck.kolivas.org/linux-2.6.0-2.6.36.tar.lrz


lrzip also has an lzo and zpaq backend for those who want to extract every 
last drop of compression out of it at the cost of a bit more time. zpaq is 
EIGHT TIMES slower during the backend compression phase compared to lzma 
whereas lzo is almost instant after the rzip phase. Note that this file loses 
most of its size during the preprocessor stage so it doesn't end up taking 8x 
longer to compress with zpaq:


lrzip -MUz linux-2.6.0-2.6.36.tar

121021214 linux-2.6.0-2.6.36.tar.lrz

Compression:
Compression Ratio: 80.550. Average Compression Speed:  3.041MB/s.
Total time: 00:50:56.537

That's 9.1GB to 115MB (1.2%) in 51 mins.

Decompression time is about 52 minutes (yes it's longer than compression!)


Now, I am NOT proposing lrzip be used as a drop in replacement for the 
existing compression formats in use. It does work on stdin/stdout but 
inefficiently except on compression from stdin. It does not have any archive 
facilities beyond compressing the one file, so it comes with an lrztar and 
lrzuntar wrapper to do basic directory archiving. It uses a LOT of ram, and 
although it has the ability to use an unlimited sized compression windows 
unconstrained by ram, the bigger the discrepancy between the file size and the 
ram, the slower it will get. (Decompression typically uses 10x less ram than 
compression).

Nevertheless, I home some people with lots of similar files lying around, like 
kernel hackers, will hopefully find it a useful tool, as will people with 
database dumps and the like. I also wonder if features of this compression 
approach might be helpful for other projects that deal with huge amounts of 
data and have large memory requirements. When I mentioned the sliding mmap 
feature online, git using lots of memory during its compression phase was 
mentioned, so perhaps there are other uses for the sliding mmap idea as a way 
of reducing memory usage. There's some documentation of it in the code in 
rzip.c and I wrote briefly about it in my blog: http://ck-hack.blogspot.com


Enjoy!
-- 
-ck
