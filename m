Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2HJQje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 12:39:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47877 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab2HJQjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 12:39:33 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5025315B.4030401@ionic.de>
References: <5021F00B.7000503@ionic.de>
	<CAKMK7uFutq0Hn3FL==53Vvt-M00ReWaeXKq3uo8C_kzUfX+1ew@mail.gmail.com>
	<5025315B.4030401@ionic.de>
Date: Fri, 10 Aug 2012 18:39:32 +0200
Message-ID: <CAKMK7uFsZyhC4b6YWiskm6dk8HPuy_-qaaxvOO2fhYu3krOEaQ@mail.gmail.com>
Subject: Re: null pointer dereference while loading i915
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 6:05 PM, Mihai Moldovan <ionic@ionic.de> wrote:
> * On 10.08.2012 12:10 PM, Daniel Vetter wrote:
>> On Wed, Aug 8, 2012 at 6:50 AM, Mihai Moldovan <ionic@ionic.de> wrote:
>>> Hi Daniel, hi list
>>>
>>> ever since version 3.2.0 (maybe even earlier, but 3.0.2 is still working fine),
>>> my box is crashing when loading the i915 driver (mode-setting enabled.)
>>>
>>> The current version I'm testing with is 3.5.0.
>>>
>>> I was able to get the BUG output (please forgive any errors/flips in the output,
>>> I have had to transcribe the messages from the screen/images), however, I'm not
>>> able to find out what's wrong.
>>>
>>> If I see it correctly, there's a null pointer dereference in a printk called
>>> from inside gmbus_xfer. The only printk calls I can see in
>>> drivers/gpu/drm/i915/intel_i2c.c gmbus_xfer() however are issued by the
>>> DRM_DEBUG_KMS() and DRM_INFO() macros.
>>> Neither call looks wrong to me, I even tried to swap adapter->name with
>>> bus->adapter.name and make *sure* i < num is true, but haven't had any success.
>>>
>>> I'd really like to see this bug fixed, as it's preventing me from updating the
>>> kernel for over a year now.
>>>
>>> Also, while 3.0.2 works, it *does* spew error/warning messages related to gmbus
>>> and I've had corrupted VTs in the past (albeit after a long uptime with multiple
>>> X restarting and DVI cable unplugging/reattaching events), so maybe there's a
>>> lot more broken than "expected".
>>
>> Hm, this is rather strange. gmbus should not be enable on 3.2 nor 3.0,
>> since exactly this issue might happen. We've re-enabled gmbus again on
>> 3.5 after having fixed this bug. Are you sure that this is plain 3.2
>> you're running?
>
> Sorry, I messed up the version numbers. Started bisecting yesterday and noticed,
> that 3.0 up to 3.2 still work "fine" (see below), instead I've had another
> problem with 3.2 (completely lockup after the kernel is running for a few
> minutes, but I have no idea where this issue is coming from. Seems to be
> happening with 3.2.0 only, so... *shrug*)
>
> 3.0.2           => working, gmbus warnings as posted.
> 3.1-09933/07170 => working, NO gmbus warnings, but render errors (see below)
> 3.2-rc2 to rc4  => working, NO gmbus warnings, but render errors (see below)
> --- (stopped bisecting 3.0 to 3.2 as this was pointless) ---
> --- (restarted bisecting with 3.2 to 3.5) ---
> 3.3.0-06109     => working, gmbus warnings just like with 3.0, render errors
> (see below)
> 3.4.0-07487     => working, gmbus warnings, hang errors (see below)
> ...
>
> I've done more steps, but have not yet finished bisecting, so stay tuned.
> All those render errors look like that:
>
> [drm] capturing error event; look for more information in
> /debug/dri/0/i915_error_state
> render error detected, EIR: 0x00000010
>   IPEIR: 0x00000000
>   IPEHR: 0x02000000
>   INSTDONE: 0xffffffff
>   INSTPS: 0x8001e025
>   INSTDONE1: 0xbfbbffff
>   ACTHD: 0x00a4203c
> page table error
>   PGTBL_ER: 0x00100000
> [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
>
> I'll finish bisecting (and hope, that my guess was right, concerning the
> varaiant I wasn't able to build) and will post the bisect log when done.
>
> Meanwhile: at least for 3.0.2 and even older versions, gmbus must have been
> enabled as I'm pretty sure I always saw those errors when booting (just
> confirmed via logs for 3.0.0, 26.38.6, 2.6.39). Doesn't come up with 2.6.34,
> 2.6.36.1, 3.1-..., 3.2-... though.

Yeah, we've enabled gmbus a few times and then disabled it again due
to bugs. Also, the usual debug messsage says gmbus even when gmbus
isn't on ... yeah, slightly confusing, but that should be fixed, too.

For the gpu hang, please ensure that you're running the latest stable
release of everything (to avoid hunting down already known issues and
also because recent kernels dump more useful stuff), grab the entire
i915_error_state from debugfs and file a bug report with the usual
details at bugs.freedesktop.org against dri -> drm/intel.

Thanks,

Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
