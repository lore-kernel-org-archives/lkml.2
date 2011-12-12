Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1LLGTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 01:19:24 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42307 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab1LLGTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 01:19:23 -0500
MIME-Version: 1.0
In-Reply-To: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 12 Dec 2011 14:19:22 +0800
Message-ID: <CAN1soZztU+gC3tkzXK5m51-+djqqcC_JhiJyc4xys2K_ZxUnGA@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 7:57 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This add per-pin and per-group pin config interfaces for biasing,
> driving and other such electronic properties. The details of passed
> configurations are passed in an opaque unsigned long which may be
> dereferences to integer types, structs or lists on either side
> of the configuration interface.
>
> ChangeLog v1->v2:
> - Clear split of terminology: we now have pin controllers, and
>  those may support two interfaces using vtables: pin
>  multiplexing and pin configuration.
> - Break out pin configuration to its own C file, controllers may
>  implement only config without mux, and vice versa, so keep each
>  sub-functionality of pin controllers separate. Introduce
>  CONFIG_PINCONF in Kconfig.
> - Implement some core logic around pin configuration in the
>  pinconf.c file.
> - Remove UNKNOWN config states, these were just surplus baggage.
> - Remove FLOAT config state - HIGH_IMPEDANCE should be enough for
>  everyone.
> - PIN_CONFIG_POWER_SOURCE added to handle switching the power
>  supply for the pin logic between different sources
> - Explicit DISABLE config enums to turn schmitt-trigger,
>  wakeup etc OFF.
> - Update documentation to reflect all the recent reasoning.
> ChangeLog v2->v3:
> - Twist API around to pass around arrays of config tuples instead
>  of (param, value) pairs everywhere.
> - Explicit drive strength semantics for push/pull and similar
>  drive modes, this shall be the number of drive stages vs
>  nominal load impedance, which should match the actual
>  electronics used in push/pull CMOS or TTY totempoles.
> - Drop load capacitance configuration - I probably don't know
>  what I'm doing here so leave it out.
> - Drop PIN_CONFIG_INPUT_SCHMITT_OFF, instead the argument zero to
>  PIN_CONFIG_INPUT_SCHMITT turns schmitt trigger off.
> - Drop PIN_CONFIG_NORMAL_POWER_MODE and have a well defined
>  argument to PIN_CONFIG_LOW_POWER_MODE to get out of it instead.
> - Drop PIN_CONFIG_WAKEUP_ENABLE/DISABLE and just use
>  PIN_CONFIG_WAKEUP with defined value zero to turn wakeup off.
> - Add PIN_CONFIG_INPUT_DEBOUNCE for configuring debounce time
>  on input lines.
> - Fix a bug when we tried to configure pins for pin controllers
>  without pinconf support.
> - Initialized debugfs properly so it works.
> - Initialize the mutex properly and lock around config tampering
>  sections.
> - Check the return value from get_initial_config() properly.
> ChangeLog v3->v4:
> - Export the pin_config_get(), pin_config_set() and
>  pin_config_group() functions.
> - Drop the entire concept of just getting initial config and
>  keeping track of pin states internally, instead ask the pins
>  what state they are in. Previous idea was plain wrong, if the
>  device cannot keep track of its state, the driver should do
>  it.
> - Drop the generic configuration layout, it seems this impose
>  too much restriction on some pin controllers, so let them do
>  things the way they want and split off support for generic
>  config as an optional add-on.
> ChangeLog v4->v5:
> - Introduce two symmetric driver calls for group configuration,
>  .pin_config_group_[get|set] and corresponding external calls.
> - Remove generic semantic meanings of return values from config
>  calls, these belong in the generic config patch. Just pass the
>  return value through instead.
> - Add a debugfs entry "pinconf-groups" to read status from group
>  configuration only, also slam in a per-group debug callback in
>  the pinconf_ops so custom drivers can display something
>  meaningful for their pins.
> - Fix some dangling newline.
> - Drop dangling #else clause.
> - Update documentation to match the above.
> ChangeLog v5->v6:
> - Change to using a pin name as parameter for the
>  [get|set]_config() functions, as suggested by Stephen Warren.
>  This is more natural as names will be what a developer has
>  access to in written documentation etc.
>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt       |   96 ++++++++++++-
>  drivers/pinctrl/Kconfig         |    5 +-
>  drivers/pinctrl/Makefile        |    1 +
>  drivers/pinctrl/core.c          |   37 +++++
>  drivers/pinctrl/core.h          |    5 +
>  drivers/pinctrl/pinconf.c       |  288 +++++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/pinconf.h       |   32 +++++
>  include/linux/pinctrl/pinconf.h |   96 +++++++++++++
>  include/linux/pinctrl/pinctrl.h |   10 +-
>  9 files changed, 559 insertions(+), 11 deletions(-)
>  create mode 100644 drivers/pinctrl/pinconf.c
>  create mode 100644 drivers/pinctrl/pinconf.h
>  create mode 100644 include/linux/pinctrl/pinconf.h
>
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index c8fd136..6d23fa8 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -7,12 +7,9 @@ This subsystem deals with:
>
>  - Multiplexing of pins, pads, fingers (etc) see below for details
>
> -The intention is to also deal with:
> -
> -- Software-controlled biasing and driving mode specific pins, such as
> -  pull-up/down, open drain etc, load capacitance configuration when controlled
> -  by software, etc.
> -
> +- Configuration of pins, pads, fingers (etc), such as software-controlled
> +  biasing and driving mode specific pins, such as pull-up/down, open drain,
> +  load capacitance etc.
>
>  Top-level interface
>  ===================
> @@ -88,6 +85,11 @@ int __init foo_probe(void)
>                pr_err("could not register foo pin driver\n");
>  }
>
> +To enable the pinctrl subsystem and the subgroups for PINMUX and PINCONF and
> +selected drivers, you need to select them from your machine's Kconfig entry,
> +since these are so tightly integrated with the machines they are used on.
> +See for example arch/arm/mach-u300/Kconfig for an example.
> +
>  Pins usually have fancier names than this. You can find these in the dataheet
>  for your chip. Notice that the core pinctrl.h file provides a fancy macro
>  called PINCTRL_PIN() to create the struct entries. As you can see I enumerated
> @@ -193,6 +195,88 @@ structure, for example specific register ranges associated with each group
>  and so on.
>
>
> +Pin configuration
> +=================
> +
> +Pins can sometimes be software-configured in an various ways, mostly related
> +to their electronic properties when used as inputs or outputs. For example you
> +may be able to make an output pin high impedance, or "tristate" meaning it is
> +effectively disconnected. You may be able to connect an input pin to VDD or GND
> +using a certain resistor value - pull up and pull down - so that the pin has a
> +stable value when nothing is driving the rail it is connected to, or when it's
> +unconnected.
> +
> +For example, a platform may do this:
> +
> +ret = pin_config_set(dev, "FOO_GPIO_PIN", PLATFORM_X_PULL_UP);
> +
> +To pull up a pin to VDD. The pin configuration driver implements callbacks for
> +changing pin configuration in the pin controller ops like this:
> +
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/pinctrl/pinconf.h>
> +#include "platform_x_pindefs.h"
> +
> +int foo_pin_config_get(struct pinctrl_dev *pctldev,
> +                   unsigned offset,
> +                   unsigned long *config)
> +{
> +       struct my_conftype conf;
> +
> +       ... Find setting for pin @ offset ...
> +
> +       *config = (unsigned long) conf;
> +}
> +
> +int foo_pin_config_set(struct pinctrl_dev *pctldev,
> +                   unsigned offset,
> +                   unsigned long config)
> +{
> +       struct my_conftype *conf = (struct my_conftype *) config;
> +
> +       switch (conf) {
> +               case PLATFORM_X_PULL_UP:
> +               ...
> +               }
> +       }
> +}
> +
> +int foo_pin_config_group_get (struct pinctrl_dev *pctldev,
> +                   unsigned selector,
> +                   unsigned long *config)
> +{
> +       ...
> +}
> +
> +int foo_pin_config_group_set (struct pinctrl_dev *pctldev,
> +                   unsigned selector,
> +                   unsigned long config)
> +{
> +       ...
> +}
> +
> +static struct pinconf_ops foo_pconf_ops = {
> +       .pin_config_get = foo_pin_config_get,
> +       .pin_config_set = foo_pin_config_set,
> +       .pin_config_group_get = foo_pin_config_group_get,
> +       .pin_config_group_set = foo_pin_config_group_set,
> +};
> +
> +/* Pin config operations are handled by some pin controller */
> +static struct pinctrl_desc foo_desc = {
> +       ...
> +       .confops = &foo_pconf_ops,
> +};
> +
> +Since some controllers have special logic for handling entire groups of pins
> +they can exploit the special whole-group pin control function. The
> +pin_config_group_set() callback is allowed to return the error code -EAGAIN,
> +for groups it does not want to handle, or if it just wants to do some
> +group-level handling and then fall through to iterate over all pins, in which
> +case each individual pin will be treated by separate pin_config_set() calls as
> +well.
> +
> +
>  Interaction with the GPIO subsystem
>  ===================================
>
> +/**
> + * struct pinconf_ops - pin config operations, to be implemented by
> + * pin configuration capable drivers.
> + * @pin_config_get: get the config of a certain pin, if the requested config
> + *     is not available on this controller this should return -ENOTSUPP
> + *     and if it is available but disabled it should return -EINVAL
> + * @pin_config_get: get the config of a certain pin
> + * @pin_config_set: configure an individual pin
> + * @pin_config_group_get: get configurations for an entire pin group
> + * @pin_config_group_set: configure all pins in a group
> + * @pin_config_dbg_show: optional debugfs display hook that will provide
> + *     per-device info for a certain pin in debugfs
> + * @pin_config_group_dbg_show: optional debugfs display hook that will provide
> + *     per-device info for a certain group in debugfs
> + */
> +struct pinconf_ops {
> +       int (*pin_config_get) (struct pinctrl_dev *pctldev,
> +                              unsigned pin,
> +                              unsigned long *config);
> +       int (*pin_config_set) (struct pinctrl_dev *pctldev,
> +                              unsigned pin,
> +                              unsigned long config);
> +       int (*pin_config_group_get) (struct pinctrl_dev *pctldev,
> +                                    unsigned selector,
> +                                    unsigned long *config);
> +       int (*pin_config_group_set) (struct pinctrl_dev *pctldev,
> +                                    unsigned selector,
> +                                    unsigned long config);
> +       void (*pin_config_dbg_show) (struct pinctrl_dev *pctldev,
> +                                    struct seq_file *s,
> +                                    unsigned offset);
> +       void (*pin_config_group_dbg_show) (struct pinctrl_dev *pctldev,
> +                                          struct seq_file *s,
> +                                          unsigned selector);
> +};
> +
> +extern int pin_config_get(struct pinctrl_dev *pctldev, const char *name,
> +                         unsigned long *config);
> +extern int pin_config_set(struct pinctrl_dev *pctldev, const char *name,
> +                         unsigned long config);
> +extern int pin_config_group_get(struct pinctrl_dev *pctldev,
> +                               const char *pin_group,
> +                               unsigned long *config);
> +extern int pin_config_group_set(struct pinctrl_dev *pctldev,
> +                               const char *pin_group,
> +                               unsigned long config);
> +
> +#else
> +
> +static inline int pin_config_get(struct pinctrl_dev *pctldev, const char *name,
> +                                unsigned long *config)
> +{
> +       return 0;
> +}
> +
> +static inline int pin_config_set(struct pinctrl_dev *pctldev, const char *name,
> +                                unsigned long config)
> +{
> +       return 0;
> +}
> +
> +static inline int pin_config_group_get(struct pinctrl_dev *pctldev,
> +                                      const char *pin_group,
> +                                      unsigned long *config)
> +{
> +       return 0;
> +}
> +
> +static inline int pin_config_group_set(struct pinctrl_dev *pctldev,
> +                                      const char *pin_group,
> +                                      unsigned long config)
> +{
> +       return 0;
> +}
> +
> +#endif
> +

You mentioned that pin_config_set() is used in below.
ret = pin_config_set(dev, "FOO_GPIO_PIN", PLATFORM_X_PULL_UP);

struct pinctrl_dev is created while pinmux is registered. I think this
structure is always internal structure. It can't be observed by
platform driver or device driver.

I think that you need to add one interface to let platform driver to
device driver query the pinctrl_dev. get_pinctrl_dev_from_dev(struct
device *dev, const char *dev_name) could take this job, but it is
defined in $LINUX/drivers/pinctrl internally too.

Best Regards
Haojian
