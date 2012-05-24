Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab2EXKsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:48:02 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34809 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab2EXKsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:48:00 -0400
Date: Thu, 24 May 2012 12:48:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Gong <gong.chen@linux.intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop CMC
 storm
Message-ID: <20120524104830.GB27063@aftab.osrc.amd.com>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com>
 <alpine.LFD.2.02.1205230859190.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com>
 <alpine.LFD.2.02.1205232044150.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com>
 <4FBD9BAA.7070902@linux.intel.com>
 <20120524060016.GB25344@aftab.osrc.amd.com>
 <alpine.LFD.2.02.1205241146100.3231@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205241146100.3231@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:01:13PM +0200, Thomas Gleixner wrote:
> Aside of that machine_check_poll is called from other places as
> well. So looking at mce_timer_start() which is surprisingly the timer
> callback:
> 
> The poll timer rate is self adjusting to intervals down to HZ/100. So
> when you get into a state where the timer rate becomes lower than HZ/5
> we'll trigger that CMCI storm in software and queue work even on
> machines which do not support CMCI or have it disabled. Brilliant,
> isn't it?

Yes, I'm thrilled just by staring at this :-).

> So that rate check belongs into intel_treshold_interrupt() and wants a
> intel specific callback in mce_start_timer() to undo it.

So AFAICT mce_start_timer() sets the polling rate of machine_check_poll,
i.e. we normally poll the MCA registers for errors every 5 minutes. This
is for correctable errors which don't raise #MC exception but only get
logged.

That's why, for example, when you boot your box you see

"Machine check events logged."

in dmesg at timestamp 299.xxx when the hw has either had an MCE causing
it to reboot or has experienced a correctable error during boot.

Oh, I see it now, this thing reconfigures the mce_timer which we use for
the above.

Ok, I'm no timer guy but can we use the same timer for two different
things? This looks pretty fishy. I assumed the CMCI thing adds another,
CMCI-only timer for its purposes.

Thomas, what is the proper design here?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
