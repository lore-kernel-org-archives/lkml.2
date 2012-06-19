Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2FSSrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:47:35 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:3148 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2FSSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:47:33 -0400
Date: Tue, 19 Jun 2012 20:47:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Subject: Re: [PATCH 2/3 v2] i2c: i801: enable irq for i801 smbus
 transactions
Message-ID: <20120619204704.69454016@endymion.delvare>
In-Reply-To: <1325847502-17841-3-git-send-email-djkurtz@chromium.org>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
	<1325847502-17841-3-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri,  6 Jan 2012 18:58:21 +0800, Daniel Kurtz wrote:
> Add a new 'feature' to i2c-i801 to enable using i801 interrupts.
> When the feature is enabled, then an isr is installed for the device's
> pci irq.
> 
> An i2c/smbus transaction is always terminated by one of the following
> interrupt sources: FAILED, BUS_ERR, DEV_ERR, or on success: INTR

Missing trailing dot.

> When the isr fires for one of these cases, it sets the ->status variable
> and wakes up the waitq.  The waitq then saves off the status code, and
> clears ->status (in preperation for some future transaction).

Typo: preparation.

> The SMBus controller generates an INTR irq at the end of each
> transaction where INTREN was set in the HST_CNT register.
> 
> No locking is needed around accesses to priv->status since all writes to
> it are serialized: it is only ever set once in the isr at the end of a
> transaction, and cleared while no irqs can occur.  In addition, the i2c
> adapter lock guarantees that entire i2c transactions for a single
> adapter are always serialized.

If no locking is needed, then why do you introduce and initialize a
spinlock?

> For this patch, the INTREN bit is set only for smbus block, byte and word
> transactions, but not for emulated i2c reads or writes.  The use of the

I don't understand the "emulated" in this sentence.

> DS (BYTE_DONE) interrupt with byte-by-byte i2c transactions is
> implemented in a subsequent patch.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/i2c/busses/i2c-i801.c |  107 ++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 100 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index f3418cf..b123133 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -59,10 +59,12 @@
>    Block process call transaction   no
>    I2C block read transaction       yes  (doesn't use the block buffer)
>    Slave mode                       no
> +  Interrupt processing             yes
>  
>    See the file Documentation/i2c/busses/i2c-i801 for details.
>  */
>  
> +#include <linux/interrupt.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
>  #include <linux/kernel.h>
> @@ -90,6 +92,7 @@
>  
>  /* PCI Address Constants */
>  #define SMBBAR		4
> +#define SMBPCISTS	0x006
>  #define SMBHSTCFG	0x040
>  
>  /* Host configuration bits for SMBHSTCFG */
> @@ -97,6 +100,9 @@
>  #define SMBHSTCFG_SMB_SMI_EN	2
>  #define SMBHSTCFG_I2C_EN	4
>  
> +/* Host status bits for SMBHSTSTS */

I guess you meant "PCI status bits for SMBPCISTS"?

> +#define SMBPCISTS_INTS		8

I'd prefer this to be expressed as an hexadecimal mask.

> +
>  /* Auxiliary control register bits, ICH4+ only */
>  #define SMBAUXCTL_CRC		1
>  #define SMBAUXCTL_E32B		2
> @@ -106,7 +112,6 @@
>  
>  /* Other settings */
>  #define MAX_TIMEOUT		100
> -#define ENABLE_INT9		0	/* set to 0x01 to enable - untested */
>  
>  /* I801 command constants */
>  #define I801_QUICK		0x00
> @@ -116,7 +121,11 @@
>  #define I801_PROC_CALL		0x10	/* unimplemented */
>  #define I801_BLOCK_DATA		0x14
>  #define I801_I2C_BLOCK_DATA	0x18	/* ICH5 and later */
> -#define I801_LAST_BYTE		0x20
> +
> +/* I801 Hosts Control register bits */
> +#define I801_INTREN		0x01
> +#define I801_KILL		0x02

This is redundant with SMBHSTCNT_KILL, right?

> +#define I801_LAST_BYTE		0x20	/* ICH5 and later */

Not true, this bit exists prior to ICH5.

>  #define I801_START		0x40
>  #define I801_PEC_EN		0x80	/* ICH3 and later */
>  
> @@ -134,6 +143,9 @@
>  				 SMBHSTSTS_BUS_ERR | SMBHSTSTS_DEV_ERR | \
>  				 SMBHSTSTS_INTR)
>  
> +#define STATUS_RESULT_FLAGS	(SMBHSTSTS_FAILED | SMBHSTSTS_BUS_ERR | \
> +				 SMBHSTSTS_DEV_ERR | SMBHSTSTS_INTR)
> +

