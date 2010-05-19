Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab0ESLGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:06:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51492 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757369Ab0ESLG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:06:29 -0400
Date: Wed, 19 May 2010 12:13:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David Dajun Chen" <Dajun.Chen@diasemi.com>
Cc: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Subject: Re: [PATCH] MFD of DA9052 Linux device drivers (1/9)
Message-ID: <20100519121329.48f13fa8@lxorguk.ukuu.org.uk>
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EB@pandora.diasemi.com>
References: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EB@pandora.diasemi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A first general pass over part 1 - from the look of it there are some
general themes here worth looking it across them all before resubmitting.

If bits of this commentary don't make sense let me know and I'll try and
explain more.

Alan


> +
> +#ifndef CONFIG_ARCH_S3C64XX
> +#include <linux/syscalls.h>
> +#endif

You have the odd ifdef like this which seems odd. If you need syscalls.h
include it, if not don't.


> +/*--------------------------------------------------------------------------*/
> +/* Local Macro Definitions                                                  */
> +/*--------------------------------------------------------------------------*/

Style wise it would be helpful I think to lose blank sections


> +typedef struct {
> +	u32 adc_vddout	:1;
> +	u32 adc_ich	:1;
> +	u32 adc_tbat	:1;
> +	u32 adc_vbat	:1;
> +	u32 adc_in4	:1;
> +	u32 adc_in5	:1;
> +	u32 adc_in6	:1;
> +	u32 adc_tsi	:1;
> +	u32 adc_tsense	:1;
> +	u32 adc_vbbat	:1;
> +	u32 dummy	:22;
> +} adc_mode_status_t;

Be careful here. Firstly the typedefs generally make it less obvious what
is going on, but secondly the compiler can choose to put typedef bits in
either endian order so you may well find that dummy ends up at the top or
bottom on different systems. This is one reason a lot of code in the
kernel tends not to use typdef enums for bit operations


> +/* EH structures for all possible events */
> +da9052_eh_nb adc4_eh_data;
> +da9052_eh_nb adc5_eh_data;
> +da9052_eh_nb adc6_eh_data;
> +da9052_eh_nb comp_1v2_eh_data;

static ?


> + *	ADC_SSC_BUS_ERROR - If there is an error on the SSC bus.
> + *	SUCCESS		  - On successful completion of the call.

This is visible across the code. The kernel has a set of error codes that
are generally used, and 0 is used for success.

So a quick search/replace of SUCCESS for 0 and the others for negative
error codes (-EINVAL etc) would help make the code easier for everyone to
follow.

> +	/* ADC channel 4 and 5 are by default enabled */
> +#if (ADC_CONF_ADC4)

Things like this should be runtime switchable unless massive amounts of
code. Otherwise people end up recompiling stuff which makes it harder
work for those trying to ship generic kernels for boards.

> +		return (ADC_SSC_BUS_ERROR);

Most return (x) don't need the brackets. Again a quick search/replace
operation would clean that up


> + * da9052_adc_signal_to_user; 
> + * This function signal to the library to call the call back function.
> + * 
> + * @param event
> + * @return s32
> + */
> +static s32 da9052_adc_signal_to_user(u8 event)
> +{
> +	DA9052_DEBUG("%s: event status: %d \n", __FUNCTION__, event);
> +	kill_fasync(&adc_fasync_queue, SIGIO, POLL_IN);
> +
> +	return(SUCCESS);
> +}

Why make it s32 if it always returns 0 ?

