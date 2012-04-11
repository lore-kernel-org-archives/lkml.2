Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab2DKVNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:13:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:33108 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2DKVNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:13:35 -0400
Date: Wed, 11 Apr 2012 23:13:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Witten <mfwitten@gmail.com>
cc: Arjan van de Ven <arjanvandeven@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        John Stultz <johnstul@us.ibm.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: Load the ACPI PM clocksource
 asynchronously
In-Reply-To: <041683e0088341c2b6d78e97f05948eb-mfwitten@gmail.com>
Message-ID: <alpine.LFD.2.02.1204112303270.2542@ionos>
References: <20120130205120.652aa64f@infradead.org>            <717f591b21b34ebea5793c6206b8a2b8-mfwitten@gmail.com>            <CADyApD2UZebJd_nSJHAWkjz=PT4_DZfnSr38geqUb1kvJzKi-g@mail.gmail.com> <041683e0088341c2b6d78e97f05948eb-mfwitten@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012, Michael Witten wrote:
> On Sun, 8 Apr 2012 19:20:22 -0700, Arjan van de Ven wrote:
> 
> >> to which I bisected as the culprit for very strange load balance
> >> behavior on my machine.
> >>
> >> With this patch in place, my CPU is constantly being pegged at 100%
> >> (and my CPU monitor sometimes registers NaN%), regardless of the
> >> active governor and under conditions when my computer would normally
> >> be idling quite placidly.
> >>
> >> Reverting this commit does indeed remove the problem from previously
> >> problematic builds.
> >>
> >>
> > any chance of a dmesg? (or even better, a diff of the dmesg from
> > abefore and fter)
> 
> Doh! I should have thought of that.
> 
> The dmesg output for a kernel built from your patch's commit yields
> this interesting line:
> 
>   PM-Timer running at invalid rate: 113% of normal - aborting.

Duh. The original code does this with interrupts disabled and not from
the context of some random worker thread.

Aside of that, this will blow up if something else touches the CTC
channel 2, which is possible as this code runs async to other init
stuff.

Arjan, did you ever verify that patch extensivly on hardware which
relies on the PM-Timer? I doubt it. :(

There is no other choice than reverting it.

Thanks,

	tglx
