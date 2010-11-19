Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0KSPky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:40:54 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:39917 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754998Ab0KSPkw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:40:52 -0500
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59302477EAA89@dbde02.ent.ti.com>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
	<d6d59b4a3c34149008f3681e0d6106efa15f354d.1289935504.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EAA89@dbde02.ent.ti.com>
Date: Fri, 19 Nov 2010 10:40:50 -0500
Message-ID: <AANLkTike4sRvptEe9PXLT2u+SrFMOpNC6pvLPSzBfVOX@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] da850-evm: add baseboard UI expander buttons,
 switches and LEDs
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sehkar,

On Fri, Nov 19, 2010 at 7:14 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> The board patches look good to me overall. Some minor comments below:

Thanks -- and I appreciate your input.

> On Wed, Nov 17, 2010 at 01:09:37, Ben Gardiner wrote:
>> [...]
>> +static const char const *baseboard_expander_names[] = {
>> +     "deep_sleep_en", "sw_rst", "tp_23", "tp_22", "tp_21", "user_pb1",
>> +     "user_led2", "user_led1", "user_sw_1", "user_sw_2", "user_sw_3",
>> +     "user_sw_4", "user_sw_5", "user_sw_6", "user_sw_7", "user_sw_8"
>> +};
>> +
>> +#define DA850_DEEP_SLEEP_EN_OFFSET           0
>> +#define DA850_SW_RST_OFFSET                  1
>> +#define DA850_PB1_OFFSET                     5
>> +#define DA850_USER_LED2_OFFSET                       6
>> +#define DA850_USER_SW_1_OFFSET                       8
>
> Again, I think index initialized array will work much
> better here. Currently it is error prone to keep the defines
> and the array of names in sync.

Agreed. Now that I've seen what you did with the previous patch I am
eager to apply that pattern also to the definitions in this patch.

>> [...]
>> +static struct gpio_keys_platform_data user_pb_gpio_key_platform_data = {
>
> Similarly "da850evm_bb_pb_pdata" instead of the long name?

Will do.

>> [...]
>> +static struct gpio_keys_button user_sw_gpio_keys[DA850_N_USER_SW];
>
> You could initialize most static fields here itself using:
>
> static struct gpio_keys_button user_sw_gpio_keys[] = {
>        [0 ... DA850_N_USER_SW] = {
>                ...
>                ...
>                ...
>        },
> };
>
> This way your runtime initialization will come down.

Indeed; I am eager to extend the pattern you introduced to this
initialization also.

>> +
>> +static struct gpio_keys_platform_data user_sw_gpio_key_platform_data = {
>> +     .buttons = user_sw_gpio_keys,
>> +     .nbuttons = ARRAY_SIZE(user_sw_gpio_keys),
>> +     .rep = 0, /* disable auto-repeat */
>> +     .poll_interval = DA850_SW_POLL_MS,
>> +};
>
> I wonder if we really have create to separate platform data
> for switches and push buttons. If it is only the debounce period
> that is different, it can be handled by initializing that field
> differently.

I see. Good idea; we can declare an array of gpio_keys_platform_data.

Note; it is the polling interval which differs, not the debounce interval.

>> +
>> +static struct platform_device user_sw_gpio_key_device = {
>> +     .name = "gpio-keys",
>> +     .id = 2,
>> +     .dev = {
>> +             .platform_data = &user_sw_gpio_key_platform_data
>
> End with a ',' here.

Will do.

>> [...]
>> +static void da850_user_switches_init(unsigned gpio)
>> +{
>> +     int i;
>> +     struct gpio_keys_button *button;
>> +
>> +     for (i = 0; i < DA850_N_USER_SW; i++) {
>> +             button = &user_sw_gpio_keys[i];
>> +
>> +             button->code = SW_LID + i;
>> +             button->type = EV_SW;
>> +             button->active_low = 1;
>> +             button->wakeup = 0;
>> +             button->debounce_interval = DA850_PB_DEBOUNCE_MS;
>> +             button->desc = (char *)
>> +                     baseboard_expander_names[DA850_USER_SW_1_OFFSET + i];
>
> You could use some shorter names here. In the context of EVM file, 'bb'
> will fit for "base board", "exp" works for expander. Also, here it is
> clear the macro is used as an array offset, so _OFFSET can be dropped
> altogether. Similarly with _names. Also, the global and static symbols
> should be pre-fixed with da850evm_ so it is easy to look up the symbol
> file or object dump.

I see your points; 1) exp and bb for expander and baseboard variable
names, respectively 2) drop _OFFSET and _names 3) prefix statics and
globals with da850evm.

>> [...]
>
> How does gpio_request prevent sysfs control?

To obtain access to a gpio through the sysfs interface the user must
first write the gpio number to 'export'. When the gpio has been
gpio_request()'d the result of writing to 'export' is nothing; whereas
writing to export would normally result in the appearance of a named
gpio line alongside 'export'.

 I hope the following commands and their output illustrate my point:

$ cd /sys/class/gpio/
$ ls
export       gpiochip128  gpiochip160  gpiochip64   unexport
gpiochip0    gpiochip144  gpiochip32   gpiochip96
$ echo 160 > export
$ ls
export       gpiochip128  gpiochip160  gpiochip64   unexport
gpiochip0    gpiochip144  gpiochip32   gpiochip96
$ echo 163 > export
$ ls
export       gpiochip128  gpiochip160  gpiochip64   tp_22
gpiochip0    gpiochip144  gpiochip32   gpiochip96   unexport

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
