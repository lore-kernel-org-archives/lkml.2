Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab0D1XPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:15:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:34986 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab0D1XO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:14:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,290,1270450800"; 
   d="scan'208,223";a="562499484"
From: "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Apr 2010 16:10:34 -0700
Subject: [RFC PATCH 1/4] Mobile security processor driver
Thread-Topic: [RFC PATCH 1/4] Mobile security processor driver
Thread-Index: AcrnHO51hK8oLM7OThCwTiZgshRYnwACr29Q
Message-ID: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AC@orsmsx501.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252ACorsmsx501amrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252ACorsmsx501amrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From ea67f69e70e5a8c6e50db3f1d8b62cd52d816bc6 Mon Sep 17 00:00:00 2001
From: Mark Allyn <mark.a.allyn@intel.com>
Date: Wed, 28 Apr 2010 14:33:16 -0700
Subject: RFC [PATCH 1/4] staging: sep: header file updates for 12/09 softwa=
re release

Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
---
  drivers/staging/sep/sep_dev.h            |  110 -----
  drivers/staging/sep/sep_driver_api.h     |  769 ++++++++++++++++++-------=
-----
  drivers/staging/sep/sep_driver_config.h  |  140 ++++--
  drivers/staging/sep/sep_driver_ext_api.h |  127 +++++
  drivers/staging/sep/sep_driver_hw_defs.h |  426 +++++++++--------
  5 files changed, 921 insertions(+), 651 deletions(-)
  delete mode 100644 drivers/staging/sep/sep_dev.h
  create mode 100644 drivers/staging/sep/sep_driver_ext_api.h

diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
deleted file mode 100644
index 9200524..0000000
--- a/drivers/staging/sep/sep_dev.h
+++ /dev/null
@@ -1,110 +0,0 @@
-#ifndef __SEP_DEV_H__
-#define __SEP_DEV_H__
-
-/*
- *
- *  sep_dev.h - Security Processor Device Structures
- *
- *  Copyright(c) 2009 Intel Corporation. All rights reserved.
- *  Copyright(c) 2009 Discretix. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or modify i=
t
- *  under the terms of the GNU General Public License as published by the =
Free
- *  Software Foundation; either version 2 of the License, or (at your opti=
on)
- *  any later version.
- *
- *  This program is distributed in the hope that it will be useful, but WI=
THOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License =
for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License alon=
g with
- *  this program; if not, write to the Free Software Foundation, Inc., 59
- *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- *  CONTACTS:
- *
- *  Alan Cox           alan@linux.intel.com
- *
- */
-
-struct sep_device {
-       /* pointer to pci dev */
-       struct pci_dev *pdev;
-
-       unsigned long in_use;
-
-       /* address of the shared memory allocated during init for SEP drive=
r
-          (coherent alloc) */
-       void *shared_addr;
-       /* the physical address of the shared area */
-       dma_addr_t shared_bus;
-
-       /* restricted access region (coherent alloc) */
-       dma_addr_t rar_bus;
-       void *rar_addr;
-       /* firmware regions: cache is at rar_addr */
-       unsigned long cache_size;
-
-       /* follows the cache */
-       dma_addr_t resident_bus;
-       unsigned long resident_size;
-       void *resident_addr;
-
-       /* start address of the access to the SEP registers from driver */
-       void __iomem *reg_addr;
-       /* transaction counter that coordinates the transactions between SE=
P and HOST */
-       unsigned long send_ct;
-       /* counter for the messages from sep */
-       unsigned long reply_ct;
-       /* counter for the number of bytes allocated in the pool for the cu=
rrent
-          transaction */
-       unsigned long data_pool_bytes_allocated;
-
-       /* array of pointers to the pages that represent input data for the=
 synchronic
-          DMA action */
-       struct page **in_page_array;
-
-       /* array of pointers to the pages that represent out data for the s=
ynchronic
-          DMA action */
-       struct page **out_page_array;
-
-       /* number of pages in the sep_in_page_array */
-       unsigned long in_num_pages;
-
-       /* number of pages in the sep_out_page_array */
-       unsigned long out_num_pages;
-
-       /* global data for every flow */
-       struct sep_flow_context_t flows[SEP_DRIVER_NUM_FLOWS];
-
-       /* pointer to the workqueue that handles the flow done interrupts *=
/
-       struct workqueue_struct *flow_wq;
-
-};
-
-static struct sep_device *sep_dev;
-
-static inline void sep_write_reg(struct sep_device *dev, int reg, u32 valu=
e)
-{
-       void __iomem *addr =3D dev->reg_addr + reg;
-       writel(value, addr);
-}
-
-static inline u32 sep_read_reg(struct sep_device *dev, int reg)
-{
-       void __iomem *addr =3D dev->reg_addr + reg;
-       return readl(addr);
-}
-
-/* wait for SRAM write complete(indirect write */
-static inline void sep_wait_sram_write(struct sep_device *dev)
-{
-       u32 reg_val;
-       do
-               reg_val =3D sep_read_reg(dev, HW_SRAM_DATA_READY_REG_ADDR);
-       while (!(reg_val & 1));
-}
-
-
-#endif
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep=
_driver_api.h
index 383543d..05ec048 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -1,23 +1,29 @@
-/*
- *
- *  sep_driver_api.h - Security Processor Driver api definitions
- *
- *  Copyright(c) 2009 Intel Corporation. All rights reserved.
- *  Copyright(c) 2009 Discretix. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or modify i=
t
- *  under the terms of the GNU General Public License as published by the =
Free
- *  Software Foundation; either version 2 of the License, or (at your opti=
on)
- *  any later version.
+ /*
+ *   sep_driver_api.h
   *
- *  This program is distributed in the hope that it will be useful, but WI=
THOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License =
for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License alon=
g with
- *  this program; if not, write to the Free Software Foundation, Inc., 59
- *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *************************************************************************=
*
+ *   Copyright 2009 (c) Discretix Technologies Ltd.                       =
   *
+ *   Copyright 2009 (c) Intel Corporation                                 =
   *
+ *                                                                        =
 *
+ *   This software is protected by copyright, international treaties and  =
 *
+ *   various patents. Any copy or reproduction of this Software as        =
 *
+ *   permitted below, must include this Copyright Notice as well as any   =
 *
+ *   other notices provided under such license.                           =
 *
+ *                                                                        =
 *
+ *   This program shall be governed by, and may be used and redistributed =
 *
+ *   under the terms and conditions of the GNU General Public License,    =
 *
+ *   version 2, as published by the Free Software Foundation.             =
 *
+ *                                                                        =
 *
+ *   This program is distributed in the hope that it will be useful,      =
 *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied     =
 *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.     =
 *
+ *   See the GNU General Public License for more details.                 =
 *
+ *                                                                        =
 *
+ *   You should have received a copy of the GNU General Public License    =
 *
+ *   along with this program; if not, please write to the Free Software   =
 *
+ *   Foundation, Inc.,                                                    =
 *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.            =
 *
+ *************************************************************************=
*
   *
   *  CONTACTS:
   *
@@ -25,401 +31,576 @@
   *
   *  CHANGES:
   *
- *  2009.06.26 Initial publish
+ *  2010.01.08 Initial publish
   *
   */
-
  #ifndef __SEP_DRIVER_API_H__
  #define __SEP_DRIVER_API_H__

+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/kdev_t.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/wait.h>

+/*-----------------
+    DEFINE
+-------------------*/

-/*----------------------------------------------------------------
-  IOCTL command defines
-  -----------------------------------------------------------------*/
+#define SEP_DRIVER_SRC_REPLY    1
+#define SEP_DRIVER_SRC_REQ      2
+#define SEP_DRIVER_SRC_PRINTF   3

-/* magic number 1 of the sep IOCTL command */
-#define SEP_IOC_MAGIC_NUMBER                           's'

-/* sends interrupt to sep that message is ready */
-#define SEP_IOCSENDSEPCOMMAND                 _IO(SEP_IOC_MAGIC_NUMBER , 0=
)

-/* sends interrupt to sep that message is ready */
-#define SEP_IOCSENDSEPRPLYCOMMAND             _IO(SEP_IOC_MAGIC_NUMBER , 1=
)
+/*-------------------------------------------
+    TYPEDEFS
+----------------------------------------------*/

-/* allocate memory in data pool */
-#define SEP_IOCALLOCDATAPOLL                  _IO(SEP_IOC_MAGIC_NUMBER , 2=
)
+/*
+  init command struct
+*/
+struct sep_driver_init_t {
+  /* start of the 1G of the host memory address that SEP can access */
+  u32 *message_addr;

-/* write to pre-allocated  memory in data pool */
-#define SEP_IOCWRITEDATAPOLL                  _IO(SEP_IOC_MAGIC_NUMBER , 3=
)
+  /* start address of resident */
+  u32   message_size_in_words;

-/* read from  pre-allocated  memory in data pool */
-#define SEP_IOCREADDATAPOLL                   _IO(SEP_IOC_MAGIC_NUMBER , 4=
)
+  /* offset of the init message in the sep sram */
+  u32   sep_sram_addr;
+};

-/* create sym dma lli tables */
-#define SEP_IOCCREATESYMDMATABLE              _IO(SEP_IOC_MAGIC_NUMBER , 5=
)

-/* create flow dma lli tables */
-#define SEP_IOCCREATEFLOWDMATABLE             _IO(SEP_IOC_MAGIC_NUMBER , 6=
)
+/*
+  realloc cache resident command
+*/
+struct sep_driver_realloc_cache_resident_t {
+  /* base address */
+  void  *base_addr;

-/* free dynamic data aalocated during table creation */
-#define SEP_IOCFREEDMATABLEDATA                _IO(SEP_IOC_MAGIC_NUMBER , =
7)
+  /* current cache address */
+  void  *cache_addr;

-/* get the static pool area addersses (physical and virtual) */
-#define SEP_IOCGETSTATICPOOLADDR               _IO(SEP_IOC_MAGIC_NUMBER , =
8)
+  /* cache size in bytes*/
+  u32   cache_size_in_bytes;

-/* set flow id command */
-#define SEP_IOCSETFLOWID                       _IO(SEP_IOC_MAGIC_NUMBER , =
9)
+  /* current resident address */
+  void  *resident_addr;

-/* add tables to the dynamic flow */
-#define SEP_IOCADDFLOWTABLE                    _IO(SEP_IOC_MAGIC_NUMBER , =
10)
+  /* resident size in bytes*/
+  u32   resident_size_in_bytes;

-/* add flow add tables message */
-#define SEP_IOCADDFLOWMESSAGE                  _IO(SEP_IOC_MAGIC_NUMBER , =
11)
+  /* current dcache address */
+  void  *dcache_addr;

-/* start sep command */
-#define SEP_IOCSEPSTART                        _IO(SEP_IOC_MAGIC_NUMBER , =
12)
+  /* resident size in bytes*/
+  u32   dcache_size_in_bytes;

-/* init sep command */
-#define SEP_IOCSEPINIT                         _IO(SEP_IOC_MAGIC_NUMBER , =
13)
+  /* ext cache current address */
+  void  *extcache_addr;

-/* end transaction command */
-#define SEP_IOCENDTRANSACTION                  _IO(SEP_IOC_MAGIC_NUMBER , =
15)
+  /* ext cache size in bytes*/
+  u32   extcache_size_in_bytes;

-/* reallocate cache and resident */
-#define SEP_IOCREALLOCCACHERES                 _IO(SEP_IOC_MAGIC_NUMBER , =
16)
+  /* new cache address */
+  dma_addr_t   new_cache_addr;

-/* get the offset of the address starting from the beginnnig of the map ar=
ea */
-#define SEP_IOCGETMAPPEDADDROFFSET             _IO(SEP_IOC_MAGIC_NUMBER , =
17)
+  /* new resident address */
+  dma_addr_t   new_resident_addr;

-/* get time address and value */
-#define SEP_IOCGETIME                          _IO(SEP_IOC_MAGIC_NUMBER , =
19)
+  /* new dcache address */
+  dma_addr_t   new_dcache_addr;

-/*-------------------------------------------
-    TYPEDEFS
-----------------------------------------------*/
+  /* new resident address */
+  dma_addr_t   new_shared_area_addr;

-/*
-  init command struct
-*/
-struct sep_driver_init_t {
-       /* start of the 1G of the host memory address that SEP can access *=
/
-       unsigned long message_addr;
+  /* new base address */
+  dma_addr_t   new_base_addr;
+};
+
+
+struct sep_driver_realloc_ext_cache_t {
+  /* current external cache address */
+  void  *ext_cache_addr;
+
+  /* external cache size in bytes*/
+  u32   ext_cache_size_in_bytes;

-       /* start address of resident */
-       unsigned long message_size_in_words;
+  /* new external cache address */
+  dma_addr_t   new_ext_cache_addr;

  };

+struct sep_driver_alloc_t {
+  /* virtual address of allocated space */
+  u32 offset;
+
+  /* physical address of allocated space */
+  dma_addr_t bus_address;
+
+  /* number of bytes to allocate */
+  u32 num_bytes;
+};

  /*
-  realloc cache resident command
  */
