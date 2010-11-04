Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0KDEWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 00:22:13 -0400
Received: from imr3.ericy.com ([198.24.6.13]:38448 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab0KDEWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:22:12 -0400
Date: Wed, 3 Nov 2010 21:21:21 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 2/8] hwmon: applesmc: Introduce a register
 lookup table
Message-ID: <20101104042121.GA19231@ericsson.com>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
 <1288511434-5662-3-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288511434-5662-3-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sun, Oct 31, 2010 at 03:50:28AM -0400, Henrik Rydberg wrote:
> One main problem with the current driver is the inability to quickly
> search for supported keys, resulting in detailed feature maps per
> machine model which are cumbersome to maintain.
> 
> This patch adds a register lookup table, which enables binary search
> for supported keys. The lookup also reduces the io frequency, so the
> original mutex is replaced by locks around the actual io.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hwmon/applesmc.c |  515 +++++++++++++++++++++++++---------------------
>  1 files changed, 281 insertions(+), 234 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 375e464..7f030f0 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -32,6 +32,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/input-polldev.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/timer.h>
>  #include <linux/dmi.h>
> @@ -51,6 +52,7 @@
> 
>  #define APPLESMC_MAX_DATA_LENGTH 32
> 
> +/* wait up to 32 ms for a status change. */
>  #define APPLESMC_MIN_WAIT      0x0040
>  #define APPLESMC_MAX_WAIT      0x8000
> 
> @@ -196,6 +198,22 @@ struct dmi_match_data {
>         int temperature_set;
>  };
> 
> +/* AppleSMC entry - cached register information */
> +struct applesmc_entry {
> +       char key[5];            /* four-letter key code */
> +       u8 valid;               /* set when entry is successfully read once */
> +       u8 len;                 /* bounded by APPLESMC_MAX_DATA_LENGTH */
> +       char type[5];           /* four-letter type code (padded) */
> +};
> +
> +/* Register lookup and registers common to all SMCs */
> +static struct applesmc_registers {
> +       struct mutex mutex;             /* register read/write mutex */
> +       unsigned int key_count;         /* number of SMC registers */
> +       bool init_complete;             /* true when fully initialized */
> +       struct applesmc_entry *entry;   /* key entries */
> +} smcreg;
> +
>  static const int debug;
>  static struct platform_device *pdev;
>  static s16 rest_x;
> @@ -217,14 +235,13 @@ static unsigned int fans_handled;
>  /* Indicates which temperature sensors set to use. */
>  static unsigned int applesmc_temperature_set;
> 
> -static DEFINE_MUTEX(applesmc_lock);
> -
>  /*
>   * Last index written to key_at_index sysfs file, and value to use for all other
>   * key_at_index_* sysfs files.
>   */
>  static unsigned int key_at_index;
> 
> +

unnecessary blank line

