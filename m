Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab2AREp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:45:28 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60437 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756925Ab2AREp0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:45:26 -0500
MIME-Version: 1.0
In-Reply-To: <4F1586E0.1060308@pengutronix.de>
References: <1326711025-6629-1-git-send-email-realmz6@gmail.com>
	<4F1538F1.8020508@grandegger.com>
	<CAMk6uBnoQwuo2LwcSD4hucn9bM9vqEVNEM3L9PLqmX-BgD30iA@mail.gmail.com>
	<4F153F16.8060603@grandegger.com>
	<CAMk6uBn87VjAJPPXUSG6G6_21Ov1tT6k=NkENm+9ZhRnsXNExQ@mail.gmail.com>
	<4F154A3C.3010502@grandegger.com>
	<CAMk6uBmJ5DqE3BDtZQBpfbp0s7pC=j0JuVzgbxCPh-jWA76Ofw@mail.gmail.com>
	<4F154CB1.4090307@pengutronix.de>
	<4F1586E0.1060308@pengutronix.de>
Date: Wed, 18 Jan 2012 12:45:23 +0800
Message-ID: <CAMk6uBkrjaXUrGD69-Wg0QLHR8AmShyxUAFQgOZcOLi1aD-7CA@mail.gmail.com>
Subject: Re: [PATCH] socket-can: bit-timing calculation
From: realmz paranoid <realmz6@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Tue, Jan 17, 2012 at 10:34 PM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> Hello,
>
> Realmz Paranoid, a hint from David Miller:
>> Nobody is seeing any of your postings because of "open list: NETWORKING
>> DRIVERS" stuff in the email headers.
>
> On 01/17/2012 11:25 AM, Marc Kleine-Budde wrote:
>> On 01/17/2012 11:18 AM, realmz paranoid wrote:
>> [...]
>>
>>>>>> This is worse because it does not find the best match. The first
>>>>>> match might not be the best.
>>>>>>
>>>>>> I got it, because the tseg1_max and tseg2_max limit, the first found
>>>> best
>>>>> error will not get the best sample point on some hardware.
>>>>> So I'd tweak the blackfin can code.
>>>>
>>>> The algorithm does *not* work well for all configs, especially when the
>>>> clock frequency is not a multiple of 8 MHz. Instead of tweaking the
>>>> algorithm just for your hardware it does make more sense to provide the
>>>> parameters manually using "tq= ...". Also setting "sjw > 1" helps if the
>>>> bit-timing is not optimal.
>>
>> I've an improved version (somewhere) that minimizes sample point error,
>> too. Give me some minutes to find it.
>
> Here it is. Wolfgang wrote the can-calc-bit-timing tool, which he used to generate
> the table in the other mail. It's part of can-utils. I've pushed my improvement
> to my repo (better-bitrate-calculation branch):
>
> https://gitorious.org/~bet-frogger/linux-can/mkl-can-utils
>
> Here's the patch:
>
> From 4df04420f128ec326e536fe55fc819b893a5c9ef Mon Sep 17 00:00:00 2001
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Date: Sat, 15 May 2010 18:26:03 +0200
> Subject: [PATCH] can-calc-bit-timing: better sample point calculation
>
> This patch tries to optimize the calculation of the sample point. To
> understand what it does have a look at the original implementation.
>
> If there is a combination of timing parameters where both the bitrate
> and sample point error are 0 the current implementation has a pretty
> good change of finding it (maybe it will always do, but I'm to lazy
> to proof this).
>
> However if the reference clock doesn't allow an optimal bitrate (this
> means  the bitrate error is always != 0) there might be several timing
> parameter combinations having the same bitrate error. The original
> implementation will allways choose the one with the highest brp. The
> actual sample point error isn't taken into account.
>
> This patch changes the algorithm to minimize the sample point error,
> too. Now a brp/tseg combination is accepted as better if one of these
> condition are fulfilled:
> 1) the bit rate error must be smaller, or
> 2) the bit rate error must be equal and
>   the sample point error must be equal or smaller
>
> If a smaller bit rate error is found the sample point error is reset.
> This ensures that we first optimize for small bit rate error and then
> for small sample point errors.
>
> The following diff shows the sample point error improvements.
>
> --- orig.txt    2010-05-17 00:10:21.000000000 +0200
> +++ new.txt     2010-05-17 00:10:05.000000000 +0200
> @@ -27,9 +27,9 @@
>  Bit timing parameters for mscan with 33.000000 MHz ref clock
>  nominal                                 real Bitrt   nom  real SampP
>  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP Bitrate Error SampP SampP Error BTR0 BTR1
>  1000000     90   3    4    3   1   3 1000000  0.0% 75.0% 72.7%  3.1% 0x02 0x26
> - 800000    181   2    2    2   1   6  785714  1.8% 80.0% 71.4% 10.8% 0x05 0x13
> + 800000     90   5    5    3   1   3  785714  1.8% 80.0% 78.5%  1.9% 0x02 0x29
>  500000    181   4    4    2   1   6  500000  0.0% 87.5% 81.8%  6.5% 0x05 0x17
>  250000    333   4    5    2   1  11  250000  0.0% 87.5% 83.3%  4.8% 0x0a 0x18
>  125000    666   4    5    2   1  22  125000  0.0% 87.5% 83.3%  4.8% 0x15 0x18
>  100000    666   6    6    2   1  22  100000  0.0% 87.5% 86.6%  1.0% 0x15 0x1b
> @@ -40,12 +40,12 @@
>  Bit timing parameters for mscan with 33.300000 MHz ref clock
>  nominal                                 real Bitrt   nom  real SampP
>  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP Bitrate Error SampP SampP Error BTR0 BTR1
>  1000000     90   3    4    3   1   3 1009090  0.9% 75.0% 72.7%  3.1% 0x02 0x26
> - 800000    180   2    2    2   1   6  792857  0.9% 80.0% 71.4% 10.8% 0x05 0x13
> + 800000     90   5    5    3   1   3  792857  0.9% 80.0% 78.5%  1.9% 0x02 0x29
>  500000    180   4    4    2   1   6  504545  0.9% 87.5% 81.8%  6.5% 0x05 0x17
> - 250000    570   2    2    2   1  19  250375  0.1% 87.5% 71.4% 18.4% 0x12 0x13
> - 125000   1141   2    2    2   1  38  125187  0.1% 87.5% 71.4% 18.4% 0x25 0x13
> + 250000    210   7    8    3   1   7  250375  0.1% 87.5% 84.2%  3.8% 0x06 0x2e
> + 125000    570   5    6    2   1  19  125187  0.1% 87.5% 85.7%  2.1% 0x12 0x1a
>  100000   1111   3    3    2   1  37  100000  0.0% 87.5% 77.7% 11.2% 0x24 0x15
>   50000   1111   7    7    3   1  37   50000  0.0% 87.5% 83.3%  4.8% 0x24 0x2d
>   20000 ***bitrate not possible***
>   10000 ***bitrate not possible***
> @@ -53,12 +53,12 @@
>  Bit timing parameters for mscan with 33.333333 MHz ref clock
>  nominal                                 real Bitrt   nom  real SampP
>  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP Bitrate Error SampP SampP Error BTR0 BTR1
>  1000000     90   3    4    3   1   3 1010101  1.0% 75.0% 72.7%  3.1% 0x02 0x26
> - 800000    180   2    2    2   1   6  793650  0.8% 80.0% 71.4% 10.8% 0x05 0x13
> + 800000     90   5    5    3   1   3  793650  0.8% 80.0% 78.5%  1.9% 0x02 0x29
>  500000    180   4    4    2   1   6  505050  1.0% 87.5% 81.8%  6.5% 0x05 0x17
> - 250000    570   2    2    2   1  19  250626  0.3% 87.5% 71.4% 18.4% 0x12 0x13
> - 125000   1140   2    2    2   1  38  125313  0.3% 87.5% 71.4% 18.4% 0x25 0x13
> + 250000    210   7    8    3   1   7  250626  0.3% 87.5% 84.2%  3.8% 0x06 0x2e
> + 125000    570   5    6    2   1  19  125313  0.3% 87.5% 85.7%  2.1% 0x12 0x1a
>  100000   1110   3    3    2   1  37  100100  0.1% 87.5% 77.7% 11.2% 0x24 0x15
>   50000    870   8    8    6   1  29   49975  0.1% 87.5% 73.9% 15.5% 0x1c 0x5f
>   20000 ***bitrate not possible***
>   10000 ***bitrate not possible***
> @@ -78,12 +78,12 @@
>
>  Bit timing parameters for at91 with 99.532800 MHz ref clock
>  nominal                                 real Bitrt   nom  real SampP
>  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP Bitrate Error SampP SampP Error     CAN_BR
> -1000000    100   3    3    3   1  10  995328  0.5% 75.0% 70.0%  6.7% 0x00090222
> +1000000     50   7    7    5   1   5  995328  0.5% 75.0% 75.0%  0.0% 0x00040664
>  800000     50   8    8    8   1   5  796262  0.5% 80.0% 68.0% 15.0% 0x00040777
> - 500000    251   2    3    2   1  25  497664  0.5% 87.5% 75.0% 14.3% 0x00180121
> - 250000    572   2    2    2   1  57  249455  0.2% 87.5% 71.4% 18.4% 0x00380111
> + 500000    100   8    8    3   1  10  497664  0.5% 87.5% 85.0%  2.9% 0x00090772
> + 250000    210   7    8    3   1  21  249455  0.2% 87.5% 84.2%  3.8% 0x00140672
>  125000    532   6    6    2   1  53  125198  0.2% 87.5% 86.6%  1.0% 0x00340551
>  100000    833   4    5    2   1  83   99932  0.1% 87.5% 83.3%  4.8% 0x00520341
>   50000    833   8    8    7   1  83   49966  0.1% 87.5% 70.8% 19.1% 0x00520776
>   20000 ***bitrate not possible***
> @@ -92,22 +92,22 @@
>  Bit timing parameters for flexcan with 49.875000 MHz ref clock
>  nominal                                 real Bitrt   nom  real SampP
>  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP Bitrate Error SampP SampP Error   CAN_CTRL
>  1000000    100   3    3    3   1   5  997500  0.2% 75.0% 70.0%  6.7% 0x04120002
> - 800000    180   2    2    2   1   9  791666  1.0% 80.0% 71.4% 10.8% 0x08090001
> - 500000    200   3    4    2   1  10  498750  0.2% 87.5% 80.0%  8.6% 0x09190002
> - 250000    501   2    3    2   1  25  249375  0.2% 87.5% 75.0% 14.3% 0x18110001
> + 800000    140   3    3    2   1   7  791666  1.0% 80.0% 77.7%  2.9% 0x06110002
> + 500000    100   8    8    3   1   5  498750  0.2% 87.5% 85.0%  2.9% 0x043a0007
> + 250000    200   8    8    3   1  10  249375  0.2% 87.5% 85.0%  2.9% 0x093a0007
>  125000    421   7    8    3   1  21  125000  0.0% 87.5% 84.2%  3.8% 0x143a0006
> - 100000   1002   3    4    2   1  50   99750  0.2% 87.5% 80.0%  8.6% 0x31190002
> + 100000    501   8    8    3   1  25   99750  0.2% 87.5% 85.0%  2.9% 0x183a0007
>   50000   1664   4    5    2   1  83   50075  0.1% 87.5% 83.3%  4.8% 0x52210003
>   20000   3568   5    6    2   1 178   20014  0.1% 87.5% 85.7%  2.1% 0xb1290004
>   10000   4350   8    8    6   1 217    9992  0.1% 87.5% 73.9% 15.5% 0xd83d0007
>
>  Bit timing parameters for flexcan with 66.500000 MHz ref clock
>  nominal                                 real Bitrt   nom  real SampP
>  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP Bitrate Error SampP SampP Error   CAN_CTRL
>  1000000     90   3    4    3   1   6 1007575  0.8% 75.0% 72.7%  3.1% 0x051a0002
> - 800000    180   2    2    2   1  12  791666  1.0% 80.0% 71.4% 10.8% 0x0b090001
> + 800000     90   5    5    3   1   6  791666  1.0% 80.0% 78.5%  1.9% 0x05220004
>  500000    105   7    8    3   1   7  500000  0.0% 87.5% 84.2%  3.8% 0x063a0006
>  250000    285   5    6    2   1  19  250000  0.0% 87.5% 85.7%  2.1% 0x12290004
>  125000    571   5    6    2   1  38  125000  0.0% 87.5% 85.7%  2.1% 0x25290004
>  100000    526   7    8    3   1  35  100000  0.0% 87.5% 84.2%  3.8% 0x223a0006
>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  can-calc-bit-timing.c |   71 +++++++++++++++++++++++++++----------------------
>  1 files changed, 39 insertions(+), 32 deletions(-)
>
> diff --git a/can-calc-bit-timing.c b/can-calc-bit-timing.c
> index f8c04ba..27bf41d 100644
> --- a/can-calc-bit-timing.c
> +++ b/can-calc-bit-timing.c
> @@ -1,6 +1,7 @@
>  /* can-calc-bit-timing.c: Calculate CAN bit timing parameters
>  *
>  * Copyright (C) 2008 Wolfgang Grandegger <wg@grandegger.com>
> + * Copyright (C) 2010 Marc Kleine-Budde <mkl@pengutronix.de>
>  *
>  * Derived from:
>  *   can_baud.c - CAN baudrate calculation
> @@ -372,18 +373,17 @@ static long common_bitrates[] = {
>  #define CAN_CALC_MAX_ERROR 50 /* in one-tenth of a percent */
>  static int can_update_spt(const struct can_bittiming_const *btc,
> -                         int sampl_pt, int tseg, int *tseg1, int *tseg2)
> +               unsigned int sampl_pt, unsigned int tseg,
> +               unsigned int *tseg1, unsigned int *tseg2)
>  {
>        *tseg2 = tseg + 1 - (sampl_pt * (tseg + 1)) / 1000;
> -       if (*tseg2 < btc->tseg2_min)
> -               *tseg2 = btc->tseg2_min;
> -       if (*tseg2 > btc->tseg2_max)
> -               *tseg2 = btc->tseg2_max;
> +       *tseg2 = clamp(*tseg2, btc->tseg2_min, btc->tseg2_max);
>        *tseg1 = tseg - *tseg2;
>        if (*tseg1 > btc->tseg1_max) {
>                *tseg1 = btc->tseg1_max;
>                *tseg2 = tseg - *tseg1;
>        }
> +
>        return 1000 * (tseg + 1 - *tseg2) / (tseg + 1);
>  }
>  @@ -391,11 +391,15 @@ static int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt)
>  {
>        struct can_priv *priv = netdev_priv(dev);
>        const struct can_bittiming_const *btc = priv->bittiming_const;
> -       long rate, best_rate = 0;
> -       long best_error = 1000000000, error = 0;
> -       int best_tseg = 0, best_brp = 0, brp = 0;
> -       int tsegall, tseg = 0, tseg1 = 0, tseg2 = 0;
> -       int spt_error = 1000, spt = 0, sampl_pt;
> +       long rate;              /* current bitrate */
> +       long rate_error;        /* difference between current and target value */
> +       long best_rate_error = 1000000000;
> +       int spt;                /* current sample point in thousandth */
> +       int spt_error;          /* difference between current and target value */
> +       int best_spt_error = 1000;
> +       int sampl_pt;           /* target sample point */
> +       int best_tseg = 0, best_brp = 0;        /* current best values for tseg and brp */
> +       unsigned int brp, tsegall, tseg, tseg1, tseg2;
>        u64 v64;
>        if (!priv->bittiming_const)
> @@ -417,48 +421,51 @@ static int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt)
>        for (tseg = (btc->tseg1_max + btc->tseg2_max) * 2 + 1;
>             tseg >= (btc->tseg1_min + btc->tseg2_min) * 2; tseg--) {
>                tsegall = 1 + tseg / 2;
> +
>                /* Compute all possible tseg choices (tseg=tseg1+tseg2) */
>                brp = priv->clock.freq / (tsegall * bt->bitrate) + tseg % 2;
> +
>                /* chose brp step which is possible in system */
>                brp = (brp / btc->brp_inc) * btc->brp_inc;
>                if ((brp < btc->brp_min) || (brp > btc->brp_max))
>                        continue;
> +
>                rate = priv->clock.freq / (brp * tsegall);
> -               error = bt->bitrate - rate;
> +               rate_error = abs((long)(bt->bitrate - rate));
> +
>                /* tseg brp biterror */
> -               if (error < 0)
> -                       error = -error;
> -               if (error > best_error)
> +               if (rate_error > best_rate_error)
>                        continue;
> -               best_error = error;
> -               if (error == 0) {
> -                       spt = can_update_spt(btc, sampl_pt, tseg / 2,
> -                                            &tseg1, &tseg2);
> -                       error = sampl_pt - spt;
> -                       if (error < 0)
> -                               error = -error;
> -                       if (error > spt_error)
> -                               continue;
> -                       spt_error = error;
> -               }
> +
> +               /* reset sample point error if we have a better bitrate */
> +               if (rate_error < best_rate_error)
> +                       best_spt_error = 1000;
> +
> +               spt = can_update_spt(btc, sampl_pt, tseg / 2, &tseg1, &tseg2);
> +               spt_error = abs((long)(sampl_pt - spt));
> +               if (spt_error > best_spt_error)
> +                       continue;
> +
> +               best_spt_error = spt_error;
> +               best_rate_error = rate_error;
>                best_tseg = tseg / 2;
>                best_brp = brp;
> -               best_rate = rate;
> -               if (error == 0)
> +
> +               if (rate_error == 0 && spt_error == 0)
>                        break;
>        }
>  -      if (best_error) {
> +       if (best_rate_error) {
>                /* Error in one-tenth of a percent */
> -               error = (best_error * 1000) / bt->bitrate;
> -               if (error > CAN_CALC_MAX_ERROR) {
> +               rate_error = (best_rate_error * 1000) / bt->bitrate;
> +               if (rate_error > CAN_CALC_MAX_ERROR) {
>                        dev_err(dev->dev.parent,
>                                "bitrate error %ld.%ld%% too high\n",
> -                               error / 10, error % 10);
> +                               rate_error / 10, rate_error % 10);
>                        return -EDOM;
>                } else {
>                        dev_warn(dev->dev.parent, "bitrate error %ld.%ld%%\n",
> -                                error / 10, error % 10);
> +                                rate_error / 10, rate_error % 10);
>                }
>        }
>  -- 1.7.4.1
>

