Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2ATPuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:50:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57627 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2ATPuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:50:06 -0500
MIME-Version: 1.0
In-Reply-To: <1326725496-28928-1-git-send-email-linus.walleij@stericsson.com>
References: <1326725496-28928-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 20 Jan 2012 21:20:05 +0530
Message-ID: <CAJuYYwQnxpbFF0f_4pEkZaVMA+9MBtJP+tEKomVf5yH1miJ1Mw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pin configuration states
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 16 January 2012 20:21, Linus Walleij <linus.walleij@stericsson.com> wrote:
>
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This introduce a pin configuration state structure and activation
> functions similar to the pinmux map. It basically names a few
> states and define the custom configuration values to be applied to
> groups and pins alike when switching to a certain state.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Maybe this is closer to what people want for configuring the pins
> in their platforms? I am not fully satisfied with this solution
> because it basically maintains status quo of the big static tables
> found in many ARM SoCs, but it does instill a common scheme for
> doing it.
>
> Also there is no way for a pinmux and its associated device to
> switch states in this solution. However one does not exclude the
> other, we might want per-device associated pinmux and group
> states *also*.
>
> Comments welcome.
> ---
>  Documentation/pinctrl.txt       |   63 +++++++++++
>  drivers/pinctrl/core.c          |    3 +
>  drivers/pinctrl/pinconf.c       |  231 +++++++++++++++++++++++++++++++++++++-
>  drivers/pinctrl/pinconf.h       |   11 ++
>  include/linux/pinctrl/machine.h |   79 +++++++++++++
>  5 files changed, 380 insertions(+), 7 deletions(-)
>

For Samsung platforms, a majority of the pinconfig is setup during
driver's probe/release/suspend/resume. This patch is helpful for any
system wide pinconfig setup from platform code but since Samsung
platforms rely pinconfig to be initiated by the driver, there still
need be a way to setup pinconfig from a driver. There are few minor
comments listed below.

>
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index 1851f1d..29845c4 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -277,6 +277,69 @@ case each individual pin will be treated by separate pin_config_set() calls as
>  well.
>
>
> +Pin configuration states
> +========================
> +
> +To help platforms to set up initial pin configuration and transit the entire
> +set of pins on a pin controller between different states, pin controller
> +states are supported by creating named states per controller. A board/machine
> +can define a pin configuration like this:
> +
> +static const struct pin_config foo_pin_config_active[] = {
> +       PIN_CONFIG("GPIO0", PLATFORM_X_PULL_UP),
> +       PIN_CONFIG("GPIO1", PLATFORM_X_PULL_DOWN),
> +};
> +
> +static const struct pin_config foo_pin_config_idle[] = {
> +       PIN_CONFIG("GPIO0", PLATFORM_X_GROUND),
> +       PIN_CONFIG("GPIO1", PLATFORM_X_GROUND),
> +};
> +
> +static const struct pin_config foo_pin_config_idle[] = {
> +       PIN_CONFIG("GPIO0", PLATFORM_X_OFF),
> +       PIN_CONFIG("GPIO1", PLATFORM_X_OFF),
> +};
> +
> +static struct pin_config_state __initdata foo_pinconf_states[] = {
> +       {
> +               .name = "active",
> +               .ctrl_dev_name = "foo",
> +               .pin_configs = foo_pin_config_active,
> +               .nr_pin_configs = ARRAY_SIZE(foo_pin_config_active),
> +               .apply_on_init = true,
> +       },
> +       {
> +               .name = "idle",
> +               .ctrl_dev_name = "foo",
> +               .pin_configs = foo_pin_config_idle,
> +               .nr_pin_configs = ARRAY_SIZE(foo_pin_config_idle),
> +       },
> +       {
> +               .name = "off",
> +               .ctrl_dev_name = "foo",
> +               .pin_configs = foo_pin_config_idle,
> +               .nr_pin_configs = ARRAY_SIZE(foo_pin_config_idle),
> +               .apply_on_exit = true,
> +       },
> +};
> +
> +The first three arrays of configurations are simply the names of some pins
> +and the custom configuration that is associated with each.
> +
> +So there are three states for the pin controller, and the "active" state will
> +pull two GPIO pins, whereas "idle" will ground them and "off" will deactivate
> +them completely. In this case "active" will be auto-applied when your pin
> +controller registers, and "off" will be auto-applied when the controller is
> +removed. At runtime, the system may want to ground both pins by simply calling:
> +
> +ret = pinconf_set_state("foo", "idle");

