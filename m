Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0IJJlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:41:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47256 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0IJJlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:41:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qwCj/HTC8MjZP6CYTBuWWhrsCcL3g5zplO4YeqDjIElh4HG/+qQ4WtZWkKR2tW3w2J
         IGr7GjigmRhISsZED5jZRUZjBfgfOAUE4k6T8iXPL1zTCpOevDIRv0roswNmEiJFa7YQ
         QwNYF1A7kMT6a/wWnRl/nz7anxnc2JNmYyb2w=
Message-ID: <4C89FD56.6060505@gmail.com>
Date: Fri, 10 Sep 2010 11:41:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Nix <nix@esperi.org.uk>, Artur Skawina <art.08.09@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown
 to unusability (HPET)
References: <87eid282pj.fsf@spindle.srvr.nix> <alpine.LFD.2.00.1009101022400.2477@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009101022400.2477@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 10:37 AM, Thomas Gleixner wrote:
> On Fri, 10 Sep 2010, Nix wrote:
> 
>> On 10 Sep 2010, Artur Skawina spake thusly:
>>> I'm seeing this too, except here it happens every couple of days of uptime,
>>> lasts for a few minutes, and then goes away. Which made bisecting a bit
>>> impractical... Thank you for doing it. 
>>
>> I just happened to be the lucky sod for whom it was consistently going
>> wrong. :)
>>
>>> HW is similar; x64 and X58/82801JI/ICH10, tsc clocksrc.
>>> Did that printk trigger?
>>
>> No.
>>
>> (hm, odd.
>>
>> spindle:~# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>> tsc
>>
>> spindle:~# grep -i tsc /proc/timer_list
>> spindle:~# grep -i hpet /proc/timer_list
>> Clock Event Device: hpet
>>  set_next_event: hpet_legacy_next_event
>>  set_mode:       hpet_legacy_set_mode
>>
>> I suspect current_clocksource doesn't do what we think it does, or the
>> clocksource and 'clock event device' are not the same.)
> 
> Right, they are not the same. clocksource provides us a read out
> device for timekeeping (usually a simple increasing counter). clock
> event device is used to generate timer interrupts.
> 
> HPET provides both functionalities.
> 
> The patch you bisected is affecting the clock events part of the
> HPET. So yes, it's not a clock source problem.

AFAIU, clocksource=jiffies shouldn't fix this issue. If that's the case
we have another 2.6.32->2.6.33 regression (and I will report it
separately). People report the system is unusable (sleepers are not
woken), unless clocksource=jiffies, clocksource=tsc or nolapic_timer is
used or a key pressed (i.e. some HW interrupt):
https://bugzilla.novell.com/show_bug.cgi?id=579932
(there is also a report with 2.6.35.3 vanilla)

thanks,
-- 
js
