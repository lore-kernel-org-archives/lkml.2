Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab1AaQoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:44:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39909 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1AaQoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:44:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LfnZUhN8D2WUI2UPY4XMyE3Ge8lDXtEzQFtOPUBAJSz6OGxdWiM45heqVO4W+6qIb6
         PPvPTY1mFl8zKg+U524UjTMqNVadl1ZuMzJtuTeBwzw3r/Zag74KcpSVnZ2YtH1vDtKv
         lS2YxFb3EPx8bC5L6qDbJUBi00uWBW8JVVZzQ=
MIME-Version: 1.0
In-Reply-To: <20110128175910.GB4599@alberich.amd.com>
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
Date: Mon, 31 Jan 2011 10:44:19 -0600
X-Google-Sender-Auth: gZHZg9RiuWxTqR7wbyj8NQAPsg8
Message-ID: <AANLkTi=r5Q5zsGnxF_Fxa+2p6Hno=Xe=0Y9Lio=KK69N@mail.gmail.com>
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

Sorry, I was not able to get to this last week, I will test your patch
today and reply by EOBD today.

On Fri, Jan 28, 2011 at 11:59 AM, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
> On Fri, Jan 14, 2011 at 02:55:30PM -0500, Manoj Iyer wrote:
>> Borislav,
>>
>> Any more thoughts on this one ?
>
> Seems that we've identified the root cause.
>
> I wondered why systems with the problem have configured IOAPIC pin
> with polarity=1 (low active).  That was different to what the working
> systems used.
>
> Switching the configuration to the usual polarity=0 (high active)
> fixed the issue.
>
> The explanation is that when hpet interrupt is triggerd, signal goes
> from low to high. (AFAIK HPET spec even mentions that HPET interrupts
> are all active high.)
>
> Now if IO-APIC pin is configured as low active it just ignores this
> signal change. It just triggers later when for next interrupt signal
> will go from high to low and high again. (That happens the first time
> after resume when the HPET counter wrapped around.)
>
> Setting the correct polarity fixes the detection of the first hpet
> interrupt after resume.
>
> To confirm that your systems behave similar you should boot with
> "apic=debug" kernel parameter. The output for IO APIC should show
> polarity=1 for IO APIC pin 2, e.g.
>
>  [    0.158179] IO APIC #2......
>   ...
>  [    0.158205]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
>  [    0.158210]  00 000 1    0    0   0   0    0    0    00
>  [    0.158217]  01 003 0    0    0   0   0    1    1    31
>  [    0.158224]  02 003 0    0    0   1   0    1    1    30
>
> Furthermore you can check with attached test patch whether changing
> the polarity fixes the problem on your system. IO APIC debug output
> with this patch should change to
>
>  [    0.156170] IO APIC #2......
>   ...
>  [    0.156197]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
>  [    0.156202]  00 000 1    0    0   0   0    0    0    00
>  [    0.156209]  01 003 0    0    0   0   0    1    1    31
>  [    0.156216]  02 003 0    0    0   0   0    1    1    30
>
>
> I'll come up with an SB800 quirk asap. (Of course we'll also try to
> fix the respective BIOSes but too often BIOS updates are only
> available for a limited time period.)
>
>
> Regards,
>
> Andreas
>
> --
> Operating | Advanced Micro Devices GmbH
>  System  | Einsteinring 24, 85609 Dornach b. München, Germany
>  Research | Geschäftsführer: Alberto Bozzo, Andrew Bowd
>  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
>  (OSRC)  | Registergericht München, HRB Nr. 43632
>



-- 
-----------------------------------------------------
Manoj Iyer
Ubuntu/Canonical Kernel Developer
Hardware Enablement Team
------------------------------------------------------
