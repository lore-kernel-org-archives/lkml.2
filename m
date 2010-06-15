Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0FOFF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 01:05:56 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:50221 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0FOFFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 01:05:55 -0400
Message-ID: <4C1708AE.7010207@seas.upenn.edu>
Date: Tue, 15 Jun 2010 00:59:26 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>, Ping <pinglinux@gmail.com>
Subject: Re: [PATCH 1/2] input: mt: Introduce MT event slots (rev 5)
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/22/10 18:30, Henrik Rydberg wrote:
> With the rapidly increasing number of intelligent multi-contact and
> multi-user devices, the need to send digested, filtered information
> from a set of different sources within the same device is imminent.
> This patch adds the concept of slots to the MT protocol. The slots
> enumerate a set of identified sources, such that all MT events
> can be passed independently and selectively per identified source.
> 
> The protocol works like this: Instead of sending a SYN_MT_REPORT
> event immediately after the contact data, one sends an ABS_MT_SLOT
> event immediately before the contact data. The input core will only
> emit events for slots with modified MT events. It is assumed that
> the same slot is used for the duration of an initiated contact.
> 
Sorry, about taking so long to look at this patch.  This looks like a good step
forward and it looks good to me.

Acked-by: Rafi Rubin <rafi@seas.upenn.edu>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Revision 5 incorporates the following changes:
> 	 - Rename the slot event to ABS_MT_SLOT to keep all MT-related events
> 	   in the same namespace.
> 	 - Move the MT slot event list to input.h so that it can be read
> 	   by userspace.
> 
>  drivers/input/input.c |  105 +++++++++++++++++++++++++++++++++++++------------
>  include/linux/input.h |   44 ++++++++++++++++++++
>  2 files changed, 123 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 9c79bd5..9b6d474 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -33,24 +33,9 @@ MODULE_LICENSE("GPL");
>  
>  #define INPUT_DEVICES	256
>  
> -/*
> - * EV_ABS events which should not be cached are listed here.
> - */
> -static unsigned int input_abs_bypass_init_data[] __initdata = {
> -	ABS_MT_TOUCH_MAJOR,
> -	ABS_MT_TOUCH_MINOR,
> -	ABS_MT_WIDTH_MAJOR,
> -	ABS_MT_WIDTH_MINOR,
> -	ABS_MT_ORIENTATION,
> -	ABS_MT_POSITION_X,
> -	ABS_MT_POSITION_Y,
> -	ABS_MT_TOOL_TYPE,
> -	ABS_MT_BLOB_ID,
> -	ABS_MT_TRACKING_ID,
> -	ABS_MT_PRESSURE,
> -	0
> -};
> -static unsigned long input_abs_bypass[BITS_TO_LONGS(ABS_CNT)];
> +static unsigned int input_mt_abs_map_init_data[] __initdata =
> +	MT_SLOT_ABS_EVENTS;
> +static unsigned char input_mt_abs_map[ABS_CNT];
>  
>  static LIST_HEAD(input_dev_list);
>  static LIST_HEAD(input_handler_list);
> @@ -181,6 +166,26 @@ static void input_stop_autorepeat(struct input_dev *dev)
>  #define INPUT_PASS_TO_DEVICE	2
>  #define INPUT_PASS_TO_ALL	(INPUT_PASS_TO_HANDLERS | INPUT_PASS_TO_DEVICE)
>  
> +static void input_mt_handle_abs_event(struct input_dev *dev,
> +				      unsigned int code, int value)
> +{
> +	if (dev->mt) {
> +		struct input_mt_slot *mtslot = &dev->mt[dev->slot];
> +		unsigned int mtcode = input_mt_abs_map[code] - 1;
> +		int old = mtslot->abs[mtcode];
> +		value = input_defuzz_abs_event(value, old, dev->absfuzz[code]);
> +		if (value == old)
> +			return;
> +		mtslot->abs[mtcode] = value;
> +	}
> +	dev->sync = 0;
> +	if (dev->slot != dev->abs[ABS_MT_SLOT]) {
> +		dev->abs[ABS_MT_SLOT] = dev->slot;
> +		input_pass_event(dev, EV_ABS, ABS_MT_SLOT, dev->slot);
> +	}
> +	input_pass_event(dev, EV_ABS, code, value);
> +}
> +
>  static void input_handle_event(struct input_dev *dev,
>  			       unsigned int type, unsigned int code, int value)
>  {
> @@ -235,11 +240,17 @@ static void input_handle_event(struct input_dev *dev,
>  	case EV_ABS:
>  		if (is_event_supported(code, dev->absbit, ABS_MAX)) {
>  
> -			if (test_bit(code, input_abs_bypass)) {
> -				disposition = INPUT_PASS_TO_HANDLERS;
> +			if (code == ABS_MT_SLOT) {
> +				if (value >= 0 && value < dev->mtsize)
> +					dev->slot = value;
>  				break;
>  			}
>  
> +			if (input_mt_abs_map[code]) {
> +				input_mt_handle_abs_event(dev, code, value);
> +				return;
> +			}
> +
>  			value = input_defuzz_abs_event(value,
>  					dev->abs[code], dev->absfuzz[code]);
>  
> @@ -1278,6 +1289,7 @@ static void input_dev_release(struct device *device)
>  	struct input_dev *dev = to_input_dev(device);
>  
>  	input_ff_destroy(dev);
> +	input_mt_destroy_slots(dev);
>  	kfree(dev);
>  
>  	module_put(THIS_MODULE);
> @@ -1518,6 +1530,46 @@ void input_free_device(struct input_dev *dev)
>  EXPORT_SYMBOL(input_free_device);
>  
>  /**
> + * input_mt_create_slots() - create MT input slots
> + * @dev: input device supporting MT events and finger tracking
> + * @max_slots: maximum number of slots supported by the device
> + *
> + * This function allocates all necessary memory for MT slot handling
> + * in the input device, and adds ABS_MT_SLOT to the device capabilities.
> + */
> +int input_mt_create_slots(struct input_dev *dev, int max_slots)
> +{
> +	struct input_mt_slot *mt;
> +
> +	if (max_slots <= 0)
> +		return 0;
> +	mt = kzalloc(max_slots * sizeof(struct input_mt_slot), GFP_KERNEL);
> +	if (!mt)
> +		return -ENOMEM;
> +
> +	dev->mt = mt;
> +	dev->mtsize = max_slots;
> +	input_set_abs_params(dev, ABS_MT_SLOT, 0, max_slots - 1, 0, 0);
> +	return 0;
> +}
> +EXPORT_SYMBOL(input_mt_create_slots);
> +
> +/**
> + * input_mt_destroy_slots() - frees the MT slots of the input device
> + * @dev: input device with allocated MT slots
> + *
> + * This function is only needed in error path as the input core will
> + * automatically free the MT slots when the device is destroyed.
> + */
> +void input_mt_destroy_slots(struct input_dev *dev)
> +{
> +	kfree(dev->mt);
> +	dev->mt = NULL;
> +	dev->mtsize = 0;
> +}
> +EXPORT_SYMBOL(input_mt_destroy_slots);
> +
> +/**
>   * input_set_capability - mark device as capable of a certain event
>   * @dev: device that is capable of emitting or accepting event
>   * @type: type of the event (EV_KEY, EV_REL, etc...)
> @@ -1926,19 +1978,20 @@ static const struct file_operations input_fops = {
>  	.open = input_open_file,
>  };
>  
> -static void __init input_init_abs_bypass(void)
> +static void __init input_mt_init_maps(void)
>  {
> -	const unsigned int *p;
> -
> -	for (p = input_abs_bypass_init_data; *p; p++)
> -		input_abs_bypass[BIT_WORD(*p)] |= BIT_MASK(*p);
> +	int i;
> +	BUILD_BUG_ON(MT_ABS_SIZE != (typeof(input_mt_abs_map[0]))MT_ABS_SIZE);
> +	BUILD_BUG_ON(ARRAY_SIZE(input_mt_abs_map_init_data) > MT_ABS_SIZE);
> +	for (i = 0; i < ARRAY_SIZE(input_mt_abs_map_init_data); i++)
> +		input_mt_abs_map[input_mt_abs_map_init_data[i]] = i + 1;
>  }
>  
>  static int __init input_init(void)
>  {
>  	int err;
>  
> -	input_init_abs_bypass();
> +	input_mt_init_maps();
>  
>  	err = class_register(&input_class);
>  	if (err) {
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 7ed2251..bea6958 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -694,6 +694,7 @@ struct input_absinfo {
>  #define ABS_VOLUME		0x20
>  #define ABS_MISC		0x28
>  
> +#define ABS_MT_SLOT		0x2f	/* MT slot being modified */
>  #define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
>  #define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis (omit if circular) */
>  #define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
> @@ -814,6 +815,24 @@ struct input_absinfo {
>  #define MT_TOOL_PEN		1
>  
>  /*
> + * MT slot event lists
> + */
> +
> +#define MT_SLOT_ABS_EVENTS {	\
> +	ABS_MT_TOUCH_MAJOR,	\
> +	ABS_MT_TOUCH_MINOR,	\
> +	ABS_MT_WIDTH_MAJOR,	\
> +	ABS_MT_WIDTH_MINOR,	\
> +	ABS_MT_ORIENTATION,	\
> +	ABS_MT_POSITION_X,	\
> +	ABS_MT_POSITION_Y,	\
> +	ABS_MT_TOOL_TYPE,	\
> +	ABS_MT_BLOB_ID,		\
> +	ABS_MT_TRACKING_ID,	\
> +	ABS_MT_PRESSURE,	\
> +}
> +
> +/*
>   * Values describing the status of a force-feedback effect
>   */
>  #define FF_STATUS_STOPPED	0x00
> @@ -1080,6 +1099,9 @@ struct ff_effect {
>   * @sync: set to 1 when there were no new events since last EV_SYNC
>   * @abs: current values for reports from absolute axes
>   * @rep: current values for autorepeat parameters (delay, rate)
> + * @mt: array of MT slots
> + * @mtsize: number of allocated MT slots
> + * @slot: current MT slot
>   * @key: reflects current state of device's keys/buttons
>   * @led: reflects current state of device's LEDs
>   * @snd: reflects current state of sound effects
> @@ -1157,6 +1179,10 @@ struct input_dev {
>  	int abs[ABS_MAX + 1];
>  	int rep[REP_MAX + 1];
>  
> +	struct input_mt_slot *mt;
> +	int mtsize;
> +	int slot;
> +
>  	unsigned long key[BITS_TO_LONGS(KEY_CNT)];
>  	unsigned long led[BITS_TO_LONGS(LED_CNT)];
>  	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
> @@ -1405,6 +1431,11 @@ static inline void input_mt_sync(struct input_dev *dev)
>  	input_event(dev, EV_SYN, SYN_MT_REPORT, 0);
>  }
>  
> +static inline void input_mt_slot(struct input_dev *dev, int slot)
> +{
> +	input_event(dev, EV_ABS, ABS_MT_SLOT, slot);
> +}
> +
>  void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
>  
>  static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
> @@ -1484,5 +1515,18 @@ int input_ff_erase(struct input_dev *dev, int effect_id, struct file *file);
>  int input_ff_create_memless(struct input_dev *dev, void *data,
>  		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
>  
> +#define MT_ABS_SIZE 11
> +
> +/**
> + * struct input_mt_slot - represents the state of an input MT slot
> + * @abs: current values of ABS_MT axes for this slot
> + */
> +struct input_mt_slot {
> +	int abs[MT_ABS_SIZE];
> +};
> +
> +int input_mt_create_slots(struct input_dev *dev, int max_slots);
> +void input_mt_destroy_slots(struct input_dev *dev);
> +
>  #endif
>  #endif

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkwXCKwACgkQwuRiAT9o608AfwCfT15rbveKL/kCROKk5E7xg81L
zrYAoK8edxq+1HeBDBcHiuP2rDoy4Oi/
=J6e0
-----END PGP SIGNATURE-----
