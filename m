Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1BATc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:32:56 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:58998 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752167Ab1BATcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:32:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eNSeP7qZrAFxTlilx2G4VE4NZPDwpvY4shLt5Cn31qY6EVE87/HLuN56VqQRRitjPSaiSt0MyVIZLOrPphe+lwLTJ1h7SaAvnUk7LzRLaHFsvzYNbgtHwKSLsd6D2iAI;
Date: Tue, 1 Feb 2011 11:32:38 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hugh Dickins <hughd@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
Message-ID: <20110201113238.60b33ff9@jbarnes-desktop>
In-Reply-To: <AANLkTim4kL9OjBDiQQ1MBfOCzThxmDonBic11N45NKxj@mail.gmail.com>
References: <849307$bc24ct@azsmga001.ch.intel.com>
	<1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LSU.2.00.1102010909270.1586@sister.anvils>
	<20110201094643.366bc073@jbarnes-desktop>
	<20110201100833.3219687e@jbarnes-desktop>
	<AANLkTim4kL9OjBDiQQ1MBfOCzThxmDonBic11N45NKxj@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 10:46:17 -0800
Hugh Dickins <hughd@google.com> wrote:

> On Tue, Feb 1, 2011 at 10:08 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Tue, 1 Feb 2011 09:46:43 -0800
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >>
> >> Are you still seeing underruns during normal activity?
> 
> Yes.  That is, I see the "pipe a underrun" messages when I set drm
> debug 7: I'm unaware of any ill-effect from them, unless they are
> indeed a factor in my unflushed text issue.

They can cause your display to shake or flicker, or the memory
controller to get confused enough to hang your system.

> I was surprised that i915_driver_irq_handler  "Clear the PIPE(A|B)STAT
> regs" writes back precisely the pipea_stats it reads in, I'd have
> expected to clear something there (and did earlier experiment with
> writing back 0: black screen at boot!).  But assumed the protocol is
> such that it acknowledges the status bits by writing same back.

Exactly.  High bits are the interrupt enable bits, low bits are set for
status, write of 1 to clear status.

> Right.  I haven't double-checked the logic, but I believe it's because
> of bits set in the underrunning pipea_stats.  I did one time modify
> the underrun message to print out pipea_stats, over five seconds most
> (265) values were 0x80440207
> (there were also 14 occurrences of 0x80440007, 5 of 0x80440004 and 3
> of 0x80440204).

Well, vblank interrupts are enabled (though they shouldn't be for your
config as far as we know), so the interrupt status and handling is
occurring as expected.

What I find strange is that you're seeing flip pending interrupts.  Are
your symptoms affected if you remove the
I915_DISPLAY_PLANE_[AB]_FLIP_PENDING_INTERRUPT lines from
I915_INTERRUPT_ENABLE_FIX at the top of i915_irq.c?

Do you see any calls to drm_mode_page_flip_ioctl() in your environment?

> I just tried i915.powersave=0 but the underruns still appeared.  I
> then tried earlier kernels, and was surprised to find no underruns
> with 2.6.34, 2.6.36: the underruns appeared with 2.6.37.

Ok, that rules out self-refresh then I think.

-- 
Jesse Barnes, Intel Open Source Technology Center
