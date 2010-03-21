Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab0CUV1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:27:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab0CUV1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:27:13 -0400
Date: Sun, 21 Mar 2010 22:27:10 +0100 (CET)
From: "Ersek, Laszlo" <lacos@caesar.elte.hu>
To: linux-kernel@vger.kernel.org
cc: Antonio Diaz Diaz <ant_diaz@teleline.es>
Subject: better/faster kernel tarball compression
Message-ID: <Pine.LNX.4.64.1003211906000.8050@login01.caesar.elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear lkml Reader,

please allow me to spam you a bit with two compression programs.

I just downloaded the Linux 2.6.34-rc2 tarball:

5d8a6005280e54cd6e590916c9d7a900  linux-2.6.34-rc2.tar
570da63bf2c0c2e199f4a5616c15f52b  linux-2.6.34-rc2.tar.bz2

403804160 linux-2.6.34-rc2.tar
  67479563 linux-2.6.34-rc2.tar.bz2

I'd like to recommend two programs to compress the tarball. Allow me to 
list mostly the PRO arguments, as I'm sure you have the CON arguments 
ready.


(1) The program I recommend primarily is "plzip" [0]. Since kernel.org's 
energy consumption and upload costs must surely be staggering, you'll be 
delighted to know that the lzlib library compresses much better than the 
bzip2 library. Decompression is very fast. The lzip program [1] -- being 
the natural choice for decompression -- is very widely available (among 
others, in GNU/Linux distributions).

Now one counter-argument might be that lzip compresses much more slowly 
than bzip2. Obviously, Linus (or his trustee) has to compress the tarball 
only once, but users download and decompress the tarball thousands of 
times. Still, this alone would *not* suffice for me to spam you. I wish to 
make you aware of plzip, which is a parallel (multi-threaded) version of 
lzip. I figure Linus (or his trustee) couldn't care less if compression 
suddenly started to take eg. four times as long for him (or him/her). 
However, with plzip one can compress the tarball *both* faster and more 
efficiently, given enough cores.

Here's the thing. I recompressed the uncompressed tarball with bzip2, and 
then with plzip, using 16 worker threads. Note that the platform and 
kernel are a Sun Fire E25K and a Solaris 9. This should not deter you from 
trying it yourself, as my only reason not to execute this test on a 
GNU/Linux box is that I have no access to any Linux box with 16 cores. All 
tested binaries are 32bit (although all sources are 64bit-clean).

         Command being timed: "bzip2 --keep linux-2.6.34-rc2.tar"
         User time (seconds): 130.82
         System time (seconds): 1.68
         Percent of CPU this job got: 99%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 2:12.51

         Command being timed: "plzip.32 --threads=16 --keep linux-2.6.34-rc2.tar"
         User time (seconds): 1009.95
         System time (seconds): 13.55
         Percent of CPU this job got: 1145%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 1:29.33

403804160 linux-2.6.34-rc2.tar
  67479563 linux-2.6.34-rc2.tar.bz2
  58452531 linux-2.6.34-rc2.tar.lz

About 13% space was saved with plzip's default compression level (-6) 
against bzip2's best compression level (-9), and about 32% wall clock time 
was saved.

Decompression times to /dev/null follow. The .tar.lz file was decompressed 
with the single-threaded "minilzip" utility coming with lzlib. I also 
verified, in a separate test, that the .tar.lz file decompresses back to 
the original tarball (sanity check).

         Command being timed: "bzip2 -dc linux-2.6.34-rc2.tar.bz2"
         User time (seconds): 31.99
         System time (seconds): 0.35
         Percent of CPU this job got: 99%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 0:32.35

         Command being timed: "minilzip.32 -dc linux-2.6.34-rc2.tar.lz"
         User time (seconds): 16.18
         System time (seconds): 0.23
         Percent of CPU this job got: 99%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 0:16.43