I added bfin-can to can-calc-bit-timing.c and tried with your
better-bitrate-calculation branch, it did improve the sample error.
Thank you.

Here's the result:

Bit timing parameters for bfin-can with 131.250000 MHz ref clock
nominal                                 real Bitrt   nom  real SampP
 Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP Bitrate Error SampP SampP Error   CAN_CTRL
 1000000    251   1    1    1   1  33  994318  0.6% 75.0% 75.0%  0.0%
clock 0x00000020 timing 0x00000001
  800000    312   1    1    1   1  41  800304  0.0% 80.0% 75.0%  6.2%
clock 0x00000028 timing 0x00000001
- 500000    502   1    1    1   1  66  497159  0.6% 87.5% 75.0% 14.3%
clock 0x00000041 timing 0x00000001
+ 500000    251   3    3    1   1  33  497159  0.6% 87.5% 87.5%  0.0%
clock 0x00000020 timing 0x00000005
  250000    266   6    6    2   1  35  250000  0.0% 87.5% 86.6%  1.0%
clock 0x00000022 timing 0x0000001b
  125000    533   6    6    2   1  70  125000  0.0% 87.5% 86.6%  1.0%
clock 0x00000045 timing 0x0000001b
- 100000   2499   1    1    1   1 328  100038  0.0% 87.5% 75.0% 14.3%
clock 0x00000147 timing 0x00000001
+ 100000   1249   3    3    1   1 164  100038  0.0% 87.5% 87.5%  0.0%
clock 0x000000a3 timing 0x00000005
   50000   1333   6    6    2   1 175   50000  0.0% 87.5% 86.6%  1.0%
