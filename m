Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1CAQnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:43:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab1CAQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:43:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stuart Menefy <stuart.menefy@st.com>
Subject: Re: [PATCH (sh-2.6) 1/4] clksource: Generic timer infrastructure
Date: Tue, 1 Mar 2011 17:43:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Peppe CAVALLARO <peppe.cavallaro@st.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <1298369864-24429-1-git-send-email-peppe.cavallaro@st.com> <201102241820.55873.arnd@arndb.de> <4D6D0EA3.9000504@st.com>
In-Reply-To: <4D6D0EA3.9000504@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011743.19847.arnd@arndb.de>
X-Provags-ID: V02:K0:Ruo9ry3YiV1len4qCJjAiC7ENYvpcnZgIG78mN5DbkT
 Pv4GpONduLHJ9DKD5TN2+nXdNR9WEoNpTvwmVtwvRlp8yU0elR
 X36zw5iV5YUnRs1UZZK4YGLghhE09lu86/txWwmhhbly9dqGBw
 kVpaTGqpC3i9MefK0DFiNUe0zXA5l3A6WoU1C6fZodKkg8eb95
 PI0LbQ7lDS+Yd7ijTBKMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 March 2011, Stuart Menefy wrote:
> On 24/02/11 17:20, Arnd Bergmann wrote:
>
> > Why is this code useful to you? In the scenarios I've seen, the
> > board can always assign a timer to a specific device in a fixed
> > way that can be describe in a board file or device tree.
> 
> What we were trying to do was separate the code which actually manipulates
> the timer hardware from the code which wants that timer service. In this
> case it was a network device driver which is used on multiple SoC devices,
> while the timer hardware tends to differ from device to device.

Right. It certainly makes sense to have an well-defined interface between
the user and the provider of a timer interrupt.

> The other user of this code which we have is an OProfile driver, which
> with this change can now be independent of the hardware it is running on,
> while the previous version manipulated the timer hardware directly.

Ok.

> > Also, what is the difference between this and clkdev?
> 
> clkdev can be used to find a struct clk, which is fine if you just want to
> read the time. In this instance we want to get interrupts from the timer
> hardware, which isn't supported by the clk infrastructure.

(adding Russell to Cc)

Is this something that could sensibly be added to clk/clkdev?

> If anything this duplicates clockevents. The main reason for not using
> clockevents was that nobody else does! Currently clockevents are
> used strictly for time keeping within the kernel, and most architectures
> only register those which are intended to be used for this purpose.
> We felt a bit nervous about adding code to register all the device's timers
> as clockevents, and having the network device driver pick up one of those
> for its own use.

I see. Using a clock_event_device for anything but the system timer tick
is currently not supported, so it certainly would not be straightforward.

I think you need a bit of both, clkdev and clockevent. I think the
options you have are:

1. copy the clkdev code to make it possible to associate a device with
a periodic timer.
2. extend the clkdev/clk code to handle periodic interrupts and reuse
the infrastructure there.
3. extend the clockevent code to make it possible for regular device
drivers to use a clockevent source.

I have no idea which makes the most sense (or if there are other ideas).
Maybe Russell, Thomas or John can comment.

	Arnd
