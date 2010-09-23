Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0IWXkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:40:06 -0400
Received: from tundra.namei.org ([65.99.196.166]:45196 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab0IWXj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:39:29 -0400
Date: Fri, 24 Sep 2010 09:38:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Christophe Henri RICARD <christophe-h.ricard@st.com>
cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] drivers/char/tpm/tpm_stm_st19_i2c.c: Add missing
 break and neatening
In-Reply-To: <0B9F1C5B86169C4EA9D042C251022E49105CE1C3A4@SAFEX1MAIL3.st.com>
Message-ID: <alpine.LRH.2.00.1009240937280.4317@tundra.namei.org>
References: <0B9F1C5B86169C4EA9D042C251022E49105CD81DE1@SAFEX1MAIL3.st.com>  <cover.1283556028.git.joe@perches.com>  <9637426b310cdf113712a7a1dfd22843839dfc08.1283556028.git.joe@perches.com> <1284484264.17585.5.camel@blackbox>
 <0B9F1C5B86169C4EA9D042C251022E49105CE1C3A4@SAFEX1MAIL3.st.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which patches need to be applied to the tree?

Rajiv: can you please send them to me as plain text inline, against my 
-next tree, with your signoffs?


On Fri, 17 Sep 2010, Christophe Henri RICARD wrote:

