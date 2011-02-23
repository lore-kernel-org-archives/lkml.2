Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1BWKid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:38:33 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:19305 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753482Ab1BWKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:38:31 -0500
Message-ID: <4D64E2BB.7010000@draigBrady.com>
Date: Wed, 23 Feb 2011 10:34:35 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: write 'O_DIRECT' file w/odd amount of data: desirable result?
References: <4D648D7D.7040500@tlinx.org>
In-Reply-To: <4D648D7D.7040500@tlinx.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/11 04:30, Linda Walsh wrote:
> 
> 
> 
> I understand, somewhat, what is happening.
> I have two different utils, 'dd' and mbuffer both of
> which have a 'direct' option to write to disk.
> mbuffer was from my distro with a direct added, which
> is
> 
> I'm not sure if it's truncating the write to the
> lower bound of the sector size or the file-allocation-unit size
> but from a dump, piped into {cat, dd mbuffer}, the
> output sizes are:
> 
> file              size       delta
> -------------   ----------   ----
> dumptest.cat    5776419696
> dumptest.dd     5776343040   76656   
> dumptest.mbuff  5368709120   407710576
> 
> params:
> 
> dd of=dumptest.dd bs=512M oflag=direct
> mbuffer -b 5 -s 512m --direct -f -o dumptest.mbuff
> 
> original file size MOD 512M = 407710576 (answer from mbuff).
> 
> The disk it is being written to is a RAID with a span
> size of 640k (64k io*10 data disks) and formatted to
> indicated that with 'xfs' (stripe-unit=64k stripe=width=10).
> 
> This gives a 'coincidental' (??) interpretation for
> the output from 'dd', where the original file size MOD
> 640K = 76656  (the amount 'dd' is short).
> 
> Was that a coincidence or a fluke?
> Why didn't 'mbuffer' have the same shortfall -- it's was
> only related to it's 512m buffer size.
> 
> In any event, shouldn't the kernel yield the correct answer
> in either case?  It would be consistent with the processor it
> was natively developed on, the x86, where a misaligned memory
> access doesn't cause a fault at the user level, but is handled
> correctly, with a slight penalty to speed for the unaligned
> data parts.
> 
> Shouldn't the linux kernel behave similarly?
> Note, that the mbuffer program indicated an error
> (which didn't help the 'dump' program that had already exited
> with what it thought was a 'success'), though a bit
> cryptic:
> buffer: error: outputThread: error writing to dumptest.mbuff at offset
> 0x140000000: Invalid argument
> 
> summary: 5509 MByte in  8.4 sec - average of  658 MB/s
> mbuffer: warning: error during output to dumptest.mbuff: Invalid argument
> 
> dd indicated no warning or error.
> 
> ----
> I'm not aware of what either did, but no doubt neither
> expected an error in the final write and didn't handle the results
> properly.
> 
> However, wouldn't it be a good thing for linux to do 'the right thing'
> and successfully the last partial write (whichever is the case!), even
> if it has to be internally buffered and slightly slowed?  Seems
> correctness of the function should be given preference over the
> adherence to some limitation where possible.
> Software should be as forgiving and tolerant and 'err' to the side of
> least harm -- which I'd argue is getting the data to the disk, NOT
> generating some 'abnormal end' (ABEND) condition that the software can't
> handle.
> I'd think of it like a page-fault of a record not in memory.  The
> remainder of the I/O record is a 'zero-filled' buffer that fills in the
> remainder of the sector while the size of the field is set to the size
> written. ??
> 
> Vanilla kernel 2.6.35-7 x86_64 (SMP PREMPT)

Note dd will turn off O_DIRECT for the last write
if it's less than the block size.
http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=5929322c

Note also you mentioned that you piped from dump to dd.
For dd reading from a pipe I strongly suggest you specify iflag=fullblock

If there is still an issue, it seems from the above that the kernel is throwing
away data and not indicating this through the last non O_DIRECT write().

cheers,
Pádraig.