-struct sep_driver_realloc_cache_resident_t {
-       /* new cache address */
-       u64 new_cache_addr;
-       /* new resident address */
-       u64 new_resident_addr;
-       /* new resident address */
-       u64  new_shared_area_addr;
-       /* new base address */
-       u64 new_base_addr;
+struct sep_driver_build_sync_table_t {
+  /* address value of the data in */
+  unsigned long  app_in_address;
+
+  /* size of data in */
+  u32  data_in_size;
+
+  /* address of the data out */
+  unsigned long  app_out_address;
+
+  /* the size of the block of the operation - if needed,
+  every table will be modulo this parameter */
+  u32  block_size;
+
+  /* the physical address of the first input DMA table */
+  dma_addr_t  in_table_address;
+
+  /* number of entries in the first input DMA table */
+  u32  in_table_num_entries;
+
+  /* the physical address of the first output DMA table */
+  dma_addr_t  out_table_address;
+
+  /* number of entries in the first output DMA table */
+  u32  out_table_num_entries;
+
+  /* data in the first input table */
+  u32  table_data_size;
+
+  /* distinct user/kernel layout */
+  bool isKernelVirtualAddress;
+
  };

-struct sep_driver_alloc_t {
-       /* virtual address of allocated space */
-       unsigned long offset;

-       /* physical address of allocated space */
-       unsigned long phys_address;
+/* command struct for static pool addresses  */
+struct sep_driver_static_pool_addr_t {
+  /* physical address of the static pool */
+  dma_addr_t   static_bus_address;

-       /* number of bytes to allocate */
-       unsigned long num_bytes;
+  /* virtual address of the static pool */
+  void   *static_virt_address;
  };

-/*
- */
-struct sep_driver_write_t {
-       /* application space address */
-       unsigned long app_address;
+/* command struct for getiing offset of the physical address from
+       the start of the mapped area  */
+struct sep_driver_get_mapped_offset_t {
+  /* physical address of the static pool */
+  dma_addr_t   bus_address;

-       /* address of the data pool */
-       unsigned long datapool_address;
+  /* virtual address of the static pool */
+  u32   offset;
+};

-       /* number of bytes to write */
-       unsigned long num_bytes;
+/* command struct for getting time value and address */
+struct sep_driver_get_time_t {
+  /* physical address of stored time */
+  dma_addr_t   time_bus_address;
+
+  /* value of the stored time */
+  u32   time_value;
  };

-/*
- */
-struct sep_driver_read_t {
-       /* application space address */
-       unsigned long app_address;
+/* command struct for getting time value and address */
+struct sep_driver_set_caller_id_t {
+  /* pid of the process */
+  u32   pid;
+
+  /* virtual address of the caller id hash */
+  void  *callerIdAddress;

-       /* address of the data pool */
-       unsigned long datapool_address;
+  /* caller id hash size in bytes */
+  u32   callerIdSizeInBytes;

-       /* number of bytes to read */
-       unsigned long num_bytes;
  };

+/* command struct for translating rar handle to bus address
+   and setting it at predefined location */
+struct sep_driver_rar_handle_to_bus {
+
+       /* rar handle */
+       void  *rar_handle;
+};
+
+
  /*
+  structure that represent one entry in the DMA LLI table
  */
-struct sep_driver_build_sync_table_t {
-       /* address value of the data in */
-       unsigned long app_in_address;
+struct sep_lli_entry_t {
+  /* physical address */
+  u32  bus_address;
+
+  /* block size */
+  u32  block_size;
+};

-       /* size of data in */
-       unsigned long data_in_size;

-       /* address of the data out */
-       unsigned long app_out_address;

-       /* the size of the block of the operation - if needed,
-          every table will be modulo this parameter */
-       unsigned long block_size;
+struct sep_caller_id_entry {

-       /* the physical address of the first input DMA table */
-       unsigned long in_table_address;
+  int pid;

-       /* number of entries in the first input DMA table */
-       unsigned long in_table_num_entries;
+  unsigned char callerIdHash[SEP_CALLER_ID_HASH_SIZE_IN_BYTES];
+
+};

-       /* the physical address of the first output DMA table */
-       unsigned long out_table_address;

-       /* number of entries in the first output DMA table */
-       unsigned long out_table_num_entries;

-       /* data in the first input table */
-       unsigned long table_data_size;
+/**
+ * @struct sep_dma_map
+ *
+ * Structure that contains all information needed for mapping the user pag=
es
+ *           or kernel buffers for dma operations
+ *
+ *
+ */
+struct sep_dma_map {

-       /* distinct user/kernel layout */
-       bool isKernelVirtualAddress;
+  /* mapped dma address */
+  dma_addr_t    dma_addr;

+  /* size of the mapped data */
+  size_t        size;
  };

+
  /*
+    context of the device
  */
-struct sep_driver_build_flow_table_t {
-       /* flow type */
-       unsigned long flow_type;
+struct device_context {

-       /* flag for input output */
-       unsigned long input_output_flag;
+    /* the following addresses are for the restricted access region */
+    void *rar_virtual_address;

-       /* address value of the data in */
-       unsigned long virt_buff_data_addr;
+    dma_addr_t rar_physical_address;

-       /* size of data in */
-       unsigned long num_virtual_buffers;
+    dma_addr_t rar_start_address;
+    dma_addr_t rar_end_address;
+    size_t rar_size;

-       /* the physical address of the first input DMA table */
-       unsigned long first_table_addr;
+    /* address of the shared memory allocated during init for SEP driver *=
/
+    void  *shared_area_virt_addr;

-       /* number of entries in the first input DMA table */
-       unsigned long first_table_num_entries;
+    /* the physical address of the shared area */
+    dma_addr_t  shared_area_bus_addr;

-       /* data in the first input table */
-       unsigned long first_table_data_size;
+    /* mapped dma address of the shared area */
+    dma_addr_t  shared_area_dma_addr;

-       /* distinct user/kernel layout */
-       bool isKernelVirtualAddress;
-};
+    /* shared area size */
+    size_t     shared_area_size;

+    /* major and minor device numbers */
+    dev_t   device_number;

-struct sep_driver_add_flow_table_t {
-       /* flow id  */
-       unsigned long flow_id;
+    int sep_irq;

-       /* flag for input output */
-       unsigned long inputOutputFlag;
+    /* cdev struct of the driver */
+    struct cdev                        cdev;

-       /* address value of the data in */
-       unsigned long virt_buff_data_addr;
+    struct pci_dev             *pdev;
+    /*
+      signals if the SeP is already used for an API,
+      updated with atomic operations
+    */
+    unsigned long   in_use_flag;

-       /* size of data in */
-       unsigned long num_virtual_buffers;
+    /* mutex for locking access to ioctl from different threads */
+    struct mutex               ioctl_mutex;

-       /* address of the first table */
-       unsigned long first_table_addr;
+    /* wait queue head (event) of the driver */
+    wait_queue_head_t          event;

-       /* number of entries in the first table */
-       unsigned long first_table_num_entries;

-       /* data size of the first table */
-       unsigned long first_table_data_size;
+    /* start address of the access to the SEP registers from driver */
+    void __iomem *reg_addr;

-       /* distinct user/kernel layout */
-       bool isKernelVirtualAddress;
+    /* device pointer, used for DMA APIs - initialized either as
+       platform device (default), or according to the type of the SeP
+       on the platform (PCI etc' ) */
+    struct device *dev_ptr;

-};
+    /* transaction counter that coordinates the transactions
+    between SEP and HOST */
+    u32                        host_to_sep_send_counter;

-/*
-  command struct for set flow id
-*/
-struct sep_driver_set_flow_id_t {
-       /* flow id to set */
-       unsigned long flow_id;
-};
+    /* counter for the messages from sep */
+    u32                        sep_to_host_reply_counter;

+    /* counter for the number of bytes allocated in the pool for the curre=
nt
+    transaction */
+    u32                        data_pool_bytes_allocated;

-/* command struct for add tables message */
-struct sep_driver_add_message_t {
-       /* flow id to set */
-       unsigned long flow_id;
+    /* number of the lli tables created in the current transaction */
+    u32     num_lli_tables_created;

-       /* message size in bytes */
-       unsigned long message_size_in_bytes;
+    /* array of pointers to the pages that represent
+    input data for the synchronic DMA action */
+    struct page                **in_page_array;

-       /* address of the message */
-       unsigned long message_address;
-};
+    /* array of pointers to the pages that represent out
+    data for the synchronic DMA action */
+    struct page                **out_page_array;

-/* command struct for static pool addresses  */
-struct sep_driver_static_pool_addr_t {
-       /* physical address of the static pool */
-       unsigned long physical_static_address;
+    /* number of pages in the sep_in_page_array */
+    u32                                        in_num_pages;

-       /* virtual address of the static pool */
-       unsigned long virtual_static_address;
-};
+    /* number of pages in the sep_out_page_array */
+    u32                                        out_num_pages;

-/* command struct for getiing offset of the physical address from
-       the start of the mapped area  */
-struct sep_driver_get_mapped_offset_t {
-       /* physical address of the static pool */
-       unsigned long physical_address;
+    /* map array of the input data */
+    struct sep_dma_map  *in_map_array;

-       /* virtual address of the static pool */
-       unsigned long offset;
-};
+    /* map array of the output data */
+    struct sep_dma_map  *out_map_array;

-/* command struct for getting time value and address */
-struct sep_driver_get_time_t {
-       /* physical address of stored time */
-       unsigned long time_physical_address;
+    /* number of entries of the input mapp array */
+    u32                                        in_map_num_entries;

-       /* value of the stored time */
-       unsigned long time_value;
-};
+    /* number of entries of the output mapp array */
+    u32                                        out_map_num_entries;

+#ifdef DX_CC52_SUPPORT

-/*
-  structure that represent one entry in the DMA LLI table
-*/
-struct sep_lli_entry_t {
-       /* physical address */
-       unsigned long physical_address;
+    /* major and minor device numbers for singleton */
+    dev_t                   singleton_device_number;
+
+    /* cdev struct for singleton */
+    struct cdev             singleton_cdev;
+
+    /* access flag for singleton */
+    unsigned long           singleton_access_flag;

-       /* block size */
-       unsigned long block_size;
+    /* caller id table */
+    struct sep_caller_id_entry
+                       caller_id_table[SEP_CALLER_ID_TABLE_NUM_ENTRIES];
+
+#endif /*DX_CC52_SUPPORT*/
  };

-/*
-  structure that reperesents data needed for lli table construction
-*/
-struct sep_lli_prepare_table_data_t {
-       /* pointer to the memory where the first lli entry to be built */
-       struct sep_lli_entry_t *lli_entry_ptr;

-       /* pointer to the array of lli entries from which the table is to b=
e built */
-       struct sep_lli_entry_t *lli_array_ptr;

-       /* number of elements in lli array */
-       int lli_array_size;
+#ifdef __LITTLE_ENDIAN

-       /* number of entries in the created table */
-       int num_table_entries;
+static inline void SEP_WRITE_REGISTER(struct device_context *dev,
+      int reg, u32 value)
+{
+       void __iomem *addr =3D dev->reg_addr + reg;
+       writel(value, addr);
+}

-       /* number of array entries processed during table creation */
-       int num_array_entries_processed;
+static inline u32 SEP_READ_REGISTER(struct device_context *dev, int reg)
+{
+       void __iomem *addr =3D dev->reg_addr + reg;
+       return readl(addr);
+}

-       /* the totatl data size in the created table */
-       int lli_table_total_data_size;
-};
+#define SEP_CHANGE_ENDIANNESS(val) (val)

-/*
-  structure that represent tone table - it is not used in code, jkust
-  to show what table looks like
-*/
-struct sep_lli_table_t {
-       /* number of pages mapped in this tables. If 0 - means that the tab=
le
-          is not defined (used as a valid flag) */
-       unsigned long num_pages;
-       /*
-          pointer to array of page pointers that represent the mapping of =
the
-          virtual buffer defined by the table to the physical memory. If t=
his
-          pointer is NULL, it means that the table is not defined
-          (used as a valid flag)
-        */
-       struct page **table_page_array_ptr;
-
-       /* maximum flow entries in table */
-       struct sep_lli_entry_t lli_entries[SEP_DRIVER_MAX_FLOW_NUM_ENTRIES_=
IN_TABLE];
-};

+#else

-/*
-  structure for keeping the mapping of the virtual buffer into physical pa=
ges
-*/
-struct sep_flow_buffer_data {
-       /* pointer to the array of page structs pointers to the pages of th=
e
-          virtual buffer */
-       struct page **page_array_ptr;
+static inline void SEP_WRITE_REGISTER(struct device_context *dev,
+      int reg,
+      u32 value)
+{
+       void __iomem *addr =3D dev->reg_addr + reg;
+       writel_be(value, addr);
+}

-       /* number of pages taken by the virtual buffer */
-       unsigned long num_pages;
+static inline u32 SEP_READ_REGISTER(struct device_context *dev, int reg)
+{
+       void __iomem *addr =3D dev->reg_addr + reg;
+       return readl_be(addr);
+}

-       /* this flag signals if this page_array is the last one among many =
that were
-          sent in one setting to SEP */
-       unsigned long last_page_array_flag;
-};
+#define SEP_CHANGE_ENDIANNESS(val) \
+      (((val) >> 24) | (((val) & 0x00FF0000) >> 8) | \
+      (((val) & 0x0000FF00) << 8) | \
+      (((val) & 0x000000FF) << 24))

-/*
-  struct that keeps all the data for one flow
-*/
-struct sep_flow_context_t {
-       /*
-          work struct for handling the flow done interrupt in the workqueu=
e
-          this structure must be in the first place, since it will be used
-          forcasting to the containing flow context
-        */
-       struct work_struct flow_wq;
+#endif
+
+/* wait for SRAM write complete(indirect write */
+static inline void SEP_WAIT_SRAM_WRITE_COMPLETE(struct device_context *dev=
)
+{
+       u32  reg_val;
+       do {
+               reg_val =3D SEP_READ_REGISTER(dev, HW_SRAM_DATA_READY_REG_A=
DDR);
+       } while (!(reg_val & 0x1));
+}
+
+
+
+/*----------------------------------------------------------------
+  IOCTL command defines
+  -----------------------------------------------------------------*/

-       /* flow id */
-       unsigned long flow_id;
+/* magic number 1 of the sep IOCTL command */
+#define SEP_IOC_MAGIC_NUMBER                           's'

-       /* additional input tables exists */
-       unsigned long input_tables_flag;
+/* sends interrupt to sep that message is ready */
+#define SEP_IOCSENDSEPCOMMAND     \
+      _IO(SEP_IOC_MAGIC_NUMBER, 0)

-       /* additional output tables exists */
-       unsigned long output_tables_flag;
+/* sends interrupt to sep that message is ready */
+#define SEP_IOCSENDSEPRPLYCOMMAND     \
+      _IO(SEP_IOC_MAGIC_NUMBER, 1)

-       /*  data of the first input file */
-       struct sep_lli_entry_t first_input_table;
+/* allocate memory in data pool */
+#define SEP_IOCALLOCDATAPOLL      \
+      _IOW(SEP_IOC_MAGIC_NUMBER, 2, struct sep_driver_alloc_t)

-       /* data of the first output table */
-       struct sep_lli_entry_t first_output_table;
+/* write to pre-allocated  memory in data pool */
+#define SEP_IOCWRITEDATAPOLL      \
+      _IOW(SEP_IOC_MAGIC_NUMBER, 3, struct sep_driver_write_t)

-       /* last input table data */
-       struct sep_lli_entry_t last_input_table;
+/* read from  pre-allocated  memory in data pool */
+#define SEP_IOCREADDATAPOLL     \
+      _IOW(SEP_IOC_MAGIC_NUMBER, 4, struct sep_driver_write_t)

-       /* last output table data */
-       struct sep_lli_entry_t last_output_table;
+/* create sym dma lli tables */
+#define SEP_IOCCREATESYMDMATABLE      \
+      _IOW(SEP_IOC_MAGIC_NUMBER, 5, struct sep_driver_build_sync_table_t)

-       /* first list of table */
-       struct sep_lli_entry_t input_tables_in_process;
+/* create flow dma lli tables */
+#define SEP_IOCCREATEFLOWDMATABLE     \
+      _IO(SEP_IOC_MAGIC_NUMBER, 6)

-       /* output table in process (in sep) */
-       struct sep_lli_entry_t output_tables_in_process;
+/* free dynamic data aalocated during table creation */
+#define SEP_IOCFREEDMATABLEDATA     \
+      _IO(SEP_IOC_MAGIC_NUMBER , 7)

-       /* size of messages in bytes */
-       unsigned long message_size_in_bytes;
+/* get the static pool area addersses (physical and virtual) */
+#define SEP_IOCGETSTATICPOOLADDR      \
+      _IOR(SEP_IOC_MAGIC_NUMBER , 8, struct sep_driver_static_pool_addr_t)

-       /* message */
-       unsigned char message[SEP_MAX_ADD_MESSAGE_LENGTH_IN_BYTES];
-};
+/* set flow id command */
+#define SEP_IOCSETFLOWID      \
+      _IO(SEP_IOC_MAGIC_NUMBER , 9)
+
+/* add tables to the dynamic flow */
+#define SEP_IOCADDFLOWTABLE     \
+      _IO(SEP_IOC_MAGIC_NUMBER , 10)
+
+/* add flow add tables message */
+#define SEP_IOCADDFLOWMESSAGE     \
+      _IO(SEP_IOC_MAGIC_NUMBER , 11)
+
+/* start sep command */
+#define SEP_IOCSEPSTART     \
+      _IO(SEP_IOC_MAGIC_NUMBER , 12)
+
+/* init sep command */
+#define SEP_IOCSEPINIT      \
+      _IOW(SEP_IOC_MAGIC_NUMBER , 13 , struct sep_driver_init_t)
+
+/* end transaction command */
+#define SEP_IOCENDTRANSACTION     \
+      _IO(SEP_IOC_MAGIC_NUMBER , 15)
+
+/* reallocate cache and resident */
+#define SEP_IOCREALLOCCACHERES      \
+  _IOW(SEP_IOC_MAGIC_NUMBER, 16, struct sep_driver_realloc_cache_resident_=
t)
+
+/* get the offset of the address starting from the beginnnig of the map ar=
ea */
+#define SEP_IOCGETMAPPEDADDROFFSET      \
+      _IOR(SEP_IOC_MAGIC_NUMBER , 17 , struct sep_driver_get_mapped_offset=
_t)
+
+/* reallocate cache and resident */
+#define SEP_IOCREALLOCEXTCACHE      \
+      _IOW(SEP_IOC_MAGIC_NUMBER , 18 , struct sep_driver_realloc_ext_cache=
_t)
+
+/* get time address and value */
+#define SEP_IOCGETIME     \
+      _IOR(SEP_IOC_MAGIC_NUMBER , 19 , struct sep_driver_get_time_t)
+
+#define SEP_IOCRARPREPAREMESSAGE      \
+      _IOW(SEP_IOC_MAGIC_NUMBER , 20 , struct sep_driver_rar_handle_to_bus=
)
+
+#define SEP_IOCTLSINGLETONLOCK      \
+      _IO(SEP_IOC_MAGIC_NUMBER , 32)
+
+#define SEP_IOCTLSINGLETONUNLOCK      \
+      _IO(SEP_IOC_MAGIC_NUMBER , 33)
+
+#define SEP_IOCTLSETCALLERID      \
+      _IOW(SEP_IOC_MAGIC_NUMBER , 34 , struct sep_driver_set_caller_id_t)
+
+
+/*----------------------------------------------------------------
+  PUBLIC functions
+  -----------------------------------------------------------------*/
+
+/*
+  this function locks SEP by locking the semaphore
+*/
+int sep_lock(void);
+
+/*
+  this function unlocks SEP
+*/
+void sep_unlock(void);
+
+/*
+       this function returns the address of the message shared area
+*/
+void  *sep_map_shared_area(void);
+
+
+/*
+       this function returns the address of the message shared area
+*/
+int sep_send_msg_rdy_cmd(void);
+
+
+/*
+       This function builds input and output DMA tables for synhronic symm=
etric
+       operations (AES, DES) It also checks that each table is of the modu=
lar
+       block size
+*/
+int sep_prepare_input_output_dma_table(unsigned long   app_virt_in_addr,
+                               unsigned long   app_virt_out_addr,
+                               u32   data_size,
+                               u32   block_size,
+                               dma_addr_t  *lli_table_in_ptr,
+                               dma_addr_t  *lli_table_out_ptr,
+                               u32  *in_num_entries_ptr,
+                               u32  *out_num_entries_ptr,
+                               u32  *table_data_size_ptr,
+                               bool            isKernelVirtualAddress);
+
+/*
+       This function prepares only input DMA table for synhronic symmetric
+       operations (HASH)
+*/
+int sep_prepare_input_dma_table(unsigned long   app_virt_addr,
+                               u32   data_size,
+                               u32   block_size,
+                               dma_addr_t  *lli_table_ptr,
+                               u32  *num_entries_ptr,
+                               u32  *table_data_size_ptr,
+                               bool            isKernelVirtualAddress);
+
+/* poll(suspend) , until reply from sep */
+int sep_driver_poll(u32 *source_ptr);
+
+/*
+       this function handles the request for freeing dma table for
+       synhronic actions
+*/
+int sep_free_dma_table_data_handler(void);


  #endif
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/=
sep_driver_config.h
index 6008fe5..0ae168d 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -1,23 +1,29 @@
-/*
- *
- *  sep_driver_config.h - Security Processor Driver configuration
- *
- *  Copyright(c) 2009 Intel Corporation. All rights reserved.
- *  Copyright(c) 2009 Discretix. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or modify i=
t
- *  under the terms of the GNU General Public License as published by the =
Free
- *  Software Foundation; either version 2 of the License, or (at your opti=
on)
- *  any later version.
+ /*
+ * sep_driver_config.h
   *
- *  This program is distributed in the hope that it will be useful, but WI=
THOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License =
for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License alon=
g with
- *  this program; if not, write to the Free Software Foundation, Inc., 59
- *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *************************************************************************=
*
+ *   Copyright 2009 (c) Discretix Technologies Ltd.                       =
   *
+ *   Copyright 2009 (c) Intel Corporation                                 =
   *
+ *                                                                        =
 *
+ *   This software is protected by copyright, international treaties and  =
 *
+ *   various patents. Any copy or reproduction of this Software as        =
 *
+ *   permitted below, must include this Copyright Notice as well as any   =
 *
+ *   other notices provided under such license.                           =
 *
+ *                                                                        =
 *
+ *   This program shall be governed by, and may be used and redistributed =
 *
+ *   under the terms and conditions of the GNU General Public License,    =
 *
+ *   version 2, as published by the Free Software Foundation.             =
 *
+ *                                                                        =
 *
+ *   This program is distributed in the hope that it will be useful,      =
 *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied     =
 *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.     =
 *
+ *   See the GNU General Public License for more details.                 =
 *
+ *                                                                        =
 *
+ *   You should have received a copy of the GNU General Public License    =
 *
+ *   along with this program; if not, please write to the Free Software   =
 *
+ *   Foundation, Inc.,                                                    =
 *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.            =
 *
+ *************************************************************************=
*
   *
   *  CONTACTS:
   *
@@ -25,10 +31,9 @@
   *
   *  CHANGES:
   *
- *  2009.06.26 Initial publish
+ *  2010.01.08 Initial publish
   *
   */
-
  #ifndef __SEP_DRIVER_CONFIG_H__
  #define __SEP_DRIVER_CONFIG_H__

@@ -39,7 +44,7 @@

  /* if flag is on , then the driver is running in polling and
        not interrupt mode */
-#define SEP_DRIVER_POLLING_MODE                         1
+#define SEP_DRIVER_POLLING_MODE                         0

  /* flag which defines if the shared area address should be
        reconfiged (send to SEP anew) during init of the driver */
@@ -48,10 +53,24 @@
  /* the mode for running on the ARM1172 Evaluation platform (flag is 1) */
  #define SEP_DRIVER_ARM_DEBUG_MODE                       0

+/* the mode for running on the PowerPC Evaluation platform (flag is 1) */
+#define SEP_DRIVER_PPC_DEBUG_MODE                       0
+
+/* RAR lock mode - cahce, resident and ext cache must be copied to externa=
l RAR
+   and locked by driver in the same API */
+#define SEP_DRIVER_LOCK_RAR_MODE                        0
+
+/* flag which defines if the SEP driver should config the OTP (flag is 1),
+   or not (flag is 0) */
+#define SEP_DRIVER_CONFIG_OTP                           1
+
  /*-------------------------------------------
        INTERNAL DATA CONFIGURATION
        -------------------------------------------*/

+/* the dirver name */
+#define DRIVER_NAME "sep_sec_driver"
+
  /* flag for the input array */
  #define SEP_DRIVER_IN_FLAG                              0

@@ -61,6 +80,13 @@
  /* maximum number of entries in one LLI tables */
  #define SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP             8

+/* flag that signifies tah the lock is
+currently held by the proccess (struct file) */
+#define SEP_DRIVER_OWN_LOCK_FLAG                        1
+
+/* flag that signifies tah the lock is currently NOT
+held by the proccess (struct file) */
+#define SEP_DRIVER_DISOWN_LOCK_FLAG                     0

  /*--------------------------------------------------------
        SHARED AREA  memory total size is 36K
@@ -82,6 +108,10 @@
        it is divided as following:

        TIME_MEMORY_AREA                     8B
+
+       RAR_MEMORY_AREA                      8B
+
+    CURRENT_CALLER_ID_MEMORY             70B
  -----------------------------------------------------------*/


@@ -104,13 +134,17 @@
  /* the size of the message shared area in pages */
  #define SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_SIZE_IN_BYTES   (1024 * 5)

-
  /* the size of the data pool shared area size in pages */
  #define SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES         (1024 * 4)

  /* system data (time, caller id etc') pool */
-#define SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES           100
+#define SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES           (1024 * 3)
+
+/* the size in bytes of the time memory */
+#define SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES                  8

+/* the size in bytes of the RAR parameters memory */
+#define SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES            8

  /* area size that is mapped  - we map the MESSAGE AREA, STATIC POOL and
        DATA POOL areas. area must be module 4k */
@@ -152,10 +186,23 @@
  #define SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES \
        (SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES)

+/* offset of the RAR area */
+#define SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES \
+       (SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES + \
+       SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES)
+
+/* offset of the caller id area */
+#define SEP_DRIVER_SYSTEM_CALLER_ID_MEMORY_OFFSET_IN_BYTES \
+       (SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES + \
+    SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES)


  /* start physical address of the SEP registers memory in HOST */
-#define SEP_IO_MEM_REGION_START_ADDRESS                       0x80000000
+#if SEP_DRIVER_PPC_DEBUG_MODE
+  #define SEP_IO_MEM_REGION_START_ADDRESS                       0x83F00000
+#else
+  #define SEP_IO_MEM_REGION_START_ADDRESS                       0x80000000
+#endif

  /* size of the SEP registers memory region  in HOST (for now 100 register=
s) */
  #define SEP_IO_MEM_REGION_SIZE                                (2 * 0x1000=
00)
@@ -184,42 +231,53 @@
  /* mask for entries after being shifted left */
  #define SEP_NUM_ENTRIES_MASK                                  0x7F

-/* default flow id */
-#define SEP_FREE_FLOW_ID                                      0xFFFFFFFF
-
-/* temp flow id used during cretiong of new flow until receiving
-       real flow id from sep */
-#define SEP_TEMP_FLOW_ID                   (SEP_DRIVER_NUM_FLOWS + 1)
-
-/* maximum add buffers message length in bytes */
-#define SEP_MAX_ADD_MESSAGE_LENGTH_IN_BYTES                   (7 * 4)
-
  /* maximum number of concurrent virtual buffers */
  #define SEP_MAX_VIRT_BUFFERS_CONCURRENT                       100

  /* the token that defines the start of time address */
  #define SEP_TIME_VAL_TOKEN                                    0x12345678

+/* size of the caller id hash (sha2) */
+#define SEP_CALLER_ID_HASH_SIZE_IN_BYTES                      32
+
+/* maximum number of entries in the caller id table */
+#define SEP_CALLER_ID_TABLE_NUM_ENTRIES                       20
+
+/* the token that defines the start of time address */
+#define SEP_RAR_VAL_TOKEN                                     0xABABABAB
+
+/* ioctl error that should be returned when trying
+   to realloc the cache/resident second time */
+#define SEP_ALREADY_INITIALIZED_ERR                           12
+
+/* bit that locks access to the shared area */
+#define SEP_MMAP_LOCK_BIT                                     0
+
+/* bit that lock access to the poll  - after send_command */
+#define SEP_SEND_MSG_LOCK_BIT                                 1
+
  /* DEBUG LEVEL MASKS */
  #define SEP_DEBUG_LEVEL_BASIC       0x1

+#define SEP_DEBUG_LEVEL_REGISTERS   0x2
+
  #define SEP_DEBUG_LEVEL_EXTENDED    0x4


-/* Debug helpers */
+/* FUNCTIONAL MACROS */

  #define dbg(fmt, args...) \
  do {\
-       if (debug & SEP_DEBUG_LEVEL_BASIC) \
+       if (sep_debug & SEP_DEBUG_LEVEL_BASIC) \
                printk(KERN_DEBUG fmt, ##args); \
-} while(0);
+} while (0);

  #define edbg(fmt, args...) \
  do { \
-       if (debug & SEP_DEBUG_LEVEL_EXTENDED) \
+       if (sep_debug & SEP_DEBUG_LEVEL_EXTENDED) \
                printk(KERN_DEBUG fmt, ##args); \
-} while(0);
+} while (0);



-#endif
+#endif /*__SEP_DRIVER_CONFIG_H__*/
diff --git a/drivers/staging/sep/sep_driver_ext_api.h b/drivers/staging/sep=
/sep_driver_ext_api.h
new file mode 100644
index 0000000..220164b
--- /dev/null
+++ b/drivers/staging/sep/sep_driver_ext_api.h
@@ -0,0 +1,127 @@
+/*
+ * sep_driver_ext_api.h
+ *
+ *************************************************************************=
*
+ *   Copyright 2009 (c) Discretix Technologies Ltd.                       =
   *
+ *   Copyright 2009 (c) Intel Corporation                                 =
   *
+ *                                                                        =
 *
+ *   This software is protected by copyright, international treaties and  =
 *
+ *   various patents. Any copy or reproduction of this Software as        =
 *
+ *   permitted below, must include this Copyright Notice as well as any   =
 *
+ *   other notices provided under such license.                           =
 *
+ *                                                                        =
 *
+ *   This program shall be governed by, and may be used and redistributed =
 *
+ *   under the terms and conditions of the GNU General Public License,    =
 *
+ *   version 2, as published by the Free Software Foundation.             =
 *
+ *                                                                        =
 *
+ *   This program is distributed in the hope that it will be useful,      =
 *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied     =
 *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.     =
 *
+ *   See the GNU General Public License for more details.                 =
 *
+ *                                                                        =
 *
+ *   You should have received a copy of the GNU General Public License    =
 *
+ *   along with this program; if not, please write to the Free Software   =
 *
+ *   Foundation, Inc.,                                                    =
 *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.            =
 *
+ *************************************************************************=
*
+ *
+ *  CONTACTS:
+ *
+ *  Mark Allyn         mark.a.allyn@intel.com
+ *
+ *  CHANGES:
+ *
+ *  2010.01.08 Initial publish
+ *
+ */
+
+#ifndef __SEP_DRIVER_EXT_API_H__
+#define __SEP_DRIVER_EXT_API_H__
+
+
+/*
+This functions locks the area of the resident and cache sep code (if possi=
ble)
+*/
+int sep_lock_cache_resident_area(void);
+
+/*
+This functions copies the cache and resident from their source location in=
to
+destination memory, which is external to Linux VM and is given as physical
+address
+*/
+int sep_copy_cache_resident_to_area(struct device_context *sep_context_ptr=
,
+      dma_addr_t  *dst_new_cache_addr_ptr,
+      dma_addr_t  *dst_new_resident_addr_ptr,
+      dma_addr_t  *dst_new_dcache_addr_ptr);
+
+/*
+  This functions copies the external cache (3rd party) from
+  it's source location into destination memory,
+  which is external to Linux VM and is given as physical address.
+  It is supposed to be adjustent to the i-cache boundary
+*/
+int sep_copy_ext_cache_to_area(void *src_ext_cache_addr,
+      u32   ext_cache_size_in_bytes,
+      dma_addr_t  *ext_cache_bus_addr_ptr);
+
+
+
+/*
+This functions maps and allocates the shared area on the external
+RAM (device) The input is shared_area_size - the size of the memory
+to allocate. The outputs are kernel_shared_area_addr_ptr - the kerenl
+address of the mapped and allocated shared area, and
+phys_shared_area_addr_ptr - the physical address of the shared area
+*/
+int sep_map_and_alloc_shared_area(struct device_context *sep_context_ptr);
+
+/*
+This functions unmaps and deallocates the shared area on the  external
+RAM (device) The input is shared_area_size - the size of the memory to
+deallocate,kernel_shared_area_addr_ptr - the kernel address of the
+mapped and allocated shared area,phys_shared_area_addr_ptr - the physical
+address of the shared area
+*/
+void sep_unmap_and_free_shared_area(struct device_context *sep_context_ptr=
);
+
+
+/*
+This functions returns the physical address inside shared area according
+to the virtual address. It can be either on the externa RAM device
+(ioremapped), or on the system RAM
+*/
+dma_addr_t sep_shared_area_virt_to_bus(struct device_context *sep_context_=
ptr,
+      void  *virt_address);
+
+/*
+This functions returns the vitrual address inside shared area according
+to the physical address. It can be either on the externa RAM device
+(ioremapped), or on the system RAM This implementation is for the external=
 RAM
+*/
+void  *sep_shared_area_bus_to_virt(struct device_context *sep_context_ptr,
+      dma_addr_t bus_address);
+
+/*
+This function registers th driver to the device
+subsystem (either PCI, USB, etc)
+*/
+int sep_register_driver_to_device(void);
+
+/*
+This function translates the RAR handle into the bus address
+*/
+int sep_rar_handle_to_bus(void *rar_handle , dma_addr_t *rar_bus);
+
+extern struct device_context sep_context;
+
+/*
+Interrupt handler
+*/
+irqreturn_t sep_inthandler(int irq, void *dev_id);
+
+/*
+Callback to be used to furnish addresses when ready
+*/
+int sep_callback(void *sep_context_pointer);
+
+#endif /*__SEP_DRIVER_EXT_API_H__*/
diff --git a/drivers/staging/sep/sep_driver_hw_defs.h b/drivers/staging/sep=
/sep_driver_hw_defs.h
index ea6abd8..b571256 100644
--- a/drivers/staging/sep/sep_driver_hw_defs.h
+++ b/drivers/staging/sep/sep_driver_hw_defs.h
@@ -1,23 +1,29 @@
  /*
+ * sep_driver_hw_defs.h
   *
- *  sep_driver_hw_defs.h - Security Processor Driver hardware definitions
- *
- *  Copyright(c) 2009 Intel Corporation. All rights reserved.
- *  Copyright(c) 2009 Discretix. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or modify i=
t
- *  under the terms of the GNU General Public License as published by the =
Free
- *  Software Foundation; either version 2 of the License, or (at your opti=
on)
- *  any later version.
- *
- *  This program is distributed in the hope that it will be useful, but WI=
THOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License =
for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License alon=
g with
- *  this program; if not, write to the Free Software Foundation, Inc., 59
- *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *************************************************************************=
*
+ *   Copyright 2009 (c) Discretix Technologies Ltd.                       =
   *
+ *   Copyright 2009 (c) Intel Corporation                                 =
   *
+ *                                                                        =
 *
+ *   This software is protected by copyright, international treaties and  =
 *
+ *   various patents. Any copy or reproduction of this Software as        =
 *
+ *   permitted below, must include this Copyright Notice as well as any   =
 *
+ *   other notices provided under such license.                           =
 *
+ *                                                                        =
 *
+ *   This program shall be governed by, and may be used and redistributed =
 *
+ *   under the terms and conditions of the GNU General Public License,    =
 *
+ *   version 2, as published by the Free Software Foundation.             =
 *
+ *                                                                        =
 *
+ *   This program is distributed in the hope that it will be useful,      =
 *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied     =
 *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.     =
 *
+ *   See the GNU General Public License for more details.                 =
 *
+ *                                                                        =
 *
+ *   You should have received a copy of the GNU General Public License    =
 *
+ *   along with this program; if not, please write to the Free Software   =
 *
+ *   Foundation, Inc.,                                                    =
 *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.            =
 *
+ *************************************************************************=
*
   *
   *  CONTACTS:
   *
@@ -25,7 +31,7 @@
   *
   *  CHANGES:
   *
- *  2009.06.26 Initial publish
+ *  2010.01.08 Initial publish
   *
   */

@@ -39,194 +45,202 @@
  /*       DO NOT EDIT THIS FILE !!!                                       =
   */
  /*-----------------------------------------------------------------------=
---*/

+#ifdef __cplusplus
+extern "C"
+{
+#endif

  /* cf registers */
-#define         HW_R0B_ADDR_0_REG_ADDR                  0x0000UL
-#define         HW_R0B_ADDR_1_REG_ADDR                  0x0004UL
-#define         HW_R0B_ADDR_2_REG_ADDR                  0x0008UL
-#define         HW_R0B_ADDR_3_REG_ADDR                  0x000cUL
-#define         HW_R0B_ADDR_4_REG_ADDR                  0x0010UL
-#define         HW_R0B_ADDR_5_REG_ADDR                  0x0014UL
-#define         HW_R0B_ADDR_6_REG_ADDR                  0x0018UL
-#define         HW_R0B_ADDR_7_REG_ADDR                  0x001cUL
-#define         HW_R0B_ADDR_8_REG_ADDR                  0x0020UL
-#define         HW_R2B_ADDR_0_REG_ADDR                  0x0080UL
-#define         HW_R2B_ADDR_1_REG_ADDR                  0x0084UL
-#define         HW_R2B_ADDR_2_REG_ADDR                  0x0088UL
-#define         HW_R2B_ADDR_3_REG_ADDR                  0x008cUL
-#define         HW_R2B_ADDR_4_REG_ADDR                  0x0090UL
-#define         HW_R2B_ADDR_5_REG_ADDR                  0x0094UL
-#define         HW_R2B_ADDR_6_REG_ADDR                  0x0098UL
-#define         HW_R2B_ADDR_7_REG_ADDR                  0x009cUL
-#define         HW_R2B_ADDR_8_REG_ADDR                  0x00a0UL
-#define         HW_R3B_REG_ADDR                         0x00C0UL
-#define         HW_R4B_REG_ADDR                         0x0100UL
-#define         HW_CSA_ADDR_0_REG_ADDR                  0x0140UL
-#define         HW_CSA_ADDR_1_REG_ADDR                  0x0144UL
-#define         HW_CSA_ADDR_2_REG_ADDR                  0x0148UL
-#define         HW_CSA_ADDR_3_REG_ADDR                  0x014cUL
-#define         HW_CSA_ADDR_4_REG_ADDR                  0x0150UL
-#define         HW_CSA_ADDR_5_REG_ADDR                  0x0154UL
-#define         HW_CSA_ADDR_6_REG_ADDR                  0x0158UL
-#define         HW_CSA_ADDR_7_REG_ADDR                  0x015cUL
-#define         HW_CSA_ADDR_8_REG_ADDR                  0x0160UL
-#define         HW_CSA_REG_ADDR                         0x0140UL
-#define         HW_SINB_REG_ADDR                        0x0180UL
-#define         HW_SOUTB_REG_ADDR                       0x0184UL
-#define         HW_PKI_CONTROL_REG_ADDR                 0x01C0UL
-#define         HW_PKI_STATUS_REG_ADDR                  0x01C4UL
-#define         HW_PKI_BUSY_REG_ADDR                0x01C8UL
-#define         HW_PKI_A_1025_REG_ADDR                  0x01CCUL
-#define         HW_PKI_SDMA_CTL_REG_ADDR                0x01D0UL
-#define         HW_PKI_SDMA_OFFSET_REG_ADDR     0x01D4UL
-#define         HW_PKI_SDMA_POINTERS_REG_ADDR   0x01D8UL
-#define         HW_PKI_SDMA_DLENG_REG_ADDR              0x01DCUL
-#define         HW_PKI_SDMA_EXP_POINTERS_REG_ADDR       0x01E0UL
-#define         HW_PKI_SDMA_RES_POINTERS_REG_ADDR       0x01E4UL
-#define         HW_PKI_CLR_REG_ADDR                     0x01E8UL
-#define         HW_PKI_SDMA_BUSY_REG_ADDR                   0x01E8UL
-#define         HW_PKI_SDMA_FIRST_EXP_N_REG_ADDR        0x01ECUL
-#define         HW_PKI_SDMA_MUL_BY1_REG_ADDR            0x01F0UL
-#define         HW_PKI_SDMA_RMUL_SEL_REG_ADDR           0x01F4UL
-#define         HW_DES_KEY_0_REG_ADDR                   0x0208UL
-#define         HW_DES_KEY_1_REG_ADDR                   0x020CUL
-#define         HW_DES_KEY_2_REG_ADDR                   0x0210UL
-#define         HW_DES_KEY_3_REG_ADDR                   0x0214UL
-#define         HW_DES_KEY_4_REG_ADDR                   0x0218UL
-#define         HW_DES_KEY_5_REG_ADDR                   0x021CUL
-#define         HW_DES_CONTROL_0_REG_ADDR               0x0220UL
-#define         HW_DES_CONTROL_1_REG_ADDR               0x0224UL
-#define         HW_DES_IV_0_REG_ADDR                    0x0228UL
-#define         HW_DES_IV_1_REG_ADDR                    0x022CUL
-#define         HW_AES_KEY_0_ADDR_0_REG_ADDR            0x0400UL
-#define         HW_AES_KEY_0_ADDR_1_REG_ADDR            0x0404UL
-#define         HW_AES_KEY_0_ADDR_2_REG_ADDR            0x0408UL
-#define         HW_AES_KEY_0_ADDR_3_REG_ADDR            0x040cUL
-#define         HW_AES_KEY_0_ADDR_4_REG_ADDR            0x0410UL
-#define         HW_AES_KEY_0_ADDR_5_REG_ADDR            0x0414UL
-#define         HW_AES_KEY_0_ADDR_6_REG_ADDR            0x0418UL
-#define         HW_AES_KEY_0_ADDR_7_REG_ADDR            0x041cUL
-#define         HW_AES_KEY_0_REG_ADDR                   0x0400UL
-#define         HW_AES_IV_0_ADDR_0_REG_ADDR             0x0440UL
-#define         HW_AES_IV_0_ADDR_1_REG_ADDR             0x0444UL
-#define         HW_AES_IV_0_ADDR_2_REG_ADDR             0x0448UL
-#define         HW_AES_IV_0_ADDR_3_REG_ADDR             0x044cUL
-#define         HW_AES_IV_0_REG_ADDR                    0x0440UL
-#define         HW_AES_CTR1_ADDR_0_REG_ADDR             0x0460UL
-#define         HW_AES_CTR1_ADDR_1_REG_ADDR             0x0464UL
-#define         HW_AES_CTR1_ADDR_2_REG_ADDR             0x0468UL
-#define         HW_AES_CTR1_ADDR_3_REG_ADDR             0x046cUL
-#define         HW_AES_CTR1_REG_ADDR                    0x0460UL
-#define         HW_AES_SK_REG_ADDR                      0x0478UL
-#define         HW_AES_MAC_OK_REG_ADDR                      0x0480UL
-#define         HW_AES_PREV_IV_0_ADDR_0_REG_ADDR        0x0490UL
-#define         HW_AES_PREV_IV_0_ADDR_1_REG_ADDR        0x0494UL
-#define         HW_AES_PREV_IV_0_ADDR_2_REG_ADDR        0x0498UL
-#define         HW_AES_PREV_IV_0_ADDR_3_REG_ADDR        0x049cUL
-#define         HW_AES_PREV_IV_0_REG_ADDR                   0x0490UL
-#define         HW_AES_CONTROL_REG_ADDR                     0x04C0UL
-#define         HW_HASH_H0_REG_ADDR                 0x0640UL
-#define         HW_HASH_H1_REG_ADDR                 0x0644UL
-#define         HW_HASH_H2_REG_ADDR                 0x0648UL
-#define         HW_HASH_H3_REG_ADDR                 0x064CUL
-#define         HW_HASH_H4_REG_ADDR                 0x0650UL
-#define         HW_HASH_H5_REG_ADDR                 0x0654UL
-#define         HW_HASH_H6_REG_ADDR                 0x0658UL
-#define         HW_HASH_H7_REG_ADDR                 0x065CUL
-#define         HW_HASH_H8_REG_ADDR                 0x0660UL
-#define         HW_HASH_H9_REG_ADDR                 0x0664UL
-#define         HW_HASH_H10_REG_ADDR                0x0668UL
-#define         HW_HASH_H11_REG_ADDR                0x066CUL
-#define         HW_HASH_H12_REG_ADDR                0x0670UL
-#define         HW_HASH_H13_REG_ADDR                0x0674UL
-#define         HW_HASH_H14_REG_ADDR                0x0678UL
-#define         HW_HASH_H15_REG_ADDR                0x067CUL
-#define         HW_HASH_CONTROL_REG_ADDR                0x07C0UL
-#define         HW_HASH_PAD_EN_REG_ADDR                 0x07C4UL
-#define         HW_HASH_PAD_CFG_REG_ADDR                0x07C8UL
-#define         HW_HASH_CUR_LEN_0_REG_ADDR      0x07CCUL
-#define         HW_HASH_CUR_LEN_1_REG_ADDR      0x07D0UL
-#define         HW_HASH_CUR_LEN_2_REG_ADDR      0x07D4UL
-#define         HW_HASH_CUR_LEN_3_REG_ADDR      0x07D8UL
-#define         HW_HASH_PARAM_REG_ADDR                  0x07DCUL
-#define         HW_HASH_INT_BUSY_REG_ADDR               0x07E0UL
-#define         HW_HASH_SW_RESET_REG_ADDR               0x07E4UL
-#define         HW_HASH_ENDIANESS_REG_ADDR      0x07E8UL
-#define         HW_HASH_DATA_REG_ADDR               0x07ECUL
-#define         HW_DRNG_CONTROL_REG_ADDR                0x0800UL
-#define         HW_DRNG_VALID_REG_ADDR                  0x0804UL
-#define         HW_DRNG_DATA_REG_ADDR               0x0808UL
-#define         HW_RND_SRC_EN_REG_ADDR                  0x080CUL
-#define         HW_AES_CLK_ENABLE_REG_ADDR      0x0810UL
-#define         HW_DES_CLK_ENABLE_REG_ADDR      0x0814UL
-#define         HW_HASH_CLK_ENABLE_REG_ADDR     0x0818UL
-#define         HW_PKI_CLK_ENABLE_REG_ADDR      0x081CUL
-#define         HW_CLK_STATUS_REG_ADDR                  0x0824UL
-#define         HW_CLK_ENABLE_REG_ADDR                  0x0828UL
-#define         HW_DRNG_SAMPLE_REG_ADDR                 0x0850UL
-#define         HW_RND_SRC_CTL_REG_ADDR                 0x0858UL
-#define         HW_CRYPTO_CTL_REG_ADDR                  0x0900UL
-#define         HW_CRYPTO_STATUS_REG_ADDR               0x090CUL
-#define         HW_CRYPTO_BUSY_REG_ADDR                 0x0910UL
-#define         HW_AES_BUSY_REG_ADDR                0x0914UL
-#define         HW_DES_BUSY_REG_ADDR                0x0918UL
-#define         HW_HASH_BUSY_REG_ADDR               0x091CUL
-#define         HW_CONTENT_REG_ADDR                 0x0924UL
-#define         HW_VERSION_REG_ADDR                 0x0928UL
-#define         HW_CONTEXT_ID_REG_ADDR                  0x0930UL
-#define         HW_DIN_BUFFER_REG_ADDR                  0x0C00UL
-#define         HW_DIN_MEM_DMA_BUSY_REG_ADDR    0x0c20UL
-#define         HW_SRC_LLI_MEM_ADDR_REG_ADDR    0x0c24UL
-#define         HW_SRC_LLI_WORD0_REG_ADDR               0x0C28UL
-#define         HW_SRC_LLI_WORD1_REG_ADDR               0x0C2CUL
-#define         HW_SRAM_SRC_ADDR_REG_ADDR               0x0c30UL
-#define         HW_DIN_SRAM_BYTES_LEN_REG_ADDR  0x0c34UL
-#define         HW_DIN_SRAM_DMA_BUSY_REG_ADDR   0x0C38UL
-#define         HW_WRITE_ALIGN_REG_ADDR                 0x0C3CUL
-#define         HW_OLD_DATA_REG_ADDR                0x0C48UL
-#define         HW_WRITE_ALIGN_LAST_REG_ADDR    0x0C4CUL
-#define         HW_DOUT_BUFFER_REG_ADDR                 0x0C00UL
-#define         HW_DST_LLI_WORD0_REG_ADDR               0x0D28UL
-#define         HW_DST_LLI_WORD1_REG_ADDR               0x0D2CUL
-#define         HW_DST_LLI_MEM_ADDR_REG_ADDR    0x0D24UL
-#define         HW_DOUT_MEM_DMA_BUSY_REG_ADDR   0x0D20UL
-#define         HW_SRAM_DEST_ADDR_REG_ADDR      0x0D30UL
-#define         HW_DOUT_SRAM_BYTES_LEN_REG_ADDR 0x0D34UL
-#define         HW_DOUT_SRAM_DMA_BUSY_REG_ADDR  0x0D38UL
-#define         HW_READ_ALIGN_REG_ADDR                  0x0D3CUL
-#define         HW_READ_LAST_DATA_REG_ADDR      0x0D44UL
-#define         HW_RC4_THRU_CPU_REG_ADDR                0x0D4CUL
-#define         HW_AHB_SINGLE_REG_ADDR                  0x0E00UL
-#define         HW_SRAM_DATA_REG_ADDR               0x0F00UL
-#define         HW_SRAM_ADDR_REG_ADDR               0x0F04UL
-#define         HW_SRAM_DATA_READY_REG_ADDR     0x0F08UL
-#define         HW_HOST_IRR_REG_ADDR                     0x0A00UL
-#define         HW_HOST_IMR_REG_ADDR                     0x0A04UL
-#define         HW_HOST_ICR_REG_ADDR                     0x0A08UL
-#define         HW_HOST_SEP_SRAM_THRESHOLD_REG_ADDR  0x0A10UL
-#define         HW_HOST_SEP_BUSY_REG_ADDR                    0x0A14UL
-#define         HW_HOST_SEP_LCS_REG_ADDR                     0x0A18UL
-#define         HW_HOST_CC_SW_RST_REG_ADDR               0x0A40UL
-#define         HW_HOST_SEP_SW_RST_REG_ADDR              0x0A44UL
-#define         HW_HOST_FLOW_DMA_SW_INT0_REG_ADDR        0x0A80UL
-#define         HW_HOST_FLOW_DMA_SW_INT1_REG_ADDR        0x0A84UL
-#define         HW_HOST_FLOW_DMA_SW_INT2_REG_ADDR        0x0A88UL
-#define         HW_HOST_FLOW_DMA_SW_INT3_REG_ADDR        0x0A8cUL
-#define         HW_HOST_FLOW_DMA_SW_INT4_REG_ADDR        0x0A90UL
-#define         HW_HOST_FLOW_DMA_SW_INT5_REG_ADDR        0x0A94UL
-#define         HW_HOST_FLOW_DMA_SW_INT6_REG_ADDR    0x0A98UL
-#define         HW_HOST_FLOW_DMA_SW_INT7_REG_ADDR        0x0A9cUL
-#define         HW_HOST_SEP_HOST_GPR0_REG_ADDR           0x0B00UL
-#define         HW_HOST_SEP_HOST_GPR1_REG_ADDR           0x0B04UL
-#define         HW_HOST_SEP_HOST_GPR2_REG_ADDR           0x0B08UL
-#define         HW_HOST_SEP_HOST_GPR3_REG_ADDR       0x0B0CUL
-#define         HW_HOST_HOST_SEP_GPR0_REG_ADDR       0x0B80UL
-#define         HW_HOST_HOST_SEP_GPR1_REG_ADDR       0x0B84UL
-#define         HW_HOST_HOST_SEP_GPR2_REG_ADDR       0x0B88UL
-#define         HW_HOST_HOST_SEP_GPR3_REG_ADDR       0x0B8CUL
-#define         HW_HOST_HOST_ENDIAN_REG_ADDR         0x0B90UL
-#define         HW_HOST_HOST_COMM_CLK_EN_REG_ADDR        0x0B94UL
-#define         HW_CLR_SRAM_BUSY_REG_REG_ADDR        0x0F0CUL
+#define         HW_R0B_ADDR_0_REG_ADDR          0x0000UL
+#define         HW_R0B_ADDR_1_REG_ADDR          0x0004UL
+#define         HW_R0B_ADDR_2_REG_ADDR          0x0008UL
+#define         HW_R0B_ADDR_3_REG_ADDR          0x000cUL
+#define         HW_R0B_ADDR_4_REG_ADDR          0x0010UL
+#define         HW_R0B_ADDR_5_REG_ADDR          0x0014UL
+#define         HW_R0B_ADDR_6_REG_ADDR          0x0018UL
+#define         HW_R0B_ADDR_7_REG_ADDR          0x001cUL
+#define         HW_R0B_ADDR_8_REG_ADDR          0x0020UL
+#define         HW_R2B_ADDR_0_REG_ADDR          0x0080UL
+#define         HW_R2B_ADDR_1_REG_ADDR          0x0084UL
+#define         HW_R2B_ADDR_2_REG_ADDR          0x0088UL
+#define         HW_R2B_ADDR_3_REG_ADDR          0x008cUL
+#define         HW_R2B_ADDR_4_REG_ADDR          0x0090UL
+#define         HW_R2B_ADDR_5_REG_ADDR          0x0094UL
+#define         HW_R2B_ADDR_6_REG_ADDR          0x0098UL
+#define         HW_R2B_ADDR_7_REG_ADDR          0x009cUL
+#define         HW_R2B_ADDR_8_REG_ADDR          0x00a0UL
+#define         HW_R3B_REG_ADDR                         0x00C0UL
+#define         HW_R4B_REG_ADDR                         0x0100UL
+#define         HW_CSA_ADDR_0_REG_ADDR          0x0140UL
+#define         HW_CSA_ADDR_1_REG_ADDR          0x0144UL
+#define         HW_CSA_ADDR_2_REG_ADDR          0x0148UL
+#define         HW_CSA_ADDR_3_REG_ADDR          0x014cUL
+#define         HW_CSA_ADDR_4_REG_ADDR          0x0150UL
+#define         HW_CSA_ADDR_5_REG_ADDR          0x0154UL
+#define         HW_CSA_ADDR_6_REG_ADDR          0x0158UL
+#define         HW_CSA_ADDR_7_REG_ADDR          0x015cUL
+#define         HW_CSA_ADDR_8_REG_ADDR          0x0160UL
+#define         HW_CSA_REG_ADDR                         0x0140UL
+#define         HW_SINB_REG_ADDR                        0x0180UL
+#define         HW_SOUTB_REG_ADDR                       0x0184UL
+#define         HW_PKI_CONTROL_REG_ADDR                 0x01C0UL
+#define         HW_PKI_STATUS_REG_ADDR          0x01C4UL
+#define         HW_PKI_BUSY_REG_ADDR                0x01C8UL
+#define         HW_PKI_A_1025_REG_ADDR          0x01CCUL
+#define         HW_PKI_SDMA_CTL_REG_ADDR                0x01D0UL
+#define         HW_PKI_SDMA_OFFSET_REG_ADDR     0x01D4UL
+#define         HW_PKI_SDMA_POINTERS_REG_ADDR   0x01D8UL
+#define         HW_PKI_SDMA_DLENG_REG_ADDR              0x01DCUL
+#define         HW_PKI_SDMA_EXP_POINTERS_REG_ADDR       0x01E0UL
+#define         HW_PKI_SDMA_RES_POINTERS_REG_ADDR       0x01E4UL
+#define         HW_PKI_CLR_REG_ADDR                     0x01E8UL
+#define         HW_PKI_SDMA_BUSY_REG_ADDR                   0x01E8UL
+#define         HW_PKI_SDMA_FIRST_EXP_N_REG_ADDR        0x01ECUL
+#define         HW_PKI_SDMA_MUL_BY1_REG_ADDR            0x01F0UL
+#define         HW_PKI_SDMA_RMUL_SEL_REG_ADDR           0x01F4UL
+#define         HW_DES_KEY_0_REG_ADDR                   0x0208UL
+#define         HW_DES_KEY_1_REG_ADDR                   0x020CUL
+#define         HW_DES_KEY_2_REG_ADDR                   0x0210UL
+#define         HW_DES_KEY_3_REG_ADDR                   0x0214UL
+#define         HW_DES_KEY_4_REG_ADDR                   0x0218UL
+#define         HW_DES_KEY_5_REG_ADDR                   0x021CUL
+#define         HW_DES_CONTROL_0_REG_ADDR               0x0220UL
+#define         HW_DES_CONTROL_1_REG_ADDR               0x0224UL
+#define         HW_DES_IV_0_REG_ADDR                    0x0228UL
+#define         HW_DES_IV_1_REG_ADDR                    0x022CUL
+#define         HW_AES_KEY_0_ADDR_0_REG_ADDR            0x0400UL
+#define         HW_AES_KEY_0_ADDR_1_REG_ADDR            0x0404UL
+#define         HW_AES_KEY_0_ADDR_2_REG_ADDR            0x0408UL
+#define         HW_AES_KEY_0_ADDR_3_REG_ADDR            0x040cUL
+#define         HW_AES_KEY_0_ADDR_4_REG_ADDR            0x0410UL
+#define         HW_AES_KEY_0_ADDR_5_REG_ADDR            0x0414UL
+#define         HW_AES_KEY_0_ADDR_6_REG_ADDR            0x0418UL
+#define         HW_AES_KEY_0_ADDR_7_REG_ADDR            0x041cUL
+#define         HW_AES_KEY_0_REG_ADDR                   0x0400UL
+#define         HW_AES_IV_0_ADDR_0_REG_ADDR             0x0440UL
+#define         HW_AES_IV_0_ADDR_1_REG_ADDR             0x0444UL
+#define         HW_AES_IV_0_ADDR_2_REG_ADDR             0x0448UL
+#define         HW_AES_IV_0_ADDR_3_REG_ADDR             0x044cUL
+#define         HW_AES_IV_0_REG_ADDR                    0x0440UL
+#define         HW_AES_CTR1_ADDR_0_REG_ADDR             0x0460UL
+#define         HW_AES_CTR1_ADDR_1_REG_ADDR             0x0464UL
+#define         HW_AES_CTR1_ADDR_2_REG_ADDR             0x0468UL
+#define         HW_AES_CTR1_ADDR_3_REG_ADDR             0x046cUL
+#define         HW_AES_CTR1_REG_ADDR                    0x0460UL
+#define         HW_AES_SK_REG_ADDR                      0x0478UL
+#define         HW_AES_MAC_OK_REG_ADDR              0x0480UL
+#define         HW_AES_PREV_IV_0_ADDR_0_REG_ADDR        0x0490UL
+#define         HW_AES_PREV_IV_0_ADDR_1_REG_ADDR        0x0494UL
+#define         HW_AES_PREV_IV_0_ADDR_2_REG_ADDR        0x0498UL
+#define         HW_AES_PREV_IV_0_ADDR_3_REG_ADDR        0x049cUL
+#define         HW_AES_PREV_IV_0_REG_ADDR                   0x0490UL
+#define         HW_AES_CONTROL_REG_ADDR                     0x04C0UL
+#define         HW_HASH_H0_REG_ADDR                 0x0640UL
+#define         HW_HASH_H1_REG_ADDR                 0x0644UL
+#define         HW_HASH_H2_REG_ADDR                 0x0648UL
+#define         HW_HASH_H3_REG_ADDR                 0x064CUL
+#define         HW_HASH_H4_REG_ADDR                 0x0650UL
+#define         HW_HASH_H5_REG_ADDR                 0x0654UL
+#define         HW_HASH_H6_REG_ADDR                 0x0658UL
+#define         HW_HASH_H7_REG_ADDR                 0x065CUL
+#define         HW_HASH_H8_REG_ADDR                 0x0660UL
+#define         HW_HASH_H9_REG_ADDR                 0x0664UL
+#define         HW_HASH_H10_REG_ADDR                0x0668UL
+#define         HW_HASH_H11_REG_ADDR                0x066CUL
+#define         HW_HASH_H12_REG_ADDR                0x0670UL
+#define         HW_HASH_H13_REG_ADDR                0x0674UL
+#define         HW_HASH_H14_REG_ADDR                0x0678UL
+#define         HW_HASH_H15_REG_ADDR                0x067CUL
+#define         HW_HASH_CONTROL_REG_ADDR                0x07C0UL
+#define         HW_HASH_PAD_EN_REG_ADDR                 0x07C4UL
+#define         HW_HASH_PAD_CFG_REG_ADDR                0x07C8UL
+#define         HW_HASH_CUR_LEN_0_REG_ADDR      0x07CCUL
+#define         HW_HASH_CUR_LEN_1_REG_ADDR      0x07D0UL
+#define         HW_HASH_CUR_LEN_2_REG_ADDR      0x07D4UL
+#define         HW_HASH_CUR_LEN_3_REG_ADDR      0x07D8UL
+#define         HW_HASH_PARAM_REG_ADDR          0x07DCUL
+#define         HW_HASH_INT_BUSY_REG_ADDR               0x07E0UL
+#define         HW_HASH_SW_RESET_REG_ADDR               0x07E4UL
+#define         HW_HASH_ENDIANESS_REG_ADDR      0x07E8UL
+#define         HW_HASH_DATA_REG_ADDR               0x07ECUL
+#define         HW_DRNG_CONTROL_REG_ADDR                0x0800UL
+#define         HW_DRNG_VALID_REG_ADDR          0x0804UL
+#define         HW_DRNG_DATA_REG_ADDR               0x0808UL
+#define         HW_RND_SRC_EN_REG_ADDR          0x080CUL
+#define         HW_AES_CLK_ENABLE_REG_ADDR      0x0810UL
+#define         HW_DES_CLK_ENABLE_REG_ADDR      0x0814UL
+#define         HW_HASH_CLK_ENABLE_REG_ADDR     0x0818UL
+#define         HW_PKI_CLK_ENABLE_REG_ADDR      0x081CUL
+#define         HW_CLK_STATUS_REG_ADDR          0x0824UL
+#define         HW_CLK_ENABLE_REG_ADDR          0x0828UL
+#define         HW_DRNG_SAMPLE_REG_ADDR                 0x0850UL
+#define         HW_RND_SRC_CTL_REG_ADDR                 0x0858UL
+#define         HW_CRYPTO_CTL_REG_ADDR          0x0900UL
+#define         HW_CRYPTO_STATUS_REG_ADDR               0x090CUL
+#define         HW_CRYPTO_BUSY_REG_ADDR                 0x0910UL
+#define         HW_AES_BUSY_REG_ADDR                0x0914UL
+#define         HW_DES_BUSY_REG_ADDR                0x0918UL
+#define         HW_HASH_BUSY_REG_ADDR               0x091CUL
+#define         HW_CONTENT_REG_ADDR                 0x0924UL
+#define         HW_VERSION_REG_ADDR                 0x0928UL
+#define         HW_CONTEXT_ID_REG_ADDR          0x0930UL
+#define         HW_DIN_BUFFER_REG_ADDR          0x0C00UL
+#define         HW_DIN_MEM_DMA_BUSY_REG_ADDR    0x0c20UL
+#define         HW_SRC_LLI_MEM_ADDR_REG_ADDR    0x0c24UL
+#define         HW_SRC_LLI_WORD0_REG_ADDR               0x0C28UL
+#define         HW_SRC_LLI_WORD1_REG_ADDR               0x0C2CUL
+#define         HW_SRAM_SRC_ADDR_REG_ADDR               0x0c30UL
+#define         HW_DIN_SRAM_BYTES_LEN_REG_ADDR  0x0c34UL
+#define         HW_DIN_SRAM_DMA_BUSY_REG_ADDR   0x0C38UL
+#define         HW_WRITE_ALIGN_REG_ADDR                 0x0C3CUL
+#define         HW_OLD_DATA_REG_ADDR                0x0C48UL
+#define         HW_WRITE_ALIGN_LAST_REG_ADDR    0x0C4CUL
+#define         HW_DOUT_BUFFER_REG_ADDR                 0x0C00UL
+#define         HW_DST_LLI_WORD0_REG_ADDR               0x0D28UL
+#define         HW_DST_LLI_WORD1_REG_ADDR               0x0D2CUL
+#define         HW_DST_LLI_MEM_ADDR_REG_ADDR    0x0D24UL
+#define         HW_DOUT_MEM_DMA_BUSY_REG_ADDR   0x0D20UL
+#define         HW_SRAM_DEST_ADDR_REG_ADDR      0x0D30UL
+#define         HW_DOUT_SRAM_BYTES_LEN_REG_ADDR 0x0D34UL
+#define         HW_DOUT_SRAM_DMA_BUSY_REG_ADDR  0x0D38UL
+#define         HW_READ_ALIGN_REG_ADDR          0x0D3CUL
+#define         HW_READ_LAST_DATA_REG_ADDR      0x0D44UL
+#define         HW_RC4_THRU_CPU_REG_ADDR                0x0D4CUL
+#define         HW_AHB_SINGLE_REG_ADDR          0x0E00UL
+#define         HW_SRAM_DATA_REG_ADDR               0x0F00UL
+#define         HW_SRAM_ADDR_REG_ADDR               0x0F04UL
+#define         HW_SRAM_DATA_READY_REG_ADDR     0x0F08UL
+#define         HW_HOST_IRR_REG_ADDR                     0x0A00UL
+#define         HW_HOST_IMR_REG_ADDR                     0x0A04UL
+#define         HW_HOST_ICR_REG_ADDR                     0x0A08UL
+#define         HW_HOST_SEP_SRAM_THRESHOLD_REG_ADDR  0x0A10UL
+#define         HW_HOST_SEP_BUSY_REG_ADDR                    0x0A14UL
+#define         HW_HOST_SEP_LCS_REG_ADDR                     0x0A18UL
+#define         HW_HOST_CC_SW_RST_REG_ADDR               0x0A40UL
+#define         HW_HOST_SEP_SW_RST_REG_ADDR              0x0A44UL
+#define         HW_HOST_FLOW_DMA_SW_INT0_REG_ADDR        0x0A80UL
+#define         HW_HOST_FLOW_DMA_SW_INT1_REG_ADDR        0x0A84UL
+#define         HW_HOST_FLOW_DMA_SW_INT2_REG_ADDR        0x0A88UL
+#define         HW_HOST_FLOW_DMA_SW_INT3_REG_ADDR        0x0A8cUL
+#define         HW_HOST_FLOW_DMA_SW_INT4_REG_ADDR        0x0A90UL
+#define         HW_HOST_FLOW_DMA_SW_INT5_REG_ADDR        0x0A94UL
+#define         HW_HOST_FLOW_DMA_SW_INT6_REG_ADDR    0x0A98UL
+#define         HW_HOST_FLOW_DMA_SW_INT7_REG_ADDR        0x0A9cUL
+#define         HW_HOST_SEP_HOST_GPR0_REG_ADDR   0x0B00UL
+#define         HW_HOST_SEP_HOST_GPR1_REG_ADDR   0x0B04UL
+#define         HW_HOST_SEP_HOST_GPR2_REG_ADDR   0x0B08UL
+#define         HW_HOST_SEP_HOST_GPR3_REG_ADDR       0x0B0CUL
+#define         HW_HOST_HOST_SEP_GPR0_REG_ADDR       0x0B80UL
+#define         HW_HOST_HOST_SEP_GPR1_REG_ADDR       0x0B84UL
+#define         HW_HOST_HOST_SEP_GPR2_REG_ADDR       0x0B88UL
+#define         HW_HOST_HOST_SEP_GPR3_REG_ADDR       0x0B8CUL
+#define         HW_HOST_HOST_ENDIAN_REG_ADDR         0x0B90UL
+#define         HW_HOST_HOST_COMM_CLK_EN_REG_ADDR        0x0B94UL
+#define         HW_CLR_SRAM_BUSY_REG_REG_ADDR        0x0F0CUL
  #define    HW_CC_SRAM_BASE_ADDRESS              0x5800UL

-#endif                         /* ifndef HW_DEFS */
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* ifndef HW_DEFS */
--
1.6.0.4

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252ACorsmsx501amrc_
Content-Type: text/x-diff;
	name="0001-staging-sep-header-file-updates-for-12-09-software.patch"
Content-Description: 0001-staging-sep-header-file-updates-for-12-09-software.patch
Content-Disposition: attachment;
	filename="0001-staging-sep-header-file-updates-for-12-09-software.patch";
	size=69995; creation-date="Wed, 28 Apr 2010 14:51:17 GMT";
	modification-date="Wed, 28 Apr 2010 14:51:17 GMT"
Content-ID: <alpine.DEB.2.00.1004281449370.24448@localhost.localdomain>
Content-Transfer-Encoding: base64

RnJvbSBlYTY3ZjY5ZTcwZTVhOGM2ZTUwZGIzZjFkOGI2MmNkNTJkODE2YmM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogTWFyayBBbGx5biA8bWFyay5hLmFsbHluQGludGVsLmNvbT4N
CkRhdGU6IFdlZCwgMjggQXByIDIwMTAgMTQ6MzM6MTYgLTA3MDANClN1YmplY3Q6IFJGQyBbUEFU
Q0ggMS80XSBzdGFnaW5nOiBzZXA6IGhlYWRlciBmaWxlIHVwZGF0ZXMgZm9yIDEyLzA5IHNvZnR3
YXJlIHJlbGVhc2UNCg0KU2lnbmVkLW9mZi1ieTogTWFyayBBLiBBbGx5biA8bWFyay5hLmFsbHlu
QGludGVsLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy9zZXAvc2VwX2Rldi5oICAgICAgICAg
ICAgfCAgMTEwIC0tLS0tDQogZHJpdmVycy9zdGFnaW5nL3NlcC9zZXBfZHJpdmVyX2FwaS5oICAg
ICB8ICA3NjkgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tDQogZHJpdmVycy9zdGFnaW5n
L3NlcC9zZXBfZHJpdmVyX2NvbmZpZy5oICB8ICAxNDAgKysrKy0tDQogZHJpdmVycy9zdGFnaW5n
L3NlcC9zZXBfZHJpdmVyX2V4dF9hcGkuaCB8ICAxMjcgKysrKysNCiBkcml2ZXJzL3N0YWdpbmcv
c2VwL3NlcF9kcml2ZXJfaHdfZGVmcy5oIHwgIDQyNiArKysrKysrKystLS0tLS0tLQ0KIDUgZmls
ZXMgY2hhbmdlZCwgOTIxIGluc2VydGlvbnMoKyksIDY1MSBkZWxldGlvbnMoLSkNCiBkZWxldGUg
bW9kZSAxMDA2NDQgZHJpdmVycy9zdGFnaW5nL3NlcC9zZXBfZGV2LmgNCiBjcmVhdGUgbW9kZSAx
MDA2NDQgZHJpdmVycy9zdGFnaW5nL3NlcC9zZXBfZHJpdmVyX2V4dF9hcGkuaA0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3NlcC9zZXBfZGV2LmggYi9kcml2ZXJzL3N0YWdpbmcvc2Vw
L3NlcF9kZXYuaA0KZGVsZXRlZCBmaWxlIG1vZGUgMTAwNjQ0DQppbmRleCA5MjAwNTI0Li4wMDAw
MDAwDQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvc2VwL3NlcF9kZXYuaA0KKysrIC9kZXYvbnVsbA0K
QEAgLTEsMTEwICswLDAgQEANCi0jaWZuZGVmIF9fU0VQX0RFVl9IX18NCi0jZGVmaW5lIF9fU0VQ
X0RFVl9IX18NCi0NCi0vKg0KLSAqDQotICogIHNlcF9kZXYuaCAtIFNlY3VyaXR5IFByb2Nlc3Nv
ciBEZXZpY2UgU3RydWN0dXJlcw0KLSAqDQotICogIENvcHlyaWdodChjKSAyMDA5IEludGVsIENv
cnBvcmF0aW9uLiBBbGwgcmlnaHRzIHJlc2VydmVkLg0KLSAqICBDb3B5cmlnaHQoYykgMjAwOSBE
aXNjcmV0aXguIEFsbCByaWdodHMgcmVzZXJ2ZWQuDQotICoNCi0gKiAgVGhpcyBwcm9ncmFtIGlz
IGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkgaXQN
Ci0gKiAgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBh
cyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUNCi0gKiAgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVy
IHZlcnNpb24gMiBvZiB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKQ0KLSAqICBhbnkg
bGF0ZXIgdmVyc2lvbi4NCi0gKg0KLSAqICBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4g
dGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwgYnV0IFdJVEhPVVQNCi0gKiAgQU5ZIFdB
UlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YgTUVSQ0hBTlRBQklM
SVRZIG9yDQotICogIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3INCi0gKiAgbW9yZSBkZXRhaWxzLg0KLSAqDQot
ICogIFlvdSBzaG91bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1
YmxpYyBMaWNlbnNlIGFsb25nIHdpdGgNCi0gKiAgdGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRl
IHRvIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24sIEluYy4sIDU5DQotICogIFRlbXBsZSBQ
bGFjZSAtIFN1aXRlIDMzMCwgQm9zdG9uLCBNQSAgMDIxMTEtMTMwNywgVVNBLg0KLSAqDQotICog
IENPTlRBQ1RTOg0KLSAqDQotICogIEFsYW4gQ294CQlhbGFuQGxpbnV4LmludGVsLmNvbQ0KLSAq
DQotICovDQotDQotc3RydWN0IHNlcF9kZXZpY2Ugew0KLQkvKiBwb2ludGVyIHRvIHBjaSBkZXYg
Ki8NCi0Jc3RydWN0IHBjaV9kZXYgKnBkZXY7DQotDQotCXVuc2lnbmVkIGxvbmcgaW5fdXNlOw0K
LQ0KLQkvKiBhZGRyZXNzIG9mIHRoZSBzaGFyZWQgbWVtb3J5IGFsbG9jYXRlZCBkdXJpbmcgaW5p
dCBmb3IgU0VQIGRyaXZlcg0KLQkgICAoY29oZXJlbnQgYWxsb2MpICovDQotCXZvaWQgKnNoYXJl
ZF9hZGRyOw0KLQkvKiB0aGUgcGh5c2ljYWwgYWRkcmVzcyBvZiB0aGUgc2hhcmVkIGFyZWEgKi8N
Ci0JZG1hX2FkZHJfdCBzaGFyZWRfYnVzOw0KLQ0KLQkvKiByZXN0cmljdGVkIGFjY2VzcyByZWdp
b24gKGNvaGVyZW50IGFsbG9jKSAqLw0KLQlkbWFfYWRkcl90IHJhcl9idXM7DQotCXZvaWQgKnJh
cl9hZGRyOw0KLQkvKiBmaXJtd2FyZSByZWdpb25zOiBjYWNoZSBpcyBhdCByYXJfYWRkciAqLw0K
LQl1bnNpZ25lZCBsb25nIGNhY2hlX3NpemU7DQotDQotCS8qIGZvbGxvd3MgdGhlIGNhY2hlICov
DQotCWRtYV9hZGRyX3QgcmVzaWRlbnRfYnVzOw0KLQl1bnNpZ25lZCBsb25nIHJlc2lkZW50X3Np
emU7DQotCXZvaWQgKnJlc2lkZW50X2FkZHI7DQotDQotCS8qIHN0YXJ0IGFkZHJlc3Mgb2YgdGhl
IGFjY2VzcyB0byB0aGUgU0VQIHJlZ2lzdGVycyBmcm9tIGRyaXZlciAqLw0KLQl2b2lkIF9faW9t
ZW0gKnJlZ19hZGRyOw0KLQkvKiB0cmFuc2FjdGlvbiBjb3VudGVyIHRoYXQgY29vcmRpbmF0ZXMg
dGhlIHRyYW5zYWN0aW9ucyBiZXR3ZWVuIFNFUCBhbmQgSE9TVCAqLw0KLQl1bnNpZ25lZCBsb25n
IHNlbmRfY3Q7DQotCS8qIGNvdW50ZXIgZm9yIHRoZSBtZXNzYWdlcyBmcm9tIHNlcCAqLw0KLQl1
bnNpZ25lZCBsb25nIHJlcGx5X2N0Ow0KLQkvKiBjb3VudGVyIGZvciB0aGUgbnVtYmVyIG9mIGJ5
dGVzIGFsbG9jYXRlZCBpbiB0aGUgcG9vbCBmb3IgdGhlIGN1cnJlbnQNCi0JICAgdHJhbnNhY3Rp
b24gKi8NCi0JdW5zaWduZWQgbG9uZyBkYXRhX3Bvb2xfYnl0ZXNfYWxsb2NhdGVkOw0KLQ0KLQkv
KiBhcnJheSBvZiBwb2ludGVycyB0byB0aGUgcGFnZXMgdGhhdCByZXByZXNlbnQgaW5wdXQgZGF0
YSBmb3IgdGhlIHN5bmNocm9uaWMNCi0JICAgRE1BIGFjdGlvbiAqLw0KLQlzdHJ1Y3QgcGFnZSAq
KmluX3BhZ2VfYXJyYXk7DQotDQotCS8qIGFycmF5IG9mIHBvaW50ZXJzIHRvIHRoZSBwYWdlcyB0
aGF0IHJlcHJlc2VudCBvdXQgZGF0YSBmb3IgdGhlIHN5bmNocm9uaWMNCi0JICAgRE1BIGFjdGlv
biAqLw0KLQlzdHJ1Y3QgcGFnZSAqKm91dF9wYWdlX2FycmF5Ow0KLQ0KLQkvKiBudW1iZXIgb2Yg
cGFnZXMgaW4gdGhlIHNlcF9pbl9wYWdlX2FycmF5ICovDQotCXVuc2lnbmVkIGxvbmcgaW5fbnVt
X3BhZ2VzOw0KLQ0KLQkvKiBudW1iZXIgb2YgcGFnZXMgaW4gdGhlIHNlcF9vdXRfcGFnZV9hcnJh
eSAqLw0KLQl1bnNpZ25lZCBsb25nIG91dF9udW1fcGFnZXM7DQotDQotCS8qIGdsb2JhbCBkYXRh
IGZvciBldmVyeSBmbG93ICovDQotCXN0cnVjdCBzZXBfZmxvd19jb250ZXh0X3QgZmxvd3NbU0VQ
X0RSSVZFUl9OVU1fRkxPV1NdOw0KLQ0KLQkvKiBwb2ludGVyIHRvIHRoZSB3b3JrcXVldWUgdGhh
dCBoYW5kbGVzIHRoZSBmbG93IGRvbmUgaW50ZXJydXB0cyAqLw0KLQlzdHJ1Y3Qgd29ya3F1ZXVl
X3N0cnVjdCAqZmxvd193cTsNCi0NCi19Ow0KLQ0KLXN0YXRpYyBzdHJ1Y3Qgc2VwX2RldmljZSAq
c2VwX2RldjsNCi0NCi1zdGF0aWMgaW5saW5lIHZvaWQgc2VwX3dyaXRlX3JlZyhzdHJ1Y3Qgc2Vw
X2RldmljZSAqZGV2LCBpbnQgcmVnLCB1MzIgdmFsdWUpDQotew0KLQl2b2lkIF9faW9tZW0gKmFk
ZHIgPSBkZXYtPnJlZ19hZGRyICsgcmVnOw0KLQl3cml0ZWwodmFsdWUsIGFkZHIpOw0KLX0NCi0N
Ci1zdGF0aWMgaW5saW5lIHUzMiBzZXBfcmVhZF9yZWcoc3RydWN0IHNlcF9kZXZpY2UgKmRldiwg
aW50IHJlZykNCi17DQotCXZvaWQgX19pb21lbSAqYWRkciA9IGRldi0+cmVnX2FkZHIgKyByZWc7
DQotCXJldHVybiByZWFkbChhZGRyKTsNCi19DQotDQotLyogd2FpdCBmb3IgU1JBTSB3cml0ZSBj
b21wbGV0ZShpbmRpcmVjdCB3cml0ZSAqLw0KLXN0YXRpYyBpbmxpbmUgdm9pZCBzZXBfd2FpdF9z
cmFtX3dyaXRlKHN0cnVjdCBzZXBfZGV2aWNlICpkZXYpDQotew0KLQl1MzIgcmVnX3ZhbDsNCi0J
ZG8NCi0JCXJlZ192YWwgPSBzZXBfcmVhZF9yZWcoZGV2LCBIV19TUkFNX0RBVEFfUkVBRFlfUkVH
X0FERFIpOw0KLQl3aGlsZSAoIShyZWdfdmFsICYgMSkpOw0KLX0NCi0NCi0NCi0jZW5kaWYNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvc2VwL3NlcF9kcml2ZXJfYXBpLmggYi9kcml2ZXJz
L3N0YWdpbmcvc2VwL3NlcF9kcml2ZXJfYXBpLmgNCmluZGV4IDM4MzU0M2QuLjA1ZWMwNDggMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvc2VwL3NlcF9kcml2ZXJfYXBpLmgNCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy9zZXAvc2VwX2RyaXZlcl9hcGkuaA0KQEAgLTEsMjMgKzEsMjkgQEANCi0v
Kg0KLSAqDQotICogIHNlcF9kcml2ZXJfYXBpLmggLSBTZWN1cml0eSBQcm9jZXNzb3IgRHJpdmVy
IGFwaSBkZWZpbml0aW9ucw0KLSAqDQotICogIENvcHlyaWdodChjKSAyMDA5IEludGVsIENvcnBv
cmF0aW9uLiBBbGwgcmlnaHRzIHJlc2VydmVkLg0KLSAqICBDb3B5cmlnaHQoYykgMjAwOSBEaXNj
cmV0aXguIEFsbCByaWdodHMgcmVzZXJ2ZWQuDQotICoNCi0gKiAgVGhpcyBwcm9ncmFtIGlzIGZy
ZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkgaXQNCi0g
KiAgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBw
dWJsaXNoZWQgYnkgdGhlIEZyZWUNCi0gKiAgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZl
cnNpb24gMiBvZiB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKQ0KLSAqICBhbnkgbGF0
ZXIgdmVyc2lvbi4NCisgLyoNCisgKiAgIHNlcF9kcml2ZXJfYXBpLmgNCiAgKg0KLSAqICBUaGlz
IHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1
bCwgYnV0IFdJVEhPVVQNCi0gKiAgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxp
ZWQgd2FycmFudHkgb2YgTUVSQ0hBTlRBQklMSVRZIG9yDQotICogIEZJVE5FU1MgRk9SIEEgUEFS
VElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IN
Ci0gKiAgbW9yZSBkZXRhaWxzLg0KLSAqDQotICogIFlvdSBzaG91bGQgaGF2ZSByZWNlaXZlZCBh
IGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFsb25nIHdpdGgNCi0gKiAg
dGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRlIHRvIHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRp
b24sIEluYy4sIDU5DQotICogIFRlbXBsZSBQbGFjZSAtIFN1aXRlIDMzMCwgQm9zdG9uLCBNQSAg
MDIxMTEtMTMwNywgVVNBLg0KKyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KKyAqICAgQ29weXJpZ2h0IDIw
MDkgwqkgRGlzY3JldGl4IFRlY2hub2xvZ2llcyBMdGQuICAgICAgICAgICAgICAgICAgICAgICAg
ICAqDQorICogICBDb3B5cmlnaHQgMjAwOSDCqSBJbnRlbCBDb3Jwb3JhdGlvbiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICoNCisgKiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqDQorICogICBU
aGlzIHNvZnR3YXJlIGlzIHByb3RlY3RlZCBieSBjb3B5cmlnaHQsIGludGVybmF0aW9uYWwgdHJl
YXRpZXMgYW5kICAgKg0KKyAqICAgdmFyaW91cyBwYXRlbnRzLiBBbnkgY29weSBvciByZXByb2R1
Y3Rpb24gb2YgdGhpcyBTb2Z0d2FyZSBhcyAgICAgICAgICoNCisgKiAgIHBlcm1pdHRlZCBiZWxv
dywgbXVzdCBpbmNsdWRlIHRoaXMgQ29weXJpZ2h0IE5vdGljZSBhcyB3ZWxsIGFzIGFueSAgICAq
DQorICogICBvdGhlciBub3RpY2VzIHByb3ZpZGVkIHVuZGVyIHN1Y2ggbGljZW5zZS4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgKg0KKyAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoNCisgKiAgIFRoaXMg
cHJvZ3JhbSBzaGFsbCBiZSBnb3Zlcm5lZCBieSwgYW5kIG1heSBiZSB1c2VkIGFuZCByZWRpc3Ry
aWJ1dGVkICAqDQorICogICB1bmRlciB0aGUgdGVybXMgYW5kIGNvbmRpdGlvbnMgb2YgdGhlIEdO
VSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlLCAgICAgKg0KKyAqICAgdmVyc2lvbiAyLCBhcyBwdWJs
aXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbi4gICAgICAgICAgICAgICoNCisg
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqDQorICogICBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4g
dGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwgICAgICAgKg0KKyAqICAgYnV0IFdJVEhP
VVQgQU5ZIGxpYWJpbGl0eSBhbmQgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCAg
ICAgICoNCisgKiAgIHdhcnJhbnR5IG9mIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBB
IFBBUlRJQ1VMQVIgUFVSUE9TRS4gICAgICAqDQorICogICBTZWUgdGhlIEdOVSBHZW5lcmFsIFB1
YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuICAgICAgICAgICAgICAgICAgKg0KKyAqICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICoNCisgKiAgIFlvdSBzaG91bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2Yg
dGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlICAgICAqDQorICogICBhbG9uZyB3aXRoIHRo
aXMgcHJvZ3JhbTsgaWYgbm90LCBwbGVhc2Ugd3JpdGUgdG8gdGhlIEZyZWUgU29mdHdhcmUgICAg
Kg0KKyAqICAgRm91bmRhdGlvbiwgSW5jLiwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICoNCisgKiAgIDU5IFRlbXBsZSBQbGFjZSAtIFN1aXRlIDMz
MCwgQm9zdG9uLCBNQSAgMDIxMTEtMTMwNywgVVNBLiAgICAgICAgICAgICAqDQorICoqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqDQogICoNCiAgKiAgQ09OVEFDVFM6DQogICoNCkBAIC0yNSw0MDEgKzMxLDU3NiBA
QA0KICAqDQogICogIENIQU5HRVM6DQogICoNCi0gKiAgMjAwOS4wNi4yNglJbml0aWFsIHB1Ymxp
c2gNCisgKiAgMjAxMC4wMS4wOAlJbml0aWFsIHB1Ymxpc2gNCiAgKg0KICAqLw0KLQ0KICNpZm5k
ZWYgX19TRVBfRFJJVkVSX0FQSV9IX18NCiAjZGVmaW5lIF9fU0VQX0RSSVZFUl9BUElfSF9fDQog
DQorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4NCisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQor
I2luY2x1ZGUgPGxpbnV4L2ZzLmg+DQorI2luY2x1ZGUgPGxpbnV4L2NkZXYuaD4NCisjaW5jbHVk
ZSA8bGludXgva2Rldl90Lmg+DQorI2luY2x1ZGUgPGxpbnV4L211dGV4Lmg+DQorI2luY2x1ZGUg
PGxpbnV4L21tLmg+DQorI2luY2x1ZGUgPGxpbnV4L3BvbGwuaD4NCisjaW5jbHVkZSA8bGludXgv
d2FpdC5oPg0KIA0KKy8qLS0tLS0tLS0tLS0tLS0tLS0NCisgICAgREVGSU5FDQorLS0tLS0tLS0t
LS0tLS0tLS0tLSovDQogDQotLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQotICBJT0NUTCBjb21tYW5kIGRlZmluZXMNCi0g
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tKi8NCisjZGVmaW5lIFNFUF9EUklWRVJfU1JDX1JFUExZICAgIDENCisjZGVmaW5l
IFNFUF9EUklWRVJfU1JDX1JFUSAgICAgIDINCisjZGVmaW5lIFNFUF9EUklWRVJfU1JDX1BSSU5U
RiAgIDMNCiANCi0vKiBtYWdpYyBudW1iZXIgMSBvZiB0aGUgc2VwIElPQ1RMIGNvbW1hbmQgKi8N
Ci0jZGVmaW5lIFNFUF9JT0NfTUFHSUNfTlVNQkVSICAgICAgICAgICAgICAgICAgICAgICAgICAg
J3MnDQogDQotLyogc2VuZHMgaW50ZXJydXB0IHRvIHNlcCB0aGF0IG1lc3NhZ2UgaXMgcmVhZHkg
Ki8NCi0jZGVmaW5lIFNFUF9JT0NTRU5EU0VQQ09NTUFORCAgICAgICAgICAgICAgICAgX0lPKFNF
UF9JT0NfTUFHSUNfTlVNQkVSICwgMCkNCiANCi0vKiBzZW5kcyBpbnRlcnJ1cHQgdG8gc2VwIHRo
YXQgbWVzc2FnZSBpcyByZWFkeSAqLw0KLSNkZWZpbmUgU0VQX0lPQ1NFTkRTRVBSUExZQ09NTUFO
RCAgICAgICAgICAgICBfSU8oU0VQX0lPQ19NQUdJQ19OVU1CRVIgLCAxKQ0KKy8qLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKyAgICBUWVBFREVGUw0KKy0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KIA0KLS8qIGFsbG9j
YXRlIG1lbW9yeSBpbiBkYXRhIHBvb2wgKi8NCi0jZGVmaW5lIFNFUF9JT0NBTExPQ0RBVEFQT0xM
ICAgICAgICAgICAgICAgICAgX0lPKFNFUF9JT0NfTUFHSUNfTlVNQkVSICwgMikNCisvKg0KKyAg
aW5pdCBjb21tYW5kIHN0cnVjdA0KKyovDQorc3RydWN0IHNlcF9kcml2ZXJfaW5pdF90IHsNCisg
IC8qIHN0YXJ0IG9mIHRoZSAxRyBvZiB0aGUgaG9zdCBtZW1vcnkgYWRkcmVzcyB0aGF0IFNFUCBj
YW4gYWNjZXNzICovDQorICB1MzIgKm1lc3NhZ2VfYWRkcjsNCiANCi0vKiB3cml0ZSB0byBwcmUt
YWxsb2NhdGVkICBtZW1vcnkgaW4gZGF0YSBwb29sICovDQotI2RlZmluZSBTRVBfSU9DV1JJVEVE
QVRBUE9MTCAgICAgICAgICAgICAgICAgIF9JTyhTRVBfSU9DX01BR0lDX05VTUJFUiAsIDMpDQor
ICAvKiBzdGFydCBhZGRyZXNzIG9mIHJlc2lkZW50ICovDQorICB1MzIgICBtZXNzYWdlX3NpemVf
aW5fd29yZHM7DQogDQotLyogcmVhZCBmcm9tICBwcmUtYWxsb2NhdGVkICBtZW1vcnkgaW4gZGF0
YSBwb29sICovDQotI2RlZmluZSBTRVBfSU9DUkVBRERBVEFQT0xMICAgICAgICAgICAgICAgICAg
IF9JTyhTRVBfSU9DX01BR0lDX05VTUJFUiAsIDQpDQorICAvKiBvZmZzZXQgb2YgdGhlIGluaXQg
bWVzc2FnZSBpbiB0aGUgc2VwIHNyYW0gKi8NCisgIHUzMiAgIHNlcF9zcmFtX2FkZHI7DQorfTsN
CiANCi0vKiBjcmVhdGUgc3ltIGRtYSBsbGkgdGFibGVzICovDQotI2RlZmluZSBTRVBfSU9DQ1JF
QVRFU1lNRE1BVEFCTEUgICAgICAgICAgICAgIF9JTyhTRVBfSU9DX01BR0lDX05VTUJFUiAsIDUp
DQogDQotLyogY3JlYXRlIGZsb3cgZG1hIGxsaSB0YWJsZXMgKi8NCi0jZGVmaW5lIFNFUF9JT0ND
UkVBVEVGTE9XRE1BVEFCTEUgICAgICAgICAgICAgX0lPKFNFUF9JT0NfTUFHSUNfTlVNQkVSICwg
NikNCisvKg0KKyAgcmVhbGxvYyBjYWNoZSByZXNpZGVudCBjb21tYW5kDQorKi8NCitzdHJ1Y3Qg
c2VwX2RyaXZlcl9yZWFsbG9jX2NhY2hlX3Jlc2lkZW50X3Qgew0KKyAgLyogYmFzZSBhZGRyZXNz
ICovDQorICB2b2lkICAqYmFzZV9hZGRyOw0KIA0KLS8qIGZyZWUgZHluYW1pYyBkYXRhIGFhbG9j
YXRlZCBkdXJpbmcgdGFibGUgY3JlYXRpb24gKi8NCi0jZGVmaW5lIFNFUF9JT0NGUkVFRE1BVEFC
TEVEQVRBICAgICAgICAgICAgICAgIF9JTyhTRVBfSU9DX01BR0lDX05VTUJFUiAsIDcpDQorICAv
KiBjdXJyZW50IGNhY2hlIGFkZHJlc3MgKi8NCisgIHZvaWQgICpjYWNoZV9hZGRyOw0KIA0KLS8q
IGdldCB0aGUgc3RhdGljIHBvb2wgYXJlYSBhZGRlcnNzZXMgKHBoeXNpY2FsIGFuZCB2aXJ0dWFs
KSAqLw0KLSNkZWZpbmUgU0VQX0lPQ0dFVFNUQVRJQ1BPT0xBRERSICAgICAgICAgICAgICAgX0lP
KFNFUF9JT0NfTUFHSUNfTlVNQkVSICwgOCkNCisgIC8qIGNhY2hlIHNpemUgaW4gYnl0ZXMqLw0K
KyAgdTMyICAgY2FjaGVfc2l6ZV9pbl9ieXRlczsNCiANCi0vKiBzZXQgZmxvdyBpZCBjb21tYW5k
ICovDQotI2RlZmluZSBTRVBfSU9DU0VURkxPV0lEICAgICAgICAgICAgICAgICAgICAgICBfSU8o
U0VQX0lPQ19NQUdJQ19OVU1CRVIgLCA5KQ0KKyAgLyogY3VycmVudCByZXNpZGVudCBhZGRyZXNz
ICovDQorICB2b2lkICAqcmVzaWRlbnRfYWRkcjsNCiANCi0vKiBhZGQgdGFibGVzIHRvIHRoZSBk
eW5hbWljIGZsb3cgKi8NCi0jZGVmaW5lIFNFUF9JT0NBRERGTE9XVEFCTEUgICAgICAgICAgICAg
ICAgICAgIF9JTyhTRVBfSU9DX01BR0lDX05VTUJFUiAsIDEwKQ0KKyAgLyogcmVzaWRlbnQgc2l6
ZSBpbiBieXRlcyovDQorICB1MzIgICByZXNpZGVudF9zaXplX2luX2J5dGVzOw0KIA0KLS8qIGFk
ZCBmbG93IGFkZCB0YWJsZXMgbWVzc2FnZSAqLw0KLSNkZWZpbmUgU0VQX0lPQ0FEREZMT1dNRVNT
QUdFICAgICAgICAgICAgICAgICAgX0lPKFNFUF9JT0NfTUFHSUNfTlVNQkVSICwgMTEpDQorICAv
KiBjdXJyZW50IGRjYWNoZSBhZGRyZXNzICovDQorICB2b2lkICAqZGNhY2hlX2FkZHI7DQogDQot
Lyogc3RhcnQgc2VwIGNvbW1hbmQgKi8NCi0jZGVmaW5lIFNFUF9JT0NTRVBTVEFSVCAgICAgICAg
ICAgICAgICAgICAgICAgIF9JTyhTRVBfSU9DX01BR0lDX05VTUJFUiAsIDEyKQ0KKyAgLyogcmVz
aWRlbnQgc2l6ZSBpbiBieXRlcyovDQorICB1MzIgICBkY2FjaGVfc2l6ZV9pbl9ieXRlczsNCiAN
Ci0vKiBpbml0IHNlcCBjb21tYW5kICovDQotI2RlZmluZSBTRVBfSU9DU0VQSU5JVCAgICAgICAg
ICAgICAgICAgICAgICAgICBfSU8oU0VQX0lPQ19NQUdJQ19OVU1CRVIgLCAxMykNCisgIC8qIGV4
dCBjYWNoZSBjdXJyZW50IGFkZHJlc3MgKi8NCisgIHZvaWQgICpleHRjYWNoZV9hZGRyOw0KIA0K
LS8qIGVuZCB0cmFuc2FjdGlvbiBjb21tYW5kICovDQotI2RlZmluZSBTRVBfSU9DRU5EVFJBTlNB
Q1RJT04gICAgICAgICAgICAgICAgICBfSU8oU0VQX0lPQ19NQUdJQ19OVU1CRVIgLCAxNSkNCisg
IC8qIGV4dCBjYWNoZSBzaXplIGluIGJ5dGVzKi8NCisgIHUzMiAgIGV4dGNhY2hlX3NpemVfaW5f
Ynl0ZXM7DQogDQotLyogcmVhbGxvY2F0ZSBjYWNoZSBhbmQgcmVzaWRlbnQgKi8NCi0jZGVmaW5l
IFNFUF9JT0NSRUFMTE9DQ0FDSEVSRVMgICAgICAgICAgICAgICAgIF9JTyhTRVBfSU9DX01BR0lD
X05VTUJFUiAsIDE2KQ0KKyAgLyogbmV3IGNhY2hlIGFkZHJlc3MgKi8NCisgIGRtYV9hZGRyX3Qg
ICBuZXdfY2FjaGVfYWRkcjsNCiANCi0vKiBnZXQgdGhlIG9mZnNldCBvZiB0aGUgYWRkcmVzcyBz
dGFydGluZyBmcm9tIHRoZSBiZWdpbm5uaWcgb2YgdGhlIG1hcCBhcmVhICovDQotI2RlZmluZSBT
RVBfSU9DR0VUTUFQUEVEQUREUk9GRlNFVCAgICAgICAgICAgICBfSU8oU0VQX0lPQ19NQUdJQ19O
VU1CRVIgLCAxNykNCisgIC8qIG5ldyByZXNpZGVudCBhZGRyZXNzICovDQorICBkbWFfYWRkcl90
ICAgbmV3X3Jlc2lkZW50X2FkZHI7DQogDQotLyogZ2V0IHRpbWUgYWRkcmVzcyBhbmQgdmFsdWUg
Ki8NCi0jZGVmaW5lIFNFUF9JT0NHRVRJTUUgICAgICAgICAgICAgICAgICAgICAgICAgIF9JTyhT
RVBfSU9DX01BR0lDX05VTUJFUiAsIDE5KQ0KKyAgLyogbmV3IGRjYWNoZSBhZGRyZXNzICovDQor
ICBkbWFfYWRkcl90ICAgbmV3X2RjYWNoZV9hZGRyOw0KIA0KLS8qLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KLSAgICBUWVBFREVGUw0KLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KKyAgLyogbmV3IHJlc2lkZW50IGFk
ZHJlc3MgKi8NCisgIGRtYV9hZGRyX3QgICBuZXdfc2hhcmVkX2FyZWFfYWRkcjsNCiANCi0vKg0K
LSAgaW5pdCBjb21tYW5kIHN0cnVjdA0KLSovDQotc3RydWN0IHNlcF9kcml2ZXJfaW5pdF90IHsN
Ci0JLyogc3RhcnQgb2YgdGhlIDFHIG9mIHRoZSBob3N0IG1lbW9yeSBhZGRyZXNzIHRoYXQgU0VQ
IGNhbiBhY2Nlc3MgKi8NCi0JdW5zaWduZWQgbG9uZyBtZXNzYWdlX2FkZHI7DQorICAvKiBuZXcg
YmFzZSBhZGRyZXNzICovDQorICBkbWFfYWRkcl90ICAgbmV3X2Jhc2VfYWRkcjsNCit9Ow0KKw0K
Kw0KK3N0cnVjdCBzZXBfZHJpdmVyX3JlYWxsb2NfZXh0X2NhY2hlX3Qgew0KKyAgLyogY3VycmVu
dCBleHRlcm5hbCBjYWNoZSBhZGRyZXNzICovDQorICB2b2lkICAqZXh0X2NhY2hlX2FkZHI7DQor
DQorICAvKiBleHRlcm5hbCBjYWNoZSBzaXplIGluIGJ5dGVzKi8NCisgIHUzMiAgIGV4dF9jYWNo
ZV9zaXplX2luX2J5dGVzOw0KIA0KLQkvKiBzdGFydCBhZGRyZXNzIG9mIHJlc2lkZW50ICovDQot
CXVuc2lnbmVkIGxvbmcgbWVzc2FnZV9zaXplX2luX3dvcmRzOw0KKyAgLyogbmV3IGV4dGVybmFs
IGNhY2hlIGFkZHJlc3MgKi8NCisgIGRtYV9hZGRyX3QgICBuZXdfZXh0X2NhY2hlX2FkZHI7DQog
DQogfTsNCiANCitzdHJ1Y3Qgc2VwX2RyaXZlcl9hbGxvY190IHsNCisgIC8qIHZpcnR1YWwgYWRk
cmVzcyBvZiBhbGxvY2F0ZWQgc3BhY2UgKi8NCisgIHUzMiBvZmZzZXQ7DQorDQorICAvKiBwaHlz
aWNhbCBhZGRyZXNzIG9mIGFsbG9jYXRlZCBzcGFjZSAqLw0KKyAgZG1hX2FkZHJfdCBidXNfYWRk
cmVzczsNCisNCisgIC8qIG51bWJlciBvZiBieXRlcyB0byBhbGxvY2F0ZSAqLw0KKyAgdTMyIG51
bV9ieXRlczsNCit9Ow0KIA0KIC8qDQotICByZWFsbG9jIGNhY2hlIHJlc2lkZW50IGNvbW1hbmQN
CiAqLw0KLXN0cnVjdCBzZXBfZHJpdmVyX3JlYWxsb2NfY2FjaGVfcmVzaWRlbnRfdCB7DQotCS8q
IG5ldyBjYWNoZSBhZGRyZXNzICovDQotCXU2NCBuZXdfY2FjaGVfYWRkcjsNCi0JLyogbmV3IHJl
c2lkZW50IGFkZHJlc3MgKi8NCi0JdTY0IG5ld19yZXNpZGVudF9hZGRyOw0KLQkvKiBuZXcgcmVz
aWRlbnQgYWRkcmVzcyAqLw0KLQl1NjQgIG5ld19zaGFyZWRfYXJlYV9hZGRyOw0KLQkvKiBuZXcg
YmFzZSBhZGRyZXNzICovDQotCXU2NCBuZXdfYmFzZV9hZGRyOw0KK3N0cnVjdCBzZXBfZHJpdmVy
X2J1aWxkX3N5bmNfdGFibGVfdCB7DQorICAvKiBhZGRyZXNzIHZhbHVlIG9mIHRoZSBkYXRhIGlu
ICovDQorICB1bnNpZ25lZCBsb25nICBhcHBfaW5fYWRkcmVzczsNCisNCisgIC8qIHNpemUgb2Yg
ZGF0YSBpbiAqLw0KKyAgdTMyICBkYXRhX2luX3NpemU7DQorDQorICAvKiBhZGRyZXNzIG9mIHRo
ZSBkYXRhIG91dCAqLw0KKyAgdW5zaWduZWQgbG9uZyAgYXBwX291dF9hZGRyZXNzOw0KKw0KKyAg
LyogdGhlIHNpemUgb2YgdGhlIGJsb2NrIG9mIHRoZSBvcGVyYXRpb24gLSBpZiBuZWVkZWQsDQor
ICBldmVyeSB0YWJsZSB3aWxsIGJlIG1vZHVsbyB0aGlzIHBhcmFtZXRlciAqLw0KKyAgdTMyICBi
bG9ja19zaXplOw0KKw0KKyAgLyogdGhlIHBoeXNpY2FsIGFkZHJlc3Mgb2YgdGhlIGZpcnN0IGlu
cHV0IERNQSB0YWJsZSAqLw0KKyAgZG1hX2FkZHJfdCAgaW5fdGFibGVfYWRkcmVzczsNCisNCisg
IC8qIG51bWJlciBvZiBlbnRyaWVzIGluIHRoZSBmaXJzdCBpbnB1dCBETUEgdGFibGUgKi8NCisg
IHUzMiAgaW5fdGFibGVfbnVtX2VudHJpZXM7DQorDQorICAvKiB0aGUgcGh5c2ljYWwgYWRkcmVz
cyBvZiB0aGUgZmlyc3Qgb3V0cHV0IERNQSB0YWJsZSAqLw0KKyAgZG1hX2FkZHJfdCAgb3V0X3Rh
YmxlX2FkZHJlc3M7DQorDQorICAvKiBudW1iZXIgb2YgZW50cmllcyBpbiB0aGUgZmlyc3Qgb3V0
cHV0IERNQSB0YWJsZSAqLw0KKyAgdTMyICBvdXRfdGFibGVfbnVtX2VudHJpZXM7DQorDQorICAv
KiBkYXRhIGluIHRoZSBmaXJzdCBpbnB1dCB0YWJsZSAqLw0KKyAgdTMyICB0YWJsZV9kYXRhX3Np
emU7DQorDQorICAvKiBkaXN0aW5jdCB1c2VyL2tlcm5lbCBsYXlvdXQgKi8NCisgIGJvb2wgaXNL
ZXJuZWxWaXJ0dWFsQWRkcmVzczsNCisNCiB9Ow0KIA0KLXN0cnVjdCBzZXBfZHJpdmVyX2FsbG9j
X3Qgew0KLQkvKiB2aXJ0dWFsIGFkZHJlc3Mgb2YgYWxsb2NhdGVkIHNwYWNlICovDQotCXVuc2ln
bmVkIGxvbmcgb2Zmc2V0Ow0KIA0KLQkvKiBwaHlzaWNhbCBhZGRyZXNzIG9mIGFsbG9jYXRlZCBz
cGFjZSAqLw0KLQl1bnNpZ25lZCBsb25nIHBoeXNfYWRkcmVzczsNCisvKiBjb21tYW5kIHN0cnVj
dCBmb3Igc3RhdGljIHBvb2wgYWRkcmVzc2VzICAqLw0KK3N0cnVjdCBzZXBfZHJpdmVyX3N0YXRp
Y19wb29sX2FkZHJfdCB7DQorICAvKiBwaHlzaWNhbCBhZGRyZXNzIG9mIHRoZSBzdGF0aWMgcG9v
bCAqLw0KKyAgZG1hX2FkZHJfdCAgIHN0YXRpY19idXNfYWRkcmVzczsNCiANCi0JLyogbnVtYmVy
IG9mIGJ5dGVzIHRvIGFsbG9jYXRlICovDQotCXVuc2lnbmVkIGxvbmcgbnVtX2J5dGVzOw0KKyAg
LyogdmlydHVhbCBhZGRyZXNzIG9mIHRoZSBzdGF0aWMgcG9vbCAqLw0KKyAgdm9pZCAgICpzdGF0
aWNfdmlydF9hZGRyZXNzOw0KIH07DQogDQotLyoNCi0gKi8NCi1zdHJ1Y3Qgc2VwX2RyaXZlcl93
cml0ZV90IHsNCi0JLyogYXBwbGljYXRpb24gc3BhY2UgYWRkcmVzcyAqLw0KLQl1bnNpZ25lZCBs
b25nIGFwcF9hZGRyZXNzOw0KKy8qIGNvbW1hbmQgc3RydWN0IGZvciBnZXRpaW5nIG9mZnNldCBv
ZiB0aGUgcGh5c2ljYWwgYWRkcmVzcyBmcm9tDQorCXRoZSBzdGFydCBvZiB0aGUgbWFwcGVkIGFy
ZWEgICovDQorc3RydWN0IHNlcF9kcml2ZXJfZ2V0X21hcHBlZF9vZmZzZXRfdCB7DQorICAvKiBw
aHlzaWNhbCBhZGRyZXNzIG9mIHRoZSBzdGF0aWMgcG9vbCAqLw0KKyAgZG1hX2FkZHJfdCAgIGJ1
c19hZGRyZXNzOw0KIA0KLQkvKiBhZGRyZXNzIG9mIHRoZSBkYXRhIHBvb2wgKi8NCi0JdW5zaWdu
ZWQgbG9uZyBkYXRhcG9vbF9hZGRyZXNzOw0KKyAgLyogdmlydHVhbCBhZGRyZXNzIG9mIHRoZSBz
dGF0aWMgcG9vbCAqLw0KKyAgdTMyICAgb2Zmc2V0Ow0KK307DQogDQotCS8qIG51bWJlciBvZiBi
eXRlcyB0byB3cml0ZSAqLw0KLQl1bnNpZ25lZCBsb25nIG51bV9ieXRlczsNCisvKiBjb21tYW5k
IHN0cnVjdCBmb3IgZ2V0dGluZyB0aW1lIHZhbHVlIGFuZCBhZGRyZXNzICovDQorc3RydWN0IHNl
cF9kcml2ZXJfZ2V0X3RpbWVfdCB7DQorICAvKiBwaHlzaWNhbCBhZGRyZXNzIG9mIHN0b3JlZCB0
aW1lICovDQorICBkbWFfYWRkcl90ICAgdGltZV9idXNfYWRkcmVzczsNCisNCisgIC8qIHZhbHVl
IG9mIHRoZSBzdG9yZWQgdGltZSAqLw0KKyAgdTMyICAgdGltZV92YWx1ZTsNCiB9Ow0KIA0KLS8q
DQotICovDQotc3RydWN0IHNlcF9kcml2ZXJfcmVhZF90IHsNCi0JLyogYXBwbGljYXRpb24gc3Bh
Y2UgYWRkcmVzcyAqLw0KLQl1bnNpZ25lZCBsb25nIGFwcF9hZGRyZXNzOw0KKy8qIGNvbW1hbmQg
c3RydWN0IGZvciBnZXR0aW5nIHRpbWUgdmFsdWUgYW5kIGFkZHJlc3MgKi8NCitzdHJ1Y3Qgc2Vw
X2RyaXZlcl9zZXRfY2FsbGVyX2lkX3Qgew0KKyAgLyogcGlkIG9mIHRoZSBwcm9jZXNzICovDQor
ICB1MzIgICBwaWQ7DQorDQorICAvKiB2aXJ0dWFsIGFkZHJlc3Mgb2YgdGhlIGNhbGxlciBpZCBo
YXNoICovDQorICB2b2lkICAqY2FsbGVySWRBZGRyZXNzOw0KIA0KLQkvKiBhZGRyZXNzIG9mIHRo
ZSBkYXRhIHBvb2wgKi8NCi0JdW5zaWduZWQgbG9uZyBkYXRhcG9vbF9hZGRyZXNzOw0KKyAgLyog
Y2FsbGVyIGlkIGhhc2ggc2l6ZSBpbiBieXRlcyAqLw0KKyAgdTMyICAgY2FsbGVySWRTaXplSW5C
eXRlczsNCiANCi0JLyogbnVtYmVyIG9mIGJ5dGVzIHRvIHJlYWQgKi8NCi0JdW5zaWduZWQgbG9u
ZyBudW1fYnl0ZXM7DQogfTsNCiANCisvKiBjb21tYW5kIHN0cnVjdCBmb3IgdHJhbnNsYXRpbmcg
cmFyIGhhbmRsZSB0byBidXMgYWRkcmVzcw0KKyAgIGFuZCBzZXR0aW5nIGl0IGF0IHByZWRlZmlu
ZWQgbG9jYXRpb24gKi8NCitzdHJ1Y3Qgc2VwX2RyaXZlcl9yYXJfaGFuZGxlX3RvX2J1cyB7DQor
DQorCS8qIHJhciBoYW5kbGUgKi8NCisJdm9pZCAgKnJhcl9oYW5kbGU7DQorfTsNCisNCisNCiAv
Kg0KKyAgc3RydWN0dXJlIHRoYXQgcmVwcmVzZW50IG9uZSBlbnRyeSBpbiB0aGUgRE1BIExMSSB0
YWJsZQ0KICovDQotc3RydWN0IHNlcF9kcml2ZXJfYnVpbGRfc3luY190YWJsZV90IHsNCi0JLyog
YWRkcmVzcyB2YWx1ZSBvZiB0aGUgZGF0YSBpbiAqLw0KLQl1bnNpZ25lZCBsb25nIGFwcF9pbl9h
ZGRyZXNzOw0KK3N0cnVjdCBzZXBfbGxpX2VudHJ5X3Qgew0KKyAgLyogcGh5c2ljYWwgYWRkcmVz
cyAqLw0KKyAgdTMyICBidXNfYWRkcmVzczsNCisNCisgIC8qIGJsb2NrIHNpemUgKi8NCisgIHUz
MiAgYmxvY2tfc2l6ZTsNCit9Ow0KIA0KLQkvKiBzaXplIG9mIGRhdGEgaW4gKi8NCi0JdW5zaWdu
ZWQgbG9uZyBkYXRhX2luX3NpemU7DQogDQotCS8qIGFkZHJlc3Mgb2YgdGhlIGRhdGEgb3V0ICov
DQotCXVuc2lnbmVkIGxvbmcgYXBwX291dF9hZGRyZXNzOw0KIA0KLQkvKiB0aGUgc2l6ZSBvZiB0
aGUgYmxvY2sgb2YgdGhlIG9wZXJhdGlvbiAtIGlmIG5lZWRlZCwNCi0JICAgZXZlcnkgdGFibGUg
d2lsbCBiZSBtb2R1bG8gdGhpcyBwYXJhbWV0ZXIgKi8NCi0JdW5zaWduZWQgbG9uZyBibG9ja19z
aXplOw0KK3N0cnVjdCBzZXBfY2FsbGVyX2lkX2VudHJ5IHsNCiANCi0JLyogdGhlIHBoeXNpY2Fs
IGFkZHJlc3Mgb2YgdGhlIGZpcnN0IGlucHV0IERNQSB0YWJsZSAqLw0KLQl1bnNpZ25lZCBsb25n
IGluX3RhYmxlX2FkZHJlc3M7DQorICBpbnQgcGlkOw0KIA0KLQkvKiBudW1iZXIgb2YgZW50cmll
cyBpbiB0aGUgZmlyc3QgaW5wdXQgRE1BIHRhYmxlICovDQotCXVuc2lnbmVkIGxvbmcgaW5fdGFi
bGVfbnVtX2VudHJpZXM7DQorICB1bnNpZ25lZCBjaGFyIGNhbGxlcklkSGFzaFtTRVBfQ0FMTEVS
X0lEX0hBU0hfU0laRV9JTl9CWVRFU107DQorDQorfTsNCiANCi0JLyogdGhlIHBoeXNpY2FsIGFk
ZHJlc3Mgb2YgdGhlIGZpcnN0IG91dHB1dCBETUEgdGFibGUgKi8NCi0JdW5zaWduZWQgbG9uZyBv
dXRfdGFibGVfYWRkcmVzczsNCiANCi0JLyogbnVtYmVyIG9mIGVudHJpZXMgaW4gdGhlIGZpcnN0
IG91dHB1dCBETUEgdGFibGUgKi8NCi0JdW5zaWduZWQgbG9uZyBvdXRfdGFibGVfbnVtX2VudHJp
ZXM7DQogDQotCS8qIGRhdGEgaW4gdGhlIGZpcnN0IGlucHV0IHRhYmxlICovDQotCXVuc2lnbmVk
IGxvbmcgdGFibGVfZGF0YV9zaXplOw0KKy8qKg0KKyAqIEBzdHJ1Y3Qgc2VwX2RtYV9tYXANCisg
Kg0KKyAqIFN0cnVjdHVyZSB0aGF0IGNvbnRhaW5zIGFsbCBpbmZvcm1hdGlvbiBuZWVkZWQgZm9y
IG1hcHBpbmcgdGhlIHVzZXIgcGFnZXMNCisgKiAgICAgICAgICAgb3Iga2VybmVsIGJ1ZmZlcnMg
Zm9yIGRtYSBvcGVyYXRpb25zDQorICoNCisgKg0KKyAqLw0KK3N0cnVjdCBzZXBfZG1hX21hcCB7
DQogDQotCS8qIGRpc3RpbmN0IHVzZXIva2VybmVsIGxheW91dCAqLw0KLQlib29sIGlzS2VybmVs
VmlydHVhbEFkZHJlc3M7DQorICAvKiBtYXBwZWQgZG1hIGFkZHJlc3MgKi8NCisgIGRtYV9hZGRy
X3QgICAgZG1hX2FkZHI7DQogDQorICAvKiBzaXplIG9mIHRoZSBtYXBwZWQgZGF0YSAqLw0KKyAg
c2l6ZV90ICAgICAgICBzaXplOw0KIH07DQogDQorDQogLyoNCisgICAgY29udGV4dCBvZiB0aGUg
ZGV2aWNlDQogKi8NCi1zdHJ1Y3Qgc2VwX2RyaXZlcl9idWlsZF9mbG93X3RhYmxlX3Qgew0KLQkv
KiBmbG93IHR5cGUgKi8NCi0JdW5zaWduZWQgbG9uZyBmbG93X3R5cGU7DQorc3RydWN0IGRldmlj
ZV9jb250ZXh0IHsNCiANCi0JLyogZmxhZyBmb3IgaW5wdXQgb3V0cHV0ICovDQotCXVuc2lnbmVk
IGxvbmcgaW5wdXRfb3V0cHV0X2ZsYWc7DQorICAgIC8qIHRoZSBmb2xsb3dpbmcgYWRkcmVzc2Vz
IGFyZSBmb3IgdGhlIHJlc3RyaWN0ZWQgYWNjZXNzIHJlZ2lvbiAqLw0KKyAgICB2b2lkICpyYXJf
dmlydHVhbF9hZGRyZXNzOw0KIA0KLQkvKiBhZGRyZXNzIHZhbHVlIG9mIHRoZSBkYXRhIGluICov
DQotCXVuc2lnbmVkIGxvbmcgdmlydF9idWZmX2RhdGFfYWRkcjsNCisgICAgZG1hX2FkZHJfdCBy
YXJfcGh5c2ljYWxfYWRkcmVzczsNCiANCi0JLyogc2l6ZSBvZiBkYXRhIGluICovDQotCXVuc2ln
bmVkIGxvbmcgbnVtX3ZpcnR1YWxfYnVmZmVyczsNCisgICAgZG1hX2FkZHJfdCByYXJfc3RhcnRf
YWRkcmVzczsNCisgICAgZG1hX2FkZHJfdCByYXJfZW5kX2FkZHJlc3M7DQorICAgIHNpemVfdCBy
YXJfc2l6ZTsNCiANCi0JLyogdGhlIHBoeXNpY2FsIGFkZHJlc3Mgb2YgdGhlIGZpcnN0IGlucHV0
IERNQSB0YWJsZSAqLw0KLQl1bnNpZ25lZCBsb25nIGZpcnN0X3RhYmxlX2FkZHI7DQorICAgIC8q
IGFkZHJlc3Mgb2YgdGhlIHNoYXJlZCBtZW1vcnkgYWxsb2NhdGVkIGR1cmluZyBpbml0IGZvciBT
RVAgZHJpdmVyICovDQorICAgIHZvaWQgICpzaGFyZWRfYXJlYV92aXJ0X2FkZHI7DQogDQotCS8q
IG51bWJlciBvZiBlbnRyaWVzIGluIHRoZSBmaXJzdCBpbnB1dCBETUEgdGFibGUgKi8NCi0JdW5z
aWduZWQgbG9uZyBmaXJzdF90YWJsZV9udW1fZW50cmllczsNCisgICAgLyogdGhlIHBoeXNpY2Fs
IGFkZHJlc3Mgb2YgdGhlIHNoYXJlZCBhcmVhICovDQorICAgIGRtYV9hZGRyX3QgIHNoYXJlZF9h
cmVhX2J1c19hZGRyOw0KIA0KLQkvKiBkYXRhIGluIHRoZSBmaXJzdCBpbnB1dCB0YWJsZSAqLw0K
LQl1bnNpZ25lZCBsb25nIGZpcnN0X3RhYmxlX2RhdGFfc2l6ZTsNCisgICAgLyogbWFwcGVkIGRt
YSBhZGRyZXNzIG9mIHRoZSBzaGFyZWQgYXJlYSAqLw0KKyAgICBkbWFfYWRkcl90ICBzaGFyZWRf
YXJlYV9kbWFfYWRkcjsNCiANCi0JLyogZGlzdGluY3QgdXNlci9rZXJuZWwgbGF5b3V0ICovDQot
CWJvb2wgaXNLZXJuZWxWaXJ0dWFsQWRkcmVzczsNCi19Ow0KKyAgICAvKiBzaGFyZWQgYXJlYSBz
aXplICovDQorICAgIHNpemVfdAlzaGFyZWRfYXJlYV9zaXplOw0KIA0KKyAgICAvKiBtYWpvciBh
bmQgbWlub3IgZGV2aWNlIG51bWJlcnMgKi8NCisgICAgZGV2X3QgICBkZXZpY2VfbnVtYmVyOw0K
IA0KLXN0cnVjdCBzZXBfZHJpdmVyX2FkZF9mbG93X3RhYmxlX3Qgew0KLQkvKiBmbG93IGlkICAq
Lw0KLQl1bnNpZ25lZCBsb25nIGZsb3dfaWQ7DQorICAgIGludCBzZXBfaXJxOw0KIA0KLQkvKiBm
bGFnIGZvciBpbnB1dCBvdXRwdXQgKi8NCi0JdW5zaWduZWQgbG9uZyBpbnB1dE91dHB1dEZsYWc7
DQorICAgIC8qIGNkZXYgc3RydWN0IG9mIHRoZSBkcml2ZXIgKi8NCisgICAgc3RydWN0IGNkZXYJ
CQljZGV2Ow0KIA0KLQkvKiBhZGRyZXNzIHZhbHVlIG9mIHRoZSBkYXRhIGluICovDQotCXVuc2ln
bmVkIGxvbmcgdmlydF9idWZmX2RhdGFfYWRkcjsNCisgICAgc3RydWN0IHBjaV9kZXYJCSpwZGV2
Ow0KKyAgICAvKg0KKyAgICAgIHNpZ25hbHMgaWYgdGhlIFNlUCBpcyBhbHJlYWR5IHVzZWQgZm9y
IGFuIEFQSSwNCisgICAgICB1cGRhdGVkIHdpdGggYXRvbWljIG9wZXJhdGlvbnMNCisgICAgKi8N
CisgICAgdW5zaWduZWQgbG9uZyAgIGluX3VzZV9mbGFnOw0KIA0KLQkvKiBzaXplIG9mIGRhdGEg
aW4gKi8NCi0JdW5zaWduZWQgbG9uZyBudW1fdmlydHVhbF9idWZmZXJzOw0KKyAgICAvKiBtdXRl
eCBmb3IgbG9ja2luZyBhY2Nlc3MgdG8gaW9jdGwgZnJvbSBkaWZmZXJlbnQgdGhyZWFkcyAqLw0K
KyAgICBzdHJ1Y3QgbXV0ZXgJCWlvY3RsX211dGV4Ow0KIA0KLQkvKiBhZGRyZXNzIG9mIHRoZSBm
aXJzdCB0YWJsZSAqLw0KLQl1bnNpZ25lZCBsb25nIGZpcnN0X3RhYmxlX2FkZHI7DQorICAgIC8q
IHdhaXQgcXVldWUgaGVhZCAoZXZlbnQpIG9mIHRoZSBkcml2ZXIgKi8NCisgICAgd2FpdF9xdWV1
ZV9oZWFkX3QJCWV2ZW50Ow0KIA0KLQkvKiBudW1iZXIgb2YgZW50cmllcyBpbiB0aGUgZmlyc3Qg
dGFibGUgKi8NCi0JdW5zaWduZWQgbG9uZyBmaXJzdF90YWJsZV9udW1fZW50cmllczsNCiANCi0J
LyogZGF0YSBzaXplIG9mIHRoZSBmaXJzdCB0YWJsZSAqLw0KLQl1bnNpZ25lZCBsb25nIGZpcnN0
X3RhYmxlX2RhdGFfc2l6ZTsNCisgICAgLyogc3RhcnQgYWRkcmVzcyBvZiB0aGUgYWNjZXNzIHRv
IHRoZSBTRVAgcmVnaXN0ZXJzIGZyb20gZHJpdmVyICovDQorICAgIHZvaWQgX19pb21lbSAqcmVn
X2FkZHI7DQogDQotCS8qIGRpc3RpbmN0IHVzZXIva2VybmVsIGxheW91dCAqLw0KLQlib29sIGlz
S2VybmVsVmlydHVhbEFkZHJlc3M7DQorICAgIC8qIGRldmljZSBwb2ludGVyLCB1c2VkIGZvciBE
TUEgQVBJcyAtIGluaXRpYWxpemVkIGVpdGhlciBhcw0KKyAgICAgICBwbGF0Zm9ybSBkZXZpY2Ug
KGRlZmF1bHQpLCBvciBhY2NvcmRpbmcgdG8gdGhlIHR5cGUgb2YgdGhlIFNlUA0KKyAgICAgICBv
biB0aGUgcGxhdGZvcm0gKFBDSSBldGMnICkgKi8NCisgICAgc3RydWN0IGRldmljZSAqZGV2X3B0
cjsNCiANCi19Ow0KKyAgICAvKiB0cmFuc2FjdGlvbiBjb3VudGVyIHRoYXQgY29vcmRpbmF0ZXMg
dGhlIHRyYW5zYWN0aW9ucw0KKyAgICBiZXR3ZWVuIFNFUCBhbmQgSE9TVCAqLw0KKyAgICB1MzIJ
CQlob3N0X3RvX3NlcF9zZW5kX2NvdW50ZXI7DQogDQotLyoNCi0gIGNvbW1hbmQgc3RydWN0IGZv
ciBzZXQgZmxvdyBpZA0KLSovDQotc3RydWN0IHNlcF9kcml2ZXJfc2V0X2Zsb3dfaWRfdCB7DQot
CS8qIGZsb3cgaWQgdG8gc2V0ICovDQotCXVuc2lnbmVkIGxvbmcgZmxvd19pZDsNCi19Ow0KKyAg
ICAvKiBjb3VudGVyIGZvciB0aGUgbWVzc2FnZXMgZnJvbSBzZXAgKi8NCisgICAgdTMyCQkJc2Vw
X3RvX2hvc3RfcmVwbHlfY291bnRlcjsNCiANCisgICAgLyogY291bnRlciBmb3IgdGhlIG51bWJl
ciBvZiBieXRlcyBhbGxvY2F0ZWQgaW4gdGhlIHBvb2wgZm9yIHRoZSBjdXJyZW50DQorICAgIHRy
YW5zYWN0aW9uICovDQorICAgIHUzMgkJCWRhdGFfcG9vbF9ieXRlc19hbGxvY2F0ZWQ7DQogDQot
LyogY29tbWFuZCBzdHJ1Y3QgZm9yIGFkZCB0YWJsZXMgbWVzc2FnZSAqLw0KLXN0cnVjdCBzZXBf
ZHJpdmVyX2FkZF9tZXNzYWdlX3Qgew0KLQkvKiBmbG93IGlkIHRvIHNldCAqLw0KLQl1bnNpZ25l
ZCBsb25nIGZsb3dfaWQ7DQorICAgIC8qIG51bWJlciBvZiB0aGUgbGxpIHRhYmxlcyBjcmVhdGVk
IGluIHRoZSBjdXJyZW50IHRyYW5zYWN0aW9uICovDQorICAgIHUzMiAgICAgbnVtX2xsaV90YWJs
ZXNfY3JlYXRlZDsNCiANCi0JLyogbWVzc2FnZSBzaXplIGluIGJ5dGVzICovDQotCXVuc2lnbmVk
IGxvbmcgbWVzc2FnZV9zaXplX2luX2J5dGVzOw0KKyAgICAvKiBhcnJheSBvZiBwb2ludGVycyB0
byB0aGUgcGFnZXMgdGhhdCByZXByZXNlbnQNCisgICAgaW5wdXQgZGF0YSBmb3IgdGhlIHN5bmNo
cm9uaWMgRE1BIGFjdGlvbiAqLw0KKyAgICBzdHJ1Y3QgcGFnZQkJKippbl9wYWdlX2FycmF5Ow0K
IA0KLQkvKiBhZGRyZXNzIG9mIHRoZSBtZXNzYWdlICovDQotCXVuc2lnbmVkIGxvbmcgbWVzc2Fn
ZV9hZGRyZXNzOw0KLX07DQorICAgIC8qIGFycmF5IG9mIHBvaW50ZXJzIHRvIHRoZSBwYWdlcyB0
aGF0IHJlcHJlc2VudCBvdXQNCisgICAgZGF0YSBmb3IgdGhlIHN5bmNocm9uaWMgRE1BIGFjdGlv
biAqLw0KKyAgICBzdHJ1Y3QgcGFnZQkJKipvdXRfcGFnZV9hcnJheTsNCiANCi0vKiBjb21tYW5k
IHN0cnVjdCBmb3Igc3RhdGljIHBvb2wgYWRkcmVzc2VzICAqLw0KLXN0cnVjdCBzZXBfZHJpdmVy
X3N0YXRpY19wb29sX2FkZHJfdCB7DQotCS8qIHBoeXNpY2FsIGFkZHJlc3Mgb2YgdGhlIHN0YXRp
YyBwb29sICovDQotCXVuc2lnbmVkIGxvbmcgcGh5c2ljYWxfc3RhdGljX2FkZHJlc3M7DQorICAg
IC8qIG51bWJlciBvZiBwYWdlcyBpbiB0aGUgc2VwX2luX3BhZ2VfYXJyYXkgKi8NCisgICAgdTMy
CQkJCQlpbl9udW1fcGFnZXM7DQogDQotCS8qIHZpcnR1YWwgYWRkcmVzcyBvZiB0aGUgc3RhdGlj
IHBvb2wgKi8NCi0JdW5zaWduZWQgbG9uZyB2aXJ0dWFsX3N0YXRpY19hZGRyZXNzOw0KLX07DQor
ICAgIC8qIG51bWJlciBvZiBwYWdlcyBpbiB0aGUgc2VwX291dF9wYWdlX2FycmF5ICovDQorICAg
IHUzMgkJCQkJb3V0X251bV9wYWdlczsNCiANCi0vKiBjb21tYW5kIHN0cnVjdCBmb3IgZ2V0aWlu
ZyBvZmZzZXQgb2YgdGhlIHBoeXNpY2FsIGFkZHJlc3MgZnJvbQ0KLQl0aGUgc3RhcnQgb2YgdGhl
IG1hcHBlZCBhcmVhICAqLw0KLXN0cnVjdCBzZXBfZHJpdmVyX2dldF9tYXBwZWRfb2Zmc2V0X3Qg
ew0KLQkvKiBwaHlzaWNhbCBhZGRyZXNzIG9mIHRoZSBzdGF0aWMgcG9vbCAqLw0KLQl1bnNpZ25l
ZCBsb25nIHBoeXNpY2FsX2FkZHJlc3M7DQorICAgIC8qIG1hcCBhcnJheSBvZiB0aGUgaW5wdXQg
ZGF0YSAqLw0KKyAgICBzdHJ1Y3Qgc2VwX2RtYV9tYXAgICppbl9tYXBfYXJyYXk7DQogDQotCS8q
IHZpcnR1YWwgYWRkcmVzcyBvZiB0aGUgc3RhdGljIHBvb2wgKi8NCi0JdW5zaWduZWQgbG9uZyBv
ZmZzZXQ7DQotfTsNCisgICAgLyogbWFwIGFycmF5IG9mIHRoZSBvdXRwdXQgZGF0YSAqLw0KKyAg
ICBzdHJ1Y3Qgc2VwX2RtYV9tYXAgICpvdXRfbWFwX2FycmF5Ow0KIA0KLS8qIGNvbW1hbmQgc3Ry
dWN0IGZvciBnZXR0aW5nIHRpbWUgdmFsdWUgYW5kIGFkZHJlc3MgKi8NCi1zdHJ1Y3Qgc2VwX2Ry
aXZlcl9nZXRfdGltZV90IHsNCi0JLyogcGh5c2ljYWwgYWRkcmVzcyBvZiBzdG9yZWQgdGltZSAq
Lw0KLQl1bnNpZ25lZCBsb25nIHRpbWVfcGh5c2ljYWxfYWRkcmVzczsNCisgICAgLyogbnVtYmVy
IG9mIGVudHJpZXMgb2YgdGhlIGlucHV0IG1hcHAgYXJyYXkgKi8NCisgICAgdTMyCQkJCQlpbl9t
YXBfbnVtX2VudHJpZXM7DQogDQotCS8qIHZhbHVlIG9mIHRoZSBzdG9yZWQgdGltZSAqLw0KLQl1
bnNpZ25lZCBsb25nIHRpbWVfdmFsdWU7DQotfTsNCisgICAgLyogbnVtYmVyIG9mIGVudHJpZXMg
b2YgdGhlIG91dHB1dCBtYXBwIGFycmF5ICovDQorICAgIHUzMgkJCQkJb3V0X21hcF9udW1fZW50
cmllczsNCiANCisjaWZkZWYgRFhfQ0M1Ml9TVVBQT1JUDQogDQotLyoNCi0gIHN0cnVjdHVyZSB0
aGF0IHJlcHJlc2VudCBvbmUgZW50cnkgaW4gdGhlIERNQSBMTEkgdGFibGUNCi0qLw0KLXN0cnVj
dCBzZXBfbGxpX2VudHJ5X3Qgew0KLQkvKiBwaHlzaWNhbCBhZGRyZXNzICovDQotCXVuc2lnbmVk
IGxvbmcgcGh5c2ljYWxfYWRkcmVzczsNCisgICAgLyogbWFqb3IgYW5kIG1pbm9yIGRldmljZSBu
dW1iZXJzIGZvciBzaW5nbGV0b24gKi8NCisgICAgZGV2X3QgICAgICAgICAgICAgICAgICAgc2lu
Z2xldG9uX2RldmljZV9udW1iZXI7DQorDQorICAgIC8qIGNkZXYgc3RydWN0IGZvciBzaW5nbGV0
b24gKi8NCisgICAgc3RydWN0IGNkZXYgICAgICAgICAgICAgc2luZ2xldG9uX2NkZXY7DQorDQor
ICAgIC8qIGFjY2VzcyBmbGFnIGZvciBzaW5nbGV0b24gKi8NCisgICAgdW5zaWduZWQgbG9uZyAg
ICAgICAgICAgc2luZ2xldG9uX2FjY2Vzc19mbGFnOw0KIA0KLQkvKiBibG9jayBzaXplICovDQot
CXVuc2lnbmVkIGxvbmcgYmxvY2tfc2l6ZTsNCisgICAgLyogY2FsbGVyIGlkIHRhYmxlICovDQor
ICAgIHN0cnVjdCBzZXBfY2FsbGVyX2lkX2VudHJ5DQorCQkJY2FsbGVyX2lkX3RhYmxlW1NFUF9D
QUxMRVJfSURfVEFCTEVfTlVNX0VOVFJJRVNdOw0KKw0KKyNlbmRpZiAvKkRYX0NDNTJfU1VQUE9S
VCovDQogfTsNCiANCi0vKg0KLSAgc3RydWN0dXJlIHRoYXQgcmVwZXJlc2VudHMgZGF0YSBuZWVk
ZWQgZm9yIGxsaSB0YWJsZSBjb25zdHJ1Y3Rpb24NCi0qLw0KLXN0cnVjdCBzZXBfbGxpX3ByZXBh
cmVfdGFibGVfZGF0YV90IHsNCi0JLyogcG9pbnRlciB0byB0aGUgbWVtb3J5IHdoZXJlIHRoZSBm
aXJzdCBsbGkgZW50cnkgdG8gYmUgYnVpbHQgKi8NCi0Jc3RydWN0IHNlcF9sbGlfZW50cnlfdCAq
bGxpX2VudHJ5X3B0cjsNCiANCi0JLyogcG9pbnRlciB0byB0aGUgYXJyYXkgb2YgbGxpIGVudHJp
ZXMgZnJvbSB3aGljaCB0aGUgdGFibGUgaXMgdG8gYmUgYnVpbHQgKi8NCi0Jc3RydWN0IHNlcF9s
bGlfZW50cnlfdCAqbGxpX2FycmF5X3B0cjsNCiANCi0JLyogbnVtYmVyIG9mIGVsZW1lbnRzIGlu
IGxsaSBhcnJheSAqLw0KLQlpbnQgbGxpX2FycmF5X3NpemU7DQorI2lmZGVmIF9fTElUVExFX0VO
RElBTg0KIA0KLQkvKiBudW1iZXIgb2YgZW50cmllcyBpbiB0aGUgY3JlYXRlZCB0YWJsZSAqLw0K
LQlpbnQgbnVtX3RhYmxlX2VudHJpZXM7DQorc3RhdGljIGlubGluZSB2b2lkIFNFUF9XUklURV9S
RUdJU1RFUihzdHJ1Y3QgZGV2aWNlX2NvbnRleHQgKmRldiwNCisgICAgICBpbnQgcmVnLCB1MzIg
dmFsdWUpDQorew0KKwl2b2lkIF9faW9tZW0gKmFkZHIgPSBkZXYtPnJlZ19hZGRyICsgcmVnOw0K
Kwl3cml0ZWwodmFsdWUsIGFkZHIpOw0KK30NCiANCi0JLyogbnVtYmVyIG9mIGFycmF5IGVudHJp
ZXMgcHJvY2Vzc2VkIGR1cmluZyB0YWJsZSBjcmVhdGlvbiAqLw0KLQlpbnQgbnVtX2FycmF5X2Vu
dHJpZXNfcHJvY2Vzc2VkOw0KK3N0YXRpYyBpbmxpbmUgdTMyIFNFUF9SRUFEX1JFR0lTVEVSKHN0
cnVjdCBkZXZpY2VfY29udGV4dCAqZGV2LCBpbnQgcmVnKQ0KK3sNCisJdm9pZCBfX2lvbWVtICph
ZGRyID0gZGV2LT5yZWdfYWRkciArIHJlZzsNCisJcmV0dXJuIHJlYWRsKGFkZHIpOw0KK30NCiAN
Ci0JLyogdGhlIHRvdGF0bCBkYXRhIHNpemUgaW4gdGhlIGNyZWF0ZWQgdGFibGUgKi8NCi0JaW50
IGxsaV90YWJsZV90b3RhbF9kYXRhX3NpemU7DQotfTsNCisjZGVmaW5lIFNFUF9DSEFOR0VfRU5E
SUFOTkVTUyh2YWwpICh2YWwpDQogDQotLyoNCi0gIHN0cnVjdHVyZSB0aGF0IHJlcHJlc2VudCB0
b25lIHRhYmxlIC0gaXQgaXMgbm90IHVzZWQgaW4gY29kZSwgamt1c3QNCi0gIHRvIHNob3cgd2hh
dCB0YWJsZSBsb29rcyBsaWtlDQotKi8NCi1zdHJ1Y3Qgc2VwX2xsaV90YWJsZV90IHsNCi0JLyog
bnVtYmVyIG9mIHBhZ2VzIG1hcHBlZCBpbiB0aGlzIHRhYmxlcy4gSWYgMCAtIG1lYW5zIHRoYXQg
dGhlIHRhYmxlDQotCSAgIGlzIG5vdCBkZWZpbmVkICh1c2VkIGFzIGEgdmFsaWQgZmxhZykgKi8N
Ci0JdW5zaWduZWQgbG9uZyBudW1fcGFnZXM7DQotCS8qDQotCSAgIHBvaW50ZXIgdG8gYXJyYXkg
b2YgcGFnZSBwb2ludGVycyB0aGF0IHJlcHJlc2VudCB0aGUgbWFwcGluZyBvZiB0aGUNCi0JICAg
dmlydHVhbCBidWZmZXIgZGVmaW5lZCBieSB0aGUgdGFibGUgdG8gdGhlIHBoeXNpY2FsIG1lbW9y
eS4gSWYgdGhpcw0KLQkgICBwb2ludGVyIGlzIE5VTEwsIGl0IG1lYW5zIHRoYXQgdGhlIHRhYmxl
IGlzIG5vdCBkZWZpbmVkDQotCSAgICh1c2VkIGFzIGEgdmFsaWQgZmxhZykNCi0JICovDQotCXN0
cnVjdCBwYWdlICoqdGFibGVfcGFnZV9hcnJheV9wdHI7DQotDQotCS8qIG1heGltdW0gZmxvdyBl
bnRyaWVzIGluIHRhYmxlICovDQotCXN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgbGxpX2VudHJpZXNb
U0VQX0RSSVZFUl9NQVhfRkxPV19OVU1fRU5UUklFU19JTl9UQUJMRV07DQotfTsNCiANCisjZWxz
ZQ0KIA0KLS8qDQotICBzdHJ1Y3R1cmUgZm9yIGtlZXBpbmcgdGhlIG1hcHBpbmcgb2YgdGhlIHZp
cnR1YWwgYnVmZmVyIGludG8gcGh5c2ljYWwgcGFnZXMNCi0qLw0KLXN0cnVjdCBzZXBfZmxvd19i
dWZmZXJfZGF0YSB7DQotCS8qIHBvaW50ZXIgdG8gdGhlIGFycmF5IG9mIHBhZ2Ugc3RydWN0cyBw
b2ludGVycyB0byB0aGUgcGFnZXMgb2YgdGhlDQotCSAgIHZpcnR1YWwgYnVmZmVyICovDQotCXN0
cnVjdCBwYWdlICoqcGFnZV9hcnJheV9wdHI7DQorc3RhdGljIGlubGluZSB2b2lkIFNFUF9XUklU
RV9SRUdJU1RFUihzdHJ1Y3QgZGV2aWNlX2NvbnRleHQgKmRldiwNCisgICAgICBpbnQgcmVnLA0K
KyAgICAgIHUzMiB2YWx1ZSkNCit7DQorCXZvaWQgX19pb21lbSAqYWRkciA9IGRldi0+cmVnX2Fk
ZHIgKyByZWc7DQorCXdyaXRlbF9iZSh2YWx1ZSwgYWRkcik7DQorfQ0KIA0KLQkvKiBudW1iZXIg
b2YgcGFnZXMgdGFrZW4gYnkgdGhlIHZpcnR1YWwgYnVmZmVyICovDQotCXVuc2lnbmVkIGxvbmcg
bnVtX3BhZ2VzOw0KK3N0YXRpYyBpbmxpbmUgdTMyIFNFUF9SRUFEX1JFR0lTVEVSKHN0cnVjdCBk
ZXZpY2VfY29udGV4dCAqZGV2LCBpbnQgcmVnKQ0KK3sNCisJdm9pZCBfX2lvbWVtICphZGRyID0g
ZGV2LT5yZWdfYWRkciArIHJlZzsNCisJcmV0dXJuIHJlYWRsX2JlKGFkZHIpOw0KK30NCiANCi0J
LyogdGhpcyBmbGFnIHNpZ25hbHMgaWYgdGhpcyBwYWdlX2FycmF5IGlzIHRoZSBsYXN0IG9uZSBh
bW9uZyBtYW55IHRoYXQgd2VyZQ0KLQkgICBzZW50IGluIG9uZSBzZXR0aW5nIHRvIFNFUCAqLw0K
LQl1bnNpZ25lZCBsb25nIGxhc3RfcGFnZV9hcnJheV9mbGFnOw0KLX07DQorI2RlZmluZSBTRVBf
Q0hBTkdFX0VORElBTk5FU1ModmFsKSBcDQorICAgICAgKCgodmFsKSA+PiAyNCkgfCAoKCh2YWwp
ICYgMHgwMEZGMDAwMCkgPj4gOCkgfCBcDQorICAgICAgKCgodmFsKSAmIDB4MDAwMEZGMDApIDw8
IDgpIHwgXA0KKyAgICAgICgoKHZhbCkgJiAweDAwMDAwMEZGKSA8PCAyNCkpDQogDQotLyoNCi0g
IHN0cnVjdCB0aGF0IGtlZXBzIGFsbCB0aGUgZGF0YSBmb3Igb25lIGZsb3cNCi0qLw0KLXN0cnVj
dCBzZXBfZmxvd19jb250ZXh0X3Qgew0KLQkvKg0KLQkgICB3b3JrIHN0cnVjdCBmb3IgaGFuZGxp
bmcgdGhlIGZsb3cgZG9uZSBpbnRlcnJ1cHQgaW4gdGhlIHdvcmtxdWV1ZQ0KLQkgICB0aGlzIHN0
cnVjdHVyZSBtdXN0IGJlIGluIHRoZSBmaXJzdCBwbGFjZSwgc2luY2UgaXQgd2lsbCBiZSB1c2Vk
DQotCSAgIGZvcmNhc3RpbmcgdG8gdGhlIGNvbnRhaW5pbmcgZmxvdyBjb250ZXh0DQotCSAqLw0K
LQlzdHJ1Y3Qgd29ya19zdHJ1Y3QgZmxvd193cTsNCisjZW5kaWYNCisNCisvKiB3YWl0IGZvciBT
UkFNIHdyaXRlIGNvbXBsZXRlKGluZGlyZWN0IHdyaXRlICovDQorc3RhdGljIGlubGluZSB2b2lk
IFNFUF9XQUlUX1NSQU1fV1JJVEVfQ09NUExFVEUoc3RydWN0IGRldmljZV9jb250ZXh0ICpkZXYp
DQorew0KKwl1MzIgIHJlZ192YWw7DQorCWRvIHsNCisJCXJlZ192YWwgPSBTRVBfUkVBRF9SRUdJ
U1RFUihkZXYsIEhXX1NSQU1fREFUQV9SRUFEWV9SRUdfQUREUik7DQorCX0gd2hpbGUgKCEocmVn
X3ZhbCAmIDB4MSkpOw0KK30NCisNCisNCisNCisvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCisgIElPQ1RMIGNvbW1hbmQg
ZGVmaW5lcw0KKyAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KIA0KLQkvKiBmbG93IGlkICovDQotCXVuc2lnbmVkIGxv
bmcgZmxvd19pZDsNCisvKiBtYWdpYyBudW1iZXIgMSBvZiB0aGUgc2VwIElPQ1RMIGNvbW1hbmQg
Ki8NCisjZGVmaW5lIFNFUF9JT0NfTUFHSUNfTlVNQkVSICAgICAgICAgICAgICAgICAgICAgICAg
ICAgJ3MnDQogDQotCS8qIGFkZGl0aW9uYWwgaW5wdXQgdGFibGVzIGV4aXN0cyAqLw0KLQl1bnNp
Z25lZCBsb25nIGlucHV0X3RhYmxlc19mbGFnOw0KKy8qIHNlbmRzIGludGVycnVwdCB0byBzZXAg
dGhhdCBtZXNzYWdlIGlzIHJlYWR5ICovDQorI2RlZmluZSBTRVBfSU9DU0VORFNFUENPTU1BTkQg
ICAgIFwNCisgICAgICBfSU8oU0VQX0lPQ19NQUdJQ19OVU1CRVIsIDApDQogDQotCS8qIGFkZGl0
aW9uYWwgb3V0cHV0IHRhYmxlcyBleGlzdHMgKi8NCi0JdW5zaWduZWQgbG9uZyBvdXRwdXRfdGFi
bGVzX2ZsYWc7DQorLyogc2VuZHMgaW50ZXJydXB0IHRvIHNlcCB0aGF0IG1lc3NhZ2UgaXMgcmVh
ZHkgKi8NCisjZGVmaW5lIFNFUF9JT0NTRU5EU0VQUlBMWUNPTU1BTkQgICAgIFwNCisgICAgICBf
SU8oU0VQX0lPQ19NQUdJQ19OVU1CRVIsIDEpDQogDQotCS8qICBkYXRhIG9mIHRoZSBmaXJzdCBp
bnB1dCBmaWxlICovDQotCXN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgZmlyc3RfaW5wdXRfdGFibGU7
DQorLyogYWxsb2NhdGUgbWVtb3J5IGluIGRhdGEgcG9vbCAqLw0KKyNkZWZpbmUgU0VQX0lPQ0FM
TE9DREFUQVBPTEwgICAgICBcDQorICAgICAgX0lPVyhTRVBfSU9DX01BR0lDX05VTUJFUiwgMiwg
c3RydWN0IHNlcF9kcml2ZXJfYWxsb2NfdCkNCiANCi0JLyogZGF0YSBvZiB0aGUgZmlyc3Qgb3V0
cHV0IHRhYmxlICovDQotCXN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgZmlyc3Rfb3V0cHV0X3RhYmxl
Ow0KKy8qIHdyaXRlIHRvIHByZS1hbGxvY2F0ZWQgIG1lbW9yeSBpbiBkYXRhIHBvb2wgKi8NCisj
ZGVmaW5lIFNFUF9JT0NXUklURURBVEFQT0xMICAgICAgXA0KKyAgICAgIF9JT1coU0VQX0lPQ19N
QUdJQ19OVU1CRVIsIDMsIHN0cnVjdCBzZXBfZHJpdmVyX3dyaXRlX3QpDQogDQotCS8qIGxhc3Qg
aW5wdXQgdGFibGUgZGF0YSAqLw0KLQlzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90IGxhc3RfaW5wdXRf
dGFibGU7DQorLyogcmVhZCBmcm9tICBwcmUtYWxsb2NhdGVkICBtZW1vcnkgaW4gZGF0YSBwb29s
ICovDQorI2RlZmluZSBTRVBfSU9DUkVBRERBVEFQT0xMICAgICBcDQorICAgICAgX0lPVyhTRVBf
SU9DX01BR0lDX05VTUJFUiwgNCwgc3RydWN0IHNlcF9kcml2ZXJfd3JpdGVfdCkNCiANCi0JLyog
bGFzdCBvdXRwdXQgdGFibGUgZGF0YSAqLw0KLQlzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90IGxhc3Rf
b3V0cHV0X3RhYmxlOw0KKy8qIGNyZWF0ZSBzeW0gZG1hIGxsaSB0YWJsZXMgKi8NCisjZGVmaW5l
IFNFUF9JT0NDUkVBVEVTWU1ETUFUQUJMRSAgICAgIFwNCisgICAgICBfSU9XKFNFUF9JT0NfTUFH
SUNfTlVNQkVSLCA1LCBzdHJ1Y3Qgc2VwX2RyaXZlcl9idWlsZF9zeW5jX3RhYmxlX3QpDQogDQot
CS8qIGZpcnN0IGxpc3Qgb2YgdGFibGUgKi8NCi0Jc3RydWN0IHNlcF9sbGlfZW50cnlfdCBpbnB1
dF90YWJsZXNfaW5fcHJvY2VzczsNCisvKiBjcmVhdGUgZmxvdyBkbWEgbGxpIHRhYmxlcyAqLw0K
KyNkZWZpbmUgU0VQX0lPQ0NSRUFURUZMT1dETUFUQUJMRSAgICAgXA0KKyAgICAgIF9JTyhTRVBf
SU9DX01BR0lDX05VTUJFUiwgNikNCiANCi0JLyogb3V0cHV0IHRhYmxlIGluIHByb2Nlc3MgKGlu
IHNlcCkgKi8NCi0Jc3RydWN0IHNlcF9sbGlfZW50cnlfdCBvdXRwdXRfdGFibGVzX2luX3Byb2Nl
c3M7DQorLyogZnJlZSBkeW5hbWljIGRhdGEgYWFsb2NhdGVkIGR1cmluZyB0YWJsZSBjcmVhdGlv
biAqLw0KKyNkZWZpbmUgU0VQX0lPQ0ZSRUVETUFUQUJMRURBVEEgICAgIFwNCisgICAgICBfSU8o
U0VQX0lPQ19NQUdJQ19OVU1CRVIgLCA3KQ0KIA0KLQkvKiBzaXplIG9mIG1lc3NhZ2VzIGluIGJ5
dGVzICovDQotCXVuc2lnbmVkIGxvbmcgbWVzc2FnZV9zaXplX2luX2J5dGVzOw0KKy8qIGdldCB0
aGUgc3RhdGljIHBvb2wgYXJlYSBhZGRlcnNzZXMgKHBoeXNpY2FsIGFuZCB2aXJ0dWFsKSAqLw0K
KyNkZWZpbmUgU0VQX0lPQ0dFVFNUQVRJQ1BPT0xBRERSICAgICAgXA0KKyAgICAgIF9JT1IoU0VQ
X0lPQ19NQUdJQ19OVU1CRVIgLCA4LCBzdHJ1Y3Qgc2VwX2RyaXZlcl9zdGF0aWNfcG9vbF9hZGRy
X3QpDQogDQotCS8qIG1lc3NhZ2UgKi8NCi0JdW5zaWduZWQgY2hhciBtZXNzYWdlW1NFUF9NQVhf
QUREX01FU1NBR0VfTEVOR1RIX0lOX0JZVEVTXTsNCi19Ow0KKy8qIHNldCBmbG93IGlkIGNvbW1h
bmQgKi8NCisjZGVmaW5lIFNFUF9JT0NTRVRGTE9XSUQgICAgICBcDQorICAgICAgX0lPKFNFUF9J
T0NfTUFHSUNfTlVNQkVSICwgOSkNCisNCisvKiBhZGQgdGFibGVzIHRvIHRoZSBkeW5hbWljIGZs
b3cgKi8NCisjZGVmaW5lIFNFUF9JT0NBRERGTE9XVEFCTEUgICAgIFwNCisgICAgICBfSU8oU0VQ
X0lPQ19NQUdJQ19OVU1CRVIgLCAxMCkNCisNCisvKiBhZGQgZmxvdyBhZGQgdGFibGVzIG1lc3Nh
Z2UgKi8NCisjZGVmaW5lIFNFUF9JT0NBRERGTE9XTUVTU0FHRSAgICAgXA0KKyAgICAgIF9JTyhT
RVBfSU9DX01BR0lDX05VTUJFUiAsIDExKQ0KKw0KKy8qIHN0YXJ0IHNlcCBjb21tYW5kICovDQor
I2RlZmluZSBTRVBfSU9DU0VQU1RBUlQgICAgIFwNCisgICAgICBfSU8oU0VQX0lPQ19NQUdJQ19O
VU1CRVIgLCAxMikNCisNCisvKiBpbml0IHNlcCBjb21tYW5kICovDQorI2RlZmluZSBTRVBfSU9D
U0VQSU5JVCAgICAgIFwNCisgICAgICBfSU9XKFNFUF9JT0NfTUFHSUNfTlVNQkVSICwgMTMgLCBz
dHJ1Y3Qgc2VwX2RyaXZlcl9pbml0X3QpDQorDQorLyogZW5kIHRyYW5zYWN0aW9uIGNvbW1hbmQg
Ki8NCisjZGVmaW5lIFNFUF9JT0NFTkRUUkFOU0FDVElPTiAgICAgXA0KKyAgICAgIF9JTyhTRVBf
SU9DX01BR0lDX05VTUJFUiAsIDE1KQ0KKw0KKy8qIHJlYWxsb2NhdGUgY2FjaGUgYW5kIHJlc2lk
ZW50ICovDQorI2RlZmluZSBTRVBfSU9DUkVBTExPQ0NBQ0hFUkVTICAgICAgXA0KKyAgX0lPVyhT
RVBfSU9DX01BR0lDX05VTUJFUiwgMTYsIHN0cnVjdCBzZXBfZHJpdmVyX3JlYWxsb2NfY2FjaGVf
cmVzaWRlbnRfdCkNCisNCisvKiBnZXQgdGhlIG9mZnNldCBvZiB0aGUgYWRkcmVzcyBzdGFydGlu
ZyBmcm9tIHRoZSBiZWdpbm5uaWcgb2YgdGhlIG1hcCBhcmVhICovDQorI2RlZmluZSBTRVBfSU9D
R0VUTUFQUEVEQUREUk9GRlNFVCAgICAgIFwNCisgICAgICBfSU9SKFNFUF9JT0NfTUFHSUNfTlVN
QkVSICwgMTcgLCBzdHJ1Y3Qgc2VwX2RyaXZlcl9nZXRfbWFwcGVkX29mZnNldF90KQ0KKw0KKy8q
IHJlYWxsb2NhdGUgY2FjaGUgYW5kIHJlc2lkZW50ICovDQorI2RlZmluZSBTRVBfSU9DUkVBTExP
Q0VYVENBQ0hFICAgICAgXA0KKyAgICAgIF9JT1coU0VQX0lPQ19NQUdJQ19OVU1CRVIgLCAxOCAs
IHN0cnVjdCBzZXBfZHJpdmVyX3JlYWxsb2NfZXh0X2NhY2hlX3QpDQorDQorLyogZ2V0IHRpbWUg
YWRkcmVzcyBhbmQgdmFsdWUgKi8NCisjZGVmaW5lIFNFUF9JT0NHRVRJTUUgICAgIFwNCisgICAg
ICBfSU9SKFNFUF9JT0NfTUFHSUNfTlVNQkVSICwgMTkgLCBzdHJ1Y3Qgc2VwX2RyaXZlcl9nZXRf
dGltZV90KQ0KKw0KKyNkZWZpbmUgU0VQX0lPQ1JBUlBSRVBBUkVNRVNTQUdFICAgICAgXA0KKyAg
ICAgIF9JT1coU0VQX0lPQ19NQUdJQ19OVU1CRVIgLCAyMCAsIHN0cnVjdCBzZXBfZHJpdmVyX3Jh
cl9oYW5kbGVfdG9fYnVzKQ0KKw0KKyNkZWZpbmUgU0VQX0lPQ1RMU0lOR0xFVE9OTE9DSyAgICAg
IFwNCisgICAgICBfSU8oU0VQX0lPQ19NQUdJQ19OVU1CRVIgLCAzMikNCisNCisjZGVmaW5lIFNF
UF9JT0NUTFNJTkdMRVRPTlVOTE9DSyAgICAgIFwNCisgICAgICBfSU8oU0VQX0lPQ19NQUdJQ19O
VU1CRVIgLCAzMykNCisNCisjZGVmaW5lIFNFUF9JT0NUTFNFVENBTExFUklEICAgICAgXA0KKyAg
ICAgIF9JT1coU0VQX0lPQ19NQUdJQ19OVU1CRVIgLCAzNCAsIHN0cnVjdCBzZXBfZHJpdmVyX3Nl
dF9jYWxsZXJfaWRfdCkNCisNCisNCisvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCisgIFBVQkxJQyBmdW5jdGlvbnMNCisg
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tKi8NCisNCisvKg0KKyAgdGhpcyBmdW5jdGlvbiBsb2NrcyBTRVAgYnkgbG9ja2lu
ZyB0aGUgc2VtYXBob3JlDQorKi8NCitpbnQgc2VwX2xvY2sodm9pZCk7DQorDQorLyoNCisgIHRo
aXMgZnVuY3Rpb24gdW5sb2NrcyBTRVANCisqLw0KK3ZvaWQgc2VwX3VubG9jayh2b2lkKTsNCisN
CisvKg0KKwl0aGlzIGZ1bmN0aW9uIHJldHVybnMgdGhlIGFkZHJlc3Mgb2YgdGhlIG1lc3NhZ2Ug
c2hhcmVkIGFyZWENCisqLw0KK3ZvaWQgICpzZXBfbWFwX3NoYXJlZF9hcmVhKHZvaWQpOw0KKw0K
Kw0KKy8qDQorCXRoaXMgZnVuY3Rpb24gcmV0dXJucyB0aGUgYWRkcmVzcyBvZiB0aGUgbWVzc2Fn
ZSBzaGFyZWQgYXJlYQ0KKyovDQoraW50IHNlcF9zZW5kX21zZ19yZHlfY21kKHZvaWQpOw0KKw0K
Kw0KKy8qDQorCVRoaXMgZnVuY3Rpb24gYnVpbGRzIGlucHV0IGFuZCBvdXRwdXQgRE1BIHRhYmxl
cyBmb3Igc3luaHJvbmljIHN5bW1ldHJpYw0KKwlvcGVyYXRpb25zIChBRVMsIERFUykgSXQgYWxz
byBjaGVja3MgdGhhdCBlYWNoIHRhYmxlIGlzIG9mIHRoZSBtb2R1bGFyDQorCWJsb2NrIHNpemUN
CisqLw0KK2ludCBzZXBfcHJlcGFyZV9pbnB1dF9vdXRwdXRfZG1hX3RhYmxlKHVuc2lnbmVkIGxv
bmcgICBhcHBfdmlydF9pbl9hZGRyLA0KKwkJCQl1bnNpZ25lZCBsb25nICAgYXBwX3ZpcnRfb3V0
X2FkZHIsDQorCQkJCXUzMiAgIGRhdGFfc2l6ZSwNCisJCQkJdTMyICAgYmxvY2tfc2l6ZSwNCisJ
CQkJZG1hX2FkZHJfdCAgKmxsaV90YWJsZV9pbl9wdHIsDQorCQkJCWRtYV9hZGRyX3QgICpsbGlf
dGFibGVfb3V0X3B0ciwNCisJCQkJdTMyICAqaW5fbnVtX2VudHJpZXNfcHRyLA0KKwkJCQl1MzIg
ICpvdXRfbnVtX2VudHJpZXNfcHRyLA0KKwkJCQl1MzIgICp0YWJsZV9kYXRhX3NpemVfcHRyLA0K
KwkJCQlib29sICAgICAgICAgICAgaXNLZXJuZWxWaXJ0dWFsQWRkcmVzcyk7DQorDQorLyoNCisJ
VGhpcyBmdW5jdGlvbiBwcmVwYXJlcyBvbmx5IGlucHV0IERNQSB0YWJsZSBmb3Igc3luaHJvbmlj
IHN5bW1ldHJpYw0KKwlvcGVyYXRpb25zIChIQVNIKQ0KKyovDQoraW50IHNlcF9wcmVwYXJlX2lu
cHV0X2RtYV90YWJsZSh1bnNpZ25lZCBsb25nICAgYXBwX3ZpcnRfYWRkciwNCisJCQkJdTMyICAg
ZGF0YV9zaXplLA0KKwkJCQl1MzIgICBibG9ja19zaXplLA0KKwkJCQlkbWFfYWRkcl90ICAqbGxp
X3RhYmxlX3B0ciwNCisJCQkJdTMyICAqbnVtX2VudHJpZXNfcHRyLA0KKwkJCQl1MzIgICp0YWJs
ZV9kYXRhX3NpemVfcHRyLA0KKwkJCQlib29sICAgICAgICAgICAgaXNLZXJuZWxWaXJ0dWFsQWRk
cmVzcyk7DQorDQorLyogcG9sbChzdXNwZW5kKSAsIHVudGlsIHJlcGx5IGZyb20gc2VwICovDQor
aW50IHNlcF9kcml2ZXJfcG9sbCh1MzIgKnNvdXJjZV9wdHIpOw0KKw0KKy8qDQorCXRoaXMgZnVu
Y3Rpb24gaGFuZGxlcyB0aGUgcmVxdWVzdCBmb3IgZnJlZWluZyBkbWEgdGFibGUgZm9yDQorCXN5
bmhyb25pYyBhY3Rpb25zDQorKi8NCitpbnQgc2VwX2ZyZWVfZG1hX3RhYmxlX2RhdGFfaGFuZGxl
cih2b2lkKTsNCiANCiANCiAjZW5kaWYNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvc2Vw
L3NlcF9kcml2ZXJfY29uZmlnLmggYi9kcml2ZXJzL3N0YWdpbmcvc2VwL3NlcF9kcml2ZXJfY29u
ZmlnLmgNCmluZGV4IDYwMDhmZTUuLjBhZTE2OGQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvc2VwL3NlcF9kcml2ZXJfY29uZmlnLmgNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9zZXAvc2Vw
X2RyaXZlcl9jb25maWcuaA0KQEAgLTEsMjMgKzEsMjkgQEANCi0vKg0KLSAqDQotICogIHNlcF9k
cml2ZXJfY29uZmlnLmggLSBTZWN1cml0eSBQcm9jZXNzb3IgRHJpdmVyIGNvbmZpZ3VyYXRpb24N
Ci0gKg0KLSAqICBDb3B5cmlnaHQoYykgMjAwOSBJbnRlbCBDb3Jwb3JhdGlvbi4gQWxsIHJpZ2h0
cyByZXNlcnZlZC4NCi0gKiAgQ29weXJpZ2h0KGMpIDIwMDkgRGlzY3JldGl4LiBBbGwgcmlnaHRz
IHJlc2VydmVkLg0KLSAqDQotICogIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3Ug
Y2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5IGl0DQotICogIHVuZGVyIHRoZSB0ZXJt
cyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5IHRoZSBG
cmVlDQotICogIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YgdGhlIExp
Y2Vuc2UsIG9yIChhdCB5b3VyIG9wdGlvbikNCi0gKiAgYW55IGxhdGVyIHZlcnNpb24uDQorIC8q
DQorICogc2VwX2RyaXZlcl9jb25maWcuaA0KICAqDQotICogIFRoaXMgcHJvZ3JhbSBpcyBkaXN0
cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQgV0lUSE9VVA0K
LSAqICBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZiBN
RVJDSEFOVEFCSUxJVFkgb3INCi0gKiAgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0Uu
ICBTZWUgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvcg0KLSAqICBtb3JlIGRldGFp
bHMuDQotICoNCi0gKiAgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05V
IEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYWxvbmcgd2l0aA0KLSAqICB0aGlzIHByb2dyYW07IGlm
IG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbiwgSW5jLiwgNTkNCi0g
KiAgVGVtcGxlIFBsYWNlIC0gU3VpdGUgMzMwLCBCb3N0b24sIE1BICAwMjExMS0xMzA3LCBVU0Eu
DQorICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqDQorICogICBDb3B5cmlnaHQgMjAwOSDCqSBEaXNjcmV0aXgg
VGVjaG5vbG9naWVzIEx0ZC4gICAgICAgICAgICAgICAgICAgICAgICAgICoNCisgKiAgIENvcHly
aWdodCAyMDA5IMKpIEludGVsIENvcnBvcmF0aW9uICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKg0KKyAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoNCisgKiAgIFRoaXMgc29mdHdhcmUgaXMg
cHJvdGVjdGVkIGJ5IGNvcHlyaWdodCwgaW50ZXJuYXRpb25hbCB0cmVhdGllcyBhbmQgICAqDQor
ICogICB2YXJpb3VzIHBhdGVudHMuIEFueSBjb3B5IG9yIHJlcHJvZHVjdGlvbiBvZiB0aGlzIFNv
ZnR3YXJlIGFzICAgICAgICAgKg0KKyAqICAgcGVybWl0dGVkIGJlbG93LCBtdXN0IGluY2x1ZGUg
dGhpcyBDb3B5cmlnaHQgTm90aWNlIGFzIHdlbGwgYXMgYW55ICAgICoNCisgKiAgIG90aGVyIG5v
dGljZXMgcHJvdmlkZWQgdW5kZXIgc3VjaCBsaWNlbnNlLiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAqDQorICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKg0KKyAqICAgVGhpcyBwcm9ncmFtIHNoYWxsIGJl
IGdvdmVybmVkIGJ5LCBhbmQgbWF5IGJlIHVzZWQgYW5kIHJlZGlzdHJpYnV0ZWQgICoNCisgKiAg
IHVuZGVyIHRoZSB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UsICAgICAqDQorICogICB2ZXJzaW9uIDIsIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJl
ZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLiAgICAgICAgICAgICAgKg0KKyAqICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICoNCisgKiAgIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0
IHdpbGwgYmUgdXNlZnVsLCAgICAgICAqDQorICogICBidXQgV0lUSE9VVCBBTlkgbGlhYmlsaXR5
IGFuZCBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkICAgICAgKg0KKyAqICAgd2Fy
cmFudHkgb2YgTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQ
T1NFLiAgICAgICoNCisgKiAgIFNlZSB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9y
IG1vcmUgZGV0YWlscy4gICAgICAgICAgICAgICAgICAqDQorICogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKg0K
KyAqICAgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwg
UHVibGljIExpY2Vuc2UgICAgICoNCisgKiAgIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyBpZiBu
b3QsIHBsZWFzZSB3cml0ZSB0byB0aGUgRnJlZSBTb2Z0d2FyZSAgICAqDQorICogICBGb3VuZGF0
aW9uLCBJbmMuLCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKg0KKyAqICAgNTkgVGVtcGxlIFBsYWNlIC0gU3VpdGUgMzMwLCBCb3N0b24sIE1BICAw
MjExMS0xMzA3LCBVU0EuICAgICAgICAgICAgICoNCisgKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCiAgKg0K
ICAqICBDT05UQUNUUzoNCiAgKg0KQEAgLTI1LDEwICszMSw5IEBADQogICoNCiAgKiAgQ0hBTkdF
UzoNCiAgKg0KLSAqICAyMDA5LjA2LjI2CUluaXRpYWwgcHVibGlzaA0KKyAqICAyMDEwLjAxLjA4
CUluaXRpYWwgcHVibGlzaA0KICAqDQogICovDQotDQogI2lmbmRlZiBfX1NFUF9EUklWRVJfQ09O
RklHX0hfXw0KICNkZWZpbmUgX19TRVBfRFJJVkVSX0NPTkZJR19IX18NCiANCkBAIC0zOSw3ICs0
NCw3IEBADQogDQogLyogaWYgZmxhZyBpcyBvbiAsIHRoZW4gdGhlIGRyaXZlciBpcyBydW5uaW5n
IGluIHBvbGxpbmcgYW5kDQogCW5vdCBpbnRlcnJ1cHQgbW9kZSAqLw0KLSNkZWZpbmUgU0VQX0RS
SVZFUl9QT0xMSU5HX01PREUgICAgICAgICAgICAgICAgICAgICAgICAgMQ0KKyNkZWZpbmUgU0VQ
X0RSSVZFUl9QT0xMSU5HX01PREUgICAgICAgICAgICAgICAgICAgICAgICAgMA0KIA0KIC8qIGZs
YWcgd2hpY2ggZGVmaW5lcyBpZiB0aGUgc2hhcmVkIGFyZWEgYWRkcmVzcyBzaG91bGQgYmUNCiAJ
cmVjb25maWdlZCAoc2VuZCB0byBTRVAgYW5ldykgZHVyaW5nIGluaXQgb2YgdGhlIGRyaXZlciAq
Lw0KQEAgLTQ4LDEwICs1MywyNCBAQA0KIC8qIHRoZSBtb2RlIGZvciBydW5uaW5nIG9uIHRoZSBB
Uk0xMTcyIEV2YWx1YXRpb24gcGxhdGZvcm0gKGZsYWcgaXMgMSkgKi8NCiAjZGVmaW5lIFNFUF9E
UklWRVJfQVJNX0RFQlVHX01PREUgICAgICAgICAgICAgICAgICAgICAgIDANCiANCisvKiB0aGUg
bW9kZSBmb3IgcnVubmluZyBvbiB0aGUgUG93ZXJQQyBFdmFsdWF0aW9uIHBsYXRmb3JtIChmbGFn
IGlzIDEpICovDQorI2RlZmluZSBTRVBfRFJJVkVSX1BQQ19ERUJVR19NT0RFICAgICAgICAgICAg
ICAgICAgICAgICAwDQorDQorLyogUkFSIGxvY2sgbW9kZSAtIGNhaGNlLCByZXNpZGVudCBhbmQg
ZXh0IGNhY2hlIG11c3QgYmUgY29waWVkIHRvIGV4dGVybmFsIFJBUg0KKyAgIGFuZCBsb2NrZWQg
YnkgZHJpdmVyIGluIHRoZSBzYW1lIEFQSSAqLw0KKyNkZWZpbmUgU0VQX0RSSVZFUl9MT0NLX1JB
Ul9NT0RFICAgICAgICAgICAgICAgICAgICAgICAgMA0KKw0KKy8qIGZsYWcgd2hpY2ggZGVmaW5l
cyBpZiB0aGUgU0VQIGRyaXZlciBzaG91bGQgY29uZmlnIHRoZSBPVFAgKGZsYWcgaXMgMSksDQor
ICAgb3Igbm90IChmbGFnIGlzIDApICovDQorI2RlZmluZSBTRVBfRFJJVkVSX0NPTkZJR19PVFAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAxDQorDQogLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogCUlOVEVSTkFMIERBVEEgQ09ORklHVVJBVElPTg0KIAkt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCiANCisvKiB0aGUg
ZGlydmVyIG5hbWUgKi8NCisjZGVmaW5lIERSSVZFUl9OQU1FICJzZXBfc2VjX2RyaXZlciINCisN
CiAvKiBmbGFnIGZvciB0aGUgaW5wdXQgYXJyYXkgKi8NCiAjZGVmaW5lIFNFUF9EUklWRVJfSU5f
RkxBRyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDANCiANCkBAIC02MSw2ICs4MCwxMyBA
QA0KIC8qIG1heGltdW0gbnVtYmVyIG9mIGVudHJpZXMgaW4gb25lIExMSSB0YWJsZXMgKi8NCiAj
ZGVmaW5lIFNFUF9EUklWRVJfRU5UUklFU19QRVJfVEFCTEVfSU5fU0VQICAgICAgICAgICAgIDgN
CiANCisvKiBmbGFnIHRoYXQgc2lnbmlmaWVzIHRhaCB0aGUgbG9jayBpcw0KK2N1cnJlbnRseSBo
ZWxkIGJ5IHRoZSBwcm9jY2VzcyAoc3RydWN0IGZpbGUpICovDQorI2RlZmluZSBTRVBfRFJJVkVS
X09XTl9MT0NLX0ZMQUcgICAgICAgICAgICAgICAgICAgICAgICAxDQorDQorLyogZmxhZyB0aGF0
IHNpZ25pZmllcyB0YWggdGhlIGxvY2sgaXMgY3VycmVudGx5IE5PVA0KK2hlbGQgYnkgdGhlIHBy
b2NjZXNzIChzdHJ1Y3QgZmlsZSkgKi8NCisjZGVmaW5lIFNFUF9EUklWRVJfRElTT1dOX0xPQ0tf
RkxBRyAgICAgICAgICAgICAgICAgICAgIDANCiANCiAvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogCVNIQVJFRCBBUkVBICBtZW1vcnkg
dG90YWwgc2l6ZSBpcyAzNksNCkBAIC04Miw2ICsxMDgsMTAgQEANCiAJaXQgaXMgZGl2aWRlZCBh
cyBmb2xsb3dpbmc6DQogDQogCVRJTUVfTUVNT1JZX0FSRUEgICAgICAgICAgICAgICAgICAgICA4
Qg0KKw0KKwlSQVJfTUVNT1JZX0FSRUEgICAgICAgICAgICAgICAgICAgICAgOEINCisNCisgICAg
Q1VSUkVOVF9DQUxMRVJfSURfTUVNT1JZICAgICAgICAgICAgIDcwQg0KIC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCiANCiANCkBA
IC0xMDQsMTMgKzEzNCwxNyBAQA0KIC8qIHRoZSBzaXplIG9mIHRoZSBtZXNzYWdlIHNoYXJlZCBh
cmVhIGluIHBhZ2VzICovDQogI2RlZmluZSBTRVBfRFJJVkVSX1NZTkNIUk9OSUNfRE1BX1RBQkxF
U19BUkVBX1NJWkVfSU5fQllURVMgICAoMTAyNCAqIDUpDQogDQotDQogLyogdGhlIHNpemUgb2Yg
dGhlIGRhdGEgcG9vbCBzaGFyZWQgYXJlYSBzaXplIGluIHBhZ2VzICovDQogI2RlZmluZSBTRVBf
RFJJVkVSX0ZMT1dfRE1BX1RBQkxFU19BUkVBX1NJWkVfSU5fQllURVMgICAgICAgICAoMTAyNCAq
IDQpDQogDQogLyogc3lzdGVtIGRhdGEgKHRpbWUsIGNhbGxlciBpZCBldGMnKSBwb29sICovDQot
I2RlZmluZSBTRVBfRFJJVkVSX1NZU1RFTV9EQVRBX01FTU9SWV9TSVpFX0lOX0JZVEVTICAgICAg
ICAgICAxMDANCisjZGVmaW5lIFNFUF9EUklWRVJfU1lTVEVNX0RBVEFfTUVNT1JZX1NJWkVfSU5f
QllURVMgICAgICAgICAgICgxMDI0ICogMykNCisNCisvKiB0aGUgc2l6ZSBpbiBieXRlcyBvZiB0
aGUgdGltZSBtZW1vcnkgKi8NCisjZGVmaW5lIFNFUF9EUklWRVJfVElNRV9NRU1PUllfU0laRV9J
Tl9CWVRFUyAgICAgICAgICAgICAgICAgIDgNCiANCisvKiB0aGUgc2l6ZSBpbiBieXRlcyBvZiB0
aGUgUkFSIHBhcmFtZXRlcnMgbWVtb3J5ICovDQorI2RlZmluZSBTRVBfRFJJVkVSX1NZU1RFTV9S
QVJfTUVNT1JZX1NJWkVfSU5fQllURVMgICAgICAgICAgICA4DQogDQogLyogYXJlYSBzaXplIHRo
YXQgaXMgbWFwcGVkICAtIHdlIG1hcCB0aGUgTUVTU0FHRSBBUkVBLCBTVEFUSUMgUE9PTCBhbmQN
CiAJREFUQSBQT09MIGFyZWFzLiBhcmVhIG11c3QgYmUgbW9kdWxlIDRrICovDQpAQCAtMTUyLDEw
ICsxODYsMjMgQEANCiAjZGVmaW5lIFNFUF9EUklWRVJfU1lTVEVNX1RJTUVfTUVNT1JZX09GRlNF
VF9JTl9CWVRFUyBcDQogCShTRVBfRFJJVkVSX1NZU1RFTV9EQVRBX01FTU9SWV9PRkZTRVRfSU5f
QllURVMpDQogDQorLyogb2Zmc2V0IG9mIHRoZSBSQVIgYXJlYSAqLw0KKyNkZWZpbmUgU0VQX0RS
SVZFUl9TWVNURU1fUkFSX01FTU9SWV9PRkZTRVRfSU5fQllURVMgXA0KKwkoU0VQX0RSSVZFUl9T
WVNURU1fVElNRV9NRU1PUllfT0ZGU0VUX0lOX0JZVEVTICsgXA0KKwlTRVBfRFJJVkVSX1RJTUVf
TUVNT1JZX1NJWkVfSU5fQllURVMpDQorDQorLyogb2Zmc2V0IG9mIHRoZSBjYWxsZXIgaWQgYXJl
YSAqLw0KKyNkZWZpbmUgU0VQX0RSSVZFUl9TWVNURU1fQ0FMTEVSX0lEX01FTU9SWV9PRkZTRVRf
SU5fQllURVMgXA0KKwkoU0VQX0RSSVZFUl9TWVNURU1fUkFSX01FTU9SWV9PRkZTRVRfSU5fQllU
RVMgKyBcDQorICAgIFNFUF9EUklWRVJfU1lTVEVNX1JBUl9NRU1PUllfU0laRV9JTl9CWVRFUykN
CiANCiANCiAvKiBzdGFydCBwaHlzaWNhbCBhZGRyZXNzIG9mIHRoZSBTRVAgcmVnaXN0ZXJzIG1l
bW9yeSBpbiBIT1NUICovDQotI2RlZmluZSBTRVBfSU9fTUVNX1JFR0lPTl9TVEFSVF9BRERSRVNT
ICAgICAgICAgICAgICAgICAgICAgICAweDgwMDAwMDAwDQorI2lmIFNFUF9EUklWRVJfUFBDX0RF
QlVHX01PREUNCisgICNkZWZpbmUgU0VQX0lPX01FTV9SRUdJT05fU1RBUlRfQUREUkVTUyAgICAg
ICAgICAgICAgICAgICAgICAgMHg4M0YwMDAwMA0KKyNlbHNlDQorICAjZGVmaW5lIFNFUF9JT19N
RU1fUkVHSU9OX1NUQVJUX0FERFJFU1MgICAgICAgICAgICAgICAgICAgICAgIDB4ODAwMDAwMDAN
CisjZW5kaWYNCiANCiAvKiBzaXplIG9mIHRoZSBTRVAgcmVnaXN0ZXJzIG1lbW9yeSByZWdpb24g
IGluIEhPU1QgKGZvciBub3cgMTAwIHJlZ2lzdGVycykgKi8NCiAjZGVmaW5lIFNFUF9JT19NRU1f
UkVHSU9OX1NJWkUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICgyICogMHgxMDAwMDAp
DQpAQCAtMTg0LDQyICsyMzEsNTMgQEANCiAvKiBtYXNrIGZvciBlbnRyaWVzIGFmdGVyIGJlaW5n
IHNoaWZ0ZWQgbGVmdCAqLw0KICNkZWZpbmUgU0VQX05VTV9FTlRSSUVTX01BU0sgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgMHg3Rg0KIA0KLS8qIGRlZmF1bHQgZmxvdyBpZCAqLw0K
LSNkZWZpbmUgU0VQX0ZSRUVfRkxPV19JRCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgMHhGRkZGRkZGRg0KLQ0KLS8qIHRlbXAgZmxvdyBpZCB1c2VkIGR1cmluZyBjcmV0aW9u
ZyBvZiBuZXcgZmxvdyB1bnRpbCByZWNlaXZpbmcNCi0JcmVhbCBmbG93IGlkIGZyb20gc2VwICov
DQotI2RlZmluZSBTRVBfVEVNUF9GTE9XX0lEICAgICAgICAgICAgICAgICAgIChTRVBfRFJJVkVS
X05VTV9GTE9XUyArIDEpDQotDQotLyogbWF4aW11bSBhZGQgYnVmZmVycyBtZXNzYWdlIGxlbmd0
aCBpbiBieXRlcyAqLw0KLSNkZWZpbmUgU0VQX01BWF9BRERfTUVTU0FHRV9MRU5HVEhfSU5fQllU
RVMgICAgICAgICAgICAgICAgICAgKDcgKiA0KQ0KLQ0KIC8qIG1heGltdW0gbnVtYmVyIG9mIGNv
bmN1cnJlbnQgdmlydHVhbCBidWZmZXJzICovDQogI2RlZmluZSBTRVBfTUFYX1ZJUlRfQlVGRkVS
U19DT05DVVJSRU5UICAgICAgICAgICAgICAgICAgICAgICAxMDANCiANCiAvKiB0aGUgdG9rZW4g
dGhhdCBkZWZpbmVzIHRoZSBzdGFydCBvZiB0aW1lIGFkZHJlc3MgKi8NCiAjZGVmaW5lIFNFUF9U
SU1FX1ZBTF9UT0tFTiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDB4MTIzNDU2
NzgNCiANCisvKiBzaXplIG9mIHRoZSBjYWxsZXIgaWQgaGFzaCAoc2hhMikgKi8NCisjZGVmaW5l
IFNFUF9DQUxMRVJfSURfSEFTSF9TSVpFX0lOX0JZVEVTICAgICAgICAgICAgICAgICAgICAgIDMy
DQorDQorLyogbWF4aW11bSBudW1iZXIgb2YgZW50cmllcyBpbiB0aGUgY2FsbGVyIGlkIHRhYmxl
ICovDQorI2RlZmluZSBTRVBfQ0FMTEVSX0lEX1RBQkxFX05VTV9FTlRSSUVTICAgICAgICAgICAg
ICAgICAgICAgICAyMA0KKw0KKy8qIHRoZSB0b2tlbiB0aGF0IGRlZmluZXMgdGhlIHN0YXJ0IG9m
IHRpbWUgYWRkcmVzcyAqLw0KKyNkZWZpbmUgU0VQX1JBUl9WQUxfVE9LRU4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgMHhBQkFCQUJBQg0KKw0KKy8qIGlvY3RsIGVycm9yIHRo
YXQgc2hvdWxkIGJlIHJldHVybmVkIHdoZW4gdHJ5aW5nDQorICAgdG8gcmVhbGxvYyB0aGUgY2Fj
aGUvcmVzaWRlbnQgc2Vjb25kIHRpbWUgKi8NCisjZGVmaW5lIFNFUF9BTFJFQURZX0lOSVRJQUxJ
WkVEX0VSUiAgICAgICAgICAgICAgICAgICAgICAgICAgIDEyDQorDQorLyogYml0IHRoYXQgbG9j
a3MgYWNjZXNzIHRvIHRoZSBzaGFyZWQgYXJlYSAqLw0KKyNkZWZpbmUgU0VQX01NQVBfTE9DS19C
SVQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMA0KKw0KKy8qIGJpdCB0aGF0
IGxvY2sgYWNjZXNzIHRvIHRoZSBwb2xsICAtIGFmdGVyIHNlbmRfY29tbWFuZCAqLw0KKyNkZWZp
bmUgU0VQX1NFTkRfTVNHX0xPQ0tfQklUICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
MQ0KKw0KIC8qIERFQlVHIExFVkVMIE1BU0tTICovDQogI2RlZmluZSBTRVBfREVCVUdfTEVWRUxf
QkFTSUMgICAgICAgMHgxDQogDQorI2RlZmluZSBTRVBfREVCVUdfTEVWRUxfUkVHSVNURVJTICAg
MHgyDQorDQogI2RlZmluZSBTRVBfREVCVUdfTEVWRUxfRVhURU5ERUQgICAgMHg0DQogDQogDQot
LyogRGVidWcgaGVscGVycyAqLw0KKy8qIEZVTkNUSU9OQUwgTUFDUk9TICovDQogDQogI2RlZmlu
ZSBkYmcoZm10LCBhcmdzLi4uKSBcDQogZG8ge1wNCi0JaWYgKGRlYnVnICYgU0VQX0RFQlVHX0xF
VkVMX0JBU0lDKSBcDQorCWlmIChzZXBfZGVidWcgJiBTRVBfREVCVUdfTEVWRUxfQkFTSUMpIFwN
CiAJCXByaW50ayhLRVJOX0RFQlVHIGZtdCwgIyNhcmdzKTsgXA0KLX0gd2hpbGUoMCk7DQorfSB3
aGlsZSAoMCk7DQogDQogI2RlZmluZSBlZGJnKGZtdCwgYXJncy4uLikgXA0KIGRvIHsgXA0KLQlp
ZiAoZGVidWcgJiBTRVBfREVCVUdfTEVWRUxfRVhURU5ERUQpIFwNCisJaWYgKHNlcF9kZWJ1ZyAm
IFNFUF9ERUJVR19MRVZFTF9FWFRFTkRFRCkgXA0KIAkJcHJpbnRrKEtFUk5fREVCVUcgZm10LCAj
I2FyZ3MpOyBcDQotfSB3aGlsZSgwKTsNCit9IHdoaWxlICgwKTsNCiANCiANCiANCi0jZW5kaWYN
CisjZW5kaWYgLypfX1NFUF9EUklWRVJfQ09ORklHX0hfXyovDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3NlcC9zZXBfZHJpdmVyX2V4dF9hcGkuaCBiL2RyaXZlcnMvc3RhZ2luZy9zZXAv
c2VwX2RyaXZlcl9leHRfYXBpLmgNCm5ldyBmaWxlIG1vZGUgMTAwNjQ0DQppbmRleCAwMDAwMDAw
Li4yMjAxNjRiDQotLS0gL2Rldi9udWxsDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvc2VwL3NlcF9k
cml2ZXJfZXh0X2FwaS5oDQpAQCAtMCwwICsxLDEyNyBAQA0KKy8qDQorICogc2VwX2RyaXZlcl9l
eHRfYXBpLmgNCisgKg0KKyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KKyAqICAgQ29weXJpZ2h0IDIwMDkg
wqkgRGlzY3JldGl4IFRlY2hub2xvZ2llcyBMdGQuICAgICAgICAgICAgICAgICAgICAgICAgICAq
DQorICogICBDb3B5cmlnaHQgMjAwOSDCqSBJbnRlbCBDb3Jwb3JhdGlvbiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICoNCisgKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqDQorICogICBUaGlz
IHNvZnR3YXJlIGlzIHByb3RlY3RlZCBieSBjb3B5cmlnaHQsIGludGVybmF0aW9uYWwgdHJlYXRp
ZXMgYW5kICAgKg0KKyAqICAgdmFyaW91cyBwYXRlbnRzLiBBbnkgY29weSBvciByZXByb2R1Y3Rp
b24gb2YgdGhpcyBTb2Z0d2FyZSBhcyAgICAgICAgICoNCisgKiAgIHBlcm1pdHRlZCBiZWxvdywg
bXVzdCBpbmNsdWRlIHRoaXMgQ29weXJpZ2h0IE5vdGljZSBhcyB3ZWxsIGFzIGFueSAgICAqDQor
ICogICBvdGhlciBub3RpY2VzIHByb3ZpZGVkIHVuZGVyIHN1Y2ggbGljZW5zZS4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKg0KKyAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoNCisgKiAgIFRoaXMgcHJv
Z3JhbSBzaGFsbCBiZSBnb3Zlcm5lZCBieSwgYW5kIG1heSBiZSB1c2VkIGFuZCByZWRpc3RyaWJ1
dGVkICAqDQorICogICB1bmRlciB0aGUgdGVybXMgYW5kIGNvbmRpdGlvbnMgb2YgdGhlIEdOVSBH
ZW5lcmFsIFB1YmxpYyBMaWNlbnNlLCAgICAgKg0KKyAqICAgdmVyc2lvbiAyLCBhcyBwdWJsaXNo
ZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbi4gICAgICAgICAgICAgICoNCisgKiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqDQorICogICBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhl
IGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwgICAgICAgKg0KKyAqICAgYnV0IFdJVEhPVVQg
QU5ZIGxpYWJpbGl0eSBhbmQgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCAgICAg
ICoNCisgKiAgIHdhcnJhbnR5IG9mIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBB
UlRJQ1VMQVIgUFVSUE9TRS4gICAgICAqDQorICogICBTZWUgdGhlIEdOVSBHZW5lcmFsIFB1Ymxp
YyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuICAgICAgICAgICAgICAgICAgKg0KKyAqICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICoNCisgKiAgIFlvdSBzaG91bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhl
IEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlICAgICAqDQorICogICBhbG9uZyB3aXRoIHRoaXMg
cHJvZ3JhbTsgaWYgbm90LCBwbGVhc2Ugd3JpdGUgdG8gdGhlIEZyZWUgU29mdHdhcmUgICAgKg0K
KyAqICAgRm91bmRhdGlvbiwgSW5jLiwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICoNCisgKiAgIDU5IFRlbXBsZSBQbGFjZSAtIFN1aXRlIDMzMCwg
Qm9zdG9uLCBNQSAgMDIxMTEtMTMwNywgVVNBLiAgICAgICAgICAgICAqDQorICoqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqDQorICoNCisgKiAgQ09OVEFDVFM6DQorICoNCisgKiAgTWFyayBBbGx5bgkJbWFyay5h
LmFsbHluQGludGVsLmNvbQ0KKyAqDQorICogIENIQU5HRVM6DQorICoNCisgKiAgMjAxMC4wMS4w
OAlJbml0aWFsIHB1Ymxpc2gNCisgKg0KKyAqLw0KKw0KKyNpZm5kZWYgX19TRVBfRFJJVkVSX0VY
VF9BUElfSF9fDQorI2RlZmluZSBfX1NFUF9EUklWRVJfRVhUX0FQSV9IX18NCisNCisNCisvKg0K
K1RoaXMgZnVuY3Rpb25zIGxvY2tzIHRoZSBhcmVhIG9mIHRoZSByZXNpZGVudCBhbmQgY2FjaGUg
c2VwIGNvZGUgKGlmIHBvc3NpYmxlKQ0KKyovDQoraW50IHNlcF9sb2NrX2NhY2hlX3Jlc2lkZW50
X2FyZWEodm9pZCk7DQorDQorLyoNCitUaGlzIGZ1bmN0aW9ucyBjb3BpZXMgdGhlIGNhY2hlIGFu
ZCByZXNpZGVudCBmcm9tIHRoZWlyIHNvdXJjZSBsb2NhdGlvbiBpbnRvDQorZGVzdGluYXRpb24g
bWVtb3J5LCB3aGljaCBpcyBleHRlcm5hbCB0byBMaW51eCBWTSBhbmQgaXMgZ2l2ZW4gYXMgcGh5
c2ljYWwNCithZGRyZXNzDQorKi8NCitpbnQgc2VwX2NvcHlfY2FjaGVfcmVzaWRlbnRfdG9fYXJl
YShzdHJ1Y3QgZGV2aWNlX2NvbnRleHQgKnNlcF9jb250ZXh0X3B0ciwNCisgICAgICBkbWFfYWRk
cl90ICAqZHN0X25ld19jYWNoZV9hZGRyX3B0ciwNCisgICAgICBkbWFfYWRkcl90ICAqZHN0X25l
d19yZXNpZGVudF9hZGRyX3B0ciwNCisgICAgICBkbWFfYWRkcl90ICAqZHN0X25ld19kY2FjaGVf
YWRkcl9wdHIpOw0KKw0KKy8qDQorICBUaGlzIGZ1bmN0aW9ucyBjb3BpZXMgdGhlIGV4dGVybmFs
IGNhY2hlICgzcmQgcGFydHkpIGZyb20NCisgIGl0J3Mgc291cmNlIGxvY2F0aW9uIGludG8gZGVz
dGluYXRpb24gbWVtb3J5LA0KKyAgd2hpY2ggaXMgZXh0ZXJuYWwgdG8gTGludXggVk0gYW5kIGlz
IGdpdmVuIGFzIHBoeXNpY2FsIGFkZHJlc3MuDQorICBJdCBpcyBzdXBwb3NlZCB0byBiZSBhZGp1
c3RlbnQgdG8gdGhlIGktY2FjaGUgYm91bmRhcnkNCisqLw0KK2ludCBzZXBfY29weV9leHRfY2Fj
aGVfdG9fYXJlYSh2b2lkICpzcmNfZXh0X2NhY2hlX2FkZHIsDQorICAgICAgdTMyICAgZXh0X2Nh
Y2hlX3NpemVfaW5fYnl0ZXMsDQorICAgICAgZG1hX2FkZHJfdCAgKmV4dF9jYWNoZV9idXNfYWRk
cl9wdHIpOw0KKw0KKw0KKw0KKy8qDQorVGhpcyBmdW5jdGlvbnMgbWFwcyBhbmQgYWxsb2NhdGVz
IHRoZSBzaGFyZWQgYXJlYSBvbiB0aGUgZXh0ZXJuYWwNCitSQU0gKGRldmljZSkgVGhlIGlucHV0
IGlzIHNoYXJlZF9hcmVhX3NpemUgLSB0aGUgc2l6ZSBvZiB0aGUgbWVtb3J5DQordG8gYWxsb2Nh
dGUuIFRoZSBvdXRwdXRzIGFyZSBrZXJuZWxfc2hhcmVkX2FyZWFfYWRkcl9wdHIgLSB0aGUga2Vy
ZW5sDQorYWRkcmVzcyBvZiB0aGUgbWFwcGVkIGFuZCBhbGxvY2F0ZWQgc2hhcmVkIGFyZWEsIGFu
ZA0KK3BoeXNfc2hhcmVkX2FyZWFfYWRkcl9wdHIgLSB0aGUgcGh5c2ljYWwgYWRkcmVzcyBvZiB0
aGUgc2hhcmVkIGFyZWENCisqLw0KK2ludCBzZXBfbWFwX2FuZF9hbGxvY19zaGFyZWRfYXJlYShz
dHJ1Y3QgZGV2aWNlX2NvbnRleHQgKnNlcF9jb250ZXh0X3B0cik7DQorDQorLyoNCitUaGlzIGZ1
bmN0aW9ucyB1bm1hcHMgYW5kIGRlYWxsb2NhdGVzIHRoZSBzaGFyZWQgYXJlYSBvbiB0aGUgIGV4
dGVybmFsDQorUkFNIChkZXZpY2UpIFRoZSBpbnB1dCBpcyBzaGFyZWRfYXJlYV9zaXplIC0gdGhl
IHNpemUgb2YgdGhlIG1lbW9yeSB0bw0KK2RlYWxsb2NhdGUsa2VybmVsX3NoYXJlZF9hcmVhX2Fk
ZHJfcHRyIC0gdGhlIGtlcm5lbCBhZGRyZXNzIG9mIHRoZQ0KK21hcHBlZCBhbmQgYWxsb2NhdGVk
IHNoYXJlZCBhcmVhLHBoeXNfc2hhcmVkX2FyZWFfYWRkcl9wdHIgLSB0aGUgcGh5c2ljYWwNCith
ZGRyZXNzIG9mIHRoZSBzaGFyZWQgYXJlYQ0KKyovDQordm9pZCBzZXBfdW5tYXBfYW5kX2ZyZWVf
c2hhcmVkX2FyZWEoc3RydWN0IGRldmljZV9jb250ZXh0ICpzZXBfY29udGV4dF9wdHIpOw0KKw0K
Kw0KKy8qDQorVGhpcyBmdW5jdGlvbnMgcmV0dXJucyB0aGUgcGh5c2ljYWwgYWRkcmVzcyBpbnNp
ZGUgc2hhcmVkIGFyZWEgYWNjb3JkaW5nDQordG8gdGhlIHZpcnR1YWwgYWRkcmVzcy4gSXQgY2Fu
IGJlIGVpdGhlciBvbiB0aGUgZXh0ZXJuYSBSQU0gZGV2aWNlDQorKGlvcmVtYXBwZWQpLCBvciBv
biB0aGUgc3lzdGVtIFJBTQ0KKyovDQorZG1hX2FkZHJfdCBzZXBfc2hhcmVkX2FyZWFfdmlydF90
b19idXMoc3RydWN0IGRldmljZV9jb250ZXh0ICpzZXBfY29udGV4dF9wdHIsDQorICAgICAgdm9p
ZCAgKnZpcnRfYWRkcmVzcyk7DQorDQorLyoNCitUaGlzIGZ1bmN0aW9ucyByZXR1cm5zIHRoZSB2
aXRydWFsIGFkZHJlc3MgaW5zaWRlIHNoYXJlZCBhcmVhIGFjY29yZGluZw0KK3RvIHRoZSBwaHlz
aWNhbCBhZGRyZXNzLiBJdCBjYW4gYmUgZWl0aGVyIG9uIHRoZSBleHRlcm5hIFJBTSBkZXZpY2UN
CisoaW9yZW1hcHBlZCksIG9yIG9uIHRoZSBzeXN0ZW0gUkFNIFRoaXMgaW1wbGVtZW50YXRpb24g
aXMgZm9yIHRoZSBleHRlcm5hbCBSQU0NCisqLw0KK3ZvaWQgICpzZXBfc2hhcmVkX2FyZWFfYnVz
X3RvX3ZpcnQoc3RydWN0IGRldmljZV9jb250ZXh0ICpzZXBfY29udGV4dF9wdHIsDQorICAgICAg
ZG1hX2FkZHJfdCBidXNfYWRkcmVzcyk7DQorDQorLyoNCitUaGlzIGZ1bmN0aW9uIHJlZ2lzdGVy
cyB0aCBkcml2ZXIgdG8gdGhlIGRldmljZQ0KK3N1YnN5c3RlbSAoZWl0aGVyIFBDSSwgVVNCLCBl
dGMpDQorKi8NCitpbnQgc2VwX3JlZ2lzdGVyX2RyaXZlcl90b19kZXZpY2Uodm9pZCk7DQorDQor
LyoNCitUaGlzIGZ1bmN0aW9uIHRyYW5zbGF0ZXMgdGhlIFJBUiBoYW5kbGUgaW50byB0aGUgYnVz
IGFkZHJlc3MNCisqLw0KK2ludCBzZXBfcmFyX2hhbmRsZV90b19idXModm9pZCAqcmFyX2hhbmRs
ZSAsIGRtYV9hZGRyX3QgKnJhcl9idXMpOw0KKw0KK2V4dGVybiBzdHJ1Y3QgZGV2aWNlX2NvbnRl
eHQgc2VwX2NvbnRleHQ7DQorDQorLyoNCitJbnRlcnJ1cHQgaGFuZGxlcg0KKyovDQoraXJxcmV0
dXJuX3Qgc2VwX2ludGhhbmRsZXIoaW50IGlycSwgdm9pZCAqZGV2X2lkKTsNCisNCisvKg0KK0Nh
bGxiYWNrIHRvIGJlIHVzZWQgdG8gZnVybmlzaCBhZGRyZXNzZXMgd2hlbiByZWFkeQ0KKyovDQor
aW50IHNlcF9jYWxsYmFjayh2b2lkICpzZXBfY29udGV4dF9wb2ludGVyKTsNCisNCisjZW5kaWYg
LypfX1NFUF9EUklWRVJfRVhUX0FQSV9IX18qLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2lu
Zy9zZXAvc2VwX2RyaXZlcl9od19kZWZzLmggYi9kcml2ZXJzL3N0YWdpbmcvc2VwL3NlcF9kcml2
ZXJfaHdfZGVmcy5oDQppbmRleCBlYTZhYmQ4Li5iNTcxMjU2IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3NlcC9zZXBfZHJpdmVyX2h3X2RlZnMuaA0KKysrIGIvZHJpdmVycy9zdGFnaW5n
L3NlcC9zZXBfZHJpdmVyX2h3X2RlZnMuaA0KQEAgLTEsMjMgKzEsMjkgQEANCiAvKg0KKyAqIHNl
cF9kcml2ZXJfaHdfZGVmcy5oDQogICoNCi0gKiAgc2VwX2RyaXZlcl9od19kZWZzLmggLSBTZWN1
cml0eSBQcm9jZXNzb3IgRHJpdmVyIGhhcmR3YXJlIGRlZmluaXRpb25zDQotICoNCi0gKiAgQ29w
eXJpZ2h0KGMpIDIwMDkgSW50ZWwgQ29ycG9yYXRpb24uIEFsbCByaWdodHMgcmVzZXJ2ZWQuDQot
ICogIENvcHlyaWdodChjKSAyMDA5IERpc2NyZXRpeC4gQWxsIHJpZ2h0cyByZXNlcnZlZC4NCi0g
Kg0KLSAqICBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1
dGUgaXQgYW5kL29yIG1vZGlmeSBpdA0KLSAqICB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBH
ZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZQ0KLSAqICBTb2Z0
d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQg
eW91ciBvcHRpb24pDQotICogIGFueSBsYXRlciB2ZXJzaW9uLg0KLSAqDQotICogIFRoaXMgcHJv
Z3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBi
dXQgV0lUSE9VVA0KLSAqICBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3
YXJyYW50eSBvZiBNRVJDSEFOVEFCSUxJVFkgb3INCi0gKiAgRklUTkVTUyBGT1IgQSBQQVJUSUNV
TEFSIFBVUlBPU0UuICBTZWUgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvcg0KLSAq
ICBtb3JlIGRldGFpbHMuDQotICoNCi0gKiAgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29w
eSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYWxvbmcgd2l0aA0KLSAqICB0aGlz
IHByb2dyYW07IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbiwg
SW5jLiwgNTkNCi0gKiAgVGVtcGxlIFBsYWNlIC0gU3VpdGUgMzMwLCBCb3N0b24sIE1BICAwMjEx
MS0xMzA3LCBVU0EuDQorICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqDQorICogICBDb3B5cmlnaHQgMjAwOSDC
qSBEaXNjcmV0aXggVGVjaG5vbG9naWVzIEx0ZC4gICAgICAgICAgICAgICAgICAgICAgICAgICoN
CisgKiAgIENvcHlyaWdodCAyMDA5IMKpIEludGVsIENvcnBvcmF0aW9uICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgKg0KKyAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoNCisgKiAgIFRoaXMg
c29mdHdhcmUgaXMgcHJvdGVjdGVkIGJ5IGNvcHlyaWdodCwgaW50ZXJuYXRpb25hbCB0cmVhdGll
cyBhbmQgICAqDQorICogICB2YXJpb3VzIHBhdGVudHMuIEFueSBjb3B5IG9yIHJlcHJvZHVjdGlv
biBvZiB0aGlzIFNvZnR3YXJlIGFzICAgICAgICAgKg0KKyAqICAgcGVybWl0dGVkIGJlbG93LCBt
dXN0IGluY2x1ZGUgdGhpcyBDb3B5cmlnaHQgTm90aWNlIGFzIHdlbGwgYXMgYW55ICAgICoNCisg
KiAgIG90aGVyIG5vdGljZXMgcHJvdmlkZWQgdW5kZXIgc3VjaCBsaWNlbnNlLiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqDQorICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKg0KKyAqICAgVGhpcyBwcm9n
cmFtIHNoYWxsIGJlIGdvdmVybmVkIGJ5LCBhbmQgbWF5IGJlIHVzZWQgYW5kIHJlZGlzdHJpYnV0
ZWQgICoNCisgKiAgIHVuZGVyIHRoZSB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB0aGUgR05VIEdl
bmVyYWwgUHVibGljIExpY2Vuc2UsICAgICAqDQorICogICB2ZXJzaW9uIDIsIGFzIHB1Ymxpc2hl
ZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLiAgICAgICAgICAgICAgKg0KKyAqICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICoNCisgKiAgIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUg
aG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCAgICAgICAqDQorICogICBidXQgV0lUSE9VVCBB
TlkgbGlhYmlsaXR5IGFuZCBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkICAgICAg
Kg0KKyAqICAgd2FycmFudHkgb2YgTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFS
VElDVUxBUiBQVVJQT1NFLiAgICAgICoNCisgKiAgIFNlZSB0aGUgR05VIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4gICAgICAgICAgICAgICAgICAqDQorICogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKg0KKyAqICAgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUg
R05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgICAgICoNCisgKiAgIGFsb25nIHdpdGggdGhpcyBw
cm9ncmFtOyBpZiBub3QsIHBsZWFzZSB3cml0ZSB0byB0aGUgRnJlZSBTb2Z0d2FyZSAgICAqDQor
ICogICBGb3VuZGF0aW9uLCBJbmMuLCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKg0KKyAqICAgNTkgVGVtcGxlIFBsYWNlIC0gU3VpdGUgMzMwLCBC
b3N0b24sIE1BICAwMjExMS0xMzA3LCBVU0EuICAgICAgICAgICAgICoNCisgKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioNCiAgKg0KICAqICBDT05UQUNUUzoNCiAgKg0KQEAgLTI1LDcgKzMxLDcgQEANCiAgKg0K
ICAqICBDSEFOR0VTOg0KICAqDQotICogIDIwMDkuMDYuMjYJSW5pdGlhbCBwdWJsaXNoDQorICog
IDIwMTAuMDEuMDgJSW5pdGlhbCBwdWJsaXNoDQogICoNCiAgKi8NCiANCkBAIC0zOSwxOTQgKzQ1
LDIwMiBAQA0KIC8qICAgICAgIERPIE5PVCBFRElUIFRISVMgRklMRSAhISEgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLw0KIC8qLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0K
IA0KKyNpZmRlZiBfX2NwbHVzcGx1cw0KK2V4dGVybiAiQyINCit7DQorI2VuZGlmDQogDQogLyog
Y2YgcmVnaXN0ZXJzICovDQotI2RlZmluZSAJIEhXX1IwQl9BRERSXzBfUkVHX0FERFIgCQkgMHgw
MDAwVUwNCi0jZGVmaW5lIAkgSFdfUjBCX0FERFJfMV9SRUdfQUREUiAJCSAweDAwMDRVTA0KLSNk
ZWZpbmUgCSBIV19SMEJfQUREUl8yX1JFR19BRERSIAkJIDB4MDAwOFVMDQotI2RlZmluZSAJIEhX
X1IwQl9BRERSXzNfUkVHX0FERFIgCQkgMHgwMDBjVUwNCi0jZGVmaW5lIAkgSFdfUjBCX0FERFJf
NF9SRUdfQUREUiAJCSAweDAwMTBVTA0KLSNkZWZpbmUgCSBIV19SMEJfQUREUl81X1JFR19BRERS
IAkJIDB4MDAxNFVMDQotI2RlZmluZSAJIEhXX1IwQl9BRERSXzZfUkVHX0FERFIgCQkgMHgwMDE4
VUwNCi0jZGVmaW5lIAkgSFdfUjBCX0FERFJfN19SRUdfQUREUiAJCSAweDAwMWNVTA0KLSNkZWZp
bmUgCSBIV19SMEJfQUREUl84X1JFR19BRERSIAkJIDB4MDAyMFVMDQotI2RlZmluZSAJIEhXX1Iy
Ql9BRERSXzBfUkVHX0FERFIgCQkgMHgwMDgwVUwNCi0jZGVmaW5lIAkgSFdfUjJCX0FERFJfMV9S
RUdfQUREUiAJCSAweDAwODRVTA0KLSNkZWZpbmUgCSBIV19SMkJfQUREUl8yX1JFR19BRERSIAkJ
IDB4MDA4OFVMDQotI2RlZmluZSAJIEhXX1IyQl9BRERSXzNfUkVHX0FERFIgCQkgMHgwMDhjVUwN
Ci0jZGVmaW5lIAkgSFdfUjJCX0FERFJfNF9SRUdfQUREUiAJCSAweDAwOTBVTA0KLSNkZWZpbmUg
CSBIV19SMkJfQUREUl81X1JFR19BRERSIAkJIDB4MDA5NFVMDQotI2RlZmluZSAJIEhXX1IyQl9B
RERSXzZfUkVHX0FERFIgCQkgMHgwMDk4VUwNCi0jZGVmaW5lIAkgSFdfUjJCX0FERFJfN19SRUdf
QUREUiAJCSAweDAwOWNVTA0KLSNkZWZpbmUgCSBIV19SMkJfQUREUl84X1JFR19BRERSIAkJIDB4
MDBhMFVMDQotI2RlZmluZSAJIEhXX1IzQl9SRUdfQUREUiAJCSAgICAgICAgIDB4MDBDMFVMDQot
I2RlZmluZSAJIEhXX1I0Ql9SRUdfQUREUiAJCSAgICAgICAgIDB4MDEwMFVMDQotI2RlZmluZSAJ
IEhXX0NTQV9BRERSXzBfUkVHX0FERFIgCQkgMHgwMTQwVUwNCi0jZGVmaW5lIAkgSFdfQ1NBX0FE
RFJfMV9SRUdfQUREUiAJCSAweDAxNDRVTA0KLSNkZWZpbmUgCSBIV19DU0FfQUREUl8yX1JFR19B
RERSIAkJIDB4MDE0OFVMDQotI2RlZmluZSAJIEhXX0NTQV9BRERSXzNfUkVHX0FERFIgCQkgMHgw
MTRjVUwNCi0jZGVmaW5lIAkgSFdfQ1NBX0FERFJfNF9SRUdfQUREUiAJCSAweDAxNTBVTA0KLSNk
ZWZpbmUgCSBIV19DU0FfQUREUl81X1JFR19BRERSIAkJIDB4MDE1NFVMDQotI2RlZmluZSAJIEhX
X0NTQV9BRERSXzZfUkVHX0FERFIgCQkgMHgwMTU4VUwNCi0jZGVmaW5lIAkgSFdfQ1NBX0FERFJf
N19SRUdfQUREUiAJCSAweDAxNWNVTA0KLSNkZWZpbmUgCSBIV19DU0FfQUREUl84X1JFR19BRERS
IAkJIDB4MDE2MFVMDQotI2RlZmluZSAJIEhXX0NTQV9SRUdfQUREUiAJCSAgICAgICAgIDB4MDE0
MFVMDQotI2RlZmluZSAJIEhXX1NJTkJfUkVHX0FERFIgCQkgICAgICAgICAweDAxODBVTA0KLSNk
ZWZpbmUgCSBIV19TT1VUQl9SRUdfQUREUiAJCSAgICAgICAgIDB4MDE4NFVMDQotI2RlZmluZSAJ
IEhXX1BLSV9DT05UUk9MX1JFR19BRERSIAkJIDB4MDFDMFVMDQotI2RlZmluZSAJIEhXX1BLSV9T
VEFUVVNfUkVHX0FERFIgCQkgMHgwMUM0VUwNCi0jZGVmaW5lIAkgSFdfUEtJX0JVU1lfUkVHX0FE
RFIgCQkgICAgIDB4MDFDOFVMDQotI2RlZmluZSAJIEhXX1BLSV9BXzEwMjVfUkVHX0FERFIgCQkg
MHgwMUNDVUwNCi0jZGVmaW5lIAkgSFdfUEtJX1NETUFfQ1RMX1JFR19BRERSIAkJIDB4MDFEMFVM
DQotI2RlZmluZSAJIEhXX1BLSV9TRE1BX09GRlNFVF9SRUdfQUREUiAJIDB4MDFENFVMDQotI2Rl
ZmluZSAJIEhXX1BLSV9TRE1BX1BPSU5URVJTX1JFR19BRERSIAkgMHgwMUQ4VUwNCi0jZGVmaW5l
IAkgSFdfUEtJX1NETUFfRExFTkdfUkVHX0FERFIgCQkgMHgwMURDVUwNCi0jZGVmaW5lIAkgSFdf
UEtJX1NETUFfRVhQX1BPSU5URVJTX1JFR19BRERSIAkgMHgwMUUwVUwNCi0jZGVmaW5lIAkgSFdf
UEtJX1NETUFfUkVTX1BPSU5URVJTX1JFR19BRERSIAkgMHgwMUU0VUwNCi0jZGVmaW5lIAkgSFdf
UEtJX0NMUl9SRUdfQUREUiAJCSAgICAgICAgIDB4MDFFOFVMDQotI2RlZmluZSAJIEhXX1BLSV9T
RE1BX0JVU1lfUkVHX0FERFIgCQkgICAgIDB4MDFFOFVMDQotI2RlZmluZSAJIEhXX1BLSV9TRE1B
X0ZJUlNUX0VYUF9OX1JFR19BRERSIAkgMHgwMUVDVUwNCi0jZGVmaW5lIAkgSFdfUEtJX1NETUFf
TVVMX0JZMV9SRUdfQUREUiAJCSAweDAxRjBVTA0KLSNkZWZpbmUgCSBIV19QS0lfU0RNQV9STVVM
X1NFTF9SRUdfQUREUiAJCSAweDAxRjRVTA0KLSNkZWZpbmUgCSBIV19ERVNfS0VZXzBfUkVHX0FE
RFIgCQkgICAgICAgICAweDAyMDhVTA0KLSNkZWZpbmUgCSBIV19ERVNfS0VZXzFfUkVHX0FERFIg
CQkgICAgICAgICAweDAyMENVTA0KLSNkZWZpbmUgCSBIV19ERVNfS0VZXzJfUkVHX0FERFIgCQkg
ICAgICAgICAweDAyMTBVTA0KLSNkZWZpbmUgCSBIV19ERVNfS0VZXzNfUkVHX0FERFIgCQkgICAg
ICAgICAweDAyMTRVTA0KLSNkZWZpbmUgCSBIV19ERVNfS0VZXzRfUkVHX0FERFIgCQkgICAgICAg
ICAweDAyMThVTA0KLSNkZWZpbmUgCSBIV19ERVNfS0VZXzVfUkVHX0FERFIgCQkgICAgICAgICAw
eDAyMUNVTA0KLSNkZWZpbmUgCSBIV19ERVNfQ09OVFJPTF8wX1JFR19BRERSIAkgICAgICAgICAw
eDAyMjBVTA0KLSNkZWZpbmUgCSBIV19ERVNfQ09OVFJPTF8xX1JFR19BRERSIAkgICAgICAgICAw
eDAyMjRVTA0KLSNkZWZpbmUgCSBIV19ERVNfSVZfMF9SRUdfQUREUiAJCSAgICAgICAgIDB4MDIy
OFVMDQotI2RlZmluZSAJIEhXX0RFU19JVl8xX1JFR19BRERSIAkJICAgICAgICAgMHgwMjJDVUwN
Ci0jZGVmaW5lIAkgSFdfQUVTX0tFWV8wX0FERFJfMF9SRUdfQUREUiAJCSAweDA0MDBVTA0KLSNk
ZWZpbmUgCSBIV19BRVNfS0VZXzBfQUREUl8xX1JFR19BRERSIAkJIDB4MDQwNFVMDQotI2RlZmlu
ZSAJIEhXX0FFU19LRVlfMF9BRERSXzJfUkVHX0FERFIgCQkgMHgwNDA4VUwNCi0jZGVmaW5lIAkg
SFdfQUVTX0tFWV8wX0FERFJfM19SRUdfQUREUiAJCSAweDA0MGNVTA0KLSNkZWZpbmUgCSBIV19B
RVNfS0VZXzBfQUREUl80X1JFR19BRERSIAkJIDB4MDQxMFVMDQotI2RlZmluZSAJIEhXX0FFU19L
RVlfMF9BRERSXzVfUkVHX0FERFIgCQkgMHgwNDE0VUwNCi0jZGVmaW5lIAkgSFdfQUVTX0tFWV8w
X0FERFJfNl9SRUdfQUREUiAJCSAweDA0MThVTA0KLSNkZWZpbmUgCSBIV19BRVNfS0VZXzBfQURE
Ul83X1JFR19BRERSIAkJIDB4MDQxY1VMDQotI2RlZmluZSAJIEhXX0FFU19LRVlfMF9SRUdfQURE
UiAJCSAgICAgICAgIDB4MDQwMFVMDQotI2RlZmluZSAJIEhXX0FFU19JVl8wX0FERFJfMF9SRUdf
QUREUiAJCSAweDA0NDBVTA0KLSNkZWZpbmUgCSBIV19BRVNfSVZfMF9BRERSXzFfUkVHX0FERFIg
CQkgMHgwNDQ0VUwNCi0jZGVmaW5lIAkgSFdfQUVTX0lWXzBfQUREUl8yX1JFR19BRERSIAkJIDB4
MDQ0OFVMDQotI2RlZmluZSAJIEhXX0FFU19JVl8wX0FERFJfM19SRUdfQUREUiAJCSAweDA0NGNV
TA0KLSNkZWZpbmUgCSBIV19BRVNfSVZfMF9SRUdfQUREUiAJCSAgICAgICAgIDB4MDQ0MFVMDQot
I2RlZmluZSAJIEhXX0FFU19DVFIxX0FERFJfMF9SRUdfQUREUiAJCSAweDA0NjBVTA0KLSNkZWZp
bmUgCSBIV19BRVNfQ1RSMV9BRERSXzFfUkVHX0FERFIgCQkgMHgwNDY0VUwNCi0jZGVmaW5lIAkg
SFdfQUVTX0NUUjFfQUREUl8yX1JFR19BRERSIAkJIDB4MDQ2OFVMDQotI2RlZmluZSAJIEhXX0FF
U19DVFIxX0FERFJfM19SRUdfQUREUiAJCSAweDA0NmNVTA0KLSNkZWZpbmUgCSBIV19BRVNfQ1RS
MV9SRUdfQUREUiAJCSAgICAgICAgIDB4MDQ2MFVMDQotI2RlZmluZSAJIEhXX0FFU19TS19SRUdf
QUREUiAJCSAgICAgICAgIDB4MDQ3OFVMDQotI2RlZmluZSAJIEhXX0FFU19NQUNfT0tfUkVHX0FE
RFIgCQkgICAgIDB4MDQ4MFVMDQotI2RlZmluZSAJIEhXX0FFU19QUkVWX0lWXzBfQUREUl8wX1JF
R19BRERSIAkgMHgwNDkwVUwNCi0jZGVmaW5lIAkgSFdfQUVTX1BSRVZfSVZfMF9BRERSXzFfUkVH
X0FERFIgCSAweDA0OTRVTA0KLSNkZWZpbmUgCSBIV19BRVNfUFJFVl9JVl8wX0FERFJfMl9SRUdf
QUREUiAJIDB4MDQ5OFVMDQotI2RlZmluZSAJIEhXX0FFU19QUkVWX0lWXzBfQUREUl8zX1JFR19B
RERSIAkgMHgwNDljVUwNCi0jZGVmaW5lIAkgSFdfQUVTX1BSRVZfSVZfMF9SRUdfQUREUiAJCSAg
ICAgMHgwNDkwVUwNCi0jZGVmaW5lIAkgSFdfQUVTX0NPTlRST0xfUkVHX0FERFIgCQkgICAgIDB4
MDRDMFVMDQotI2RlZmluZSAJIEhXX0hBU0hfSDBfUkVHX0FERFIgCQkgICAgIDB4MDY0MFVMDQot
I2RlZmluZSAJIEhXX0hBU0hfSDFfUkVHX0FERFIgCQkgICAgIDB4MDY0NFVMDQotI2RlZmluZSAJ
IEhXX0hBU0hfSDJfUkVHX0FERFIgCQkgICAgIDB4MDY0OFVMDQotI2RlZmluZSAJIEhXX0hBU0hf
SDNfUkVHX0FERFIgCQkgICAgIDB4MDY0Q1VMDQotI2RlZmluZSAJIEhXX0hBU0hfSDRfUkVHX0FE
RFIgCQkgICAgIDB4MDY1MFVMDQotI2RlZmluZSAJIEhXX0hBU0hfSDVfUkVHX0FERFIgCQkgICAg
IDB4MDY1NFVMDQotI2RlZmluZSAJIEhXX0hBU0hfSDZfUkVHX0FERFIgCQkgICAgIDB4MDY1OFVM
DQotI2RlZmluZSAJIEhXX0hBU0hfSDdfUkVHX0FERFIgCQkgICAgIDB4MDY1Q1VMDQotI2RlZmlu
ZSAJIEhXX0hBU0hfSDhfUkVHX0FERFIgCQkgICAgIDB4MDY2MFVMDQotI2RlZmluZSAJIEhXX0hB
U0hfSDlfUkVHX0FERFIgCQkgICAgIDB4MDY2NFVMDQotI2RlZmluZSAJIEhXX0hBU0hfSDEwX1JF
R19BRERSIAkJICAgICAweDA2NjhVTA0KLSNkZWZpbmUgCSBIV19IQVNIX0gxMV9SRUdfQUREUiAJ
CSAgICAgMHgwNjZDVUwNCi0jZGVmaW5lIAkgSFdfSEFTSF9IMTJfUkVHX0FERFIgCQkgICAgIDB4
MDY3MFVMDQotI2RlZmluZSAJIEhXX0hBU0hfSDEzX1JFR19BRERSIAkJICAgICAweDA2NzRVTA0K
LSNkZWZpbmUgCSBIV19IQVNIX0gxNF9SRUdfQUREUiAJCSAgICAgMHgwNjc4VUwNCi0jZGVmaW5l
IAkgSFdfSEFTSF9IMTVfUkVHX0FERFIgCQkgICAgIDB4MDY3Q1VMDQotI2RlZmluZSAJIEhXX0hB
U0hfQ09OVFJPTF9SRUdfQUREUiAJCSAweDA3QzBVTA0KLSNkZWZpbmUgCSBIV19IQVNIX1BBRF9F
Tl9SRUdfQUREUiAJCSAweDA3QzRVTA0KLSNkZWZpbmUgCSBIV19IQVNIX1BBRF9DRkdfUkVHX0FE
RFIgCQkgMHgwN0M4VUwNCi0jZGVmaW5lIAkgSFdfSEFTSF9DVVJfTEVOXzBfUkVHX0FERFIgCSAw
eDA3Q0NVTA0KLSNkZWZpbmUgCSBIV19IQVNIX0NVUl9MRU5fMV9SRUdfQUREUiAJIDB4MDdEMFVM
DQotI2RlZmluZSAJIEhXX0hBU0hfQ1VSX0xFTl8yX1JFR19BRERSIAkgMHgwN0Q0VUwNCi0jZGVm
aW5lIAkgSFdfSEFTSF9DVVJfTEVOXzNfUkVHX0FERFIgCSAweDA3RDhVTA0KLSNkZWZpbmUgCSBI
V19IQVNIX1BBUkFNX1JFR19BRERSIAkJIDB4MDdEQ1VMDQotI2RlZmluZSAJIEhXX0hBU0hfSU5U
X0JVU1lfUkVHX0FERFIgCQkgMHgwN0UwVUwNCi0jZGVmaW5lIAkgSFdfSEFTSF9TV19SRVNFVF9S
RUdfQUREUiAJCSAweDA3RTRVTA0KLSNkZWZpbmUgCSBIV19IQVNIX0VORElBTkVTU19SRUdfQURE
UiAJIDB4MDdFOFVMDQotI2RlZmluZSAJIEhXX0hBU0hfREFUQV9SRUdfQUREUiAJCSAgICAgMHgw
N0VDVUwNCi0jZGVmaW5lIAkgSFdfRFJOR19DT05UUk9MX1JFR19BRERSIAkJIDB4MDgwMFVMDQot
I2RlZmluZSAJIEhXX0RSTkdfVkFMSURfUkVHX0FERFIgCQkgMHgwODA0VUwNCi0jZGVmaW5lIAkg
SFdfRFJOR19EQVRBX1JFR19BRERSIAkJICAgICAweDA4MDhVTA0KLSNkZWZpbmUgCSBIV19STkRf
U1JDX0VOX1JFR19BRERSIAkJIDB4MDgwQ1VMDQotI2RlZmluZSAJIEhXX0FFU19DTEtfRU5BQkxF
X1JFR19BRERSIAkgMHgwODEwVUwNCi0jZGVmaW5lIAkgSFdfREVTX0NMS19FTkFCTEVfUkVHX0FE
RFIgCSAweDA4MTRVTA0KLSNkZWZpbmUgCSBIV19IQVNIX0NMS19FTkFCTEVfUkVHX0FERFIgCSAw
eDA4MThVTA0KLSNkZWZpbmUgCSBIV19QS0lfQ0xLX0VOQUJMRV9SRUdfQUREUiAJIDB4MDgxQ1VM
DQotI2RlZmluZSAJIEhXX0NMS19TVEFUVVNfUkVHX0FERFIgCQkgMHgwODI0VUwNCi0jZGVmaW5l
IAkgSFdfQ0xLX0VOQUJMRV9SRUdfQUREUiAJCSAweDA4MjhVTA0KLSNkZWZpbmUgCSBIV19EUk5H
X1NBTVBMRV9SRUdfQUREUiAJCSAweDA4NTBVTA0KLSNkZWZpbmUgCSBIV19STkRfU1JDX0NUTF9S
RUdfQUREUiAJCSAweDA4NThVTA0KLSNkZWZpbmUgCSBIV19DUllQVE9fQ1RMX1JFR19BRERSIAkJ
IDB4MDkwMFVMDQotI2RlZmluZSAJIEhXX0NSWVBUT19TVEFUVVNfUkVHX0FERFIgCQkgMHgwOTBD
VUwNCi0jZGVmaW5lIAkgSFdfQ1JZUFRPX0JVU1lfUkVHX0FERFIgCQkgMHgwOTEwVUwNCi0jZGVm
aW5lIAkgSFdfQUVTX0JVU1lfUkVHX0FERFIgCQkgICAgIDB4MDkxNFVMDQotI2RlZmluZSAJIEhX
X0RFU19CVVNZX1JFR19BRERSIAkJICAgICAweDA5MThVTA0KLSNkZWZpbmUgCSBIV19IQVNIX0JV
U1lfUkVHX0FERFIgCQkgICAgIDB4MDkxQ1VMDQotI2RlZmluZSAJIEhXX0NPTlRFTlRfUkVHX0FE
RFIgCQkgICAgIDB4MDkyNFVMDQotI2RlZmluZSAJIEhXX1ZFUlNJT05fUkVHX0FERFIgCQkgICAg
IDB4MDkyOFVMDQotI2RlZmluZSAJIEhXX0NPTlRFWFRfSURfUkVHX0FERFIgCQkgMHgwOTMwVUwN
Ci0jZGVmaW5lIAkgSFdfRElOX0JVRkZFUl9SRUdfQUREUiAJCSAweDBDMDBVTA0KLSNkZWZpbmUg
CSBIV19ESU5fTUVNX0RNQV9CVVNZX1JFR19BRERSIAkgMHgwYzIwVUwNCi0jZGVmaW5lIAkgSFdf
U1JDX0xMSV9NRU1fQUREUl9SRUdfQUREUiAJIDB4MGMyNFVMDQotI2RlZmluZSAJIEhXX1NSQ19M
TElfV09SRDBfUkVHX0FERFIgCQkgMHgwQzI4VUwNCi0jZGVmaW5lIAkgSFdfU1JDX0xMSV9XT1JE
MV9SRUdfQUREUiAJCSAweDBDMkNVTA0KLSNkZWZpbmUgCSBIV19TUkFNX1NSQ19BRERSX1JFR19B
RERSIAkJIDB4MGMzMFVMDQotI2RlZmluZSAJIEhXX0RJTl9TUkFNX0JZVEVTX0xFTl9SRUdfQURE
UiAgMHgwYzM0VUwNCi0jZGVmaW5lIAkgSFdfRElOX1NSQU1fRE1BX0JVU1lfUkVHX0FERFIgCSAw
eDBDMzhVTA0KLSNkZWZpbmUgCSBIV19XUklURV9BTElHTl9SRUdfQUREUiAJCSAweDBDM0NVTA0K
LSNkZWZpbmUgCSBIV19PTERfREFUQV9SRUdfQUREUiAJCSAgICAgMHgwQzQ4VUwNCi0jZGVmaW5l
IAkgSFdfV1JJVEVfQUxJR05fTEFTVF9SRUdfQUREUiAJIDB4MEM0Q1VMDQotI2RlZmluZSAJIEhX
X0RPVVRfQlVGRkVSX1JFR19BRERSIAkJIDB4MEMwMFVMDQotI2RlZmluZSAJIEhXX0RTVF9MTElf
V09SRDBfUkVHX0FERFIgCQkgMHgwRDI4VUwNCi0jZGVmaW5lIAkgSFdfRFNUX0xMSV9XT1JEMV9S
RUdfQUREUiAJCSAweDBEMkNVTA0KLSNkZWZpbmUgCSBIV19EU1RfTExJX01FTV9BRERSX1JFR19B
RERSIAkgMHgwRDI0VUwNCi0jZGVmaW5lIAkgSFdfRE9VVF9NRU1fRE1BX0JVU1lfUkVHX0FERFIg
CSAweDBEMjBVTA0KLSNkZWZpbmUgCSBIV19TUkFNX0RFU1RfQUREUl9SRUdfQUREUiAJIDB4MEQz
MFVMDQotI2RlZmluZSAJIEhXX0RPVVRfU1JBTV9CWVRFU19MRU5fUkVHX0FERFIgMHgwRDM0VUwN
Ci0jZGVmaW5lIAkgSFdfRE9VVF9TUkFNX0RNQV9CVVNZX1JFR19BRERSICAweDBEMzhVTA0KLSNk
ZWZpbmUgCSBIV19SRUFEX0FMSUdOX1JFR19BRERSIAkJIDB4MEQzQ1VMDQotI2RlZmluZSAJIEhX
X1JFQURfTEFTVF9EQVRBX1JFR19BRERSIAkgMHgwRDQ0VUwNCi0jZGVmaW5lIAkgSFdfUkM0X1RI
UlVfQ1BVX1JFR19BRERSIAkJIDB4MEQ0Q1VMDQotI2RlZmluZSAJIEhXX0FIQl9TSU5HTEVfUkVH
X0FERFIgCQkgMHgwRTAwVUwNCi0jZGVmaW5lIAkgSFdfU1JBTV9EQVRBX1JFR19BRERSIAkJICAg
ICAweDBGMDBVTA0KLSNkZWZpbmUgCSBIV19TUkFNX0FERFJfUkVHX0FERFIgCQkgICAgIDB4MEYw
NFVMDQotI2RlZmluZSAJIEhXX1NSQU1fREFUQV9SRUFEWV9SRUdfQUREUiAJIDB4MEYwOFVMDQot
I2RlZmluZSAJIEhXX0hPU1RfSVJSX1JFR19BRERSIAkJICAgICAgICAgIDB4MEEwMFVMDQotI2Rl
ZmluZSAJIEhXX0hPU1RfSU1SX1JFR19BRERSIAkJICAgICAgICAgIDB4MEEwNFVMDQotI2RlZmlu
ZSAJIEhXX0hPU1RfSUNSX1JFR19BRERSIAkJICAgICAgICAgIDB4MEEwOFVMDQotI2RlZmluZSAJ
IEhXX0hPU1RfU0VQX1NSQU1fVEhSRVNIT0xEX1JFR19BRERSICAweDBBMTBVTA0KLSNkZWZpbmUg
CSBIV19IT1NUX1NFUF9CVVNZX1JFR19BRERSIAkJICAgICAgMHgwQTE0VUwNCi0jZGVmaW5lIAkg
SFdfSE9TVF9TRVBfTENTX1JFR19BRERSIAkJICAgICAgMHgwQTE4VUwNCi0jZGVmaW5lIAkgSFdf
SE9TVF9DQ19TV19SU1RfUkVHX0FERFIgCQkgIDB4MEE0MFVMDQotI2RlZmluZSAJIEhXX0hPU1Rf
U0VQX1NXX1JTVF9SRUdfQUREUiAJCSAgMHgwQTQ0VUwNCi0jZGVmaW5lIAkgSFdfSE9TVF9GTE9X
X0RNQV9TV19JTlQwX1JFR19BRERSIAkgIDB4MEE4MFVMDQotI2RlZmluZSAJIEhXX0hPU1RfRkxP
V19ETUFfU1dfSU5UMV9SRUdfQUREUiAJICAweDBBODRVTA0KLSNkZWZpbmUgCSBIV19IT1NUX0ZM
T1dfRE1BX1NXX0lOVDJfUkVHX0FERFIgCSAgMHgwQTg4VUwNCi0jZGVmaW5lIAkgSFdfSE9TVF9G
TE9XX0RNQV9TV19JTlQzX1JFR19BRERSIAkgIDB4MEE4Y1VMDQotI2RlZmluZSAJIEhXX0hPU1Rf
RkxPV19ETUFfU1dfSU5UNF9SRUdfQUREUiAJICAweDBBOTBVTA0KLSNkZWZpbmUgCSBIV19IT1NU
X0ZMT1dfRE1BX1NXX0lOVDVfUkVHX0FERFIgCSAgMHgwQTk0VUwNCi0jZGVmaW5lIAkgSFdfSE9T
VF9GTE9XX0RNQV9TV19JTlQ2X1JFR19BRERSICAgIDB4MEE5OFVMDQotI2RlZmluZSAJIEhXX0hP
U1RfRkxPV19ETUFfU1dfSU5UN19SRUdfQUREUiAJICAweDBBOWNVTA0KLSNkZWZpbmUgCSBIV19I
T1NUX1NFUF9IT1NUX0dQUjBfUkVHX0FERFIgCSAgMHgwQjAwVUwNCi0jZGVmaW5lIAkgSFdfSE9T
VF9TRVBfSE9TVF9HUFIxX1JFR19BRERSIAkgIDB4MEIwNFVMDQotI2RlZmluZSAJIEhXX0hPU1Rf
U0VQX0hPU1RfR1BSMl9SRUdfQUREUiAJICAweDBCMDhVTA0KLSNkZWZpbmUgCSBIV19IT1NUX1NF
UF9IT1NUX0dQUjNfUkVHX0FERFIgICAgICAgMHgwQjBDVUwNCi0jZGVmaW5lIAkgSFdfSE9TVF9I
T1NUX1NFUF9HUFIwX1JFR19BRERSICAgICAgIDB4MEI4MFVMDQotI2RlZmluZSAJIEhXX0hPU1Rf
SE9TVF9TRVBfR1BSMV9SRUdfQUREUiAgICAgICAweDBCODRVTA0KLSNkZWZpbmUgCSBIV19IT1NU
X0hPU1RfU0VQX0dQUjJfUkVHX0FERFIgICAgICAgMHgwQjg4VUwNCi0jZGVmaW5lIAkgSFdfSE9T
VF9IT1NUX1NFUF9HUFIzX1JFR19BRERSICAgICAgIDB4MEI4Q1VMDQotI2RlZmluZSAJIEhXX0hP
U1RfSE9TVF9FTkRJQU5fUkVHX0FERFIgCSAgICAgIDB4MEI5MFVMDQotI2RlZmluZSAJIEhXX0hP
U1RfSE9TVF9DT01NX0NMS19FTl9SRUdfQUREUiAJICAweDBCOTRVTA0KLSNkZWZpbmUgCSBIV19D
TFJfU1JBTV9CVVNZX1JFR19SRUdfQUREUiAJICAgICAgMHgwRjBDVUwNCisjZGVmaW5lCSBIV19S
MEJfQUREUl8wX1JFR19BRERSCQkgMHgwMDAwVUwNCisjZGVmaW5lCSBIV19SMEJfQUREUl8xX1JF
R19BRERSCQkgMHgwMDA0VUwNCisjZGVmaW5lCSBIV19SMEJfQUREUl8yX1JFR19BRERSCQkgMHgw
MDA4VUwNCisjZGVmaW5lCSBIV19SMEJfQUREUl8zX1JFR19BRERSCQkgMHgwMDBjVUwNCisjZGVm
aW5lCSBIV19SMEJfQUREUl80X1JFR19BRERSCQkgMHgwMDEwVUwNCisjZGVmaW5lCSBIV19SMEJf
QUREUl81X1JFR19BRERSCQkgMHgwMDE0VUwNCisjZGVmaW5lCSBIV19SMEJfQUREUl82X1JFR19B
RERSCQkgMHgwMDE4VUwNCisjZGVmaW5lCSBIV19SMEJfQUREUl83X1JFR19BRERSCQkgMHgwMDFj
VUwNCisjZGVmaW5lCSBIV19SMEJfQUREUl84X1JFR19BRERSCQkgMHgwMDIwVUwNCisjZGVmaW5l
CSBIV19SMkJfQUREUl8wX1JFR19BRERSCQkgMHgwMDgwVUwNCisjZGVmaW5lCSBIV19SMkJfQURE
Ul8xX1JFR19BRERSCQkgMHgwMDg0VUwNCisjZGVmaW5lCSBIV19SMkJfQUREUl8yX1JFR19BRERS
CQkgMHgwMDg4VUwNCisjZGVmaW5lCSBIV19SMkJfQUREUl8zX1JFR19BRERSCQkgMHgwMDhjVUwN
CisjZGVmaW5lCSBIV19SMkJfQUREUl80X1JFR19BRERSCQkgMHgwMDkwVUwNCisjZGVmaW5lCSBI
V19SMkJfQUREUl81X1JFR19BRERSCQkgMHgwMDk0VUwNCisjZGVmaW5lCSBIV19SMkJfQUREUl82
X1JFR19BRERSCQkgMHgwMDk4VUwNCisjZGVmaW5lCSBIV19SMkJfQUREUl83X1JFR19BRERSCQkg
MHgwMDljVUwNCisjZGVmaW5lCSBIV19SMkJfQUREUl84X1JFR19BRERSCQkgMHgwMGEwVUwNCisj
ZGVmaW5lCSBIV19SM0JfUkVHX0FERFIJCSAgICAgICAgIDB4MDBDMFVMDQorI2RlZmluZQkgSFdf
UjRCX1JFR19BRERSCQkgICAgICAgICAweDAxMDBVTA0KKyNkZWZpbmUJIEhXX0NTQV9BRERSXzBf
UkVHX0FERFIJCSAweDAxNDBVTA0KKyNkZWZpbmUJIEhXX0NTQV9BRERSXzFfUkVHX0FERFIJCSAw
eDAxNDRVTA0KKyNkZWZpbmUJIEhXX0NTQV9BRERSXzJfUkVHX0FERFIJCSAweDAxNDhVTA0KKyNk
ZWZpbmUJIEhXX0NTQV9BRERSXzNfUkVHX0FERFIJCSAweDAxNGNVTA0KKyNkZWZpbmUJIEhXX0NT
QV9BRERSXzRfUkVHX0FERFIJCSAweDAxNTBVTA0KKyNkZWZpbmUJIEhXX0NTQV9BRERSXzVfUkVH
X0FERFIJCSAweDAxNTRVTA0KKyNkZWZpbmUJIEhXX0NTQV9BRERSXzZfUkVHX0FERFIJCSAweDAx
NThVTA0KKyNkZWZpbmUJIEhXX0NTQV9BRERSXzdfUkVHX0FERFIJCSAweDAxNWNVTA0KKyNkZWZp
bmUJIEhXX0NTQV9BRERSXzhfUkVHX0FERFIJCSAweDAxNjBVTA0KKyNkZWZpbmUJIEhXX0NTQV9S
RUdfQUREUgkJICAgICAgICAgMHgwMTQwVUwNCisjZGVmaW5lCSBIV19TSU5CX1JFR19BRERSCQkg
ICAgICAgICAweDAxODBVTA0KKyNkZWZpbmUJIEhXX1NPVVRCX1JFR19BRERSCQkgICAgICAgICAw
eDAxODRVTA0KKyNkZWZpbmUJIEhXX1BLSV9DT05UUk9MX1JFR19BRERSCQkgMHgwMUMwVUwNCisj
ZGVmaW5lCSBIV19QS0lfU1RBVFVTX1JFR19BRERSCQkgMHgwMUM0VUwNCisjZGVmaW5lCSBIV19Q
S0lfQlVTWV9SRUdfQUREUgkJICAgICAweDAxQzhVTA0KKyNkZWZpbmUJIEhXX1BLSV9BXzEwMjVf
UkVHX0FERFIJCSAweDAxQ0NVTA0KKyNkZWZpbmUJIEhXX1BLSV9TRE1BX0NUTF9SRUdfQUREUgkJ
IDB4MDFEMFVMDQorI2RlZmluZQkgSFdfUEtJX1NETUFfT0ZGU0VUX1JFR19BRERSCSAweDAxRDRV
TA0KKyNkZWZpbmUJIEhXX1BLSV9TRE1BX1BPSU5URVJTX1JFR19BRERSCSAweDAxRDhVTA0KKyNk
ZWZpbmUJIEhXX1BLSV9TRE1BX0RMRU5HX1JFR19BRERSCQkgMHgwMURDVUwNCisjZGVmaW5lCSBI
V19QS0lfU0RNQV9FWFBfUE9JTlRFUlNfUkVHX0FERFIJIDB4MDFFMFVMDQorI2RlZmluZQkgSFdf
UEtJX1NETUFfUkVTX1BPSU5URVJTX1JFR19BRERSCSAweDAxRTRVTA0KKyNkZWZpbmUJIEhXX1BL
SV9DTFJfUkVHX0FERFIJCSAgICAgICAgIDB4MDFFOFVMDQorI2RlZmluZQkgSFdfUEtJX1NETUFf
QlVTWV9SRUdfQUREUgkJICAgICAweDAxRThVTA0KKyNkZWZpbmUJIEhXX1BLSV9TRE1BX0ZJUlNU
X0VYUF9OX1JFR19BRERSCSAweDAxRUNVTA0KKyNkZWZpbmUJIEhXX1BLSV9TRE1BX01VTF9CWTFf
UkVHX0FERFIJCSAweDAxRjBVTA0KKyNkZWZpbmUJIEhXX1BLSV9TRE1BX1JNVUxfU0VMX1JFR19B
RERSCQkgMHgwMUY0VUwNCisjZGVmaW5lCSBIV19ERVNfS0VZXzBfUkVHX0FERFIJCSAgICAgICAg
IDB4MDIwOFVMDQorI2RlZmluZQkgSFdfREVTX0tFWV8xX1JFR19BRERSCQkgICAgICAgICAweDAy
MENVTA0KKyNkZWZpbmUJIEhXX0RFU19LRVlfMl9SRUdfQUREUgkJICAgICAgICAgMHgwMjEwVUwN
CisjZGVmaW5lCSBIV19ERVNfS0VZXzNfUkVHX0FERFIJCSAgICAgICAgIDB4MDIxNFVMDQorI2Rl
ZmluZQkgSFdfREVTX0tFWV80X1JFR19BRERSCQkgICAgICAgICAweDAyMThVTA0KKyNkZWZpbmUJ
IEhXX0RFU19LRVlfNV9SRUdfQUREUgkJICAgICAgICAgMHgwMjFDVUwNCisjZGVmaW5lCSBIV19E
RVNfQ09OVFJPTF8wX1JFR19BRERSCSAgICAgICAgIDB4MDIyMFVMDQorI2RlZmluZQkgSFdfREVT
X0NPTlRST0xfMV9SRUdfQUREUgkgICAgICAgICAweDAyMjRVTA0KKyNkZWZpbmUJIEhXX0RFU19J
Vl8wX1JFR19BRERSCQkgICAgICAgICAweDAyMjhVTA0KKyNkZWZpbmUJIEhXX0RFU19JVl8xX1JF
R19BRERSCQkgICAgICAgICAweDAyMkNVTA0KKyNkZWZpbmUJIEhXX0FFU19LRVlfMF9BRERSXzBf
UkVHX0FERFIJCSAweDA0MDBVTA0KKyNkZWZpbmUJIEhXX0FFU19LRVlfMF9BRERSXzFfUkVHX0FE
RFIJCSAweDA0MDRVTA0KKyNkZWZpbmUJIEhXX0FFU19LRVlfMF9BRERSXzJfUkVHX0FERFIJCSAw
eDA0MDhVTA0KKyNkZWZpbmUJIEhXX0FFU19LRVlfMF9BRERSXzNfUkVHX0FERFIJCSAweDA0MGNV
TA0KKyNkZWZpbmUJIEhXX0FFU19LRVlfMF9BRERSXzRfUkVHX0FERFIJCSAweDA0MTBVTA0KKyNk
ZWZpbmUJIEhXX0FFU19LRVlfMF9BRERSXzVfUkVHX0FERFIJCSAweDA0MTRVTA0KKyNkZWZpbmUJ
IEhXX0FFU19LRVlfMF9BRERSXzZfUkVHX0FERFIJCSAweDA0MThVTA0KKyNkZWZpbmUJIEhXX0FF
U19LRVlfMF9BRERSXzdfUkVHX0FERFIJCSAweDA0MWNVTA0KKyNkZWZpbmUJIEhXX0FFU19LRVlf
MF9SRUdfQUREUgkJICAgICAgICAgMHgwNDAwVUwNCisjZGVmaW5lCSBIV19BRVNfSVZfMF9BRERS
XzBfUkVHX0FERFIJCSAweDA0NDBVTA0KKyNkZWZpbmUJIEhXX0FFU19JVl8wX0FERFJfMV9SRUdf
QUREUgkJIDB4MDQ0NFVMDQorI2RlZmluZQkgSFdfQUVTX0lWXzBfQUREUl8yX1JFR19BRERSCQkg
MHgwNDQ4VUwNCisjZGVmaW5lCSBIV19BRVNfSVZfMF9BRERSXzNfUkVHX0FERFIJCSAweDA0NGNV
TA0KKyNkZWZpbmUJIEhXX0FFU19JVl8wX1JFR19BRERSCQkgICAgICAgICAweDA0NDBVTA0KKyNk
ZWZpbmUJIEhXX0FFU19DVFIxX0FERFJfMF9SRUdfQUREUgkJIDB4MDQ2MFVMDQorI2RlZmluZQkg
SFdfQUVTX0NUUjFfQUREUl8xX1JFR19BRERSCQkgMHgwNDY0VUwNCisjZGVmaW5lCSBIV19BRVNf
Q1RSMV9BRERSXzJfUkVHX0FERFIJCSAweDA0NjhVTA0KKyNkZWZpbmUJIEhXX0FFU19DVFIxX0FE
RFJfM19SRUdfQUREUgkJIDB4MDQ2Y1VMDQorI2RlZmluZQkgSFdfQUVTX0NUUjFfUkVHX0FERFIJ
CSAgICAgICAgIDB4MDQ2MFVMDQorI2RlZmluZQkgSFdfQUVTX1NLX1JFR19BRERSCQkgICAgICAg
ICAweDA0NzhVTA0KKyNkZWZpbmUJIEhXX0FFU19NQUNfT0tfUkVHX0FERFIJCSAgICAgMHgwNDgw
VUwNCisjZGVmaW5lCSBIV19BRVNfUFJFVl9JVl8wX0FERFJfMF9SRUdfQUREUgkgMHgwNDkwVUwN
CisjZGVmaW5lCSBIV19BRVNfUFJFVl9JVl8wX0FERFJfMV9SRUdfQUREUgkgMHgwNDk0VUwNCisj
ZGVmaW5lCSBIV19BRVNfUFJFVl9JVl8wX0FERFJfMl9SRUdfQUREUgkgMHgwNDk4VUwNCisjZGVm
aW5lCSBIV19BRVNfUFJFVl9JVl8wX0FERFJfM19SRUdfQUREUgkgMHgwNDljVUwNCisjZGVmaW5l
CSBIV19BRVNfUFJFVl9JVl8wX1JFR19BRERSCQkgICAgIDB4MDQ5MFVMDQorI2RlZmluZQkgSFdf
QUVTX0NPTlRST0xfUkVHX0FERFIJCSAgICAgMHgwNEMwVUwNCisjZGVmaW5lCSBIV19IQVNIX0gw
X1JFR19BRERSCQkgICAgIDB4MDY0MFVMDQorI2RlZmluZQkgSFdfSEFTSF9IMV9SRUdfQUREUgkJ
ICAgICAweDA2NDRVTA0KKyNkZWZpbmUJIEhXX0hBU0hfSDJfUkVHX0FERFIJCSAgICAgMHgwNjQ4
VUwNCisjZGVmaW5lCSBIV19IQVNIX0gzX1JFR19BRERSCQkgICAgIDB4MDY0Q1VMDQorI2RlZmlu
ZQkgSFdfSEFTSF9INF9SRUdfQUREUgkJICAgICAweDA2NTBVTA0KKyNkZWZpbmUJIEhXX0hBU0hf
SDVfUkVHX0FERFIJCSAgICAgMHgwNjU0VUwNCisjZGVmaW5lCSBIV19IQVNIX0g2X1JFR19BRERS
CQkgICAgIDB4MDY1OFVMDQorI2RlZmluZQkgSFdfSEFTSF9IN19SRUdfQUREUgkJICAgICAweDA2
NUNVTA0KKyNkZWZpbmUJIEhXX0hBU0hfSDhfUkVHX0FERFIJCSAgICAgMHgwNjYwVUwNCisjZGVm
aW5lCSBIV19IQVNIX0g5X1JFR19BRERSCQkgICAgIDB4MDY2NFVMDQorI2RlZmluZQkgSFdfSEFT
SF9IMTBfUkVHX0FERFIJCSAgICAgMHgwNjY4VUwNCisjZGVmaW5lCSBIV19IQVNIX0gxMV9SRUdf
QUREUgkJICAgICAweDA2NkNVTA0KKyNkZWZpbmUJIEhXX0hBU0hfSDEyX1JFR19BRERSCQkgICAg
IDB4MDY3MFVMDQorI2RlZmluZQkgSFdfSEFTSF9IMTNfUkVHX0FERFIJCSAgICAgMHgwNjc0VUwN
CisjZGVmaW5lCSBIV19IQVNIX0gxNF9SRUdfQUREUgkJICAgICAweDA2NzhVTA0KKyNkZWZpbmUJ
IEhXX0hBU0hfSDE1X1JFR19BRERSCQkgICAgIDB4MDY3Q1VMDQorI2RlZmluZQkgSFdfSEFTSF9D
T05UUk9MX1JFR19BRERSCQkgMHgwN0MwVUwNCisjZGVmaW5lCSBIV19IQVNIX1BBRF9FTl9SRUdf
QUREUgkJIDB4MDdDNFVMDQorI2RlZmluZQkgSFdfSEFTSF9QQURfQ0ZHX1JFR19BRERSCQkgMHgw
N0M4VUwNCisjZGVmaW5lCSBIV19IQVNIX0NVUl9MRU5fMF9SRUdfQUREUgkgMHgwN0NDVUwNCisj
ZGVmaW5lCSBIV19IQVNIX0NVUl9MRU5fMV9SRUdfQUREUgkgMHgwN0QwVUwNCisjZGVmaW5lCSBI
V19IQVNIX0NVUl9MRU5fMl9SRUdfQUREUgkgMHgwN0Q0VUwNCisjZGVmaW5lCSBIV19IQVNIX0NV
Ul9MRU5fM19SRUdfQUREUgkgMHgwN0Q4VUwNCisjZGVmaW5lCSBIV19IQVNIX1BBUkFNX1JFR19B
RERSCQkgMHgwN0RDVUwNCisjZGVmaW5lCSBIV19IQVNIX0lOVF9CVVNZX1JFR19BRERSCQkgMHgw
N0UwVUwNCisjZGVmaW5lCSBIV19IQVNIX1NXX1JFU0VUX1JFR19BRERSCQkgMHgwN0U0VUwNCisj
ZGVmaW5lCSBIV19IQVNIX0VORElBTkVTU19SRUdfQUREUgkgMHgwN0U4VUwNCisjZGVmaW5lCSBI
V19IQVNIX0RBVEFfUkVHX0FERFIJCSAgICAgMHgwN0VDVUwNCisjZGVmaW5lCSBIV19EUk5HX0NP
TlRST0xfUkVHX0FERFIJCSAweDA4MDBVTA0KKyNkZWZpbmUJIEhXX0RSTkdfVkFMSURfUkVHX0FE
RFIJCSAweDA4MDRVTA0KKyNkZWZpbmUJIEhXX0RSTkdfREFUQV9SRUdfQUREUgkJICAgICAweDA4
MDhVTA0KKyNkZWZpbmUJIEhXX1JORF9TUkNfRU5fUkVHX0FERFIJCSAweDA4MENVTA0KKyNkZWZp
bmUJIEhXX0FFU19DTEtfRU5BQkxFX1JFR19BRERSCSAweDA4MTBVTA0KKyNkZWZpbmUJIEhXX0RF
U19DTEtfRU5BQkxFX1JFR19BRERSCSAweDA4MTRVTA0KKyNkZWZpbmUJIEhXX0hBU0hfQ0xLX0VO
QUJMRV9SRUdfQUREUgkgMHgwODE4VUwNCisjZGVmaW5lCSBIV19QS0lfQ0xLX0VOQUJMRV9SRUdf
QUREUgkgMHgwODFDVUwNCisjZGVmaW5lCSBIV19DTEtfU1RBVFVTX1JFR19BRERSCQkgMHgwODI0
VUwNCisjZGVmaW5lCSBIV19DTEtfRU5BQkxFX1JFR19BRERSCQkgMHgwODI4VUwNCisjZGVmaW5l
CSBIV19EUk5HX1NBTVBMRV9SRUdfQUREUgkJIDB4MDg1MFVMDQorI2RlZmluZQkgSFdfUk5EX1NS
Q19DVExfUkVHX0FERFIJCSAweDA4NThVTA0KKyNkZWZpbmUJIEhXX0NSWVBUT19DVExfUkVHX0FE
RFIJCSAweDA5MDBVTA0KKyNkZWZpbmUJIEhXX0NSWVBUT19TVEFUVVNfUkVHX0FERFIJCSAweDA5
MENVTA0KKyNkZWZpbmUJIEhXX0NSWVBUT19CVVNZX1JFR19BRERSCQkgMHgwOTEwVUwNCisjZGVm
aW5lCSBIV19BRVNfQlVTWV9SRUdfQUREUgkJICAgICAweDA5MTRVTA0KKyNkZWZpbmUJIEhXX0RF
U19CVVNZX1JFR19BRERSCQkgICAgIDB4MDkxOFVMDQorI2RlZmluZQkgSFdfSEFTSF9CVVNZX1JF
R19BRERSCQkgICAgIDB4MDkxQ1VMDQorI2RlZmluZQkgSFdfQ09OVEVOVF9SRUdfQUREUgkJICAg
ICAweDA5MjRVTA0KKyNkZWZpbmUJIEhXX1ZFUlNJT05fUkVHX0FERFIJCSAgICAgMHgwOTI4VUwN
CisjZGVmaW5lCSBIV19DT05URVhUX0lEX1JFR19BRERSCQkgMHgwOTMwVUwNCisjZGVmaW5lCSBI
V19ESU5fQlVGRkVSX1JFR19BRERSCQkgMHgwQzAwVUwNCisjZGVmaW5lCSBIV19ESU5fTUVNX0RN
QV9CVVNZX1JFR19BRERSCSAweDBjMjBVTA0KKyNkZWZpbmUJIEhXX1NSQ19MTElfTUVNX0FERFJf
UkVHX0FERFIJIDB4MGMyNFVMDQorI2RlZmluZQkgSFdfU1JDX0xMSV9XT1JEMF9SRUdfQUREUgkJ
IDB4MEMyOFVMDQorI2RlZmluZQkgSFdfU1JDX0xMSV9XT1JEMV9SRUdfQUREUgkJIDB4MEMyQ1VM
DQorI2RlZmluZQkgSFdfU1JBTV9TUkNfQUREUl9SRUdfQUREUgkJIDB4MGMzMFVMDQorI2RlZmlu
ZQkgSFdfRElOX1NSQU1fQllURVNfTEVOX1JFR19BRERSICAweDBjMzRVTA0KKyNkZWZpbmUJIEhX
X0RJTl9TUkFNX0RNQV9CVVNZX1JFR19BRERSCSAweDBDMzhVTA0KKyNkZWZpbmUJIEhXX1dSSVRF
X0FMSUdOX1JFR19BRERSCQkgMHgwQzNDVUwNCisjZGVmaW5lCSBIV19PTERfREFUQV9SRUdfQURE
UgkJICAgICAweDBDNDhVTA0KKyNkZWZpbmUJIEhXX1dSSVRFX0FMSUdOX0xBU1RfUkVHX0FERFIJ
IDB4MEM0Q1VMDQorI2RlZmluZQkgSFdfRE9VVF9CVUZGRVJfUkVHX0FERFIJCSAweDBDMDBVTA0K
KyNkZWZpbmUJIEhXX0RTVF9MTElfV09SRDBfUkVHX0FERFIJCSAweDBEMjhVTA0KKyNkZWZpbmUJ
IEhXX0RTVF9MTElfV09SRDFfUkVHX0FERFIJCSAweDBEMkNVTA0KKyNkZWZpbmUJIEhXX0RTVF9M
TElfTUVNX0FERFJfUkVHX0FERFIJIDB4MEQyNFVMDQorI2RlZmluZQkgSFdfRE9VVF9NRU1fRE1B
X0JVU1lfUkVHX0FERFIJIDB4MEQyMFVMDQorI2RlZmluZQkgSFdfU1JBTV9ERVNUX0FERFJfUkVH
X0FERFIJIDB4MEQzMFVMDQorI2RlZmluZQkgSFdfRE9VVF9TUkFNX0JZVEVTX0xFTl9SRUdfQURE
UiAweDBEMzRVTA0KKyNkZWZpbmUJIEhXX0RPVVRfU1JBTV9ETUFfQlVTWV9SRUdfQUREUiAgMHgw
RDM4VUwNCisjZGVmaW5lCSBIV19SRUFEX0FMSUdOX1JFR19BRERSCQkgMHgwRDNDVUwNCisjZGVm
aW5lCSBIV19SRUFEX0xBU1RfREFUQV9SRUdfQUREUgkgMHgwRDQ0VUwNCisjZGVmaW5lCSBIV19S
QzRfVEhSVV9DUFVfUkVHX0FERFIJCSAweDBENENVTA0KKyNkZWZpbmUJIEhXX0FIQl9TSU5HTEVf
UkVHX0FERFIJCSAweDBFMDBVTA0KKyNkZWZpbmUJIEhXX1NSQU1fREFUQV9SRUdfQUREUgkJICAg
ICAweDBGMDBVTA0KKyNkZWZpbmUJIEhXX1NSQU1fQUREUl9SRUdfQUREUgkJICAgICAweDBGMDRV
TA0KKyNkZWZpbmUJIEhXX1NSQU1fREFUQV9SRUFEWV9SRUdfQUREUgkgMHgwRjA4VUwNCisjZGVm
aW5lCSBIV19IT1NUX0lSUl9SRUdfQUREUgkJICAgICAgICAgIDB4MEEwMFVMDQorI2RlZmluZQkg
SFdfSE9TVF9JTVJfUkVHX0FERFIJCSAgICAgICAgICAweDBBMDRVTA0KKyNkZWZpbmUJIEhXX0hP
U1RfSUNSX1JFR19BRERSCQkgICAgICAgICAgMHgwQTA4VUwNCisjZGVmaW5lCSBIV19IT1NUX1NF
UF9TUkFNX1RIUkVTSE9MRF9SRUdfQUREUiAgMHgwQTEwVUwNCisjZGVmaW5lCSBIV19IT1NUX1NF
UF9CVVNZX1JFR19BRERSCQkgICAgICAweDBBMTRVTA0KKyNkZWZpbmUJIEhXX0hPU1RfU0VQX0xD
U19SRUdfQUREUgkJICAgICAgMHgwQTE4VUwNCisjZGVmaW5lCSBIV19IT1NUX0NDX1NXX1JTVF9S
RUdfQUREUgkJICAweDBBNDBVTA0KKyNkZWZpbmUJIEhXX0hPU1RfU0VQX1NXX1JTVF9SRUdfQURE
UgkJICAweDBBNDRVTA0KKyNkZWZpbmUJIEhXX0hPU1RfRkxPV19ETUFfU1dfSU5UMF9SRUdfQURE
UgkgIDB4MEE4MFVMDQorI2RlZmluZQkgSFdfSE9TVF9GTE9XX0RNQV9TV19JTlQxX1JFR19BRERS
CSAgMHgwQTg0VUwNCisjZGVmaW5lCSBIV19IT1NUX0ZMT1dfRE1BX1NXX0lOVDJfUkVHX0FERFIJ
ICAweDBBODhVTA0KKyNkZWZpbmUJIEhXX0hPU1RfRkxPV19ETUFfU1dfSU5UM19SRUdfQUREUgkg
IDB4MEE4Y1VMDQorI2RlZmluZQkgSFdfSE9TVF9GTE9XX0RNQV9TV19JTlQ0X1JFR19BRERSCSAg
MHgwQTkwVUwNCisjZGVmaW5lCSBIV19IT1NUX0ZMT1dfRE1BX1NXX0lOVDVfUkVHX0FERFIJICAw
eDBBOTRVTA0KKyNkZWZpbmUJIEhXX0hPU1RfRkxPV19ETUFfU1dfSU5UNl9SRUdfQUREUiAgICAw
eDBBOThVTA0KKyNkZWZpbmUJIEhXX0hPU1RfRkxPV19ETUFfU1dfSU5UN19SRUdfQUREUgkgIDB4
MEE5Y1VMDQorI2RlZmluZQkgSFdfSE9TVF9TRVBfSE9TVF9HUFIwX1JFR19BRERSCSAgMHgwQjAw
VUwNCisjZGVmaW5lCSBIV19IT1NUX1NFUF9IT1NUX0dQUjFfUkVHX0FERFIJICAweDBCMDRVTA0K
KyNkZWZpbmUJIEhXX0hPU1RfU0VQX0hPU1RfR1BSMl9SRUdfQUREUgkgIDB4MEIwOFVMDQorI2Rl
ZmluZQkgSFdfSE9TVF9TRVBfSE9TVF9HUFIzX1JFR19BRERSICAgICAgIDB4MEIwQ1VMDQorI2Rl
ZmluZQkgSFdfSE9TVF9IT1NUX1NFUF9HUFIwX1JFR19BRERSICAgICAgIDB4MEI4MFVMDQorI2Rl
ZmluZQkgSFdfSE9TVF9IT1NUX1NFUF9HUFIxX1JFR19BRERSICAgICAgIDB4MEI4NFVMDQorI2Rl
ZmluZQkgSFdfSE9TVF9IT1NUX1NFUF9HUFIyX1JFR19BRERSICAgICAgIDB4MEI4OFVMDQorI2Rl
ZmluZQkgSFdfSE9TVF9IT1NUX1NFUF9HUFIzX1JFR19BRERSICAgICAgIDB4MEI4Q1VMDQorI2Rl
ZmluZQkgSFdfSE9TVF9IT1NUX0VORElBTl9SRUdfQUREUgkgICAgICAweDBCOTBVTA0KKyNkZWZp
bmUJIEhXX0hPU1RfSE9TVF9DT01NX0NMS19FTl9SRUdfQUREUgkgIDB4MEI5NFVMDQorI2RlZmlu
ZQkgSFdfQ0xSX1NSQU1fQlVTWV9SRUdfUkVHX0FERFIJICAgICAgMHgwRjBDVUwNCiAjZGVmaW5l
ICAgIEhXX0NDX1NSQU1fQkFTRV9BRERSRVNTICAgICAgICAgICAgICAweDU4MDBVTA0KIA0KLSNl
bmRpZgkJCQkvKiBpZm5kZWYgSFdfREVGUyAqLw0KKyNpZmRlZiBfX2NwbHVzcGx1cw0KK30NCisj
ZW5kaWYNCisNCisjZW5kaWYgLyogaWZuZGVmIEhXX0RFRlMgKi8NCi0tIA0KMS42LjAuNA0KDQo=

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252ACorsmsx501amrc_--
