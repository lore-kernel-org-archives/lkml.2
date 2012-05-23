Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab2EWS6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:58:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:46261 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933835Ab2EWS6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:58:49 -0400
Date: Wed, 23 May 2012 20:58:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luck, Tony" <tony.luck@intel.com>
cc: Chen Gong <gong.chen@linux.intel.com>, "bp@amd64.org" <bp@amd64.org>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1205232044150.3231@ionos>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1205230859190.3231@ionos> <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Luck, Tony wrote:

> > What's the point of doing this work? Why can't we just do that on the
> > CPU which got hit by the MCE storm and leave the others alone? They
> > either detect it themself or are just not affected. 
> 
> CMCI gets broadcast to all threads on a socket. So
> if one cpu has a problem, many cpus have a problem :-(
> Some machine check banks are local to a thread/core,
> so we need to make sure that the CMCI gets taken by
> someone who can actually see the bank with the problem.
> The others are collateral damage - but this means there
> is even more reason to do something about a CMCI storm
> as the effects are not localized.

Thanks for the explanation. That should have been part of the
patch/changelog.

But there are a few questions left:

If I understand correctly, the CMCI gets broadcast to all threads on a
socket, but only one handles it. So if it's the wrong one (not seing
the local bank of the affected one) then you get that storm
behaviour. So you have to switch all of them to polling mode in order
to get to the root cause of the CMCI.

If that's the case, then I really can't understand the 5 CMCIs per
second treshold for defining the storm and switching to poll mode.
I'd rather expect 5 of them in a row.

Confused.

> > What's wrong with doing that strictly per cpu and avoid the whole
> > global state horror?
> 
> Is that less of a horror? We'd have some cpus polling and some
> taking CMCI (in somewhat arbitrary and ever changing combinations).
> I'm not sure which is less bad.

It's definitely less horrible than an implementation which allows
arbitrary disable/enable work scheduled. It really depends on how the
hardware really works, which I have not fully understood yet.

Thanks,

	tglx
