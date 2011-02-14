Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1BNRmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:42:00 -0500
Received: from smtp-out.google.com ([74.125.121.67]:44441 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1BNRl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:41:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C0Ra4jmUzSDf5oxAtvPJe6FojUS6ZyUAUNyl7iRgcPP7CRVxLj9Mvhvmh/TEWWbW9J
         FXGjBUrbswY9saFApeCQ==
MIME-Version: 1.0
In-Reply-To: <87E55E65-72FF-462C-8BD3-84C367021DB7@tuebingen.mpg.de>
References: <849307$bc24ct@azsmga001.ch.intel.com>
	<1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LSU.2.00.1102010909270.1586@sister.anvils>
	<20110201094643.366bc073@jbarnes-desktop>
	<20110201100833.3219687e@jbarnes-desktop>
	<AANLkTim4kL9OjBDiQQ1MBfOCzThxmDonBic11N45NKxj@mail.gmail.com>
	<20110201113238.60b33ff9@jbarnes-desktop>
	<AANLkTikwfHd6t95-jhbXCy1ciW3OV+HVYVikZNs5LHfz@mail.gmail.com>
	<20110202091838.5efaa660@jbarnes-desktop>
	<alpine.LSU.2.00.1102081132160.1591@sister.anvils>
	<87E55E65-72FF-462C-8BD3-84C367021DB7@tuebingen.mpg.de>
Date: Mon, 14 Feb 2011 09:41:53 -0800
Message-ID: <AANLkTi=JD4zwo9aW7iQW-==dQM9W7NHyq12uOPBqGYSB@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
From: Hugh Dickins <hughd@google.com>
To: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:21 AM, Mario Kleiner
<mario.kleiner@tuebingen.mpg.de> wrote:
> On Feb 8, 2011, at 8:52 PM, Hugh Dickins wrote:
>>  It appears that the
>> underruns, while mysterious and worrisome, have litte or nothing to do
>> with the unflushed text problem which is making 2.6.38-rc unusable.
>>
>> For the moment I've gone back to my patch moving intel_display.c's
>> do_gettimeofday() call into the block where it's needed; though that
>> too disappointed eventually before.  It all rather stinks of something
>> uninitialized somewhere.
>
> Just a remark, the do_gettimeofday() call is placed where it is (Before the
> spin_lock_irqsave() call for the event_lock), so that taking that timestamp
> (which is only needed later for some comparisons) isn't delayed by a
> possible blocking on that lock. Getting the timestamp as early as possible
> after entering that function is needed to make pageflip timestamping more
> robust.
>
> I'm puzzled why calling do_gettimeofday() could cause any harm, even if that
> code gets executed by accident. I stared at the code for a while and
> couldn't see missing initializations or similar. Maybe it would still make
> sense to try to get some ftrace's on how the code there executes, e.g.,
> which path does it actually take or if some piece of code takes an unusual
> and excessive amount of time to execute?

I'm sorry to say that I have now given up on this: it has already
consumed a lot more time than I can afford to give it.  So I've now
just turned CONFIG_DRM_I915_KMS off, which gives me a laptop on which
2.6.38-rc is usable.

If in due course there's a likely patch someone would like me to try,
that I can do.  And from time to time, with new kernels and with
upgraded userspace, I'll give I915_KMS a try again - indeed, for the
moment I still have it in my 64bit kernel.

Before switching KMS off, I did establish that, with Chris's overrun
fix, do_intel_finish_page_flip() - the function whose call to
do_gettimeofday() I moved - is no longer called at all.  So that
modification was just cargo-cult magic by now (though perhaps made a
difference to timings when overruns were happening), and there's no
reason to suspect Mario's vblank patch at all.  Let's assume that if I
attempted a fifth bisection, it would lead me to another (equally
blameless) patch.  Nobody else is complaining: maybe my 965 is broken
and just gets along better with 2.6.38 KMS off.

Hugh
