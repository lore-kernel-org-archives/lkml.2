Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1LILii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:38:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37832 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1LILih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:38:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAArOQ2V7bAxnWq5Mp1ROJ4oEdVBhHFAsbO_zGfEh50bYQcwtSg@mail.gmail.com>
References: <CAArOQ2UcC8P0xe6qwmf4FLitQs-tThtQLe7ZwS2J8FOwTXV=YQ@mail.gmail.com>
	<CAArOQ2V7bAxnWq5Mp1ROJ4oEdVBhHFAsbO_zGfEh50bYQcwtSg@mail.gmail.com>
Date: Fri, 9 Dec 2011 06:38:36 -0500
Message-ID: <CAArOQ2VDBaTwf7ytdhPvHZJ9nDPwVqwv6GPKUksqMePfYWe_YQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: fix infinite recursion on unbind
 due to ilk vt-d w/a
From: Bobby Powers <bobbypowers@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ben Widawsky <ben@bwidawsk.net>, Dave Airlie <airlied@gmail.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 6:32 AM, Bobby Powers <bobbypowers@gmail.com> wrote:
> On Thu, Dec 8, 2011 at 11:05 PM, Bobby Powers <bobbypowers@gmail.com> wrote:
>> On Tue, Dec 6, 2011 at 12:43 PM, Ben Widawsky <ben@bwidawsk.net> wrote:
>>> On Tue, Dec 06, 2011 at 12:12:33PM +0100, Daniel Vetter wrote:
>>>> The recursion loop goes retire_requests->unbind->gpu_idle->retire_reqeusts.
>>>>
>>>> Every time we go through this we need a
>>>> - active object that can be retired
>>>> - and there are no other references to that object than the one from
>>>>   the active list, so that it gets unbound and freed immediately.
>>>> Otherwise the recursion stops. So the recursion is only limited by the
>>>> number of objects that fit these requirements sitting in the active list
>>>> any time retire_request is called.
>>>>
>>>> Issue exercised by tests/gem_unref_active_buffers from i-g-t.
>>>>
>>>> There's been a decent bikeshed discussion whether it wouldn't be
>>>> better to pass around a flag, but imo this is o.k. for such a limited
>>>> case that only supports a w/a.
>>>>
>>>> Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>> Reviewed-by: Chris Wilson <chris@chris-wilson> # we built better
>>>>       bikesheds, but this keeps the rain off for now
>>>> ---
>>>
>>> What about:
>>> http://lists.freedesktop.org/archives/intel-gfx/2011-October/012984.html
>>>
>>>
>>> Did someone prove that doesn't work?
>>
>> This patch caused hard lockups for me after ~35 minutes of casual use
>> (twice).  I've attached the oopses.  I'm running a Fedora 16 machine,
>> Lenovo T420 (i5-2540M w/ VT-d enabled), and at each time had a Windows
>> 7 KVM guest idling (not sure if that is relevant).  With this patch
>> reverted, I've had ~ 6 hours of oops free uptime.
>
> To be clear, by 'this patch' I mean commit eb1711bb "[PATCH] drm/i915:
> fix infinite recursion on unbind due to ilk vt-d w/a" on Linus's
> branch, not the patch Ben linked to.
>
>> Let me know what additional information I can provide, or if there is
>> anything I can test to help narrow the issue down.

Additionally I have i915.i915_enable_rc6=1 on the kernel command line.

>>
>> yours,
>> Bobby
>>
>> ~~~
>>
>> [bpowers@fina linux]$ lspci
>> 00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
>> Family DRAM Controller (rev 09)
>> 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
>> Core Processor Family Integrated Graphics Controller (rev 09)
>> 00:16.0 Communication controller: Intel Corporation 6 Series/C200
>> Series Chipset Family MEI Controller #1 (rev 04)
>> 00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network
>> Connection (rev 04)
>> 00:1a.0 USB Controller: Intel Corporation 6 Series/C200 Series Chipset
>> Family USB Enhanced Host Controller #2 (rev 04)
>> 00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
>> Family High Definition Audio Controller (rev 04)
>> 00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
>> Family PCI Express Root Port 1 (rev b4)
>> 00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
>> Family PCI Express Root Port 2 (rev b4)
>> 00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
>> Family PCI Express Root Port 4 (rev b4)
>> 00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
>> Family PCI Express Root Port 5 (rev b4)
>> 00:1d.0 USB Controller: Intel Corporation 6 Series/C200 Series Chipset
>> Family USB Enhanced Host Controller #1 (rev 04)
>> 00:1f.0 ISA bridge: Intel Corporation QM67 Express Chipset Family LPC
>> Controller (rev 04)
>> 00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series
>> Chipset Family 6 port SATA AHCI Controller (rev 04)
>> 00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
>> SMBus Controller (rev 04)
>> 03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev 34)
>> 0d:00.0 System peripheral: Ricoh Co Ltd Device e823 (rev 08)
>> 0d:00.3 FireWire (IEEE 1394): Ricoh Co Ltd FireWire Host Controller (rev 04)
>> [bpowers@fina linux]$ cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : GenuineIntel
>> cpu family      : 6
>> model           : 42
>> model name      : Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz
>> stepping        : 7
>> microcode       : 0x18
>> cpu MHz         : 800.000
>> cache size      : 3072 KB
>> physical id     : 0
>> siblings        : 4
>> core id         : 0
>> cpu cores       : 2
>> apicid          : 0
>> initial apicid  : 0
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 13
>> wp              : yes
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
>> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
>> rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology
>> nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
>> tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
>> tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts
>> dts tpr_shadow vnmi flexpriority ept vpid
>> bogomips        : 5184.24
>> clflush size    : 64
>> cache_alignment : 64
>> address sizes   : 36 bits physical, 48 bits virtual
>> power management:
>>
>> [3 other processors omitted]
