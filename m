Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2ISDbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:31:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63351 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2ISDbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:31:05 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYnW=VbR1ieF1oicdPF79jV2raX9xkccE_ndrxQQjkUqw@mail.gmail.com>
References: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
	<CACRpkdbHegZAw+9XXzOb5UPPqJvzoNfPJ5aPDhuwWWhWunuv8w@mail.gmail.com>
	<CAOh2x==GY6xvyWmLJtpR68x1kiFWO8F85RwS6VfHjJA8YdhgvA@mail.gmail.com>
	<CACRpkdYnW=VbR1ieF1oicdPF79jV2raX9xkccE_ndrxQQjkUqw@mail.gmail.com>
Date: Wed, 19 Sep 2012 09:01:04 +0530
X-Google-Sender-Auth: 9hynhRangcNaUb4YlcmorCF7b7M
Message-ID: <CAOh2x=kH2pmF0oh+Rfna+0JmM+X433vB_TyhPJUhQg9B5r1evA@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: Add clk_{un}prepare() support in runtime PM
From: viresh kumar <viresh.kumar@linaro.org>
To: Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinit Shenoy <vinit.shenoy@st.com>
Cc: spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 5:20 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Sep 18, 2012 at 6:09 AM, viresh kumar <viresh.kumar@linaro.org> wrote:
>
>> Yes, we don't need to call prepare() again atleast for SPEAr. You are correct.
>> I saw the driver after a long time :)
>
> I'm asking because it's actually OK to do this, I was more asking whether it
> was really needed by any platforms...

Yes, I got that. Patch from Vipul is correct and should be there for
any platforms
which do anything in prepare/unprepare. But Atleast for SPEAr we don't need it.
But i would still insist in keeping it for completeness. :)

> We clk_disable() at runtime_suspend() and clk_enable() at runtime resume,
> and the driver gives hints to the runtime PM layer to autosuspend the
> driver whenever it's unused. Check the pm_runtime_* calls.

Ahh.. How could i miss it.

>> The amba layer is taking care of interface clock only and not
>> functional clock. So
>> i believe that's not the magic code. :)
>
> This clock is the one for the external bus. In some designs these two
> clocks are one and the same, and these won't currently get into any clock
> disabled states, sadly. (We need to fix that some day.)

I went through the code and found following in amba/bus.c:


static int amba_pm_runtime_suspend(struct device *dev)
{
	struct amba_device *pcdev = to_amba_device(dev);
	int ret = pm_generic_runtime_suspend(dev);

	if (ret == 0 && dev->driver)
		clk_disable(pcdev->pclk);

	return ret;
}

static int amba_pm_runtime_resume(struct device *dev)
{
	struct amba_device *pcdev = to_amba_device(dev);
	int ret;

	if (dev->driver) {
		ret = clk_enable(pcdev->pclk);
		/* Failure is probably fatal to the system, but... */
		if (ret)
			return ret;
	}

	return pm_generic_runtime_resume(dev);
}

If i am not wrong, these routines also get called with runtiime suspend/resume
of pl022? If that is the case, the even the interface clock of pl022 is getting
disabled when not in used.

And so for Architectures like SPEAr (where functional and interface
clock are controlled
by a single bit), we don't need anything else for power saving, with
respect to clocks.
Isn't it so?

@Vipul/Vinit: Can you please confirm this behavior?

--
viresh
