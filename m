Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2H0VBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:01:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54188 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab2H0VBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:01:45 -0400
MIME-Version: 1.0
In-Reply-To: <1345241877-16200-7-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-7-git-send-email-cheiny@synaptics.com>
Date: Mon, 27 Aug 2012 14:01:43 -0700
Message-ID: <CACRpkdbhqOLiHPKMJ-EC=PTH+eHkHHUbqSK4N08fF=DmD_OErA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/17] input: RMI4 firmware update
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 3:17 PM, Christopher Heiny <cheiny@synaptics.com> wrote:

No commit message. Describe exactly what this feature is for and how
it works and how it differs from standard kernel firmware loading.
(Where the kernel loads firmware into devices at boot time.)
i.e. mention that all devices have their own flash memory etc.

> +#define DEBUG

No, use previously describe Kconfig approach.

> +#define RIM_HACK 1

Que ce que c'est?

Should this also be a Kconfig, or mayble always enabled simply,
and detected at runtime if need be?

(...)
> +#define HAS_BSR_MASK 0x20

"Has*" sounds like something boolean, I guess this bit tells if you
have BSR, so say:

#include <linux/bitops.h>

#define HAS_BSR BIT(5)

> +#define PRODUCT_ID_OFFSET 0x10
> +#define PRODUCT_ID_SIZE 10
> +#define PRODUCT_INFO_OFFSET 0x1E
> +#define PRODUCT_INFO_SIZE 2

It's really nice that you have this info in the product.

