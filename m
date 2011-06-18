Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1FRNL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 09:11:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58305 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1FRNLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 09:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SMwS775je+s3hsAVVaYh/ohI38onqZBmOaq1DFrDkJcAovyPIJLNc7smmtUhho7n6q
         5B5wDaG7MXoTRxUkGrg/YmdlS+ix5Cc8Cxps55nuvh1ad0+0QTP/jz0QSIOkcSqR1fki
         ttKQa6vyzxRQidknFkJuiGoFA8Ahfyc9PcT0Y=
MIME-Version: 1.0
In-Reply-To: <20110618150356.1b9e31cb@farn.lan>
References: <BANLkTi=o06eHLtFvmmz7c4TEjahy=EOrJQ@mail.gmail.com>
	<20110618133957.378b5266@farn.lan>
	<BANLkTikT3qoZhTrd0uF-JNehNhTCRjF6kw@mail.gmail.com>
	<BANLkTinf8X1AUEHteMnU3MMBEPEO1WNtzA@mail.gmail.com>
	<20110618150356.1b9e31cb@farn.lan>
Date: Sat, 18 Jun 2011 15:05:23 +0200
Message-ID: <BANLkTi=eU-XPJmZ=a3ZGFhJZxHVezzZ4VA@mail.gmail.com>
Subject: Re: Lock up when faking MMIO read[bwl] on some machines [WAS: Faking
 MMIO ops? Fooling a driver]
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pekka Paalanen <pq@iki.fi>, David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 18 czerwca 2011 14:03 użytkownik Pekka Paalanen <pq@iki.fi> napisał:
> On Sat, 18 Jun 2011 13:26:14 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> W dniu 18 czerwca 2011 12:57 użytkownik Rafał Miłecki
>> <zajec5@gmail.com> napisał:
>> > Not modified MMIO tracing works great on this machine, I've
>> > grabbed dumps 10-20 times without a lock up or anything.
>> >
>> > I'm using different drivers on both machines, because Macbook
>> > Pro 8,1 has unique BCM4331 card that I can not buy and that is
>> > not available with PCI(e) slot. Is uses some vendor specific,
>> > PCIe compatible slot. Simple commenting out "set_ins_reg_val"
>> > work fine on this Macbook, PHY reads are tracked correctly.
>> >
>> > As for differences in struct pt_regs... yeah, I think that
>> > happens. I'm using x86 kernel, while on Macbook we use x86_64
>> > as it's required to use 64bit driver in ndiswrapper.
>> >
>> > I can try to find out, which register we try to overwrite on
>> > Macbook.
>>
>> This is what does happen on my machine (working):
>> [  122.550991] mmiotrace: ZAJEC: read PHY 0x20
>> [  122.550994] mmiotrace: ZAJEC: overwriting 0x20 with 0xFFFF
>> [  122.550997] [ZAJEC] setting AX with 0xFFFF
>> (...)
>> [  122.551071] mmiotrace: ZAJEC: read PHY 0x22
>> [  122.551074] mmiotrace: ZAJEC: overwriting 0x22 with 0xFFFF
>> [  122.551077] [ZAJEC] setting AX with 0xFFFF
>> (...)
>> [  122.551198] mmiotrace: ZAJEC: read PHY 0x27
>> [  122.551201] mmiotrace: ZAJEC: overwriting 0x27 with 0xFFFF
>> [  122.551204] [ZAJEC] setting AX with 0xFFFF
>>
>>
>> This is what does happen on Macbook:
>> [  166.886438] mmiotrace: ZAJEC: read PHY 0x810
>> [  166.886649] mmiotrace: ZAJEC: overwriting 0x810 with 0xFFFF
>> [  166.886860] [ZAJEC] setting AX with 0xFFFF
>> LOCK UP
>>
>>
>> So on both machines we modify AX register in the same place. My
>> function set_ins_reg_val is a copy of get_ins_reg_val which works
>> fine... So no idea what may we be doing wrong on this Macbook
>> x86_64...
>
> Ok, so it is a 32 vs. 64 bit arch difference, or difference in
> driver binary. AX on 64-bit is actually RAX... well, depending
> on data width.
>
> I actually missed you patch attachment before, sorry.
>
> I have minor notes, but I cannot see them being a reason for a
> lockup:

Thanks for answer!


> - instead of set_reg_w32(), you should be able to simply
> *get_reg_w32() = (unsigned long)value; or equivalent since
> it returns a pointer.

Agree.


> - you are not checking the data access width, but you assume
> it is 32 bits. Maybe you should verify that? get_reg_w8() is
> very different. I think you should reproduce the switch on
> get_ins_reg_width() statement from get_ins_reg_val() in
> your set_ins_reg_val(), and use unsigned long instead of u32
> to account for 64-bitness.
>
> Yes, get_reg_w32() is a little badly named.
>
> Maybe the driver is doing a 16-bit wide access, and happens to
> store something else in the other 16/48 bits of RAX?

Nice comment, thanks! I've decided to print info about planned
overwrite, instead of really doing it. Plus few more debugging
messages suggested by David:
[  293.682242] mmiotrace: ZAJEC: overwriting 0x810 with 0xFFFF
[  293.687929] mmiotrace: [ZAJEC] ins at ffffc90010503b60: 0f b7 81 fe 03 00
[  293.693651] mmiotrace: [ZAJEC] p = (unsigned char *)ins_addr;
         p == 0xf
[  293.699379] mmiotrace: [ZAJEC] p += skip_prefix(p, &prf);
         p == 0xf
[  293.705116] mmiotrace: [ZAJEC] p += get_opcode(p, &opcode);
         p == 0x81
[  293.710815] mmiotrace: [ZAJEC] opcode is 0xb70f
[  293.716411] mmiotrace: [ZAJEC] prf info: shorted:0; enlarged:0, rexr:0, rex:0
[  293.722062] mmiotrace: [ZAJEC] after checing opcode we decided to use reg 0x0
[  293.727698] mmiotrace: [ZAJEC] width is 4
[  293.733219] [ZAJEC] (not) setting AX with 0xFFFF

So the read's width is 4, that's 32bit. If this is 64bit arch we could
be overwritting another 32bits in AX register, right? Can this be our
issue?


> I assume the lockup is silent, since you have not shown
> anything. Have you tried a serial console, if you have one?

I think David has some USB debugging (what ever it means...). Using
console mode just printed commands done right before overwritting
register.

-- 
Rafał
