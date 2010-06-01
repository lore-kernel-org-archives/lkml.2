Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab0FAUee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:34:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46452 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0FAUec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jyrBPgqSDL3KcIhjXPic/bcrs9di9OaDv/njFOBIPikH0Ng4gvPGV6lgFZCHFqAQEU
         X7rmPSmEnr/5Xaa0OwsBDCaEJSMsEQCkk1FkEBYBLH+sT8XEHJqeJpV7ZnmuWoMfRkJX
         JeGZyDuU/jsFeZHEPqOWXk1OZJziC9HZJE2T0=
MIME-Version: 1.0
In-Reply-To: <4c056b50.0c3fdf0a.500b.44af@mx.google.com>
References: <4c056b50.0c3fdf0a.500b.44af@mx.google.com>
Date: Tue, 1 Jun 2010 16:34:30 -0400
X-Google-Sender-Auth: 96D-1H4uT84vwfYSU0mY7exwso8
Message-ID: <AANLkTinFCuqgvnEGFmssL5R1J9-Yx7JB8mO9yKdXuYUj@mail.gmail.com>
Subject: Re: [PATCH] [ath5k][leds] Ability to disable leds support. If leds 
	support enabled do not force mac802.11 leds layer selection.
From: Bob Copeland <me@bobcopeland.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: ath5k-devel@venema.h4ckr.net, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       GeunSik Lim <geunsik.lim@samsung.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Lukas Turek <8an@praha12.net>,
       Mark Hindley <mark@hindley.org.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>, Kalle Valo <kalle.valo@iki.fi>,
       Keng-Yu Lin <keng-yu.lin@canonical.com>,
       Luca Verdesca <magooz@salug.it>, Shahar Or <shahar@shahar-or.co.il>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 7, 2010 at 2:58 PM, Dmytro Milinevskyy
<milinevskyy@gmail.com> wrote:
> Hello!

Thanks, comments inline.


> +config ATH5K_LEDS
> +       tristate "Atheros 5xxx wireless cards LEDs support"
> +       depends on ATH5K
> +       ---help---
> +         Atheros 5xxx LED support.
> +

This can select the proper LED classes?  Then you can get rid of another
ifdef check later.

> -/* GPIO-controlled software LED */
> -#define AR5K_SOFTLED_PIN       0
> -#define AR5K_SOFTLED_ON                0
> -#define AR5K_SOFTLED_OFF       1
> -

Please drop this hunk, no problem keeping it around.

> +#ifdef CONFIG_ATH5K_LEDS
>  /* LED functions */
>  int ath5k_init_leds(struct ath5k_softc *sc);
>  void ath5k_led_enable(struct ath5k_softc *sc);
>  void ath5k_led_off(struct ath5k_softc *sc);
>  void ath5k_unregister_leds(struct ath5k_softc *sc);
> +#else
> +#define ath5k_init_leds(sc) do {} while (0)
> +#define ath5k_led_enable(sc) do {} while (0)
> +#define ath5k_led_off(sc) do {} while (0)
> +#define ath5k_unregister_leds(sc) do {} while (0)
> +#endif

I prefer:

#ifdef
...
#else
static inline int ath5k_init_leds(struct ath5k_softc *sc)
{
    return 0;
}
...
#endif

so you get type-checking.  Also this doesn't quite work in your version:

    int foo = ath5k_init_leds(sc);

> +#ifdef CONFIG_ATH5K_LEDS
>  /*
>  * State for LED triggers
>  */
>  struct ath5k_led
>  {
> -       char name[ATH5K_LED_MAX_NAME_LEN + 1];  /* name of the LED in sysfs */
>        struct ath5k_softc *sc;                 /* driver state */
> +#ifdef CONFIG_LEDS_CLASS
> +       char name[ATH5K_LED_MAX_NAME_LEN + 1];  /* name of the LED in sysfs */
>        struct led_classdev led_dev;            /* led classdev */
> +#endif
>  };
> +#endif

Why move name?

>  /* Rfkill */
>  struct ath5k_rfkill {
> @@ -186,9 +190,6 @@ struct ath5k_softc {
>
>        u8                      bssidmask[ETH_ALEN];
>
> -       unsigned int            led_pin,        /* GPIO pin for driving LED */
> -                               led_on;         /* pin setting for LED on */
> -
>        struct tasklet_struct   restq;          /* reset tasklet */
>
>        unsigned int            rxbufsize;      /* rx size based on mtu */
> @@ -196,7 +197,6 @@ struct ath5k_softc {
>        spinlock_t              rxbuflock;
>        u32                     *rxlink;        /* link ptr in last RX desc */
>        struct tasklet_struct   rxtq;           /* rx intr tasklet */
> -       struct ath5k_led        rx_led;         /* rx led */
>
>        struct list_head        txbuf;          /* transmit buffer */
>        spinlock_t              txbuflock;
> @@ -204,7 +204,14 @@ struct ath5k_softc {
>        struct ath5k_txq        txqs[AR5K_NUM_TX_QUEUES];       /* tx queues */
>        struct ath5k_txq        *txq;           /* main tx queue */
>        struct tasklet_struct   txtq;           /* tx intr tasklet */
> +
> +
> +#ifdef CONFIG_ATH5K_LEDS
> +       unsigned int            led_pin,        /* GPIO pin for driving LED */
> +                               led_on;         /* pin setting for LED on */
> +       struct ath5k_led        rx_led;         /* rx led */
>        struct ath5k_led        tx_led;         /* tx led */
> +#endif

You might want to do this in two stages: move the led-dependent things
together in the structure (or into a separate structure) and then only
have one #ifdef section.

Still too many ifdefs in general.

-- 
Bob Copeland %% www.bobcopeland.com
