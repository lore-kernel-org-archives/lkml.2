Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1CKO10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:27:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab1CKO1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:27:25 -0500
Message-ID: <4D7A314A.7000901@suse.cz>
Date: Fri, 11 Mar 2011 15:27:22 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc8
References: <AANLkTimG-1nSZw3P5q7LQbGmQch3ibsMPQ_duhAjhtQH@mail.gmail.com> <20110311092811.GA2079@polaris.bitmath.org>
In-Reply-To: <20110311092811.GA2079@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.3.2011 10:28, Henrik Rydberg wrote:
> On Mon, Mar 07, 2011 at 09:40:04PM -0800, Linus Torvalds wrote:
>> I would have been ok with releasing this as the final 38, but I'm
>> going to be partially unreachable for several days next week, so I
>> felt there was no point in opening the merge window yet.
>>
>> Also, we do have regressions. Some of them hopefully fixed here, but
>> it won't hurt to give it another week.
>>
>> Not everything here is strictly a regression: the i_nlink fixes are
>> long-standing races (very unlikely ones, admittedly), and the alpha
>> updates just convert the irq chip descriptions so that we can enable
>> GENERIC_HARDIRQS_NO_DEPRECATED on alpha too. But most everything is
>> pretty simple, and the diffstat is fairly flat with nothing huge that
>> stands out.
>>
>> 40% drivers, 35% arch updates (alpha and arm), with the rest being fs,
>> net and some block layer updates.
>>
>> So please keep testing,
> 
> Hi Linus,
> 
> I stumbled upon this problem when a dkms package install claimed to
> already have the latest version of a module, only it clearly did not.
> 
> It turns out the module srcversion is not unique. Doing a
> 
> cat /sys/module/*/srcversion | sort | uniq -c
> 
> shows something like this:
> 
> mainline>cat /sys/module/*/srcversion | sort | uniq -c
>       1 3EF20C25CC62BD750F4C3F3
>       1 41024DA8E830C7DAE171017
>       1 47AD35AE180473EB06EED32
>      19 533BB7E5866E52F63B9ACCB
>       1 598C709DDDAB55EB331379A
>       1 5AC5CB9DA8C242CBC76EEC0
>       1 AAD974CC23F320629986F38
>       2 AEBBDFD273E0316FD4E5D04
>       [...]
> 
> Bisecting leads to this commit
> 
> commit b7bd182176960fdd139486cadb9962b39f8a2b50
> Author: Michal Marek <mmarek@suse.cz>
> 
>     fixdep: Do not record dependency on the source file itself
> 
> which seems to be a change to the build system. Reverting followed by
> "make clean" cures the symptoms, and all module srcversions are again
> unique. Just doing make after the revert does not work, which seems
> reasonable. However, I can't even begin to imagine what the real
> reason is.
> 
> The patch below is what fixes it for me.
> 
> Thanks,
> Henrik
> 
> ---
> 
> From 0004c5bdc44c22646269756b0e0bbff1a7a30ac3 Mon Sep 17 00:00:00 2001
> From: Henrik Rydberg <rydberg@euromail.se>
> Date: Fri, 11 Mar 2011 09:54:33 +0100
> Subject: [PATCH] Revert "fixdep: Do not record dependency on the source file itself"
> 
> In 2.6.38-rc8, the module srcversion is not unique. Doing a
> 
> cat /sys/module/*/srcversion | sort | uniq -c
> 
> shows something like this:
> 
> mainline>cat /sys/module/*/srcversion | sort | uniq -c
>       1 3EF20C25CC62BD750F4C3F3
>       1 41024DA8E830C7DAE171017
>       1 47AD35AE180473EB06EED32
>      19 533BB7E5866E52F63B9ACCB
>       1 598C709DDDAB55EB331379A
>       1 5AC5CB9DA8C242CBC76EEC0
>       1 AAD974CC23F320629986F38
>       2 AEBBDFD273E0316FD4E5D04
>       [...]
> 
> Bisecting leads to this commit
> 
> commit b7bd182176960fdd139486cadb9962b39f8a2b50
> Author: Michal Marek <mmarek@suse.cz>
> 
>     fixdep: Do not record dependency on the source file itself
> 
> which is a change to the build system. Reverting followed by "make
> clean" cures the symptoms and all module srcversions are unique. Just
> doing make after the revert does not work.
> 
> I can't even begin to imagine what the real reason is.

The problem is that the code to calculate the checksums
(scripts/mod/sumversions.c) is parsing the *.cmd files to find out what
sources were used to build a given object file. One option is to let
fixdep record the *.[cS] separately, so that it does not confuse make,
but it available for modpost. I'll think about it a bit more.

Michal
