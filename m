Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0KSMPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:15:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56160 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab0KSMPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:15:10 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Date: Fri, 19 Nov 2010 17:44:49 +0530
Subject: RE: [PATCH v2 4/4] da850-evm: add baseboard UI expander buttons,
	switches and LEDs
Thread-Topic: [PATCH v2 4/4] da850-evm: add baseboard UI expander buttons,
	switches and LEDs
Thread-Index: AcuFxjj1OoRhG3wbQyGDuMUe+Yz7TACFZhvw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59302477EAA89@dbde02.ent.ti.com>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
 <d6d59b4a3c34149008f3681e0d6106efa15f354d.1289935504.git.bengardiner@nanometrics.ca>
In-Reply-To: <d6d59b4a3c34149008f3681e0d6106efa15f354d.1289935504.git.bengardiner@nanometrics.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

The board patches look good to me overall. Some minor comments below:

On Wed, Nov 17, 2010 at 01:09:37, Ben Gardiner wrote:
> This patch adds a pca953x platform device for the tca6416 found on the evm
> baseboard. The tca6416 is a GPIO expander, also found on the UI board at a
> separate I2C address. The pins of the baseboard IO expander are connected to
> software reset, deep sleep enable, test points, a push button, DIP switches and
> LEDs.
>
> Add support for the push button, DIP switches and LEDs and test points (as
> free GPIOs). The reset and deep sleep enable connections are reserved by the
> setup routine so that userspace can't toggle those lines.
>
> The existing tca6416-keypad driver was not employed because there was no
> apararent way to register the LEDs connected to gpio's on the tca6416 while
> simultaneously registering the tca6416-keypad instance.
>
> Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> Reviewed-by: Chris Cordahi <christophercordahi@nanometrics.ca>
> CC: Govindarajan, Sriramakrishnan <srk@ti.com>
>
> ---
>
> Changes since v1:
>  * adding note about why the tca6416-keypad driver was not used.
>  * adding Govindarajan, Sriramakrishnan, the author of the tca6416-keypad
>    driver
> ---
>  arch/arm/mach-davinci/board-da850-evm.c |  217 ++++++++++++++++++++++++++++++-
>  1 files changed, 213 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index dcf21e5..79f2c95 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -410,6 +410,208 @@ static int da850_evm_ui_expander_teardown(struct i2c_client *client,
>       return 0;
>  }
>
> +/* assign the baseboard expander's GPIOs after the UI board's */
> +#define DA850_UI_EXPANDER_N_GPIOS ARRAY_SIZE(ui_expander_names)
> +#define DA850_BB_EXPANDER_GPIO_BASE (DAVINCI_N_GPIO + DA850_UI_EXPANDER_N_GPIOS)
> +
> +static const char const *baseboard_expander_names[] = {
> +     "deep_sleep_en", "sw_rst", "tp_23", "tp_22", "tp_21", "user_pb1",
> +     "user_led2", "user_led1", "user_sw_1", "user_sw_2", "user_sw_3",
> +     "user_sw_4", "user_sw_5", "user_sw_6", "user_sw_7", "user_sw_8"
> +};
> +
> +#define DA850_DEEP_SLEEP_EN_OFFSET           0
> +#define DA850_SW_RST_OFFSET                  1
> +#define DA850_PB1_OFFSET                     5
> +#define DA850_USER_LED2_OFFSET                       6
> +#define DA850_USER_SW_1_OFFSET                       8

Again, I think index initialized array will work much
better here. Currently it is error prone to keep the defines
and the array of names in sync.

> +
> +#define DA850_N_USER_SW                              8
> +#define DA850_N_USER_LED                     2
> +
> +static struct gpio_keys_button user_pb_gpio_key = {

"da850evm_bb_pb" might be a better name?

> +     .code = KEY_PROG1,
> +     .type = EV_KEY,
> +     .active_low = 1,
> +     .wakeup = 0,
> +     .debounce_interval = DA850_PB_DEBOUNCE_MS,
> +     .gpio = -1, /* assigned at runtime */
> +     .desc = NULL, /* assigned at runtime */
> +};
> +
> +static struct gpio_keys_platform_data user_pb_gpio_key_platform_data = {

Similarly "da850evm_bb_pb_pdata" instead of the long name?

> +     .buttons = &user_pb_gpio_key,
> +     .nbuttons = 1,
> +     .rep = 0, /* disable auto-repeat */
> +     .poll_interval = DA850_PB_POLL_MS,
> +};
> +
> +static struct platform_device user_pb_gpio_key_device = {
> +     .name = "gpio-keys",
> +     .id = 1,
> +     .dev = {
> +             .platform_data = &user_pb_gpio_key_platform_data
> +     }
> +};
> +
> +static struct gpio_keys_button user_sw_gpio_keys[DA850_N_USER_SW];