clock 0x000000ae timing 0x0000001b
   20000   2940   6    7    3   1 386   20001  0.0% 87.5% 82.3%  5.9%
clock 0x00000181 timing 0x0000002c
   10000   6666   6    6    2   1 875   10000  0.0% 87.5% 86.6%  1.0%
clock 0x0000036a timing 0x0000001b
@@ -15,7 +15,7 @@
Bit timing parameters for bfin-can with 125.000000 MHz ref clock
 nominal                                 real Bitrt   nom  real SampP
 Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP Bitrate Error SampP SampP Error   CAN_CTRL
 1000000     40   8    8    8   1   5 1000000  0.0% 75.0% 68.0%  9.3%
clock 0x00000004 timing 0x0000007f
- 800000    312   1    1    1   1  39  801282  0.2% 80.0% 75.0%  6.2%
clock 0x00000026 timing 0x00000001
+ 800000     96   4    5    3   1  12  801282  0.2% 80.0% 76.9%  3.9%
clock 0x0000000b timing 0x00000028
  500000    400   1    2    1   1  50  500000  0.0% 87.5% 80.0%  8.6%
clock 0x00000031 timing 0x00000002
  250000    200   8    8    3   1  25  250000  0.0% 87.5% 85.0%  2.9%
clock 0x00000018 timing 0x0000002f
  125000   1000   3    3    1   1 125  125000  0.0% 87.5% 87.5%  0.0%
clock 0x0000007c timing 0x00000005

-steven

> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |
>
>
>