> +/** Image file V5, Option 0

Pls actually add some kerneldoc here :-)
This is malformed as it looks now, anything following /** will be parsed.

> + */
> +struct image_header {
> +       u32 checksum;
> +       unsigned int image_size;

Should this be size_t?

> +       unsigned int config_size;

size_t?

> +       unsigned char options;

u8? Some kind of enum? (If it's a bitfield use u8.)

> +       unsigned char bootloader_version;

u8?

> +       u8 product_id[RMI_PRODUCT_ID_LENGTH + 1];
> +       unsigned char product_info[PRODUCT_INFO_SIZE];

u8[]?

> +};
> +
> +static u32 extract_u32(const u8 *ptr)
> +{
> +       return (u32)ptr[0] +
> +               (u32)ptr[1] * 0x100 +
> +               (u32)ptr[2] * 0x10000 +
> +               (u32)ptr[3] * 0x1000000;

This looks very dangerous from an endianness point of view.
If you run this driver in a big endian system, what happens?

> +}
> +
> +struct reflash_data {

This would be nice to kerneldoc.

> +       struct rmi_device *rmi_dev;
> +       struct pdt_entry *f01_pdt;
> +       union f01_basic_queries f01_queries;
> +       union f01_device_control_0 f01_controls;
> +       char product_id[RMI_PRODUCT_ID_LENGTH+1];
> +       struct pdt_entry *f34_pdt;
> +       u8 bootloader_id[2];
> +       union f34_query_regs f34_queries;
> +       union f34_control_status f34_controls;
> +       const u8 *firmware_data;
> +       const u8 *config_data;
> +};
> +
> +/* If this parameter is true, we will update the firmware regardless of
> + * the versioning info.
> + */
> +static bool force = 1;

= true;

> +module_param(force, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(param, "Force reflash of RMI4 devices");

Looks reasonable...

> +
> +/* If this parameter is not NULL, we'll use that name for the firmware image,
> + * instead of getting it from the F01 queries.
> + */
> +static char *img_name;
> +module_param(img_name, charp, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(param, "Name of the RMI4 firmware image");

Is there a default name?

(...)
> +#define MIN_SLEEP_TIME_US 50
> +#define MAX_SLEEP_TIME_US 100
> +
> +/* Wait until the status is idle and we're ready to continue */
> +static int wait_for_idle(struct reflash_data *data, int timeout_ms)
> +{
> +       int timeout_count = ((timeout_ms * 1000) / MAX_SLEEP_TIME_US) + 1;

Use DIV_ROUND_UP() from <linux/kernel.h>:

= DIV_ROUND_UP((timeout_ms * 1000), MAX_SLEEP_TIME_US);

> +       int count = 0;

Consider just int i;

(...)
> +static int read_f34_queries(struct reflash_data *data)
> +{
> +       int retval;
> +       u8 id_str[3];

If it's a string it should be char id_str[3]; right?

(...)
> +#ifdef DEBUG
> +       dev_info(&data->rmi_dev->dev, "Got F34 data->f34_queries.\n");

This is equivalent to using dev_dbg() so use that.

> +       dev_info(&data->rmi_dev->dev, "F34 bootloader id: %s (%#04x %#04x)\n",
> +                id_str, data->bootloader_id[0], data->bootloader_id[1]);
> +       dev_info(&data->rmi_dev->dev, "F34 has config id: %d\n",
> +                data->f34_queries.has_config_id);
> +       dev_info(&data->rmi_dev->dev, "F34 unlocked:      %d\n",
> +                data->f34_queries.unlocked);
> +       dev_info(&data->rmi_dev->dev, "F34 regMap:        %d\n",
> +                data->f34_queries.reg_map);
> +       dev_info(&data->rmi_dev->dev, "F34 block size:    %d\n",
> +                data->f34_queries.block_size);
> +       dev_info(&data->rmi_dev->dev, "F34 fw blocks:     %d\n",
> +                data->f34_queries.fw_block_count);
> +       dev_info(&data->rmi_dev->dev, "F34 config blocks: %d\n",
> +                data->f34_queries.config_block_count);

Dito.

(...)
> +static int enter_flash_programming(struct reflash_data *data)
> +{
> +       int retval;
> +       union f01_device_status device_status;
> +       struct rmi_device *rmi_dev = data->rmi_dev;
> +
> +       retval = write_bootloader_id(data);
> +       if (retval < 0)
> +               return retval;
> +
> +       dev_info(&rmi_dev->dev, "Enabling flash programming.\n");
> +       retval = write_f34_command(data, F34_ENABLE_FLASH_PROG);
> +       if (retval < 0)
> +               return retval;
> +
> +#if    RIM_HACK
> +       data->f01_controls.nosleep = true;
> +       retval = write_f01_controls(data);
> +       if (retval < 0)
> +               return retval;
> +#endif

So just default-enable this since it's defined to 1? BTW what is an RIM?

(...)
> +       dev_info(&rmi_dev->dev, "HOORAY! Programming is enabled!\n");

I always enjoy it when the kernel is happy ;-)

(...)
> +static int write_firmware(struct reflash_data *data)
> +{
> +       return write_blocks(data, (u8 *) data->firmware_data,
> +               data->f34_queries.fw_block_count, F34_WRITE_FW_BLOCK);
> +}
> +
> +static int write_configuration(struct reflash_data *data)
> +{
> +       return write_blocks(data, (u8 *) data->config_data,
> +               data->f34_queries.config_block_count, F34_WRITE_CONFIG_BLOCK);
> +}

Now there are these one-function call functions again, are you sure you
can't just inline these?

> +static void reflash_firmware(struct reflash_data *data)
> +{
> +#ifdef DEBUG
> +       struct timespec start;
> +       struct timespec end;
> +       s64 duration_ns;
> +#endif

This actually seems to be a valid case for #ifdef:ing!

> +       int retval = 0;
> +
> +       retval = enter_flash_programming(data);
> +       if (retval)
> +               return;
> +
> +       retval = write_bootloader_id(data);
> +       if (retval)
> +               return;
> +
> +#ifdef DEBUG
> +       dev_info(&data->rmi_dev->dev, "Erasing FW...\n");

dev_dbg() includes the DEBUG flag.

> +       getnstimeofday(&start);

But this is a

> +#endif
> +       retval = write_f34_command(data, F34_ERASE_ALL);
> +       if (retval)
> +               return;
> +
> +       retval = wait_for_idle(data, F34_ERASE_WAIT_MS);
> +       if (retval) {
> +               dev_err(&data->rmi_dev->dev,
> +                       "Failed to reach idle state. Code: %d.\n", retval);
> +               return;
> +       }
> +#ifdef DEBUG
> +       getnstimeofday(&end);
> +       duration_ns = timespec_to_ns(&end) - timespec_to_ns(&start);
> +       dev_info(&data->rmi_dev->dev,
> +                "Erase complete, time: %lld ns.\n", duration_ns);

dev_dbg()

> +#endif
> +
> +       if (data->firmware_data) {
> +#ifdef DEBUG
> +               dev_info(&data->rmi_dev->dev, "Writing firmware...\n");
> +               getnstimeofday(&start);
> +#endif
> +               retval = write_firmware(data);
> +               if (retval)
> +                       return;
> +#ifdef DEBUG
> +               getnstimeofday(&end);
> +               duration_ns = timespec_to_ns(&end) - timespec_to_ns(&start);
> +               dev_info(&data->rmi_dev->dev,
> +                        "Done writing FW, time: %lld ns.\n", duration_ns);
> +#endif
> +       }
> +
> +       if (data->config_data) {
> +#ifdef DEBUG
> +               dev_info(&data->rmi_dev->dev, "Writing configuration...\n");
> +               getnstimeofday(&start);
> +#endif
> +               retval = write_configuration(data);
> +               if (retval)
> +                       return;
> +#ifdef DEBUG
> +               getnstimeofday(&end);
> +               duration_ns = timespec_to_ns(&end) - timespec_to_ns(&start);
> +               dev_info(&data->rmi_dev->dev,
> +                        "Done writing config, time: %lld ns.\n", duration_ns);
> +#endif
> +       }
> +}

Hard to avoid #ifdef:ing here, but maybe you could use some stub functions.

(...)
> +void rmi4_fw_update(struct rmi_device *rmi_dev,
> +               struct pdt_entry *f01_pdt, struct pdt_entry *f34_pdt)
> +{
> +#ifdef DEBUG
> +       struct timespec start;
> +       struct timespec end;
> +       s64 duration_ns;
> +#endif
> +       char firmware_name[RMI_PRODUCT_ID_LENGTH + 12];
> +       const struct firmware *fw_entry = NULL;
> +       int retval;
> +       struct image_header header;
> +       union pdt_properties pdt_props;
> +       struct reflash_data data = {
> +               .rmi_dev = rmi_dev,
> +               .f01_pdt = f01_pdt,
> +               .f34_pdt = f34_pdt,
> +       };
> +       struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
> +
> +       dev_info(&rmi_dev->dev, "%s called.\n", __func__);
> +#ifdef DEBUG
> +       getnstimeofday(&start);
> +#endif
> +
> +       retval = rmi_read(rmi_dev, PDT_PROPERTIES_LOCATION, pdt_props.regs);
> +       if (retval < 0) {
> +               dev_warn(&rmi_dev->dev,
> +                        "Failed to read PDT props at %#06x (code %d). Assuming 0x00.\n",
> +                        PDT_PROPERTIES_LOCATION, retval);
> +       }
> +       if (pdt_props.has_bsr) {
> +               dev_warn(&rmi_dev->dev,
> +                        "Firmware update for LTS not currently supported.\n");
> +               return;
> +       }
> +
> +       retval = read_f01_queries(&data);
> +       if (retval) {
> +               dev_err(&rmi_dev->dev, "F01 queries failed, code = %d.\n",
> +                       retval);
> +               return;
> +       }
> +       retval = read_f34_queries(&data);
> +       if (retval) {
> +               dev_err(&rmi_dev->dev, "F34 queries failed, code = %d.\n",
> +                       retval);
> +               return;
> +       }
> +       if (pdata->firmware_name && strlen(pdata->firmware_name))
> +               snprintf(firmware_name, sizeof(firmware_name), "rmi4/%s.img",
> +                       pdata->firmware_name);

Aha this works out nicely with the firmware name from pdata...

> +       else
> +               snprintf(firmware_name, sizeof(firmware_name), "rmi4/%s.img",
> +                       (img_name && strlen(img_name))
> +                               ? img_name : data.product_id);

And in the other case as module parameter right?

> +       dev_info(&rmi_dev->dev, "Requesting %s.\n", firmware_name);
> +       retval = request_firmware(&fw_entry, firmware_name, &rmi_dev->dev);
> +       if (retval != 0) {
> +               dev_err(&rmi_dev->dev, "Firmware %s not available, code = %d\n",
> +                       firmware_name, retval);
> +               return;
> +       }
> +
> +#ifdef DEBUG

I don't see why this would be #ifdef DEBUG, it seems to be very useful
information
to always have in the dmesg.

> +       dev_info(&rmi_dev->dev, "Got firmware, size: %d.\n", fw_entry->size);

dev_dbg() if you insist to have this as debug only.

> +       extract_header(fw_entry->data, 0, &header);
> +       dev_info(&rmi_dev->dev, "Img checksum:           %#08X\n",
> +                header.checksum);
> +       dev_info(&rmi_dev->dev, "Img image size:         %d\n",
> +                header.image_size);
> +       dev_info(&rmi_dev->dev, "Img config size:        %d\n",
> +                header.config_size);
> +       dev_info(&rmi_dev->dev, "Img bootloader version: %d\n",
> +                header.bootloader_version);
> +       dev_info(&rmi_dev->dev, "Img product id:         %s\n",
> +                header.product_id);
> +       dev_info(&rmi_dev->dev, "Img product info:       %#04x %#04x\n",
> +                header.product_info[0], header.product_info[1]);
> +#endif

Yours,
Linus Walleij
