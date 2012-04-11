Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870Ab2DKSRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:17:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39602 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab2DKSRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:17:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120410150304.GJ4115@phenom.ffwll.local>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
 <1333108003-6341-5-git-send-email-djkurtz@chromium.org> <20120410103746.GH4115@phenom.ffwll.local>
 <20120410104147.GI4115@phenom.ffwll.local> <CAGS+omAjDPxs1qR-EwzKhjE9c5J26fZinv6+5RFz1RyAsfStmw@mail.gmail.com>
 <20120410150304.GJ4115@phenom.ffwll.local>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 12 Apr 2012 02:16:45 +0800
X-Google-Sender-Auth: 92BpItjyT30adXDCj5fVvSYQmUQ
Message-ID: <CAGS+omD9dTTK4gRERy406nLFEMfqC=hw6ZFe3_V9yacSR2r9Sw@mail.gmail.com>
Subject: Re: [PATCH 4/8 v7] drm/i915/intel_i2c: use WAIT cycle, not STOP
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 11:03 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Apr 10, 2012 at 06:56:15PM +0800, Daniel Kurtz wrote:
>> On Tue, Apr 10, 2012 at 6:41 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> > On Tue, Apr 10, 2012 at 12:37:46PM +0200, Daniel Vetter wrote:
>> >> On Fri, Mar 30, 2012 at 07:46:39PM +0800, Daniel Kurtz wrote:
>> >> > The i915 is only able to generate a STOP cycle (i.e. finalize an i2c
>> >> > transaction) during a DATA or WAIT phase.  In other words, the
>> >> > controller rejects a STOP requested as part of the first transaction in a
>> >> > sequence.
>> >> >
>> >> > Thus, for the first transaction we must always use a WAIT cycle, detect
>> >> > when the device has finished (and is in a WAIT phase), and then either
>> >> > start the next transaction, or, if there are no more transactions,
>> >> > generate a STOP cycle.
>> >> >
>> >> > Note: Theoretically, the last transaction of a multi-transaction sequence
>> >> > could initiate a STOP cycle.  However, this slight optimization is left
>> >> > for another patch.  We return -ETIMEDOUT if the hardware doesn't
>> >> > deactivate after the STOP cycle.
>> >> >
>> >> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> >>
>> >> I've re-read gmbus register spec and STOP seems to be allowed even in the
>> >> first cycle. Does this patch solve an issue for you? If not, I prefer we
>> >> just drop it.
>>
>> STOP does not work in the first cycle, hence the patch.
>
> Ok, I've picked this patch up and extended the comment a bit to that
> effect. Just to avoid anyone else trying to 'fix' things because bspec
> sounds like it should work.
>
> I've also picked up the other patches safe for the last one, thanks a lot
> for digging through the gmbus code and fixing it all up.
>
> Now can I volunteer you for a (hopefully) last set of gmbus patches?
> Afaics there are a few small things left to fix:
> - zero-length reads can blow up the kernel, like zero-length writes could.
>  See: https://bugs.freedesktop.org/show_bug.cgi?id=48269

Got it.  Will Fix.

> - Chris Wilson suggested on irc that we should wait for HW_READY even for
>  zero-length writes (and also reads), currently we don't.

I don't think so.  We just need to wait for (GMBUS_SATOER |
GMBUS_HW_WAIT_PHASE).
Why would we wait for HW_READY, too?

> - atm the debug output is too noisy. I think we can leave the fallback to
>  gpio bitbanging at info (or maybe error) level, but all the other
>  messages should be tuned down to DRM_DEBUG_KMS - these can easily be hit
>  when userspace tries to probe the i2c with nothing connected or if the
>  driver code tries to do the same. See:
>  https://bugs.freedesktop.org/show_bug.cgi?id=48248

OK...  we can change the logging level.
However, the log in the bug to which you link seems to indicate a more
serious issue in this case.  It says to me that something on his
system is trying to talk to the disabled dpc i2c port 5 times every 10
seconds.  Each time it fails due with a time out, and each timeout
takes 50ms.  I would argue that the INFO message here is pointing out
that the hotplug code might want to check the corresponding
PORT_ENABLED bit before attempting a read over a particular DP/HDMI
gmbus port.  Perhaps I am mistaken, but if there was really nothing on
the bus, shouldn't that be a NAK, not a timeout?

>
> Chris, anything you want to add to the wishlist?
>
> Thanks, Daniel
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
