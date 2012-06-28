Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2F1Vbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:31:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38907 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2F1Vbt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZJwocwwFUeVte+NTN83LRaiBvis9nHWV0KUj9htsDoQg@mail.gmail.com>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
	<1340232467-6023-12-git-send-email-john.stultz@linaro.org>
	<CACRpkdZJwocwwFUeVte+NTN83LRaiBvis9nHWV0KUj9htsDoQg@mail.gmail.com>
Date: Thu, 28 Jun 2012 14:31:47 -0700
Message-ID: <CAMP5XgceDFLrk3a1yfPHiap56Nvc2XOyvmS9yOrJ9ULVYLbGeQ@mail.gmail.com>
Subject: Re: [PATCH 11/15] ARM: etm: Check arch version and disable data
 tracing for ptm
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 9:07 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Jun 21, 2012 at 12:47 AM, John Stultz <john.stultz@linaro.org> wrote:
>
>> +#define ETMR_ID                        0x1e4
>> +#define ETMIDR_VERSION(x)      (((x) >> 4) & 0xff)
>> +#define ETMIDR_VERSION_PFT_1_0 0x30
>
> NAK don't reinvent this stuff.
>
> From <linux/amba/bus.h>
>
> Use these macros on the periphid:
> #define amba_config(d)  AMBA_CONFIG_BITS((d)->periphid)
> #define amba_rev(d)     AMBA_REV_BITS((d)->periphid)
> #define amba_manf(d)    AMBA_MANF_BITS((d)->periphid)
> #define amba_part(d)    AMBA_PART_BITS((d)->periphid)
>

Those values do not come from the same register. The revision is
duplicated there, but I did not find the major and minor etm version
which is what I'm looking at. Also, if these values are set in the
amba_device before calling amba_device_register the hardware registers
are not read at all and the information could be from an older
hardware rev than what you are currently running on.

> I thin amba_rev() is the one you're looking for (not sure).
>
> So here:
>
>> @@ -724,6 +724,9 @@ static int __devinit etm_probe(struct amba_device *dev, const struct amba_id *id
>
>> +       if (etmccr & ETMCCR_ETMIDR_PRESENT) {
>> +               etmidr = etm_readl(t, t->etm_regs_count, ETMR_ID);
>> +               etm_version = ETMIDR_VERSION(etmidr);
>
> etm_version = amba_rev(dev);
>
> etc.
>
> Yours,
> Linus Walleij



-- 
Arve Hjønnevåg
