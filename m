Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044Ab0HFJGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 05:06:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12074 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759360Ab0HFJGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 05:06:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6065"; a="49966180"
Message-ID: <4C5BD096.4010001@codeaurora.org>
Date: Fri, 06 Aug 2010 14:36:30 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kevin McNeely <kev@cypress.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Todd Fischer <todd.fischer@ridgerun.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init submit
References: <Kevin McNeely <kev@cypress.com> <1281031924-3032-1-git-send-email-kev@cypress.com>
In-Reply-To: <1281031924-3032-1-git-send-email-kev@cypress.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

Review for SPI code.

> diff --git a/drivers/input/touchscreen/cyttsp_spi.c b/drivers/input/touchscreen/cyttsp_spi.c
> new file mode 100755


> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/spi/spi.h>
> +#include <linux/delay.h>
> +#include <linux/cyttsp.h>
> +#include "cyttsp_core.h"
> +
> +#define DBG(x)
> +
> +#define CY_SPI_WR_OP      0x00 /* r/~w */
> +#define CY_SPI_RD_OP      0x01
> +#define CY_SPI_CMD_BYTES  4
> +#define CY_SPI_SYNC_BYTES 2
> +#define CY_SPI_SYNC_ACK1  0x62 /* from protocol v.2 */
> +#define CY_SPI_SYNC_ACK2  0x9D /* from protocol v.2 */
> +#define CY_SPI_SYNC_NACK  0x69
> +#define CY_SPI_DATA_SIZE  64
> +#define CY_SPI_DATA_BUF_SIZE (CY_SPI_CMD_BYTES + CY_SPI_DATA_SIZE)
> +#define CY_SPI_BITS_PER_WORD 8
> +
> +struct cyttsp_spi {
> +	struct cyttsp_bus_ops ops;
> +	struct spi_device *spi_client;
> +	void *ttsp_client;
> +	u8 wr_buf[CY_SPI_DATA_BUF_SIZE];
> +	u8 rd_buf[CY_SPI_DATA_BUF_SIZE];
> +};
> +
> +static void spi_complete(void *arg)
> +{
> +	complete(arg);

We don't need anything here on completion?

> +}
> +
> +static int spi_sync_tmo(struct spi_device *spi, struct spi_message *message)
> +{
> +	DECLARE_COMPLETION_ONSTACK(done);
> +	int status;
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)

No need.

> +
> +	message->complete = spi_complete;
> +	message->context = &done;
> +	status = spi_async(spi, message);
> +	if (status == 0) {
> +		int ret = wait_for_completion_interruptible_timeout(&done, HZ);
> +		if (!ret) {
> +			printk(KERN_ERR "%s: timeout\n", __func__);
> +			status = -EIO;
> +		} else
> +			status = message->status;
> +	}
> +	message->context = NULL;
> +	return status;
> +}
> +
> +static int cyttsp_spi_xfer_(u8 op, struct cyttsp_spi *ts_spi,
> +			    u8 reg, u8 *buf, int length)
> +{
> +	struct spi_message msg;
> +	struct spi_transfer xfer = { 0 };
> +	u8 *wr_buf = ts_spi->wr_buf;
> +	u8 *rd_buf = ts_spi->rd_buf;
> +	int retval;
> +	int i;
> +	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)

No need.

> +
> +	if (length > CY_SPI_DATA_SIZE) {
> +		printk(KERN_ERR "%s: length %d is too big.\n",
> +			__func__, length);
> +		return -EINVAL;
> +	}
> +	DBG(printk(KERN_INFO "%s: OP=%s length=%d\n", __func__,
> +		   op == CY_SPI_RD_OP ? "Read" : "Write", length);)

dev_dbg if really needed.

> +
> +	wr_buf[0] = 0x00; /* header byte 0 */
> +	wr_buf[1] = 0xFF; /* header byte 1 */
> +	wr_buf[2] = reg;  /* reg index */
> +	wr_buf[3] = op;   /* r/~w */
> +	if (op == CY_SPI_WR_OP)
> +		memcpy(wr_buf + CY_SPI_CMD_BYTES, buf, length);
> +	DBG(
> +	if (op == CY_SPI_RD_OP)
> +		memset(rd_buf, CY_SPI_SYNC_NACK, CY_SPI_DATA_BUF_SIZE);)
> +	DBG(
> +	for (i = 0; i < (length + CY_SPI_CMD_BYTES); i++) {
> +		if ((op == CY_SPI_RD_OP) && (i < CY_SPI_CMD_BYTES))
> +			printk(KERN_INFO "%s: wr[%d]:0x%02x\n",
> +				__func__, i, wr_buf[i]);
> +		if (op == CY_SPI_WR_OP)
> +			printk(KERN_INFO "%s: wr[%d]:0x%02x\n",
> +				__func__, i, wr_buf[i]);
> +	})

