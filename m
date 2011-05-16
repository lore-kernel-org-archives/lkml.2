Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1EPPv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:51:57 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:48425 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415Ab1EPPv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:51:56 -0400
X-AuditID: 1209190c-b7c65ae00000117c-ba-4dd148225883
Message-ID: <4DD14814.8080305@mit.edu>
Date: Mon, 16 May 2011 11:51:48 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org> <1305329059-2017-5-git-send-email-andi@firstfloor.org> <20110514065752.GA8827@elte.hu> <20110514163424.GU6008@one.firstfloor.org>
In-Reply-To: <20110514163424.GU6008@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsUixCmqravkcdHX4MsFE4vjEywt5qxfw2Zx
	5Np3dovf93ayWVzeNYfNYsulZlaLzZumMls86nvL7sDhcavtD7PH/J0fGT3enTvH7nFixm8W
	j3knAz22/3bz+LxJLoA9issmJTUnsyy1SN8ugSvj7Le5TAXvxStuPMtpYHwv1MXIwSEhYCKx
	sE+7i5ETyBSTuHBvPVsXIxeHkMA+Ronrm86xQzgbGCXu7DvOCFIlJPCWSeLuERUQm1dATeL4
	tYPsIDaLgKrEhTmrWUFsNgEViY6lD5hAbFGBSolJP3ewQtQLSpyc+YQFZLEIUM3xU3wg85kF
	5jFJ7Ni9CWy+sICexK7nP6GuOMIosblrIdgCTgFzif73r5hBmpkFrCW+7S4CCTMLyEtsfzuH
	eQKj4CwkK2YhVM1CUrWAkXkVo2xKbpVubmJmTnFqsm5xcmJeXmqRrqFebmaJXmpK6SZGcIRI
	8uxgfHNQ6RCjAAejEg9vmOtFXyHWxLLiytxDjJIcTEqivAYgIb6k/JTKjMTijPii0pzU4kOM
	EhzMSiK8Z+ov+ArxpiRWVqUW5cOkpDlYlMR5Z0iq+woJpCeWpGanphakFsFkZTg4lCR4492B
	hgoWpaanVqRl5pQgpJk4OEGG8wANrwSp4S0uSMwtzkyHyJ9i1OXY83z/AUYhlrz8vFQpcd5k
	kCIBkKKM0jy4ObDE9opRHOgtYd4CkCoeYFKEm/QKaAkT0JJVp0A+KC5JREhJNTDWvZDiWB/a
	UKuto8/nef+Zlnf/osn340+0PpPa+7SAX1x2iTRvtmTxsxZ+z7Z3jTVsT1ZPWnO+LOfUkz2s
	V+t7ts7dUvf97sfQRrnOz3snLL+7ebPrlsQd5r96zf7ESocUzTkotmm7iecKrx8Fupz1Zyfl
	HTRdcXL9PpYTRvwMS52M/UV9UrKVWIozEg21mIuKEwEZMH6KRwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2011 12:34 PM, Andi Kleen wrote:
>> What glibc does (opening /proc/stat) is rather stupid, but i think your syscall
>
> I don't think it has any other choice today. So if anything is "stupid"
> it is the kernel for not providing efficient interfaces for this.
>
>> Note that these are mostly constant or semi-constant values that are updated
>> very rarely:
>
> That's not true. Most of them are dynamic. Take a look at the patch.
> Also several of those have changed recently.
>
>> If glibc is stupid and reads /proc/stat to receive something it could cache or
>> mmap() itself then hey, did you consider fixing glibc or creating a sane libc?
> Caching doesn't help when you have a workload that exec()s a lot.
> Also some of these values can change at runtime.
>
>> If we *really* want to offer kernel help for these values even then your
>> solution is still wrong: then the proper solution would be to define a standard
>> *data* structure and map it as a vsyscall *data* page - essentially a
>> kernel-guaranteed data mmap(), with no extra syscall needed!
>
> That's quite complicted because several of those are dynamically computed
> based on other values. Sometimes they are also not tied to the mm_struct -- like
> the vsyscall is. For example some of the rlimits are per task, not VM.
> Basically your proposal doesn't interact well with clone().
>
> Even if we ignored that semantic problem it would need another writable page
> per task because the values cannot be shared.
>
> Also I never liked the idea of having more writable pages per task,
> It increases the memory footprint of a single process more. Given a 4K
> page is not a lot, but lots of 4K pages add up. Some workloads like
> to have lots of small processes and I think that's a valuable use
> case Linux should stay lean and efficient at.
>
> [OK in theory one could do COW for the page and share it but that would
> get really complicated]
>
> I also don't think it's THAT performance critical to justify the vsyscall.
> The simple syscall is already orders of magnitude faster than /proc, and
> seems to solve the performance problems we've seen completely.
>
> It's also simple and straight forward and simple to userstand and maintain.
> I doubt any of that would apply to a vsyscall solution.
>
> I don't think the additional effort for a vsyscall would be worth
> it at this point, unless there's some concrete example that would
> justify it. Even then it wouldn't work for some of the values.

You could also add a vsyscall function and have that function pull the 
values from vvar data.  It would be very fast (i.e. almost as fast as 
mmaping some data) and it would be more portable.

If you built it on top of the vdso cleanup in my rdtsc patches, it would 
be dead simple, too.  (Think three or four lines of code and no linker 
hackery).

>
> Also a vsyscall doesn't help on non x86 anyways.
>

Add one?  x86-32 at least would benefit a lot.  (I'm not volunteering 
right now...)

--Andy
