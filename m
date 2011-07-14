Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1GNWzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:55:06 -0400
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:51158 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab1GNWzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:55:05 -0400
Message-ID: <4E1F72E1.3040102@genband.com>
Date: Thu, 14 Jul 2011 16:51:13 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>,
        Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: App blocked in futex() burns 14% CPU.
References: <alpine.LNX.2.00.1107150019580.26455@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1107150019580.26455@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2011 22:51:14.0890 (UTC) FILETIME=[89002AA0:01CC4278]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18262.002
X-TM-AS-Result: No--32.176500-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 04:34 PM, Jesper Juhl wrote:
> So, I've recently started enabling the KDE desktop search on my box and it
> runs some indexing services (naturally) to keep track of changes to files.
> One of the apps it starts is a process named "virtuoso-t". This process
> burns a *lot* of CPU when it's just started, but once it has caught up
> with recent changes it quiets down. It doesn't quite quiet down to the
> level I'd expect though. I see it constantly using 12-14% CPU time in
> 'top' even when there is *nothing* going on on the machine :
>
> top - 00:25:09 up  2:38,  2 users,  load average: 0.01, 0.04, 0.05
> Tasks: 155 total,   1 running, 153 sleeping,   0 stopped,   1 zombie
> Cpu(s):  0.7%us,  0.8%sy,  3.7%ni, 94.6%id,  0.1%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:   3853028k total,  2154696k used,  1698332k free,   184280k buffers
> Swap:  4200992k total,        0k used,  4200992k free,   996824k cached
>
>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>   1952 jj        39  19  362m 263m 6544 S   14  7.0  25:09.54 virtuoso-t
>   1811 jj        20   0  635m  27m  17m S    2  0.7   2:49.78 knotify4
>   1928 jj        39  19  595m  26m  18m S    1  0.7   2:58.40 nepomukservices
>
> This box has a dual core Intel core i5-560M CPU with hyperthreading, so it
> is 12-14% of a fairly capable CPU - that's rather a lot more than I'd
> expect when the box is idle and there's nothing for the process to do.
>
> So, I tried strace'ing the process and it seems to just be blocked in
> futex() most of the time (like 99%) :
>
> [jj@dragon ~]$ strace -p 1952
> Process 1952 attached - interrupt to quit
> futex(0x3086424, FUTEX_WAIT_PRIVATE, 503, NULL
>
> So it's just sitting there doing nothing, which lead me to think that this
> is probably not a bug in the application - if it was doing some silly
> polling loop or similar I would not just see it blocked in a futex() call.
> So I'm guessing something must be happening in kernel space that's burning
> a lot of CPU.. I could be completely wrong of course, and if I am, please
> feel free to enlighten me.

You don't have enough kernel activity to account for 14% of a cpu.  Have 
you checked whether there's another thread within the process that's 
doing something in userspace?

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