Let remove such things.

> +
> +	xfer.tx_buf = wr_buf;
> +	xfer.rx_buf = rd_buf;
> +	xfer.len = length + CY_SPI_CMD_BYTES;
> +
> +	if ((op == CY_SPI_RD_OP) && (xfer.len < 32))
> +		xfer.len += 1;
> +
> +	spi_message_init(&msg);
> +	spi_message_add_tail(&xfer, &msg);
> +	retval = spi_sync_tmo(ts_spi->spi_client, &msg);
> +	if (retval < 0) {
> +		printk(KERN_ERR "%s: spi_sync_tmo() error %d\n",
> +			__func__, retval);
> +		retval = 0;
> +	}
> +	if (op == CY_SPI_RD_OP) {
> +		DBG(
> +		for (i = 0; i < (length + CY_SPI_CMD_BYTES); i++)
> +			printk(KERN_INFO "%s: rd[%d]:0x%02x\n",
> +				__func__, i, rd_buf[i]);)
> +
> +		for (i = 0; i < (length + CY_SPI_CMD_BYTES - 1); i++) {
> +			if ((rd_buf[i] != CY_SPI_SYNC_ACK1) ||
> +				(rd_buf[i + 1] != CY_SPI_SYNC_ACK2)) {
> +				continue;
> +			}
> +			if (i <= (CY_SPI_CMD_BYTES - 1)) {
> +				memcpy(buf, (rd_buf + i + CY_SPI_SYNC_BYTES),
> +					length);
> +				return 0;
> +			}
> +		}
> +		DBG(printk(KERN_INFO "%s: byte sync error\n", __func__);)

dev_err if you really need to print for debugging purpose or pr_err(...)

> +		retval = 1;
> +	}
> +	return retval;
> +}
> +
> +static int cyttsp_spi_xfer(u8 op, struct cyttsp_spi *ts,
> +			    u8 reg, u8 *buf, int length)
> +{
> +	int tries;
> +	int retval;
> +	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)

No need.

> +
> +	if (op == CY_SPI_RD_OP) {
> +		for (tries = CY_NUM_RETRY; tries; tries--) {
> +			retval = cyttsp_spi_xfer_(op, ts, reg, buf, length);
> +			if (retval == 0)
> +				break;
> +			else
> +				msleep(10);
> +		}
> +	} else {
> +		retval = cyttsp_spi_xfer_(op, ts, reg, buf, length);
> +	}
> +	return retval;
> +}
> +
> +static s32 ttsp_spi_read_block_data(void *handle, u8 addr,
> +				    u8 length, void *data)
> +{
> +	int retval;
> +	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
> +
> +	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)

No need.

> +
> +	retval = cyttsp_spi_xfer(CY_SPI_RD_OP, ts, addr, data, length);
> +	if (retval < 0)
> +		printk(KERN_ERR "%s: ttsp_spi_read_block_data failed\n",
> +			__func__);

dev_err(...)

> +
> +	/* Do not print the above error if the data sync bytes were not found.
> +	   This is a normal condition for the bootloader loader startup and need
> +	   to retry until data sync bytes are found. */

Use kernel style for multi-line comments.


/* 
 * You should use this format
 * for multi-line commenting
 */



> +	if (retval > 0)
> +		retval = -1;	/* now signal fail; so retry can be done */
> +
> +	return retval;
> +}
> +
> +static s32 ttsp_spi_write_block_data(void *handle, u8 addr,
> +				     u8 length, const void *data)
> +{
> +	int retval;
> +	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
> +
> +	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)

No need.

> +
> +	retval = cyttsp_spi_xfer(CY_SPI_WR_OP, ts, addr, (void *)data, length);
> +	if (retval < 0)
> +		printk(KERN_ERR "%s: ttsp_spi_write_block_data failed\n",
> +			__func__);
> +
> +	if (retval == -EIO)
> +		return 0;
> +	else
> +		return retval;
> +}
> +
> +static s32 ttsp_spi_tch_ext(void *handle, void *values)
> +{
> +	int retval = 0;
> +	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
> +
> +	DBG(printk(KERN_INFO "%s: Enter\n", __func__);)

No need.

> +
> +	/* Add custom touch extension handling code here */

You may want to add this as "TODO".

> +	/* set: retval < 0 for any returned system errors,
> +		retval = 0 if normal touch handling is required,
> +		retval > 0 if normal touch handling is *not* required */
> +	if (!ts || !values)
> +		retval = -EIO;
> +
> +	return retval;
> +}
> +
> +static int __devinit cyttsp_spi_probe(struct spi_device *spi)
> +{
> +	struct cyttsp_spi *ts_spi;
> +	int retval;
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)

