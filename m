Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab1ANTzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:55:33 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49887 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab1ANTzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:55:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jBQILJwOlP95kSpnMwOM9sfwdVHX1Fa5BinHl2TXnI9+YGD16osV29JO50Zi6xz1fH
         ZmC65CIv5G4tpPdBjz0zXPozatejo0chhqfjWKiOQKeZYqavPx0UrUDuOwLCI05m0FIe
         cnmR67QoGlbKl0KLhn1hZ5SmPNVYLnLxytDOw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101132353210.2678@localhost6.localdomain6>
References: <AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
	<20110113183025.GE2006@aftab>
	<alpine.LFD.2.00.1101131946560.2678@localhost6.localdomain6>
	<20110113185807.GA24720@srcf.ucam.org>
	<20110113190700.GB30866@kryptos.osrc.amd.com>
	<alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6>
	<20110113192825.GC30866@kryptos.osrc.amd.com>
	<alpine.LFD.2.00.1101132032350.2678@localhost6.localdomain6>
	<20110113210950.GA4081@aftab>
	<alpine.LFD.2.00.1101132210351.2678@localhost6.localdomain6>
	<20110113214841.GC4081@aftab>
	<alpine.LFD.2.00.1101132353210.2678@localhost6.localdomain6>
Date: Fri, 14 Jan 2011 13:55:30 -0600
X-Google-Sender-Auth: 4SlFFFEeqo3oJ--hnV6T1b-rtto
Message-ID: <AANLkTik7DgsmFv1KN6r92jai-Git5G9+kQLF9J0u=6e0@mail.gmail.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
From: Manoj Iyer <manoj.iyer@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav,

Any more thoughts on this one ?

Many Thanks
Manoj

On Thu, Jan 13, 2011 at 4:55 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 13 Jan 2011, Borislav Petkov wrote:
>> On Thu, Jan 13, 2011 at 04:30:43PM -0500, Thomas Gleixner wrote:
>> > The more interesting info is there in Manoj's logs:
>> >
>> > [    0.036455] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
>> > [    0.040000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>> > [    0.040000] ...trying to set up timer (IRQ0) through the 8259A ...
>> > [    0.040000] ..... (found apic 0 pin 0) ...
>> > [    0.080021] ....... works.
>> >
>> > versus
>> >
>> > [    0.036460] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> >
>> > So the "working" state is using "apic 0 pin 0" while the non working
>> > state is using "vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1".
>> >
>> > Something changes across suspend/resume which makes the BIOS
>> > advertised routing work with PIT but not with HPET. Further why does
>> > the apic 0/0 solution found by the kernel (when ignoring BIOS) works
>> > always (except that we don't know whether the "nohpet" case works as
>> > well, but I bet it does).
>>
>> Yes, it does. With "nohpet" we use PIT and PIT obviously works.
>
> No. We have no prove that acpi_skip_timer_override and nohpet work
> together :)
>
>> > So we are back to the question I raised above: What changes and even
>> > more interesting what changes after the HPET expires - which we know
>> > for sure that it must happen as otherwise we wont get a HPET interrupt
>> > after the 32bit wraparound.
>> >
>> > We need answers to these questions before applying any
>> > patch/workaround/quirk or whatever.
>>
>> Well, this is easily answered in the theoretical sense, without the
>> actual details :):
>>
>> 1. HPET gets reinitialized first
>> 2. Something programs it
>> 3. Timer expires but timer IRQ routing is still wrong and "Something"
>>    doesn't get its IRQ.
>> 4. Timer IRQ routing gets "fixed" as part of the resume path.
>>
>> ... we end up waiting for the counter to wraparound and get an IRQ which
>> gets delivered this time.
>>
>> Does that make sense at all?
>
> Yes, that's what I figured, but we need some explanation WHY this is
> "working" magically. Once we have that we can fix the issue at hand
> w/o applying random quirks.
>
> Thanks,
>
>        tglx
>



-- 
--manjo
