Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab0FPTFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:05:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab0FPTFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:05:15 -0400
Message-ID: <4C192085.2090404@vlnb.net>
Date: Wed, 16 Jun 2010 23:05:41 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: sparclinux@vger.kernel.org
CC: Simone Ricci <simone.ricci@gmail.com>, scst-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Couchman <Nick.Couchman@seakr.com>
Subject: Error "Unknown relocation: 36" on module load on Sparc
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com>
In-Reply-To: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020701050104050304040407"
X-Provags-ID: V01U2FsdGVkX18pjrUH3IoC/vbjkz7jLipPLUc2rKSvC7OKoZc
 6umsehZ7znmQndlEGEhwL9hzPCP838IFaWCOu1ZZrrHXy2hUXC
 cDKMjuJdx7mtZ396InmOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020701050104050304040407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

We in SCST project have a very strange problem on Sparc. Our main module 
scst.ko, if built as a module out of the kernel tree, can't be loaded 
and "modprobe scst" returns:

FATAL: Error inserting scst 
(/lib/modules/2.6.26-2-sparc64/extra/scst.ko): Invalid module format

The following message is immediately spit out by the kernel:
[ 1686.676534] module scst: Unknown relocation: 36

On x86 everything works fine. If SCST built inside the kernel, on Sparc 
it also works fine.

We completely stuck and have no idea what could be the cause. Googling 
also doesn't help much.

Could anybody point out a direction how to find the cause of the issue? 
I'm attaching Makefile we are using for you reference.

Thanks,
Vlad

--------------020701050104050304040407
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Makefile"

#
#  SCSI target mid-level makefile
#  
#  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
#  Copyright (C) 2004 - 2005 Leonid Stoljar
#  Copyright (C) 2007 - 2010 ID7 Ltd.
#  
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, version 2
#  of the License.
# 
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#
# Main targets:
#    all (the default) : make all
#    clean             : clean files
#    extraclean        : clean + clean dependencies
#    install           : install 
#    uninstall         : uninstall 
#
# Notes :
#    - install and uninstall must be made as root
#

SHELL=/bin/bash

DEV_HANDLERS_DIR = dev_handlers

ifneq ($(PATCHLEVEL),)
SCST_INC_DIR := $(SUBDIRS)/../include

obj-m := scst.o

scst-y        += scst_main.o
scst-y        += scst_targ.o
scst-y        += scst_lib.o
scst-y        += scst_proc.o
#scst-y        += scst_sysfs.o
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

clean:
	rm -f *.o *.ko .*.cmd *.mod.c .*.d .depend Modules.symvers \
		Module.symvers Module.markers modules.order
	rm -rf .tmp_versions
	cd $(DEV_HANDLERS_DIR) && $(MAKE) $@

extraclean: clean

debug2release:
	sed -i.aa s/"^EXTRA_CFLAGS += \-DCONFIG_SCST_EXTRACHECKS"/"#EXTRA_CFLAGS += \-DCONFIG_SCST_EXTRACHECKS"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	sed -i.aa s/"#EXTRA_CFLAGS += \-DCONFIG_SCST_TRACING"/"EXTRA_CFLAGS += \-DCONFIG_SCST_TRACING"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	sed -i.aa s/"^EXTRA_CFLAGS += \-DCONFIG_SCST_DEBUG -g -fno-inline -fno-inline-functions"/"#EXTRA_CFLAGS += \-DCONFIG_SCST_DEBUG -g -fno-inline -fno-inline-functions"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	rm Makefile.aa
	cd $(DEV_HANDLERS_DIR) && $(MAKE) $@

release2debug:
	sed -i.aa s/"#EXTRA_CFLAGS += \-DCONFIG_SCST_EXTRACHECKS"/"EXTRA_CFLAGS += \-DCONFIG_SCST_EXTRACHECKS"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	sed -i.aa s/"^EXTRA_CFLAGS += \-DCONFIG_SCST_TRACING"/"#EXTRA_CFLAGS += \-DCONFIG_SCST_TRACING"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	sed -i.aa s/"#EXTRA_CFLAGS += \-DCONFIG_SCST_DEBUG -g -fno-inline -fno-inline-functions"/"EXTRA_CFLAGS += \-DCONFIG_SCST_DEBUG -g -fno-inline -fno-inline-functions"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	rm Makefile.aa
	cd $(DEV_HANDLERS_DIR) && $(MAKE) $@

debug2perf:
	sed -i.aa s/"^EXTRA_CFLAGS += \-DCONFIG_SCST_EXTRACHECKS"/"#EXTRA_CFLAGS += \-DCONFIG_SCST_EXTRACHECKS"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	sed -i.aa s/"^EXTRA_CFLAGS += \-DCONFIG_SCST_DEBUG -g -fno-inline -fno-inline-functions"/"#EXTRA_CFLAGS += \-DCONFIG_SCST_DEBUG -g -fno-inline -fno-inline-functions"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	rm Makefile.aa
	cd $(DEV_HANDLERS_DIR) && $(MAKE) $@

perf2debug:
	sed -i.aa s/"#EXTRA_CFLAGS += \-DCONFIG_SCST_EXTRACHECKS"/"EXTRA_CFLAGS += \-DCONFIG_SCST_EXTRACHECKS"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	sed -i.aa s/"#EXTRA_CFLAGS += \-DCONFIG_SCST_DEBUG -g -fno-inline -fno-inline-functions"/"EXTRA_CFLAGS += \-DCONFIG_SCST_DEBUG -g -fno-inline -fno-inline-functions"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	rm Makefile.aa
	cd $(DEV_HANDLERS_DIR) && $(MAKE) $@

disable_proc:
	sed -i.aa s/"^#define CONFIG_SCST_PROC"/"\/* #define CONFIG_SCST_PROC *\/"/ ../include/scst.h
	@cmp ../include/scst.h ../include/scst.h.aa >/dev/null; if [[ $$? = 0 ]]; then rm ../include/scst.h.aa; echo "sed failed"; false; fi
	rm ../include/scst.h.aa
	sed -i.aa s/"^scst-y        += scst_proc.o"/"#scst\-y        += scst_proc.o"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	sed -i.aa s/"#scst\-y        += scst_sysfs.o"/"scst\-y        += scst_sysfs.o"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	rm Makefile.aa

enable_proc:
	sed -i.aa s/"\/\* #define CONFIG_SCST_PROC \*\/"/"#define CONFIG_SCST_PROC"/ ../include/scst.h
	@cmp ../include/scst.h ../include/scst.h.aa >/dev/null; if [[ $$? = 0 ]]; then rm ../include/scst.h.aa; echo "sed failed"; false; fi
	rm ../include/scst.h.aa
	sed -i.aa s/"#scst\-y        += scst_proc.o"/"scst\-y        += scst_proc.o"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	sed -i.aa s/"^scst\-y        += scst_sysfs.o"/"#scst\-y        += scst_sysfs.o"/ Makefile
	@cmp Makefile Makefile.aa >/dev/null; if [[ $$? = 0 ]]; then rm Makefile.aa; echo "sed failed"; false; fi
	rm Makefile.aa

.PHONY: all install uninstall clean extraclean debug2release release2debug debug2perf perf2debug disable_proc enable_proc

--------------020701050104050304040407--
