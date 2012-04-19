Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2DSRyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:54:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2DSRye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:54:34 -0400
Message-ID: <4F905144.7000205@zytor.com>
Date: Thu, 19 Apr 2012 10:54:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
References: <1334794610-5546-1-git-send-email-hpa@zytor.com> <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab> <4F904541.2030200@zytor.com>
In-Reply-To: <4F904541.2030200@zytor.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 10:02 AM, H. Peter Anvin wrote:
> On 04/19/2012 02:26 AM, Borislav Petkov wrote:
>>
>> Also, move the sorting of the main exception table earlier in the boot
>> process now that we handle exceptions in the early IDT handler too.
>>
> 
> I would much rather use David Daney's patchset to sort the exception
> table at compile time:
> 
> 	https://lkml.org/lkml/2011/11/18/427
> 
> ... and I would be *even happier* with an O(1) hash (which pretty much
> *have* to be constructed at compile time.)
> 

The sorting is easier infrastructure-wise, since it can be done
in-place.  The O(1) hash needs additional space for the hash table
itself (the actual table can still be stashed where the compiler
generates it.)

The hash table generator I have posted at:

http://www.zytor.com/~hpa/phash/

Generally needs ~3.2 bytes per hash table entry, rounded up to a power
of two.  The rounding up is for performance.  The easiest way to do this
is probably to let the linker create a zero-filled section of the proper
size (since the linker knows the final size of the __ex_table section,
and the linker script can do at least a modicum of arithmetic) and then
use a tool to patch in the hash table auxilliary data.

	-hpa


P.S. Another modification which was talked about in the past and there
even were patches for was to make the exception table entries relative
to the start of the kernel, so we don't need two relocations per entry
for x86-32 and twice the amount of data that we can actually use for
x86-64.  As I recall we tried those patches and there was some bug that
never got resolved.

This is obviously a precondition for doing the O(1) hash, since the O(1)
hash can't be relocated once generated.
