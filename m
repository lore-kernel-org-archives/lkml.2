Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab1BUHGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 02:06:08 -0500
Received: from smtp-out.google.com ([74.125.121.67]:61382 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab1BUHGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 02:06:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EnTmcguUM2Yh5mWlY8DTaPEY53YX5OjAMJm94Tp29oGZbcWEo76oSck9XusecWKl5s
         3wK8rHf4NVEqoM+c7tPg==
MIME-Version: 1.0
In-Reply-To: <AANLkTin8AmjM2CWoNh54NmyV6=298bGzDUPO+j4LTrBj@mail.gmail.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-16-git-send-email-ccross@android.com>
	<AANLkTin8AmjM2CWoNh54NmyV6=298bGzDUPO+j4LTrBj@mail.gmail.com>
Date: Sun, 20 Feb 2011 23:06:01 -0800
X-Google-Sender-Auth: gwu3ohcDDh0RTyUsu_UNV9yIKc0
Message-ID: <AANLkTin5O-dbKhwkBmsZVYCJM=qg=QY=N1w4Zc++6qY4@mail.gmail.com>
Subject: Re: [PATCH v2 14/21] ARM: tegra: clock: Refcount periph clock enables
From: Colin Cross <ccross@android.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 8:18 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:
>> Some peripheral clocks share enable bits.  Refcount the enables so
>> that calling clk_disable on one clock will not turn off another
>> clock.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>  arch/arm/mach-tegra/tegra2_clocks.c |   35 +++++++++++++++++++++++++++++------
>>  1 files changed, 29 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
>> index 196c249..2734889 100644
>> --- a/arch/arm/mach-tegra/tegra2_clocks.c
>> +++ b/arch/arm/mach-tegra/tegra2_clocks.c
>> @@ -154,6 +154,12 @@ static void __iomem *reg_pmc_base = IO_ADDRESS(TEGRA_PMC_BASE);
>>  */
>>  static DEFINE_SPINLOCK(clock_register_lock);
>>
>> +/*
>> + * Some peripheral clocks share an enable bit, so refcount the enable bits
>> + * in registers CLK_ENABLE_L, CLK_ENABLE_H, and CLK_ENABLE_U
>> + */
>> +static int tegra_periph_clk_enable_refcount[3 * 32];
>
> Given that this is always locked when incrementing/decrementing,
> should it just be switched to an array of atomics instead?
No, the spinlock needs to be held between the increment/decrement and
test and the actual register write.  The spinlock release in the
enable function needs to be moved after the register write.
