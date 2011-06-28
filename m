Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1F1HA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:00:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63937 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab1F1HAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DzpfpeaxtWKzFSKrXEHhLae/7V33jiUs4fxx7H5Kr0wq5nOqRr5/J5SAZzKVtUsxR9
         5Yv5AZip2G/brZV0/3RRB1s4BZRLcHtmT0bXUmp6/rxuf+GUOILcQmnVqtZqvXR4Wudq
         UvI9OVXe+KCN3MCeTssX2anUYTIc4mJN+gOcM=
MIME-Version: 1.0
In-Reply-To: <BANLkTinJHNztwaR44qdOpZyWg7ASrVG7vQ@mail.gmail.com>
References: <BLU158-w332CD7657F92343D3D2D1C876A0@phx.gbl>
	<BANLkTinr-5k3grHM-gfjVi2PA67VvvTiNg@mail.gmail.com>
	<BANLkTinJHNztwaR44qdOpZyWg7ASrVG7vQ@mail.gmail.com>
Date: Tue, 28 Jun 2011 12:30:18 +0530
Message-ID: <BANLkTimGyAN2MvPsTAYqCo2LcWQO2xjXtA@mail.gmail.com>
Subject: Re: [ath9k-devel] Patching ath9k/mac80211 to change MAC layer features
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Fred Matthews <fredmm@hotmail.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, ath9k-devel@lists.ath9k
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 11:07 PM, Fred Matthews <fredmm@hotmail.co.uk> wrote:
> Hi all,
>
> Much appreciated Mohammed Shafi, disabling aggregation works when
> replacing those lines with
>  sc->sc_flags &= ~SC_OP_TXAGGR;
>  sc->sc_flags &= ~SC_OP_RXAGGR;
> only issue is I must always recompile compat-wireless to
> re-enable/disable it again. I tried to port it using debugfs to be
> able to enable and disable at runtime but ath9k kept rebooting.

I am not sure we can enable/disable aggregation via debugfs, these
flags seem are set at initialization and based on this lot of things
happen in tx-path, initializing TID structure, ampdu action, rate
control  etc.

>
> Also I would be very grateful if someone can help regarding my
> attached patch and previous query:
>
> ------------
>  need to patch ath9k so that I can be able to modify/fix the A-MPDU
> aggregation frame length and other parameters such that they can be
> configured at runtime via debugfs. I made a newbie attempt at trying
> to change the aggregate length (attached), but I am unsure of the
> correctness/efficiency  - when applied throughput varies with
> different frame lengths entered but I can't be sure if its actually
> changing the aggregation length (passes the framelen/aggr_limit).
> Hence I would be very grateful if someone can assist in the correct
> way of doing this (possibly directly via mac80211).
>
>
> Also if the ampdu aggregate length is changed I believe the
> number/length of the subframes of the aggregate stays constant (at the
> default which is 32). I try to change this in my patch as well as the
> maximum software retries by just changing the default definition in
> ath9k.h, thus is there a (more) correct/better way of changing these.
> Finally, how can I patch the driver to be able to disable Block-Acks
> via debugfs or otherwise.
> ---------------
>
> Thank you very much
>
>
>
> On Mon, Jun 20, 2011 at 9:15 AM, Mohammed Shafi
> <shafi.wireless@gmail.com> wrote:
>> On Fri, Jun 17, 2011 at 2:09 AM, Fred Matthews <fredmm@hotmail.co.uk> wrote:
>>> Hello all,
>>>
>>>
>>> I have a query regarding patching ath9k/mac80211 to change MAC layer
>>> features and I would be most grateful if someone can assist.
>>>
>>>
>>> I need to patch ath9k so that I can be able to modify/fix the A-MPDU
>>> aggregation frame length and other parameters such that they can be
>>> configured at runtime via debugfs. I made a newbie attempt at trying to
>>> change the aggregate length (attached), but I am unsure of the
>>> correctness/efficiency  - when applied throughput varies with different
>>> frame lengths entered but I can't be sure if its actually changing the
>>> aggregation length (passes the framelen/aggr_limit). Hence I would be very
>>> grateful if someone can assist in the correct way of doing this (possibly
>>> directly via mac80211).
>>>
>>>
>>>
>>> Also if the ampdu aggregate length is changed I believe the number/length of
>>> the subframes of the aggregate stays constant (at the default which is
>>> 32). I try to change this in my patch as well as the maximum software
>>> retries by just changing the default definition in ath9k.h, thus is there a
>>> (more) correct/better way of changing these. Finally, how can I patch the
>>> driver to be able to disable Block-Acks/aggregation via debugfs or
>>> otherwise.
>>
>>
>> to disable aggregation in the driver, please try this
>> diff --git a/drivers/net/wireless/ath/ath9k/init.c
>> b/drivers/net/wireless/ath/ath9k/init.c
>> index d4b166c..e0175d0 100644
>> --- a/drivers/net/wireless/ath/ath9k/init.c
>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>> @@ -524,8 +524,6 @@ static void ath9k_init_misc(struct ath_softc *sc)
>>        sc->config.txpowlimit = ATH_TXPOWER_MAX;
>>
>>        if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
>> -               sc->sc_flags |= SC_OP_TXAGGR;
>> -               sc->sc_flags |= SC_OP_RXAGGR;
>>        }
>>
>>        common->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
>>
>> if you want only tx-aggregation to be disabled , please comment out only that.
>> also you can completely disable HT by
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c
>> b/drivers/net/wireless/ath/ath9k/hw.c
>> index 6de2655..696b4cc 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -1915,10 +1915,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
>>
>>        common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_AESCCM;
>>
>> -       if (ah->hw_version.devid != AR2427_DEVID_PCIE)
>> -               pCap->hw_caps |= ATH9K_HW_CAP_HT;
>> -       else
>> -               pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
>> +       pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
>>
>>        if (AR_SREV_9271(ah))
>>                pCap->num_gpio_pins = AR9271_NUM_GPIO;
>>
>>
>>
>>
>>>
>>>
>>>
>>> I highly appreciate, help in any of the above, as well as other advice,
>>> Many thanks
>>>
>>> _______________________________________________
>>> ath9k-devel mailing list
>>> ath9k-devel@lists.ath9k.org
>>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>>
>>>
>>
>>
>>
>> --
>> shafi
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
shafi
