Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab0D3SoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:44:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:39570 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933292Ab0D3SoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:44:04 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/D5W1PRELDwVyocvaYC3F2KwrTf0YvfdC65nBpoa
	MiHnVxOOuwt5F0
Message-ID: <4BDB24ED.7010907@gmx.de>
Date: Fri, 30 Apr 2010 20:43:57 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
       linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 13/30] viafb: Separate global and fb-specific data
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>	<1272493051-25380-14-git-send-email-corbet@lwn.net>	<20100429201902.6379f8d3@neptune.home>	<20100430102157.5eb59055@bike.lwn.net>	<4BDB1C46.8020101@gmx.de> <20100430122236.2357c034@bike.lwn.net>
In-Reply-To: <20100430122236.2357c034@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> On Fri, 30 Apr 2010 20:07:02 +0200
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>> Please don't do this. The reason for not failing in viafb is that 
>> ioremap failure of the engine is not critical it just disables the 
>> hardware acceleration but otherwiese it works quite nice. The problem is 
>> that ioremap failures are quite common as we really try to remap huge 
>> amount (sometimes above 128 or even 256 MB). 
> 
> But...this region is small should never be hard to remap.  Are you sure
> you've seen trouble with the engine region?

Well I agree that after the reordering you did it should more likely 
work. But it remains valid that viafb can work without it and so it 
should (IMHO).
Yes there were actually problems, especially since the really old code 
did not even catch the error:
https://bugzilla.kernel.org/show_bug.cgi?id=13976

>> In fact the bug (or missing 
>> feature) is that the first ioremap is fatal and that needs to be fixed 
>> on the long run. Sorry but I don't want to make viafb unusable for many 
>> people if they don't add the "vmalloc=" kernel option so failing here 
>> would be a step in the wrong direction.
> 
> Is the real problem, perhaps, that we're remapping the entire
> framebuffer?  One wonders if we could get away without doing that.
> Some quick greppery suggests that the cursor code goes straight to a

> small region of framebuffer memory.  With working acceleration, we
> shouldn't need cfb_*().  But, probably, I'm missing something?

That mostly works I just tried it once for fun. But that's probably 
nothing we want to have in mainline as the hardware acceleration 
functions do at least have the possibility to fail. Possible solutions 
would include reducing the remapped memory on error (example: dividing 
it each time by 2 and failing if not at least 4 MB could be reamapped) 
or remapping it on demand: framebuffer only as big as needed (often 
between 4 and 8MB) with the possibility to "grow" and the cursor. The 
last would be my favourite as it does not needlessly eats memory space 
but is hardest to implement. Probably it will be fixed the next time 
I'll work around the memory management (which will be also tricky due to 
the framebuffer interface)

> Meanwhile, I can let initialization continue without the engine space.
> It kills interrupts/dma/camera, of course, but so be it.

Yeah at least for viafb that would be nice as it does not use any of 
these until now.


Thanks,

Florian Tobias Schandinat
