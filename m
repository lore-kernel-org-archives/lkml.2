Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2FNNhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:37:37 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:39582 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2FNNhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:37:35 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4FD9E917.8020602@cam.ac.uk>
Date: Thu, 14 Jun 2012 14:37:27 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: let the doc follow core code move
References: <alpine.LNX.2.00.1206141527230.8644@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1206141527230.8644@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2012 2:28 PM, Jiri Kosina wrote:
> As the IIO core code has been moved out of staging, let the appropriate
> documentation appear in Documentation/iio (which is what
> drivers/iio/Kconfig suggests as a location to look for it anyway).
>
I'd really rather not do this just yet.  There are elements that are out 
of date or downright wrong in here. Much like the drivers, these
should get some careful review before they go anywhere.

For now we have carefully only moved abi docs that have been
carefully sanity checked first (and even then a few 'interesting'
corners made it through).

Obviously we'd like to do that pretty soon!
In the meantime it comes down to that old story of wrong docs
perhaps being worse than no docs.

> Signed-off-by: Jiri Kosina<jkosina@suse.cz>
> ---
>   Documentation/iio/device.txt                       |   81 +++
>   Documentation/iio/generic_buffer.c                 |  329 ++++++++++
>   Documentation/iio/iio_event_monitor.c              |  241 ++++++++
>   Documentation/iio/iio_utils.h                      |  639 ++++++++++++++++++++
>   Documentation/iio/inkernel.txt                     |   58 ++
>   Documentation/iio/overview.txt                     |   57 ++
>   Documentation/iio/ring.txt                         |   47 ++
>   drivers/staging/iio/Documentation/device.txt       |   81 ---
>   drivers/staging/iio/Documentation/generic_buffer.c |  329 ----------
>   .../staging/iio/Documentation/iio_event_monitor.c  |  241 --------
>   drivers/staging/iio/Documentation/iio_utils.h      |  639 --------------------
>   drivers/staging/iio/Documentation/inkernel.txt     |   58 --
>   drivers/staging/iio/Documentation/overview.txt     |   57 --
>   drivers/staging/iio/Documentation/ring.txt         |   47 --
>   14 files changed, 1452 insertions(+), 1452 deletions(-)
>   create mode 100644 Documentation/iio/device.txt
>   create mode 100644 Documentation/iio/generic_buffer.c
>   create mode 100644 Documentation/iio/iio_event_monitor.c
>   create mode 100644 Documentation/iio/iio_utils.h
>   create mode 100644 Documentation/iio/inkernel.txt
>   create mode 100644 Documentation/iio/overview.txt
>   create mode 100644 Documentation/iio/ring.txt
>   delete mode 100644 drivers/staging/iio/Documentation/device.txt
>   delete mode 100644 drivers/staging/iio/Documentation/generic_buffer.c
>   delete mode 100644 drivers/staging/iio/Documentation/iio_event_monitor.c
>   delete mode 100644 drivers/staging/iio/Documentation/iio_utils.h
>   delete mode 100644 drivers/staging/iio/Documentation/inkernel.txt
>   delete mode 100644 drivers/staging/iio/Documentation/overview.txt
>   delete mode 100644 drivers/staging/iio/Documentation/ring.txt
>
> diff --git a/Documentation/iio/device.txt b/Documentation/iio/device.txt
> new file mode 100644
> index 0000000..0338c7c
> --- /dev/null
> +++ b/Documentation/iio/device.txt
> @@ -0,0 +1,81 @@
> +IIO Device drivers
> +
> +This is not intended to provide a comprehensive guide to writing an
> +IIO device driver.  For further information see the drivers within the
> +subsystem.
> +
> +The crucial structure for device drivers in iio is iio_dev.
> +
> +First allocate one using:
> +
> +struct iio_dev *indio_dev = iio_device_alloc(sizeof(struct chip_state));
> +where chip_state is a structure of local state data for this instance of
> +the chip.
> +
> +That data can be accessed using iio_priv(struct iio_dev *)
> +
> +Then fill in the following:
> +
> +- indio_dev->dev.parent
> +	Struct device associated with the underlying hardware.
> +- indio_dev->name
> +	Name of the device being driven - made available as the name
> +	attribute in sysfs.
> +
> +- indio_dev->info
> +	pointer to a structure with elements that tend to be fixed for
> +	large sets of different parts supported by a given driver.
> +	This contains:
> +	* info->driver_module:
> +		Set to THIS_MODULE. Used to ensure correct ownership
> +		of various resources allocate by the core.
> +	* info->num_interrupt_lines:
> +		Number of event triggering hardware lines the device has.
> +	* info->event_attrs:
> +		Attributes used to enable / disable hardware events.
> +	* info->attrs:
> +		General device attributes. Typically used for the weird
> +		and the wonderful bits not covered by the channel specification.
> +	* info->read_raw:
> +		Raw data reading function. Used for both raw channel access
> +		and for associate parameters such as offsets and scales.
> +	* info->write_raw:
> +		Raw value writing function. Used for writable device values such
> +		as DAC values and caliboffset.
> +	* info->read_event_config:
> +		Typically only set if there are some interrupt lines.  This
> +		is used to read if an on sensor event detector is enabled.
> +	* info->write_event_config:
> +		Enable / disable an on sensor event detector.
> +	* info->read_event_value:
> +		Read value associated with on sensor event detectors. Note that
> +		the meaning of the returned value is dependent on the event
> +		type.
> +	* info->write_event_value:
> +		Write the value associated with on sensor event detectors. E.g.
> +		a threshold above which an interrupt occurs.  Note that the
> +		meaning of the value to be set is event type dependant.
> +
> +- indio_dev->modes:
> +	Specify whether direct access and / or ring buffer access is supported.
> +- indio_dev->ring:
> +	An optional associated buffer.
> +- indio_dev->pollfunc:
> +	Poll function related elements. This controls what occurs when a trigger
> +	to which this device is attached sends an event.
> +- indio_dev->channels:
> +	Specification of device channels. Most attributes etc are built
> +	form this spec.
> +- indio_dev->num_channels:
> +	How many channels are there?
> +
> +Once these are set up, a call to iio_device_register(indio_dev),
> +will register the device with the iio core.
> +
> +Worth noting here is that, if a ring buffer is to be used, it can be
> +allocated prior to registering the device with the iio-core, but must
> +be registered afterwards (otherwise the whole parentage of devices
> +gets confused)
> +
> +On remove, iio_device_unregister(indio_dev) will remove the device from
> +the core, and iio_device_free will clean up.
> diff --git a/Documentation/iio/generic_buffer.c b/Documentation/iio/generic_buffer.c
> new file mode 100644
> index 0000000..bf55335
> --- /dev/null
> +++ b/Documentation/iio/generic_buffer.c
> @@ -0,0 +1,329 @@
> +/* Industrialio buffer test code.
> + *
> + * Copyright (c) 2008 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is primarily intended as an example application.
> + * Reads the current buffer setup from sysfs and starts a short capture
> + * from the specified device, pretty printing the result after appropriate
> + * conversion.
> + *
> + * Command line parameters
> + * generic_buffer -n<device_name>  -t<trigger_name>
> + * If trigger name is not specified the program assumes you want a dataready
> + * trigger associated with the device and goes looking for it.
> + *
> + */
> +
> +#include<unistd.h>
> +#include<dirent.h>
> +#include<fcntl.h>
> +#include<stdio.h>
> +#include<errno.h>
> +#include<sys/stat.h>
> +#include<sys/dir.h>
> +#include<linux/types.h>
> +#include<string.h>
> +#include<poll.h>
> +#include<endian.h>
> +#include "iio_utils.h"
> +
> +/**
> + * size_from_channelarray() - calculate the storage size of a scan
> + * @channels: the channel info array
> + * @num_channels: size of the channel info array
> + *
> + * Has the side effect of filling the channels[i].location values used
> + * in processing the buffer output.
> + **/
> +int size_from_channelarray(struct iio_channel_info *channels, int num_channels)
> +{
> +	int bytes = 0;
> +	int i = 0;
> +	while (i<  num_channels) {
> +		if (bytes % channels[i].bytes == 0)
> +			channels[i].location = bytes;
> +		else
> +			channels[i].location = bytes - bytes%channels[i].bytes
> +				+ channels[i].bytes;
> +		bytes = channels[i].location + channels[i].bytes;
> +		i++;
> +	}
> +	return bytes;
> +}
> +
> +void print2byte(int input, struct iio_channel_info *info)
> +{
> +	/* First swap if incorrect endian */
> +
> +	if (info->be)
> +		input = be16toh((uint16_t)input);
> +	else
> +		input = le16toh((uint16_t)input);
> +
> +	/* shift before conversion to avoid sign extension
> +	   of left aligned data */
> +	input = input>>  info->shift;
> +	if (info->is_signed) {
> +		int16_t val = input;
> +		val&= (1<<  info->bits_used) - 1;
> +		val = (int16_t)(val<<  (16 - info->bits_used))>>
> +			(16 - info->bits_used);
> +		printf("%05f  ", val,
> +		       (float)(val + info->offset)*info->scale);
> +	} else {
> +		uint16_t val = input;
> +		val&= (1<<  info->bits_used) - 1;
> +		printf("%05f ", ((float)val + info->offset)*info->scale);
> +	}
> +}
> +/**
> + * process_scan() - print out the values in SI units
> + * @data:		pointer to the start of the scan
> + * @infoarray:		information about the channels. Note
> + *  size_from_channelarray must have been called first to fill the
> + *  location offsets.
> + * @num_channels:	the number of active channels
> + **/
> +void process_scan(char *data,
> +		  struct iio_channel_info *infoarray,
> +		  int num_channels)
> +{
> +	int k;
> +	for (k = 0; k<  num_channels; k++)
> +		switch (infoarray[k].bytes) {
> +			/* only a few cases implemented so far */
> +		case 2:
> +			print2byte(*(uint16_t *)(data + infoarray[k].location),
> +				&infoarray[k]);
> +			break;
> +		case 8:
> +			if (infoarray[k].is_signed) {
> +				int64_t val = *(int64_t *)
> +					(data +
> +					 infoarray[k].location);
> +				if ((val>>  infoarray[k].bits_used)&  1)
> +					val = (val&  infoarray[k].mask) |
> +						~infoarray[k].mask;
> +				/* special case for timestamp */
> +				if (infoarray[k].scale == 1.0f&&
> +				    infoarray[k].offset == 0.0f)
> +					printf(" %lld", val);
> +				else
> +					printf("%05f ", ((float)val +
> +							 infoarray[k].offset)*
> +					       infoarray[k].scale);
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +	printf("\n");
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	unsigned long num_loops = 2;
> +	unsigned long timedelay = 1000000;
> +	unsigned long buf_len = 128;
> +
> +
> +	int ret, c, i, j, toread;
> +
> +	FILE *fp_ev;
> +	int fp;
> +
> +	int num_channels;
> +	char *trigger_name = NULL, *device_name = NULL;
> +	char *dev_dir_name, *buf_dir_name;
> +
> +	int datardytrigger = 1;
> +	char *data;
> +	ssize_t read_size;
> +	int dev_num, trig_num;
> +	char *buffer_access;
> +	int scan_size;
> +	int noevents = 0;
> +	char *dummy;
> +
> +	struct iio_channel_info *infoarray;
> +
> +	while ((c = getopt(argc, argv, "l:w:c:et:n:")) != -1) {
> +		switch (c) {
> +		case 'n':
> +			device_name = optarg;
> +			break;
> +		case 't':
> +			trigger_name = optarg;
> +			datardytrigger = 0;
> +			break;
> +		case 'e':
> +			noevents = 1;
> +			break;
> +		case 'c':
> +			num_loops = strtoul(optarg,&dummy, 10);
> +			break;
> +		case 'w':
> +			timedelay = strtoul(optarg,&dummy, 10);
> +			break;
> +		case 'l':
> +			buf_len = strtoul(optarg,&dummy, 10);
> +			break;
> +		case '?':
> +			return -1;
> +		}
> +	}
> +
> +	if (device_name == NULL)
> +		return -1;
> +
> +	/* Find the device requested */
> +	dev_num = find_type_by_name(device_name, "iio:device");
> +	if (dev_num<  0) {
> +		printf("Failed to find the %s\n", device_name);
> +		ret = -ENODEV;
> +		goto error_ret;
> +	}
> +	printf("iio device number being used is %d\n", dev_num);
> +
> +	asprintf(&dev_dir_name, "%siio:device%d", iio_dir, dev_num);
> +	if (trigger_name == NULL) {
> +		/*
> +		 * Build the trigger name. If it is device associated it's
> +		 * name is<device_name>_dev[n] where n matches the device
> +		 * number found above
> +		 */
> +		ret = asprintf(&trigger_name,
> +			       "%s-dev%d", device_name, dev_num);
> +		if (ret<  0) {
> +			ret = -ENOMEM;
> +			goto error_ret;
> +		}
> +	}
> +
> +	/* Verify the trigger exists */
> +	trig_num = find_type_by_name(trigger_name, "trigger");
> +	if (trig_num<  0) {
> +		printf("Failed to find the trigger %s\n", trigger_name);
> +		ret = -ENODEV;
> +		goto error_free_triggername;
> +	}
> +	printf("iio trigger number being used is %d\n", trig_num);
> +
> +	/*
> +	 * Parse the files in scan_elements to identify what channels are
> +	 * present
> +	 */
> +	ret = build_channel_array(dev_dir_name,&infoarray,&num_channels);
> +	if (ret) {
> +		printf("Problem reading scan element information\n");
> +		printf("diag %s\n", dev_dir_name);
> +		goto error_free_triggername;
> +	}
> +
> +	/*
> +	 * Construct the directory name for the associated buffer.
> +	 * As we know that the lis3l02dq has only one buffer this may
> +	 * be built rather than found.
> +	 */
> +	ret = asprintf(&buf_dir_name,
> +		       "%siio:device%d/buffer", iio_dir, dev_num);
> +	if (ret<  0) {
> +		ret = -ENOMEM;
> +		goto error_free_triggername;
> +	}
> +	printf("%s %s\n", dev_dir_name, trigger_name);
> +	/* Set the device trigger to be the data rdy trigger found above */
> +	ret = write_sysfs_string_and_verify("trigger/current_trigger",
> +					dev_dir_name,
> +					trigger_name);
> +	if (ret<  0) {
> +		printf("Failed to write current_trigger file\n");
> +		goto error_free_buf_dir_name;
> +	}
> +
> +	/* Setup ring buffer parameters */
> +	ret = write_sysfs_int("length", buf_dir_name, buf_len);
> +	if (ret<  0)
> +		goto error_free_buf_dir_name;
> +
> +	/* Enable the buffer */
> +	ret = write_sysfs_int("enable", buf_dir_name, 1);
> +	if (ret<  0)
> +		goto error_free_buf_dir_name;
> +	scan_size = size_from_channelarray(infoarray, num_channels);
> +	data = malloc(scan_size*buf_len);
> +	if (!data) {
> +		ret = -ENOMEM;
> +		goto error_free_buf_dir_name;
> +	}
> +
> +	ret = asprintf(&buffer_access, "/dev/iio:device%d", dev_num);
> +	if (ret<  0) {
> +		ret = -ENOMEM;
> +		goto error_free_data;
> +	}
> +
> +	/* Attempt to open non blocking the access dev */
> +	fp = open(buffer_access, O_RDONLY | O_NONBLOCK);
> +	if (fp == -1) { /*If it isn't there make the node */
> +		printf("Failed to open %s\n", buffer_access);
> +		ret = -errno;
> +		goto error_free_buffer_access;
> +	}
> +
> +	/* Wait for events 10 times */
> +	for (j = 0; j<  num_loops; j++) {
> +		if (!noevents) {
> +			struct pollfd pfd = {
> +				.fd = fp,
> +				.events = POLLIN,
> +			};
> +
> +			poll(&pfd, 1, -1);
> +			toread = buf_len;
> +
> +		} else {
> +			usleep(timedelay);
> +			toread = 64;
> +		}
> +
> +		read_size = read(fp,
> +				 data,
> +				 toread*scan_size);
> +		if (read_size == -EAGAIN) {
> +			printf("nothing available\n");
> +			continue;
> +		}
> +		for (i = 0; i<  read_size/scan_size; i++)
> +			process_scan(data + scan_size*i,
> +				     infoarray,
> +				     num_channels);
> +	}
> +
> +	/* Stop the ring buffer */
> +	ret = write_sysfs_int("enable", buf_dir_name, 0);
> +	if (ret<  0)
> +		goto error_close_buffer_access;
> +
> +	/* Disconnect from the trigger - just write a dummy name.*/
> +	write_sysfs_string("trigger/current_trigger",
> +			dev_dir_name, "NULL");
> +
> +error_close_buffer_access:
> +	close(fp);
> +error_free_data:
> +	free(data);
> +error_free_buffer_access:
> +	free(buffer_access);
> +error_free_buf_dir_name:
> +	free(buf_dir_name);
> +error_free_triggername:
> +	if (datardytrigger)
> +		free(trigger_name);
> +error_ret:
> +	return ret;
> +}
> diff --git a/Documentation/iio/iio_event_monitor.c b/Documentation/iio/iio_event_monitor.c
> new file mode 100644
> index 0000000..2227584
> --- /dev/null
> +++ b/Documentation/iio/iio_event_monitor.c
> @@ -0,0 +1,241 @@
> +/* Industrialio event test code.
> + *
> + * Copyright (c) 2011-2012 Lars-Peter Clausen<lars@metafoo.de>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is primarily intended as an example application.
> + * Reads the current buffer setup from sysfs and starts a short capture
> + * from the specified device, pretty printing the result after appropriate
> + * conversion.
> + *
> + * Usage:
> + *	iio_event_monitor<device_name>
> + *
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include<unistd.h>
> +#include<stdbool.h>
> +#include<stdio.h>
> +#include<errno.h>
> +#include<string.h>
> +#include<poll.h>
> +#include<fcntl.h>
> +#include<sys/ioctl.h>
> +#include "iio_utils.h"
> +#include<linux/iio/events.h>
> +
> +static const char * const iio_chan_type_name_spec[] = {
> +	[IIO_VOLTAGE] = "voltage",
> +	[IIO_CURRENT] = "current",
> +	[IIO_POWER] = "power",
> +	[IIO_ACCEL] = "accel",
> +	[IIO_ANGL_VEL] = "anglvel",
> +	[IIO_MAGN] = "magn",
> +	[IIO_LIGHT] = "illuminance",
> +	[IIO_INTENSITY] = "intensity",
> +	[IIO_PROXIMITY] = "proximity",
> +	[IIO_TEMP] = "temp",
> +	[IIO_INCLI] = "incli",
> +	[IIO_ROT] = "rot",
> +	[IIO_ANGL] = "angl",
> +	[IIO_TIMESTAMP] = "timestamp",
> +	[IIO_CAPACITANCE] = "capacitance",
> +};
> +
> +static const char * const iio_ev_type_text[] = {
> +	[IIO_EV_TYPE_THRESH] = "thresh",
> +	[IIO_EV_TYPE_MAG] = "mag",
> +	[IIO_EV_TYPE_ROC] = "roc",
> +	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
> +	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
> +};
> +
> +static const char * const iio_ev_dir_text[] = {
> +	[IIO_EV_DIR_EITHER] = "either",
> +	[IIO_EV_DIR_RISING] = "rising",
> +	[IIO_EV_DIR_FALLING] = "falling"
> +};
> +
> +static const char * const iio_modifier_names[] = {
> +	[IIO_MOD_X] = "x",
> +	[IIO_MOD_Y] = "y",
> +	[IIO_MOD_Z] = "z",
> +	[IIO_MOD_LIGHT_BOTH] = "both",
> +	[IIO_MOD_LIGHT_IR] = "ir",
> +};
> +
> +static bool event_is_known(struct iio_event_data *event)
> +{
> +	enum iio_chan_type type = IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event->id);
> +	enum iio_modifier mod = IIO_EVENT_CODE_EXTRACT_MODIFIER(event->id);
> +	enum iio_event_type ev_type = IIO_EVENT_CODE_EXTRACT_TYPE(event->id);
> +	enum iio_event_direction dir = IIO_EVENT_CODE_EXTRACT_DIR(event->id);
> +
> +	switch (type) {
> +	case IIO_VOLTAGE:
> +	case IIO_CURRENT:
> +	case IIO_POWER:
> +	case IIO_ACCEL:
> +	case IIO_ANGL_VEL:
> +	case IIO_MAGN:
> +	case IIO_LIGHT:
> +	case IIO_INTENSITY:
> +	case IIO_PROXIMITY:
> +	case IIO_TEMP:
> +	case IIO_INCLI:
> +	case IIO_ROT:
> +	case IIO_ANGL:
> +	case IIO_TIMESTAMP:
> +	case IIO_CAPACITANCE:
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	switch (mod) {
> +	case IIO_NO_MOD:
> +	case IIO_MOD_X:
> +	case IIO_MOD_Y:
> +	case IIO_MOD_Z:
> +	case IIO_MOD_LIGHT_BOTH:
> +	case IIO_MOD_LIGHT_IR:
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	switch (ev_type) {
> +	case IIO_EV_TYPE_THRESH:
> +	case IIO_EV_TYPE_MAG:
> +	case IIO_EV_TYPE_ROC:
> +	case IIO_EV_TYPE_THRESH_ADAPTIVE:
> +	case IIO_EV_TYPE_MAG_ADAPTIVE:
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	switch (dir) {
> +	case IIO_EV_DIR_EITHER:
> +	case IIO_EV_DIR_RISING:
> +	case IIO_EV_DIR_FALLING:
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void print_event(struct iio_event_data *event)
> +{
> +	enum iio_chan_type type = IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event->id);
> +	enum iio_modifier mod = IIO_EVENT_CODE_EXTRACT_MODIFIER(event->id);
> +	enum iio_event_type ev_type = IIO_EVENT_CODE_EXTRACT_TYPE(event->id);
> +	enum iio_event_direction dir = IIO_EVENT_CODE_EXTRACT_DIR(event->id);
> +	int chan = IIO_EVENT_CODE_EXTRACT_CHAN(event->id);
> +	int chan2 = IIO_EVENT_CODE_EXTRACT_CHAN2(event->id);
> +	bool diff = IIO_EVENT_CODE_EXTRACT_DIFF(event->id);
> +
> +	if (!event_is_known(event)) {
> +		printf("Unknown event: time: %lld, id: %llx\n",
> +				event->timestamp, event->id);
> +		return;
> +	}
> +
> +	printf("Event: time: %lld, ", event->timestamp);
> +
> +	if (mod != IIO_NO_MOD) {
> +		printf("type: %s(%s), ",
> +			iio_chan_type_name_spec[type],
> +			iio_modifier_names[mod]);
> +	} else {
> +		printf("type: %s, ",
> +			iio_chan_type_name_spec[type]);
> +	}
> +
> +	if (diff&&  chan>= 0&&  chan2>= 0)
> +		printf("channel: %d-%d, ", chan, chan2);
> +	else if (chan>= 0)
> +		printf("channel: %d, ", chan);
> +
> +	printf("evtype: %s, direction: %s\n",
> +		iio_ev_type_text[ev_type],
> +		iio_ev_dir_text[dir]);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct iio_event_data event;
> +	const char *device_name;
> +	char *chrdev_name;
> +	int ret;
> +	int dev_num;
> +	int fd, event_fd;
> +
> +	if (argc<= 1) {
> +		printf("Usage: %s<device_name>\n", argv[0]);
> +		return -1;
> +	}
> +
> +	device_name = argv[1];
> +
> +	dev_num = find_type_by_name(device_name, "iio:device");
> +	if (dev_num>= 0) {
> +		printf("Found IIO device with name %s with device number %d\n",
> +			device_name, dev_num);
> +		ret = asprintf(&chrdev_name, "/dev/iio:device%d", dev_num);
> +		if (ret<  0) {
> +			ret = -ENOMEM;
> +			goto error_ret;
> +		}
> +	} else {
> +		/* If we can't find a IIO device by name assume device_name is a
> +		   IIO chrdev */
> +		chrdev_name = strdup(device_name);
> +	}
> +
> +	fd = open(chrdev_name, 0);
> +	if (fd == -1) {
> +		fprintf(stdout, "Failed to open %s\n", chrdev_name);
> +		ret = -errno;
> +		goto error_free_chrdev_name;
> +	}
> +
> +	ret = ioctl(fd, IIO_GET_EVENT_FD_IOCTL,&event_fd);
> +
> +	close(fd);
> +
> +	if (ret == -1 || event_fd == -1) {
> +		fprintf(stdout, "Failed to retrieve event fd\n");
> +		ret = -errno;
> +		goto error_free_chrdev_name;
> +	}
> +
> +	while (true) {
> +		ret = read(event_fd,&event, sizeof(event));
> +		if (ret == -1) {
> +			if (errno == EAGAIN) {
> +				printf("nothing available\n");
> +				continue;
> +			} else {
> +				perror("Failed to read event from device");
> +				ret = -errno;
> +				break;
> +			}
> +		}
> +
> +		print_event(&event);
> +	}
> +
> +	close(event_fd);
> +error_free_chrdev_name:
> +	free(chrdev_name);
> +error_ret:
> +	return ret;
> +}
> diff --git a/Documentation/iio/iio_utils.h b/Documentation/iio/iio_utils.h
> new file mode 100644
> index 0000000..6f3a392
> --- /dev/null
> +++ b/Documentation/iio/iio_utils.h
> @@ -0,0 +1,639 @@
> +/* IIO - useful set of util functionality
> + *
> + * Copyright (c) 2008 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +/* Made up value to limit allocation sizes */
> +#include<string.h>
> +#include<stdlib.h>
> +#include<ctype.h>
> +#include<stdio.h>
> +#include<stdint.h>
> +#include<dirent.h>
> +
> +#define IIO_MAX_NAME_LENGTH 30
> +
> +#define FORMAT_SCAN_ELEMENTS_DIR "%s/scan_elements"
> +#define FORMAT_TYPE_FILE "%s_type"
> +
> +const char *iio_dir = "/sys/bus/iio/devices/";
> +
> +/**
> + * iioutils_break_up_name() - extract generic name from full channel name
> + * @full_name: the full channel name
> + * @generic_name: the output generic channel name
> + **/
> +static int iioutils_break_up_name(const char *full_name,
> +				  char **generic_name)
> +{
> +	char *current;
> +	char *w, *r;
> +	char *working;
> +	current = strdup(full_name);
> +	working = strtok(current, "_\0");
> +	w = working;
> +	r = working;
> +
> +	while (*r != '\0') {
> +		if (!isdigit(*r)) {
> +			*w = *r;
> +			w++;
> +		}
> +		r++;
> +	}
> +	*w = '\0';
> +	*generic_name = strdup(working);
> +	free(current);
> +
> +	return 0;
> +}
> +
> +/**
> + * struct iio_channel_info - information about a given channel
> + * @name: channel name
> + * @generic_name: general name for channel type
> + * @scale: scale factor to be applied for conversion to si units
> + * @offset: offset to be applied for conversion to si units
> + * @index: the channel index in the buffer output
> + * @bytes: number of bytes occupied in buffer output
> + * @mask: a bit mask for the raw output
> + * @is_signed: is the raw value stored signed
> + * @enabled: is this channel enabled
> + **/
> +struct iio_channel_info {
> +	char *name;
> +	char *generic_name;
> +	float scale;
> +	float offset;
> +	unsigned index;
> +	unsigned bytes;
> +	unsigned bits_used;
> +	unsigned shift;
> +	uint64_t mask;
> +	unsigned be;
> +	unsigned is_signed;
> +	unsigned enabled;
> +	unsigned location;
> +};
> +
> +/**
> + * iioutils_get_type() - find and process _type attribute data
> + * @is_signed: output whether channel is signed
> + * @bytes: output how many bytes the channel storage occupies
> + * @mask: output a bit mask for the raw data
> + * @be: big endian
> + * @device_dir: the iio device directory
> + * @name: the channel name
> + * @generic_name: the channel type name
> + **/
> +inline int iioutils_get_type(unsigned *is_signed,
> +			     unsigned *bytes,
> +			     unsigned *bits_used,
> +			     unsigned *shift,
> +			     uint64_t *mask,
> +			     unsigned *be,
> +			     const char *device_dir,
> +			     const char *name,
> +			     const char *generic_name)
> +{
> +	FILE *sysfsfp;
> +	int ret;
> +	DIR *dp;
> +	char *scan_el_dir, *builtname, *builtname_generic, *filename = 0;
> +	char signchar, endianchar;
> +	unsigned padint;
> +	const struct dirent *ent;
> +
> +	ret = asprintf(&scan_el_dir, FORMAT_SCAN_ELEMENTS_DIR, device_dir);
> +	if (ret<  0) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	ret = asprintf(&builtname, FORMAT_TYPE_FILE, name);
> +	if (ret<  0) {
> +		ret = -ENOMEM;
> +		goto error_free_scan_el_dir;
> +	}
> +	ret = asprintf(&builtname_generic, FORMAT_TYPE_FILE, generic_name);
> +	if (ret<  0) {
> +		ret = -ENOMEM;
> +		goto error_free_builtname;
> +	}
> +
> +	dp = opendir(scan_el_dir);
> +	if (dp == NULL) {
> +		ret = -errno;
> +		goto error_free_builtname_generic;
> +	}
> +	while (ent = readdir(dp), ent != NULL)
> +		/*
> +		 * Do we allow devices to override a generic name with
> +		 * a specific one?
> +		 */
> +		if ((strcmp(builtname, ent->d_name) == 0) ||
> +		    (strcmp(builtname_generic, ent->d_name) == 0)) {
> +			ret = asprintf(&filename,
> +				       "%s/%s", scan_el_dir, ent->d_name);
> +			if (ret<  0) {
> +				ret = -ENOMEM;
> +				goto error_closedir;
> +			}
> +			sysfsfp = fopen(filename, "r");
> +			if (sysfsfp == NULL) {
> +				printf("failed to open %s\n", filename);
> +				ret = -errno;
> +				goto error_free_filename;
> +			}
> +
> +			ret = fscanf(sysfsfp,
> +				     "%ce:%c%u/%u>>%u",
> +				&endianchar,
> +				&signchar,
> +				     bits_used,
> +				&padint, shift);
> +			if (ret<  0) {
> +				printf("failed to pass scan type description\n");
> +				return ret;
> +			}
> +			*be = (endianchar == 'b');
> +			*bytes = padint / 8;
> +			if (*bits_used == 64)
> +				*mask = ~0;
> +			else
> +				*mask = (1<<  *bits_used) - 1;
> +			if (signchar == 's')
> +				*is_signed = 1;
> +			else
> +				*is_signed = 0;
> +			fclose(sysfsfp);
> +			free(filename);
> +
> +			filename = 0;
> +		}
> +error_free_filename:
> +	if (filename)
> +		free(filename);
> +error_closedir:
> +	closedir(dp);
> +error_free_builtname_generic:
> +	free(builtname_generic);
> +error_free_builtname:
> +	free(builtname);
> +error_free_scan_el_dir:
> +	free(scan_el_dir);
> +error_ret:
> +	return ret;
> +}
> +
> +inline int iioutils_get_param_float(float *output,
> +				    const char *param_name,
> +				    const char *device_dir,
> +				    const char *name,
> +				    const char *generic_name)
> +{
> +	FILE *sysfsfp;
> +	int ret;
> +	DIR *dp;
> +	char *builtname, *builtname_generic;
> +	char *filename = NULL;
> +	const struct dirent *ent;
> +
> +	ret = asprintf(&builtname, "%s_%s", name, param_name);
> +	if (ret<  0) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	ret = asprintf(&builtname_generic,
> +		       "%s_%s", generic_name, param_name);
> +	if (ret<  0) {
> +		ret = -ENOMEM;
> +		goto error_free_builtname;
> +	}
> +	dp = opendir(device_dir);
> +	if (dp == NULL) {
> +		ret = -errno;
> +		goto error_free_builtname_generic;
> +	}
> +	while (ent = readdir(dp), ent != NULL)
> +		if ((strcmp(builtname, ent->d_name) == 0) ||
> +		    (strcmp(builtname_generic, ent->d_name) == 0)) {
> +			ret = asprintf(&filename,
> +				       "%s/%s", device_dir, ent->d_name);
> +			if (ret<  0) {
> +				ret = -ENOMEM;
> +				goto error_closedir;
> +			}
> +			sysfsfp = fopen(filename, "r");
> +			if (!sysfsfp) {
> +				ret = -errno;
> +				goto error_free_filename;
> +			}
> +			fscanf(sysfsfp, "%f", output);
> +			break;
> +		}
> +error_free_filename:
> +	if (filename)
> +		free(filename);
> +error_closedir:
> +	closedir(dp);
> +error_free_builtname_generic:
> +	free(builtname_generic);
> +error_free_builtname:
> +	free(builtname);
> +error_ret:
> +	return ret;
> +}
> +
> +/**
> + * bsort_channel_array_by_index() - reorder so that the array is in index order
> + *
> + **/
> +
> +inline void bsort_channel_array_by_index(struct iio_channel_info **ci_array,
> +					 int cnt)
> +{
> +
> +	struct iio_channel_info temp;
> +	int x, y;
> +
> +	for (x = 0; x<  cnt; x++)
> +		for (y = 0; y<  (cnt - 1); y++)
> +			if ((*ci_array)[y].index>  (*ci_array)[y+1].index) {
> +				temp = (*ci_array)[y + 1];
> +				(*ci_array)[y + 1] = (*ci_array)[y];
> +				(*ci_array)[y] = temp;
> +			}
> +}
> +
> +/**
> + * build_channel_array() - function to figure out what channels are present
> + * @device_dir: the IIO device directory in sysfs
> + * @
> + **/
> +inline int build_channel_array(const char *device_dir,
> +			      struct iio_channel_info **ci_array,
> +			      int *counter)
> +{
> +	DIR *dp;
> +	FILE *sysfsfp;
> +	int count, temp, i;
> +	struct iio_channel_info *current;
> +	int ret;
> +	const struct dirent *ent;
> +	char *scan_el_dir;
> +	char *filename;
> +
> +	*counter = 0;
> +	ret = asprintf(&scan_el_dir, FORMAT_SCAN_ELEMENTS_DIR, device_dir);
> +	if (ret<  0) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	dp = opendir(scan_el_dir);
> +	if (dp == NULL) {
> +		ret = -errno;
> +		goto error_free_name;
> +	}
> +	while (ent = readdir(dp), ent != NULL)
> +		if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
> +			   "_en") == 0) {
> +			ret = asprintf(&filename,
> +				       "%s/%s", scan_el_dir, ent->d_name);
> +			if (ret<  0) {
> +				ret = -ENOMEM;
> +				goto error_close_dir;
> +			}
> +			sysfsfp = fopen(filename, "r");
> +			if (sysfsfp == NULL) {
> +				ret = -errno;
> +				free(filename);
> +				goto error_close_dir;
> +			}
> +			fscanf(sysfsfp, "%u",&ret);
> +			if (ret == 1)
> +				(*counter)++;
> +			fclose(sysfsfp);
> +			free(filename);
> +		}
> +	*ci_array = malloc(sizeof(**ci_array) * (*counter));
> +	if (*ci_array == NULL) {
> +		ret = -ENOMEM;
> +		goto error_close_dir;
> +	}
> +	seekdir(dp, 0);
> +	count = 0;
> +	while (ent = readdir(dp), ent != NULL) {
> +		if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
> +			   "_en") == 0) {
> +			current =&(*ci_array)[count++];
> +			ret = asprintf(&filename,
> +				       "%s/%s", scan_el_dir, ent->d_name);
> +			if (ret<  0) {
> +				ret = -ENOMEM;
> +				/* decrement count to avoid freeing name */
> +				count--;
> +				goto error_cleanup_array;
> +			}
> +			sysfsfp = fopen(filename, "r");
> +			if (sysfsfp == NULL) {
> +				free(filename);
> +				ret = -errno;
> +				goto error_cleanup_array;
> +			}
> +			fscanf(sysfsfp, "%u",&current->enabled);
> +			fclose(sysfsfp);
> +
> +			if (!current->enabled) {
> +				free(filename);
> +				count--;
> +				continue;
> +			}
> +
> +			current->scale = 1.0;
> +			current->offset = 0;
> +			current->name = strndup(ent->d_name,
> +						strlen(ent->d_name) -
> +						strlen("_en"));
> +			if (current->name == NULL) {
> +				free(filename);
> +				ret = -ENOMEM;
> +				goto error_cleanup_array;
> +			}
> +			/* Get the generic and specific name elements */
> +			ret = iioutils_break_up_name(current->name,
> +						&current->generic_name);
> +			if (ret) {
> +				free(filename);
> +				goto error_cleanup_array;
> +			}
> +			ret = asprintf(&filename,
> +				       "%s/%s_index",
> +				       scan_el_dir,
> +				       current->name);
> +			if (ret<  0) {
> +				free(filename);
> +				ret = -ENOMEM;
> +				goto error_cleanup_array;
> +			}
> +			sysfsfp = fopen(filename, "r");
> +			fscanf(sysfsfp, "%u",&current->index);
> +			fclose(sysfsfp);
> +			free(filename);
> +			/* Find the scale */
> +			ret = iioutils_get_param_float(&current->scale,
> +						       "scale",
> +						       device_dir,
> +						       current->name,
> +						       current->generic_name);
> +			if (ret<  0)
> +				goto error_cleanup_array;
> +			ret = iioutils_get_param_float(&current->offset,
> +						       "offset",
> +						       device_dir,
> +						       current->name,
> +						       current->generic_name);
> +			if (ret<  0)
> +				goto error_cleanup_array;
> +			ret = iioutils_get_type(&current->is_signed,
> +						&current->bytes,
> +						&current->bits_used,
> +						&current->shift,
> +						&current->mask,
> +						&current->be,
> +						device_dir,
> +						current->name,
> +						current->generic_name);
> +		}
> +	}
> +
> +	closedir(dp);
> +	/* reorder so that the array is in index order */
> +	bsort_channel_array_by_index(ci_array, *counter);
> +
> +	return 0;
> +
> +error_cleanup_array:
> +	for (i = count - 1;  i>= 0; i--)
> +		free((*ci_array)[i].name);
> +	free(*ci_array);
> +error_close_dir:
> +	closedir(dp);
> +error_free_name:
> +	free(scan_el_dir);
> +error_ret:
> +	return ret;
> +}
> +
> +/**
> + * find_type_by_name() - function to match top level types by name
> + * @name: top level type instance name
> + * @type: the type of top level instance being sort
> + *
> + * Typical types this is used for are device and trigger.
> + **/
> +inline int find_type_by_name(const char *name, const char *type)
> +{
> +	const struct dirent *ent;
> +	int number, numstrlen;
> +
> +	FILE *nameFile;
> +	DIR *dp;
> +	char thisname[IIO_MAX_NAME_LENGTH];
> +	char *filename;
> +
> +	dp = opendir(iio_dir);
> +	if (dp == NULL) {
> +		printf("No industrialio devices available");
> +		return -ENODEV;
> +	}
> +
> +	while (ent = readdir(dp), ent != NULL) {
> +		if (strcmp(ent->d_name, ".") != 0&&
> +			strcmp(ent->d_name, "..") != 0&&
> +			strlen(ent->d_name)>  strlen(type)&&
> +			strncmp(ent->d_name, type, strlen(type)) == 0) {
> +			numstrlen = sscanf(ent->d_name + strlen(type),
> +					   "%d",
> +					&number);
> +			/* verify the next character is not a colon */
> +			if (strncmp(ent->d_name + strlen(type) + numstrlen,
> +					":",
> +					1) != 0) {
> +				filename = malloc(strlen(iio_dir)
> +						+ strlen(type)
> +						+ numstrlen
> +						+ 6);
> +				if (filename == NULL)
> +					return -ENOMEM;
> +				sprintf(filename, "%s%s%d/name",
> +					iio_dir,
> +					type,
> +					number);
> +				nameFile = fopen(filename, "r");
> +				if (!nameFile)
> +					continue;
> +				free(filename);
> +				fscanf(nameFile, "%s", thisname);
> +				if (strcmp(name, thisname) == 0)
> +					return number;
> +				fclose(nameFile);
> +			}
> +		}
> +	}
> +	return -ENODEV;
> +}
> +
> +inline int _write_sysfs_int(char *filename, char *basedir, int val, int verify)
> +{
> +	int ret;
> +	FILE *sysfsfp;
> +	int test;
> +	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
> +	if (temp == NULL)
> +		return -ENOMEM;
> +	sprintf(temp, "%s/%s", basedir, filename);
> +	sysfsfp = fopen(temp, "w");
> +	if (sysfsfp == NULL) {
> +		printf("failed to open %s\n", temp);
> +		ret = -errno;
> +		goto error_free;
> +	}
> +	fprintf(sysfsfp, "%d", val);
> +	fclose(sysfsfp);
> +	if (verify) {
> +		sysfsfp = fopen(temp, "r");
> +		if (sysfsfp == NULL) {
> +			printf("failed to open %s\n", temp);
> +			ret = -errno;
> +			goto error_free;
> +		}
> +		fscanf(sysfsfp, "%d",&test);
> +		if (test != val) {
> +			printf("Possible failure in int write %d to %s%s\n",
> +				val,
> +				basedir,
> +				filename);
> +			ret = -1;
> +		}
> +	}
> +error_free:
> +	free(temp);
> +	return ret;
> +}
> +
> +int write_sysfs_int(char *filename, char *basedir, int val)
> +{
> +	return _write_sysfs_int(filename, basedir, val, 0);
> +}
> +
> +int write_sysfs_int_and_verify(char *filename, char *basedir, int val)
> +{
> +	return _write_sysfs_int(filename, basedir, val, 1);
> +}
> +
> +int _write_sysfs_string(char *filename, char *basedir, char *val, int verify)
> +{
> +	int ret = 0;
> +	FILE  *sysfsfp;
> +	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
> +	if (temp == NULL) {
> +		printf("Memory allocation failed\n");
> +		return -ENOMEM;
> +	}
> +	sprintf(temp, "%s/%s", basedir, filename);
> +	sysfsfp = fopen(temp, "w");
> +	if (sysfsfp == NULL) {
> +		printf("Could not open %s\n", temp);
> +		ret = -errno;
> +		goto error_free;
> +	}
> +	fprintf(sysfsfp, "%s", val);
> +	fclose(sysfsfp);
> +	if (verify) {
> +		sysfsfp = fopen(temp, "r");
> +		if (sysfsfp == NULL) {
> +			printf("could not open file to verify\n");
> +			ret = -errno;
> +			goto error_free;
> +		}
> +		fscanf(sysfsfp, "%s", temp);
> +		if (strcmp(temp, val) != 0) {
> +			printf("Possible failure in string write of %s "
> +				"Should be %s "
> +				"written to %s\%s\n",
> +				temp,
> +				val,
> +				basedir,
> +				filename);
> +			ret = -1;
> +		}
> +	}
> +error_free:
> +	free(temp);
> +
> +	return ret;
> +}
> +
> +/**
> + * write_sysfs_string_and_verify() - string write, readback and verify
> + * @filename: name of file to write to
> + * @basedir: the sysfs directory in which the file is to be found
> + * @val: the string to write
> + **/
> +int write_sysfs_string_and_verify(char *filename, char *basedir, char *val)
> +{
> +	return _write_sysfs_string(filename, basedir, val, 1);
> +}
> +
> +int write_sysfs_string(char *filename, char *basedir, char *val)
> +{
> +	return _write_sysfs_string(filename, basedir, val, 0);
> +}
> +
> +int read_sysfs_posint(char *filename, char *basedir)
> +{
> +	int ret;
> +	FILE  *sysfsfp;
> +	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
> +	if (temp == NULL) {
> +		printf("Memory allocation failed");
> +		return -ENOMEM;
> +	}
> +	sprintf(temp, "%s/%s", basedir, filename);
> +	sysfsfp = fopen(temp, "r");
> +	if (sysfsfp == NULL) {
> +		ret = -errno;
> +		goto error_free;
> +	}
> +	fscanf(sysfsfp, "%d\n",&ret);
> +	fclose(sysfsfp);
> +error_free:
> +	free(temp);
> +	return ret;
> +}
> +
> +int read_sysfs_float(char *filename, char *basedir, float *val)
> +{
> +	float ret = 0;
> +	FILE  *sysfsfp;
> +	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
> +	if (temp == NULL) {
> +		printf("Memory allocation failed");
> +		return -ENOMEM;
> +	}
> +	sprintf(temp, "%s/%s", basedir, filename);
> +	sysfsfp = fopen(temp, "r");
> +	if (sysfsfp == NULL) {
> +		ret = -errno;
> +		goto error_free;
> +	}
> +	fscanf(sysfsfp, "%f\n", val);
> +	fclose(sysfsfp);
> +error_free:
> +	free(temp);
> +	return ret;
> +}
> diff --git a/Documentation/iio/inkernel.txt b/Documentation/iio/inkernel.txt
> new file mode 100644
> index 0000000..a05823e
> --- /dev/null
> +++ b/Documentation/iio/inkernel.txt
> @@ -0,0 +1,58 @@
> +Industrial I/O Subsystem in kernel consumers.
> +
> +The IIO subsystem can act as a layer under other elements of the kernel
> +providing a means of obtaining ADC type readings or of driving DAC type
> +signals.  The functionality supported will grow as use cases arise.
> +
> +Describing the channel mapping (iio/machine.h)
> +
> +Channel associations are described using:
> +
> +struct iio_map {
> +	const char *adc_channel_label;
> +	const char *consumer_dev_name;
> +	const char *consumer_channel;
> +};
> +
> +adc_channel_label identifies the channel on the IIO device by being
> +matched against the datasheet_name field of the iio_chan_spec.
> +
> +consumer_dev_name allows identification of the consumer device.
> +This are then used to find the channel mapping from the consumer device (see
> +below).
> +
> +Finally consumer_channel is a string identifying the channel to the consumer.
> +(Perhaps 'battery_voltage' or similar).
> +
> +An array of these structures is then passed to the IIO driver.
> +
> +Supporting in kernel interfaces in the driver (driver.h)
> +
> +The driver must provide datasheet_name values for its channels and
> +must pass the iio_map structures and a pointer to its own iio_dev structure
> + on to the core via a call to iio_map_array_register.  On removal,
> +iio_map_array_unregister reverses this process.
> +
> +The result of this is that the IIO core now has all the information needed
> +to associate a given channel with the consumer requesting it.
> +
> +Acting as an IIO consumer (consumer.h)
> +
> +The consumer first has to obtain an iio_channel structure from the core
> +by calling iio_channel_get().  The correct channel is identified by:
> +
> +* matching dev or dev_name against consumer_dev and consumer_dev_name
> +* matching consumer_channel against consumer_channel in the map
> +
> +There are then a number of functions that can be used to get information
> +about this channel such as it's current reading.
> +
> +e.g.
> +iio_st_read_channel_raw() - get a reading
> +iio_st_read_channel_type() - get the type of channel
> +
> +There is also provision for retrieving all of the channels associated
> +with a given consumer.  This is useful for generic drivers such as
> +iio_hwmon where the number and naming of channels is not known by the
> +consumer driver.  To do this, use iio_st_channel_get_all.
> +
> diff --git a/Documentation/iio/overview.txt b/Documentation/iio/overview.txt
> new file mode 100644
> index 0000000..afc39ec
> --- /dev/null
> +++ b/Documentation/iio/overview.txt
> @@ -0,0 +1,57 @@
> +Overview of IIO
> +
> +The Industrial I/O subsystem is intended to provide support for devices
> +that in some sense are analog to digital converters (ADCs). As many
> +actual devices combine some ADCs with digital to analog converters
> +(DACs) that functionality is also supported.
> +
> +The aim is to fill the gap between the somewhat similar hwmon and
> +input subsystems.  Hwmon is very much directed at low sample rate
> +sensors used in applications such as fan speed control and temperature
> +measurement.  Input is, as it's name suggests focused on input
> +devices. In some cases there is considerable overlap between these and
> +IIO.
> +
> +A typical device falling into this category would be connected via SPI
> +or I2C.
> +
> +Functionality of IIO
> +
> +* Basic device registration and handling. This is very similar to
> +hwmon with simple polled access to device channels via sysfs.
> +
> +* Event chrdevs.  These are similar to input in that they provide a
> +route to user space for hardware triggered events. Such events include
> +threshold detectors, free-fall detectors and more complex action
> +detection.  The events themselves are currently very simple with
> +merely an event code and a timestamp.  Any data associated with the
> +event must be accessed via polling.
> +
> +Note: A given device may have one or more event channel.  These events are
> +turned on or off (if possible) via sysfs interfaces.
> +
> +* Hardware buffer support.  Some recent sensors have included
> +fifo / ring buffers on the sensor chip.  These greatly reduce the load
> +on the host CPU by buffering relatively large numbers of data samples
> +based on an internal sampling clock. Examples include VTI SCA3000
> +series and Analog Device ADXL345 accelerometers.  Each buffer supports
> +polling to establish when data is available.
> +
> +* Trigger and software buffer support. In many data analysis
> +applications it it useful to be able to capture data based on some
> +external signal (trigger).  These triggers might be a data ready
> +signal, a gpio line connected to some external system or an on
> +processor periodic interrupt.  A single trigger may initialize data
> +capture or reading from a number of sensors.  These triggers are
> +used in IIO to fill software buffers acting in a very similar
> +fashion to the hardware buffers described above.
> +
> +Other documentation:
> +
> +device.txt - elements of a typical device driver.
> +
> +trigger.txt - elements of a typical trigger driver.
> +
> +ring.txt - additional elements required for buffer support.
> +
> +sysfs-bus-iio - abi documentation file.
> diff --git a/Documentation/iio/ring.txt b/Documentation/iio/ring.txt
> new file mode 100644
> index 0000000..e338077
> --- /dev/null
> +++ b/Documentation/iio/ring.txt
> @@ -0,0 +1,47 @@
> +Buffer support within IIO
> +
> +This document is intended as a general overview of the functionality
> +a buffer may supply and how it is specified within IIO.  For more
> +specific information on a given buffer implementation, see the
> +comments in the source code.  Note that some drivers allow buffer
> +implementation to be selected at compile time via Kconfig options.
> +
> +A given buffer implementation typically embeds a struct
> +iio_ring_buffer and it is a pointer to this that is provided to the
> +IIO core. Access to the embedding structure is typically done via
> +container_of functions.
> +
> +struct iio_ring_buffer contains a struct iio_ring_setup_ops *setup_ops
> +which in turn contains the 4 function pointers
> +(preenable, postenable, predisable and postdisable).
> +These are used to perform device specific steps on either side
> +of the core changing it's current mode to indicate that the buffer
> +is enabled or disabled (along with enabling triggering etc as appropriate).
> +
> +Also in struct iio_ring_buffer is a struct iio_ring_access_funcs.
> +The function pointers within here are used to allow the core to handle
> +as much buffer functionality as possible. Note almost all of these
> +are optional.
> +
> +store_to
> +  If possible, push data to the buffer.
> +
> +read_last
> +  If possible, get the most recent scan from the buffer (without removal).
> +  This provides polling like functionality whilst the ring buffering is in
> +  use without a separate read from the device.
> +
> +rip_first_n
> +  The primary buffer reading function. Note that it may well not return
> +  as much data as requested.
> +
> +request_update
> +  If parameters have changed that require reinitialization or configuration of
> +  the buffer this will trigger it.
> +
> +get_bytes_per_datum, set_bytes_per_datum
> +  Get/set the number of bytes for a complete scan. (All samples + timestamp)
> +
> +get_length / set_length
> +  Get/set the number of complete scans that may be held by the buffer.
> +
> diff --git a/drivers/staging/iio/Documentation/device.txt b/drivers/staging/iio/Documentation/device.txt
> deleted file mode 100644
> index 0338c7c..0000000
> --- a/drivers/staging/iio/Documentation/device.txt
> +++ /dev/null
> @@ -1,81 +0,0 @@
> -IIO Device drivers
> -
> -This is not intended to provide a comprehensive guide to writing an
> -IIO device driver.  For further information see the drivers within the
> -subsystem.
> -
> -The crucial structure for device drivers in iio is iio_dev.
> -
> -First allocate one using:
> -
> -struct iio_dev *indio_dev = iio_device_alloc(sizeof(struct chip_state));
> -where chip_state is a structure of local state data for this instance of
> -the chip.
> -
> -That data can be accessed using iio_priv(struct iio_dev *)
> -
> -Then fill in the following:
> -
> -- indio_dev->dev.parent
> -	Struct device associated with the underlying hardware.
> -- indio_dev->name
> -	Name of the device being driven - made available as the name
> -	attribute in sysfs.
> -
> -- indio_dev->info
> -	pointer to a structure with elements that tend to be fixed for
> -	large sets of different parts supported by a given driver.
> -	This contains:
> -	* info->driver_module:
> -		Set to THIS_MODULE. Used to ensure correct ownership
> -		of various resources allocate by the core.
> -	* info->num_interrupt_lines:
> -		Number of event triggering hardware lines the device has.
> -	* info->event_attrs:
> -		Attributes used to enable / disable hardware events.
> -	* info->attrs:
> -		General device attributes. Typically used for the weird
> -		and the wonderful bits not covered by the channel specification.
> -	* info->read_raw:
> -		Raw data reading function. Used for both raw channel access
> -		and for associate parameters such as offsets and scales.
> -	* info->write_raw:
> -		Raw value writing function. Used for writable device values such
> -		as DAC values and caliboffset.
> -	* info->read_event_config:
> -		Typically only set if there are some interrupt lines.  This
> -		is used to read if an on sensor event detector is enabled.
> -	* info->write_event_config:
> -		Enable / disable an on sensor event detector.
> -	* info->read_event_value:
> -		Read value associated with on sensor event detectors. Note that
> -		the meaning of the returned value is dependent on the event
> -		type.
> -	* info->write_event_value:
> -		Write the value associated with on sensor event detectors. E.g.
> -		a threshold above which an interrupt occurs.  Note that the
> -		meaning of the value to be set is event type dependant.
> -
> -- indio_dev->modes:
> -	Specify whether direct access and / or ring buffer access is supported.
> -- indio_dev->ring:
> -	An optional associated buffer.
> -- indio_dev->pollfunc:
> -	Poll function related elements. This controls what occurs when a trigger
> -	to which this device is attached sends an event.
> -- indio_dev->channels:
> -	Specification of device channels. Most attributes etc are built
> -	form this spec.
> -- indio_dev->num_channels:
> -	How many channels are there?
> -
> -Once these are set up, a call to iio_device_register(indio_dev),
> -will register the device with the iio core.
> -
> -Worth noting here is that, if a ring buffer is to be used, it can be
> -allocated prior to registering the device with the iio-core, but must
> -be registered afterwards (otherwise the whole parentage of devices
> -gets confused)
> -
> -On remove, iio_device_unregister(indio_dev) will remove the device from
> -the core, and iio_device_free will clean up.
> diff --git a/drivers/staging/iio/Documentation/generic_buffer.c b/drivers/staging/iio/Documentation/generic_buffer.c
> deleted file mode 100644
> index bf55335..0000000
> --- a/drivers/staging/iio/Documentation/generic_buffer.c
> +++ /dev/null
> @@ -1,329 +0,0 @@
> -/* Industrialio buffer test code.
> - *
> - * Copyright (c) 2008 Jonathan Cameron
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of the GNU General Public License version 2 as published by
> - * the Free Software Foundation.
> - *
> - * This program is primarily intended as an example application.
> - * Reads the current buffer setup from sysfs and starts a short capture
> - * from the specified device, pretty printing the result after appropriate
> - * conversion.
> - *
> - * Command line parameters
> - * generic_buffer -n<device_name>  -t<trigger_name>
> - * If trigger name is not specified the program assumes you want a dataready
> - * trigger associated with the device and goes looking for it.
> - *
> - */
> -
> -#include<unistd.h>
> -#include<dirent.h>
> -#include<fcntl.h>
> -#include<stdio.h>
> -#include<errno.h>
> -#include<sys/stat.h>
> -#include<sys/dir.h>
> -#include<linux/types.h>
> -#include<string.h>
> -#include<poll.h>
> -#include<endian.h>
> -#include "iio_utils.h"
> -
> -/**
> - * size_from_channelarray() - calculate the storage size of a scan
> - * @channels: the channel info array
> - * @num_channels: size of the channel info array
> - *
> - * Has the side effect of filling the channels[i].location values used
> - * in processing the buffer output.
> - **/
> -int size_from_channelarray(struct iio_channel_info *channels, int num_channels)
> -{
> -	int bytes = 0;
> -	int i = 0;
> -	while (i<  num_channels) {
> -		if (bytes % channels[i].bytes == 0)
> -			channels[i].location = bytes;
> -		else
> -			channels[i].location = bytes - bytes%channels[i].bytes
> -				+ channels[i].bytes;
> -		bytes = channels[i].location + channels[i].bytes;
> -		i++;
> -	}
> -	return bytes;
> -}
> -
> -void print2byte(int input, struct iio_channel_info *info)
> -{
> -	/* First swap if incorrect endian */
> -
> -	if (info->be)
> -		input = be16toh((uint16_t)input);
> -	else
> -		input = le16toh((uint16_t)input);
> -
> -	/* shift before conversion to avoid sign extension
> -	   of left aligned data */
> -	input = input>>  info->shift;
> -	if (info->is_signed) {
> -		int16_t val = input;
> -		val&= (1<<  info->bits_used) - 1;
> -		val = (int16_t)(val<<  (16 - info->bits_used))>>
> -			(16 - info->bits_used);
> -		printf("%05f  ", val,
> -		       (float)(val + info->offset)*info->scale);
> -	} else {
> -		uint16_t val = input;
> -		val&= (1<<  info->bits_used) - 1;
> -		printf("%05f ", ((float)val + info->offset)*info->scale);
> -	}
> -}
> -/**
> - * process_scan() - print out the values in SI units
> - * @data:		pointer to the start of the scan
> - * @infoarray:		information about the channels. Note
> - *  size_from_channelarray must have been called first to fill the
> - *  location offsets.
> - * @num_channels:	the number of active channels
> - **/
> -void process_scan(char *data,
> -		  struct iio_channel_info *infoarray,
> -		  int num_channels)
> -{
> -	int k;
> -	for (k = 0; k<  num_channels; k++)
> -		switch (infoarray[k].bytes) {
> -			/* only a few cases implemented so far */
> -		case 2:
> -			print2byte(*(uint16_t *)(data + infoarray[k].location),
> -				&infoarray[k]);
> -			break;
> -		case 8:
> -			if (infoarray[k].is_signed) {
> -				int64_t val = *(int64_t *)
> -					(data +
> -					 infoarray[k].location);
> -				if ((val>>  infoarray[k].bits_used)&  1)
> -					val = (val&  infoarray[k].mask) |
> -						~infoarray[k].mask;
> -				/* special case for timestamp */
> -				if (infoarray[k].scale == 1.0f&&
> -				    infoarray[k].offset == 0.0f)
> -					printf(" %lld", val);
> -				else
> -					printf("%05f ", ((float)val +
> -							 infoarray[k].offset)*
> -					       infoarray[k].scale);
> -			}
> -			break;
> -		default:
> -			break;
> -		}
> -	printf("\n");
> -}
> -
> -int main(int argc, char **argv)
> -{
> -	unsigned long num_loops = 2;
> -	unsigned long timedelay = 1000000;
> -	unsigned long buf_len = 128;
> -
> -
> -	int ret, c, i, j, toread;
> -
> -	FILE *fp_ev;
> -	int fp;
> -
> -	int num_channels;
> -	char *trigger_name = NULL, *device_name = NULL;
> -	char *dev_dir_name, *buf_dir_name;
> -
> -	int datardytrigger = 1;
> -	char *data;
> -	ssize_t read_size;
> -	int dev_num, trig_num;
> -	char *buffer_access;
> -	int scan_size;
> -	int noevents = 0;
> -	char *dummy;
> -
> -	struct iio_channel_info *infoarray;
> -
> -	while ((c = getopt(argc, argv, "l:w:c:et:n:")) != -1) {
> -		switch (c) {
> -		case 'n':
> -			device_name = optarg;
> -			break;
> -		case 't':
> -			trigger_name = optarg;
> -			datardytrigger = 0;
> -			break;
> -		case 'e':
> -			noevents = 1;
> -			break;
> -		case 'c':
> -			num_loops = strtoul(optarg,&dummy, 10);
> -			break;
> -		case 'w':
> -			timedelay = strtoul(optarg,&dummy, 10);
> -			break;
> -		case 'l':
> -			buf_len = strtoul(optarg,&dummy, 10);
> -			break;
> -		case '?':
> -			return -1;
> -		}
> -	}
> -
> -	if (device_name == NULL)
> -		return -1;
> -
> -	/* Find the device requested */
> -	dev_num = find_type_by_name(device_name, "iio:device");
> -	if (dev_num<  0) {
> -		printf("Failed to find the %s\n", device_name);
> -		ret = -ENODEV;
> -		goto error_ret;
> -	}
> -	printf("iio device number being used is %d\n", dev_num);
> -
> -	asprintf(&dev_dir_name, "%siio:device%d", iio_dir, dev_num);
> -	if (trigger_name == NULL) {
> -		/*
> -		 * Build the trigger name. If it is device associated it's
> -		 * name is<device_name>_dev[n] where n matches the device
> -		 * number found above
> -		 */
> -		ret = asprintf(&trigger_name,
> -			       "%s-dev%d", device_name, dev_num);
> -		if (ret<  0) {
> -			ret = -ENOMEM;
> -			goto error_ret;
> -		}
> -	}
> -
> -	/* Verify the trigger exists */
> -	trig_num = find_type_by_name(trigger_name, "trigger");
> -	if (trig_num<  0) {
> -		printf("Failed to find the trigger %s\n", trigger_name);
> -		ret = -ENODEV;
> -		goto error_free_triggername;
> -	}
> -	printf("iio trigger number being used is %d\n", trig_num);
> -
> -	/*
> -	 * Parse the files in scan_elements to identify what channels are
> -	 * present
> -	 */
> -	ret = build_channel_array(dev_dir_name,&infoarray,&num_channels);
> -	if (ret) {
> -		printf("Problem reading scan element information\n");
> -		printf("diag %s\n", dev_dir_name);
> -		goto error_free_triggername;
> -	}
> -
> -	/*
> -	 * Construct the directory name for the associated buffer.
> -	 * As we know that the lis3l02dq has only one buffer this may
> -	 * be built rather than found.
> -	 */
> -	ret = asprintf(&buf_dir_name,
> -		       "%siio:device%d/buffer", iio_dir, dev_num);
> -	if (ret<  0) {
> -		ret = -ENOMEM;
> -		goto error_free_triggername;
> -	}
> -	printf("%s %s\n", dev_dir_name, trigger_name);
> -	/* Set the device trigger to be the data rdy trigger found above */
> -	ret = write_sysfs_string_and_verify("trigger/current_trigger",
> -					dev_dir_name,
> -					trigger_name);
> -	if (ret<  0) {
> -		printf("Failed to write current_trigger file\n");
> -		goto error_free_buf_dir_name;
> -	}
> -
> -	/* Setup ring buffer parameters */
> -	ret = write_sysfs_int("length", buf_dir_name, buf_len);
> -	if (ret<  0)
> -		goto error_free_buf_dir_name;
> -
> -	/* Enable the buffer */
> -	ret = write_sysfs_int("enable", buf_dir_name, 1);
> -	if (ret<  0)
> -		goto error_free_buf_dir_name;
> -	scan_size = size_from_channelarray(infoarray, num_channels);
> -	data = malloc(scan_size*buf_len);
> -	if (!data) {
> -		ret = -ENOMEM;
> -		goto error_free_buf_dir_name;
> -	}
> -
> -	ret = asprintf(&buffer_access, "/dev/iio:device%d", dev_num);
> -	if (ret<  0) {
> -		ret = -ENOMEM;
> -		goto error_free_data;
> -	}
> -
> -	/* Attempt to open non blocking the access dev */
> -	fp = open(buffer_access, O_RDONLY | O_NONBLOCK);
> -	if (fp == -1) { /*If it isn't there make the node */
> -		printf("Failed to open %s\n", buffer_access);
> -		ret = -errno;
> -		goto error_free_buffer_access;
> -	}
> -
> -	/* Wait for events 10 times */
> -	for (j = 0; j<  num_loops; j++) {
> -		if (!noevents) {
> -			struct pollfd pfd = {
> -				.fd = fp,
> -				.events = POLLIN,
> -			};
> -
> -			poll(&pfd, 1, -1);
> -			toread = buf_len;
> -
> -		} else {
> -			usleep(timedelay);
> -			toread = 64;
> -		}
> -
> -		read_size = read(fp,
> -				 data,
> -				 toread*scan_size);
> -		if (read_size == -EAGAIN) {
> -			printf("nothing available\n");
> -			continue;
> -		}
> -		for (i = 0; i<  read_size/scan_size; i++)
> -			process_scan(data + scan_size*i,
> -				     infoarray,
> -				     num_channels);
> -	}
> -
> -	/* Stop the ring buffer */
> -	ret = write_sysfs_int("enable", buf_dir_name, 0);
> -	if (ret<  0)
> -		goto error_close_buffer_access;
> -
> -	/* Disconnect from the trigger - just write a dummy name.*/
> -	write_sysfs_string("trigger/current_trigger",
> -			dev_dir_name, "NULL");
> -
> -error_close_buffer_access:
> -	close(fp);
> -error_free_data:
> -	free(data);
> -error_free_buffer_access:
> -	free(buffer_access);
> -error_free_buf_dir_name:
> -	free(buf_dir_name);
> -error_free_triggername:
> -	if (datardytrigger)
> -		free(trigger_name);
> -error_ret:
> -	return ret;
> -}
> diff --git a/drivers/staging/iio/Documentation/iio_event_monitor.c b/drivers/staging/iio/Documentation/iio_event_monitor.c
> deleted file mode 100644
> index 2227584..0000000
> --- a/drivers/staging/iio/Documentation/iio_event_monitor.c
> +++ /dev/null
> @@ -1,241 +0,0 @@
> -/* Industrialio event test code.
> - *
> - * Copyright (c) 2011-2012 Lars-Peter Clausen<lars@metafoo.de>
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of the GNU General Public License version 2 as published by
> - * the Free Software Foundation.
> - *
> - * This program is primarily intended as an example application.
> - * Reads the current buffer setup from sysfs and starts a short capture
> - * from the specified device, pretty printing the result after appropriate
> - * conversion.
> - *
> - * Usage:
> - *	iio_event_monitor<device_name>
> - *
> - */
> -
> -#define _GNU_SOURCE
> -
> -#include<unistd.h>
> -#include<stdbool.h>
> -#include<stdio.h>
> -#include<errno.h>
> -#include<string.h>
> -#include<poll.h>
> -#include<fcntl.h>
> -#include<sys/ioctl.h>
> -#include "iio_utils.h"
> -#include<linux/iio/events.h>
> -
> -static const char * const iio_chan_type_name_spec[] = {
> -	[IIO_VOLTAGE] = "voltage",
> -	[IIO_CURRENT] = "current",
> -	[IIO_POWER] = "power",
> -	[IIO_ACCEL] = "accel",
> -	[IIO_ANGL_VEL] = "anglvel",
> -	[IIO_MAGN] = "magn",
> -	[IIO_LIGHT] = "illuminance",
> -	[IIO_INTENSITY] = "intensity",
> -	[IIO_PROXIMITY] = "proximity",
> -	[IIO_TEMP] = "temp",
> -	[IIO_INCLI] = "incli",
> -	[IIO_ROT] = "rot",
> -	[IIO_ANGL] = "angl",
> -	[IIO_TIMESTAMP] = "timestamp",
> -	[IIO_CAPACITANCE] = "capacitance",
> -};
> -
> -static const char * const iio_ev_type_text[] = {
> -	[IIO_EV_TYPE_THRESH] = "thresh",
> -	[IIO_EV_TYPE_MAG] = "mag",
> -	[IIO_EV_TYPE_ROC] = "roc",
> -	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
> -	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
> -};
> -
> -static const char * const iio_ev_dir_text[] = {
> -	[IIO_EV_DIR_EITHER] = "either",
> -	[IIO_EV_DIR_RISING] = "rising",
> -	[IIO_EV_DIR_FALLING] = "falling"
> -};
> -
> -static const char * const iio_modifier_names[] = {
> -	[IIO_MOD_X] = "x",
> -	[IIO_MOD_Y] = "y",
> -	[IIO_MOD_Z] = "z",
> -	[IIO_MOD_LIGHT_BOTH] = "both",
> -	[IIO_MOD_LIGHT_IR] = "ir",
> -};
> -
> -static bool event_is_known(struct iio_event_data *event)
> -{
> -	enum iio_chan_type type = IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event->id);
> -	enum iio_modifier mod = IIO_EVENT_CODE_EXTRACT_MODIFIER(event->id);
> -	enum iio_event_type ev_type = IIO_EVENT_CODE_EXTRACT_TYPE(event->id);
> -	enum iio_event_direction dir = IIO_EVENT_CODE_EXTRACT_DIR(event->id);
> -
> -	switch (type) {
> -	case IIO_VOLTAGE:
> -	case IIO_CURRENT:
> -	case IIO_POWER:
> -	case IIO_ACCEL:
> -	case IIO_ANGL_VEL:
> -	case IIO_MAGN:
> -	case IIO_LIGHT:
> -	case IIO_INTENSITY:
> -	case IIO_PROXIMITY:
> -	case IIO_TEMP:
> -	case IIO_INCLI:
> -	case IIO_ROT:
> -	case IIO_ANGL:
> -	case IIO_TIMESTAMP:
> -	case IIO_CAPACITANCE:
> -		break;
> -	default:
> -		return false;
> -	}
> -
> -	switch (mod) {
> -	case IIO_NO_MOD:
> -	case IIO_MOD_X:
> -	case IIO_MOD_Y:
> -	case IIO_MOD_Z:
> -	case IIO_MOD_LIGHT_BOTH:
> -	case IIO_MOD_LIGHT_IR:
> -		break;
> -	default:
> -		return false;
> -	}
> -
> -	switch (ev_type) {
> -	case IIO_EV_TYPE_THRESH:
> -	case IIO_EV_TYPE_MAG:
> -	case IIO_EV_TYPE_ROC:
> -	case IIO_EV_TYPE_THRESH_ADAPTIVE:
> -	case IIO_EV_TYPE_MAG_ADAPTIVE:
> -		break;
> -	default:
> -		return false;
> -	}
> -
> -	switch (dir) {
> -	case IIO_EV_DIR_EITHER:
> -	case IIO_EV_DIR_RISING:
> -	case IIO_EV_DIR_FALLING:
> -		break;
> -	default:
> -		return false;
> -	}
> -
> -	return true;
> -}
> -
> -static void print_event(struct iio_event_data *event)
> -{
> -	enum iio_chan_type type = IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event->id);
> -	enum iio_modifier mod = IIO_EVENT_CODE_EXTRACT_MODIFIER(event->id);
> -	enum iio_event_type ev_type = IIO_EVENT_CODE_EXTRACT_TYPE(event->id);
> -	enum iio_event_direction dir = IIO_EVENT_CODE_EXTRACT_DIR(event->id);
> -	int chan = IIO_EVENT_CODE_EXTRACT_CHAN(event->id);
> -	int chan2 = IIO_EVENT_CODE_EXTRACT_CHAN2(event->id);
> -	bool diff = IIO_EVENT_CODE_EXTRACT_DIFF(event->id);
> -
> -	if (!event_is_known(event)) {
> -		printf("Unknown event: time: %lld, id: %llx\n",
> -				event->timestamp, event->id);
> -		return;
> -	}
> -
> -	printf("Event: time: %lld, ", event->timestamp);
> -
> -	if (mod != IIO_NO_MOD) {
> -		printf("type: %s(%s), ",
> -			iio_chan_type_name_spec[type],
> -			iio_modifier_names[mod]);
> -	} else {
> -		printf("type: %s, ",
> -			iio_chan_type_name_spec[type]);
> -	}
> -
> -	if (diff&&  chan>= 0&&  chan2>= 0)
> -		printf("channel: %d-%d, ", chan, chan2);
> -	else if (chan>= 0)
> -		printf("channel: %d, ", chan);
> -
> -	printf("evtype: %s, direction: %s\n",
> -		iio_ev_type_text[ev_type],
> -		iio_ev_dir_text[dir]);
> -}
> -
> -int main(int argc, char **argv)
> -{
> -	struct iio_event_data event;
> -	const char *device_name;
> -	char *chrdev_name;
> -	int ret;
> -	int dev_num;
> -	int fd, event_fd;
> -
> -	if (argc<= 1) {
> -		printf("Usage: %s<device_name>\n", argv[0]);
> -		return -1;
> -	}
> -
> -	device_name = argv[1];
> -
> -	dev_num = find_type_by_name(device_name, "iio:device");
> -	if (dev_num>= 0) {
> -		printf("Found IIO device with name %s with device number %d\n",
> -			device_name, dev_num);
> -		ret = asprintf(&chrdev_name, "/dev/iio:device%d", dev_num);
> -		if (ret<  0) {
> -			ret = -ENOMEM;
> -			goto error_ret;
> -		}
> -	} else {
> -		/* If we can't find a IIO device by name assume device_name is a
> -		   IIO chrdev */
> -		chrdev_name = strdup(device_name);
> -	}
> -
> -	fd = open(chrdev_name, 0);
> -	if (fd == -1) {
> -		fprintf(stdout, "Failed to open %s\n", chrdev_name);
> -		ret = -errno;
> -		goto error_free_chrdev_name;
> -	}
> -
> -	ret = ioctl(fd, IIO_GET_EVENT_FD_IOCTL,&event_fd);
> -
> -	close(fd);
> -
> -	if (ret == -1 || event_fd == -1) {
> -		fprintf(stdout, "Failed to retrieve event fd\n");
> -		ret = -errno;
> -		goto error_free_chrdev_name;
> -	}
> -
> -	while (true) {
> -		ret = read(event_fd,&event, sizeof(event));
> -		if (ret == -1) {
> -			if (errno == EAGAIN) {
> -				printf("nothing available\n");
> -				continue;
> -			} else {
> -				perror("Failed to read event from device");
> -				ret = -errno;
> -				break;
> -			}
> -		}
> -
> -		print_event(&event);
> -	}
> -
> -	close(event_fd);
> -error_free_chrdev_name:
> -	free(chrdev_name);
> -error_ret:
> -	return ret;
> -}
> diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
> deleted file mode 100644
> index 6f3a392..0000000
> --- a/drivers/staging/iio/Documentation/iio_utils.h
> +++ /dev/null
> @@ -1,639 +0,0 @@
> -/* IIO - useful set of util functionality
> - *
> - * Copyright (c) 2008 Jonathan Cameron
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of the GNU General Public License version 2 as published by
> - * the Free Software Foundation.
> - */
> -
> -/* Made up value to limit allocation sizes */
> -#include<string.h>
> -#include<stdlib.h>
> -#include<ctype.h>
> -#include<stdio.h>
> -#include<stdint.h>
> -#include<dirent.h>
> -
> -#define IIO_MAX_NAME_LENGTH 30
> -
> -#define FORMAT_SCAN_ELEMENTS_DIR "%s/scan_elements"
> -#define FORMAT_TYPE_FILE "%s_type"
> -
> -const char *iio_dir = "/sys/bus/iio/devices/";
> -
> -/**
> - * iioutils_break_up_name() - extract generic name from full channel name
> - * @full_name: the full channel name
> - * @generic_name: the output generic channel name
> - **/
> -static int iioutils_break_up_name(const char *full_name,
> -				  char **generic_name)
> -{
> -	char *current;
> -	char *w, *r;
> -	char *working;
> -	current = strdup(full_name);
> -	working = strtok(current, "_\0");
> -	w = working;
> -	r = working;
> -
> -	while (*r != '\0') {
> -		if (!isdigit(*r)) {
> -			*w = *r;
> -			w++;
> -		}
> -		r++;
> -	}
> -	*w = '\0';
> -	*generic_name = strdup(working);
> -	free(current);
> -
> -	return 0;
> -}
> -
> -/**
> - * struct iio_channel_info - information about a given channel
> - * @name: channel name
> - * @generic_name: general name for channel type
> - * @scale: scale factor to be applied for conversion to si units
> - * @offset: offset to be applied for conversion to si units
> - * @index: the channel index in the buffer output
> - * @bytes: number of bytes occupied in buffer output
> - * @mask: a bit mask for the raw output
> - * @is_signed: is the raw value stored signed
> - * @enabled: is this channel enabled
> - **/
> -struct iio_channel_info {
> -	char *name;
> -	char *generic_name;
> -	float scale;
> -	float offset;
> -	unsigned index;
> -	unsigned bytes;
> -	unsigned bits_used;
> -	unsigned shift;
> -	uint64_t mask;
> -	unsigned be;
> -	unsigned is_signed;
> -	unsigned enabled;
> -	unsigned location;
> -};
> -
> -/**
> - * iioutils_get_type() - find and process _type attribute data
> - * @is_signed: output whether channel is signed
> - * @bytes: output how many bytes the channel storage occupies
> - * @mask: output a bit mask for the raw data
> - * @be: big endian
> - * @device_dir: the iio device directory
> - * @name: the channel name
> - * @generic_name: the channel type name
> - **/
> -inline int iioutils_get_type(unsigned *is_signed,
> -			     unsigned *bytes,
> -			     unsigned *bits_used,
> -			     unsigned *shift,
> -			     uint64_t *mask,
> -			     unsigned *be,
> -			     const char *device_dir,
> -			     const char *name,
> -			     const char *generic_name)
> -{
> -	FILE *sysfsfp;
> -	int ret;
> -	DIR *dp;
> -	char *scan_el_dir, *builtname, *builtname_generic, *filename = 0;
> -	char signchar, endianchar;
> -	unsigned padint;
> -	const struct dirent *ent;
> -
> -	ret = asprintf(&scan_el_dir, FORMAT_SCAN_ELEMENTS_DIR, device_dir);
> -	if (ret<  0) {
> -		ret = -ENOMEM;
> -		goto error_ret;
> -	}
> -	ret = asprintf(&builtname, FORMAT_TYPE_FILE, name);
> -	if (ret<  0) {
> -		ret = -ENOMEM;
> -		goto error_free_scan_el_dir;
> -	}
> -	ret = asprintf(&builtname_generic, FORMAT_TYPE_FILE, generic_name);
> -	if (ret<  0) {
> -		ret = -ENOMEM;
> -		goto error_free_builtname;
> -	}
> -
> -	dp = opendir(scan_el_dir);
> -	if (dp == NULL) {
> -		ret = -errno;
> -		goto error_free_builtname_generic;
> -	}
> -	while (ent = readdir(dp), ent != NULL)
> -		/*
> -		 * Do we allow devices to override a generic name with
> -		 * a specific one?
> -		 */
> -		if ((strcmp(builtname, ent->d_name) == 0) ||
> -		    (strcmp(builtname_generic, ent->d_name) == 0)) {
> -			ret = asprintf(&filename,
> -				       "%s/%s", scan_el_dir, ent->d_name);
> -			if (ret<  0) {
> -				ret = -ENOMEM;
> -				goto error_closedir;
> -			}
> -			sysfsfp = fopen(filename, "r");
> -			if (sysfsfp == NULL) {
> -				printf("failed to open %s\n", filename);
> -				ret = -errno;
> -				goto error_free_filename;
> -			}
> -
> -			ret = fscanf(sysfsfp,
> -				     "%ce:%c%u/%u>>%u",
> -				&endianchar,
> -				&signchar,
> -				     bits_used,
> -				&padint, shift);
> -			if (ret<  0) {
> -				printf("failed to pass scan type description\n");
> -				return ret;
> -			}
> -			*be = (endianchar == 'b');
> -			*bytes = padint / 8;
> -			if (*bits_used == 64)
> -				*mask = ~0;
> -			else
> -				*mask = (1<<  *bits_used) - 1;
> -			if (signchar == 's')
> -				*is_signed = 1;
> -			else
> -				*is_signed = 0;
> -			fclose(sysfsfp);
> -			free(filename);
> -
> -			filename = 0;
> -		}
> -error_free_filename:
> -	if (filename)
> -		free(filename);
> -error_closedir:
> -	closedir(dp);
> -error_free_builtname_generic:
> -	free(builtname_generic);
> -error_free_builtname:
> -	free(builtname);
> -error_free_scan_el_dir:
> -	free(scan_el_dir);
> -error_ret:
> -	return ret;
> -}
> -
> -inline int iioutils_get_param_float(float *output,
> -				    const char *param_name,
> -				    const char *device_dir,
> -				    const char *name,
> -				    const char *generic_name)
> -{
> -	FILE *sysfsfp;
> -	int ret;
> -	DIR *dp;
> -	char *builtname, *builtname_generic;
> -	char *filename = NULL;
> -	const struct dirent *ent;
> -
> -	ret = asprintf(&builtname, "%s_%s", name, param_name);
> -	if (ret<  0) {
> -		ret = -ENOMEM;
> -		goto error_ret;
> -	}
> -	ret = asprintf(&builtname_generic,
> -		       "%s_%s", generic_name, param_name);
> -	if (ret<  0) {
> -		ret = -ENOMEM;
> -		goto error_free_builtname;
> -	}
> -	dp = opendir(device_dir);
> -	if (dp == NULL) {
> -		ret = -errno;
> -		goto error_free_builtname_generic;
> -	}
> -	while (ent = readdir(dp), ent != NULL)
> -		if ((strcmp(builtname, ent->d_name) == 0) ||
> -		    (strcmp(builtname_generic, ent->d_name) == 0)) {
> -			ret = asprintf(&filename,
> -				       "%s/%s", device_dir, ent->d_name);
> -			if (ret<  0) {
> -				ret = -ENOMEM;
> -				goto error_closedir;
> -			}
> -			sysfsfp = fopen(filename, "r");
> -			if (!sysfsfp) {
> -				ret = -errno;
> -				goto error_free_filename;
> -			}
> -			fscanf(sysfsfp, "%f", output);
> -			break;
> -		}
> -error_free_filename:
> -	if (filename)
> -		free(filename);
> -error_closedir:
> -	closedir(dp);
> -error_free_builtname_generic:
> -	free(builtname_generic);
> -error_free_builtname:
> -	free(builtname);
> -error_ret:
> -	return ret;
> -}
> -
> -/**
> - * bsort_channel_array_by_index() - reorder so that the array is in index order
> - *
> - **/
> -
> -inline void bsort_channel_array_by_index(struct iio_channel_info **ci_array,
> -					 int cnt)
> -{
> -
> -	struct iio_channel_info temp;
> -	int x, y;
> -
> -	for (x = 0; x<  cnt; x++)
> -		for (y = 0; y<  (cnt - 1); y++)
> -			if ((*ci_array)[y].index>  (*ci_array)[y+1].index) {
> -				temp = (*ci_array)[y + 1];
> -				(*ci_array)[y + 1] = (*ci_array)[y];
> -				(*ci_array)[y] = temp;
> -			}
> -}
> -
> -/**
> - * build_channel_array() - function to figure out what channels are present
> - * @device_dir: the IIO device directory in sysfs
> - * @
> - **/
> -inline int build_channel_array(const char *device_dir,
> -			      struct iio_channel_info **ci_array,
> -			      int *counter)
> -{
> -	DIR *dp;
> -	FILE *sysfsfp;
> -	int count, temp, i;
> -	struct iio_channel_info *current;
> -	int ret;
> -	const struct dirent *ent;
> -	char *scan_el_dir;
> -	char *filename;
> -
> -	*counter = 0;
> -	ret = asprintf(&scan_el_dir, FORMAT_SCAN_ELEMENTS_DIR, device_dir);
> -	if (ret<  0) {
> -		ret = -ENOMEM;
> -		goto error_ret;
> -	}
> -	dp = opendir(scan_el_dir);
> -	if (dp == NULL) {
> -		ret = -errno;
> -		goto error_free_name;
> -	}
> -	while (ent = readdir(dp), ent != NULL)
> -		if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
> -			   "_en") == 0) {
> -			ret = asprintf(&filename,
> -				       "%s/%s", scan_el_dir, ent->d_name);
> -			if (ret<  0) {
> -				ret = -ENOMEM;
> -				goto error_close_dir;
> -			}
> -			sysfsfp = fopen(filename, "r");
> -			if (sysfsfp == NULL) {
> -				ret = -errno;
> -				free(filename);
> -				goto error_close_dir;
> -			}
> -			fscanf(sysfsfp, "%u",&ret);
> -			if (ret == 1)
> -				(*counter)++;
> -			fclose(sysfsfp);
> -			free(filename);
> -		}
> -	*ci_array = malloc(sizeof(**ci_array) * (*counter));
> -	if (*ci_array == NULL) {
> -		ret = -ENOMEM;
> -		goto error_close_dir;
> -	}
> -	seekdir(dp, 0);
> -	count = 0;
> -	while (ent = readdir(dp), ent != NULL) {
> -		if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
> -			   "_en") == 0) {
> -			current =&(*ci_array)[count++];
> -			ret = asprintf(&filename,
> -				       "%s/%s", scan_el_dir, ent->d_name);
> -			if (ret<  0) {
> -				ret = -ENOMEM;
> -				/* decrement count to avoid freeing name */
> -				count--;
> -				goto error_cleanup_array;
> -			}
> -			sysfsfp = fopen(filename, "r");
> -			if (sysfsfp == NULL) {
> -				free(filename);
> -				ret = -errno;
> -				goto error_cleanup_array;
> -			}
> -			fscanf(sysfsfp, "%u",&current->enabled);
> -			fclose(sysfsfp);
> -
> -			if (!current->enabled) {
> -				free(filename);
> -				count--;
> -				continue;
> -			}
> -
> -			current->scale = 1.0;
> -			current->offset = 0;
> -			current->name = strndup(ent->d_name,
> -						strlen(ent->d_name) -
> -						strlen("_en"));
> -			if (current->name == NULL) {
> -				free(filename);
> -				ret = -ENOMEM;
> -				goto error_cleanup_array;
> -			}
> -			/* Get the generic and specific name elements */
> -			ret = iioutils_break_up_name(current->name,
> -						&current->generic_name);
> -			if (ret) {
> -				free(filename);
> -				goto error_cleanup_array;
> -			}
> -			ret = asprintf(&filename,
> -				       "%s/%s_index",
> -				       scan_el_dir,
> -				       current->name);
> -			if (ret<  0) {
> -				free(filename);
> -				ret = -ENOMEM;
> -				goto error_cleanup_array;
> -			}
> -			sysfsfp = fopen(filename, "r");
> -			fscanf(sysfsfp, "%u",&current->index);
> -			fclose(sysfsfp);
> -			free(filename);
> -			/* Find the scale */
> -			ret = iioutils_get_param_float(&current->scale,
> -						       "scale",
> -						       device_dir,
> -						       current->name,
> -						       current->generic_name);
> -			if (ret<  0)
> -				goto error_cleanup_array;
> -			ret = iioutils_get_param_float(&current->offset,
> -						       "offset",
> -						       device_dir,
> -						       current->name,
> -						       current->generic_name);
> -			if (ret<  0)
> -				goto error_cleanup_array;
> -			ret = iioutils_get_type(&current->is_signed,
> -						&current->bytes,
> -						&current->bits_used,
> -						&current->shift,
> -						&current->mask,
> -						&current->be,
> -						device_dir,
> -						current->name,
> -						current->generic_name);
> -		}
> -	}
> -
> -	closedir(dp);
> -	/* reorder so that the array is in index order */
> -	bsort_channel_array_by_index(ci_array, *counter);
> -
> -	return 0;
> -
> -error_cleanup_array:
> -	for (i = count - 1;  i>= 0; i--)
> -		free((*ci_array)[i].name);
> -	free(*ci_array);
> -error_close_dir:
> -	closedir(dp);
> -error_free_name:
> -	free(scan_el_dir);
> -error_ret:
> -	return ret;
> -}
> -
> -/**
> - * find_type_by_name() - function to match top level types by name
> - * @name: top level type instance name
> - * @type: the type of top level instance being sort
> - *
> - * Typical types this is used for are device and trigger.
> - **/
> -inline int find_type_by_name(const char *name, const char *type)
> -{
> -	const struct dirent *ent;
> -	int number, numstrlen;
> -
> -	FILE *nameFile;
> -	DIR *dp;
> -	char thisname[IIO_MAX_NAME_LENGTH];
> -	char *filename;
> -
> -	dp = opendir(iio_dir);
> -	if (dp == NULL) {
> -		printf("No industrialio devices available");
> -		return -ENODEV;
> -	}
> -
> -	while (ent = readdir(dp), ent != NULL) {
> -		if (strcmp(ent->d_name, ".") != 0&&
> -			strcmp(ent->d_name, "..") != 0&&
> -			strlen(ent->d_name)>  strlen(type)&&
> -			strncmp(ent->d_name, type, strlen(type)) == 0) {
> -			numstrlen = sscanf(ent->d_name + strlen(type),
> -					   "%d",
> -					&number);
> -			/* verify the next character is not a colon */
> -			if (strncmp(ent->d_name + strlen(type) + numstrlen,
> -					":",
> -					1) != 0) {
> -				filename = malloc(strlen(iio_dir)
> -						+ strlen(type)
> -						+ numstrlen
> -						+ 6);
> -				if (filename == NULL)
> -					return -ENOMEM;
> -				sprintf(filename, "%s%s%d/name",
> -					iio_dir,
> -					type,
> -					number);
> -				nameFile = fopen(filename, "r");
> -				if (!nameFile)
> -					continue;
> -				free(filename);
> -				fscanf(nameFile, "%s", thisname);
> -				if (strcmp(name, thisname) == 0)
> -					return number;
> -				fclose(nameFile);
> -			}
> -		}
> -	}
> -	return -ENODEV;
> -}
> -
> -inline int _write_sysfs_int(char *filename, char *basedir, int val, int verify)
> -{
> -	int ret;
> -	FILE *sysfsfp;
> -	int test;
> -	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
> -	if (temp == NULL)
> -		return -ENOMEM;
> -	sprintf(temp, "%s/%s", basedir, filename);
> -	sysfsfp = fopen(temp, "w");
> -	if (sysfsfp == NULL) {
> -		printf("failed to open %s\n", temp);
> -		ret = -errno;
> -		goto error_free;
> -	}
> -	fprintf(sysfsfp, "%d", val);
> -	fclose(sysfsfp);
> -	if (verify) {
> -		sysfsfp = fopen(temp, "r");
> -		if (sysfsfp == NULL) {
> -			printf("failed to open %s\n", temp);
> -			ret = -errno;
> -			goto error_free;
> -		}
> -		fscanf(sysfsfp, "%d",&test);
> -		if (test != val) {
> -			printf("Possible failure in int write %d to %s%s\n",
> -				val,
> -				basedir,
> -				filename);
> -			ret = -1;
> -		}
> -	}
> -error_free:
> -	free(temp);
> -	return ret;
> -}
> -
> -int write_sysfs_int(char *filename, char *basedir, int val)
> -{
> -	return _write_sysfs_int(filename, basedir, val, 0);
> -}
> -
> -int write_sysfs_int_and_verify(char *filename, char *basedir, int val)
> -{
> -	return _write_sysfs_int(filename, basedir, val, 1);
> -}
> -
> -int _write_sysfs_string(char *filename, char *basedir, char *val, int verify)
> -{
> -	int ret = 0;
> -	FILE  *sysfsfp;
> -	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
> -	if (temp == NULL) {
> -		printf("Memory allocation failed\n");
> -		return -ENOMEM;
> -	}
> -	sprintf(temp, "%s/%s", basedir, filename);
> -	sysfsfp = fopen(temp, "w");
> -	if (sysfsfp == NULL) {
> -		printf("Could not open %s\n", temp);
> -		ret = -errno;
> -		goto error_free;
> -	}
> -	fprintf(sysfsfp, "%s", val);
> -	fclose(sysfsfp);
> -	if (verify) {
> -		sysfsfp = fopen(temp, "r");
> -		if (sysfsfp == NULL) {
> -			printf("could not open file to verify\n");
> -			ret = -errno;
> -			goto error_free;
> -		}
> -		fscanf(sysfsfp, "%s", temp);
> -		if (strcmp(temp, val) != 0) {
> -			printf("Possible failure in string write of %s "
> -				"Should be %s "
> -				"written to %s\%s\n",
> -				temp,
> -				val,
> -				basedir,
> -				filename);
> -			ret = -1;
> -		}
> -	}
> -error_free:
> -	free(temp);
> -
> -	return ret;
> -}
> -
> -/**
> - * write_sysfs_string_and_verify() - string write, readback and verify
> - * @filename: name of file to write to
> - * @basedir: the sysfs directory in which the file is to be found
> - * @val: the string to write
> - **/
> -int write_sysfs_string_and_verify(char *filename, char *basedir, char *val)
> -{
> -	return _write_sysfs_string(filename, basedir, val, 1);
> -}
> -
> -int write_sysfs_string(char *filename, char *basedir, char *val)
> -{
> -	return _write_sysfs_string(filename, basedir, val, 0);
> -}
> -
> -int read_sysfs_posint(char *filename, char *basedir)
> -{
> -	int ret;
> -	FILE  *sysfsfp;
> -	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
> -	if (temp == NULL) {
> -		printf("Memory allocation failed");
> -		return -ENOMEM;
> -	}
> -	sprintf(temp, "%s/%s", basedir, filename);
> -	sysfsfp = fopen(temp, "r");
> -	if (sysfsfp == NULL) {
> -		ret = -errno;
> -		goto error_free;
> -	}
> -	fscanf(sysfsfp, "%d\n",&ret);
> -	fclose(sysfsfp);
> -error_free:
> -	free(temp);
> -	return ret;
> -}
> -
> -int read_sysfs_float(char *filename, char *basedir, float *val)
> -{
> -	float ret = 0;
> -	FILE  *sysfsfp;
> -	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
> -	if (temp == NULL) {
> -		printf("Memory allocation failed");
> -		return -ENOMEM;
> -	}
> -	sprintf(temp, "%s/%s", basedir, filename);
> -	sysfsfp = fopen(temp, "r");
> -	if (sysfsfp == NULL) {
> -		ret = -errno;
> -		goto error_free;
> -	}
> -	fscanf(sysfsfp, "%f\n", val);
> -	fclose(sysfsfp);
> -error_free:
> -	free(temp);
> -	return ret;
> -}
> diff --git a/drivers/staging/iio/Documentation/inkernel.txt b/drivers/staging/iio/Documentation/inkernel.txt
> deleted file mode 100644
> index a05823e..0000000
> --- a/drivers/staging/iio/Documentation/inkernel.txt
> +++ /dev/null
> @@ -1,58 +0,0 @@
> -Industrial I/O Subsystem in kernel consumers.
> -
> -The IIO subsystem can act as a layer under other elements of the kernel
> -providing a means of obtaining ADC type readings or of driving DAC type
> -signals.  The functionality supported will grow as use cases arise.
> -
> -Describing the channel mapping (iio/machine.h)
> -
> -Channel associations are described using:
> -
> -struct iio_map {
> -	const char *adc_channel_label;
> -	const char *consumer_dev_name;
> -	const char *consumer_channel;
> -};
> -
> -adc_channel_label identifies the channel on the IIO device by being
> -matched against the datasheet_name field of the iio_chan_spec.
> -
> -consumer_dev_name allows identification of the consumer device.
> -This are then used to find the channel mapping from the consumer device (see
> -below).
> -
> -Finally consumer_channel is a string identifying the channel to the consumer.
> -(Perhaps 'battery_voltage' or similar).
> -
> -An array of these structures is then passed to the IIO driver.
> -
> -Supporting in kernel interfaces in the driver (driver.h)
> -
> -The driver must provide datasheet_name values for its channels and
> -must pass the iio_map structures and a pointer to its own iio_dev structure
> - on to the core via a call to iio_map_array_register.  On removal,
> -iio_map_array_unregister reverses this process.
> -
> -The result of this is that the IIO core now has all the information needed
> -to associate a given channel with the consumer requesting it.
> -
> -Acting as an IIO consumer (consumer.h)
> -
> -The consumer first has to obtain an iio_channel structure from the core
> -by calling iio_channel_get().  The correct channel is identified by:
> -
> -* matching dev or dev_name against consumer_dev and consumer_dev_name
> -* matching consumer_channel against consumer_channel in the map
> -
> -There are then a number of functions that can be used to get information
> -about this channel such as it's current reading.
> -
> -e.g.
> -iio_st_read_channel_raw() - get a reading
> -iio_st_read_channel_type() - get the type of channel
> -
> -There is also provision for retrieving all of the channels associated
> -with a given consumer.  This is useful for generic drivers such as
> -iio_hwmon where the number and naming of channels is not known by the
> -consumer driver.  To do this, use iio_st_channel_get_all.
> -
> diff --git a/drivers/staging/iio/Documentation/overview.txt b/drivers/staging/iio/Documentation/overview.txt
> deleted file mode 100644
> index afc39ec..0000000
> --- a/drivers/staging/iio/Documentation/overview.txt
> +++ /dev/null
> @@ -1,57 +0,0 @@
> -Overview of IIO
> -
> -The Industrial I/O subsystem is intended to provide support for devices
> -that in some sense are analog to digital converters (ADCs). As many
> -actual devices combine some ADCs with digital to analog converters
> -(DACs) that functionality is also supported.
> -
> -The aim is to fill the gap between the somewhat similar hwmon and
> -input subsystems.  Hwmon is very much directed at low sample rate
> -sensors used in applications such as fan speed control and temperature
> -measurement.  Input is, as it's name suggests focused on input
> -devices. In some cases there is considerable overlap between these and
> -IIO.
> -
> -A typical device falling into this category would be connected via SPI
> -or I2C.
> -
> -Functionality of IIO
> -
> -* Basic device registration and handling. This is very similar to
> -hwmon with simple polled access to device channels via sysfs.
> -
> -* Event chrdevs.  These are similar to input in that they provide a
> -route to user space for hardware triggered events. Such events include
> -threshold detectors, free-fall detectors and more complex action
> -detection.  The events themselves are currently very simple with
> -merely an event code and a timestamp.  Any data associated with the
> -event must be accessed via polling.
> -
> -Note: A given device may have one or more event channel.  These events are
> -turned on or off (if possible) via sysfs interfaces.
> -
> -* Hardware buffer support.  Some recent sensors have included
> -fifo / ring buffers on the sensor chip.  These greatly reduce the load
> -on the host CPU by buffering relatively large numbers of data samples
> -based on an internal sampling clock. Examples include VTI SCA3000
> -series and Analog Device ADXL345 accelerometers.  Each buffer supports
> -polling to establish when data is available.
> -
> -* Trigger and software buffer support. In many data analysis
> -applications it it useful to be able to capture data based on some
> -external signal (trigger).  These triggers might be a data ready
> -signal, a gpio line connected to some external system or an on
> -processor periodic interrupt.  A single trigger may initialize data
> -capture or reading from a number of sensors.  These triggers are
> -used in IIO to fill software buffers acting in a very similar
> -fashion to the hardware buffers described above.
> -
> -Other documentation:
> -
> -device.txt - elements of a typical device driver.
> -
> -trigger.txt - elements of a typical trigger driver.
> -
> -ring.txt - additional elements required for buffer support.
> -
> -sysfs-bus-iio - abi documentation file.
> diff --git a/drivers/staging/iio/Documentation/ring.txt b/drivers/staging/iio/Documentation/ring.txt
> deleted file mode 100644
> index e338077..0000000
> --- a/drivers/staging/iio/Documentation/ring.txt
> +++ /dev/null
> @@ -1,47 +0,0 @@
> -Buffer support within IIO
> -
> -This document is intended as a general overview of the functionality
> -a buffer may supply and how it is specified within IIO.  For more
> -specific information on a given buffer implementation, see the
> -comments in the source code.  Note that some drivers allow buffer
> -implementation to be selected at compile time via Kconfig options.
> -
> -A given buffer implementation typically embeds a struct
> -iio_ring_buffer and it is a pointer to this that is provided to the
> -IIO core. Access to the embedding structure is typically done via
> -container_of functions.
> -
> -struct iio_ring_buffer contains a struct iio_ring_setup_ops *setup_ops
> -which in turn contains the 4 function pointers
> -(preenable, postenable, predisable and postdisable).
> -These are used to perform device specific steps on either side
> -of the core changing it's current mode to indicate that the buffer
> -is enabled or disabled (along with enabling triggering etc as appropriate).
> -
> -Also in struct iio_ring_buffer is a struct iio_ring_access_funcs.
> -The function pointers within here are used to allow the core to handle
> -as much buffer functionality as possible. Note almost all of these
> -are optional.
> -
> -store_to
> -  If possible, push data to the buffer.
> -
> -read_last
> -  If possible, get the most recent scan from the buffer (without removal).
> -  This provides polling like functionality whilst the ring buffering is in
> -  use without a separate read from the device.
> -
> -rip_first_n
> -  The primary buffer reading function. Note that it may well not return
> -  as much data as requested.
> -
> -request_update
> -  If parameters have changed that require reinitialization or configuration of
> -  the buffer this will trigger it.
> -
> -get_bytes_per_datum, set_bytes_per_datum
> -  Get/set the number of bytes for a complete scan. (All samples + timestamp)
> -
> -get_length / set_length
> -  Get/set the number of complete scans that may be held by the buffer.
> -

