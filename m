Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab1AaRyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:54:35 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39841 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1AaRye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GSkGatJe+7qLydZtu4VlG4gbyalfNgCXTS6uXz4HKAg/nMmPP2iebzBCaCdEFGjvgm
         a91uXmJheMbzK6F78a3FrNYdWzQLigRMHtcnylv1p03mpkQ/kLDHli58H3rS3meuq1jj
         LGIyXffA2IRJ4xlYe0lN28wJ2wprK85roBYxc=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=r5Q5zsGnxF_Fxa+2p6Hno=Xe=0Y9Lio=KK69N@mail.gmail.com>
References: <20110113185807.GA24720@srcf.ucam.org>
	<20110113190700.GB30866@kryptos.osrc.amd.com>
	<alpine.LFD.2.00.1101132012140.2678@localhost6.localdomain6>
	<20110113192825.GC30866@kryptos.osrc.amd.com>
	<alpine.LFD.2.00.1101132032350.2678@localhost6.localdomain6>
	<20110113210950.GA4081@aftab>
	<alpine.LFD.2.00.1101132210351.2678@localhost6.localdomain6>
	<20110113214841.GC4081@aftab>
	<alpine.LFD.2.00.1101132353210.2678@localhost6.localdomain6>
	<AANLkTik7DgsmFv1KN6r92jai-Git5G9+kQLF9J0u=6e0@mail.gmail.com>
	<20110128175910.GB4599@alberich.amd.com>
	<AANLkTi=r5Q5zsGnxF_Fxa+2p6Hno=Xe=0Y9Lio=KK69N@mail.gmail.com>
Date: Mon, 31 Jan 2011 11:54:32 -0600
X-Google-Sender-Auth: lXj-B_dTkDBxqS5yuv7QSZLsDAQ
Message-ID: <AANLkTinx=__6s_pNLA1hgucoi0PYntx6MOkK15s7qNxd@mail.gmail.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
From: Manoj Iyer <manoj.iyer@canonical.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "James C. Georgas" <james.georgas@yahoo.ca>,
        Borislav Petkov <bp@amd64.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

I tested your patch on a ThinkPad Edge 14, I only tested if the
machines was able to suspend and resume without delay, in that respect
I think your test patch works well. Please let me know when you have
your final patch ready I will be happy to test it and report back to
you.

On Mon, Jan 31, 2011 at 10:44 AM, Manoj Iyer <manoj.iyer@canonical.com> wrote:
> Sorry, I was not able to get to this last week, I will test your patch
> today and reply by EOBD today.
>
> On Fri, Jan 28, 2011 at 11:59 AM, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:
>> On Fri, Jan 14, 2011 at 02:55:30PM -0500, Manoj Iyer wrote:
>>> Borislav,
>>>
>>> Any more thoughts on this one ?
>>
>> Seems that we've identified the root cause.
>>
>> I wondered why systems with the problem have configured IOAPIC pin
>> with polarity=1 (low active).  That was different to what the working
>> systems used.
>>
>> Switching the configuration to the usual polarity=0 (high active)
>> fixed the issue.
>>
>> The explanation is that when hpet interrupt is triggerd, signal goes
>> from low to high. (AFAIK HPET spec even mentions that HPET interrupts
>> are all active high.)
>>
>> Now if IO-APIC pin is configured as low active it just ignores this
>> signal change. It just triggers later when for next interrupt signal
>> will go from high to low and high again. (That happens the first time
>> after resume when the HPET counter wrapped around.)
>>
>> Setting the correct polarity fixes the detection of the first hpet
>> interrupt after resume.
>>
>> To confirm that your systems behave similar you should boot with
>> "apic=debug" kernel parameter. The output for IO APIC should show
>> polarity=1 for IO APIC pin 2, e.g.
>>
>>  [    0.158179] IO APIC #2......
>>   ...
>>  [    0.158205]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
>>  [    0.158210]  00 000 1    0    0   0   0    0    0    00
>>  [    0.158217]  01 003 0    0    0   0   0    1    1    31
>>  [    0.158224]  02 003 0    0    0   1   0    1    1    30
>>
>> Furthermore you can check with attached test patch whether changing
>> the polarity fixes the problem on your system. IO APIC debug output
>> with this patch should change to
>>
>>  [    0.156170] IO APIC #2......
>>   ...
>>  [    0.156197]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
>>  [    0.156202]  00 000 1    0    0   0   0    0    0    00
>>  [    0.156209]  01 003 0    0    0   0   0    1    1    31
>>  [    0.156216]  02 003 0    0    0   0   0    1    1    30
>>
>>
>> I'll come up with an SB800 quirk asap. (Of course we'll also try to
>> fix the respective BIOSes but too often BIOS updates are only
>> available for a limited time period.)
>>
>>
>> Regards,
>>
>> Andreas
>>
>> --
>> Operating | Advanced Micro Devices GmbH
>>  System  | Einsteinring 24, 85609 Dornach b. München, Germany
>>  Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
>>  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
>>  (OSRC)  | Registergericht München, HRB Nr. 43632
>>
>
>
>
> --
> -----------------------------------------------------
> Manoj Iyer
> Ubuntu/Canonical Kernel Developer
> Hardware Enablement Team
> ------------------------------------------------------
>



-- 
-----------------------------------------------------
Manoj Iyer
Ubuntu/Canonical Kernel Developer
Hardware Enablement Team
------------------------------------------------------
