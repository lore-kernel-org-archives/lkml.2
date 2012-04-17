Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2DQI2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:28:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab2DQI2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:28:43 -0400
Date: Tue, 17 Apr 2012 10:28:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtitmuss@logitech.com, ogay@logitech.com,
        jzanone@logitech.com
Subject: Re: [PATCH v5 1/1] HID: Add full support for Logitech Unifying
 receivers
In-Reply-To: <CAN+gG=EcaMrz2w-cVL-cCwi2NNVJ-NXOpOQpbjyFdCwn5+Bn+w@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1204171027220.11298@twin.jikos.cz>
References: <1316018905-4175-1-git-send-email-nlopezcasad@logitech.com> <4E77A221.1060909@t-online.de> <CAN+gG=EcaMrz2w-cVL-cCwi2NNVJ-NXOpOQpbjyFdCwn5+Bn+w@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011, Benjamin Tissoires wrote:

> Hi Richard,
> 
> here, you'll find a small C program that allows you to do a pairing of
> a new device to a receiver.
> 
> compile it with with gcc -o pairing_tool pairing_tool.c

Could this perhaps be provided into Documentation/ or samples/ somewhere? 
I don't think that Logitech themselves do ship pairing application for 
Linux, or do they?

If they don't, it'd be nice to have this at least documented somewhere, so 
that someone could write a pairing GUI.

Thanks.

> 
> --------------------------------- file pairing_tool.c
> ---------------------------------
> /*
>  * Copyright 2011 Benjamin Tissoires <benjamin.tissoires@gmail.com>
>  *
>  * This program is free software: you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation, either version 3 of the License, or
>  * (at your option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.
>  *
>  * You should have received a copy of the GNU General Public License
>  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>  */
> 
> #include <linux/input.h>
> #include <linux/hidraw.h>
> #include <sys/ioctl.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <errno.h>
> 
> #define USB_VENDOR_ID_LOGITECH			(__u32)0x046d
> #define USB_DEVICE_ID_UNIFYING_RECEIVER		(__s16)0xc52b
> #define USB_DEVICE_ID_UNIFYING_RECEIVER_2	(__s16)0xc532
> 
> int main(int argc, char **argv)
> {
> 	int fd;
> 	int res;
> 	struct hidraw_devinfo info;
> 	char magic_sequence[] = {0x10, 0xFF, 0x80, 0xB2, 0x01, 0x00, 0x00};
> 
> 	if (argc == 1) {
> 		errno = EINVAL;
> 		perror("No hidraw device given");
> 		return 1;
> 	}
> 
> 	/* Open the Device with non-blocking reads. */
> 	fd = open(argv[1], O_RDWR|O_NONBLOCK);
> 
> 	if (fd < 0) {
> 		perror("Unable to open device");
> 		return 1;
> 	}
> 
> 	/* Get Raw Info */
> 	res = ioctl(fd, HIDIOCGRAWINFO, &info);
> 	if (res < 0) {
> 		perror("error while getting info from device");
> 	} else {
> 		if (info.bustype != BUS_USB ||
> 		    info.vendor != USB_VENDOR_ID_LOGITECH ||
> 		    (info.product != USB_DEVICE_ID_UNIFYING_RECEIVER &&
> 		     info.product != USB_DEVICE_ID_UNIFYING_RECEIVER_2)) {
> 			errno = EPERM;
> 			perror("The given device is not a Logitech "
> 				"Unifying Receiver");
> 			return 1;
> 		}
> 	}
> 
> 	/* Send the magic sequence to the Device */
> 	res = write(fd, magic_sequence, sizeof(magic_sequence));
> 	if (res < 0) {
> 		printf("Error: %d\n", errno);
> 		perror("write");
> 	} else if (res == sizeof(magic_sequence)) {
> 		printf("The receiver is ready to pair a new device.\n"
> 		"Switch your device on to pair it.\n");
> 	} else {
> 		errno = ENOMEM;
> 		printf("write: %d were written instead of %ld.\n", res,
> 			sizeof(magic_sequence));
> 		perror("write");
> 	}
> 	close(fd);
> 	return 0;
> }

-- 
Jiri Kosina
SUSE Labs

