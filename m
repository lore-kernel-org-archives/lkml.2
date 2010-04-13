Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0DMKL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 06:11:57 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:50448 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0DMKL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:11:56 -0400
Message-ID: <4BC44365.9010108@lumino.de>
Date: Tue, 13 Apr 2010 12:11:49 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de> <201004091714.04990.arnd@arndb.de> <4BC2EEBD.3070504@lumino.de> <201004121702.35237.arnd@arndb.de>
In-Reply-To: <201004121702.35237.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 05:02 PM, Arnd Bergmann wrote:
>
> if you cannot implement a 'test-and-set', 'exchange' or
> 'store-conditional' instruction, I don't think any custom instructions
> will help you.
>   
That is not the point. Custom instructions easily can implement
thread-safe and SMP safe atomic read-modify-write user-land-enabled
operations such as "test-and-set", "exchange" or "inc" (I don't think
that "store conditional" would be necessary). But they can't work if the
same data can be accessed by other (non-custom) CPU instructions, as the
custom-instructions would necessarily bypass the cache and the MMU while
the normal CPU instructions would use both (and as all this is done with
performance in mind disabling or invalidating the cache is out of
question and in user-land such operations are impossible, anyway. This
is why the idea of a dedicated "atomic RAM" has been developed (which
requires the arch-independent Kernel and Library code to access all
would-be "atomic" locations _only_ through arch-depending macros
<including allocating and freeing these memory locations>, even though
for "standard" archs, the resulting ASM code would (hopefully, nearly
everywhere) stay the same as it is).
> You can probably implement an atomic function in a VDSO though, without
> any CPU extensions, I think this has been discussed for blackfin
> before. The idea is to let the kernel check if the instruction pointer
> is in the critical section of the VDSO while returning to user space.
> If it is, the kernel can jump back to the caller of that function
> instead of the function itself, and indicate failure so the user can
> retry.
>   
Right., I already mentioned this "Atomic Region" way to implement an
"atomic operation" workaround for non-SMP systems in the first message
of this thread.

Of course it would be advantageous to have this method for NIOS, as
well, as it can be implemented without "hardware" support and without
modifications of the arch-independent Kernel and library code. But it
will not work with SMP and it will introduces an (even if supposedly not
huge) overhead with any interrupt.

A hardware implementation would avoid this overhead, would allow for
atomic SMP user-land operations and could be the base of implementing an
SMP Kernel (even though with NIOS/SMP other issues <like
cache-synchronization> might need to be solved additionally).

-Michael
