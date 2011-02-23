Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1BWTue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:50:34 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:43171 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752926Ab1BWTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:50:34 -0500
Message-ID: <4D656504.5010504@tlinx.org>
Date: Wed, 23 Feb 2011 11:50:28 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Fwd: write 'O_DIRECT' file w/odd amount of data: desirable result?
X-Stationery: 0.4.10
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Bounced due to 8-bit in header of 'to' address...hmmm
lkml email system can't handle 8-bit character names?


-------- Original Message --------
Subject: 	Re: write 'O_DIRECT' file w/odd amount of data: desirable result?
Date: 	Wed, 23 Feb 2011 10:04:30 -0800
From: 	Linda A. Walsh <lkml@tlinx.org>
To: 	Pádraig Brady <P@draigBrady.com>
CC: 	LKML <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
References: 	<4D648D7D.7040500@tlinx.org> <4D64E2BB.7010000@draigBrady.com>



FWIW -- xfs-oss, included as 'last line' was of minor interest; known bug on
this kernel?:
Linux Ishtar 2.6.35.7-T610-Vanilla-1 #2 SMP PREEMPT Mon Oct 11 17:19:41 
PDT 2010 x86_64 x86_64 x86_64 GNU/Linux

Pádraig Brady wrote:
> On 23/02/11 04:30, Linda Walsh wrote:
>   
>> I understand, somewhat, what is happening. I have two different utils, 
>> 'dd' and mbuffer both of which have a 'direct' option to write to disk. 
>> mbuffer was from my distro with a direct added, which is
>>
>> I'm not sure if it's truncating the write to the lower bound of the 
>> sector size or the file-allocation-unit size but from a {dump|cat},
>> piped into {cat, dd mbuffer}, the output sizes are:
>> file              size       delta
>> -------------   ----------   ----
>> dumptest.cat    5776419696
>> dumptest.dd     5776343040   76656   
>> dumptest.mbuff  5368709120   407710576
>> - params:
>> dd of=dumptest.dd bs=512M oflag=direct
>> mbuffer -b 5 -s 512m -direct -f -o dumptest.mbuff
>> ----
>> I'm not aware of what either did, but no doubt neither expected an
>> error in the final write and didn't handle the results properly.
>> Vanilla kernel 2.6.35-7 x86_64 (SMP PREMPT)
>>     
> Note dd will turn off O_DIRECT for the last write
> if it's less than the block size.
> http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=5929322c
>   
------

FWIW, 'dd' is from 'coreutils-7.1-3.2.x86_64' (from the suse 11.2 release):

While I used dump (xfsdump to be precise) to produce my initial output
to mbuffer, it was the error message at the end which caught my attention.
Prior I had a tried a series of filters after the initial mem-to-mem
buffer performed by 'dd', then later 'mbuffer'.  The filters were
successively lower-io compress options over the years as disk and
network speeds rose and cpu-compression became the choke-point.

(xfsdump -b 512m )|(initially 'dd', later, 'mbuffer' )| \
        (su -f -m backup -c "$umask $um;${Compress:-} ${Compress_ops:-} \
               >${Dmpfile}${Compress_ext}" )
---
Eventually I wanted to get rid of the final filter step altogether and
have that 'buffer' statement after the 'dump' go direct to disk, then
later "--direct" to disk...

   It was adding the 'DIRECT' flag then that I noticed mbuffer's error.

   My first debug step was to go for a shorter dump file (the one that
failed on was over 3TB and took over 3h to reproduce).  Then I substituted
'cat' as that final filter and ended up with my 'testfile' I used for later
tests for 'mbuffer' and 'dd'.

NOTE:

I tried using the 'iflag=fullblock' as you recommend and it made the problem
'consistent' with the output of 'mbuffer', i.e. it transfered less data
and the truncation was consistent with a 512M divisor, indicating it was
'cat' default record output size that was causing the difference. 
If I use 'dd' to read the base file (no direct i/o) I get consistent results
with 'mbuffer' and 'dd':


Input: DumpTest.out: 5776419696

Output file sizes are as reported by 'dd', with 'test1' giving the closest
answer (short record line concatenated with ' & '):

test1> cat DumpTest.out |dd of=dumptest.dd-fb oflag=direct 
bs=512M          
dd: writing `dumptest.dd-fb': Invalid argument
0+7346 records in & 0+7345 records out
5776343040 bytes (5.8 GB) copied, 12.4361 s, 464 MB/s


test2> cat DumpTest.out |dd of=dumptest.dd+fb oflag=direct bs=512M 
iflag=fullblock
dd: writing `dumptest.dd+fb': Invalid argument
10+1 records in & 10+0 records out
5368709120 bytes (5.4 GB) copied, 12.581 s, 427 MB/s

test3> dd if=DumpTest.out bs=512M |dd of=dumptest2.dd+fb oflag=direct 
bs=512M iflag=fullblock               
10+1 records in & 10+1 records out
5776419696 bytes (5.8 GB) copieddd: writing `dumptest2.dd+fb', 11.6493 
s, 496 MB/s
: Invalid argument
10+1 records in & 10+0 records out
5368709120 bytes (5.4 GB) copied, 11.6513 s, 461 MB/s

test4> dd if=DumpTest.out bs=512M |dd of=dumptest2.dd-fb oflag=direct 
bs=512M
10+1 records in & 10+1 records out
dd: writing `dumptest2.dd-fb'5776419696 bytes (5.8 GB) copied, 11.4503 
s, 504 MB/s
: Invalid argument
10+1 records in & 10+0 records out
5368709120 bytes (5.4 GB) copied, 11.4503 s, 469 MB/s

---
I've tried significantly shorter files and NOT had this problem
(record size=64k, and 2 files one @ 57k and one at 64+57k). Both copied 
fine.
Something to do with large file buffers.

Of *SIGNIFICANT* note.  In trying to create an empty file of the size
used, from scratch, using 'xfs_mkfile', I got an error:

>  xfs_mkfile 5776419696 testfile
pwrite64: Invalid argument

---
I'm having problems generating new kernels (will ask in separate
message) so will have to fix those before moving ahead...






