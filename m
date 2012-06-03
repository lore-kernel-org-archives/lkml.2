Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2FCIlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 04:41:46 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:52100 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2FCIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 04:41:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com>
	<4FCAD590.8000506@zytor.com>
Date: Sun, 03 Jun 2012 02:41:32 -0600
In-Reply-To: <4FCAD590.8000506@zytor.com> (H. Peter Anvin's message of "Sat,
	02 Jun 2012 20:10:08 -0700")
Message-ID: <87obp0bxdv.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+/kLZpqm4JLSf5CiXz27NRn6VFrjtdENY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3214]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: why the decompressed procedure move kernel from address 0x100000(1M) to 0x1000000(16M) +x
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 06/02/2012 04:48 PM, Eric W. Biederman wrote:
> On 06/02/2012 04:48 PM, Eric W. Biederman wrote:
>> hacklu <embedway.linux@gmail.com> writes:
>> 
>>> hi all,
>>> recently, I got some puzzle when I read source code of the system boot. I need
>>> some help.
>>>
>>> at the end of src/arch/x86/boot/header.S,  kernel jump to 0x100000(where is the
>>> src/arch/x86/boot/compressed/head_32.S).
>>> in __this__ head_32.S, I found the kernel is move to 0x1000000(mostly is to
>>> here) +x. the x distance is used for decompressed buf.  must leave some distance
>>> for decompressing without overlap.
>>>
>>> after the move, kernel is decompressed at 0x1000000(16m). and jump to it.
>>>
>>> so why not decompressed kernel at 0x100000(1M) to 0x1000000(16m) directly
>>> without moving?
>>>
>>> is the move necessary?
>> 
>> The move is nececcessary if we are doing the decompression in place.
>> Without a move it is hard to tell if there are going to be overlapping
>> address problems.  The move is cheap so there is no apparent reason
>> to optimize it away.
>> 
>
> Well, right now we do two copies (one before decompression, and one
> after while parsing the ELF payload.)  It would be nice to get rid of at
> least one but preferably both (when possible.)
>
> Boot time does matter, although this isn't a huge amount of time, it is
> something that can be shaved off relatively cheaply.

Interesting.  I have been out of the loop for a bit and had not noticed
the ELF payload change.  It is really sad to say that I have missed
a feature like that for 4 years.

Time wise copying the kernel probably takes a millisecond or less on
modern hardware, so I don't think it is a particularly large concern.

Looking at parse_elf I see two misfeatures.
- parse_elf is short some memsets for the ELF sections that are larger
  in memory than they are in the file data.
- We don't return the entry point of the elf header and instead hard
  code the beginning of the file data.

The oddest thing about parse_elf is what makes the copies parse_elf
performs safe.  It just happens to be the case that because of the
way ld lays out the file those copies turn into a single memmove 
that just strips off the elf header and program header.

So it should be trivial to and perhaps even safer to decompress the
program segments to their final destination.

Looking at the way the code is evolving, I suspect we should just give
up overlapping compressed data and uncompressed data.  The elf header
logic in theory allows the code in a more arbitrary order, and it
doesn't look like anyone has done a worst case space analysis for
anything except gzip.  The code works most of the time today but
I do wonder if it is safe.

Additionally at the rate we are adding compression algorithms I don't
believe that all of the compression alorigthms use the gzip footer that
reports the uncompressed length of the file.  So I suspect it would be
wise to get z_output_len from simply examining the uncompressed file
that we feed to compression programs, aka vmlinux.bin.all-y

Perhaps I am wrong but I have the strongest feeling we are playing with
fire and getting very lucky right now.

Eric
