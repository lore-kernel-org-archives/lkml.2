Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2JPTde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:33:34 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63443 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab2JPTdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:33:31 -0400
MIME-Version: 1.0
In-Reply-To: <507DB47E.5090003@mit.edu>
References: <CAAZUjxCvK0QnwnZP_FBiO2JM1rMoEA3HLjKAcYD14cxdGWyg4Q@mail.gmail.com>
	<507DB47E.5090003@mit.edu>
Date: Tue, 16 Oct 2012 14:33:30 -0500
Message-ID: <CAAZUjxAPAUD50asniJVNgD3X=vM_d=GPKJ5C2eVGo6r4HUKYLQ@mail.gmail.com>
Subject: Re: VDSO gettimeofday() x86_64 linux 3.2
From: wilson self <wself00@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current_clocksource is tsc.

the entire source of the test application:
---
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>

int main() {
      struct timeval tim;
      gettimeofday(&tim, NULL);
      printf("%.6lf seconds\n", tim.tv_sec+tim.tv_usec/1000000.0);
}
---
nothing fancy going on here.

thanks for the help.

On Tue, Oct 16, 2012 at 2:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 10/16/2012 11:09 AM, wilson self wrote:
>> I noticed recently that my get time of day calls are quite a bit
>> slower than I would have expected; and it would see that a likely
>> cause is that they are not going via vdso, but rather a system call.
>>
>> In older kernels there was kernel.vsyscall64 parameter to enable them,
>> but this seems to be gone in later kernel releases.  What config
>> option or parameter might I be missing that could cause gettimeofday()
>> to use the fallback methods?
>
> That option is gone because it's treated as unconditionally true.  What
> does /sys/devices/system/clocksource/clocksource0/current_clocksource
> say?  The usual cause of this problem is a clocksource other than tsc or
> hpet.  hpet is amazingly slow, though, and arguably the hpet vdso code
> could be deleted because the syscall overhead is the least of your
> worries if you're using the hpet for timing.
>
> (Also, if you're doing the call yourself instead of using libc, make
> sure you're using the vdso and not the old vsyscall.  The vsyscall (call
> direct to 0xffffffffff600000) is the slowest possible way to read the
> time -- it's several times slower than the syscall on my box.  This is
> mostly intentional.
>
> --Andy
