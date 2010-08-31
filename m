Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0HaSPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:15:55 -0400
Received: from ppsw-31.csi.cam.ac.uk ([131.111.8.131]:55122 "EHLO
	ppsw-31.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0HaSPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:15:54 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C7D47E5.5070608@cam.ac.uk>
Date: Tue, 31 Aug 2010 19:20:21 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>	<20100829184904.GC26209@core.coreip.homeip.net>	<36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>	<20100830214025.2f9677a1@lxorguk.ukuu.org.uk>	<20100830204412.GA28711@core.coreip.homeip.net>	<AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>	<20100830214355.GB28865@core.coreip.homeip.net>	<AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>	<20100830224352.GF28865@core.coreip.homeip.net>	<20100831104446.321fd4f4@lxorguk.ukuu.org.uk>	<20100831161730.GA30947@core.coreip.homeip.net> <20100831175937.70a59a91@lxorguk.ukuu.org.uk> <4C7D43FE.8080906@jic23.retrosnub.co.uk>
In-Reply-To: <4C7D43FE.8080906@jic23.retrosnub.co.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

> 
> Anyhow, here is a code dump of a very nasty proof of concept for an IIO
> to input bridge in userspace.  If I'd known it would be this easy I'd
> have done this ages ago.  I'm away for next couple of days, so a more
> general version won't occur until next week unless someone else picks it
> up.
> 
One thing I forgot to mention.   IIO uses two different paths for what
become events in input.  The main data stream (which is predictable)
comes via the buffer interface handled here.  Threshold type events
(and all the weird and wonderful variants) come via a second chrdev
if the device supports them.  These are trivial to add to the below
and I'll put them in the generalized version (basically a second fd
and a call to select + a big translation table - which may want to
be configurable...)
> ---
> 
> /* IIO to uinput userspace bridge example for specific device.
>  *
>  * Copyright (c) 2010 Jonathan Cameron
>  * Sometime in the past Luke Casson (or at least it is on his website)
>  *
>  * This program is free software; you can redistribute it and/or modify it
>  * under the terms of the GNU General Public License version 2 as published by
>  * the Free Software Foundation.
>  *
>  * This program is to illustrate how an IIO to input bridge would more or less
>  * work.
>  * Some comments in line to say where there have been short cuts taken. Denote S:
>  */
> 
> #include <dirent.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <errno.h>
> #include <sys/stat.h>
> #include <sys/dir.h>
> #include <linux/types.h>
> #include "iio_utils.h"
> #include <linux/input.h>
> #include <linux/uinput.h>
> 
> int send_event(int fd, __u16 type, __u16 code, __s32 value)
> {
>     struct input_event event;
> 
>     memset(&event, 0, sizeof(event));
>     event.type = type;
>     event.code = code;
>     event.value = value;
> 
>     if (write(fd, &event, sizeof(event)) != sizeof(event)) {
>         fprintf(stderr, "Error on send_event");
>         return -1;
>     }
> 
>     return 0;
> }
> 
> /* S: these would need to provided as configuration so
>  * that the bridge would know which devices to bridge to input
>  */
> const char *device_name = "lis3l02dq";
> const char *trigger_name_base = "lis3l02dq-dev";
> /*
>  * S: obtain these from combination of configuration file for
>  * bridge and buffer description in sysfs for the IIO device
>  */
> const int num_vals = 3;
> /* S: not actually using the timestamp as I couldn't be bothered
>  * to check what format uinput needed
>  */
> const int scan_ts = 1;
> /* S: this is way to long as it means you only get data a couple
>  * of times a second.
>  */
> const int buf_len = 128;
> /*
>  * Obviously this would be infinite
>  */
> const int num_loops = 40;
> 
> /* S: Calculate this form sysfs params */
> int size_from_scanmode(int num_vals, int timestamp)
> {
> 	if (num_vals && timestamp)
> 		return 16;
> 	else if (timestamp)
> 		return 8;
> 	else
> 		return num_vals*2;
> }
> 
> int main(int argc, char **argv)
> {
> 	
> 	int ret;
> 	int i, j, k, toread;
> 	FILE *fp_ev;
> 	int fp;
> 
> 	char *trigger_name, *dev_dir_name, *buf_dir_name;
> 	char *data;
> 	size_t read_size;
> 	struct iio_event_data dat;
> 	int dev_num, trig_num;
> 
> 	char *buffer_access, *buffer_event;
> 	const char *iio_dir = "/sys/bus/iio/devices/";
> 	int scan_size;
> 	float gain = 1;
> 
> 	/* New uinput stuff */
> 	int fd;
> 	struct uinput_user_dev device;
> 	memset(&device, 0, sizeof device);
> 	fd=open("/dev/input/uinput", O_WRONLY);
> 	strcpy(device.name, "lis3l02dq accelerometer");
> 
> 	/* No idea what sort of bus I should use... */
> 	device.id.bustype = BUS_VIRTUAL;
> 	device.id.vendor = 1;
> 	device.id.product = 1;
> 	device.id.version = 1;
> 	for (i=0; i < ABS_MAX; i++) {
> 		device.absmax[i] = -1;
> 		device.absmin[i] = -1;
> 		device.absfuzz[i] = -1;
> 		device.absflat[i] = -1;
> 	}
> 	/* S: These can all be derived from sysfs attributes,
> 	 * though we need the format spec Manuel suggested the
> 	 * other day. Typically IIO never cares about range,
> 	 * just format.
> 	 */
> 	device.absmin[ABS_X] = -2048;
> 	device.absmax[ABS_X] = 2047;
> 	device.absfuzz[ABS_X] = 0;
> 	device.absflat[ABS_X] = 0;
> 	device.absmin[ABS_Y] = -2048;
> 	device.absmax[ABS_Y] = 2047;
> 	device.absfuzz[ABS_Y] = 0;
> 	device.absflat[ABS_Y] = 0;
> 	device.absmin[ABS_Z] = -2048;
> 	device.absmax[ABS_Z] = 2047;
> 	device.absfuzz[ABS_Z] = 0;
> 	device.absflat[ABS_Z] = 0;
> 
> 	if (write(fd, &device, sizeof(device)) != sizeof(device)) {
> 		fprintf(stderr, "error setup\n");
> 		return -1;
> 	}
> 
> 	if (ioctl(fd, UI_SET_EVBIT, EV_ABS) < 0) {
> 		fprintf(stderr, "error evbit abs\n");
> 		return -1;
> 	}
> 	
> 	for(i = REL_X; i <= REL_Z; i++)
> 		if (ioctl(fd, UI_SET_ABSBIT, i) < 0) {
> 			fprintf(stderr, "error setrelbit %d\n", i);
> 			return -1;
> 		}
> 	
> 	if (ioctl(fd, UI_DEV_CREATE) < 0) {
> 		fprintf(stderr, "error create\n");
> 		return -1;
> 	}
> 	
> 	/* Find out which iio device is the accelerometer. */
> 	dev_num = find_type_by_name(device_name, "device");
> 	if (dev_num < 0) {
> 		printf("Failed to find the %s\n", device_name);
> 		ret = -ENODEV;
> 		goto error_ret;
> 	}
> 	printf("iio device number being used is %d\n", dev_num);
> 	asprintf(&dev_dir_name, "%sdevice%d", iio_dir, dev_num);
> 
> 	/*
> 	 * Build the trigger name.
> 	 * In this case we want the lis3l02dq's data ready trigger
> 	 * for this lis3l02dq. The naming is lis3l02dq_dev[n], where
> 	 * n matches the device number found above.
> 	 */
> 	ret = asprintf(&trigger_name, "%s%d", trigger_name_base, dev_num);
> 	if (ret < 0) {
> 		ret = -ENOMEM;
> 		goto error_free_dev_dir_name;
> 	}
> 
> 	/*
> 	 * Find the trigger by name.
> 	 * This is techically unecessary here as we only need to
> 	 * refer to the trigger by name and that name is already
> 	 * known.
> 	 */
> 	trig_num = find_type_by_name(trigger_name, "trigger");
> 	if (trig_num < 0) {
> 		printf("Failed to find the %s\n", trigger_name);
> 		ret = -ENODEV;
> 		goto error_free_triggername;
> 	}
> 	printf("iio trigger number being used is %d\n", trig_num);
> 
> 	/*
> 	 * Read in the scale value - in a more generic case, first
> 	 * check for accel_scale, then the indivual channel scales
> 	 */
> 	ret = read_sysfs_float("accel_scale", dev_dir_name, &gain);
> 	if (ret)
> 		goto error_free_triggername;;
> 
> 	/*
> 	 * Construct the directory name for the associated buffer.
> 	 * As we know that the lis3l02dq has only one buffer this may
> 	 * be built rather than found.
> 	 */
> 	ret = asprintf(&buf_dir_name, "%sdevice%d:buffer0", iio_dir, dev_num);
> 	if (ret < 0) {
> 		ret = -ENOMEM;
> 		goto error_free_triggername;
> 	}
> 	/* Set the device trigger to be the data rdy trigger found above */
> 	ret = write_sysfs_string_and_verify("trigger/current_trigger",
> 					dev_dir_name,
> 					trigger_name);
> 	if (ret < 0) {
> 		printf("Failed to write current_trigger file\n");
> 		goto error_free_buf_dir_name;
> 	}
> 
> 	/* Setup ring buffer parameters */
> 	ret = write_sysfs_int("length", buf_dir_name, buf_len);
> 	if (ret < 0)
> 		goto error_free_buf_dir_name;
> 
> 	/* Enable the buffer */
> 	ret = write_sysfs_int("enable", buf_dir_name, 1);
> 	if (ret < 0)
> 		goto error_free_buf_dir_name;
> 
> 	data = malloc(size_from_scanmode(num_vals, scan_ts)*buf_len);
> 	if (!data) {
> 		ret = -ENOMEM;
> 		goto error_free_buf_dir_name;
> 	}
> 
> 	ret = asprintf(&buffer_access,
> 		       "/dev/device%d:buffer0:access0",
> 		       dev_num);
> 	if (ret < 0) {
> 		ret = -ENOMEM;
> 		goto error_free_data;
> 	}
> 
> 	ret = asprintf(&buffer_event, "/dev/device%d:buffer0:event0", dev_num);
> 	if (ret < 0) {
> 		ret = -ENOMEM;
> 		goto error_free_data;
> 	}
> 	/* Attempt to open non blocking the access dev */
> 	fp = open(buffer_access, O_RDONLY | O_NONBLOCK);
> 	if (fp == -1) { /*If it isn't there make the node */
> 		printf("Failed to open %s\n", buffer_access);
> 		ret = -errno;
> 		goto error_free_buffer_event;
> 	}
> 	/* Attempt to open the event access dev (blocking this time) */
> 	fp_ev = fopen(buffer_event, "rb");
> 	if (fp_ev == NULL) {
> 		printf("Failed to open %s\n", buffer_event);
> 		ret = -errno;
> 		goto error_close_buffer_access;
> 	}
> 
> 	/* Wait for events 10 times */
> 	for (j = 0; j < num_loops; j++) {
> 		read_size = fread(&dat, 1, sizeof(struct iio_event_data),
> 				  fp_ev);
> 		switch (dat.id) {
> 		case IIO_EVENT_CODE_RING_100_FULL:
> 			toread = buf_len;
> 			break;
> 		case IIO_EVENT_CODE_RING_75_FULL:
> 			toread = buf_len*3/4;
> 			break;
> 		case IIO_EVENT_CODE_RING_50_FULL:
> 			toread = buf_len/2;
> 			break;
> 		default:
> 			printf("Unexpecteded event code\n");
> 			continue;
> 		}
> 		read_size = read(fp,
> 				 data,
> 				 toread*size_from_scanmode(num_vals, scan_ts));
> 		if (read_size == -EAGAIN) {
> 			printf("nothing available\n");
> 			continue;
> 		}
> 		scan_size = size_from_scanmode(num_vals, scan_ts);
> 		for (i = 0; i < read_size/scan_size; i++) {
> 			
> 			/* This is the only bit I changed (rather than
> 			 * added) from the original demo code.
> 			 */
> 			__s16 val = *(__s16 *)(&data[i*scan_size + (0)*2]);
> 			send_event(fd, EV_ABS, ABS_X, val);
> 			val = *(__s16 *)(&data[i*scan_size + (1)*2]);
> 			send_event(fd, EV_ABS, ABS_Y, val);
> 			val = *(__s16 *)(&data[i*scan_size + (1)*2]);
> 			send_event(fd, EV_ABS, ABS_Z, val);
> 
> 			/* S: I'm not actually sure what this does? */
> 			send_event(fd, EV_SYN, SYN_REPORT, 0);
> 		}
> 	}
> 
> 	/* Stop the ring buffer */
> 	ret = write_sysfs_int("enable", buf_dir_name, 0);
> 	if (ret < 0)
> 		goto error_close_buffer_event;
> 
> 	/* Disconnect from the trigger - just write a dummy name.*/
> 	write_sysfs_string("trigger/current_trigger",
> 			dev_dir_name, "NULL");
> 
> error_close_buffer_event:
> 	fclose(fp_ev);
> error_close_buffer_access:
> 	close(fp);
> error_free_data:
> 	free(data);
> error_free_buffer_access:
> 	free(buffer_access);
> error_free_buffer_event:
> 	free(buffer_event);
> error_free_buf_dir_name:
> 	free(buf_dir_name);
> error_free_triggername:
> 	free(trigger_name);
> error_free_dev_dir_name:
> 	free(dev_dir_name);
> error_ret:
> 
> /* S: didn't clean up properly for the uinput stuff */
> 	close(fd);
> 	return ret;
> }
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

