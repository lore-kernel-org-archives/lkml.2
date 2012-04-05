Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2DEBI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 21:08:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38781 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DEBIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 21:08:55 -0400
Message-ID: <4F7CF094.5020201@us.ibm.com>
Date: Wed, 04 Apr 2012 18:08:36 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com>
In-Reply-To: <4F7C9402.3090602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040501-1780-0000-0000-000004875AA6
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000264; HX=3.00000186; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00128081; UDB=6.00030393; UTC=2012-04-05
 01:08:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 11:33 AM, Prarit Bhargava wrote:
>> One idea might be to replace the cyc2ns w/ mult_frac in only the watchdog code.
>> I need to think on that some more (and maybe have you provide some debug output)
>> to really understand how that's solving the issue for you, but it would be able
>> to be done w/o affecting the other assumptions of the timekeeping core.
>>
> Hey John,
>
> After reading the initial part of your reply I was thinking about calling
> mult_frac() directly from the watchdog code as well.
>
> Here's some debug output I cobbled together to get an idea of how quickly the
> overflow was happening.
>
> [    5.435323] clocksource_watchdog: {0} cs tsc csfirst 227349443638728 mask
> 0xFFFFFFFFFFFFFFFF mult 797281036 shift 31
> [    5.444930] clocksource_watchdog: {0} wd hpet wdfirst 78332535 mask
> 0xFFFFFFFF mult 292935555 shift 22
>
> These, of course, are just the basic data from the clocksources tsc and hpet.

If I'm doing the math right, these are ~2.7 Ghz cpus?

So what kernel version are you using?

In trying to reproduce this locally against Linus' HEAD on a much 
smaller system (single core + HT 1.6Ghz), I got:
[    6.611366] clocksource_watchdog: {0} cs tsc csfirst 36177888648 mask 
ffffffffffffffff mult 10485747 shift 24
[    6.611596] clocksource_watchdog: {0} wd hpet wdfirst 169168400 mask 
ffffffff mult 2684354560 shift 26

Note the smaller shift values. Not too long ago the shift calculation 
was adjusted to allow for longer periods between interrupts,  so I 
suspect you're on an older kernel.

Further, using your debug patch on my system, it was well beyond 10 
minutes before the debug overflow occurred.  And similarly I couldn't 
trip the watchdog trigger using sysrq-t (but again, only two threads 
here, so not nearly as much data to print as you have).

Could you verify that the issue you're seeing is still is present w/ 
current mainline?  Please don't take this as me dismissing your 
problem!  As I mentioned earlier there are some known issues w/ the 
clocksource watchdog code. But I want to narrow down if you're  problem  
is currently present in mainline or only in older kernels, as that will 
help us find the proper fix.

thanks
-john

