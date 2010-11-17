Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0KQD4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:56:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21622 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0KQD4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=b6+BQU/zglqYKcS/5hfkr9F/Iah8sELgfwE/YIgzktgmQ4XIRNIuMngOWhcaXbfnd9
         mRhU1Ji1jAesiQT3XLeA==
MIME-Version: 1.0
In-Reply-To: <2D4BBBBAD3C3714F8E8675F927E908210A210908@ESESSCMS0361.eemea.ericsson.se>
References: <1283396674-4865-1-git-send-email-ccross@android.com>
	<AANLkTinsRCinLdhq1xj0tx09Jb=Tohdbd7PUD=ae1q3m@mail.gmail.com>
	<DB5ED9F94071134F8D813944A461CF1A0196031CBA@ESESSCMS0361.eemea.ericsson.se>
	<20101112125901.GA3619@n2100.arm.linux.org.uk>
	<2D4BBBBAD3C3714F8E8675F927E908210A210908@ESESSCMS0361.eemea.ericsson.se>
Date: Tue, 16 Nov 2010 19:55:59 -0800
X-Google-Sender-Auth: UE-L69adGheU6rZQfsF2cTawWe8
Message-ID: <AANLkTikZhikQ+Ag8++NpMn5vWPmTkeEmVCE6s5TCfdGr@mail.gmail.com>
Subject: Re: [PATCH] [ARM] twd: Allow twd rescaling to match cpu frequency
From: Colin Cross <ccross@android.com>
To: Harald Gustafsson <harald.gustafsson@ericsson.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rickard ANDERSSON <Rickard.Andersson@stericsson.com>,
        Rob Herring <robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 5:05 AM, Harald Gustafsson
<harald.gustafsson@ericsson.com> wrote:
>> > Don't forget the other patches to make this work:
>> >
>> > [ARM] twd: Always calibrate local timer [ARM] twd: Fix updating
>> > control register in set_mode [ARM] twd: Fix prescaler
>> getting cleared
>> > by set_mode
>>
>> ... which have never been posted to this mailing list, so no
>> one here knows of them.
>
> They are on the tegra branch git also authored by Colin. So I would suggest that Colin make all the changes into a new patch.
>
> http://android.git.kernel.org/?p=kernel%2Ftegra.git&a=search&h=refs%2Fheads%2Flinux-tegra-2.6.35&st=commit&s=twd
>
> /Harald

I'm not happy with the current implementation, which is why it hasn't
been posted.  I'm planning to rewrite it with cpufreq notifiers, but
that brings us back to the periphclk divider problem discussed in
http://comments.gmane.org/gmane.linux.ports.arm.kernel/91827

If the frequency is going to change, using clk_get_rate on periphclk
is not sufficient, because the clock will not have been updated when
the prechange cpufreq notifier is called.  If the cpu frequency is
increasing, the twd divider must be recalculated before the frequency
changes to avoid timers expiring early.  Either the clock used by the
twd driver must be updated before prechange notifiers and after
postchange notifiers, which is difficult to fit in to all the
different implementations of the clock api, or the twd driver needs to
know the ratio between the cpu frequency and the periphclk frequency.
