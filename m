Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965865Ab2JZSMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:12:38 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36204 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965748Ab2JZSMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:12:36 -0400
Message-ID: <508AD291.1010803@gmail.com>
Date: Fri, 26 Oct 2012 11:12:33 -0700
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>  <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>  <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>  <1351172849.12171.10.camel@twins>  <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>  <1351241389.12171.45.camel@twins> <20121026092421.GB628@gmail.com>  <1351244130.16863.7.camel@twins> <20121026094207.GA2179@gmail.com>  <1351245264.16863.12.camel@twins>  <alpine.LFD.2.02.1210261208170.2756@ionos>  <1351248244.16863.13.camel@twins> <1351256204.16863.56.camel@twins>
In-Reply-To: <1351256204.16863.56.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
first of all thanks to everybody for all this comments!

On 10/26/2012 05:56 AM, Peter Zijlstra wrote:
> On Fri, 2012-10-26 at 12:44 +0200, Peter Zijlstra wrote:
>>> We can still have the user space interface handing in the information
>>> in nsec resolution, but it's reasonable to scale it down to something
>>> useful. Just shift the incoming information right by 10, so you're in
>>> the 1us resolution for all the internal math and all your limitation
>>> problems are gone. A shift by ten for converting back and forth to
>>> nsecs is not a real performance issue.
>>
>> I'm fine with that.. all I wanted was to not have the undefined overflow
>> we initially had.
>
> Note that we still need the constraint checking with this, although with
> both values shifted right 10 bits the range is now much bigger and
> shouldn't be a practical limit anymore.
>

I'll try to recap what seems to me you agreed and what will be the
changes for the next iteration.

- remove first two patches (u128 math) [and keep them in a safe place
   just in case following constraints will annoy future generation users
   :P]

- scale down (right by 10) incoming parameters as to do internal
   math with ~1us resolution (and scale up outgoing params)

- insert new constraints on -dl entities parameters:

     o since we have - dl_period >= dl_deadline >= dl_runtime - the
       only constraint we have to add for the overflow problem should
       be dl_period * dl_runtime < U64_MAX

     o to rule out problems with <= 1000ns parameters just force the user
       to pass > 1000ns parameters (in the end its our real resolution)

- WARN_ONCE() in proper places

- properly document all this (comments and Documentation)

What you think?

Thanks a lot and Regards,

- Juri