You could swap the definitions so you can define STATUS_FLAGS in terms
of STATUS_RESULT_FLAGS.

>  /* Older devices have their ID defined in <linux/pci_ids.h> */
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS	0x1c22
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
> @@ -151,6 +163,11 @@ struct i801_priv {
>  	unsigned char original_hstcfg;
>  	struct pci_dev *pci_dev;
>  	unsigned int features;
> +
> +	/* isr processing */
> +	wait_queue_head_t waitq;

This needs <linux/wait.h>.

> +	spinlock_t lock;

This needs <linux/spinlock.h> (if you need this at all...)

> +	u8 status;
>  };
>  
>  static struct pci_driver i801_driver;
> @@ -159,6 +176,7 @@ static struct pci_driver i801_driver;
>  #define FEATURE_BLOCK_BUFFER	(1 << 1)
>  #define FEATURE_BLOCK_PROC	(1 << 2)
>  #define FEATURE_I2C_BLOCK_READ	(1 << 3)
> +#define FEATURE_IRQ		(1 << 4)
>  /* Not really a feature, but it's convenient to handle it as such */
>  #define FEATURE_IDF		(1 << 15)
>  
> @@ -167,6 +185,7 @@ static const char *i801_feature_names[] = {
>  	"Block buffer",
>  	"Block process call",
>  	"I2C block read",
> +	"Interrupt"

Trailing comma please.

>  };
>  
>  static unsigned int disable_features;
> @@ -207,7 +226,12 @@ static int i801_check_post(struct i801_priv *priv, int status, int timeout)
>  {
>  	int result = 0;
>  
> -	/* If the SMBus is still busy, we give up */
> +	/*
> +	 * If the SMBus is still busy, we give up
> +	 * Note: This timeout condition only happens when using polling
> +	 * transactions.  For interrupt operation, NAK/timeout is indicated by
> +	 * DEV_ERR.
> +	 */
>  	if (timeout) {
>  		dev_err(&priv->pci_dev->dev, "Transaction timeout\n");
>  		/* try to stop the current command */
> @@ -265,8 +289,15 @@ static int i801_transaction(struct i801_priv *priv, int xact)
>  	if (result < 0)
>  		return result;
>  
> +	if (priv->features & FEATURE_IRQ) {
> +		outb(xact | I801_INTREN | I801_START, SMBHSTCNT(priv));
> +		wait_event(priv->waitq, (status = priv->status));
> +		priv->status = 0;
> +		return i801_check_post(priv, status, 0);
> +	}
> +
>  	/* the current contents of SMBHSTCNT can be overwritten, since PEC,
> -	 * INTREN, SMBSCMD are passed in xact */
> +	 * SMBSCMD are passed in xact */
>  	outb_p(xact | I801_START, SMBHSTCNT(priv));
>  
>  	/* We will always wait for a fraction of a second! */
> @@ -280,6 +311,7 @@ static int i801_transaction(struct i801_priv *priv, int xact)
>  		return result;
>  
>  	outb_p(SMBHSTSTS_INTR, SMBHSTSTS(priv));
> +
>  	return 0;

Please avoid mixing whitespace changes with real changes.

>  }
>  
> @@ -318,7 +350,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
>  			outb_p(data->block[i+1], SMBBLKDAT(priv));
>  	}
>  
> -	status = i801_transaction(priv, I801_BLOCK_DATA | ENABLE_INT9 |
> +	status = i801_transaction(priv, I801_BLOCK_DATA |

Dropping ENABLE_INT9 would have made a nice preliminary cleanup patch...

>  				  (hwpec ? I801_PEC_EN : 0));
>  	if (status)
>  		return status;
> @@ -336,6 +368,44 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
>  }
>  
>  /*
> + * i801 signals transaction completion with one of these interrupts:
> + *   INTR - Success
> + *   DEV_ERR - Invalid command, NAK or communication timeout
> + *   BUS_ERR - SMI# transaction collision
> + *   FAILED - transaction was canceled due to a KILL request
> + * When any of these occur, update ->status and wake up the waitq.
> + * ->status must be cleared before kicking off the next transaction.
> + */
> +static irqreturn_t i801_isr(int irq, void *dev_id)
> +{
> +	struct i801_priv *priv = dev_id;
> +	u8 pcists, hststs;
> +
> +	/* Confirm this is our interrupt */
> +	pci_read_config_byte(priv->pci_dev, SMBPCISTS, &pcists);

According to the datasheet this is a 16-bit register, you should read
it with pci_read_config_word().

> +	if (!(pcists & SMBPCISTS_INTS)) {
> +		dev_dbg(&priv->pci_dev->dev, "irq: pcists.ints not set\n");

This is expected in case of shared interrupts, right?

> +		return IRQ_NONE;
> +	}
> +
> +	hststs = inb(SMBHSTSTS(priv));

BTW, the rest of the driver is using inb_p/outb_p instead of inb/outb.
Do you believe it would be safe to use inb/outb everywhere else?

> +	dev_dbg(&priv->pci_dev->dev, "irq: hststs = %02x\n", hststs);
> +
> +	/*
> +	 * Clear irq sources and report transaction result.
> +	 * ->status must be cleared before the next transaction is started.
> +	 */
> +	hststs &= STATUS_RESULT_FLAGS;
> +	if (hststs) {

If not, something's seriously wrong, isn't it?

> +		outb(hststs, SMBHSTSTS(priv));
> +		priv->status |= hststs;
> +		wake_up(&priv->waitq);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
>   * i2c write uses cmd=I801_BLOCK_DATA, I2C_EN=1
>   * i2c read uses cmd=I801_I2C_BLOCK_DATA
>   */
> @@ -370,7 +440,7 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
>  	for (i = 1; i <= len; i++) {
>  		if (i == len && read_write == I2C_SMBUS_READ)
>  			smbcmd |= I801_LAST_BYTE;
> -		outb_p(smbcmd | ENABLE_INT9, SMBHSTCNT(priv));
> +		outb_p(smbcmd, SMBHSTCNT(priv));
>  
>  		if (i == 1)
>  			outb_p(inb(SMBHSTCNT(priv)) | I801_START,
> @@ -571,7 +641,7 @@ static s32 i801_access(struct i2c_adapter *adap, u16 addr,
>  		ret = i801_block_transaction(priv, data, read_write, size,
>  					     hwpec);
>  	else
> -		ret = i801_transaction(priv, xact | ENABLE_INT9);
> +		ret = i801_transaction(priv, xact);
>  
>  	/* Some BIOSes don't like it when PEC is enabled at reboot or resume
>  	   time, so we forcibly disable it after every transaction. Turn off
> @@ -805,6 +875,10 @@ static int __devinit i801_probe(struct pci_dev *dev,
>  		break;
>  	}
>  
> +	/* IRQ processing only tested on CougarPoint PCH */

I'll test on other chips, I have ICH3-M, ICH5, ICH7 and ICH10 here. The
INTS bit in PCI Status Register is new in ICH5 so your code will not
work on older chips. I think interrupts were supported before that, but
probably not shared interrupts?

OTOH I'm not completely sure why you check this bit in the first
place... hststs == 0 should be enough to detect the not-for-us shared
interrupt case?

> +	if (dev->device == PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS)
> +		priv->features |= FEATURE_IRQ;
> +
>  	/* Disable features on user request */
>  	for (i = 0; i < ARRAY_SIZE(i801_feature_names); i++) {
>  		if (priv->features & disable_features & (1 << i))
> @@ -879,8 +953,24 @@ static int __devinit i801_probe(struct pci_dev *dev,
>  	i801_probe_optional_slaves(priv);
>  
>  	pci_set_drvdata(dev, priv);
> +
> +	if (priv->features & FEATURE_IRQ) {
> +		init_waitqueue_head(&priv->waitq);
> +		spin_lock_init(&priv->lock);
> +
> +		err = request_irq(dev->irq, i801_isr, IRQF_SHARED,
> +				  i801_driver.name, priv);
> +		if (err) {
> +			dev_err(&dev->dev, "Failed to allocate irq %d: %d",

Missing "\n".

> +				dev->irq, err);
> +			goto exit_del_adapter;
> +		}

I believe order is wrong, and interrupt handler should be installed
_before_ registering the adapter. Otherwise you have a race condition
where the handler could be called before the waitqueue and spinlock are
initialized.

> +	}
>  	return 0;
>  
> +exit_del_adapter:
> +	pci_set_drvdata(dev, NULL);
> +	i2c_del_adapter(&priv->adapter);
>  exit_release:
>  	pci_release_region(dev, SMBBAR);
>  exit:
> @@ -892,6 +982,9 @@ static void __devexit i801_remove(struct pci_dev *dev)
>  {
>  	struct i801_priv *priv = pci_get_drvdata(dev);
>  
> +	if (priv->features & FEATURE_IRQ)
> +		free_irq(dev->irq, priv);
> +
>  	i2c_del_adapter(&priv->adapter);

Here again I think order is wrong and you should delete the adapter
first, otherwise there is a small chance that you free the irq while an
SMBus transaction is being processed.

>  	pci_write_config_byte(dev, SMBHSTCFG, priv->original_hstcfg);
>  	pci_release_region(dev, SMBBAR);


-- 
Jean Delvare