> Rajiv,
> Please find in attached file a full patch (driver + Joe Perches observations/patches + comments update).
> This patch has been tested.
> 
> Thanks
> Christophe
> 
> -----Original Message-----
> From: Rajiv Andrade [mailto:srajiv@linux.vnet.ibm.com] 
> Sent: Tuesday, September 14, 2010 12:11 PM
> To: Joe Perches
> Cc: Christophe Henri RICARD; Marcel Selhorst; Debora Velarde; James Morris; tpmdd-devel@lists.sourceforge.net; LKML
> Subject: Re: [PATCH 2/2] drivers/char/tpm/tpm_stm_st19_i2c.c: Add missing break and neatening
> 
> Chris, did you have the chance to test it against this specific TPM?
> Despite this, the patch looks pretty good, thanks Joe.
> 
> Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> 
> On Fri, 2010-09-03 at 16:29 -0700, Joe Perches wrote:
> > Add missing break in wait_until_good_shape
> > Use init; while (test) loops not for(init;test;)
> > Calculate bytes to transfer using if and min_t not multiple ?:
> > Miscellaneous function whitespace aliging
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/char/tpm/tpm_stm_st19_i2c.c |  158 +++++++++++++++++++----------------
> >  1 files changed, 85 insertions(+), 73 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_stm_st19_i2c.c b/drivers/char/tpm/tpm_stm_st19_i2c.c
> > index cdf2eb3..4b1ed05 100644
> > --- a/drivers/char/tpm/tpm_stm_st19_i2c.c
> > +++ b/drivers/char/tpm/tpm_stm_st19_i2c.c
> > @@ -158,8 +158,10 @@ static int wait_until_good_shape(void)
> >  		else if (!signal_pending(current)) {
> >  			ret = schedule_timeout(time);
> >  			wait_time += time;
> > -		} else
> > +		} else {
> >  			ret = -ERESTARTSYS;
> > +			break;
> > +		}
> >  	} while (1);
> >  	finish_wait(&queue, &__wait);
> > 
> > @@ -204,10 +206,10 @@ static int wait_event_interruptible_on_gpio(wait_queue_head_t queue,
> >  		else if (wait_time >= timeout)
> >  			break;
> >  		else if (!signal_pending(current)) {
> > -			ret =
> > -			    schedule_timeout(msecs_to_jiffies
> > -					     (TICK_GPIO_SPOOLING));
> > -			wait_time += msecs_to_jiffies(TICK_GPIO_SPOOLING);
> > +			int time = msecs_to_jiffies(TICK_GPIO_SPOOLING);
> > +
> > +			ret = schedule_timeout(time);
> > +			wait_time += time;
> >  		} else {
> >  			ret = -ERESTARTSYS;
> >  			break;
> > @@ -286,9 +288,9 @@ static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
> >  	/* sending data (data_avail_pin hight) */
> >  	/* If data are available, we read the data */
> >  	init_waitqueue_head(&pin_infos->write_queue);
> > -	pin = wait_event_interruptible_on_gpio(pin_infos->write_queue,
> > -					       tpm_calc_ordinal_duration
> > -					       (chip, ordinal));
> > +	pin = wait_event_interruptible_on_gpio(
> > +			pin_infos->write_queue,
> > +			tpm_calc_ordinal_duration(chip, ordinal));
> >  	if (pin < 0) {
> >  		ret = pin;
> >  		goto end;
> > @@ -297,25 +299,30 @@ static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
> >  	client->flags = I2C_M_RD;
> > 
> >  	size = TPM_HEADER_SIZE;
> > -	for (i = 0; pin == DATA_ON && i < size;) {
> > -		ret = i2c_master_recv(client,
> > -				      pin_infos->tpm_i2c_buffer[1],
> > -				      (i == 0) ? TPM_HEADER_SIZE :
> > -				      count - i > TPM_I2C_BLOCK_SIZE ?
> > -				      TPM_I2C_BLOCK_SIZE : count - i);
> > +	i = 0;
> > +	while (i < size && pin == DATA_ON) {
> > +		int bytes;
> > +
> > +		if (i == 0)
> > +			bytes = TPM_HEADER_SIZE;
> > +		else
> > +			bytes = min_t(int, count - i, TPM_I2C_BLOCK_SIZE);
> > +
> > +		ret = i2c_master_recv(client, pin_infos->tpm_i2c_buffer[1],
> > +				      bytes);
> >  		if (ret < 0)
> >  			goto end;
> > -		if (i == 0)
> > -			size =
> > -			    responseSize(pin_infos->tpm_i2c_buffer[1], count);
> > -		(i == 0) ? (i += TPM_HEADER_SIZE) : (i += TPM_I2C_BLOCK_SIZE);
> > +		if (i == 0) {
> > +			size = responseSize(pin_infos->tpm_i2c_buffer[1],
> > +					    count);
> > +			i += TPM_HEADER_SIZE;
> > +		} else
> > +			i += TPM_I2C_BLOCK_SIZE;
> > 
> >  		if (i < size)
> > -			pin =
> > -			    wait_event_interruptible_on_gpio(pin_infos->
> > -							     write_queue,
> > -							     msecs_to_jiffies
> > -							     (TPM_I2C_SHORT));
> > +			pin = wait_event_interruptible_on_gpio(
> > +					pin_infos->write_queue,
> > +					msecs_to_jiffies(TPM_I2C_SHORT));
> >  	}
> > 
> >  	pin = wait_event_interruptible_on_gpio(pin_infos->write_queue,
> > @@ -325,36 +332,41 @@ static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
> >  	client->flags = 0;
> > 
> >  	size = TPM_HEADER_SIZE;
> > -	for (i = 0; i < size && pin == COMMAND_ON;) {
> > -		memcpy(pin_infos->tpm_i2c_buffer[0], buf + i,
> > -		       (i == 0) ? TPM_HEADER_SIZE : count - i >
> > -		       TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE : count - i);
> > +	i = 0;
> > +	while (i < size && pin == COMMAND_ON) {
> > +		int bytes;
> > +
> > +		if (i == 0)
> > +			bytes = TPM_HEADER_SIZE;
> > +		else
> > +			bytes = min_t(int, count - i, TPM_I2C_BLOCK_SIZE);
> > +
> > +		memcpy(pin_infos->tpm_i2c_buffer[0], buf + i, bytes);
> > 
> >  		if (i == 0) {
> >  			size = responseSize(buf, count);
> > -			size = (size < count ? size : count);
> > +			size = size < count ? size : count;
> >  		}
> > -		ret =
> > -		    i2c_master_send(client,
> > -				    pin_infos->tpm_i2c_buffer[0],
> > -				    count >= TPM_HEADER_SIZE ? (i ==
> > -								0) ?
> > -				    TPM_HEADER_SIZE : count - i >
> > -				    TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE :
> > -				    count - i : count);
> > +
> > +		if (count < TPM_HEADER_SIZE)
> > +			bytes = count;
> > +
> > +		ret = i2c_master_send(client, pin_infos->tpm_i2c_buffer[0],
> > +				      bytes);
> >  		if (ret < 0) {
> >  			pr_info("Failed to send data\n");
> >  			goto end;
> >  		}
> > 
> > -		(i == 0) ? (i += TPM_HEADER_SIZE) : (i += TPM_I2C_BLOCK_SIZE);
> > +		if (i == 0)
> > +			i += TPM_HEADER_SIZE;
> > +		else
> > +			i += TPM_I2C_BLOCK_SIZE;
> >  		/* Wait for AcceptCmd signal hight */
> >  		if (i < size)
> > -			pin =
> > -			    wait_event_interruptible_on_gpio(pin_infos->
> > -							     write_queue,
> > -							     msecs_to_jiffies
> > -							     (TPM_I2C_SHORT));
> > +			pin = wait_event_interruptible_on_gpio(
> > +					pin_infos->write_queue,
> > +					msecs_to_jiffies(TPM_I2C_SHORT));
> > 
> >  		if (pin != COMMAND_ON) {
> >  			pr_info("Failed to read gpio pin (AcceptCmd)\n");
> > @@ -362,6 +374,7 @@ static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
> >  			goto end;
> >  		}
> >  	}
> > +
> >  	if (i == 0) {
> >  		pr_info("Failed to read gpio pin (AcceptCmd)\n");
> >  		ret = -EIO;
> > @@ -412,49 +425,48 @@ static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
> > 
> >  	/* Spool on the good gpio as long as pin GPIO 3 not HIGHT */
> >  	init_waitqueue_head(&chip->vendor.read_queue);
> > -	pin = wait_event_interruptible_on_gpio(chip->vendor.read_queue,
> > -					       tpm_calc_ordinal_duration
> > -					       (chip, TPM_I2C_ORDINAL_LONG));
> > +	pin = wait_event_interruptible_on_gpio(
> > +			chip->vendor.read_queue,
> > +			tpm_calc_ordinal_duration(chip, TPM_I2C_ORDINAL_LONG));
> > 
> >  	size = TPM_HEADER_SIZE;
> > -	for (i = 0; i < size && pin == DATA_ON;) {
> > -		ret =
> > -		    i2c_master_recv(client,
> > -				    pin_infos->tpm_i2c_buffer[1],
> > -				    (count >= TPM_HEADER_SIZE ? i ==
> > -				     0 ? TPM_HEADER_SIZE : (size - i) >
> > -				     TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE :
> > -				     size - i : count));
> > +	i = 0;
> > +	while (i < size && pin == DATA_ON) {
> > +		int bytes;
> > +
> > +		if (count < TPM_HEADER_SIZE)
> > +			bytes = count;
> > +		else if (i == 0)
> > +			bytes = TPM_HEADER_SIZE;
> > +		else
> > +			bytes = min_t(int, size - i, TPM_I2C_BLOCK_SIZE);
> > +
> > +		ret = i2c_master_recv(client, pin_infos->tpm_i2c_buffer[1],
> > +				      bytes);
> >  		if (ret < 0) {
> >  			pr_info("Failed to read gpio pin (DataAvailable)\n");
> >  			goto end;
> >  		}
> > 
> > -		if (buf != NULL) {
> > -			memcpy(buf + i, pin_infos->tpm_i2c_buffer[1],
> > -			       (count >= TPM_HEADER_SIZE ? i == 0 ?
> > -				TPM_HEADER_SIZE : (size - i) >
> > -				TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE : size -
> > -				i : count));
> > -
> > -			if (i == 0) {
> > -				size = responseSize(buf, size);
> > -				if (size > count)
> > -					size = count;
> > -			}
> > -		} else {
> > +		if (!buf) {
> >  			pr_info("read buffer is NULL\n");
> >  			goto end;
> >  		}
> > 
> > -		(i == 0) ? (i += TPM_HEADER_SIZE) : (i += TPM_I2C_BLOCK_SIZE);
> > +		memcpy(buf + i, pin_infos->tpm_i2c_buffer[1], size);
> > +
> > +		if (i == 0) {
> > +			size = responseSize(buf, size);
> > +			if (size > count)
> > +				size = count;
> > +			i += TPM_HEADER_SIZE;
> > +		} else
> > +			i += TPM_I2C_BLOCK_SIZE;
> > 
> >  		if (i < size)
> > -			pin =
> > -			    wait_event_interruptible_on_gpio(chip->vendor.
> > -							     read_queue,
> > -							     msecs_to_jiffies
> > -							     (TPM_I2C_SHORT));
> > +			pin = wait_event_interruptible_on_gpio(
> > +					chip->vendor.read_queue,
> > +					msecs_to_jiffies(TPM_I2C_SHORT));
> >  	}
> > 
> >  	if (i == 0) {
> > @@ -532,7 +544,7 @@ static ssize_t tpm_st19_i2c_ioctl(struct inode *inode, struct file *file,
> >  		return -ENOSYS;
> >  	case TPMIOC_TRANSMIT:
> >  		if (copy_from_user(pin_infos->tpm_i2c_buffer[0],
> > -		    (const char *)arg, TPM_HEADER_SIZE))
> > +				   (const char *)arg, TPM_HEADER_SIZE))
> >  			return -EFAULT;
> >  		in_size = responseSize(pin_infos->tpm_i2c_buffer[0],
> >  				      TPM_HEADER_SIZE);
> 
> 
> 

-- 
James Morris
<jmorris@namei.org>