You could initialize most static fields here itself using:

static struct gpio_keys_button user_sw_gpio_keys[] = {
        [0 ... DA850_N_USER_SW] = {
                ...
                ...
                ...
        },
};

This way your runtime initialization will come down.

> +
> +static struct gpio_keys_platform_data user_sw_gpio_key_platform_data = {
> +     .buttons = user_sw_gpio_keys,
> +     .nbuttons = ARRAY_SIZE(user_sw_gpio_keys),
> +     .rep = 0, /* disable auto-repeat */
> +     .poll_interval = DA850_SW_POLL_MS,
> +};

I wonder if we really have create to separate platform data
for switches and push buttons. If it is only the debounce period
that is different, it can be handled by initializing that field
differently.

> +
> +static struct platform_device user_sw_gpio_key_device = {
> +     .name = "gpio-keys",
> +     .id = 2,
> +     .dev = {
> +             .platform_data = &user_sw_gpio_key_platform_data

End with a ',' here.

> +     }
> +};
> +
> +static void da850_user_switches_init(unsigned gpio)
> +{
> +     int i;
> +     struct gpio_keys_button *button;
> +
> +     for (i = 0; i < DA850_N_USER_SW; i++) {
> +             button = &user_sw_gpio_keys[i];
> +
> +             button->code = SW_LID + i;
> +             button->type = EV_SW;
> +             button->active_low = 1;
> +             button->wakeup = 0;
> +             button->debounce_interval = DA850_PB_DEBOUNCE_MS;
> +             button->desc = (char *)
> +                     baseboard_expander_names[DA850_USER_SW_1_OFFSET + i];

You could use some shorter names here. In the context of EVM file, 'bb'
will fit for "base board", "exp" works for expander. Also, here it is
clear the macro is used as an array offset, so _OFFSET can be dropped
altogether. Similarly with _names. Also, the global and static symbols
should be pre-fixed with da850evm_ so it is easy to look up the symbol
file or object dump.

> +
> +             button->gpio = gpio + DA850_USER_SW_1_OFFSET + i;
> +     }
> +}
> +
> +static struct gpio_led user_leds[DA850_N_USER_LED];
> +
> +static struct gpio_led_platform_data user_led_gpio_data = {
> +     .leds = user_leds,
> +     .num_leds = ARRAY_SIZE(user_leds),
> +};
> +
> +static struct platform_device user_leds_gpio_device = {
> +     .name           = "leds-gpio",
> +     .id             = -1,
> +     .dev = {
> +             .platform_data = &user_led_gpio_data
> +     }
> +};
> +
> +static void da850_user_leds_init(unsigned gpio)
> +{
> +     int i;
> +     struct gpio_led *led;
> +
> +     for (i = 0; i < DA850_N_USER_LED; i++) {
> +             led = &user_leds[i];
> +
> +             led->active_low = 1;
> +             led->gpio = gpio + DA850_USER_LED2_OFFSET + i;
> +             led->name =
> +                     baseboard_expander_names[DA850_USER_LED2_OFFSET + i];
> +     }
> +}
> +
> +static int da850_evm_baseboard_expander_setup(struct i2c_client *client,
> +                                             unsigned gpio, unsigned ngpio,
> +                                             void *c)
> +{
> +     int ret;
> +     int deep_sleep_en, sw_rst;
> +
> +     deep_sleep_en   = gpio + DA850_DEEP_SLEEP_EN_OFFSET;
> +     sw_rst          = gpio + DA850_SW_RST_OFFSET;
> +
> +     /* Do not allow sysfs control of deep_sleep_en */
> +     ret = gpio_request(deep_sleep_en,
> +                     baseboard_expander_names[DA850_DEEP_SLEEP_EN_OFFSET]);

How does gpio_request prevent sysfs control?

Thanks,
Sekhar

