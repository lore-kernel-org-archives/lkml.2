Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab1D0KrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:47:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35459 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab1D0KrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HQAU7l3LlS7BXXcQmA0NutxX+CwqBx+KjUGh8rkF5znL2HnVwY06rxt5XbyrzbUmux
         W+grdDua9RiASN68UCh/IVUTAJpL7bHrAwfCdCyAyWeMvv5xOg/Ivr8icvAf5im3JY4Q
         a8JVz6VasHvi0j/lu5CQf4YPGWyI/ozCWmcuk=
MIME-Version: 1.0
In-Reply-To: <1303897603.4431.16.camel@oct.suse.cz>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
	<20110426210627.GA28033@elf.ucw.cz>
	<201104262346.58046.rjw@sisk.pl>
	<201104270032.42046.rjw@sisk.pl>
	<BANLkTi=QDjBtY2WypXjYzyAOUGYjf_oRvw@mail.gmail.com>
	<1303897603.4431.16.camel@oct.suse.cz>
Date: Wed, 27 Apr 2011 19:47:20 +0900
X-Google-Sender-Auth: fzluRs-A-_I8RI68MqSnqJt_gd8
Message-ID: <BANLkTik4v=8ME4p76dxboj_hs=m6P3EENA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for device PM.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Stanislav Brabec <utx@penguin.cz>
Cc: arminlitzel@web.de, Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
        lenz@cs.wisc.edu, dbaryshkov@gmail.com,
        Marek Vasut <marek.vasut@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, omegamoon@gmail.com,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        eric.y.miao@gmail.com, Cyril Hrubis <metan@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        rpurdie@rpsys.net,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        zaurus-devel@www.linuxtogo.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 6:46 PM, Stanislav Brabec <utx@penguin.cz> wrote:
> MyungJoo Ham wrote:
>
>> As long as sysdevs are resumed and some devices/subsystems (I2C-PMIC,
>> ADC, and RTC in my cases) can be selectively resumed and suspended, it
>> is fine.
>> Thus, your "alternative" suggestion is perfect with me. Actually, this
>> is almost going back to the original hack. =)
>>
>> I'll submit next revision with platform_suspend_ops later.
>
> Does kernel have something like "sleepy task" interface, e. g. special
> mode that is triggered by some sort of interrupt and instead of going to
> perform full resume, it just lets a hook to wake up "manually" needed
> devices, perform the "sleepy task" and then tell the system whether full
> resume is requested?

Not that I know of. I don't see anything that stops the resuming flow
(full resume will be performed at any wakeup event before this patch)

The patch that is going to be revised as mentioned will allow you to perform
1) "manually" wake up some devices
2) perform "sleepy tasks"
3) "manually" suspend devices waked up at 1)
4) tell the system whether full resume is requested.
at the suspend_again callback of struct platform_suspend_ops suspend_ops.

However, you may need some "helpers" to do 1 and 3 easily.

Anyway, for the "helpers" for 1) and 3), I expect that allowing the
one who provide suspend_ops to provide a list of struct dev pointers
that required wakeup would be enough.

I'd look at this issue as well because I have the same issue, but I'd
do it separately with the "suspend_again".

>
> It can fit for Zaurus battery charging monitoring - timer interrupt
> needs to wake just the SPI bus.
>
> But I can imagine a GPS logger using such interface to save energy -
> serial interrupt semi-wakes the system each second, but will not go to
> do full resume. It just processes NMEA sentence and buffers the result.
> Only if buffer becomes full, it issues full resume and writes data
> somewhere.

Sure, as long as the platform file (or machine/board file) has the
suspend_again callback implemented correctly, it will work as you
expected.

>
> --
> Best Regards / S pozdravem,
>
> Stanislav Brabec
> software developer
> ---------------------------------------------------------------------
> SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
> Lihovarská 1060/12                            tel: +49 911 7405384547
> 190 00 Praha 9                                  fax: +420 284 028 951
> Czech Republic                                    http://www.suse.cz/
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>


Cheers!

- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
