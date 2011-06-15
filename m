Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1FODYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 23:24:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39066 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1FODYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 23:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l4zOhPa0AE5q1fJoteAME8CJl3zxLnmcrkxkNjEmqieQWPMl2x2TpqatQTl84W3ScR
         oReF4cPKaMxikz6MD2qcZ1Akz766t16MR0nRhmwySf/xn5TXsoPY4nFKgh0kHNfZknf9
         5134ut40yodMEP74N5Kn0DH+0BecXGAQ7+AHc=
MIME-Version: 1.0
In-Reply-To: <877h8nc0gp.fsf@eliezer.anholt.net>
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
	<877h8nc0gp.fsf@eliezer.anholt.net>
Date: Wed, 15 Jun 2011 11:24:38 +0800
Message-ID: <BANLkTinYuqzdg3OtzBRBGGnig2sC3fSsYQ@mail.gmail.com>
Subject: Re: [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 June 2011 10:06, Eric Anholt <eric@anholt.net> wrote:
> On Wed, 15 Jun 2011 00:51:47 +0800, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>> On 14 June 2011 13:23, Eric Anholt <eric@anholt.net> wrote:
>> > On Tue, 14 Jun 2011 12:18:36 +0800, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>> >> Hi Eric,
>> >>
>> >> The frequent ~1.5s pauses I hit with SNB hardware in the gnome3 UI (eg
>> >> whenever you hit the top-left of the screen to show all windows) are
>> >> nicely addressed by your recent wake patch [1] (ported to -rc3). Thus
>> >> I see no 'missed IRQ' kernel messages.
>> >>
>> >> As this addresses a significant usability regression, are you happy to
>> >> add it to the 3.0-rc queue? I think it has very good value in -stable
>> >> also (assuming correctness). What do you think?
>> >
>> > This one had significant performance impacts, and later hacks in this
>> > series worked around the problem to approximately the same level of
>> > success with less impact, and we don't actually have a justification of
>> > why any of them work.  We were still hoping to come up with some clue,
>> > and haven't yet.
>>
>> True; that is quite heavy handed delay looping.
>>
>> It's a pity the usual Intel font didn't make it to the programmer's
>> reference manuals. Anyway, unmasking the blitter user interrupt in the hardware
>> status mask register addresses the root cause. Out of reset it's FFFFFFFFh,
>> so we don't need to read it here.
>>
>> It would be good to get this into -rc4. -stable probably needs some additional
>> tweaks.
>>
>> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

> So you're saying that our interrupts at the top-level IMR are triggered
> by the write to the status page of the lower-level ring?  That's
> surprising to me.  Or do you think that this write is just happening to
> trigger serialization so the interrupt comes after the DWORD write of
> the seqno by the ring?  (hw folks just recently indicated that our
> particular code is not expected to serialize the interrupt after the
> seqno store, unless we had an MI_FLUSH_DWORD in between)

When ISR bits not masked by the hardware status mask register change,
a write is generated with the ISR contents to the status page, so I
believe that the blitter command streamer wasn't generating an
interrupt when an MI_USER_INTERRUPT command was issued. The interrupt
handler would kick in for other interrupts, read all the IIRs and
notice the bit set and wake the ring interrupt queue anyway.

I guess we could test this by observing that the BLT user interrupt
IIR bit is always not set on it's own (ie another interrupt woke us)
in the interrupt handler.

Thanks,
  Daniel

> This patch has now passed 7000 iterations of the testcase that had a
> ~.5% failure rate before.
>
> Tested-by: Eric Anholt <eric@anholt.net>
-- 
Daniel J Blueman
