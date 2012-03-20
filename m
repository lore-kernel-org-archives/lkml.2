Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700Ab2CTLP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:15:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65352 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961Ab2CTLP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAD2nsn0JCKd4NnXOLfw4QXHTJdxrfepw9s6yYca=uSHwWXq3-A@mail.gmail.com>
References: <4F576FD5.2050208@gmail.com>
	<CAD2nsn23UqshHz1ZUn8bHN0rWyOMbBHhn9V8pmCc4_aT_uGYaw@mail.gmail.com>
	<4F577D9B.7020402@gmail.com>
	<4F579A88.6030503@openwrt.org>
	<4F61F551.5010608@gmail.com>
	<4F639851.5080500@gmail.com>
	<4F674616.8080103@gmail.com>
	<CAD2nsn3xpkGenrK50YmE5D7Odg3sBEek5zKcLZF6MAm69p5RJg@mail.gmail.com>
	<4F674FF5.2060406@gmail.com>
	<4F6751B2.1030809@openwrt.org>
	<4F681B78.9000207@gmail.com>
	<CAD2nsn0d-3edYGH8u+v5mhrUZBMsznDNRDkDHE-tErG8uGk84Q@mail.gmail.com>
	<4F68235C.5090701@gmail.com>
	<CAD2nsn0toAjyWw48J7oREES0=x6D72hMntP+WpAjHmR5drd-tQ@mail.gmail.com>
	<4F682555.3020502@gmail.com>
	<20328.16366.166909.255035@gargle.gargle.HOWL>
	<CAD2nsn0JCKd4NnXOLfw4QXHTJdxrfepw9s6yYca=uSHwWXq3-A@mail.gmail.com>
Date: Tue, 20 Mar 2012 16:45:56 +0530
Message-ID: <CAD2nsn10svpDFkpbkCtFMGFdqW9G0syWrhL3s-ApQH2bKt0P2g@mail.gmail.com>
Subject: Re: ath: DMA failed to stop in 10 ms AR_CR=0x00000024
 AR_DIAG_SW=0x02000020 DMADBG_7=0x00008040
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, linux-kernel@vger.kernel.org,
        Linux-netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 3:07 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> Hi Sujith/Justin,
>
> On Tue, Mar 20, 2012 at 1:59 PM, Sujith Manoharan
> <c_manoha@qca.qualcomm.com> wrote:
>> Justin P. Mattock wrote:
>>> yeah this works:
>>>
>>> eading symbols from
>>> /home/kernel/linux-next/drivers/net/wireless/ath/ath9k/ath9k.o...done.
>>> (gdb) l *(ath_tx_start+0x284)
>>> 0xcad4 is in ath_tx_start (drivers/net/wireless/ath/ath9k/xmit.c:1878).
>>> 1873                  ieee80211_is_data_qos(hdr->frame_control)) {
>>> 1874                  tidno = ieee80211_get_qos_ctl(hdr)[0] &
>>> 1875                          IEEE80211_QOS_CTL_TID_MASK;
>>> 1876                  tid = ATH_AN_2_TID(txctl->an, tidno);
>>> 1877
>>> 1878                  WARN_ON(tid->ac->txq != txctl->txq);
>>> 1879          }
>>> 1880
>>> 1881          if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && tid) {
>>> 1882                  /*
>>> (gdb)
>>
>> Can you try this patch ?
>
> just found out that 'ht_supported' may not  be set, if assoc response
> does not has ht_cap IE (or) if we could not parse it (why), then the
> driver won't initialize those tid related structures ath_tx_node_init,
> while we later access them in ath_tx_start. so this should fix the
> issue.

now i was able to quite easily recreate this issue in wireless testing
even without suspend resume and with the patch the issue seems to get
fixed.
i was using 2ghz channel 6 and TKIP (no HT!).


>
>>
>> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>> Date: Tue, 20 Mar 2012 13:51:26 +0530
>> Subject: [PATCH] ath9k: Use HW HT capabilites properly
>>
>> The commit "ath9k: Remove aggregation flags" changed how
>> nodes were being initialized. Use the HW HT cap bits
>> to initialize/de-initialize nodes, else we would be
>> accessing an uninitialized entry during a suspend/resume cycle,
>> resulting in a panic.
>>
>> Reported-by: Justin P. Mattock <justinmattock@gmail.com>
>> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/main.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> index 3879485..215eb25 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -640,7 +640,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
>>        an->sta = sta;
>>        an->vif = vif;
>>
>> -       if (sta->ht_cap.ht_supported) {
>> +       if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
>>                ath_tx_node_init(sc, an);
>>                an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
>>                                     sta->ht_cap.ampdu_factor);
>> @@ -659,7 +659,7 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
>>        an->sta = NULL;
>>  #endif
>>
>> -       if (sta->ht_cap.ht_supported)
>> +       if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
>>                ath_tx_node_cleanup(sc, an);
>>  }
>>
>> --
>> 1.7.9.4
>>
>
>
>
> --
> thanks,
> shafi



-- 
thanks,
shafi