>  static struct workqueue_struct *applesmc_led_wq;
> 
>  /*
> @@ -241,16 +258,10 @@ static int __wait_status(u8 val)
>         for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
>                 udelay(us);
>                 if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
> -                       if (debug)
> -                               printk(KERN_DEBUG
> -                                       "Waited %d us for status %x\n",
> -                                       2 * us - APPLESMC_MIN_WAIT, val);
>                         return 0;
>                 }
>         }
> 
> -       pr_warn("wait status failed: %x != %x\n", val, inb(APPLESMC_CMD_PORT));
> -
>         return -EIO;
>  }
> 
> @@ -268,156 +279,228 @@ static int send_command(u8 cmd)
>                 if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == 0x0c)
>                         return 0;
>         }
> -       pr_warn("command failed: %x -> %x\n", cmd, inb(APPLESMC_CMD_PORT));
>         return -EIO;
>  }
> 
> -/*
> - * applesmc_read_key - reads len bytes from a given key, and put them in buffer.
> - * Returns zero on success or a negative error on failure. Callers must
> - * hold applesmc_lock.
> - */
> -static int applesmc_read_key(const char* key, u8* buffer, u8 len)
> +static int send_argument(const char *key)
>  {
>         int i;
> 
> -       if (len > APPLESMC_MAX_DATA_LENGTH) {
> -               pr_err("%s(): cannot read more than %d bytes\n",
> -                      __func__, APPLESMC_MAX_DATA_LENGTH);
> -               return -EINVAL;
> -       }
> -
> -       if (send_command(APPLESMC_READ_CMD))
> -               return -EIO;
> -
>         for (i = 0; i < 4; i++) {
>                 outb(key[i], APPLESMC_DATA_PORT);
>                 if (__wait_status(0x04))
>                         return -EIO;
>         }
> -       if (debug)
> -               printk(KERN_DEBUG "<%s", key);
> +       return 0;
> +}
> +
> +static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
> +{
> +       int i;
> +
> +       if (send_command(cmd) || send_argument(key)) {
> +               pr_warn("%s: read arg fail\n", key);
> +               return -EIO;
> +       }
> 
>         outb(len, APPLESMC_DATA_PORT);
> -       if (debug)
> -               printk(KERN_DEBUG ">%x", len);
> 
>         for (i = 0; i < len; i++) {
> -               if (__wait_status(0x05))
> +               if (__wait_status(0x05)) {
> +                       pr_warn("%s: read data fail\n", key);
>                         return -EIO;
> +               }
>                 buffer[i] = inb(APPLESMC_DATA_PORT);
> -               if (debug)
> -                       printk(KERN_DEBUG "<%x", buffer[i]);
>         }
> -       if (debug)
> -               printk(KERN_DEBUG "\n");
> 
>         return 0;
>  }
> 
> -/*
> - * applesmc_write_key - writes len bytes from buffer to a given key.
> - * Returns zero on success or a negative error on failure. Callers must
> - * hold applesmc_lock.
> - */
> -static int applesmc_write_key(const char* key, u8* buffer, u8 len)
> +static int write_smc(u8 cmd, const char *key, const u8 *buffer, u8 len)
>  {
>         int i;
> 
> -       if (len > APPLESMC_MAX_DATA_LENGTH) {
> -               pr_err("%s(): cannot write more than %d bytes\n",
> -                      __func__, APPLESMC_MAX_DATA_LENGTH);
> -               return -EINVAL;
> -       }
> -
> -       if (send_command(APPLESMC_WRITE_CMD))
> +       if (send_command(cmd) || send_argument(key)) {
> +               pr_warn("%s: write arg fail\n", key);
>                 return -EIO;
> -
> -       for (i = 0; i < 4; i++) {
> -               outb(key[i], APPLESMC_DATA_PORT);
> -               if (__wait_status(0x04))
> -                       return -EIO;
>         }
> 
>         outb(len, APPLESMC_DATA_PORT);
> 
>         for (i = 0; i < len; i++) {
> -               if (__wait_status(0x04))
> +               if (__wait_status(0x04)) {
> +                       pr_warn("%s: write data fail\n", key);
>                         return -EIO;
> +               }
>                 outb(buffer[i], APPLESMC_DATA_PORT);
>         }
> 
>         return 0;
>  }
> 
> +static int read_register_count(unsigned int *count)
> +{
> +       __be32 be;
> +       int ret;
> +
> +       ret = read_smc(APPLESMC_READ_CMD, KEY_COUNT_KEY, (u8 *)&be, 4);
> +       if (ret)
> +               return ret;
> +
> +       *count = be32_to_cpu(be);
> +       return 0;
> +}
> +
>  /*
> - * applesmc_get_key_at_index - get key at index, and put the result in key
> - * (char[6]). Returns zero on success or a negative error on failure. Callers
> - * must hold applesmc_lock.
> + * Serialized I/O
> + *
> + * Returns zero on success or a negative error on failure.
> + * All functions below are concurrency safe - callers should NOT hold lock.
>   */
> -static int applesmc_get_key_at_index(int index, char* key)
> +
> +static int applesmc_read_entry(const struct applesmc_entry *entry,
> +                              u8 *buf, u8 len)
>  {
> -       int i;
> -       u8 readkey[4];
> -       readkey[0] = index >> 24;
> -       readkey[1] = index >> 16;
> -       readkey[2] = index >> 8;
> -       readkey[3] = index;
> +       int ret;
> 
> -       if (send_command(APPLESMC_GET_KEY_BY_INDEX_CMD))
> -               return -EIO;
> +       if (entry->len != len)
> +               return -EINVAL;
> +       mutex_lock(&smcreg.mutex);
> +       ret = read_smc(APPLESMC_READ_CMD, entry->key, buf, len);
> +       mutex_unlock(&smcreg.mutex);
> 
> -       for (i = 0; i < 4; i++) {
> -               outb(readkey[i], APPLESMC_DATA_PORT);
> -               if (__wait_status(0x04))
> -                       return -EIO;
> -       }
> +       return ret;
> +}
> +
> +static int applesmc_write_entry(const struct applesmc_entry *entry,
> +                               const u8 *buf, u8 len)
> +{
> +       int ret;
> 
> -       outb(4, APPLESMC_DATA_PORT);
> +       if (entry->len != len)
> +               return -EINVAL;
> +       mutex_lock(&smcreg.mutex);
> +       ret = write_smc(APPLESMC_WRITE_CMD, entry->key, buf, len);
> +       mutex_unlock(&smcreg.mutex);
> +       return ret;
> +}
> 
> -       for (i = 0; i < 4; i++) {
> -               if (__wait_status(0x05))
> -                       return -EIO;
> -               key[i] = inb(APPLESMC_DATA_PORT);
> +static int applesmc_get_entry_by_index(int index, struct applesmc_entry *entry)
> +{

One thing I don't understand about the whole caching scheme - why don't you just
return (and use) a pointer to the cached entry ? Seems to me that would be much simpler.
If you want to return error types, you could use ERR_PTR, PTR_ERR, and IS_ERR.

> +       struct applesmc_entry *cache = &smcreg.entry[index];
> +       __be32 be;
> +       int ret;
> +
> +       if (cache->valid) {
> +               memcpy(entry, cache, sizeof(*entry));
> +               return 0;
>         }
> -       key[4] = 0;
> 
> -       return 0;
> +       mutex_lock(&smcreg.mutex);
> +
> +       be = cpu_to_be32(index);
> +       ret = read_smc(APPLESMC_GET_KEY_BY_INDEX_CMD, (u8 *)&be, cache->key, 4);
> +       if (ret)
> +               goto out;
> +       ret = read_smc(APPLESMC_GET_KEY_TYPE_CMD, cache->key, &cache->len, 6);

This one is a bit odd. cache->len is an u8. You are reading 6 bytes into it.
I assume this is supposed to fill both cache->len and cache->type in a single operation.

Not sure if this is a good idea. Seems to depend a lot on the assumption that
fields are consecutive. Might be safer to read the data into a temporary
6 byte buffer and copy it into ->len and ->type afterwards.

If that is not acceptable, please add a comment describing what you are doing here
and why.

> +       if (ret)
> +               goto out;
> +
> +       cache->type[4] = 0;

Why read 6 bytes above if you overwrite the last byte anyway ?

> +       cache->valid = 1;
> +       memcpy(entry, cache, sizeof(*entry));
> +
> +out:
> +       mutex_unlock(&smcreg.mutex);
> +       return ret;
>  }
> 
> -/*
> - * applesmc_get_key_type - get key type, and put the result in type (char[6]).
> - * Returns zero on success or a negative error on failure. Callers must
> - * hold applesmc_lock.
> - */
> -static int applesmc_get_key_type(char* key, char* type)
> +static int applesmc_get_lower_bound(unsigned int *lo, const char *key)
>  {
> -       int i;
> -
> -       if (send_command(APPLESMC_GET_KEY_TYPE_CMD))
> -               return -EIO;
> +       int begin = 0, end = smcreg.key_count;
> +       struct applesmc_entry entry;
> +       int ret;
> 
> -       for (i = 0; i < 4; i++) {
> -               outb(key[i], APPLESMC_DATA_PORT);
> -               if (__wait_status(0x04))
> -                       return -EIO;
> +       while (begin != end) {
> +               int middle = begin + (end - begin) / 2;
> +               ret = applesmc_get_entry_by_index(middle, &entry);
> +               if (ret)
> +                       return ret;
> +               if (strcmp(entry.key, key) < 0)
> +                       begin = middle + 1;
> +               else
> +                       end = middle;
>         }
> 
> -       outb(6, APPLESMC_DATA_PORT);
> +       *lo = begin;
> +       return 0;
> +}
> 
> -       for (i = 0; i < 6; i++) {
> -               if (__wait_status(0x05))
> -                       return -EIO;
> -               type[i] = inb(APPLESMC_DATA_PORT);
> +static int applesmc_get_upper_bound(unsigned int *hi, const char *key)
> +{
> +       int begin = 0, end = smcreg.key_count;
> +       struct applesmc_entry entry;
> +       int ret;
> +
> +       while (begin != end) {
> +               int middle = begin + (end - begin) / 2;
> +               ret = applesmc_get_entry_by_index(middle, &entry);
> +               if (ret)
> +                       return ret;
> +               if (strcmp(key, entry.key) < 0)
> +                       end = middle;
> +               else
> +                       begin = middle + 1;
>         }
> -       type[5] = 0;
> 
> +       *hi = begin;
>         return 0;
>  }
> 
> +static int applesmc_get_entry_by_key(const char *key,
> +                                    struct applesmc_entry *entry)
> +{
> +       int begin, end;
> +       int ret;
> +
> +       ret = applesmc_get_lower_bound(&begin, key);
> +       if (ret)
> +               return ret;
> +       ret = applesmc_get_upper_bound(&end, key);
> +       if (ret)
> +               return ret;
> +       if (end - begin != 1)
> +               return -EINVAL;
> +
> +       return applesmc_get_entry_by_index(begin, entry);
> +}
> +
> +static int applesmc_read_key(const char *key, u8 *buffer, u8 len)
> +{
> +       struct applesmc_entry entry;
> +       int ret;
> +
> +       ret = applesmc_get_entry_by_key(key, &entry);
> +       if (ret)
> +               return ret;
> +
> +       return applesmc_read_entry(&entry, buffer, len);
> +}
> +
> +static int applesmc_write_key(const char *key, const u8 *buffer, u8 len)
> +{
> +       struct applesmc_entry entry;
> +       int ret;
> +
> +       ret = applesmc_get_entry_by_key(key, &entry);
> +       if (ret)
> +               return ret;
> +
> +       return applesmc_write_entry(&entry, buffer, len);
> +}
> +
>  /*
> - * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z). Callers must
> - * hold applesmc_lock.
> + * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z).
>   */
>  static int applesmc_read_motion_sensor(int index, s16* value)
>  {
> @@ -455,8 +538,6 @@ static int applesmc_device_init(void)
>         if (!applesmc_accelerometer)
>                 return 0;
> 
> -       mutex_lock(&applesmc_lock);
> -
>         for (total = INIT_TIMEOUT_MSECS; total > 0; total -= INIT_WAIT_MSECS) {
>                 if (!applesmc_read_key(MOTION_SENSOR_KEY, buffer, 2) &&
>                                 (buffer[0] != 0x00 || buffer[1] != 0x00)) {
> @@ -472,33 +553,90 @@ static int applesmc_device_init(void)
>         pr_warn("failed to init the device\n");
> 
>  out:
> -       mutex_unlock(&applesmc_lock);
>         return ret;
>  }
> 
>  /*
> - * applesmc_get_fan_count - get the number of fans. Callers must NOT hold
> - * applesmc_lock.
> + * applesmc_get_fan_count - get the number of fans.
>   */
>  static int applesmc_get_fan_count(void)
>  {
>         int ret;
>         u8 buffer[1];
> 
> -       mutex_lock(&applesmc_lock);
> -
>         ret = applesmc_read_key(FANS_COUNT, buffer, 1);
> 
> -       mutex_unlock(&applesmc_lock);
>         if (ret)
>                 return ret;
>         else
>                 return buffer[0];
>  }
> 
> +/*
> + * applesmc_init_smcreg_try - Try to initialize register cache. Idempotent.
> + */
> +static int applesmc_init_smcreg_try(void)
> +{
> +       struct applesmc_registers *s = &smcreg;
> +       int ret;
> +
> +       if (s->init_complete)
> +               return 0;
> +
> +       mutex_init(&s->mutex);
> +
> +       ret = read_register_count(&s->key_count);
> +       if (ret)
> +               return ret;
> +
> +       if (!s->entry)
> +               s->entry = kcalloc(s->key_count, sizeof(*s->entry), GFP_KERNEL);
> +       if (!s->entry)
> +               return -ENOMEM;
> +
> +       s->init_complete = true;
> +
> +       pr_info("key=%d\n", s->key_count);
> +
> +       return 0;
> +}
> +
> +/*
> + * applesmc_init_smcreg - Initialize register cache.
> + *
> + * Retries until initialization is successful, or the operation times out.
> + *
> + */
> +static int applesmc_init_smcreg(void)
> +{
> +       int ms, ret;
> +
> +       for (ms = 0; ms < INIT_TIMEOUT_MSECS; ms += INIT_WAIT_MSECS) {
> +               ret = applesmc_init_smcreg_try();
> +               if (!ret)
> +                       return 0;
> +               pr_warn("slow init, retrying\n");
> +               msleep(INIT_WAIT_MSECS);
> +       }
> +
> +       return ret;
> +}
> +
> +static void applesmc_destroy_smcreg(void)
> +{
> +       kfree(smcreg.entry);
> +       smcreg.entry = NULL;

Do you also have to reset init_complete ?

> +}
> +
>  /* Device model stuff */
>  static int applesmc_probe(struct platform_device *dev)
>  {
> +       int ret;
> +
> +       ret = applesmc_init_smcreg();
> +       if (ret)
> +               return ret;
> +
>         applesmc_device_init();
> 
>         return 0;
> @@ -507,10 +645,8 @@ static int applesmc_probe(struct platform_device *dev)
>  /* Synchronize device with memorized backlight state */
>  static int applesmc_pm_resume(struct device *dev)
>  {
> -       mutex_lock(&applesmc_lock);
>         if (applesmc_light)
>                 applesmc_write_key(BACKLIGHT_KEY, backlight_state, 2);
> -       mutex_unlock(&applesmc_lock);
>         return 0;
>  }
> 
> @@ -551,20 +687,15 @@ static void applesmc_idev_poll(struct input_polled_dev *dev)
>         struct input_dev *idev = dev->input;
>         s16 x, y;
> 
> -       mutex_lock(&applesmc_lock);
> -
>         if (applesmc_read_motion_sensor(SENSOR_X, &x))
> -               goto out;
> +               return;
>         if (applesmc_read_motion_sensor(SENSOR_Y, &y))
> -               goto out;
> +               return;
> 
>         x = -x;
>         input_report_abs(idev, ABS_X, x - rest_x);
>         input_report_abs(idev, ABS_Y, y - rest_y);
>         input_sync(idev);
> -
> -out:
> -       mutex_unlock(&applesmc_lock);
>  }
> 
>  /* Sysfs Files */
> @@ -581,8 +712,6 @@ static ssize_t applesmc_position_show(struct device *dev,
>         int ret;
>         s16 x, y, z;
> 
> -       mutex_lock(&applesmc_lock);
> -
>         ret = applesmc_read_motion_sensor(SENSOR_X, &x);
>         if (ret)
>                 goto out;
> @@ -594,7 +723,6 @@ static ssize_t applesmc_position_show(struct device *dev,
>                 goto out;
> 
>  out:
> -       mutex_unlock(&applesmc_lock);
>         if (ret)
>                 return ret;
>         else
> @@ -604,18 +732,17 @@ out:
>  static ssize_t applesmc_light_show(struct device *dev,
>                                 struct device_attribute *attr, char *sysfsbuf)
>  {
> +       struct applesmc_entry entry;
>         static int data_length;
>         int ret;
>         u8 left = 0, right = 0;
> -       u8 buffer[10], query[6];
> -
> -       mutex_lock(&applesmc_lock);
> +       u8 buffer[10];
> 
>         if (!data_length) {
> -               ret = applesmc_get_key_type(LIGHT_SENSOR_LEFT_KEY, query);
> +               ret = applesmc_get_entry_by_key(LIGHT_SENSOR_LEFT_KEY, &entry);
>                 if (ret)
>                         goto out;
> -               data_length = clamp_val(query[0], 0, 10);
> +               data_length = clamp_val(entry.len, 0, 10);
>                 pr_info("light sensor data length set to %d\n", data_length);
>         }
> 
> @@ -632,7 +759,6 @@ static ssize_t applesmc_light_show(struct device *dev,
>         right = buffer[2];
> 
>  out:
> -       mutex_unlock(&applesmc_lock);
>         if (ret)
>                 return ret;
>         else
> @@ -661,14 +787,10 @@ static ssize_t applesmc_show_temperature(struct device *dev,
>         const char* key =
>                 temperature_sensors_sets[applesmc_temperature_set][attr->index];
> 
> -       mutex_lock(&applesmc_lock);
> -
>         ret = applesmc_read_key(key, buffer, 2);
>         temp = buffer[0]*1000;
>         temp += (buffer[1] >> 6) * 250;
> 
> -       mutex_unlock(&applesmc_lock);
> -
>         if (ret)
>                 return ret;
>         else
> @@ -691,12 +813,9 @@ static ssize_t applesmc_show_fan_speed(struct device *dev,
>         newkey[3] = fan_speed_keys[sensor_attr->nr][3];
>         newkey[4] = 0;
> 
> -       mutex_lock(&applesmc_lock);
> -
>         ret = applesmc_read_key(newkey, buffer, 2);
>         speed = ((buffer[0] << 8 | buffer[1]) >> 2);
> 
> -       mutex_unlock(&applesmc_lock);
>         if (ret)
>                 return ret;
>         else
> @@ -725,13 +844,10 @@ static ssize_t applesmc_store_fan_speed(struct device *dev,
>         newkey[3] = fan_speed_keys[sensor_attr->nr][3];
>         newkey[4] = 0;
> 
> -       mutex_lock(&applesmc_lock);
> -
>         buffer[0] = (speed >> 6) & 0xff;
>         buffer[1] = (speed << 2) & 0xff;
>         ret = applesmc_write_key(newkey, buffer, 2);
> 
> -       mutex_unlock(&applesmc_lock);
>         if (ret)
>                 return ret;
>         else
> @@ -746,12 +862,9 @@ static ssize_t applesmc_show_fan_manual(struct device *dev,
>         u8 buffer[2];
>         struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> 
> -       mutex_lock(&applesmc_lock);
> -
>         ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
>         manual = ((buffer[0] << 8 | buffer[1]) >> attr->index) & 0x01;
> 
> -       mutex_unlock(&applesmc_lock);
>         if (ret)
>                 return ret;
>         else
> @@ -770,8 +883,6 @@ static ssize_t applesmc_store_fan_manual(struct device *dev,
> 
>         input = simple_strtoul(sysfsbuf, NULL, 10);
> 
> -       mutex_lock(&applesmc_lock);
> -
>         ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
>         val = (buffer[0] << 8 | buffer[1]);
>         if (ret)
> @@ -788,7 +899,6 @@ static ssize_t applesmc_store_fan_manual(struct device *dev,
>         ret = applesmc_write_key(FANS_MANUAL, buffer, 2);
> 
>  out:
> -       mutex_unlock(&applesmc_lock);
>         if (ret)
>                 return ret;
>         else
> @@ -810,12 +920,9 @@ static ssize_t applesmc_show_fan_position(struct device *dev,
>         newkey[3] = FAN_POSITION[3];
>         newkey[4] = 0;
> 
> -       mutex_lock(&applesmc_lock);
> -
>         ret = applesmc_read_key(newkey, buffer, 16);
>         buffer[16] = 0;
> 
> -       mutex_unlock(&applesmc_lock);
>         if (ret)
>                 return ret;
>         else
> @@ -831,18 +938,14 @@ static ssize_t applesmc_calibrate_show(struct device *dev,
>  static ssize_t applesmc_calibrate_store(struct device *dev,
>         struct device_attribute *attr, const char *sysfsbuf, size_t count)
>  {
> -       mutex_lock(&applesmc_lock);
>         applesmc_calibrate();
> -       mutex_unlock(&applesmc_lock);
> 
>         return count;
>  }
> 
>  static void applesmc_backlight_set(struct work_struct *work)
>  {
> -       mutex_lock(&applesmc_lock);
>         applesmc_write_key(BACKLIGHT_KEY, backlight_state, 2);
> -       mutex_unlock(&applesmc_lock);
>  }
>  static DECLARE_WORK(backlight_work, &applesmc_backlight_set);
> 
> @@ -865,13 +968,10 @@ static ssize_t applesmc_key_count_show(struct device *dev,
>         u8 buffer[4];
>         u32 count;
> 
> -       mutex_lock(&applesmc_lock);
> -
>         ret = applesmc_read_key(KEY_COUNT_KEY, buffer, 4);
>         count = ((u32)buffer[0]<<24) + ((u32)buffer[1]<<16) +
>                                                 ((u32)buffer[2]<<8) + buffer[3];
> 
> -       mutex_unlock(&applesmc_lock);
>         if (ret)
>                 return ret;
>         else
> @@ -881,113 +981,56 @@ static ssize_t applesmc_key_count_show(struct device *dev,
>  static ssize_t applesmc_key_at_index_read_show(struct device *dev,
>                                 struct device_attribute *attr, char *sysfsbuf)
>  {
> -       char key[5];
> -       char info[6];
> +       struct applesmc_entry entry;
>         int ret;
> 
> -       mutex_lock(&applesmc_lock);
> -
> -       ret = applesmc_get_key_at_index(key_at_index, key);
> -
> -       if (ret || !key[0]) {
> -               mutex_unlock(&applesmc_lock);
> -
> -               return -EINVAL;
> -       }
> -
> -       ret = applesmc_get_key_type(key, info);
> -
> -       if (ret) {
> -               mutex_unlock(&applesmc_lock);
> -
> +       ret = applesmc_get_entry_by_index(key_at_index, &entry);
> +       if (ret)
>                 return ret;
> -       }
> -
> -       /*
> -        * info[0] maximum value (APPLESMC_MAX_DATA_LENGTH) is much lower than
> -        * PAGE_SIZE, so we don't need any checks before writing to sysfsbuf.
> -        */
> -       ret = applesmc_read_key(key, sysfsbuf, info[0]);
> -
> -       mutex_unlock(&applesmc_lock);
> -
> -       if (!ret) {
> -               return info[0];
> -       } else {
> +       ret = applesmc_read_entry(&entry, sysfsbuf, entry.len);
> +       if (ret)
>                 return ret;
> -       }
> +
> +       return entry.len;
>  }
> 
>  static ssize_t applesmc_key_at_index_data_length_show(struct device *dev,
>                                 struct device_attribute *attr, char *sysfsbuf)
>  {
> -       char key[5];
> -       char info[6];
> +       struct applesmc_entry entry;
>         int ret;
> 
> -       mutex_lock(&applesmc_lock);
> -
> -       ret = applesmc_get_key_at_index(key_at_index, key);
> -
> -       if (ret || !key[0]) {
> -               mutex_unlock(&applesmc_lock);
> -
> -               return -EINVAL;
> -       }
> -
> -       ret = applesmc_get_key_type(key, info);
> -
> -       mutex_unlock(&applesmc_lock);
> -
> -       if (!ret)
> -               return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", info[0]);
> -       else
> +       ret = applesmc_get_entry_by_index(key_at_index, &entry);
> +       if (ret)
>                 return ret;
> +
> +       return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", entry.len);
>  }
> 
>  static ssize_t applesmc_key_at_index_type_show(struct device *dev,
>                                 struct device_attribute *attr, char *sysfsbuf)
>  {
> -       char key[5];
> -       char info[6];
> +       struct applesmc_entry entry;
>         int ret;
> 
> -       mutex_lock(&applesmc_lock);
> -
> -       ret = applesmc_get_key_at_index(key_at_index, key);
> -
> -       if (ret || !key[0]) {
> -               mutex_unlock(&applesmc_lock);
> -
> -               return -EINVAL;
> -       }
> -
> -       ret = applesmc_get_key_type(key, info);
> -
> -       mutex_unlock(&applesmc_lock);
> -
> -       if (!ret)
> -               return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", info+1);
> -       else
> +       ret = applesmc_get_entry_by_index(key_at_index, &entry);
> +       if (ret)
>                 return ret;
> +
> +       return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", entry.type);
>  }
> 
>  static ssize_t applesmc_key_at_index_name_show(struct device *dev,
>                                 struct device_attribute *attr, char *sysfsbuf)
>  {
> -       char key[5];
> +       struct applesmc_entry entry;
>         int ret;
> 
> -       mutex_lock(&applesmc_lock);
> -
> -       ret = applesmc_get_key_at_index(key_at_index, key);
> -
> -       mutex_unlock(&applesmc_lock);
> +       ret = applesmc_get_entry_by_index(key_at_index, &entry);
> +       if (ret)
> +               return ret;
> 
> -       if (!ret && key[0])
> -               return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", key);
> -       else
> -               return -EINVAL;
> +       return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", entry.key);
>  }
> 
>  static ssize_t applesmc_key_at_index_show(struct device *dev,
> @@ -999,12 +1042,8 @@ static ssize_t applesmc_key_at_index_show(struct device *dev,
>  static ssize_t applesmc_key_at_index_store(struct device *dev,
>         struct device_attribute *attr, const char *sysfsbuf, size_t count)
>  {
> -       mutex_lock(&applesmc_lock);
> -
>         key_at_index = simple_strtoul(sysfsbuf, NULL, 10);
> 
> -       mutex_unlock(&applesmc_lock);
> -
>         return count;
>  }
> 
> @@ -1640,10 +1679,15 @@ static int __init applesmc_init(void)
>                 goto out_driver;
>         }
> 
> -       ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_name.attr);
> +       /* create register cache */
> +       ret = applesmc_init_smcreg();
>         if (ret)
>                 goto out_device;
> 
> +       ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_name.attr);
> +       if (ret)
> +               goto out_smcreg;
> +
>         /* Create key enumeration sysfs files */
>         ret = sysfs_create_group(&pdev->dev.kobj, &key_enumeration_group);
>         if (ret)
> @@ -1745,6 +1789,8 @@ out_fans:
>         sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
>  out_name:
>         sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
> +out_smcreg:
> +       applesmc_destroy_smcreg();
>  out_device:
>         platform_device_unregister(pdev);
>  out_driver:
> @@ -1773,6 +1819,7 @@ static void __exit applesmc_exit(void)
>                                    &fan_attribute_groups[--fans_handled]);
>         sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
>         sysfs_remove_file(&pdev->dev.kobj, &dev_attr_name.attr);
> +       applesmc_destroy_smcreg();
>         platform_device_unregister(pdev);
>         platform_driver_unregister(&applesmc_driver);
>         release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
> --
> 1.7.1
> 
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
