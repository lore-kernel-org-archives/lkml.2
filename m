Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1EIPLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:11:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47008 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1EIPLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=m0CKH3sV/HhIwrhyTN8wqxpBs21F7YG7RUvty8YQ9gHZdMadvoB2Oa5ZgW7vVdM+hr
         /Fb6XTk6B6qBpmEEG0bqaOXvrTky+ikvb7/bOv7smmaWlvDev+edI3ADicNESb6XfHCC
         k5E1uGT08JqciY70D/b5X9etxYZ2ZbMiu3M0k=
MIME-Version: 1.0
In-Reply-To: <20110509144546.GB13275@khazad-dum.debian.net>
References: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com> <20110509144546.GB13275@khazad-dum.debian.net>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 9 May 2011 11:10:55 -0400
X-Google-Sender-Auth: OY5YFCZCRyTA7UOD86-nAYrO8_Y
Message-ID: <BANLkTikB2TFF12vdwLqV9NRw4meEyDjvdA@mail.gmail.com>
Subject: Re: [ibm-acpi-devel] [RFC] Controlling the ThinkPad battery charger
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 10:45 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sun, 08 May 2011, Andrew Lutomirski wrote:
>> I've figured out how the ThinkPad SMAPI charge control works (at least
>> well enough to program thresholds on some models), and I'd like to get
>
> Yeah, there's a little protocol to talk to the EC, otherwise it simply
> ignores writes to the battery threshold registers.  I think you had to set
> bit 7 before you write the threshold to the relevant EC register, or
> something.  Found it by trial-and-error a long time ago, I documented it
> somewhere but never took it forward.  I never bothered to hunt down the
> force-drain/battery-select commands, though.
>
> Anyway, since SMAPI works, and is *stable* (the fact that it works from the
> A21 to the latest Lenovos tells you just how stable), which is a lot more
> than what I can say about the ACPI stuff, I didn't see any reason to mess
> with this.

I must have been unclear.  I'm using SMAPI -- I've reverse-engineered
it from a combination of tp_smapi, the mwave driver, the ancient PDF
on Lenovo's site, and trial-and-error on my X220.  (The X220 fails
requests for the start threshold that work on on the X200s.)

>> 2. Integrate it with power_supply.
>
> Only if we can make it generic enough, but yes, THIS is the better way.
>
> However, I'd prefer if you went all the way and actually hooked to the SBS
> subsystem and exposed all the battery information.  There is a way to do
> that through the ACPI DSDT (but you will have to do the rev. engineering
> yourself, as I said, smapi works just fine across so many models, that I
> never bothered with it -- it is far better supported than ACPI).
>
> It is not even difficult, just look at the methods used to expose the
> standard ACPI battery interface, then read the Smart Battery System (SBS)
> standard, and you will find out by fast trial-and-error how to map one to
> the other.  Or you can look at tp_smapi to speed things up (only, tp_smapi
> talks directly to the EC instead of doing it over ACPI).
>
> The SBS interface exposes more data about the battery, including
> per-cell-group voltage and pack microcontroller aging counters, alarms, and
> the "needs to get through the fuel-gaugue reset procedure" semasphore.

If I'm feeling really motivated, I'll look at that.  I'm currently
more interested in the charging thresholds, though, which I think is
independent of the choice of SBS vs ACPI to access the battery state.
(From a quick glance at the SBS spec, you can inhibit charging
entirely but you can't ask for thresholds.  I assume that the EC takes
care of that.  If I'm wrong, please tell me, but SMAPI seems like a
fine way to access the thresholds.)

--Andy
