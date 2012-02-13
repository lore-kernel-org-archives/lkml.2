Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab2BMTy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:54:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57191 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766Ab2BMTy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:54:26 -0500
MIME-Version: 1.0
In-Reply-To: <87d39xj955.fsf@rustcorp.com.au>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
	<1328055439-9441-1-git-send-email-venki@google.com>
	<20120201140125.c656df41.akpm@linux-foundation.org>
	<87d39xj955.fsf@rustcorp.com.au>
Date: Mon, 13 Feb 2012 11:54:26 -0800
Message-ID: <CA+8MBbJcTgj7X-7RZAgWk8a3Qyaz1FxFzu3ZLk-8LHKD7M8h-Q@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v5
From: Tony Luck <tony.luck@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 12:03 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> IIRC playing with 3 archs boot code seemed like a recipe for disaster.
> Feel free to try to fix this in -next though, and see what breaks...

ia64 is what breaks ... well not actually broken ... but some very
weird delays that
show up in different places depending on whether this patch is present.

First linux-next kernel to be blessed with this patch was
next-20120210. Booting it
I see:
[    7.164233] Switching to clocksource itc
[  146.077315] pnp: PnP ACPI init

An ugly 138.913 second delay.  Digging in the code showed that the bad bits
happened inside stop_machine()

Reverting just this patch makes this big delay disappear:

[   32.780232] Switching to clocksource itc
[   32.832100] pnp: PnP ACPI init

but notice that it takes 25 extra seconds to get to this point in the
boot (and while
we expect to save some time by not re-computing num_online_cpus each time we
need it ... this looks to be a lot more than I'd expect!)

-Tony
