Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056Ab2EXSST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:18:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:57384 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab2EXSSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:18:17 -0400
Date: Thu, 24 May 2012 20:18:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luck, Tony" <tony.luck@intel.com>
cc: Chen Gong <gong.chen@linux.intel.com>, "bp@amd64.org" <bp@amd64.org>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F37C0@ORSMSX104.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1205242013490.3231@ionos>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1205230859190.3231@ionos> <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com> <alpine.LFD.2.02.1205232044150.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com> <alpine.LFD.2.02.1205241033460.3231@ionos> <3908561D78D1C84285E8C5FCA982C28F192F37C0@ORSMSX104.amr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, Luck, Tony wrote:

> > So can you please explain how this is better than having this strict
> > per cpu and avoid all the mess which comes with that patch? The
> > approach of letting global state be modified in a random manner is
> > just doomed.
> 
> Well doomed sounds bad :-) ... and I think I now agree that we should
> get rid of global state and have polling vs. CMCI mode be per-cpu. It
> means that it will take fractionally longer to react to a storm, but
> on the plus side we'll naturally set storm mode on just the cpus
> that are seeing it on a multi-socket system without having to check
> topology data ... which should be better for the case where a noisy
> source of CMCI is plaguing one socket, while other sockets have some
> much lower rate of CMCI that we'd still like to log.

I thought more about it - see my patch. So I have a global state now
as well, but it's only making sure that stuff stays in poll mode as
long as others are in poll mode. That's good I think as you avoid the
following:

cmcis which affect siblings or a socket are delivered to all affected
cores, but only one core might see the bank. So all others would
reenable fast and then switch back to polling because the storm still
persists. This would ping pong so, we probably want to avoid it.

Ideally the storm_on_cpus variable should be per socket and not system
wide, but we can do that when it really becomes an issue.

Thanks,

	tglx