Hence users would benefit not only from the smaller download, but the 
faster decompression too. (plzip supports multi-threaded decompression as 
well, but I didn't measure it for now.) AFAICT, multiple GNU/Linux 
distributions are considering an lzip-compressed package format, too.

Let me cite H. Peter Anvin's mail from Sep 21, 2006 [2]:

----v----
I have been holding out on implementing LZMA on kernel.org, because just 
as zip (deflate) didn't become common in the Unix world until an 
encapsulation format that handles things expected in the Unix world, e.g. 
streaming, was created (gzip), I don't think LZMA is going to be widely 
used until there is an "lzip" which does the same thing. I actually 
started the work of adding LZMA support to gzip, but then realized it 
would be better if a new encapsulation format with proper 64-bit support 
everywhere was created.
----^----

In reflection on the followups in said thread, please note that the file 
format is very simple, 64bit-clean and CRC-protected [3]. For streaming 
properties, see section (3) below.


(2) The program I recommend secondarily, *only* for the case if kernel.org 
admins are determined to stick with .bz2, is "lbzip2" [4]. I'll mention 
one drawback up-front (which I consider irrelevant, truth to be told): the 
compressed output looks like the concatenation of many bzip2 outputs. This 
is irrelevant for bunzip2, since the compressed output is still a 
perfectly valid bz2 file. Programs decompressing such files with libbz2 
will see multiple end-of-bzip2-stream conditions, however. I dare to 
recommend lbzip2 in order to shorten both compression and decompression 
times for whomever works with the .bz2 tarball. (Though see my disclaimer 
at the end.)

Compression times (32 bit binaries, 16 worker threads; re-pasting the 
(single-threaded) bzip2 result from above, and moving the downloaded 
.tar.bz2 under a subdirectory called "orig" before starting lbzip2):

         Command being timed: "bzip2 --keep linux-2.6.34-rc2.tar"
         User time (seconds): 130.82
         System time (seconds): 1.68
         Percent of CPU this job got: 99%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 2:12.51

         Command being timed: "lbzip2 -n 16 --keep linux-2.6.34-rc2.tar"
         User time (seconds): 144.08
         System time (seconds): 2.86
         Percent of CPU this job got: 1405%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 0:10.45

Sizes:

403804160 linux-2.6.34-rc2.tar
  67479563 orig/linux-2.6.34-rc2.tar.bz2
  67691446 linux-2.6.34-rc2.tar.bz2

For less than half a percent size sacrifice, we saved 92% wall clock time.

Both bzip2 and lbzip2 decompress both archives back to the original 
tarball (sanity check). Decompression times to /dev/null:

         Command being timed: "bzip2 -dc orig/linux-2.6.34-rc2.tar.bz2"
         User time (seconds): 29.81
         System time (seconds): 0.29
         Percent of CPU this job got: 99%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 0:30.12

         Command being timed: "bzip2 -dc linux-2.6.34-rc2.tar.bz2"
         User time (seconds): 31.57
         System time (seconds): 0.40
         Percent of CPU this job got: 99%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 0:31.97

         Command being timed: "lbzip2 -n 16 -dc orig/linux-2.6.34-rc2.tar.bz2"
         User time (seconds): 54.18
         System time (seconds): 2.37
         Percent of CPU this job got: 1259%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 0:04.48

         Command being timed: "lbzip2 -n 16 -dc linux-2.6.34-rc2.tar.bz2"
         User time (seconds): 53.62
         System time (seconds): 1.93
         Percent of CPU this job got: 1349%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 0:04.11

(Note that in the third case, lbzip2 parallelizes the decompression of the 
downloaded (single-stream) .tar.bz2 file too.)


(3) Both plzip and lbzip2 parallelize both compression and decompression 
from non-seekable input to non-seekable output (eg. pipes and SOCK_STREAM 
sockets). Additionally, they strive to follow the Utility Syntax 
Guidelines laid down in The Single UNIX(R) Specification, Version 2 [5].


+----------+
|DISCLAIMER|
+----------+

- I am the author of lbzip2. Therefore this mail qualifies as shameless 
self-promotion. I've got no problem with that; a rightful public 
humiliation will do me only good. I hope the subject pertains well enough 
to the payload so that nobody is lured into reading the mail spuriously.

- Originally, I forked plzip from lbzip2 under a different name ("llzip"). 
>From the start, it was based on lzlib, written by Antonio Diaz Diaz. (Just 
as lbzip2 is based on Julian Seward's libbz2. I'm not throwing around 
these names to gain credibility, I'm rather trying to give credit.) 
Shortly after the fork, Antonio Diaz Diaz has taken over llzip's 
maintenance as planned, and renamed it to plzip, much more fittingly. He 
has in effect completely rewritten it since then. He knew nothing of this 
email beforehand. The blame is entirely mine. Still, I'm convinced people 
would benefit if the kernel tarball switched to .lz compression.

- The quoted measurements were done on the "regina" supercomputer node of 
the NIIFI [6]. For a scaling test somewhat related to the ones listed 
above, see [7]. I'm currently preparing to repeat those tests with plzip.

(Disclaimer ends.)

Thank you very much for considering, and I apologize for being off-topic,
Laszlo Ersek

PS. As permitted by the lkml FAQ 3.3, I'm not subscribed to the list. 
Please keep me CC'd (and also poor victim Antonio). Thanks.


[0] http://www.nongnu.org/lzip/plzip.html
[1] http://www.nongnu.org/lzip/lzip.html
[2] http://lkml.indiana.edu/hypermail/linux/kernel/0609.2/1598.html
[3] http://www.nongnu.org/lzip/manual/plzip_manual.html#File-Format
[4] http://lacos.hu/
[5] http://www.opengroup.org/onlinepubs/007908799/xbd/utilconv.html#tag_009_002
[6] http://www.niif.hu/en/niif_institute/supercomputing_service
[7] http://lacos.hu/lbzip2-scaling/scaling.html
