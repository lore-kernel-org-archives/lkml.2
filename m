Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1LXGkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 01:40:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59847 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1LXGkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 01:40:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAMDbWJG4u62qmBgxhaYZCuL+5897defC1cy5tNMd+M+9BhWS+g@mail.gmail.com>
References: <CAMDbWJG4u62qmBgxhaYZCuL+5897defC1cy5tNMd+M+9BhWS+g@mail.gmail.com>
From: Phil Miller <mille121@illinois.edu>
Date: Sat, 24 Dec 2011 00:40:25 -0600
X-Google-Sender-Auth: L535ISubYQ5uzQ6ALUGdKGdE1rA
Message-ID: <CAMDbWJGjGo4BVpL+vwZJgBBJxradjzp2gvwVUqk-H9CvCL6XFg@mail.gmail.com>
Subject: Re: [REGRESSION,STABLE,BISECTED] Hang on resume from standby in
 3.1.[56], 3.2-rc*
To: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <greg@kroah.com>,
        stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just went digging through the history, and it looks like the commit
I found to be problematic partially reverts
7c1e76897492d92b6a1c2d6892494d39ded9680c, from 2008.

On Fri, Dec 23, 2011 at 11:31, Phil Miller <mille121@illinois.edu> wrote:
> I've got a Dell Precision T1500 (lspci, dmidecode, and dmesg output at
> http://charm.cs.uiuc.edu/~phil/linux-suspend-hang/ ) that I generally
> suspend when I'm out of the house or asleep, and wake up when I want
> to use it. Sadly, a recent change to the kernel has disrupted that
> happy state of affairs. When I run the most recent stable or
> pre-release versions, the kernel hangs on resume. I can still switch
> virtual consoles, and get keyboard output echoed to the screen, but no
> userspace code seems to be running (e.g. login doesn't give me a
> password prompt after entering a username), nor does the system
> respond to ping or SSH connections.
>
> Bisection between v3.1 and v3.1.6 points to the following commit as the culprit:
> =====
> commit aeed6baa702a285cf03b7dc4182ffc1a7f4e4ed6
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Dec 2 16:02:45 2011 +0100
>
>    clockevents: Set noop handler in clockevents_exchange_device()
>
>    commit de28f25e8244c7353abed8de0c7792f5f883588c upstream.
>
>    If a device is shutdown, then there might be a pending interrupt,
>    which will be processed after we reenable interrupts, which causes the
>    original handler to be run. If the old handler is the (broadcast)
>    periodic handler the shutdown state might hang the kernel completely.
>
>    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> :040000 040000 1cfa477e4be68746d7ef2818a430d50424b06572
> ccd4ef67437a19acba03df2debac6eb8c5957b30 M      kernel
> =====
>
> I've tested that reverting this commit also restores my ability to
> resume from suspend on 3.2-rc6.
>
> If there's anything else I can do to help diagnose this issue or get
> it fixed, I'm happy to help.
>
> Thanks.
>
> Phil
