Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1LISc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:32:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38375 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1LISc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:32:26 -0500
MIME-Version: 1.0
In-Reply-To: <20111209091319.GI27578@tbergstrom-lnx.Nvidia.com>
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
	<1323348254-29072-4-git-send-email-pdeschrijver@nvidia.com>
	<CAMbhsRT97Oq-=8f9++f6Jgg=YVaimKSz68xcDDNbDbvL+V5fJg@mail.gmail.com>
	<20111209091319.GI27578@tbergstrom-lnx.Nvidia.com>
Date: Fri, 9 Dec 2011 10:32:25 -0800
X-Google-Sender-Auth: 85A4XKOl_wqhidcD2ttR8J_BNEw
Message-ID: <CAMbhsRSBtkOybN+SDgQyjHZffUT=YxeQ1YnSd52WPS0BL+q=HA@mail.gmail.com>
Subject: Re: [PATCH v6 03/10] arm/tegra: prepare clock code for multiple tegra variants
From: Colin Cross <ccross@android.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Gary King <gking@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 1:13 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> On Thu, Dec 08, 2011 at 07:25:53PM +0100, Colin Cross wrote:
>> On Thu, Dec 8, 2011 at 4:43 AM, Peter De Schrijver <pdeschrijver@nvidia.com<mailto:pdeschrijver@nvidia.com>> wrote:
>> Rework the tegra20 clock code to support multiple tegra variants :
>>
>>  * remove tegra2_periph_reset_assert/tegra2_periph_reset_deassert. This
>>   functionality should be in clock.c.
>>  * compile tegra_sdmmc_tap_delay only on tegra20 as this feature will not
>>   be available in future variants.
>>  * don't export clk_measure_input_freq as its functionality is also available
>>   using clk_get_rate().
>>
>> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com<mailto:pdeschrijver@nvidia.com>>
>> ---
>>  arch/arm/mach-tegra/clock.c         |   12 +++++++-----
>>  arch/arm/mach-tegra/clock.h         |    8 ++++----
>>  arch/arm/mach-tegra/tegra2_clocks.c |   14 +-------------
>>  arch/arm/mach-tegra/timer.c         |   12 ++++++++----
>>  4 files changed, 20 insertions(+), 26 deletions(-)
>>
>> diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
>> index f8d41ff..f27bdcc 100644
>> --- a/arch/arm/mach-tegra/clock.c
>> +++ b/arch/arm/mach-tegra/clock.c
>> @@ -387,13 +387,15 @@ EXPORT_SYMBOL(tegra_clk_init_from_table);
>>
>>  void tegra_periph_reset_deassert(struct clk *c)
>>  {
>> -       tegra2_periph_reset_deassert(c);
>> +       BUG_ON(!c->ops->reset);
>> +       c->ops->reset(c, false);
>>  }
>>  EXPORT_SYMBOL(tegra_periph_reset_deassert);
>>
>>  void tegra_periph_reset_assert(struct clk *c)
>>  {
>> -       tegra2_periph_reset_assert(c);
>> +       BUG_ON(!c->ops->reset);
>> +       c->ops->reset(c, true);
>>  }
>>  EXPORT_SYMBOL(tegra_periph_reset_assert);
>>
>> @@ -403,9 +405,9 @@ void __init tegra_init_clock(void)
>>  }
>>
>>  /*
>> - * The SDMMC controllers have extra bits in the clock source register that
>> - * adjust the delay between the clock and data to compenstate for delays
>> - * on the PCB.
>> + * The SDMMC controllers on tegra20 have extra bits in the clock source
>> + * register that adjust the delay between the clock and data to compenstate
>> + * for delays on the PCB.
>>  */
>>  void tegra_sdmmc_tap_delay(struct clk *c, int delay)
>>  {
>>
>> I created this wrapper around tegra2_sdmmc_tap_delay because I guessed the same requirement would be present in tegra3.  If you don't expect this to be required on anything but tegra2, you could drop the wrapper and just have callers use tegra2_sdmmc_tap_delay.
>>
>
> I will ask around if this is needed for tegra30.
>
>> diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
>> index 688316a..135bb5f 100644
>> --- a/arch/arm/mach-tegra/clock.h
>> +++ b/arch/arm/mach-tegra/clock.h
>> @@ -146,15 +146,15 @@ struct tegra_clk_init_table {
>>  };
>>
>>  void tegra2_init_clocks(void);
>> -void tegra2_periph_reset_deassert(struct clk *c);
>> -void tegra2_periph_reset_assert(struct clk *c);
>>  void clk_init(struct clk *clk);
>>  struct clk *tegra_get_clock_by_name(const char *name);
>> -unsigned long clk_measure_input_freq(void);
>>  int clk_reparent(struct clk *c, struct clk *parent);
>>  void tegra_clk_init_from_table(struct tegra_clk_init_table *table);
>>  unsigned long clk_get_rate_locked(struct clk *c);
>>  int clk_set_rate_locked(struct clk *c, unsigned long rate);
>> +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
>>  void tegra2_sdmmc_tap_delay(struct clk *c, int delay);
>> -
>> +#else
>> +#define tegra2_sdmmc_tap_delay(c, d) do {} while(0);
>>
>> It's more standard to use an empty static inline function here.
>>
>
> clock.h is included in several board files. So making this a static inline
> function results in a number of 'static function declared but not used'
> warnings.

That's true for "static", but not for "static inline".  Look at a
commonly used header like include/kernel.h, it's full of static
inlines that are not used by most of the includers.
