Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2JPTYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:24:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33565 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2JPTYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:24:50 -0400
Message-ID: <507DB47E.5090003@mit.edu>
Date: Tue, 16 Oct 2012 12:24:46 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: wilson self <wself00@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: VDSO gettimeofday() x86_64 linux 3.2
References: <CAAZUjxCvK0QnwnZP_FBiO2JM1rMoEA3HLjKAcYD14cxdGWyg4Q@mail.gmail.com>
In-Reply-To: <CAAZUjxCvK0QnwnZP_FBiO2JM1rMoEA3HLjKAcYD14cxdGWyg4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 11:09 AM, wilson self wrote:
> I noticed recently that my get time of day calls are quite a bit
> slower than I would have expected; and it would see that a likely
> cause is that they are not going via vdso, but rather a system call.
> 
> In older kernels there was kernel.vsyscall64 parameter to enable them,
> but this seems to be gone in later kernel releases.  What config
> option or parameter might I be missing that could cause gettimeofday()
> to use the fallback methods?

That option is gone because it's treated as unconditionally true.  What
does /sys/devices/system/clocksource/clocksource0/current_clocksource
say?  The usual cause of this problem is a clocksource other than tsc or
hpet.  hpet is amazingly slow, though, and arguably the hpet vdso code
could be deleted because the syscall overhead is the least of your
worries if you're using the hpet for timing.

(Also, if you're doing the call yourself instead of using libc, make
sure you're using the vdso and not the old vsyscall.  The vsyscall (call
direct to 0xffffffffff600000) is the slowest possible way to read the
time -- it's several times slower than the syscall on my box.  This is
mostly intentional.

--Andy
