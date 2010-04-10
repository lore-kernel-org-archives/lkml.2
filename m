Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab0DJH1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 03:27:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46174 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0DJH1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 03:27:21 -0400
Date: Sat, 10 Apr 2010 09:27:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100410072714.GA9246@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org>
 <20100409174041.GA10780@a1.tnic>
 <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org>
 <20100409191425.GB10780@a1.tnic>
 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
 <20100409204328.GG28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
 <20100410003110.GI28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, Apr 09, 2010 at 05:32:36PM -0700

> Exactly. This is the "let's limit things a bit to keep them much simpler.

You gotta love that rule :)

> > Let's hope it fixes Boris's issue.
> 
> I'm going to just guess that it won't, and that Boris' issue was actually 
> due to something else entirely, and we've all been staring at totally the 
> wrong code.
> 
> But we can hope.

Now why would you go and jinx it like that... :)

Hibernation runs back-to-back:

1. light system load after boot... ok
2. 3 kvm guests, 3Gb mem free of 8Gb total acc. to /proc/meminfo... ok			[ this was the fireproof way to trigger the bug, btw]
3. kvm guests down, firefox loading a 4Mb html page... ok
4. start ubuntu guest, firefox keeps loading the 4Mb html page after previous resume... ok
5. ubuntu guest booting done, firefox done, play video... ok
6. video broken after resume due to:

[AO_ALSA] Pcm in suspend mode, trying to resume. 212%  2%  1.7% 1 0 
[AO_ALSA] alsa-lib: pcm_hw.c:709:(snd_pcm_hw_resume) SNDRV_PCM_IOCTL_RESUME failed: Function not implemented

i.e., unrelated... still ok

7. ubuntu guest downloading a 100Mb file causing allocation of a bunch of anon memory in the host... ok
8. all guests off, firefox off, back to light load... ok

No oopsies or problems in dmesg except the old lockdep sysfs warning.

I will keep running that kernel in the next couple of days and keep you
informed in case this is the fix we're gonna use.

-- 
Regards/Gruss,
    Boris.
