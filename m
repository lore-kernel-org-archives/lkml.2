Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab1CaKbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:31:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab1CaKbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:31:17 -0400
Message-ID: <4D9457BF.1040601@redhat.com>
Date: Thu, 31 Mar 2011 12:30:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Robin Holt <holt@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
References: <20101215015840.390204279@gulag1.americas.sgi.com> <20101215015849.051095242@gulag1.americas.sgi.com> <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com> <20110331065036.GC5938@elte.hu> <20110331065805.GG5938@elte.hu> <20110331093723.GE24046@sgi.com> <20110331095705.GA23319@elte.hu>
In-Reply-To: <20110331095705.GA23319@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 11:57 AM, Ingo Molnar wrote:
> >
> >  I am not trying to be argumentative.  I never got an understanding of
> >  what was going wrong with that earlier patch and am hoping for some
> >  understanding now.
>
> Well, if calibrate_delay() calls run in parallel then different hyperthreads
> will impact each other.

It's different but not more wrong.  If delay() later runs on a thread 
whose sibling is busy, it will in fact give more accurate results.

> >  Why does it spectacularly miscalibrate?  Can anything be done to correct
> >  that miscalibration?  Doesn't this patch indicate another problem with
> >  the calibration for hotplug cpus?  Isn't there already a problem if
> >  you boot a cpu normally, then hot-remove a hyperthread of a cpu, run a
> >  userland task which fully loads up all the cores on that socket, then
> >  hot-add that hyperthread back in?  If the lpj value is that volatile,
> >  what value does it really have?
>
> The typical CPU hotplug usecase is suspend/resume, where we bring down the CPUs
> in a more or less controlled manner.
>
> Yes, you could achieve something similar by frobbing /sys/*/*/online but that's
> a big difference to *always* running the calibration loops in parallel.
>
> I'd argue for the opposite direction: only calibrate a physical CPU once per
> CPU per bootup - this would also make CPU hotplug faster btw.
>
> ( Virtual CPUs (KVM, etc.) need a recalibration per bringup, because the new
>    CPU could be running on different hardware - but that's a detail: 4096 UV
>    CPUs are not in this category. )

Virtual cpus change their performance dynamically due to overcommit, 
live migration, the host scheduler rearranging them, etc.

> Really, there's no good reason why every CPU should be calibrated on a system
> running identical CPUs, right? Mixed-frequency systems are rather elusive on
> x86.

Good point.  And udelay() users are probably not sensitive to accuracy 
anyway (which changes with load and thermal conditions).

-- 
error compiling committee.c: too many arguments to function

