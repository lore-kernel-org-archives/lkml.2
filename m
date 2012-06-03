Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2FCNBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 09:01:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60451 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab2FCNBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 09:01:41 -0400
Message-ID: <4FCB602B.70907@zytor.com>
Date: Sun, 03 Jun 2012 06:01:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: why the decompressed procedure move kernel from address 0x100000(1M)
 to 0x1000000(16M) +x
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com> <4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com>
In-Reply-To: <87obp0bxdv.fsf@xmission.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2012 01:41 AM, Eric W. Biederman wrote:
> 
> Time wise copying the kernel probably takes a millisecond or less on
> modern hardware, so I don't think it is a particularly large concern.
> 

If your boot time budget is a second, getting rid of a millisecond helps.

> Looking at parse_elf I see two misfeatures.
> - parse_elf is short some memsets for the ELF sections that are larger
>   in memory than they are in the file data.
> - We don't return the entry point of the elf header and instead hard
>   code the beginning of the file data.
> 
> The oddest thing about parse_elf is what makes the copies parse_elf
> performs safe.  It just happens to be the case that because of the
> way ld lays out the file those copies turn into a single memmove 
> that just strips off the elf header and program header.
> 
> So it should be trivial to and perhaps even safer to decompress the
> program segments to their final destination.
> 
> Looking at the way the code is evolving, I suspect we should just give
> up overlapping compressed data and uncompressed data.  The elf header
> logic in theory allows the code in a more arbitrary order, and it
> doesn't look like anyone has done a worst case space analysis for
> anything except gzip.  The code works most of the time today but
> I do wonder if it is safe.
> 
> Additionally at the rate we are adding compression algorithms I don't
> believe that all of the compression alorigthms use the gzip footer that
> reports the uncompressed length of the file.  So I suspect it would be
> wise to get z_output_len from simply examining the uncompressed file
> that we feed to compression programs, aka vmlinux.bin.all-y
> 
> Perhaps I am wrong but I have the strongest feeling we are playing with
> fire and getting very lucky right now.

I think it might be even worse; on x86-64 we produce 2 MiB of completely
useless zero-padding after the header.  I have wanted to get rid of it
but I'm not sure if the ELF code is robust enough.  The code is a
hackwork and yes, should be replaced by decompressing into the
designated target areas.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

