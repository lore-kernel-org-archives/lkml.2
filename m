Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2CLCN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 22:13:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49386 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2CLCNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 22:13:50 -0400
Message-ID: <4F5D5D90.8020401@gmail.com>
Date: Mon, 12 Mar 2012 12:21:04 +1000
From: wei <yinwei168@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mac80211: improve PID rate control mechanism by
 avoiding rate oscillation problem
References: <4F5D4C4E.1060800@gmail.com> <CAGRGNgX-RDRFNXKTXf=qw7h4bQNypHx0Hgvjd7rvXu9T43f4WQ@mail.gmail.com>
In-Reply-To: <CAGRGNgX-RDRFNXKTXf=qw7h4bQNypHx0Hgvjd7rvXu9T43f4WQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, Julian.

You helped me a lot improving the patch. Your suggestion are very
valuable. Thank you.

The reason for why I change this value to 2 is below.

On 12/03/12 11:14, Julian Calaby wrote:
> Hi Wei,
>
> Much better!
>
> Still a few style comments below.
>
> On Mon, Mar 12, 2012 at 12:07, wei <yinwei168@gmail.com> wrote:
>> From Wei YIN <Wei.Yin@nicta.com.au>
>> Improve PID rate control mechanism by avoiding rate oscillation problem
>>
>> Signed-off-by: Wei YIN <Wei.Yin@nicta.com.au>
>> ---
>> kernel 3.3.0
>> net/mac80211/rc80211_pid_algo.c | 392 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------
>> 1 file changed, 317 insertions(+), 75 deletions(-)
>>
>> --- wireless-testing_orig/net/mac80211/rc80211_pid_algo.c       2012-02-17 13:59:53.495254495 +1000
>> +++ wireless-testing/net/mac80211/rc80211_pid_algo.c    2012-03-08 20:00:31.791698813 +1000
>> @@ -155,99 +217,239 @@ static void rate_control_pid_sample(stru
>>        /* Ignore all frames that were sent with a different rate than the rate
>>         * we currently advise mac80211 to use. */
>> -       if (info->status.rates[0].idx != spinfo->txrate_idx)
>> -               return;
>>
>> -       spinfo->tx_num_xmit++;
>> +       if ((info->status.rates[0].idx != spinfo->txrate_idx) &&
>> +                       (info->status.rates[0].idx != spinfo->tmp_rate_idx))
>> +               return;
> You don't need the parentheses around the != expressions.
>
>> @@ -271,14 +473,17 @@ rate_control_pid_get_rate(void *priv, st
>>                info->control.rates[0].count =
>>                        txrc->hw->conf.long_frame_max_tx_count;
>>        else
>> -               info->control.rates[0].count =
>> -                       txrc->hw->conf.short_frame_max_tx_count;
>> -
>> +               info->control.rates[0].count = 2;
> Should this be a constant or something? Why is this being set to 2?

According to the principle of how PID works, the default FLR is 14% and it attempts to decrease the rate if the FLR is higher than 14%. Let us assume that the current FLR is 14%, Then the probability for two consecutive failed attempts should be 14% * 14% = 0.0196 = 1.96%. The probability is very low. So I think we should not try further retransmission at this rate and fall back as soon as possible. Another reason is that the number of probes at the proposed rate is set to MAX_PROBES = 3 in the implementation, which means we will have 6 attempts at the probing rate. If the current rate is the lowest, say 1 Mbit/s, in 120 ms (a rate adaptation period in PID), the maximum number of attempts is around 8--9. I think I should limit the number of probes within the maximum attempts that can be achieved in one rate adaptation period.

We could switch back to the configured value. But I need to change the maximum number of probes, MAX_PROBES. 

>  
>> @@ -321,7 +530,7 @@ rate_control_pid_rate_init(void *priv, s
>>                s = false;
>>                for (j = 0; j < sband->n_bitrates - i; j++)
>>                        if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
>> -                                    sband->bitrates[rinfo[j + 1].index].bitrate)) {
>> +                               sband->bitrates[rinfo[j + 1].index].bitrate)) {
> You should drop this whitespace change as it's unrelated to the rest
> of your patch.
>
> Thanks,
>

