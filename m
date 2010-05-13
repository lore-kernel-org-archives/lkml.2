Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0EMHhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:37:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53644 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab0EMHhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=gPhZ6ioqyziU/4iCmLZep64LOQy+E8j/D7EO7r+Tdq//mrAyVd2ahVcQouk4MeP8Su
         do+UCo2527A9OByWS/ASt3e48+WGrWDg61G2r1tguF4eeRE7XEwOOobtFpvD0rV8eRmA
         yWjOJrqEMvoRciGoLQ5Kl6ZOXOIcaym3Cvk78=
MIME-Version: 1.0
In-Reply-To: <1273679336.10823.15.camel@mj>
References: <4bea1f81.09b6660a.746e.1c12@mx.google.com> <1273679336.10823.15.camel@mj>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Thu, 13 May 2010 10:36:56 +0300
X-Google-Sender-Auth: q-06SNdKsF1pnWmXqVeE4tvX8mw
Message-ID: <AANLkTinYfKlQ-MzkGV9o2qXUTeArYscfqoc8WS7SRjgz@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] [ath5k][leds] Ability to disable leds 
	support. If leds support enabled do not force mac802.11 leds layer selection.
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@venema.h4ckr.net, Kalle Valo <kalle.valo@iki.fi>,
       linux-wireless@vger.kernel.org, GeunSik Lim <geunsik.lim@samsung.com>,
       Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Keng-Yu Lin <keng-yu.lin@canonical.com>, netdev@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       Shahar Or <shahar@shahar-or.co.il>, linux-kernel@vger.kernel.org,
       Luca Verdesca <magooz@salug.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel.

I will rework the patch considering your suggestions.

> I'm not sure this complexity is needed.  Are you going to support LEDs
> if CONFIG_LEDS_CLASS is disabled?
If there's any other place in driver that might want use LEDs w/o
exporting the interface to the userspace.

-- Dima Milinevskyy


On Wed, May 12, 2010 at 6:48 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 2010-04-07 at 21:58 +0300, Dmytro Milinevskyy wrote:
>
>> Here is the patch to disable ath5k leds support on build stage.
>> However if the leds support was enabled do not force selection of 802.11 leds layer.
>
> The idea is good, but the implementation could be improved.
>
> There are too many preprocessor conditionals in your patch.
>
>> +#ifdef CONFIG_ATH5K_LEDS
>>  /*
>>   * These match net80211 definitions (not used in
>>   * mac80211).
>> @@ -939,11 +940,7 @@ enum ath5k_power_mode {
>>  #define AR5K_LED_AUTH        2 /*IEEE80211_S_AUTH*/
>>  #define AR5K_LED_ASSOC       3 /*IEEE80211_S_ASSOC*/
>>  #define AR5K_LED_RUN 4 /*IEEE80211_S_RUN*/
>
> It should be OK to leave the constants defined even if they are not
> used.
>
>> +#ifdef CONFIG_ATH5K_LEDS
>>  /* LED functions */
>>  extern int ath5k_init_leds(struct ath5k_softc *sc);
>>  extern void ath5k_led_enable(struct ath5k_softc *sc);
>>  extern void ath5k_led_off(struct ath5k_softc *sc);
>>  extern void ath5k_unregister_leds(struct ath5k_softc *sc);
>> +#endif
>
> You could add inline functions for the case when CONFIG_ATH5K_LEDS is
> not defined.  That would avoid may conditionals in the code.
>
>>  /* GPIO Functions */
>> +#ifdef CONFIG_ATH5K_LEDS
>>  extern void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state);
>> +#endif
>
> The same comment applies.
>
> Also, there is nothing wrong with having an external declaration that is
> not used in some particular configuration.
>
>> +#ifdef CONFIG_ATH5K_LEDS
>>       /* turn on HW LEDs */
>>       ath5k_hw_set_ledstate(ah, AR5K_LED_INIT);
>> +#endif
>
> This is avoidable by having an inline ath5k_hw_set_ledstate() that does
> nothing.
>
>> +#ifdef CONFIG_ATH5K_LEDS
>>       struct ieee80211_hw *hw = pci_get_drvdata(to_pci_dev(dev));
>>       struct ath5k_softc *sc = hw->priv;
>>
>>       ath5k_led_off(sc);
>> +#endif
>
> Even this is avoidable if ath5k_led_off() does nothing.  gcc should be
> smart enough to optimize out unneeded function calls.
>
>> +#ifdef CONFIG_ATH5K_LEDS
>>  /*
>>   * State for LED triggers
>>   */
>>  struct ath5k_led
>>  {
>> +#ifdef CONFIG_LEDS_CLASS
>
> I'm not sure this complexity is needed.  Are you going to support LEDs
> if CONFIG_LEDS_CLASS is disabled?
>
>> +#ifdef CONFIG_ATH5K_LEDS
>>       unsigned int            led_pin,        /* GPIO pin for driving LED */
>>                               led_on;         /* pin setting for LED on */
>> +#endif
>>
>>       struct tasklet_struct   restq;          /* reset tasklet */
>>
>> @@ -164,7 +172,9 @@ struct ath5k_softc {
>>       spinlock_t              rxbuflock;
>>       u32                     *rxlink;        /* link ptr in last RX desc */
>>       struct tasklet_struct   rxtq;           /* rx intr tasklet */
>> +#ifdef CONFIG_ATH5K_LEDS
>>       struct ath5k_led        rx_led;         /* rx led */
>> +#endif
>
> You may want to group those fields together to make the code more
> readable.
>
>> --- a/drivers/net/wireless/ath/ath5k/led.c
>> +++ b/drivers/net/wireless/ath/ath5k/led.c
>
> I wonder if you could omit led.c completely in the Makefile.  If there
> are some parts of led.c that are needed without CONFIG_ATH5K_LEDS, maybe
> they belong elsewhere?
>
> --
> Regards,
> Pavel Roskin
>
