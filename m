Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1BASqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:46:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:56406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1BASqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:46:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fo7Dl0gvp5eEGehJhmNBdY9MLnftSYn9UONZKUvfiGwaTsa4OSLu3fxaIGIdrBQ+dV
         TlBEh1WGZHvy71K+8UUQ==
MIME-Version: 1.0
In-Reply-To: <20110201100833.3219687e@jbarnes-desktop>
References: <849307$bc24ct@azsmga001.ch.intel.com>
	<1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LSU.2.00.1102010909270.1586@sister.anvils>
	<20110201094643.366bc073@jbarnes-desktop>
	<20110201100833.3219687e@jbarnes-desktop>
Date: Tue, 1 Feb 2011 10:46:17 -0800
Message-ID: <AANLkTim4kL9OjBDiQQ1MBfOCzThxmDonBic11N45NKxj@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
From: Hugh Dickins <hughd@google.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 10:08 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tue, 1 Feb 2011 09:46:43 -0800
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>
>> Are you still seeing underruns during normal activity?

Yes.  That is, I see the "pipe a underrun" messages when I set drm
debug 7: I'm unaware of any ill-effect from them, unless they are
indeed a factor in my unflushed text issue.

>> I wonder if the
>> ones you were seeing before were only reported at 60Hz due to vblank
>> interrupt processing.  If we failed to clear the underrun status, we'd
>> report one every time we got a vblank interrupt (since the underruns
>> don't report interrupts by themselves).

I was surprised that i915_driver_irq_handler  "Clear the PIPE(A|B)STAT
regs" writes back precisely the pipea_stats it reads in, I'd have
expected to clear something there (and did earlier experiment with
writing back 0: black screen at boot!).  But assumed the protocol is
such that it acknowledges the status bits by writing same back.

>>
>> If so, that may just be a red herring in this case.
>
> More random questions arise from the info provided:
>  - why are we ending up in the flip code at all?  fvwm shouldn't
>   trigger that path...

Right.  I haven't double-checked the logic, but I believe it's because
of bits set in the underrunning pipea_stats.  I did one time modify
the underrun message to print out pipea_stats, over five seconds most
(265) values were 0x80440207
(there were also 14 occurrences of 0x80440007, 5 of 0x80440004 and 3
of 0x80440204).

>  - what's with all the underruns?  it looks like we *do* ack those
>   flags as needed, so apparently they're valid, but they indicate a
>   serious problem with the display pipeline; maybe self-refresh
>   shouldn't be enabled on your system (that would increase memory
>   latency and potentially cause underruns), running with
>   i915.powersave=0 would disable that feature

I just tried i915.powersave=0 but the underruns still appeared.  I
then tried earlier kernels, and was surprised to find no underruns
with 2.6.34, 2.6.36: the underruns appeared with 2.6.37.

>
> The lack of text really does sound like a render cache flushing
> problem, but the other issues are worrying as well, and could be
> compounding things.  And the last time I saw the issue, it was related
> to compositing and required an X server fix.  But supposedly you're not
> using compositing, so...

That's right.

Hugh
