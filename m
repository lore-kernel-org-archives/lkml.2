Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2EXKB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:01:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:49661 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2EXKB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:01:26 -0400
Date: Thu, 24 May 2012 12:01:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@amd64.org>
cc: Chen Gong <gong.chen@linux.intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
In-Reply-To: <20120524060016.GB25344@aftab.osrc.amd.com>
Message-ID: <alpine.LFD.2.02.1205241146100.3231@ionos>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1205230859190.3231@ionos> <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com> <alpine.LFD.2.02.1205232044150.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com> <4FBD9BAA.7070902@linux.intel.com> <20120524060016.GB25344@aftab.osrc.amd.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, Borislav Petkov wrote:

> On Thu, May 24, 2012 at 10:23:38AM +0800, Chen Gong wrote:
> > Hi, Boris, when I write these codes I don't care if it is specific for
> > Intel or AMD.
> 
> Well, but I do care so that when you leave and start doing something
> else, people after you can still read and maintain that code.
> 
> > I just noticed it should be general for x86 platform and all related
> > codes are general too, which in mce.c, so I think it should be fine to
> > place the codes in mce.c.
> 
> Are you kidding me? Only Intel has CMCI.
> 
> Now, if some other vendor needs correctable errors interrupt rate
> throttling, they can carve it out, make it generic, and move it to mce.c.
> 
> Otherwise, it belongs in mce_intel.c. For the same reason AMD error
> thresholding code belongs to mce_amd.c.

Aside of that machine_check_poll is called from other places as
well. So looking at mce_timer_start() which is surprisingly the timer
callback:

The poll timer rate is self adjusting to intervals down to HZ/100. So
when you get into a state where the timer rate becomes lower than HZ/5
we'll trigger that CMCI storm in software and queue work even on
machines which do not support CMCI or have it disabled. Brilliant,
isn't it?

So that rate check belongs into intel_treshold_interrupt() and wants a
intel specific callback in mce_start_timer() to undo it.

Thanks,

	tglx




	


