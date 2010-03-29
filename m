Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0C2VIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:08:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33907 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0C2VIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=HN1rMpCgzlnhTZetGM13kRYs0k0sM2l+kNM/EQAcXVuJ37HhNvMttH/Up7drfl2mPP
         wly8J8/T/8ga4svtSN1yGliC3fMjj9a+riMwf3V3cqhGBSLVd9R78g2/N+afbte/Kpt+
         SSvXEXhO/ZpLeULkZqDvZYE412mV0SOzd0zo4=
MIME-Version: 1.0
In-Reply-To: <1269888291.3968.5.camel@localhost.localdomain>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	 <20100326214648.GF9984@mail.oracle.com>
	 <1269824436.1880.2.camel@work-vm>
	 <20100329101106.3678a312@penta.localdomain>
	 <1269881007.1857.18.camel@work-vm>
	 <20100329130418.2b5c068c@penta.localdomain>
	 <1269888291.3968.5.camel@localhost.localdomain>
Date: Mon, 29 Mar 2010 17:08:28 -0400
X-Google-Sender-Auth: b5f226506f08157a
Message-ID: <ea182b21003291408t5a4fe8a8l47c0041df043a3a9@mail.gmail.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: john stultz <johnstul@us.ibm.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > What I'm saying is that if you're using getrawmonotonic() to detect
>> > hangs, you might miss them, as getrawmonotonic may wrap (and thus stop
>> > continually increasing) if the timer interrupt is delayed. This does not
>> > apply to systems using the TSC clocksource, but does apply to systems
>> > using the acpi_pm.
>>
>> But if timer interrupt is delayed by more than acpi_pm wrap-around
>> time, then the update_wall_time() is also screwed. Since it is not, we
>> can rely on getrawmonotonic().
>
> Right, if the box hangs for longer then the clocksource can count for,
> the timekeeping subsystem will be off by some multiple of that length.
>

Oh, I see. You mean that getrawmonotonic() wouldn't work under
abnormal conditions. I understand now, sorry for the confusion. You
are correct, of course.

I personally don't like the idea of relying on read_persistent_clock()
not only because of hwclock and ntp. In fact, my core interest in
hangcheck-timer is to set a very low margin (1 to 3 jiffies for
example) so that I would get a log message upon any kernel slow down
or a tick-miss (as a hardware integrity check). I don't think
read_persistent_clock() is precise enough for this purpose, is it?

Also, hooking to ntp update code complicates an otherwise simple
driver. I propose to simply check on non-S390 if the clock source
resolves to something other than TSC and dump a warning message on
driver load (something like "Hangcheck: kernel using clocksource %s,
which is not reliable for hang detection").

What do you think about it?

Thanks,
Yury
