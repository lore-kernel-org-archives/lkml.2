Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1A0Ofg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:35:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab1A0Off (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:35:35 -0500
Message-ID: <4D4182A7.5050503@redhat.com>
Date: Thu, 27 Jan 2011 15:35:19 +0100
From: "Fabio M. Di Nitto" <fdinitto@redhat.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Fabio M. Di Nitto" <fabbione@fabbione.net>,
        Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daid Miller <davem@davemloft.net>
Subject: Re: [PATCH] console: allow to retain boot console via boot option
 keep_bootcon
References: <1294821624-24544-1-git-send-email-fabbione@fabbione.net> <20110119161918.1f827080.akpm@linux-foundation.org> <4D37D18D.9060402@redhat.com>
In-Reply-To: <4D37D18D.9060402@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 1/20/2011 7:09 AM, Fabio M. Di Nitto wrote:
> On 01/20/2011 01:19 AM, Andrew Morton wrote:
>> On Wed, 12 Jan 2011 09:40:24 +0100
>> "Fabio M. Di Nitto" <fabbione@fabbione.net> wrote:
>>
>>> From: Fabio M. Di Nitto <fdinitto@redhat.com>
>>>
>>> On some architectures, the boot process involves de-registering the boot
>>> console (early boot), initialize drivers and then re-register the console.
>>>
>>> This mechanism introduces a window in which no printk can happen on the console
>>> and messages are buffered and then printed once the new console is available.
>>>
>>> If a kernel crashes during this window, all it's left on the boot console
>>> is "console [foo] enabled, bootconsole disabled" making debug of the crash
>>> rather 'interesting'.
>>>
>>> By adding "keep_bootcon" option, do not unregister the boot console, that
>>> will allow to printk everything that is happening up to the crash.
>>>
>>> The option is clearly meant only for debugging purposes as it introduces lots
>>> of duplicated info printed on console, but will make bug report from users
>>> easier as it doesn't require a kernel build just to figure out where we crash.
>>>
>>
>> I don't get it, as usual.
> 
> It might just be my itaglish explanation :)
> 
>>
>> The architecture does
>>
>> a) deregister boot console
>> b) initialize drivers
>> c) register console
>>
>> and the patch basically disables step a).
> 
> Yes that is correct.
> 
>>
>> But if we can do that without screwing things up, why not simply change
>> the architecture to not deregister the boot console until after
>> initializing the drivers?
> 
> I am not entirely sure if this is possible (or even worth it since this
> is a pure debugging option) and what kind of effects it might have on
> the boot output (in terms of duplicated entries on the output that might
> or might not make it more difficult to read). I am happy to investigate
> that and come back to you soon.

I have been looking into your suggestion and I think this is what
already happens.

According to kernel/print.k:

>         /*
>          * By unregistering the bootconsoles after we enable the real console
>          * we get the "console xxx enabled" message on all the consoles -
>          * boot consoles, real consoles, etc - this is to ensure that end
>          * users know there might be something in the kernel's log buffer that
>          * went to the bootconsole (that they do not see on the real console)
>          */

but my understanding, and please correct if I am wrong, is that when we
load or initialize modules such as fbcon (I made this patch debugging a
crash in atyfb), a console is indeed registered and bootconsole disable,
while in reality the real console is not there yet (in my case fbcon was
loaded but not atyfb yet).
At a later stage, once atyfb is loaded, it registers with fbcon and then
the console output starts again.

Thanks again for your time

Fabio
