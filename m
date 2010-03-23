Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0CWXVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:21:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab0CWXVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:21:12 -0400
Date: Wed, 24 Mar 2010 00:21:07 +0100 (CET)
From: "Ersek, Laszlo" <lacos@caesar.elte.hu>
To: linux-kernel@vger.kernel.org
Subject: Re: better/faster kernel tarball compression
In-Reply-To: <jo2k77-9sp.ln1@chipmunk.wormnet.eu>
Message-ID: <Pine.LNX.4.64.1003232248310.16224@login01.caesar.elte.hu>
References: <4BA741D7.9020008@wpkg.org> <jo2k77-9sp.ln1@chipmunk.wormnet.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0232]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010, Alexander Clouter wrote:

> For some time there has been a multi-threaded bzip2 called pbzip2[1], 
> for some time; hell even Debian has it :)
>
> I have no idea why the original poster is trying to say how "all teh 
> awesome" his code is being faster, well 'duh' it is using all the cores 
> on $BOX rather than just a single one.

I asked explicitly to be CC'd. I saw somewhere that more than 200 messages 
are posted to lkml each single day, so excuse me for not subscribing to 
it. Of course nobody needs to give a damn about what I ask for, but then 
it's difficult for me to respond.

You didn't quote where I said 'how "all teh awesome" my code is being 
faster'.

Anyway, please download a bz2 kernel tarball, and decompress it with 
pbzip2 and then with lbzip2. Eg. on a quad-core AMD or similar. Then 
please re-read the last sentence of section (2) of my previous mail.

Or please check my site which I linked to previously, and look at some 
test reports and their analysis on the debian-mentors mailing list (link 
on my site, likewise).

I could go on about how the multiple workers decompressor of lbzip2 is 
designed, or about its signal handling, but since you decided upfront that 
I'm an attention whoring idiot, I won't struggle. I'll paste at the end 
one such test report I generated now on a 2x2 core Opteron 275, with the 
test file being "linux-2.6.33.1.tar".

I'd call lbzip2 useful especially if kernel.org continued to offer the 
full tarballs in the current .bz2 format. ("I dare to recommend lbzip2 in 
order to shorten both compression and decompression times for whomever 
works with the .bz2 tarball.") See [0] for example.


> I would be interested in comparisons against pbzip2 and the amusingly
> named pigz[2]...plus a bunch of memory use comparisons, my AR7 board
> only has 16MB of RAM :)

lbzip2's malloc() peaks were like this during the correctness (not the 
performance) test phase -- not that you'd care:

- single-threadded decompression of bzip2-compressed file:  9,955,696
- same but with four worker threads:                       71,308,096
- single-threaded decompression of lbzip2-compressed file:  9,955,696
- same but with four worker threads:                       65,079,712
- compression with four worker threads:                    49,049,265

(lbzip2 has a compile-time configurable "backlog factor", sort of the 
maximum number of buffered input chunks per thread. It is 4 per default 
which I deem an okay tradeoff between memory usage and presumable, 
unexpected bursts in (de)compression performance due to "inhomogeneous" 
input data.)


Additionally [1],

----v----
How is it pronounced?

I'm glad you asked. It is pronounced "pig-zee". It is /not/ pronounced 
like the plural of pig.
----^----

lacos

[0] http://permalink.gmane.org/gmane.linux.kernel/949924
[1] http://zlib.net/pigz/


(Note that "7za" denotes the (C language) bzip2 module of p7zip -- option 
"-tbzip2" -- which is *not* based on libbz2. Furthermore, "ws" means 
"workers stalled", ie. the ratio of unfruitful condvar predicate 
evaluations in worker threads, each resulting in the given worker going to 
sleep until the next condvar broadcast.)