ret = pinconf_activate_state("foo", "idle");

> +
> +Which will apply the "idle" configuration.
> +
> +For simple systems that just configure the pins on boot and then forget about
> +them, the first configuration table may be sufficient.
> +
> +
>  Generic pin configuration
>  =========================
>
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index 569bdb3..15d5adf 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -541,6 +541,7 @@ static void pinctrl_init_debugfs(void)
>        debugfs_create_file("pinctrl-devices", S_IFREG | S_IRUGO,
>                            debugfs_root, NULL, &pinctrl_devices_ops);
>        pinmux_init_debugfs(debugfs_root);
> +       pinconf_init_debugfs(debugfs_root);
>  }
>
>  #else /* CONFIG_DEBUG_FS */
> @@ -622,6 +623,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
>        list_add(&pctldev->node, &pinctrldev_list);
>        mutex_unlock(&pinctrldev_list_mutex);
>        pinmux_hog_maps(pctldev);
> +       pinconf_apply_initexit(pctldev, true);
>        return pctldev;
>
>  out_err:
> @@ -642,6 +644,7 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
>                return;
>
>        pinmux_unhog_maps(pctldev);
> +       pinconf_apply_initexit(pctldev, false);
>        /* TODO: check that no pinmuxes are still active? */
>        mutex_lock(&pinctrldev_list_mutex);
>        list_del(&pctldev->node);
> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
> index 819fcd9..5830786 100644
> --- a/drivers/pinctrl/pinconf.c
> +++ b/drivers/pinctrl/pinconf.c
> @@ -23,6 +23,10 @@
>  #include "core.h"
>  #include "pinconf.h"
>
> +/* Global pin configuration states */
> +static struct pin_config_state *pinconf_states;
> +static unsigned pinconf_states_num;
> +
>  int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
>                           unsigned long *config)
>  {
> @@ -138,11 +142,10 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
>  }
>  EXPORT_SYMBOL(pin_config_group_get);
>
> -
> -int pin_config_group_set(const char *dev_name, const char *pin_group,
> -                        unsigned long config)
> +static int pin_config_group_set_for_group(struct pinctrl_dev *pctldev,
> +                                         const char *pin_group,
> +                                         unsigned long config)
>  {
> -       struct pinctrl_dev *pctldev;
>        const struct pinconf_ops *ops;
>        const struct pinctrl_ops *pctlops;
>        int selector;
> @@ -151,9 +154,6 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
>        int ret;
>        int i;
>
> -       pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
> -       if (!pctldev)
> -               return -EINVAL;
>        ops = pctldev->desc->confops;
>        pctlops = pctldev->desc->pctlops;
>
> @@ -203,6 +203,20 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
>
>        return 0;
>  }
> +
> +int pin_config_group_set(const char *dev_name, const char *pin_group,
> +                        unsigned long config)
> +{
> +       struct pinctrl_dev *pctldev;
> +
> +       pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
> +       if (!pctldev)
> +               return -EINVAL;
> +
> +       return pin_config_group_set_for_group(pctldev,
> +                                             pin_group,
> +                                             config);
> +}
>  EXPORT_SYMBOL(pin_config_group_set);
>
>  int pinconf_check_ops(const struct pinconf_ops *ops)
> @@ -216,6 +230,167 @@ int pinconf_check_ops(const struct pinconf_ops *ops)
>        return 0;
>  }
>
> +int __init pinconf_register_pin_states(struct pin_config_state const *states,
> +                                      unsigned num_states)
> +{
> +       void *tmp;
> +       int i;
> +
> +       pr_debug("add %d pin configuration states\n", num_states);
> +
> +       /* First sanity check the new states */
> +       for (i = 0; i < num_states; i++) {
> +               if (!states[i].name) {
> +                       pr_err("failed to register config state %d: "
> +                              "no state name given\n", i);
> +                       return -EINVAL;
> +               }
> +
> +               if (!states[i].ctrl_dev && !states[i].ctrl_dev_name) {
> +                       pr_err("failed to register config state %s (%d): "
> +                              "no pin control device given\n",
> +                              states[i].name, i);
> +                       return -EINVAL;
> +               }
> +
> +               if (!states[i].pin_configs && !states[i].pin_group_configs) {
> +                       pr_err("failed to register config state %s (%d): "
> +                              "no pin or group states defined in it\n",
> +                              states[i].name, i);
> +                       return -EINVAL;
> +               }
> +               else
> +                       pr_debug("register pin config state %s\n",
> +                                states[i].name);
> +       }
> +
> +       /*
> +        * Make a copy of the config state array - string pointers will end up
> +        * in the kernel const section anyway so these do not need to be deep
> +        * copied. Note that the pointers to the config tuples are *not* being
> +        * copied as of now, these cannot be declared __init_data.
> +        */
> +       if (!pinconf_states_num) {
> +               /* On first call, just copy them */
> +               tmp = kmemdup(states,
> +                             sizeof(struct pin_config_state) * num_states,
> +                             GFP_KERNEL);
> +               if (!tmp)
> +                       return -ENOMEM;
> +       } else {
> +               /* Subsequent calls, reallocate array to new size */
> +               size_t oldsize = sizeof(struct pin_config_state) *
> +                       pinconf_states_num;
> +               size_t newsize = sizeof(struct pin_config_state) * num_states;
> +
> +               tmp = krealloc(pinconf_states, oldsize + newsize, GFP_KERNEL);
> +               if (!tmp)
> +                       return -ENOMEM;
> +               memcpy((tmp + oldsize), states, newsize);
> +       }
> +
> +       pinconf_states = tmp;
> +       pinconf_states_num += num_states;
> +       return 0;
> +}
> +
> +/**
> + * pinconf_apply_state() - apply a certain pin configuration state on a certain
> + * pin controller
> + * @pctldev: the pin controller to apply the state to
> + * @pstate: the configuration state to apply on the pin controller
> + */
> +static int pinconf_apply_state(struct pinctrl_dev *pctldev,
> +                              struct pin_config_state const *pstate)
> +{
> +       int ret, i;
> +
> +       /* Apply group configs first */
> +       for (i = 0; i < pstate->nr_pin_group_configs; i++) {
> +               const struct pin_group_config *groupconf =
> +                       &pstate->pin_group_configs[i];
> +
> +               ret = pin_config_group_set_for_group(pctldev,
> +                                                    groupconf->group_name,
> +                                                    groupconf->config);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       /* Then apply individual pin configs */
> +       for (i = 0; i < pstate->nr_pin_configs; i++) {
> +               const struct pin_config *pinconf =
> +                       &pstate->pin_configs[i];
> +               int pin;
> +
> +               pin = pin_get_from_name(pctldev, pinconf->pin_name);
> +               if (pin < 0)
> +                       return pin;
> +
> +               ret = pin_config_set_for_pin(pctldev, pin, pinconf->config);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * pinconf_set_state() - sets the state for pins and groups on a pin controller

* pinconf_activate_state() - sets the ....

> + * @dev_name: the textual name for the pin controller
> + * @state: name of the state to set
> + */
> +int pinconf_activate_state(const char *dev_name, const char *state)
> +{
> +       struct pinctrl_dev *pctldev;
> +       int i;
> +
> +       pctldev = get_pinctrl_dev_from_dev(NULL, dev_name);
> +       if (!pctldev)
> +               return -EINVAL;
> +
> +       for (i = 0; i < pinconf_states_num; i++) {
> +               struct pin_config_state const *pstate = &pinconf_states[i];
> +               int ret;
> +
> +               if (!strcmp(pstate->name, state)) {
> +                       ret = pinconf_apply_state(pctldev, pstate);
> +                       if (ret)
> +                               dev_err(pctldev->dev,
> +                                       "failed to apply state %s\n",
> +                                       pstate->name);
> +               }
> +       }
> +
> +       return 0;
> +}

EXPORT_SYMBOL(pinconf_activate_state);

> +
> +/**
> + * pinconf_apply_initexit() - check for states to be applied on init and exit
> + * @pctldev: pin controller to be checked
> + * @init: true for checking during registration of the pin controller, false
> + *     for checking during removal of the pin controller
> + */
> +void pinconf_apply_initexit(struct pinctrl_dev *pctldev, bool init)
> +{
> +       int i;
> +
> +       for (i = 0; i < pinconf_states_num; i++) {
> +               struct pin_config_state const *pstate = &pinconf_states[i];
> +               int ret;
> +
> +               if ((pstate->apply_on_init && init) ||
> +                   (pstate->apply_on_exit && !init)) {
> +                       ret = pinconf_apply_state(pctldev, pstate);
> +                       if (ret)
> +                               dev_err(pctldev->dev,
> +                                       "failed to apply state %s on %s\n",
> +                                       pstate->name,
> +                                       init ? "init" : "exit");
> +               }
> +       }
> +}
> +
>  #ifdef CONFIG_DEBUG_FS
>
>  static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
> @@ -294,6 +469,30 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
>        return 0;
>  }
>
> +static int pinconf_states_show(struct seq_file *s, void *what)
> +{
> +       int i;
> +
> +       seq_puts(s, "Pinconfig state table:\n");
> +
> +       for (i = 0; i < pinconf_states_num; i++) {
> +               struct pin_config_state const *pstate = &pinconf_states[i];
> +
> +               seq_printf(s, "%s:\n", pstate->name);
> +               seq_printf(s, "  controlling device %s\n",
> +                          pstate->ctrl_dev ? dev_name(pstate->ctrl_dev) :
> +                          pstate->ctrl_dev_name);
> +               seq_printf(s, "  %u pin configs, %u pin group configs\n",
> +                          pstate->nr_pin_configs,
> +                          pstate->nr_pin_group_configs);
> +               seq_printf(s, "  apply on init: %s\n",
> +                          pstate->apply_on_init ? "YES" : "NO");
> +               seq_printf(s, "  apply on exit: %s\n",
> +                          pstate->apply_on_exit ? "YES" : "NO");
> +       }
> +       return 0;
> +}
> +
>  static int pinconf_pins_open(struct inode *inode, struct file *file)
>  {
>        return single_open(file, pinconf_pins_show, inode->i_private);
> @@ -304,6 +503,11 @@ static int pinconf_groups_open(struct inode *inode, struct file *file)
>        return single_open(file, pinconf_groups_show, inode->i_private);
>  }
>
> +static int pinconf_states_open(struct inode *inode, struct file *file)
> +{
> +       return single_open(file, pinconf_states_show, inode->i_private);
> +}
> +
>  static const struct file_operations pinconf_pins_ops = {
>        .open           = pinconf_pins_open,
>        .read           = seq_read,
> @@ -318,6 +522,13 @@ static const struct file_operations pinconf_groups_ops = {
>        .release        = single_release,
>  };
>
> +static const struct file_operations pinconf_states_ops = {
> +       .open           = pinconf_states_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = single_release,
> +};
> +
>  void pinconf_init_device_debugfs(struct dentry *devroot,
>                         struct pinctrl_dev *pctldev)
>  {
> @@ -327,4 +538,10 @@ void pinconf_init_device_debugfs(struct dentry *devroot,
>                            devroot, pctldev, &pinconf_groups_ops);
>  }
>
> +void pinconf_init_debugfs(struct dentry *subsys_root)
> +{
> +       debugfs_create_file("pinconf-states", S_IFREG | S_IRUGO,
> +                           subsys_root, NULL, &pinconf_states_ops);
> +}
> +
>  #endif
> diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
> index 81d71ae..f5872d4 100644
> --- a/drivers/pinctrl/pinconf.h
> +++ b/drivers/pinctrl/pinconf.h
> @@ -14,8 +14,10 @@
>  #ifdef CONFIG_PINCONF
>
>  int pinconf_check_ops(const struct pinconf_ops *ops);
> +void pinconf_apply_initexit(struct pinctrl_dev *pctldev, bool init);

int pinconf_activate_state(const char *dev_name, const char *state);

>  void pinconf_init_device_debugfs(struct dentry *devroot,
>                                 struct pinctrl_dev *pctldev);
> +void pinconf_init_debugfs(struct dentry *subsys_root);
>  int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
>                           unsigned long *config);
>  int pin_config_set_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
> @@ -28,11 +30,20 @@ static inline int pinconf_check_ops(const struct pinconf_ops *ops)
>        return 0;
>  }

#else

>
> +static inline void pinconf_apply_initexit(struct pinctrl_dev *pctldev,
> +                                         bool init)
> +{
> +}
> +
>  static inline void pinconf_init_device_debugfs(struct dentry *devroot,
>                                               struct pinctrl_dev *pctldev)
>  {
>  }
>
> +static inline void pinconf_init_debugfs(struct dentry *subsys_root)
> +{
> +}
> +
>  #endif
>
>  /*
> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> index d0aecb7..a4f78bd 100644
> --- a/include/linux/pinctrl/machine.h
> +++ b/include/linux/pinctrl/machine.h
> @@ -82,6 +82,67 @@ struct pinmux_map {
>        { .name = a, .ctrl_dev_name = b, .function = c, .group = d, \
>          .hog_on_boot = true }
>
> +/**
> + * struct pin_config - configuration tuple for a single pin
> + * @pin_name: name of the pin affected by this configuration
> + * @config: configuration of the named pin (custom format)
> + */
> +struct pin_config {
> +       const char *pin_name;
> +       u32 config;
> +};
> +
> +/*
> + * Convenience macro to set up a simple config for a named pin
> + */
> +#define PIN_CONFIG(a, b) \
> +       { .pin_name = a, .config = b }
> +
> +/**
> + * struct pin_group_config - configuration tuple for a group
> + * @group_name: name of the group affected by this configuration
> + * @config: configuration of the named group (custom format)
> + */
> +struct pin_group_config {
> +       const char *group_name;
> +       u32 config;
> +};
> +
> +/*
> + * Convenience macro to set up a simple config for a named pin group
> + */
> +#define PIN_GROUP_CONFIG(a, b) \
> +       { .group_name = a, .config = b }
> +
> +/**
> + * struct pin_config_state - configuration for an array of pins
> + * @name: name of this configuration state
> + * @ctrl_dev: the pin control device to be used for this state, may be NULL
> + *     if you provide .ctrl_dev_name instead (this is more common)
> + * @ctrl_dev_name: the name of the device controlling this specific state,
> + *     the name must be the same as in your struct device*, may be NULL if
> + *     you provide .ctrl_dev instead
> + * @pin_configs: array of pin configuration tuples
> + * @nr_pin_configs: number of pin_configuration tuples in the array
> + * @pin_group_configs: array of pin group configuration tuples
> + * @nr_pin_group_configs: number of pin_group_configuration tuples in the array
> + * @apply_on_init: whether this configuration shall be auto-applied when
> + *     the pin controller is registered
> + * @apply_on_exit: whether this configuration shall be auto-applied when
> + *     the pin controller is unregistered
> + */
> +struct pin_config_state {
> +       const char *name;
> +       struct device *ctrl_dev;
> +       const char *ctrl_dev_name;
> +       const struct pin_config *pin_configs;
> +       unsigned nr_pin_configs;
> +       const struct pin_group_config *pin_group_configs;
> +       unsigned nr_pin_group_configs;
> +       bool apply_on_init;
> +       bool apply_on_exit;
> +};
> +
>  #ifdef CONFIG_PINMUX
>
>  extern int pinmux_register_mappings(struct pinmux_map const *map,
> @@ -96,4 +157,22 @@ static inline int pinmux_register_mappings(struct pinmux_map const *map,
>  }
>
>  #endif /* !CONFIG_PINMUX */
> +
> +#ifdef CONFIG_PINCONF
> +
> +extern int pinconf_register_pin_states(struct pin_config_state const
> +                                      *states,
> +                                      unsigned num_states);
> +
> +#else
> +
> +static inline int pinconf_register_pin_states(struct pin_config_state const
> +                                       *states,
> +                                       unsigned num_states)
> +{
> +       return 0;
> +}
> +
> +#endif /* !CONFIG_PINCONF */
> +
>  #endif
> --
> 1.7.8
>

Thanks,
Thomas.
