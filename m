Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1KCVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:25:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42419 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1KCVZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <1320354450.3000.60.camel@pc786-ubu.gnet.global.vpn>
References: <1320354450.3000.60.camel@pc786-ubu.gnet.global.vpn>
Date: Thu, 3 Nov 2011 16:25:53 -0500
Message-ID: <CAAOQ2gvtwfwwh+YVjJNEX8GFVK3QatKB5miStiDTg4p_8myuxw@mail.gmail.com>
Subject: Re: [PATCH v3] rtc: ds1307: generalise ram size and offset
From: David Anders <danders.dev@gmail.com>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org, x0132446@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Austin,

On Thu, Nov 3, 2011 at 4:07 PM, Austin Boyle <Austin.Boyle@aviatnet.com> wrote:
> From: Austin Boyle <Austin.Boyle@aviatnet.com>
>
> This patch generalises NVRAM to support RAM with other size and offset, such
> as the 64 bytes of SRAM on the mcp7941x. Register offsets are added to chip
> description instead of being hard-coded into probe function.
>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: David Anderson <danders.dev@gmail.com>

please correct my name: David Anders

> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>

i'll apply and test for MCP7941x parts

> ---
> this patch is based on Wolfram Sang's tree:
> git://git.pengutronix.de/git/wsa/linux-2.6.git ds1307
>
> patch depends on:
> rtc: ds1307: comment and format cleanup 21af5f7bd6
> rtc: ds1307: simplify irq setup code  8c63e03627
> rtc: ds1307: refactor chip_desc table e246db081d
> rtc: add initial support for mcp7941x parts e69bba2d3a
>
> --- a/drivers/rtc/rtc-ds1307.c  2011-10-10 11:22:22.674690998 +1300
> +++ b/drivers/rtc/rtc-ds1307.c  2011-11-04 10:02:27.859155009 +1300
> @@ -104,6 +104,8 @@ enum ds_type {
>
>  struct ds1307 {
>        u8                      offset; /* register's offset */
> +       u16                     nvram_offset;
> +       u16                     nvram_size;
>        u8                      regs[11];
>        enum ds_type            type;
>        unsigned long           flags;
> @@ -119,26 +121,37 @@ struct ds1307 {
>  };
>
>  struct chip_desc {
> -       unsigned                nvram56:1;
>        unsigned                alarm:1;
> +       u8                      offset;
> +       u16                     nvram_offset;
> +       u16                     nvram_size;
>  };
>
>  static const struct chip_desc chips[last_ds_type] = {
>        [ds_1307] = {
> -               .nvram56        = 1,
> +               .nvram_offset   = 8,
> +               .nvram_size     = 56, /* 56 bytes NVRAM */
>        },
>        [ds_1337] = {
>                .alarm          = 1,
>        },
>        [ds_1338] = {
> -               .nvram56        = 1,
> +               .nvram_offset   = 8,
> +               .nvram_size     = 56, /* 56 bytes NVRAM */
>        },
>        [ds_1339] = {
>                .alarm          = 1,
>        },
> +       [ds_1388] = {
> +               .offset         = 1, /* seconds starts at 1 */
> +       },
>        [ds_3231] = {
>                .alarm          = 1,
>        },
> +       [mcp7941x] = {
> +               .nvram_offset   = 0x20,
> +               .nvram_size     = 64, /* 64 bytes SRAM */
> +       },
>  };
>
>  static const struct i2c_device_id ds1307_id[] = {
> @@ -543,8 +556,6 @@ static const struct rtc_class_ops ds13xx
>
>  /*----------------------------------------------------------------------*/
>
> -#define NVRAM_SIZE     56
> -
>  static ssize_t
>  ds1307_nvram_read(struct file *filp, struct kobject *kobj,
>                struct bin_attribute *attr,
> @@ -557,14 +568,15 @@ ds1307_nvram_read(struct file *filp, str
>        client = kobj_to_i2c_client(kobj);
>        ds1307 = i2c_get_clientdata(client);
>
> -       if (unlikely(off >= NVRAM_SIZE))
> +       if (unlikely(off >= ds1307->nvram_size))
>                return 0;
> -       if ((off + count) > NVRAM_SIZE)
> -               count = NVRAM_SIZE - off;
> +       if ((off + count) > ds1307->nvram_size)
> +               count = ds1307->nvram_size - off;
>        if (unlikely(!count))
>                return count;
>
> -       result = ds1307->read_block_data(client, 8 + off, count, buf);
> +       result = ds1307->read_block_data(client, ds1307->nvram_offset + off,
> +                                                               count, buf);
>        if (result < 0)
>                dev_err(&client->dev, "%s error %d\n", "nvram read", result);
>        return result;
> @@ -582,14 +594,15 @@ ds1307_nvram_write(struct file *filp, st
>        client = kobj_to_i2c_client(kobj);
>        ds1307 = i2c_get_clientdata(client);
>
> -       if (unlikely(off >= NVRAM_SIZE))
> +       if (unlikely(off >= ds1307->nvram_size))
>                return -EFBIG;
> -       if ((off + count) > NVRAM_SIZE)
> -               count = NVRAM_SIZE - off;
> +       if ((off + count) > ds1307->nvram_size)
> +               count = ds1307->nvram_size - off;
>        if (unlikely(!count))
>                return count;
>
> -       result = ds1307->write_block_data(client, 8 + off, count, buf);
> +       result = ds1307->write_block_data(client, ds1307->nvram_offset + off,
> +                                                               count, buf);
>        if (result < 0) {
>                dev_err(&client->dev, "%s error %d\n", "nvram write", result);
>                return result;
> @@ -605,7 +618,6 @@ static struct bin_attribute nvram = {
>
>        .read   = ds1307_nvram_read,
>        .write  = ds1307_nvram_write,
> -       .size   = NVRAM_SIZE,
>  };
>
>  /*----------------------------------------------------------------------*/
> @@ -638,7 +650,19 @@ static int __devinit ds1307_probe(struct
>
>        ds1307->client  = client;
>        ds1307->type    = id->driver_data;
> -       ds1307->offset  = 0;
> +
> +       if (chip && chip->offset)
> +               ds1307->offset = chip->offset;
> +       else
> +               ds1307->offset = 0;
> +       if (chip && chip->nvram_size)
> +               ds1307->nvram_size = chip->nvram_size;
> +       else
> +               ds1307->nvram_size = 0;
> +       if (chip && chip->nvram_offset)
> +               ds1307->nvram_offset = chip->nvram_offset;
> +       else
> +               ds1307->nvram_offset = 0;
>
>        buf = ds1307->regs;
>        if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
> @@ -756,9 +780,6 @@ static int __devinit ds1307_probe(struct
>                                                  hour);
>                }
>                break;
> -       case ds_1388:
> -               ds1307->offset = 1; /* Seconds starts at 1 */
> -               break;
>        default:
>                break;
>        }
> @@ -893,11 +914,12 @@ read_rtc:
>                dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
>        }
>
> -       if (chip && chip->nvram56) {
> +       if (chip && chip->nvram_size) {
> +               nvram.size = ds1307->nvram_size;
>                err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
>                if (err == 0) {
>                        set_bit(HAS_NVRAM, &ds1307->flags);
> -                       dev_info(&client->dev, "56 bytes nvram\n");
> +                       dev_info(&client->dev, "%zd bytes nvram\n", nvram.size);
>                }
>        }
>
>
>
>

Dave