+-----------------------------------------------------------------------
|Version
|                  |bzip2                                          1.0.5
|                  |lbzip2                                          0.23
|                  |pbzip2                                         1.1.0
|                  |7za                                             9.04
+-----------------------------------------------------------------------
|File size [B]
|                  |original                                   395089920
|                  |bzip2                                       66219178
|                  |lbzip2                                      66488716
|                  |pbzip2                                      66491545
|                  |7za                                         66230645
+-----------------------------------------------------------------------
|Compr. size [%]
|                  |lbzip2:bzip2                                  100.40
|                  |pbzip2:bzip2                                  100.41
|                  |7za:bzip2                                     100.01
+-----------------------------------------------------------------------
|Compr. time [s]
|                  +----------------------------------------------------
|                  |from regf
|                  |            |bzip2                            113.59
|                  |            |lbzip2                            31.52
|                  |            |pbzip2                            31.55
|                  |            |7za                               52.22
|                  +----------------------------------------------------
|                  |from pipe
|                  |            |bzip2                            116.95
|                  |            |lbzip2                            31.44
|                  |            |pbzip2                            31.31
|                  |            |7za                               49.72
+-----------------------------------------------------------------------
|Compr. speed [%]
|                  +----------------------------------------------------
|                  |from regf
|                  |            |lbzip2:bzip2                     360.37
|                  |            |pbzip2:bzip2                     360.03
|                  |            |7za:bzip2                        217.52
|                  +----------------------------------------------------
|                  |from pipe
|                  |            |lbzip2:bzip2                     371.97
|                  |            |pbzip2:bzip2                     373.52
|                  |            |7za:bzip2                        235.21
+-----------------------------------------------------------------------
|"lbzip2" ws [%]
|                  |from regf                                       1.11
|                  |from pipe                                       1.55
+-----------------------------------------------------------------------
|Decompr. time [s]
|                  +----------------------------------------------------
|                  |from regf
|                  |            +---------------------------------------
|                  |            |from bzip2
|                  |            |            |by bzip2             22.21
|                  |            |            |by lbzip2             8.87
|                  |            |            |by pbzip2            41.76
|                  |            |            |by 7za               14.83
|                  |            +---------------------------------------
|                  |            |from lbzip2
|                  |            |            |by bzip2             23.46
|                  |            |            |by lbzip2             8.84
|                  |            |            |by pbzip2             7.58
|                  |            |            |by 7za               22.81
|                  |            +---------------------------------------
|                  |            |from pbzip2
|                  |            |            |by bzip2             23.47
|                  |            |            |by lbzip2             8.79
|                  |            |            |by pbzip2             7.52
|                  |            |            |by 7za               24.40
|                  |            +---------------------------------------
|                  |            |from 7za
|                  |            |            |by bzip2             22.24
|                  |            |            |by lbzip2             8.90
|                  |            |            |by pbzip2            51.07
|                  |            |            |by 7za               14.92
|                  +----------------------------------------------------
|                  |from pipe
|                  |            +---------------------------------------
|                  |            |from bzip2
|                  |            |            |by bzip2             22.38
|                  |            |            |by lbzip2             8.87
|                  |            |            |by pbzip2            51.27
|                  |            |            |by 7za                0.00
|                  |            +---------------------------------------
|                  |            |from lbzip2
|                  |            |            |by bzip2             23.65
|                  |            |            |by lbzip2             8.78
|                  |            |            |by pbzip2             7.53
|                  |            |            |by 7za                0.00
|                  |            +---------------------------------------
|                  |            |from pbzip2
|                  |            |            |by bzip2             28.65
|                  |            |            |by lbzip2             8.85
|                  |            |            |by pbzip2             7.57
|                  |            |            |by 7za                0.00
|                  |            +---------------------------------------
|                  |            |from 7za
|                  |            |            |by bzip2             27.53
|                  |            |            |by lbzip2             8.88
|                  |            |            |by pbzip2            41.91
|                  |            |            |by 7za                0.00
+-----------------------------------------------------------------------
|Decompr. speed [%]
|                  +----------------------------------------------------
|                  |from regf
|                  |            +---------------------------------------
|                  |            |from bzip2
|                  |            |            |lbzip2:bzip2        250.39
|                  |            |            |pbzip2:bzip2         53.18
|                  |            |            |7za:bzip2           149.76
|                  |            +---------------------------------------
|                  |            |from lbzip2
|                  |            |            |lbzip2:bzip2        265.38
|                  |            |            |pbzip2:bzip2        309.49
|                  |            |            |7za:bzip2           102.84
|                  |            +---------------------------------------
|                  |            |from pbzip2
|                  |            |            |lbzip2:bzip2        267.00
|                  |            |            |pbzip2:bzip2        312.10
|                  |            |            |7za:bzip2            96.18
|                  |            +---------------------------------------
|                  |            |from 7za
|                  |            |            |lbzip2:bzip2        249.88
|                  |            |            |pbzip2:bzip2         43.54
|                  |            |            |7za:bzip2           149.06
|                  +----------------------------------------------------
|                  |from pipe
|                  |            +---------------------------------------
|                  |            |from bzip2
|                  |            |            |lbzip2:bzip2        252.31
|                  |            |            |pbzip2:bzip2         43.65
|                  |            |            |7za:bzip2
|                  |            +---------------------------------------
|                  |            |from lbzip2
|                  |            |            |lbzip2:bzip2        269.36
|                  |            |            |pbzip2:bzip2        314.07
|                  |            |            |7za:bzip2
|                  |            +---------------------------------------
|                  |            |from pbzip2
|                  |            |            |lbzip2:bzip2        323.72
|                  |            |            |pbzip2:bzip2        378.46
|                  |            |            |7za:bzip2
|                  |            +---------------------------------------
|                  |            |from 7za
|                  |            |            |lbzip2:bzip2        310.02
|                  |            |            |pbzip2:bzip2         65.68
|                  |            |            |7za:bzip2
+-----------------------------------------------------------------------
|"lbzip2 -d" ws [%]
|                  +----------------------------------------------------
|                  |from regf
|                  |            |from bzip2                         1.58
|                  |            |from lbzip2                        1.00
|                  |            |from pbzip2                        1.49
|                  |            |from 7za                           1.23
|                  +----------------------------------------------------
|                  |from pipe
|                  |            |from bzip2                         1.58
|                  |            |from lbzip2                        1.16
|                  |            |from pbzip2                         .83
|                  |            |from 7za                           1.58

(Report ends.)
