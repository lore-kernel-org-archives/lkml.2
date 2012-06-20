Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2FTNfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:35:19 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:9777 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2FTNfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:35:18 -0400
Date: Wed, 20 Jun 2012 15:34:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Subject: Re: [PATCH 3/3 v2] i2c: i801: enable irq for byte_by_byte
 transactions
Message-ID: <20120620153449.5cee35fa@endymion.delvare>
In-Reply-To: <1325847502-17841-4-git-send-email-djkurtz@chromium.org>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
 <1325847502-17841-4-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri,  6 Jan 2012 18:58:22 +0800, Daniel Kurtz wrote:
> Byte-by-byte transactions are used primarily for accessing i2c devices
> with an smbus controller.  For these transactions, for each byte that is

On recent chips, yes. On older chips (ICH3 and older), the block buffer
didn't exist, so even SMBus block transactions went for byte-by-byte.
Not that it matters much at the moment, as your interrupt support
doesn't yet cover these old chips anyway.

BTW, please use proper capitalization in comments: I2C and SMBus.

(As a side note, it might be worth checking if block buffer can now be
used with I2C block transactions too. The comment that says it doesn't
is getting old, maybe there was a bug somewhere in the code back then,
or that may have been a hardware issue possibly fixed in recent chips.)

> read or written, the SMBus controller generates a BYTE_DONE irq.  The isr
> reads/writes the next byte, and clears the irq flag to start the next byte.
> On the penultimate irq, the isr also sets the LAST_BYTE flag.
> 
> There is no locking around the cmd/len/count/data variables, since the
> i2c adapter lock ensures there is never multiple simultaneous transactions
> for the same device, and the driver thread never accesses these variables
> while interrupts might be occurring.
> 
> The end result is a dramatic speed up in emulated i2c-over smbus block
> read and write transactions.

Here again the term "emulated" makes little sense IMHO. I2C block reads
and writes are just one of the transaction types commonly supported by
SMBus controllers.

I agree that the performance gain is great. Maybe no longer dramatic
compared to the usleep_delay() version, but certainly compared to the
msleep() version, especially if HZ < 1000. In my case I see a 2.5x
improvement which is still very good.

> Note: This patch has only been tested and verified by doing i2c read and
> write block transfers on Cougar Point 6 Series PCH.

I'll get at least the I2C block read tested on ICH5.

> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |   51 ++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 50 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index b123133..f957eca 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -168,6 +168,13 @@ struct i801_priv {
>  	wait_queue_head_t waitq;
>  	spinlock_t lock;
>  	u8 status;
> +
> +	/* Command state used during by isr */

Might be worth mentioning that it's only needed for byte-by-byte block
transactions.

> +	u8 cmd;
> +	bool is_read;
> +	int count;
> +	int len;
> +	u8 *data;
>  };
>  
>  static struct pci_driver i801_driver;
> @@ -368,18 +375,24 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
>  }
>  
>  /*
> - * i801 signals transaction completion with one of these interrupts:
> + * There are two kinds of interrupts:
> + *
> + * (1) i801 signals transaction completion with one of these interrupts:
>   *   INTR - Success
>   *   DEV_ERR - Invalid command, NAK or communication timeout
>   *   BUS_ERR - SMI# transaction collision
>   *   FAILED - transaction was canceled due to a KILL request
>   * When any of these occur, update ->status and wake up the waitq.
>   * ->status must be cleared before kicking off the next transaction.
> + *
> +* (2) For byte-by-byte (I2C read/write) transactions, one BYTE_DONE interrupt
> +*     occurs for each byte of a byte-by-byte to prepare the next byte.

These stars aren't properly aligned.

>   */
>  static irqreturn_t i801_isr(int irq, void *dev_id)
>  {
>  	struct i801_priv *priv = dev_id;
>  	u8 pcists, hststs;
> +	u8 cmd;
>  
>  	/* Confirm this is our interrupt */
>  	pci_read_config_byte(priv->pci_dev, SMBPCISTS, &pcists);
> @@ -391,6 +404,27 @@ static irqreturn_t i801_isr(int irq, void *dev_id)
>  	hststs = inb(SMBHSTSTS(priv));
>  	dev_dbg(&priv->pci_dev->dev, "irq: hststs = %02x\n", hststs);
>  
> +	if (hststs & SMBHSTSTS_BYTE_DONE) {
> +		if (priv->is_read) {
> +			priv->data[priv->count++] = inb(SMBBLKDAT(priv));
> +
> +			/* Set LAST_BYTE for last byte of read transaction */
> +			cmd = priv->cmd;
> +			if (priv->count == priv->len - 1)
> +				cmd |= I801_LAST_BYTE;
> +			outb_p(cmd | I801_START, SMBHSTCNT(priv));

I don't think you need the local variable "cmd". The only change is
I801_LAST_BYTE and it's only ever added, so I believe you could do:

			/* Set LAST_BYTE for last byte of read transaction */
			if (priv->count == priv->len - 1)
				priv->cmd |= I801_LAST_BYTE;
			outb_p(priv->cmd, SMBHSTCNT(priv));

as is done in the polling code. If you were worried about writing to
priv, I don't think it is an issue. If you felt safe reading from it
without a lock, writing to it is just as safe.

> +		} else if (priv->count < priv->len - 1) {

Is this just paranoia or do you believe it could actually happen? I
admit I don't see how. If it is paranoia then the same should be done
for the read part.

> +			outb(priv->data[++priv->count], SMBBLKDAT(priv));
> +			outb_p(priv->cmd | I801_START, SMBHSTCNT(priv));

I don't get the I801_START here and above. We are in the middle of the block
transaction. The polling-based code only sets I801_START at the
beginning, not for every byte, so why would it be different here?

> +		}
> +
> +		/* Clear BYTE_DONE to start next transaction. */
> +		outb(SMBHSTSTS_BYTE_DONE, SMBHSTSTS(priv));
> +
> +		/* Clear BYTE_DONE so it does not wake_up waitq */
> +		hststs &= ~SMBHSTSTS_BYTE_DONE;

SMBHSTSTS_BYTE_DONE isn't part of STATUS_RESULT_FLAGS anyway, so it
will be removed from hststs right after.

> +	}
> +
>  	/*
>  	 * Clear irq sources and report transaction result.
>  	 * ->status must be cleared before the next transaction is started.
> @@ -437,6 +471,21 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
>  	else
>  		smbcmd = I801_BLOCK_DATA;
>  
> +	if (priv->features & FEATURE_IRQ) {
> +		priv->is_read = (read_write == I2C_SMBUS_READ);
> +		if (len == 1 && priv->is_read)
> +			smbcmd |= I801_LAST_BYTE;
> +		priv->cmd = smbcmd | I801_INTREN;
> +		priv->len = len;
> +		priv->count = 0;
> +		priv->data = &data->block[1];
> +
> +		outb(priv->cmd | I801_START, SMBHSTCNT(priv));
> +		wait_event(priv->waitq, (status = priv->status));
> +		priv->status = 0;
> +		return i801_check_post(priv, status, 0);
> +	}
> +
>  	for (i = 1; i <= len; i++) {
>  		if (i == len && read_write == I2C_SMBUS_READ)
>  			smbcmd |= I801_LAST_BYTE;


-- 
Jean Delvare
