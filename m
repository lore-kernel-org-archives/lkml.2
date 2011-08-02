Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1HBJFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:05:45 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35266 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1HBJFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110731170451.GC2975@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<96781d46e41fa6ffc04b88527a25d73f5a59eda8.1311936524.git.viresh.kumar@st.com>
	<20110730120740.GA15791@n2100.arm.linux.org.uk>
	<20110730130537.GB15791@n2100.arm.linux.org.uk>
	<CAKnu2MqTYF43wW3axM--jXdtvsCyRBTLEHDc3hPoJYAmTAL5UA@mail.gmail.com>
	<CAKnu2MppEKxZD2Z77tfShMfG80d-Xx26yBGhZtJkJ2C6SjE=1w@mail.gmail.com>
	<20110731170451.GC2975@n2100.arm.linux.org.uk>
Date: Tue, 2 Aug 2011 11:05:38 +0200
Message-ID: <CACRpkdZTsD=7woN1qV-sFpsJTyT0LQBq+q=xTOwuewAk=ijBjQ@mail.gmail.com>
Subject: Re: [PATCH 07/18] dmaengine/amba-pl08x: Enable/Disable amba_pclk with
 channel requests
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@st.com>, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, armando.visconti@st.com,
        bhupesh.sharma@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
        amit.virdi@st.com, vipulkumar.samar@st.com, viresh.linux@gmail.com,
        deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 7:04 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Jul 31, 2011 at 02:04:47AM +0200, Linus Walleij wrote:
>>
>> ..and while it will just cause some double refcounts on the clock,
>> it makes sense to delete the pclk manipulation from the PL022
>> driver code as part of the patch, like this:
>
> Yes, this looks fine.  Shall I wrap it up as part of my patch?

Yes please.
Acked-by.

> Two other things I've spotted in this driver are:
>
> 1. The remove function doesn't undo what the probe function did to
> the pclk and vcore.  It needs to keep things balanced.  For a driver
> which doesn't manage its pclk, this is what happens:
>        - core gets pclk
>        - core enables pclk
>        - core calls driver's probe
>                - driver sets stuff up
> ...
>        - core calls driver's remove
>                - driver tidies up
>        - core disables pclk
>        - core puts pclk
>
> And PL022 does this:
>        - core gets pclk
>        - core enables pclk
>        - core calls driver's probe
>                - driver sets stuff up
>                - driver disables pclk
> ...
>        - core calls driver's remove
>                - driver tidies up
>        - core disables pclk
>        - core puts pclk
>
> Notice the double-disable of pclk in that sequence.  If ->probe disables
> pclk, ->remove needs to return with that disable balanced with an enable.

Ah yes. Can you fix this as part of the patch since it's pretty related?
Much appreciated if you do.

> 2. It thinks it can refuse 'remove' by returning an error code.  This
> is false.  removes can't be aborted - here's the code from drivers/base/dd.c:
>
> static void __device_release_driver(struct device *dev)
> {
> ...
>                if (dev->bus && dev->bus->remove)
>                        dev->bus->remove(dev);
>                else if (drv->remove)
>                        drv->remove(dev);
> ...
> }
>
> Notice how return codes go nowhere.  remove should _really_ be a void
> function to stop people thinking that it can be aborted.  It can't.

Correct, thanks for spotting this. I'll send a separate patch to Grant
fixing this up.

Yours,
Linus Walleij
