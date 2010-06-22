Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0FVTHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:07:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab0FVTHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 15:07:19 -0400
Message-ID: <4C210A07.80906@vlnb.net>
Date: Tue, 22 Jun 2010 23:07:51 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sparclinux@vger.kernel.org, simone.ricci@gmail.com,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Nick.Couchman@seakr.com, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org
Subject: Re: Error "Unknown relocation: 36" on module load on Sparc
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com>	<4C192085.2090404@vlnb.net> <20100616.133540.189696272.davem@davemloft.net>
In-Reply-To: <20100616.133540.189696272.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------090404070802070904040706"
X-Provags-ID: V01U2FsdGVkX18E3yjpktL8DiraqW9kftZaNq8GKPYb0uXOGlz
 Kx15bQLYnYcqt+3f8Vd3CRsDJMNaWAprgK1UVvakxpeIG05beB
 TR5j6f9MZWdCGgzNsTNbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090404070802070904040706
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


David Miller, on 06/17/2010 12:35 AM wrote:
> From: Vladislav Bolkhovitin <vst@vlnb.net>
> Date: Wed, 16 Jun 2010 23:05:41 +0400
> 
>> We in SCST project have a very strange problem on Sparc. Our main
>> module scst.ko, if built as a module out of the kernel tree, can't be
>> loaded and "modprobe scst" returns:
>>
>> FATAL: Error inserting scst
>> (/lib/modules/2.6.26-2-sparc64/extra/scst.ko): Invalid module format
>>
>> The following message is immediately spit out by the kernel:
>> [ 1686.676534] module scst: Unknown relocation: 36
> 
> You're building the module with incorrect compiler flags, in
> particular somehow the "-mcmodel=medlow" option is not getting passed
> into the module build and thus the wrong code model is being used to
> build the module.
> 
> There are a host of other sparc64 specific compiler options that must
> be present for a correct build as well.  The only way to get it done
> correctly is to properly inherit the option settings made by
> arch/sparc/Makefile and friends in the kernel tree.

Thank you. This gives us the direction away from the current dead end. 
We will make the needed changes in our Makefiles.

But we surprised that such platform specific compiler flags have to be 
manually maintained by out of the kernel tree modules developers. We 
thought kbuild environment doing it automatically. Particularly, 
Documentation/kbuild/modules.txt doesn't say anything about manual 
platform specific flags.

I added kbuild developers on CC and attached again our Makefile just in 
case if they would like to look at it.

Thanks,
Vlad

--------------090404070802070904040706
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Makefile"

SHELL=/bin/bash

DEV_HANDLERS_DIR = dev_handlers

ifneq ($(PATCHLEVEL),)
SCST_INC_DIR := $(SUBDIRS)/../include

obj-m := scst.o

scst-y        += scst_main.o
scst-y        += scst_targ.o
scst-y        += scst_lib.o
#scst-y        += scst_proc.o
scst-y        += scst_sysfs.o
scst-y        += scst_mem.o
scst-y        += scst_debug.o
scst-y        += scst_pres.o
obj-$(CONFIG_SCST)   += scst.o dev_handlers/

obj-$(BUILD_DEV) += $(DEV_HANDLERS_DIR)/

else
ifeq ($(KVER),)
  ifeq ($(KDIR),)
    KVER = $(shell uname -r)
    KDIR := /lib/modules/$(KVER)/build
  endif
else
  KDIR := /lib/modules/$(KVER)/build
endif

all:
	$(MAKE) -C $(KDIR) SUBDIRS=$(shell pwd) BUILD_DEV=m

scst:
	$(MAKE) -C $(KDIR) SUBDIRS=$(shell pwd) BUILD_DEV=n

MODS_VERS := $(shell ls Modules.symvers 2>/dev/null)
# It's renamed in 2.6.18
MOD_VERS := $(shell ls Module.symvers 2>/dev/null)