Un-necessary printk.

> +
> +	/* Set up SPI*/
> +	spi->bits_per_word = CY_SPI_BITS_PER_WORD;
> +	spi->mode = SPI_MODE_0;
> +	retval = spi_setup(spi);
> +	if (retval < 0) {
> +		printk(KERN_ERR "%s: SPI setup error %d\n", __func__, retval);

dev_err(...)

> +		return retval;
> +	}
> +	ts_spi = kzalloc(sizeof(*ts_spi), GFP_KERNEL);
> +	if (ts_spi == NULL) {
> +		printk(KERN_ERR "%s: Error, kzalloc\n", __func__);

dev_err(...)

> +		retval = -ENOMEM;
> +		goto error_alloc_data_failed;
> +	}
> +	ts_spi->spi_client = spi;
> +	dev_set_drvdata(&spi->dev, ts_spi);
> +	ts_spi->ops.write = ttsp_spi_write_block_data;
> +	ts_spi->ops.read = ttsp_spi_read_block_data;
> +	ts_spi->ops.ext = ttsp_spi_tch_ext;
> +
> +	ts_spi->ttsp_client = cyttsp_core_init(&ts_spi->ops, &spi->dev);
> +	if (!ts_spi->ttsp_client)
> +		goto ttsp_core_err;
> +	printk(KERN_INFO "%s: Successful registration %s\n",
> +	       __func__, CY_SPI_NAME);


> +
> +	return 0;
> +
> +ttsp_core_err:
> +	kfree(ts_spi);
> +error_alloc_data_failed:
> +	return retval;
> +}
> +
> +/* registered in driver struct */

No need.

> +static int __devexit cyttsp_spi_remove(struct spi_device *spi)
> +{
> +	struct cyttsp_spi *ts_spi = dev_get_drvdata(&spi->dev);
> +	DBG(printk(KERN_INFO"%s: Enter\n", __func__);)

Remove this printk.

> +	cyttsp_core_release(ts_spi->ttsp_client);
> +	kfree(ts_spi);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int cyttsp_spi_suspend(struct spi_device *spi, pm_message_t message)
> +{
> +	return cyttsp_suspend(dev_get_drvdata(&spi->dev));
> +}
> +
> +static int cyttsp_spi_resume(struct spi_device *spi)
> +{
> +	return cyttsp_resume(dev_get_drvdata(&spi->dev));
> +}
> +#endif
> +
> +static struct spi_driver cyttsp_spi_driver = {
> +	.driver = {
> +		.name = CY_SPI_NAME,
> +		.bus = &spi_bus_type,
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = cyttsp_spi_probe,
> +	.remove = __devexit_p(cyttsp_spi_remove),
> +#ifdef CONFIG_PM
> +	.suspend = cyttsp_spi_suspend,
> +	.resume = cyttsp_spi_resume,
> +#endif
> +};
> +
> +static int __init cyttsp_spi_init(void)
> +{
> +	int err;
> +
> +	err = spi_register_driver(&cyttsp_spi_driver);
> +	printk(KERN_INFO "%s: Cypress TrueTouch(R) Standard Product SPI "
> +		"Touchscreen Driver (Built %s @ %s) returned %d\n",
> +		 __func__, __DATE__, __TIME__, err);

As Dmitry mentioned on another e-mail, remove such printks. They create un-necessary noise.

> +
> +	return err;
> +}
> +module_init(cyttsp_spi_init);
> +
> +static void __exit cyttsp_spi_exit(void)
> +{
> +	spi_unregister_driver(&cyttsp_spi_driver);
> +	printk(KERN_INFO "%s: module exit\n", __func__);

Ditto.

> +}
> +module_exit(cyttsp_spi_exit);
> +
> +MODULE_ALIAS("spi:cyttsp");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) SPI driver");
> +MODULE_AUTHOR("Cypress");
> +
> diff --git a/include/linux/cyttsp.h b/include/linux/cyttsp.h
> new file mode 100755
> index 0000000..b2a289b
> --- /dev/null
> +++ b/include/linux/cyttsp.h

You may want to move this to include/linux/input/cyttsp.h

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