> +	switch (channel) {
> +	case ADC_VDDOUT:
> +		adc_mode_status.adc_vddout = mode;

Is there a reason the adc_mode_status isn't just an array ? Then this
would all collapse into

	if (< 0 || > range)
		error
	else
	adc_mode_status[channel] = mode 
>
> +	switch(channel){
> +	/* VDD_OUT channel */
> +	case ADC_VDDOUT:{

and much of this lot ..


> +void da9052_adc_adcin6_handler(u32 data)
> +{
> +	/* Acquire lock before accessing the status variable */
> +	mutex_lock(&adc_event_occ_lock);

Similarly with all these you seem to end up with lots of functions
because you use typdefs for it all so can't just do

	adc_event_occ_status.event_bits |= 1 << mask[x];
	signal_to_user(event[x])

and have a single handler that is generic

> +	/* Store the status of the event in the variable */
> +	adc_event_occ_status.event_bits_t.adc_adcin6_e_occ = TRUE;
> +	/* Release the lock */
> +	mutex_unlock(&adc_event_occ_lock);
> +	/* Signal to the user space */
> +	da9052_adc_signal_to_user(GPI2_EVE);
> +}
> +

> +s32 da9052_adc_register_event(u8 event_type)
> +{
> +	/* Register the callback function with event handler */
> +	switch(event_type) {
> +	case GPI0_EVE:
> +#if ADC_CONF_ADC4
> +		/* Check if event is already registered */
> +		if (!is_eh_registered.adc4_event) {
> +			/* Set the EH structure */
> +			adc4_eh_data.call_back = da9052_adc_adcin4_handler;
> +			adc4_eh_data.eve_type = event_type;
> +			/* Register the event with EH */
> +			if (da9052_eh_register_nb(&adc4_eh_data))
> +				return (ADC_EVENT_REGISTRATION_FAILED);
> +			/* Set the registration flag to 1 */
> +			is_eh_registered.adc4_event = TRUE;

And again here.. you'd be looking at

	if (!(events_registered & (1 << event_type))) {
		event[event_type].callback = foo;
		register ..
		events_registered |= (1 << event_type);
	}

plus any locking needed in both cases

And all the other bits would vanish

> +#else
> +		return (ADC_CH4_NOT_CONF);
> +#endif

and an
	if (! (events_enabled & (1 << event_type))
		return -Esomething;

would fix the rest



> +s32 da9052_adc_unregister_event(u8 event_type)
> +{

Similarly in this lot


> +/*--------------------------------------------------------------------------*/
> +/* Infrastructure Functions                                                 */
> +/*--------------------------------------------------------------------------*/
> +/**
> + * da9052_adc_open: 
> + * 
> + * @param *inode pointer to device inode
> + * @param *file  file pointer
> + * @return s32   Error Code, zero: no error
> + */
> +s32 da9052_adc_open(struct inode *inode, struct file *file)
> +{
> +	/* Check if device is already open */
> +	if(adc_device_open) {
> +		printk("DA9052: ADC device already open.\n");
> +		return (-EBUSY);

Locking... open/close could race. Use something like test_and_set_bit()
to do this. 


> +s32 da9052_adc_ioctl(struct inode *inode, struct file *file, 
> +					u32 cmd, unsigned long arg)
> +{
> +/**
> + * da9052_adc_remove: Called when ditaching device from driver
> + * @param void
> + * @return void
> + */
> +static s32 __devexit da9052_adc_remove(struct platform_device *dev)
> +{
> +	DA9052_DEBUG(KERN_DEBUG "Removing %s \n", DA9052_ADC_DEVICE_NAME);

How about freeing things like the character device allocation ?

> +EXPORT_SYMBOL(da9052_set_adc_mode);
> +EXPORT_SYMBOL(da9052_configure_thresholds);

Stylewise should be under the function itself


> +/* Increment with wrap operation for TSI FIFO */
> +#define incr_with_wrap(x)	\
> +		if(++x >= TSI_FIFO_SIZE)	\
> +			x = 0

Hiding this sort of stuff needs care - its not locking safe but it hides
that fact



> +	/* Acqurie nb array lock */
> +	if(down_interruptible(&eh_info.eve_nb_array_lock))
> +		return (FAILURE);

Please use mutexes whenever possible - that makes realtime the realtime
Linux people much happier.


> +	/* Acquire TSI FIFO lock */
> +	if(down_interruptible(&tsi_info.tsi_fifo_lock))
> +		return (0);
> +
> +	if(tsi_info.tsi_fifo_start < tsi_info.tsi_fifo_end){
> +		/* FIFO partly or completely full but NOT overflown */

See the kfifo functionality in the kernel - it should save you lots of
work and some locks.


>
> +	/*
> +	 * This delay is necessary to avoid hardware fake interrupts from DA9052.
> +	 * Because of the 33 us internal delay in sync operation of DA9052, nIRQ line
> +	 * changes state from LOW to HIGH after max. 33 us of clearing event register.
> +	 * If we don't wait for this time (by adding udelay()) before re-enabling the
> +	 * IRQ, we will immediately get another interrupt, as it is configured as 
> +	 * LOW LEVEL triggered. Experiments showed that delay of 50 us seems to be
> +	 * safe enough to get rid of fake interrupts.
> +	 */
> +	udelay(50);
> +	
> +	//printk(KERN_CRIT "T=%d ", (jiffies - start));
> +	
> +	/* Enable HOST interrupt */
> +	enable_irq(DA9052_IRQ);
> +}

If you need the IRQ masked during processing you really want to be doing
this in the IRQ handler - otherwise your task may get delayed and the
delay may mean important other hardware has its IRQ blocked.

> +
> +/**
> + * process_events: Function to process all events occured
> + * @param
> + * @return int
> + */
> +static s32 process_events(s32 events_sts){
> +	

> +		/* Event bit is set, execute all registered call backs */
> +		if(down_interruptible(&eh_info.eve_nb_array_lock)){
> +			printk(KERN_CRIT "Can't acquire eve_nb_array_lock \n");
> +			return (FAILURE);
> +		}

Randomly losing events seems a bit of bad way to handle this ? Would it
not be better to scan them all in the IRQ handler into a queue then kick
off work that can sleep to empty the queue ?



> + * da9052_eh_open: Function that is called when some one opens EH device node
> + * 
> + * @param *inode pointer to device inode
> + * @param *file  file pointer
> + * @return int   Error Code, zero: no error
> + */
> +s32 da9052_eh_open(struct inode *inode, struct file *file)
> +{
> +	/* Check if device is already open */
> +	if(eh_info.device_open) {
> +		printk( KERN_INFO "DA9052: EH device already open.\n");
> +		return (-EBUSY);

Again locking


> +static int __devexit da9052_eh_remove(struct platform_device *dev)
> +{
> +	DA9052_DEBUG(KERN_DEBUG "Removing %s \n", DA9052_EH_DEVICE_NAME);

Again not actually coded for some reason so leaks resources on unload

> +	/* Now selectively set type for all Volatile registers */
> +	ssc_info.ssc_cache[DA9052_STATUSA_REG].type	= VOLATILE;	// Reg - 1

See test_bit/set_bit/clear_bit - they work on arrays of bits so you can
simply set up a 128bit array pair, initialise it at compile time and turn
the tests into

	if (test_bit(n, &ssc_reg_volatile))

and
	if (test_bit(n, &ssc_info.ssc_valid))


However you do it you can initialise it at compile time...

> +	 * It is better to do un-interruptible sleep here. Otherwise we will get
> +	 * interttupted in case of high frequency events e.g. ADC THRESHOLD.
> +	 * As a result this SSC write operation will fail!
> +	 */
> +	down(&ssc_info.ssc_sem);

Use mutexes

 
> +	 * Check if this is a Non-volatile register, if yes then return value -
> +	 * from cache instead of actual reading from hardware. Before reading -
> +	 * cache entry, make sure that the entry is valid
> +	 */
> +	if(ssc_info.ssc_cache[sscmsg->addr].type != VOLATILE){
> +		/* The read request is for Non-volatile register */
> +		/* Check if we have valid cached value for this */
> +		if(ssc_info.ssc_cache[sscmsg->addr].status == VALID){

If you never set the valid bit for a volatile register cache why test
both ?


> +			/* We have valid cached value, copy this value */
> +			sscmsg->data = ssc_info.ssc_cache[sscmsg->addr].val;
> +			
> +			/* Release ssc lock */
> +			up(&ssc_info.ssc_sem);
> +			return (SUCCESS);
> +		}
> +	}
> +	
> +#if defined (CONFIG_MFD_DA9052_SPI)
> +	/* Call SPI specific function */
> +	ret = da9052_ssc_spi_read(sscmsg);
> +	
> +#elif defined (CONFIG_MFD_DA9052_I2C)
> +	/* Put I2C specific function here */
> +	ret = da9052_ssc_i2c_read(sscmsg);
> +#endif

This should be handled at runtime (probably you want an ssc_read function
pointer or function pointer array). You'll see several other SPI/I²C
drivers have

	foo.c		-	the device driver
	foo_spi.c	-	SPI read/write functions for driver +
				struct something_ops
	foo_i2c.c	-	Ditto for I2C




> +/* Macros to configure the ADC port pins */
> +#if (DA9052_GPIO_PIN_0 == DA9052_GPIO_CONFIG_ADC)
> +#define ADC_CONF_ADC4					ENABLE

This sort of magic wants to be runtime, and certainly not hidden away


> +typedef struct {
> +	u8 auto4_high;
> +	u8 auto4_low;
> +	u8 auto5_high;
> +	u8 auto5_low;
> +	u8 auto6_high;
> +	u8 auto6_low;
> +}threshold_res;

Avoid typedefs for this kind fo stuff (see Documentation/CodingStyle)



> +/* To enable debug output for your module, set this to 1 */
> +#define		DA9052_EH_DEBUG		0
> +
> +#undef DA9052_DEBUG
> +#if DA9052_EH_DEBUG
> +#define DA9052_DEBUG( fmt, args... ) printk( KERN_CRIT "" fmt, ##args )
> +#else
> +#define DA9052_DEBUG( fmt, args... )
> +#endif

See dev_dbg and friends


> +/* Failed Copy from User */
> +#define COPY_FROM_USER_FAILED			(3)
> +
> +/* Failed Copy to User */
> +#define COPY_TO_USER_FAILED			(4)

And use standard Linux error codes


> +#define TRUE		1
> +#define FALSE		0

The kernel has its own set of these

