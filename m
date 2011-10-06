Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935899Ab1JFWJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:09:31 -0400
Received: from icarus.com ([209.172.115.90]:36907 "EHLO icarus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935612Ab1JFWJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:09:30 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 18:09:30 EDT
Message-ID: <4E8E2569.8030301@icarus.com>
Date: Thu, 06 Oct 2011 15:02:17 -0700
From: Stephen Williams <steve@icarus.com>
Reply-To: Stephen Williams <steve@icarus.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: MODULE_LICENSE("GPL") not working for me
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------010806060403060203070306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010806060403060203070306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I have some large drivers for use in embedded arm systems, and
I want them to be GPL, because I want to use some symbols exported
as GPL, and also because I just wanna. But it is not working for
me. I've attached my Makefile. I'm building from outside the kernel
tree, but that should be OK. I'm using the following script to
actually build:

  SE0=/home/u/wing/steve/picturel/SE0

CROSS_COMPILE=/opt/CodeSourcery/Sourcery_G++_Lite/bin/arm-none-linux-gnueabi-

  export CROSS_COMPILE
  make KERNELDIR=$SE0/linux-2.6.33-quatro ARCH=arm modules

But no matter what I do, when I try to load my module, I get
errors line this:

  # insmod ./vidfor2.ko
  vidfor: module license 'unspecified' taints kernel.
  Disabling lock debugging due to kernel taint
  vidfor: Unknown symbol driver_remove_file
  vidfor: Unknown symbol driver_create_file
  insmod: can't insert './vidfor2.ko': unknown symbol in module or
invalid parameter

I have a MODULE_LICENSE("GPL"); line in the "linux.c" source file,
and the pertinent parts of the makefile are here:

  OBJ := linux.o ops.o console.o sysfs.o ident_tables.o
  LIBOBJ := vidforio.o init.o format.o video.o isr.o version.o

  ifneq ($(KERNELRELEASE),)

  EXTRA_CFLAGS += -I$(M)/../libvidforio
  obj-m += vidfor.o
  vidfor-objs := $(OBJ) $(patsubst %,../libvidforio/%,$(LIBOBJ))

  else
  [...]

What's the trick for getting the MODULE_LICENSE successfully stamped
into my generated .ko file?

I've googled the list and the internet in general, and found
as many relevant examples as I could in the kernel source, but
I'm at wit's end. I'm not subscribed, so please CC responses,
although I will check back often.

-- 
Steve Williams                "The woods are lovely, dark and deep.
steve at icarus.com           But I have promises to keep,
http://www.icarus.com         and lines to code before I sleep,
http://www.picturel.com       And lines to code before I sleep."

--------------010806060403060203070306
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Makefile"



OBJ := linux.o ops.o console.o sysfs.o ident_tables.o
LIBOBJ := vidforio.o init.o format.o video.o isr.o version.o

ifneq ($(KERNELRELEASE),)

EXTRA_CFLAGS += -I$(M)/../libvidforio
obj-m += vidfor.o
vidfor-objs := $(OBJ) $(patsubst %,../libvidforio/%,$(LIBOBJ))

else

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

version ident_tables.c:
	@echo ' /* MACHINE GENERATED -- DO NOT EDIT */' > tmp.c
	@echo 'const char vidfor_build_stamp[] =' >> tmp.c
	@echo '"'`git describe --tags --long --always --match sys-\*`'";' >> tmp.c
	@diff tmp.c ident_tables.c > /dev/null 2>&1 || (echo "updating ident_tables.c"; cp tmp.c ident_tables.c)
	@rm -f tmp.c

modules:
	$(MAKE) -C ../libvidforio version
	$(MAKE) version
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean

endif

--------------010806060403060203070306--
