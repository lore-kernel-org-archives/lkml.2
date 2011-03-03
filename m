Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab1CCIpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:45:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1CCIpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:45:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peppe CAVALLARO <peppe.cavallaro@st.com>
Subject: Re: [PATCH (sh-2.6) 1/4] clksource: Generic timer infrastructure
Date: Thu, 3 Mar 2011 09:45:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Stuart MENEFY <stuart.menefy@st.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
References: <1298369864-24429-1-git-send-email-peppe.cavallaro@st.com> <alpine.LFD.2.00.1103011630080.2701@localhost6.localdomain6> <4D6E7FD7.1060408@st.com>
In-Reply-To: <4D6E7FD7.1060408@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103030945.07486.arnd@arndb.de>
X-Provags-ID: V02:K0:omhT1mGGQgjoc4bALXNA56KhU2YEcZoKXillQT7Y4tR
 RtOhQ+rutfUtgczX0AWSLVcIn6FKbd68rLgqML6uestunirPQM
 JY66QEUkt4sujT9YQeLCVCGsUxkdiNonBGZNAtYVS6WJHVXkV1
 O03yX73dK7Hznq+xorUWfGYJxTV4aMCioAY4J3lBCrMom1qY0w
 Tj/EG7960HX8caVvSmfgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 March 2011, Peppe CAVALLARO wrote:
> At any rate, I am happy to use the stmmac as experimental
> driver to do this kind tests.
> Indeed, in the past, on old Kernel (IIRC 2.6.23), I tried to use
> the kernel timers but I removed the code from it because
> I had noticed packets loss and a strange phenomenon with cyclesoak
> (that showed broken sysload % during the heavy network activities).
> 
> Let me know how to proceed:
> 
> 1) experiment with stmmac and hrtimer for handling rx/tx?
> 2) rework the patches for the Generic Timer Infra?

I'd suggest doing the first. I'm surprised that using an unrelated
timer for processing interrupts even helps you on stmmac.

The timers that you'd normally use for rx interrupt mitigation
are not periodic timers but are started when a packet arrives
from the outside.

Doing periodic wakeups for RX instead of just waiting for
packets to come in should have a significant impact on power
management on an otherwise idle system.

For tx resource reclaim, a relatively slow oneshot timer (not
even hrtimer) should be good enough, since it only needs to be
active when there is no other way to clean up. E.g. when you
are in napi polling mode (interrupt disabled), you know that
stmmac_poll gets called soon, and you can also do the reclaim
from stmmac_xmit() in order to prevent the timer from triggering
when you are constantly transmitting.

	Arnd
