Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab2GAUkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 16:40:24 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:46116 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2GAUkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 16:40:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, hacklu <embedway.linux@gmail.com>,
        linux-kernel@vger.kernel.org
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com>
	<4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com>
	<4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com>
	<877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com>
	<4FF06DF4.4000006@zytor.com> <87wr2nsbvi.fsf@xmission.com>
	<4FF0769F.8090105@zytor.com> <87sjdbsb0v.fsf@xmission.com>
	<4FF07E66.2020706@zytor.com> <87d34fs914.fsf@xmission.com>
	<4FF085B1.6070604@zytor.com> <87a9zj9w43.fsf@xmission.com>
	<4FF098E2.3040307@zytor.com> <87sjdb8f0m.fsf@xmission.com>
	<4FF0A399.8070207@zytor.com>
Date: Sun, 01 Jul 2012 13:40:05 -0700
In-Reply-To: <4FF0A399.8070207@zytor.com> (H. Peter Anvin's message of "Sun,
	01 Jul 2012 12:23:05 -0700")
Message-ID: <87txxr6wre.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Ea4XxnM+O5uqA+fZGgHUx3rITcnMLvHs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1648]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] x86, boot: Optimize the elf header handling.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 07/01/2012 12:20 PM, Eric W. Biederman wrote:
>> 
>> Grumble Grumble.
>> 
>> If I force a 2M alignment, poffsets and paddrs align and my previous
>> patches work.  Although I don't expect that to be more than a testing
>> hack.
>> 
>> Meanwhile if I force a 4K max page size for most purposes things look
>> better from a file offset perspective.  But the data segment is now less
>> aligned in the file than it is in memory and my patches don't work.
>> 
>> Sigh.
>> 
>> I feel like I have stumbled into pandoras box.
>> 
>
> Last I looked at this we didn't actually have a general PHDR parser...
> are you running into its limitations?

Sort of.  It was my premise that we should not need a general PHDR
parser, or even a parser at all , especially since a general PHDR parser
is hard to fit into the existing bzImage protocol.  So far emperically
except when dealing with the weird percpu section we don't need a 
general PHDR parser.

There is just enough weirdness that it makes sense to have a
phdr parser that just verifies it doesn't need to do anything.

So I have tracked down part of the crazyness.
CONFIG_RODATA actually uses 2MB alignment, making
-z max_page_size=4096 a bit questionable.

In practice I'm not concerned with a few extra zero's in the file
because giant runs of zeros compress very well.

I am going to play with the percpu section a bit more and see if
I can remove the need for magic to get it's p_offset and p_paddr
to be aligned in the file, as that comes for free with everything
else.

Hmm.  I think I see why the percpu section is problematic.  We have to
specify AT on all of our sections and the usual formula is
".section : AT(.section - LOAD_OFFSET)".  Unfortunately that doesn't
work when we we set the virtual address to zero.

I will play with it a little more and see if I can come up with
something interesting.

Eric
