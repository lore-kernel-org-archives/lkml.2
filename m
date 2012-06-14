Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2FNM6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:58:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab2FNM6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:58:14 -0400
Message-ID: <4FD9DFCE.1070609@redhat.com>
Date: Thu, 14 Jun 2012 08:57:50 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, sjhill@mips.com, ralf@linux-mips.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: bugs in page colouring code
References: <20120613152936.363396d5@cuia.bos.redhat.com> <20120614103627.GA25940@aftab.osrc.amd.com>
In-Reply-To: <20120614103627.GA25940@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 06:36 AM, Borislav Petkov wrote:
> On Wed, Jun 13, 2012 at 03:29:36PM -0400, Rik van Riel wrote:

>> For one, there are separate kernel boot arguments to control whether
>> 32 and 64 bit processes need to have their addresses aligned for
>> page colouring.
>>
>> Do we really need that?
>
> Yes.

What do we need it for?

I can see wanting a big knob to disable page colouring
globally for both 32 and 64 bit processes, but why do
we need to control it separately?

I am not too keen on x86 keeping a slightly changed
private copy of arch_align_addr :)

> Mind you, this is only enabled on AMD F15h - all other x86 simply can't
> tweak it without code change.
>
>> Would it be a problem if I discarded that code, in order to get to one
>> common cache colouring implementation?
>
> Sorry, but, we'd like to keep it in.

What is it used for?

>> Secondly, MAP_FIXED never checks for page colouring alignment. I
>> assume the cache aliasing on AMD Bulldozer is merely a performance
>> issue, and we can simply ignore page colouring for MAP_FIXED?
>
> Right, AFAICR, MAP_FIXED is not generally used for shared libs (correct
> me if I'm wrong here, my memory is very fuzzy about it) and since we see
> the perf issue with shared libs, this was fine.

Try stracing /bin/mount one of these days. A whole bunch
of libraries are mapped with MAP_FIXED :)

However, I expect that on x86 many applications expect
MAP_FIXED to just work, and enforcing that would be
more trouble than it's worth.

>> That will be easy to get right in an architecture-independent
>> implementation.
>>
>>
>> A third issue is this:
>>
>>          if (!(current->flags&  PF_RANDOMIZE))
>>                  return addr;
>>
>> Do we really want to skip page colouring merely because the
>> application does not have PF_RANDOMIZE set?  What is this
>> conditional supposed to do?
>
> Linus said that without this we are probably breaking old userspace
> which can't stomach ASLR so we had to respect such userspace which
> clears that flag.

I wonder if that is true, since those userspace programs
probably run fine on ARM, MIPS and other architectures...

-- 
All rights reversed