install: all
	-rm -f $(INSTALL_DIR)/scsi_tgt.ko
	$(MAKE) -C $(KDIR) SUBDIRS=$(shell pwd) BUILD_DEV=m \
		modules_install
	install -d $(INSTALL_DIR_H)
	install -m 644 ../include/scst.h $(INSTALL_DIR_H)
	install -m 644 ../include/scst_sgv.h $(INSTALL_DIR_H)
	install -m 644 ../include/scst_debug.h $(INSTALL_DIR_H)
	install -m 644 ../include/scst_user.h $(INSTALL_DIR_H)
	install -m 644 ../include/scst_const.h $(INSTALL_DIR_H)
ifneq ($(MODS_VERS),)
	rm -f $(INSTALL_DIR_H)/Module.symvers
	install -m 644 Modules.symvers $(INSTALL_DIR_H)
endif
ifneq ($(MOD_VERS),)
	rm -f $(INSTALL_DIR_H)/Modules.symvers
	install -m 644 Module.symvers $(INSTALL_DIR_H)
endif
	-/sbin/depmod -a $(KVER)
	mkdir -p /var/lib/scst/pr
	@echo "****************************************************************"
	@echo "*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*"
	@echo "*!!                                                          !!*"
	@echo "*!!  Now don't forget to rebuild and reinstall all your      !!*"
	@echo "*!!  target drivers, custom dev handlers and necessary user  !!*"
	@echo "*!!  space applications. Otherwise, because of the versions  !!*"
	@echo "*!!  mismatch, you could have many problems and crashes.     !!*"
	@echo "*!!  See IMPORTANT note in the \"Installation\" section of     !!*"
	@echo "*!!  SCST's README file for more info.                       !!*"
	@echo "*!!                                                          !!*"
	@echo "*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*"
	@echo "****************************************************************"

uninstall:
	cd $(DEV_HANDLERS_DIR) && $(MAKE) $@
	rm -f $(INSTALL_DIR)/scst.ko
	-rmdir $(INSTALL_DIR) 2>/dev/null
	-/sbin/depmod -a $(KVER)
	rm -rf $(INSTALL_DIR_H)
endif

ifeq ($(KVER),)
INSTALL_DIR := $(DESTDIR)/lib/modules/$(shell uname -r)/extra
else
INSTALL_DIR := $(DESTDIR)/lib/modules/$(KVER)/extra
endif
INSTALL_DIR_H := $(DESTDIR)/usr/local/include/scst

EXTRA_CFLAGS += -I$(SCST_INC_DIR) -Wextra -Wno-unused-parameter \
		-Wno-missing-field-initializers

#EXTRA_CFLAGS += -DCONFIG_SCST_STRICT_SERIALIZING

EXTRA_CFLAGS += -DCONFIG_SCST_EXTRACHECKS

#EXTRA_CFLAGS += -DCONFIG_SCST_USE_EXPECTED_VALUES
#EXTRA_CFLAGS += -DCONFIG_SCST_TEST_IO_IN_SIRQ
#EXTRA_CFLAGS += -DCONFIG_SCST_ABORT_CONSIDER_FINISHED_TASKS_AS_NOT_EXISTING

#EXTRA_CFLAGS += -fno-inline

#EXTRA_CFLAGS += -DCONFIG_SCST_TRACING

EXTRA_CFLAGS += -DCONFIG_SCST_DEBUG -g -fno-inline -fno-inline-functions
#EXTRA_CFLAGS += -DCONFIG_SCST_DEBUG_TM -DCONFIG_SCST_TM_DBG_GO_OFFLINE
#EXTRA_CFLAGS += -DCONFIG_SCST_DEBUG_RETRY
#EXTRA_CFLAGS += -DCONFIG_SCST_DEBUG_OOM
#EXTRA_CFLAGS += -DCONFIG_SCST_DEBUG_SN

#EXTRA_CFLAGS += -DCONFIG_SCST_MEASURE_LATENCY

# If defined, makes SCST zero allocated data buffers. 
# Undefining it considerably improves performance and eases CPU load, 
# but could create a security hole (information leakage), so 
# enable it if you have strict security requirements.
#EXTRA_CFLAGS += -DSCST_STRICT_SECURITY

.PHONY: all install uninstall

--------------090404070802070904040706--
