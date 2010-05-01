Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab0EAX1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 19:27:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:52250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0EAX1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 19:27:12 -0400
Date: Sat, 1 May 2010 16:29:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100501162917.06bcafed@infradead.org>
In-Reply-To: <20100424045626.GA7561@elf.ucw.cz>
References: <20100418115949.7b743898@infradead.org>
	<20100418120346.1b478410@infradead.org>
	<20100423052439.GB4829@ucw.cz>
	<20100423065248.3b0a98ab@infradead.org>
	<20100424045626.GA7561@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Apr 2010 06:56:26 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> 
> So... some old data. It is not exactly athlon 64 -- I don't have that
> particular number for it -- but: (from my old notes):
> 
> thinkpad x32 [52Wh]
> ~~~~~~~~~~~~
> idle machine at 600MHz, min bl:         10 W
>              at 1.8GHz:                 +6.6 W
> 
> ...so yes, I kind of see a pattern there. And you should be able to
> easily see the difference, too, if you took something from that era...


so I finally found a machine based on a Pentium M (similar to this
Thinkpad, at least according to google) and spend half a day getting its
Fedora 8 installation to compile a modern kernel (these guys don't
compile very fast....).

Turns out that things are not as simple as your data suggest.
The complexity is in USB autosuspend.
Without USB devices, I see:

"powersave"	9.7 / 9.8  Watts (alternating between these readings)
"ondemand"      9.7 / 9.8  Watts
"performance"   9.8 Watts (solid on 9.8, not alternating)

if all USB devices are in autosuspend, it's pretty much the same
picture.

But if there is an active USB device, the CPU will no longer go to C4,
but will be stuck in C2 (this is the last generation of Intel chipsets
that suffer from this behavior; "c2 popup" is what the ich4m is
missing). And the C2 power behavior does show sensitivity to the CPU
frequency... roughly 3 1/2 Watts for my machine.

Doing the 'cat' from a usb mount as you suggested, which implies active
USB DMA, shows this 3 1/2 Watts increase between the old and new
ondemand. At the same time, the performance went up a little as well (a
3.7Gb took 3m32.5s before, and now takes 3m20.5s, so that saves a
little of the energy back).

 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
