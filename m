Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab0D1HtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:49:13 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:37559 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0D1HtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QNYOi4jK7JIo31Bm7b7PVrfP2RKSQzAVUKRcewnLkIJwtbEvnlTjcaEYFdpEt5MwJ1
         mormeJPOLf5Qes2GThGcEfqeNmYMijTNx08pjUE+/fD7PlHLmmZeWw/NW0C3RnxYp0qy
         geQts+veIpj1nELfwA0V8sqC72cAGb1tk8vig=
MIME-Version: 1.0
In-Reply-To: <ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
References: <1268258994.2183.14.camel@carter>
	 <ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
	 <20100311083404.GG6896@zhen-devel.sh.intel.com>
	 <ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
Date: Wed, 28 Apr 2010 17:49:09 +1000
Message-ID: <k2h21d7e9971004280049obb60e5e5v308e3f1f630adb6f@mail.gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
	entries in i915
From: Dave Airlie <airlied@gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, dwmw2@infradead.org, eric@anholt.net,
       ben@decadent.org.uk, gregkh@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 1:54 AM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> On Thu, Mar 11, 2010 at 9:34 AM, Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
>> On 2010.03.11 08:31:57 +0100, Miguel Ojeda wrote:
>>> On Wed, Mar 10, 2010 at 11:09 PM, Miguel Ojeda
>>> <miguel.ojeda.sandonis@gmail.com> wrote:
>>> > Hi,
>>> >
>>> > The commit 5877960869333e42ebeb733e8d9d5630ff96d350 (included since 2.6.32.4) crashes (locks up) the 82915G/GV/910GL Controller when intel-agp.c tries to access nonexistent GTT entries at:
>>> >
>>> > -               for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
>>> > +               for (i = intel_private.gtt_entries; i < intel_private.gtt_total_size; i++) {
>>> >
>>> > Rationale: I915 (gma900) has 128 MB of video memory (maximum), as per intel.com ( http://www.intel.com/support/graphics/intel915g/sb/CS-012579.htm ) and lscpi:
>>
>> I think that page is wrong, and http://www.intel.com/design/chipsets/datashts/301467.htm
>> has info that 256K is for GTT bar, so max video memory size is 256M. On my 915G
>> board, I can choose 128M/256M in BIOS setup.
>
> You are right, I can choose between 128M/256M in BIOS too. The BIOS
> config is the following:
>
> IGD Aperture Size: 128 MB
> DVMT MODE: FIXED
> IGD DVMT/FIXED MEMORY: 32 MB
>
>>
>>> >
>>> > 00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL Integrated Graphics Controller (rev 04) (prog-if 00 [VGA controller])
>>> >        Subsystem: Intel Corporation Device 4147
>>> >        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>> >        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>> >        Latency: 0
>>> >        Interrupt: pin A routed to IRQ 11
>>> >        Region 0: Memory at ff480000 (32-bit, non-prefetchable) [size=512K]
>>> >        Region 1: I/O ports at ec00 [size=8]
>>> >        Region 2: Memory at d8000000 (32-bit, prefetchable) [size=128M]
>>> >        Region 3: Memory at ff440000 (32-bit, non-prefetchable) [size=256K]
>>
>> This also tells bar 3 for GTT has 256K.
>>
>
> I see. I just guessed by seeing that gtt_total_size is the double than
> older num_entries and that "default" gtt_map_size is 256 instead of
> 128. Then I checked the webpage and lspci, I wrote the fix and it
> worked, so I thought it was 128 MB in fact (so GTT double in size).
>
>>> >        Capabilities: <access denied>
>>> >
>>> >
>>> > AFAIK, that implies that its gtt_total_size (in pages) should be 32K (as num_entries showed before the commit) instead of 64K.
>>> >
>>> > Note: The IS_I915 macro includes 945; however, only GMA900 (I915) had 128 MB as the maximum AFAIK. Therefore, I divided the IS_I915 macro. I do not know about the "E7221" (please check).
>>> >
>>> > How to reproduce: Access kernel.org in iceweasel (Debian Lenny) and the X server will crash. Sometimes, the kernel freezes.
>>> >
>>
>> I can't produce this on my 915G board with 128M or 256M memory config.
>
> It also occurs in other applications/ways. Maybe you could try to do
> some scrolling (I recall it also triggered it) or try to open other
> browsers (konqueror is another application that seems to trigger it
> easily in this box).
>
>> Could you
>> paste dmesg in your failure or just hang?
>
> Attached dmesg, lspci -vv, config and xorg.
>
> When the X server crashes, the kernel does not report anything:
>
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel 915G Chipset
> DEBUG i915 num_entries = 32768
> DEBUG i915 intel_private.gtt_total_size = 65536
> agpgart-intel 0000:00:00.0: detected 8060K stolen memory
> agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xd8000000
>
> I added a couple of printk's to see the value of num_entries (older
> loop limit) and gtt_total_size (newer).
>
> However, xorg reports the error:
>
> Error in I830WaitLpRing(), timeout for 2 seconds
> pgetbl_ctl: 0x7ffe0001 getbl_err: 0x00000000
> ipeir: 0x00000000 iphdr: 0x15000000
> LP ring tail: 0x00013aa8 head: 0x00013ae0 len: 0x0001f001 start 0x00000000
> eir: 0x0000 esr: 0x0000 emr: 0xffff
> instdone: 0xffc1 instpm: 0x0000
> memmode: 0x00000306 instps: 0x800f00ca
> hwstam: 0xffff ier: 0x0000 imr: 0xffff iir: 0x0000
> Ring at virtual 0xaf1c6000 head 0x13ae0 tail 0x13aa8 count 32754
>        00013a60: 00004820
>        00013a64: 00000000
> ...
>        00013adc: 00000001
>        00013ae0: 02001910
> Ring end
> space: 48 wanted 56
>
> Fatal server error:
> lockup
>
>
> FatalError re-entered, aborting
> I830Sync: BEGIN_LP_RING called without closing ADVANCE_LP_RING
>
> I do not know about output/reports when the video/kernel freezes
> completely (or seems so).
>

Is there any difference in the X org log files between booting
with/without this patch.

I suspect its one of those crappy cases where an old userspace driver
directly hits the hardware and the kernel AGP driver hits it
different,

I don't think reverting this patch can help anyone, as its clearly not
wrong, we also have no way to know in advance what userspace driver is
going to come along.

The only other way I can think to do this, is when the KMS drm driver
comes up it sets up the extra GTT entries and we leave the AGP driver
only touching what is always has.

In that case then the KMS driver will just work, and anyone running
UMS can stay in the 200xs.

Dave.
