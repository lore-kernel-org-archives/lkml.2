Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab2DJKig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:38:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10852 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2DJKif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:38:35 -0400
X-AuditID: cbfee610-b7c16ae0000031ed-c6-4f840da9eb67
Date: Tue, 10 Apr 2012 10:38:33 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] [CPUFREQ] EXYNOS: bugfix on retrieving old_index from
 freqs.old
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        =?euc-kr?Q?=C0=CC=C0=E7=C3=B6?= <jc.lee@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120410102554596@myungjoo.ham
Msgkey: 20120410102554596@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120410102554596@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <13404.111131334054311065.JavaMail.weblogic@epv6ml08>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3AAcjNZ024368

Sender : Inderpal Singh<inderpal.singh@linaro.org> Date : 2012-04-10 19:05 (GMT+09:00)
> 
> Hi MyungJoo,

Hi Inderpal,

> 
> On 4 April 2012 15:53, MyungJoo Ham wrote:
> > The policy might have been changed since last call of target().
> > Thus, using cpufreq_frequency_table_target(), which depends on
> > policy to find the correspoding index from a frequency, may return
> > inconsistent index for freqs.old. Thus, old_index should be
> > calculated not based on the current policy.
> >
> > We have been observing such issue when scaling_min/max_freq were
> > updated and sometimes caused system lockups due to incorrectly
> > configured voltages.
> >
> > Signed-off-by: MyungJoo Ham 
> > ---
> >  drivers/cpufreq/exynos-cpufreq.c |   13 +++++++++++--
> >  1 files changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> > index b243a7e..1577522 100644
> > --- a/drivers/cpufreq/exynos-cpufreq.c
> > +++ b/drivers/cpufreq/exynos-cpufreq.c
> > @@ -62,8 +62,17 @@ static int exynos_target(struct cpufreq_policy *policy,
> >                goto out;
> >        }
> >
> > -       if (cpufreq_frequency_table_target(policy, freq_table,
> > -                                          freqs.old, relation, &old_index)) {
> > +       /*
> > +        * The policy may have been changed so that we cannot get proper
> > +        * old_index with cpufreq_frequency_table_target(). Thus, ignore
> > +        * policy and get the index from the raw frequency table.
> > +        */
> > +       for (old_index = 0;
> > +            freq_table[old_index].frequency != CPUFREQ_TABLE_END;
> > +            old_index++)
> > +               if (freq_table[old_index].frequency == freqs.old)
> > +                       break;
> > +       if (freq_table[old_index].frequency == CPUFREQ_TABLE_END) {
> >                ret = -EINVAL;
> >                goto out;
> >        }
> 
> I also had the same issue and same fix while testing powertop 1.98 as
> it changes the scaling_min/max_freq.
> 
> The only concern I have is when this code gets called for the very
> first time, the freqs.old will be the freq set by bootloader. Now if
> bootloader sets a freq which is not in the freq_table (not sure if its
> practical but theoretically its possible ), this code will error out.

It is not practical (the vendor ships IPL), but theoretically, it's possible
if one hacks the IPL.

However, in such a theoretical scenario, cpufreq won't work anyway even if
we accept out-of-specification freqs.old.

In the case you've mentioned, the bootloader has configured the clock dividers
and sources incorrectly (out of the chip vendor's specification). Then,
the Exynos cpufreq is not compatible with such a bootloader anyway even if
out-of-spec freqs.old is allowed. It is because Exynos cpufreq driver assumes
that the dividers and sources are correctly configured previously; i.e., it
does not reset/set every related divider or source when the frequency has been
updated. Thus, the resulting frequency may be different from the intended
frequency and often the system will suffer from lock ups. We've been observing
lock ups when the bootloader configures some dividers different from what the
kernel expects during suspend-to-ram and wakeup.

Cheers!
MyungJoo.

> 
> 
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Thanks,
> Inder
> 
> 
> 
> 

--

MyungJoo Ham (ÇÔ¸íÁÖ), PHD

System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858



 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
