Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2AQM1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:27:54 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:56487 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2AQMWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:16 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 14/50] ACPI 5.0: Support for all new resource descriptors
Date: Tue, 17 Jan 2012 07:21:06 -0500
Message-id: <e0fe0a8d4ed5474261d0ee1452f5d9ae77236958.1326802229.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

FixedDMA, GPIO descriptors, SerialBus descriptors

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/Makefile   |    2 +-
 drivers/acpi/acpica/aclocal.h  |    6 +-
 drivers/acpi/acpica/acresrc.h  |  109 +++++++----
 drivers/acpi/acpica/acutils.h  |    1 +
 drivers/acpi/acpica/amlresrc.h |  136 ++++++++++++
 drivers/acpi/acpica/rscalc.c   |   87 ++++++++-
 drivers/acpi/acpica/rscreate.c |    3 +-
 drivers/acpi/acpica/rsdump.c   |  194 +++++++++++++++++-
 drivers/acpi/acpica/rsinfo.c   |   56 +++++-
 drivers/acpi/acpica/rsirq.c    |   31 +++
 drivers/acpi/acpica/rslist.c   |   75 ++++++--
 drivers/acpi/acpica/rsmisc.c   |  267 ++++++++++++++++++++++++-
 drivers/acpi/acpica/rsserial.c |  441 ++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/rsutils.c  |    4 +
 drivers/acpi/acpica/utresrc.c  |  276 ++++++++++++++++++++++---
 include/acpi/acrestyp.h        |  207 ++++++++++++++++++-
 16 files changed, 1776 insertions(+), 119 deletions(-)
 create mode 100644 drivers/acpi/acpica/rsserial.c

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 1bd4661..b0af3b8 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -36,7 +36,7 @@ acpi-y += psargs.o    psparse.o  psloop.o pstree.o   pswalk.o  \
 	 psopcode.o  psscope.o  psutils.o  psxface.o
 
 acpi-y += rsaddr.o rscreate.o rsinfo.o rsio.o rslist.o rsmisc.o rsxface.o \
-	 rscalc.o  rsirq.o  rsmemory.o  rsutils.o
+	 rscalc.o  rsirq.o  rsmemory.o  rsutils.o rsserial.o
 
 acpi-$(ACPI_FUTURE_USAGE) += rsdump.o
 
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 52c4ebd..60aee56 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -955,7 +955,7 @@ struct acpi_port_info {
 #define ACPI_RESOURCE_NAME_END_DEPENDENT        0x38
 #define ACPI_RESOURCE_NAME_IO                   0x40
 #define ACPI_RESOURCE_NAME_FIXED_IO             0x48
-#define ACPI_RESOURCE_NAME_RESERVED_S1          0x50
+#define ACPI_RESOURCE_NAME_FIXED_DMA            0x50
 #define ACPI_RESOURCE_NAME_RESERVED_S2          0x58
 #define ACPI_RESOURCE_NAME_RESERVED_S3          0x60
 #define ACPI_RESOURCE_NAME_RESERVED_S4          0x68
@@ -977,7 +977,9 @@ struct acpi_port_info {
 #define ACPI_RESOURCE_NAME_EXTENDED_IRQ         0x89
 #define ACPI_RESOURCE_NAME_ADDRESS64            0x8A
 #define ACPI_RESOURCE_NAME_EXTENDED_ADDRESS64   0x8B
-#define ACPI_RESOURCE_NAME_LARGE_MAX            0x8B
+#define ACPI_RESOURCE_NAME_GPIO                 0x8C
+#define ACPI_RESOURCE_NAME_SERIAL_BUS           0x8E
+#define ACPI_RESOURCE_NAME_LARGE_MAX            0x8E
 
 /*****************************************************************************
  *
diff --git a/drivers/acpi/acpica/acresrc.h b/drivers/acpi/acpica/acresrc.h
index f08b55b..05721b0 100644
--- a/drivers/acpi/acpica/acresrc.h
+++ b/drivers/acpi/acpica/acresrc.h
@@ -73,28 +73,40 @@ typedef const struct acpi_rsconvert_info {
 
 /* Resource conversion opcodes */
 
-#define ACPI_RSC_INITGET                0
-#define ACPI_RSC_INITSET                1
-#define ACPI_RSC_FLAGINIT               2
-#define ACPI_RSC_1BITFLAG               3
-#define ACPI_RSC_2BITFLAG               4
-#define ACPI_RSC_COUNT                  5
-#define ACPI_RSC_COUNT16                6
-#define ACPI_RSC_LENGTH                 7
-#define ACPI_RSC_MOVE8                  8
-#define ACPI_RSC_MOVE16                 9
-#define ACPI_RSC_MOVE32                 10
-#define ACPI_RSC_MOVE64                 11
-#define ACPI_RSC_SET8                   12
-#define ACPI_RSC_DATA8                  13
-#define ACPI_RSC_ADDRESS                14
-#define ACPI_RSC_SOURCE                 15
-#define ACPI_RSC_SOURCEX                16
-#define ACPI_RSC_BITMASK                17
-#define ACPI_RSC_BITMASK16              18
-#define ACPI_RSC_EXIT_NE                19
-#define ACPI_RSC_EXIT_LE                20
-#define ACPI_RSC_EXIT_EQ                21
+typedef enum {
+	ACPI_RSC_INITGET = 0,
+	ACPI_RSC_INITSET,
+	ACPI_RSC_FLAGINIT,
+	ACPI_RSC_1BITFLAG,
+	ACPI_RSC_2BITFLAG,
+	ACPI_RSC_3BITFLAG,
+	ACPI_RSC_ADDRESS,
+	ACPI_RSC_BITMASK,
+	ACPI_RSC_BITMASK16,
+	ACPI_RSC_COUNT,
+	ACPI_RSC_COUNT16,
+	ACPI_RSC_COUNT_GPIO_PIN,
+	ACPI_RSC_COUNT_GPIO_RES,
+	ACPI_RSC_COUNT_GPIO_VEN,
+	ACPI_RSC_COUNT_SERIAL_RES,
+	ACPI_RSC_COUNT_SERIAL_VEN,
+	ACPI_RSC_DATA8,
+	ACPI_RSC_EXIT_EQ,
+	ACPI_RSC_EXIT_LE,
+	ACPI_RSC_EXIT_NE,
+	ACPI_RSC_LENGTH,
+	ACPI_RSC_MOVE_GPIO_PIN,
+	ACPI_RSC_MOVE_GPIO_RES,
+	ACPI_RSC_MOVE_SERIAL_RES,
+	ACPI_RSC_MOVE_SERIAL_VEN,
+	ACPI_RSC_MOVE8,
+	ACPI_RSC_MOVE16,
+	ACPI_RSC_MOVE32,
+	ACPI_RSC_MOVE64,
+	ACPI_RSC_SET8,
+	ACPI_RSC_SOURCE,
+	ACPI_RSC_SOURCEX
+} ACPI_RSCONVERT_OPCODES;
 
 /* Resource Conversion sub-opcodes */
 
@@ -106,6 +118,9 @@ typedef const struct acpi_rsconvert_info {
 #define ACPI_RS_OFFSET(f)               (u8) ACPI_OFFSET (struct acpi_resource,f)
 #define AML_OFFSET(f)                   (u8) ACPI_OFFSET (union aml_resource,f)
 
+/*
+ * Individual entry for the resource dump tables
+ */
 typedef const struct acpi_rsdump_info {
 	u8 opcode;
 	u8 offset;
@@ -116,20 +131,25 @@ typedef const struct acpi_rsdump_info {
 
 /* Values for the Opcode field above */
 
-#define ACPI_RSD_TITLE                  0
-#define ACPI_RSD_LITERAL                1
-#define ACPI_RSD_STRING                 2
-#define ACPI_RSD_UINT8                  3
-#define ACPI_RSD_UINT16                 4
-#define ACPI_RSD_UINT32                 5
-#define ACPI_RSD_UINT64                 6
-#define ACPI_RSD_1BITFLAG               7
-#define ACPI_RSD_2BITFLAG               8
-#define ACPI_RSD_SHORTLIST              9
-#define ACPI_RSD_LONGLIST               10
-#define ACPI_RSD_DWORDLIST              11
-#define ACPI_RSD_ADDRESS                12
-#define ACPI_RSD_SOURCE                 13
+typedef enum {
+	ACPI_RSD_TITLE = 0,
+	ACPI_RSD_1BITFLAG,
+	ACPI_RSD_2BITFLAG,
+	ACPI_RSD_3BITFLAG,
+	ACPI_RSD_ADDRESS,
+	ACPI_RSD_DWORDLIST,
+	ACPI_RSD_LITERAL,
+	ACPI_RSD_LONGLIST,
+	ACPI_RSD_SHORTLIST,
+	ACPI_RSD_SHORTLISTX,
+	ACPI_RSD_SOURCE,
+	ACPI_RSD_STRING,
+	ACPI_RSD_UINT8,
+	ACPI_RSD_UINT16,
+	ACPI_RSD_UINT32,
+	ACPI_RSD_UINT64,
+	ACPI_RSD_WORDLIST
+} ACPI_RSDUMP_OPCODES;
 
 /* restore default alignment */
 
@@ -138,13 +158,18 @@ typedef const struct acpi_rsdump_info {
 /* Resource tables indexed by internal resource type */
 
 extern const u8 acpi_gbl_aml_resource_sizes[];
+extern const u8 acpi_gbl_aml_resource_serial_bus_sizes[];
 extern struct acpi_rsconvert_info *acpi_gbl_set_resource_dispatch[];
 
 /* Resource tables indexed by raw AML resource descriptor type */
 
 extern const u8 acpi_gbl_resource_struct_sizes[];
+extern const u8 acpi_gbl_resource_struct_serial_bus_sizes[];
 extern struct acpi_rsconvert_info *acpi_gbl_get_resource_dispatch[];
 
+extern struct acpi_rsconvert_info
+    *acpi_gbl_convert_resource_serial_bus_dispatch[];
+
 struct acpi_vendor_walk_info {
 	struct acpi_vendor_uuid *uuid;
 	struct acpi_buffer *buffer;
@@ -293,6 +318,11 @@ extern struct acpi_rsconvert_info acpi_rs_convert_address16[];
 extern struct acpi_rsconvert_info acpi_rs_convert_ext_irq[];
 extern struct acpi_rsconvert_info acpi_rs_convert_address64[];
 extern struct acpi_rsconvert_info acpi_rs_convert_ext_address64[];
+extern struct acpi_rsconvert_info acpi_rs_convert_gpio[];
+extern struct acpi_rsconvert_info acpi_rs_convert_fixed_dma[];
+extern struct acpi_rsconvert_info acpi_rs_convert_i2c_serial_bus[];
+extern struct acpi_rsconvert_info acpi_rs_convert_spi_serial_bus[];
+extern struct acpi_rsconvert_info acpi_rs_convert_uart_serial_bus[];
 
 /* These resources require separate get/set tables */
 
@@ -310,6 +340,7 @@ extern struct acpi_rsconvert_info acpi_rs_set_vendor[];
  * rsinfo
  */
 extern struct acpi_rsdump_info *acpi_gbl_dump_resource_dispatch[];
+extern struct acpi_rsdump_info *acpi_gbl_dump_serial_bus_dispatch[];
 
 /*
  * rsdump
@@ -331,6 +362,12 @@ extern struct acpi_rsdump_info acpi_rs_dump_address64[];
 extern struct acpi_rsdump_info acpi_rs_dump_ext_address64[];
 extern struct acpi_rsdump_info acpi_rs_dump_ext_irq[];
 extern struct acpi_rsdump_info acpi_rs_dump_generic_reg[];
+extern struct acpi_rsdump_info acpi_rs_dump_gpio[];
+extern struct acpi_rsdump_info acpi_rs_dump_fixed_dma[];
+extern struct acpi_rsdump_info acpi_rs_dump_common_serial_bus[];
+extern struct acpi_rsdump_info acpi_rs_dump_i2c_serial_bus[];
+extern struct acpi_rsdump_info acpi_rs_dump_spi_serial_bus[];
+extern struct acpi_rsdump_info acpi_rs_dump_uart_serial_bus[];
 #endif
 
 #endif				/* __ACRESRC_H__ */
diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
index 99c140d..ab95d45 100644
--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -45,6 +45,7 @@
 #define _ACUTILS_H
 
 extern const u8 acpi_gbl_resource_aml_sizes[];
+extern const u8 acpi_gbl_resource_aml_serial_bus_sizes[];
 
 /* Strings used by the disassembler and debugger resource dump routines */
 
diff --git a/drivers/acpi/acpica/amlresrc.h b/drivers/acpi/acpica/amlresrc.h
index 59122cd..d4c3051 100644
--- a/drivers/acpi/acpica/amlresrc.h
+++ b/drivers/acpi/acpica/amlresrc.h
@@ -58,29 +58,48 @@
 #define ACPI_RESTAG_TYPESPECIFICATTRIBUTES      "_ATT"
 #define ACPI_RESTAG_BASEADDRESS                 "_BAS"
 #define ACPI_RESTAG_BUSMASTER                   "_BM_"	/* Master(1), Slave(0) */
+#define ACPI_RESTAG_DEBOUNCETIME                "_DBT"
 #define ACPI_RESTAG_DECODE                      "_DEC"
+#define ACPI_RESTAG_DEVICEPOLARITY              "_DPL"
 #define ACPI_RESTAG_DMA                         "_DMA"
 #define ACPI_RESTAG_DMATYPE                     "_TYP"	/* Compatible(0), A(1), B(2), F(3) */
+#define ACPI_RESTAG_DRIVESTRENGTH               "_DRS"
+#define ACPI_RESTAG_ENDIANNESS                  "_END"
+#define ACPI_RESTAG_FLOWCONTROL                 "_FLC"
 #define ACPI_RESTAG_GRANULARITY                 "_GRA"
 #define ACPI_RESTAG_INTERRUPT                   "_INT"
 #define ACPI_RESTAG_INTERRUPTLEVEL              "_LL_"	/* active_lo(1), active_hi(0) */
 #define ACPI_RESTAG_INTERRUPTSHARE              "_SHR"	/* Shareable(1), no_share(0) */
 #define ACPI_RESTAG_INTERRUPTTYPE               "_HE_"	/* Edge(1), Level(0) */
+#define ACPI_RESTAG_IORESTRICTION               "_IOR"
 #define ACPI_RESTAG_LENGTH                      "_LEN"
+#define ACPI_RESTAG_LINE                        "_LIN"
 #define ACPI_RESTAG_MEMATTRIBUTES               "_MTP"	/* Memory(0), Reserved(1), ACPI(2), NVS(3) */
 #define ACPI_RESTAG_MEMTYPE                     "_MEM"	/* non_cache(0), Cacheable(1) Cache+combine(2), Cache+prefetch(3) */
 #define ACPI_RESTAG_MAXADDR                     "_MAX"
 #define ACPI_RESTAG_MINADDR                     "_MIN"
 #define ACPI_RESTAG_MAXTYPE                     "_MAF"
 #define ACPI_RESTAG_MINTYPE                     "_MIF"
+#define ACPI_RESTAG_MODE                        "_MOD"
+#define ACPI_RESTAG_PARITY                      "_PAR"
+#define ACPI_RESTAG_PHASE                       "_PHA"
+#define ACPI_RESTAG_PIN                         "_PIN"
+#define ACPI_RESTAG_PINCONFIG                   "_PPI"
+#define ACPI_RESTAG_POLARITY                    "_POL"
 #define ACPI_RESTAG_REGISTERBITOFFSET           "_RBO"
 #define ACPI_RESTAG_REGISTERBITWIDTH            "_RBW"
 #define ACPI_RESTAG_RANGETYPE                   "_RNG"
 #define ACPI_RESTAG_READWRITETYPE               "_RW_"	/* read_only(0), Writeable (1) */
+#define ACPI_RESTAG_LENGTH_RX                   "_RXL"
+#define ACPI_RESTAG_LENGTH_TX                   "_TXL"
+#define ACPI_RESTAG_SLAVEMODE                   "_SLV"
+#define ACPI_RESTAG_SPEED                       "_SPE"
+#define ACPI_RESTAG_STOPBITS                    "_STB"
 #define ACPI_RESTAG_TRANSLATION                 "_TRA"
 #define ACPI_RESTAG_TRANSTYPE                   "_TRS"	/* Sparse(1), Dense(0) */
 #define ACPI_RESTAG_TYPE                        "_TTP"	/* Translation(1), Static (0) */
 #define ACPI_RESTAG_XFERTYPE                    "_SIZ"	/* 8(0), 8_and16(1), 16(2) */
+#define ACPI_RESTAG_VENDORDATA                  "_VEN"
 
 /* Default sizes for "small" resource descriptors */
 
@@ -90,6 +109,7 @@
 #define ASL_RDESC_END_DEPEND_SIZE               0x00
 #define ASL_RDESC_IO_SIZE                       0x07
 #define ASL_RDESC_FIXED_IO_SIZE                 0x03
+#define ASL_RDESC_FIXED_DMA_SIZE                0x05
 #define ASL_RDESC_END_TAG_SIZE                  0x01
 
 struct asl_resource_node {
@@ -164,6 +184,12 @@ struct aml_resource_end_tag {
 	AML_RESOURCE_SMALL_HEADER_COMMON u8 checksum;
 };
 
+struct aml_resource_fixed_dma {
+	AML_RESOURCE_SMALL_HEADER_COMMON u16 request_lines;
+	u16 channels;
+	u8 width;
+};
+
 /*
  * LARGE descriptors
  */
@@ -263,6 +289,110 @@ struct aml_resource_generic_register {
 	u64 address;
 };
 
+/* Common descriptor for gpio_int and gpio_io (ACPI 5.0) */
+
+struct aml_resource_gpio {
+	AML_RESOURCE_LARGE_HEADER_COMMON u8 revision_id;
+	u8 connection_type;
+	u16 flags;
+	u16 int_flags;
+	u8 pin_config;
+	u16 drive_strength;
+	u16 debounce_timeout;
+	u16 pin_table_offset;
+	u8 res_source_index;
+	u16 res_source_offset;
+	u16 vendor_offset;
+	u16 vendor_length;
+	/*
+	 * Optional fields follow immediately:
+	 * 1) PIN list (Words)
+	 * 2) Resource Source String
+	 * 3) Vendor Data bytes
+	 */
+};
+
+#define AML_RESOURCE_GPIO_REVISION              1	/* ACPI 5.0 */
+
+/* Values for connection_type above */
+
+#define AML_RESOURCE_GPIO_TYPE_INT              0
+#define AML_RESOURCE_GPIO_TYPE_IO               1
+#define AML_RESOURCE_MAX_GPIOTYPE               1
+
+/* Common preamble for all serial descriptors (ACPI 5.0) */
+
+#define AML_RESOURCE_SERIAL_COMMON \
+	u8                              revision_id; \
+	u8                              res_source_index; \
+	u8                              type; \
+	u8                              flags; \
+	u16                             type_specific_flags; \
+	u8                              type_revision_id; \
+	u16                             type_data_length; \
+
+/* Values for the type field above */
+
+#define AML_RESOURCE_I2C_SERIALBUSTYPE          1
+#define AML_RESOURCE_SPI_SERIALBUSTYPE          2
+#define AML_RESOURCE_UART_SERIALBUSTYPE         3
+#define AML_RESOURCE_MAX_SERIALBUSTYPE          3
+#define AML_RESOURCE_VENDOR_SERIALBUSTYPE       192	/* Vendor defined is 0xC0-0xFF (NOT SUPPORTED) */
+
+struct aml_resource_common_serialbus {
+AML_RESOURCE_LARGE_HEADER_COMMON AML_RESOURCE_SERIAL_COMMON};
+
+struct aml_resource_i2c_serialbus {
+	AML_RESOURCE_LARGE_HEADER_COMMON
+	    AML_RESOURCE_SERIAL_COMMON u32 connection_speed;
+	u16 slave_address;
+	/*
+	 * Optional fields follow immediately:
+	 * 1) Vendor Data bytes
+	 * 2) Resource Source String
+	 */
+};
+
+#define AML_RESOURCE_I2C_REVISION               1	/* ACPI 5.0 */
+#define AML_RESOURCE_I2C_TYPE_REVISION          1	/* ACPI 5.0 */
+#define AML_RESOURCE_I2C_MIN_DATA_LEN           6
+
+struct aml_resource_spi_serialbus {
+	AML_RESOURCE_LARGE_HEADER_COMMON
+	    AML_RESOURCE_SERIAL_COMMON u32 connection_speed;
+	u8 data_bit_length;
+	u8 clock_phase;
+	u8 clock_polarity;
+	u16 device_selection;
+	/*
+	 * Optional fields follow immediately:
+	 * 1) Vendor Data bytes
+	 * 2) Resource Source String
+	 */
+};
+
+#define AML_RESOURCE_SPI_REVISION               1	/* ACPI 5.0 */
+#define AML_RESOURCE_SPI_TYPE_REVISION          1	/* ACPI 5.0 */
+#define AML_RESOURCE_SPI_MIN_DATA_LEN           9
+
+struct aml_resource_uart_serialbus {
+	AML_RESOURCE_LARGE_HEADER_COMMON
+	    AML_RESOURCE_SERIAL_COMMON u32 default_baud_rate;
+	u16 rx_fifo_size;
+	u16 tx_fifo_size;
+	u8 parity;
+	u8 lines_enabled;
+	/*
+	 * Optional fields follow immediately:
+	 * 1) Vendor Data bytes
+	 * 2) Resource Source String
+	 */
+};
+
+#define AML_RESOURCE_UART_REVISION              1	/* ACPI 5.0 */
+#define AML_RESOURCE_UART_TYPE_REVISION         1	/* ACPI 5.0 */
+#define AML_RESOURCE_UART_MIN_DATA_LEN          10
+
 /* restore default alignment */
 
 #pragma pack()
@@ -284,6 +414,7 @@ union aml_resource {
 	struct aml_resource_end_dependent end_dpf;
 	struct aml_resource_io io;
 	struct aml_resource_fixed_io fixed_io;
+	struct aml_resource_fixed_dma fixed_dma;
 	struct aml_resource_vendor_small vendor_small;
 	struct aml_resource_end_tag end_tag;
 
@@ -299,6 +430,11 @@ union aml_resource {
 	struct aml_resource_address64 address64;
 	struct aml_resource_extended_address64 ext_address64;
 	struct aml_resource_extended_irq extended_irq;
+	struct aml_resource_gpio gpio;
+	struct aml_resource_i2c_serialbus i2c_serial_bus;
+	struct aml_resource_spi_serialbus spi_serial_bus;
+	struct aml_resource_uart_serialbus uart_serial_bus;
+	struct aml_resource_common_serialbus common_serial_bus;
 
 	/* Utility overlays */
 
diff --git a/drivers/acpi/acpica/rscalc.c b/drivers/acpi/acpica/rscalc.c
index 3a8a89e..3a29b4dd 100644
--- a/drivers/acpi/acpica/rscalc.c
+++ b/drivers/acpi/acpica/rscalc.c
@@ -313,6 +313,38 @@ acpi_rs_get_aml_length(struct acpi_resource * resource, acpi_size * size_needed)
 							  resource_source));
 			break;
 
+		case ACPI_RESOURCE_TYPE_GPIO:
+
+			total_size =
+			    (acpi_rs_length) (total_size +
+					      (resource->data.gpio.
+					       pin_table_length * 2) +
+					      resource->data.gpio.
+					      resource_source.string_length +
+					      resource->data.gpio.
+					      vendor_length);
+
+			break;
+
+		case ACPI_RESOURCE_TYPE_SERIAL_BUS:
+
+			total_size =
+			    acpi_gbl_aml_resource_serial_bus_sizes[resource->
+								   data.
+								   common_serial_bus.
+								   type];
+
+			total_size = (acpi_rs_length) (total_size +
+						       resource->data.
+						       i2c_serial_bus.
+						       resource_source.
+						       string_length +
+						       resource->data.
+						       i2c_serial_bus.
+						       vendor_length);
+
+			break;
+
 		default:
 			break;
 		}
@@ -362,10 +394,11 @@ acpi_rs_get_list_length(u8 * aml_buffer,
 	u32 extra_struct_bytes;
 	u8 resource_index;
 	u8 minimum_aml_resource_length;
+	union aml_resource *aml_resource;
 
 	ACPI_FUNCTION_TRACE(rs_get_list_length);
 
-	*size_needed = 0;
+	*size_needed = ACPI_RS_SIZE_MIN;	/* Minimum size is one end_tag */
 	end_aml = aml_buffer + aml_buffer_length;
 
 	/* Walk the list of AML resource descriptors */
@@ -376,9 +409,15 @@ acpi_rs_get_list_length(u8 * aml_buffer,
 
 		status = acpi_ut_validate_resource(aml_buffer, &resource_index);
 		if (ACPI_FAILURE(status)) {
+			/*
+			 * Exit on failure. Cannot continue because the descriptor length
+			 * may be bogus also.
+			 */
 			return_ACPI_STATUS(status);
 		}
 
+		aml_resource = (void *)aml_buffer;
+
 		/* Get the resource length and base (minimum) AML size */
 
 		resource_length = acpi_ut_get_resource_length(aml_buffer);
@@ -422,10 +461,8 @@ acpi_rs_get_list_length(u8 * aml_buffer,
 
 		case ACPI_RESOURCE_NAME_END_TAG:
 			/*
-			 * End Tag:
-			 * This is the normal exit, add size of end_tag
+			 * End Tag: This is the normal exit
 			 */
-			*size_needed += ACPI_RS_SIZE_MIN;
 			return_ACPI_STATUS(AE_OK);
 
 		case ACPI_RESOURCE_NAME_ADDRESS32:
@@ -457,6 +494,33 @@ acpi_rs_get_list_length(u8 * aml_buffer,
 							 minimum_aml_resource_length);
 			break;
 
+		case ACPI_RESOURCE_NAME_GPIO:
+
+			/* Vendor data is optional */
+
+			if (aml_resource->gpio.vendor_length) {
+				extra_struct_bytes +=
+				    aml_resource->gpio.vendor_offset -
+				    aml_resource->gpio.pin_table_offset +
+				    aml_resource->gpio.vendor_length;
+			} else {
+				extra_struct_bytes +=
+				    aml_resource->large_header.resource_length +
+				    sizeof(struct aml_resource_large_header) -
+				    aml_resource->gpio.pin_table_offset;
+			}
+			break;
+
+		case ACPI_RESOURCE_NAME_SERIAL_BUS:
+
+			minimum_aml_resource_length =
+			    acpi_gbl_resource_aml_serial_bus_sizes
+			    [aml_resource->common_serial_bus.type];
+			extra_struct_bytes +=
+			    aml_resource->common_serial_bus.resource_length -
+			    minimum_aml_resource_length;
+			break;
+
 		default:
 			break;
 		}
@@ -467,9 +531,18 @@ acpi_rs_get_list_length(u8 * aml_buffer,
 		 * Important: Round the size up for the appropriate alignment. This
 		 * is a requirement on IA64.
 		 */
-		buffer_size = acpi_gbl_resource_struct_sizes[resource_index] +
-		    extra_struct_bytes;
-		buffer_size = (u32) ACPI_ROUND_UP_TO_NATIVE_WORD(buffer_size);
+		if (acpi_ut_get_resource_type(aml_buffer) ==
+		    ACPI_RESOURCE_NAME_SERIAL_BUS) {
+			buffer_size =
+			    acpi_gbl_resource_struct_serial_bus_sizes
+			    [aml_resource->common_serial_bus.type] +
+			    extra_struct_bytes;
+		} else {
+			buffer_size =
+			    acpi_gbl_resource_struct_sizes[resource_index] +
+			    extra_struct_bytes;
+		}
+		buffer_size = (u32)ACPI_ROUND_UP_TO_NATIVE_WORD(buffer_size);
 
 		*size_needed += buffer_size;
 
diff --git a/drivers/acpi/acpica/rscreate.c b/drivers/acpi/acpica/rscreate.c
index 4ce6e11..f61285d 100644
--- a/drivers/acpi/acpica/rscreate.c
+++ b/drivers/acpi/acpica/rscreate.c
@@ -66,9 +66,10 @@ ACPI_MODULE_NAME("rscreate")
  *              of device resources.
  *
  ******************************************************************************/
+
 acpi_status
 acpi_rs_create_resource_list(union acpi_operand_object *aml_buffer,
-			     struct acpi_buffer *output_buffer)
+			     struct acpi_buffer * output_buffer)
 {
 
 	acpi_status status;
diff --git a/drivers/acpi/acpica/rsdump.c b/drivers/acpi/acpica/rsdump.c
index 33db752..9969985 100644
--- a/drivers/acpi/acpica/rsdump.c
+++ b/drivers/acpi/acpica/rsdump.c
@@ -61,11 +61,13 @@ static void acpi_rs_out_integer64(char *title, u64 value);
 
 static void acpi_rs_out_title(char *title);
 
-static void acpi_rs_dump_byte_list(u16 length, u8 * data);
+static void acpi_rs_dump_byte_list(u16 length, u8 *data);
 
-static void acpi_rs_dump_dword_list(u8 length, u32 * data);
+static void acpi_rs_dump_word_list(u16 length, u16 *data);
 
-static void acpi_rs_dump_short_byte_list(u8 length, u8 * data);
+static void acpi_rs_dump_dword_list(u8 length, u32 *data);
+
+static void acpi_rs_dump_short_byte_list(u8 length, u8 *data);
 
 static void
 acpi_rs_dump_resource_source(struct acpi_resource_source *resource_source);
@@ -309,6 +311,125 @@ struct acpi_rsdump_info acpi_rs_dump_generic_reg[6] = {
 	{ACPI_RSD_UINT64, ACPI_RSD_OFFSET(generic_reg.address), "Address", NULL}
 };
 
+struct acpi_rsdump_info acpi_rs_dump_gpio[16] = {
+	{ACPI_RSD_TITLE, ACPI_RSD_TABLE_SIZE(acpi_rs_dump_gpio), "GPIO", NULL},
+	{ACPI_RSD_UINT8, ACPI_RSD_OFFSET(gpio.revision_id), "RevisionId", NULL},
+	{ACPI_RSD_UINT8, ACPI_RSD_OFFSET(gpio.connection_type),
+	 "ConnectionType", acpi_gbl_ct_decode},
+	{ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET(gpio.producer_consumer),
+	 "ProducerConsumer", acpi_gbl_consume_decode},
+	{ACPI_RSD_UINT8, ACPI_RSD_OFFSET(gpio.pin_config), "PinConfig",
+	 acpi_gbl_ppc_decode},
+	{ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET(gpio.sharable), "Sharable",
+	 acpi_gbl_shr_decode},
+	{ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET(gpio.io_restriction),
+	 "IoRestriction", acpi_gbl_ior_decode},
+	{ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET(gpio.triggering), "Triggering",
+	 acpi_gbl_he_decode},
+	{ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET(gpio.polarity), "Polarity",
+	 acpi_gbl_ll_decode},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(gpio.drive_strength), "DriveStrength",
+	 NULL},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(gpio.debounce_timeout),
+	 "DebounceTimeout", NULL},
+	{ACPI_RSD_SOURCE, ACPI_RSD_OFFSET(gpio.resource_source),
+	 "ResourceSource", NULL},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(gpio.pin_table_length),
+	 "PinTableLength", NULL},
+	{ACPI_RSD_WORDLIST, ACPI_RSD_OFFSET(gpio.pin_table), "PinTable", NULL},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(gpio.vendor_length), "VendorLength",
+	 NULL},
+	{ACPI_RSD_SHORTLISTX, ACPI_RSD_OFFSET(gpio.vendor_data), "VendorData",
+	 NULL},
+};
+
+struct acpi_rsdump_info acpi_rs_dump_fixed_dma[4] = {
+	{ACPI_RSD_TITLE, ACPI_RSD_TABLE_SIZE(acpi_rs_dump_fixed_dma),
+	 "FixedDma", NULL},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(fixed_dma.request_lines),
+	 "RequestLines", NULL},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(fixed_dma.channels), "Channels",
+	 NULL},
+	{ACPI_RSD_UINT8, ACPI_RSD_OFFSET(fixed_dma.width), "TransferWidth",
+	 acpi_gbl_dts_decode},
+};
+
+#define ACPI_RS_DUMP_COMMON_SERIAL_BUS \
+	{ACPI_RSD_UINT8,    ACPI_RSD_OFFSET (common_serial_bus.revision_id),    "RevisionId",               NULL}, \
+	{ACPI_RSD_UINT8,    ACPI_RSD_OFFSET (common_serial_bus.type),           "Type",                     acpi_gbl_sbt_decode}, \
+	{ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (common_serial_bus.producer_consumer), "ProducerConsumer",      acpi_gbl_consume_decode}, \
+	{ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET (common_serial_bus.slave_mode),     "SlaveMode",                acpi_gbl_sm_decode}, \
+	{ACPI_RSD_UINT8,    ACPI_RSD_OFFSET (common_serial_bus.type_revision_id), "TypeRevisionId",         NULL}, \
+	{ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (common_serial_bus.type_data_length), "TypeDataLength",         NULL}, \
+	{ACPI_RSD_SOURCE,   ACPI_RSD_OFFSET (common_serial_bus.resource_source), "ResourceSource",          NULL}, \
+	{ACPI_RSD_UINT16,   ACPI_RSD_OFFSET (common_serial_bus.vendor_length),  "VendorLength",             NULL}, \
+	{ACPI_RSD_SHORTLISTX,ACPI_RSD_OFFSET (common_serial_bus.vendor_data),   "VendorData",               NULL},
+
+struct acpi_rsdump_info acpi_rs_dump_common_serial_bus[10] = {
+	{ACPI_RSD_TITLE, ACPI_RSD_TABLE_SIZE(acpi_rs_dump_common_serial_bus),
+	 "Common Serial Bus", NULL},
+	ACPI_RS_DUMP_COMMON_SERIAL_BUS
+};
+
+struct acpi_rsdump_info acpi_rs_dump_i2c_serial_bus[13] = {
+	{ACPI_RSD_TITLE, ACPI_RSD_TABLE_SIZE(acpi_rs_dump_i2c_serial_bus),
+	 "I2C Serial Bus", NULL},
+	ACPI_RS_DUMP_COMMON_SERIAL_BUS {ACPI_RSD_1BITFLAG,
+					ACPI_RSD_OFFSET(i2c_serial_bus.
+							access_mode),
+					"AccessMode", acpi_gbl_am_decode},
+	{ACPI_RSD_UINT32, ACPI_RSD_OFFSET(i2c_serial_bus.connection_speed),
+	 "ConnectionSpeed", NULL},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(i2c_serial_bus.slave_address),
+	 "SlaveAddress", NULL},
+};
+
+struct acpi_rsdump_info acpi_rs_dump_spi_serial_bus[17] = {
+	{ACPI_RSD_TITLE, ACPI_RSD_TABLE_SIZE(acpi_rs_dump_spi_serial_bus),
+	 "Spi Serial Bus", NULL},
+	ACPI_RS_DUMP_COMMON_SERIAL_BUS {ACPI_RSD_1BITFLAG,
+					ACPI_RSD_OFFSET(spi_serial_bus.
+							wire_mode), "WireMode",
+					acpi_gbl_wm_decode},
+	{ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET(spi_serial_bus.device_polarity),
+	 "DevicePolarity", acpi_gbl_dp_decode},
+	{ACPI_RSD_UINT8, ACPI_RSD_OFFSET(spi_serial_bus.data_bit_length),
+	 "DataBitLength", NULL},
+	{ACPI_RSD_UINT8, ACPI_RSD_OFFSET(spi_serial_bus.clock_phase),
+	 "ClockPhase", acpi_gbl_cph_decode},
+	{ACPI_RSD_UINT8, ACPI_RSD_OFFSET(spi_serial_bus.clock_polarity),
+	 "ClockPolarity", acpi_gbl_cpo_decode},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(spi_serial_bus.device_selection),
+	 "DeviceSelection", NULL},
+	{ACPI_RSD_UINT32, ACPI_RSD_OFFSET(spi_serial_bus.connection_speed),
+	 "ConnectionSpeed", NULL},
+};
+
+struct acpi_rsdump_info acpi_rs_dump_uart_serial_bus[19] = {
+	{ACPI_RSD_TITLE, ACPI_RSD_TABLE_SIZE(acpi_rs_dump_uart_serial_bus),
+	 "Uart Serial Bus", NULL},
+	ACPI_RS_DUMP_COMMON_SERIAL_BUS {ACPI_RSD_2BITFLAG,
+					ACPI_RSD_OFFSET(uart_serial_bus.
+							flow_control),
+					"FlowControl", acpi_gbl_fc_decode},
+	{ACPI_RSD_2BITFLAG, ACPI_RSD_OFFSET(uart_serial_bus.stop_bits),
+	 "StopBits", acpi_gbl_sb_decode},
+	{ACPI_RSD_3BITFLAG, ACPI_RSD_OFFSET(uart_serial_bus.data_bits),
+	 "DataBits", acpi_gbl_bpb_decode},
+	{ACPI_RSD_1BITFLAG, ACPI_RSD_OFFSET(uart_serial_bus.endian), "Endian",
+	 acpi_gbl_ed_decode},
+	{ACPI_RSD_UINT8, ACPI_RSD_OFFSET(uart_serial_bus.parity), "Parity",
+	 acpi_gbl_pt_decode},
+	{ACPI_RSD_UINT8, ACPI_RSD_OFFSET(uart_serial_bus.lines_enabled),
+	 "LinesEnabled", NULL},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(uart_serial_bus.rx_fifo_size),
+	 "RxFifoSize", NULL},
+	{ACPI_RSD_UINT16, ACPI_RSD_OFFSET(uart_serial_bus.tx_fifo_size),
+	 "TxFifoSize", NULL},
+	{ACPI_RSD_UINT32, ACPI_RSD_OFFSET(uart_serial_bus.default_baud_rate),
+	 "ConnectionSpeed", NULL},
+};
+
 /*
  * Tables used for common address descriptor flag fields
  */
@@ -413,7 +534,14 @@ acpi_rs_dump_descriptor(void *resource, struct acpi_rsdump_info *table)
 			/* Data items, 8/16/32/64 bit */
 
 		case ACPI_RSD_UINT8:
-			acpi_rs_out_integer8(name, ACPI_GET8(target));
+			if (table->pointer) {
+				acpi_rs_out_string(name, ACPI_CAST_PTR(char,
+								       table->
+								       pointer
+								       [*target]));
+			} else {
+				acpi_rs_out_integer8(name, ACPI_GET8(target));
+			}
 			break;
 
 		case ACPI_RSD_UINT16:
@@ -444,6 +572,13 @@ acpi_rs_dump_descriptor(void *resource, struct acpi_rsdump_info *table)
 								       0x03]));
 			break;
 
+		case ACPI_RSD_3BITFLAG:
+			acpi_rs_out_string(name, ACPI_CAST_PTR(char,
+							       table->
+							       pointer[*target &
+								       0x07]));
+			break;
+
 		case ACPI_RSD_SHORTLIST:
 			/*
 			 * Short byte list (single line output) for DMA and IRQ resources
@@ -456,6 +591,20 @@ acpi_rs_dump_descriptor(void *resource, struct acpi_rsdump_info *table)
 			}
 			break;
 
+		case ACPI_RSD_SHORTLISTX:
+			/*
+			 * Short byte list (single line output) for GPIO vendor data
+			 * Note: The list length is obtained from the previous table entry
+			 */
+			if (previous_target) {
+				acpi_rs_out_title(name);
+				acpi_rs_dump_short_byte_list(*previous_target,
+							     *
+							     (ACPI_CAST_INDIRECT_PTR
+							      (u8, target)));
+			}
+			break;
+
 		case ACPI_RSD_LONGLIST:
 			/*
 			 * Long byte list for Vendor resource data
@@ -480,6 +629,18 @@ acpi_rs_dump_descriptor(void *resource, struct acpi_rsdump_info *table)
 			}
 			break;
 
+		case ACPI_RSD_WORDLIST:
+			/*
+			 * Word list for GPIO Pin Table
+			 * Note: The list length is obtained from the previous table entry
+			 */
+			if (previous_target) {
+				acpi_rs_dump_word_list(*previous_target,
+						       *(ACPI_CAST_INDIRECT_PTR
+							 (u16, target)));
+			}
+			break;
+
 		case ACPI_RSD_ADDRESS:
 			/*
 			 * Common flags for all Address resources
@@ -627,14 +788,20 @@ void acpi_rs_dump_resource_list(struct acpi_resource *resource_list)
 
 		/* Dump the resource descriptor */
 
-		acpi_rs_dump_descriptor(&resource_list->data,
-					acpi_gbl_dump_resource_dispatch[type]);
+		if (type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
+			acpi_rs_dump_descriptor(&resource_list->data,
+						acpi_gbl_dump_serial_bus_dispatch
+						[resource_list->data.
+						 common_serial_bus.type]);
+		} else {
+			acpi_rs_dump_descriptor(&resource_list->data,
+						acpi_gbl_dump_resource_dispatch
+						[type]);
+		}
 
 		/* Point to the next resource structure */
 
-		resource_list =
-		    ACPI_ADD_PTR(struct acpi_resource, resource_list,
-				 resource_list->length);
+		resource_list = ACPI_NEXT_RESOURCE(resource_list);
 
 		/* Exit when END_TAG descriptor is reached */
 
@@ -768,4 +935,13 @@ static void acpi_rs_dump_dword_list(u8 length, u32 * data)
 	}
 }
 
+static void acpi_rs_dump_word_list(u16 length, u16 *data)
+{
+	u16 i;
+
+	for (i = 0; i < length; i++) {
+		acpi_os_printf("%25s%2.2X : %4.4X\n", "Word", i, data[i]);
+	}
+}
+
 #endif
diff --git a/drivers/acpi/acpica/rsinfo.c b/drivers/acpi/acpica/rsinfo.c
index f9ea608..e5489bf 100644
--- a/drivers/acpi/acpica/rsinfo.c
+++ b/drivers/acpi/acpica/rsinfo.c
@@ -76,7 +76,10 @@ struct acpi_rsconvert_info *acpi_gbl_set_resource_dispatch[] = {
 	acpi_rs_convert_address64,	/* 0x0D, ACPI_RESOURCE_TYPE_ADDRESS64 */
 	acpi_rs_convert_ext_address64,	/* 0x0E, ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64 */
 	acpi_rs_convert_ext_irq,	/* 0x0F, ACPI_RESOURCE_TYPE_EXTENDED_IRQ */
-	acpi_rs_convert_generic_reg	/* 0x10, ACPI_RESOURCE_TYPE_GENERIC_REGISTER */
+	acpi_rs_convert_generic_reg,	/* 0x10, ACPI_RESOURCE_TYPE_GENERIC_REGISTER */
+	acpi_rs_convert_gpio,	/* 0x11, ACPI_RESOURCE_TYPE_GPIO */
+	acpi_rs_convert_fixed_dma,	/* 0x12, ACPI_RESOURCE_TYPE_FIXED_DMA */
+	NULL,			/* 0x13, ACPI_RESOURCE_TYPE_SERIAL_BUS - Use subtype table below */
 };
 
 /* Dispatch tables for AML-to-resource (Get Resource) conversion functions */
@@ -94,7 +97,7 @@ struct acpi_rsconvert_info *acpi_gbl_get_resource_dispatch[] = {
 	acpi_rs_convert_end_dpf,	/* 0x07, ACPI_RESOURCE_NAME_END_DEPENDENT */
 	acpi_rs_convert_io,	/* 0x08, ACPI_RESOURCE_NAME_IO */
 	acpi_rs_convert_fixed_io,	/* 0x09, ACPI_RESOURCE_NAME_FIXED_IO */
-	NULL,			/* 0x0A, Reserved */
+	acpi_rs_convert_fixed_dma,	/* 0x0A, ACPI_RESOURCE_NAME_FIXED_DMA */
 	NULL,			/* 0x0B, Reserved */
 	NULL,			/* 0x0C, Reserved */
 	NULL,			/* 0x0D, Reserved */
@@ -114,7 +117,19 @@ struct acpi_rsconvert_info *acpi_gbl_get_resource_dispatch[] = {
 	acpi_rs_convert_address16,	/* 0x08, ACPI_RESOURCE_NAME_ADDRESS16 */
 	acpi_rs_convert_ext_irq,	/* 0x09, ACPI_RESOURCE_NAME_EXTENDED_IRQ */
 	acpi_rs_convert_address64,	/* 0x0A, ACPI_RESOURCE_NAME_ADDRESS64 */
-	acpi_rs_convert_ext_address64	/* 0x0B, ACPI_RESOURCE_NAME_EXTENDED_ADDRESS64 */
+	acpi_rs_convert_ext_address64,	/* 0x0B, ACPI_RESOURCE_NAME_EXTENDED_ADDRESS64 */
+	acpi_rs_convert_gpio,	/* 0x0C, ACPI_RESOURCE_NAME_GPIO */
+	NULL,			/* 0x0D, Reserved */
+	NULL,			/* 0x0E, ACPI_RESOURCE_NAME_SERIAL_BUS - Use subtype table below */
+};
+
+/* Subtype table for serial_bus -- I2C, SPI, and UART */
+
+struct acpi_rsconvert_info *acpi_gbl_convert_resource_serial_bus_dispatch[] = {
+	NULL,
+	acpi_rs_convert_i2c_serial_bus,
+	acpi_rs_convert_spi_serial_bus,
+	acpi_rs_convert_uart_serial_bus,
 };
 
 #ifdef ACPI_FUTURE_USAGE
@@ -140,6 +155,16 @@ struct acpi_rsdump_info *acpi_gbl_dump_resource_dispatch[] = {
 	acpi_rs_dump_ext_address64,	/* ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64 */
 	acpi_rs_dump_ext_irq,	/* ACPI_RESOURCE_TYPE_EXTENDED_IRQ */
 	acpi_rs_dump_generic_reg,	/* ACPI_RESOURCE_TYPE_GENERIC_REGISTER */
+	acpi_rs_dump_gpio,	/* ACPI_RESOURCE_TYPE_GPIO */
+	acpi_rs_dump_fixed_dma,	/* ACPI_RESOURCE_TYPE_FIXED_DMA */
+	NULL,			/* ACPI_RESOURCE_TYPE_SERIAL_BUS */
+};
+
+struct acpi_rsdump_info *acpi_gbl_dump_serial_bus_dispatch[] = {
+	NULL,
+	acpi_rs_dump_i2c_serial_bus,	/* AML_RESOURCE_I2C_BUS_TYPE */
+	acpi_rs_dump_spi_serial_bus,	/* AML_RESOURCE_SPI_BUS_TYPE */
+	acpi_rs_dump_uart_serial_bus,	/* AML_RESOURCE_UART_BUS_TYPE */
 };
 #endif
 
@@ -166,7 +191,10 @@ const u8 acpi_gbl_aml_resource_sizes[] = {
 	sizeof(struct aml_resource_address64),	/* ACPI_RESOURCE_TYPE_ADDRESS64 */
 	sizeof(struct aml_resource_extended_address64),	/*ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64 */
 	sizeof(struct aml_resource_extended_irq),	/* ACPI_RESOURCE_TYPE_EXTENDED_IRQ */
-	sizeof(struct aml_resource_generic_register)	/* ACPI_RESOURCE_TYPE_GENERIC_REGISTER */
+	sizeof(struct aml_resource_generic_register),	/* ACPI_RESOURCE_TYPE_GENERIC_REGISTER */
+	sizeof(struct aml_resource_gpio),	/* ACPI_RESOURCE_TYPE_GPIO */
+	sizeof(struct aml_resource_fixed_dma),	/* ACPI_RESOURCE_TYPE_FIXED_DMA */
+	sizeof(struct aml_resource_common_serialbus),	/* ACPI_RESOURCE_TYPE_SERIAL_BUS */
 };
 
 const u8 acpi_gbl_resource_struct_sizes[] = {
@@ -182,7 +210,7 @@ const u8 acpi_gbl_resource_struct_sizes[] = {
 	ACPI_RS_SIZE_MIN,
 	ACPI_RS_SIZE(struct acpi_resource_io),
 	ACPI_RS_SIZE(struct acpi_resource_fixed_io),
-	0,
+	ACPI_RS_SIZE(struct acpi_resource_fixed_dma),
 	0,
 	0,
 	0,
@@ -202,5 +230,21 @@ const u8 acpi_gbl_resource_struct_sizes[] = {
 	ACPI_RS_SIZE(struct acpi_resource_address16),
 	ACPI_RS_SIZE(struct acpi_resource_extended_irq),
 	ACPI_RS_SIZE(struct acpi_resource_address64),
-	ACPI_RS_SIZE(struct acpi_resource_extended_address64)
+	ACPI_RS_SIZE(struct acpi_resource_extended_address64),
+	ACPI_RS_SIZE(struct acpi_resource_gpio),
+	ACPI_RS_SIZE(struct acpi_resource_common_serialbus)
+};
+
+const u8 acpi_gbl_aml_resource_serial_bus_sizes[] = {
+	0,
+	sizeof(struct aml_resource_i2c_serialbus),
+	sizeof(struct aml_resource_spi_serialbus),
+	sizeof(struct aml_resource_uart_serialbus),
+};
+
+const u8 acpi_gbl_resource_struct_serial_bus_sizes[] = {
+	0,
+	ACPI_RS_SIZE(struct acpi_resource_i2c_serialbus),
+	ACPI_RS_SIZE(struct acpi_resource_spi_serialbus),
+	ACPI_RS_SIZE(struct acpi_resource_uart_serialbus),
 };
diff --git a/drivers/acpi/acpica/rsirq.c b/drivers/acpi/acpica/rsirq.c
index 50b8ad2..3ac9d4a 100644
--- a/drivers/acpi/acpica/rsirq.c
+++ b/drivers/acpi/acpica/rsirq.c
@@ -264,3 +264,34 @@ struct acpi_rsconvert_info acpi_rs_convert_dma[6] = {
 	 AML_OFFSET(dma.dma_channel_mask),
 	 ACPI_RS_OFFSET(data.dma.channel_count)}
 };
+
+/*******************************************************************************
+ *
+ * acpi_rs_convert_fixed_dma
+ *
+ ******************************************************************************/
+
+struct acpi_rsconvert_info acpi_rs_convert_fixed_dma[4] = {
+	{ACPI_RSC_INITGET, ACPI_RESOURCE_TYPE_FIXED_DMA,
+	 ACPI_RS_SIZE(struct acpi_resource_fixed_dma),
+	 ACPI_RSC_TABLE_SIZE(acpi_rs_convert_fixed_dma)},
+
+	{ACPI_RSC_INITSET, ACPI_RESOURCE_NAME_FIXED_DMA,
+	 sizeof(struct aml_resource_fixed_dma),
+	 0},
+
+	/*
+	 * These fields are contiguous in both the source and destination:
+	 * request_lines
+	 * Channels
+	 */
+
+	{ACPI_RSC_MOVE16, ACPI_RS_OFFSET(data.fixed_dma.request_lines),
+	 AML_OFFSET(fixed_dma.request_lines),
+	 2},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.fixed_dma.width),
+	 AML_OFFSET(fixed_dma.width),
+	 1},
+
+};
diff --git a/drivers/acpi/acpica/rslist.c b/drivers/acpi/acpica/rslist.c
index 1bfcef7..c446351 100644
--- a/drivers/acpi/acpica/rslist.c
+++ b/drivers/acpi/acpica/rslist.c
@@ -70,6 +70,8 @@ acpi_rs_convert_aml_to_resources(u8 * aml,
 	struct acpi_resource **resource_ptr =
 	    ACPI_CAST_INDIRECT_PTR(struct acpi_resource, context);
 	struct acpi_resource *resource;
+	union aml_resource *aml_resource;
+	struct acpi_rsconvert_info *conversion_table;
 	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(rs_convert_aml_to_resources);
@@ -84,14 +86,37 @@ acpi_rs_convert_aml_to_resources(u8 * aml,
 			      "Misaligned resource pointer %p", resource));
 	}
 
+	/* Get the appropriate conversion info table */
+
+	aml_resource = ACPI_CAST_PTR(union aml_resource, aml);
+	if (acpi_ut_get_resource_type(aml) == ACPI_RESOURCE_NAME_SERIAL_BUS) {
+		if (aml_resource->common_serial_bus.type >
+		    AML_RESOURCE_MAX_SERIALBUSTYPE) {
+			conversion_table = NULL;
+		} else {
+			/* This is an I2C, SPI, or UART serial_bus descriptor */
+
+			conversion_table =
+			    acpi_gbl_convert_resource_serial_bus_dispatch
+			    [aml_resource->common_serial_bus.type];
+		}
+	} else {
+		conversion_table =
+		    acpi_gbl_get_resource_dispatch[resource_index];
+	}
+
+	if (!conversion_table) {
+		ACPI_ERROR((AE_INFO,
+			    "Invalid/unsupported resource descriptor: Type 0x%2.2X",
+			    resource_index));
+		return (AE_AML_INVALID_RESOURCE_TYPE);
+	}
+
 	/* Convert the AML byte stream resource to a local resource struct */
 
 	status =
-	    acpi_rs_convert_aml_to_resource(resource,
-					    ACPI_CAST_PTR(union aml_resource,
-							  aml),
-					    acpi_gbl_get_resource_dispatch
-					    [resource_index]);
+	    acpi_rs_convert_aml_to_resource(resource, aml_resource,
+					    conversion_table);
 	if (ACPI_FAILURE(status)) {
 		ACPI_EXCEPTION((AE_INFO, status,
 				"Could not convert AML resource (Type 0x%X)",
@@ -106,7 +131,7 @@ acpi_rs_convert_aml_to_resources(u8 * aml,
 
 	/* Point to the next structure in the output buffer */
 
-	*resource_ptr = ACPI_ADD_PTR(void, resource, resource->length);
+	*resource_ptr = ACPI_NEXT_RESOURCE(resource);
 	return_ACPI_STATUS(AE_OK);
 }
 
@@ -135,6 +160,7 @@ acpi_rs_convert_resources_to_aml(struct acpi_resource *resource,
 {
 	u8 *aml = output_buffer;
 	u8 *end_aml = output_buffer + aml_size_needed;
+	struct acpi_rsconvert_info *conversion_table;
 	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(rs_convert_resources_to_aml);
@@ -154,11 +180,34 @@ acpi_rs_convert_resources_to_aml(struct acpi_resource *resource,
 
 		/* Perform the conversion */
 
-		status = acpi_rs_convert_resource_to_aml(resource, ACPI_CAST_PTR(union
-										 aml_resource,
-										 aml),
-							 acpi_gbl_set_resource_dispatch
-							 [resource->type]);
+		if (resource->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
+			if (resource->data.common_serial_bus.type >
+			    AML_RESOURCE_MAX_SERIALBUSTYPE) {
+				conversion_table = NULL;
+			} else {
+				/* This is an I2C, SPI, or UART serial_bus descriptor */
+
+				conversion_table =
+				    acpi_gbl_convert_resource_serial_bus_dispatch
+				    [resource->data.common_serial_bus.type];
+			}
+		} else {
+			conversion_table =
+			    acpi_gbl_set_resource_dispatch[resource->type];
+		}
+
+		if (!conversion_table) {
+			ACPI_ERROR((AE_INFO,
+				    "Invalid/unsupported resource descriptor: Type 0x%2.2X",
+				    resource->type));
+			return (AE_AML_INVALID_RESOURCE_TYPE);
+		}
+
+		status = acpi_rs_convert_resource_to_aml(resource,
+						         ACPI_CAST_PTR(union
+								       aml_resource,
+								       aml),
+							 conversion_table);
 		if (ACPI_FAILURE(status)) {
 			ACPI_EXCEPTION((AE_INFO, status,
 					"Could not convert resource (type 0x%X) to AML",
@@ -192,9 +241,7 @@ acpi_rs_convert_resources_to_aml(struct acpi_resource *resource,
 
 		/* Point to the next input resource descriptor */
 
-		resource =
-		    ACPI_ADD_PTR(struct acpi_resource, resource,
-				 resource->length);
+		resource = ACPI_NEXT_RESOURCE(resource);
 	}
 
 	/* Completed buffer, but did not find an end_tag resource descriptor */
diff --git a/drivers/acpi/acpica/rsmisc.c b/drivers/acpi/acpica/rsmisc.c
index 410264b..af3dc63 100644
--- a/drivers/acpi/acpica/rsmisc.c
+++ b/drivers/acpi/acpica/rsmisc.c
@@ -83,6 +83,10 @@ acpi_rs_convert_aml_to_resource(struct acpi_resource *resource,
 
 	ACPI_FUNCTION_TRACE(rs_convert_aml_to_resource);
 
+	if (!info) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
 	if (((acpi_size) resource) & 0x3) {
 
 		/* Each internal resource struct is expected to be 32-bit aligned */
@@ -101,7 +105,6 @@ acpi_rs_convert_aml_to_resource(struct acpi_resource *resource,
 	 * table length (# of table entries)
 	 */
 	count = INIT_TABLE_LENGTH(info);
-
 	while (count) {
 		/*
 		 * Source is the external AML byte stream buffer,
@@ -145,6 +148,14 @@ acpi_rs_convert_aml_to_resource(struct acpi_resource *resource,
 			    ((ACPI_GET8(source) >> info->value) & 0x03);
 			break;
 
+		case ACPI_RSC_3BITFLAG:
+			/*
+			 * Mask and shift the flag bits
+			 */
+			ACPI_SET8(destination) = (u8)
+			    ((ACPI_GET8(source) >> info->value) & 0x07);
+			break;
+
 		case ACPI_RSC_COUNT:
 
 			item_count = ACPI_GET8(source);
@@ -163,6 +174,69 @@ acpi_rs_convert_aml_to_resource(struct acpi_resource *resource,
 			    (info->value * (item_count - 1));
 			break;
 
+		case ACPI_RSC_COUNT_GPIO_PIN:
+
+			target = ACPI_ADD_PTR(void, aml, info->value);
+			item_count = ACPI_GET16(target) - ACPI_GET16(source);
+
+			resource->length = resource->length + item_count;
+			item_count = item_count / 2;
+			ACPI_SET16(destination) = item_count;
+			break;
+
+		case ACPI_RSC_COUNT_GPIO_VEN:
+
+			item_count = ACPI_GET8(source);
+			ACPI_SET8(destination) = (u8)item_count;
+
+			resource->length = resource->length +
+			    (info->value * item_count);
+			break;
+
+		case ACPI_RSC_COUNT_GPIO_RES:
+
+			/*
+			 * Vendor data is optional (length/offset may both be zero)
+			 * Examine vendor data length field first
+			 */
+			target = ACPI_ADD_PTR(void, aml, (info->value + 2));
+			if (ACPI_GET16(target)) {
+
+				/* Use vendor offset to get resource source length */
+
+				target = ACPI_ADD_PTR(void, aml, info->value);
+				item_count =
+				    ACPI_GET16(target) - ACPI_GET16(source);
+			} else {
+				/* No vendor data to worry about */
+
+				item_count = aml->large_header.resource_length +
+				    sizeof(struct aml_resource_large_header) -
+				    ACPI_GET16(source);
+			}
+
+			resource->length = resource->length + item_count;
+			ACPI_SET16(destination) = item_count;
+			break;
+
+		case ACPI_RSC_COUNT_SERIAL_VEN:
+
+			item_count = ACPI_GET16(source) - info->value;
+
+			resource->length = resource->length + item_count;
+			ACPI_SET16(destination) = item_count;
+			break;
+
+		case ACPI_RSC_COUNT_SERIAL_RES:
+
+			item_count = (aml_resource_length +
+				      sizeof(struct aml_resource_large_header))
+			    - ACPI_GET16(source) - info->value;
+
+			resource->length = resource->length + item_count;
+			ACPI_SET16(destination) = item_count;
+			break;
+
 		case ACPI_RSC_LENGTH:
 
 			resource->length = resource->length + info->value;
@@ -183,6 +257,72 @@ acpi_rs_convert_aml_to_resource(struct acpi_resource *resource,
 					  info->opcode);
 			break;
 
+		case ACPI_RSC_MOVE_GPIO_PIN:
+
+			/* Generate and set the PIN data pointer */
+
+			target = (char *)ACPI_ADD_PTR(void, resource,
+						      (resource->length -
+						       item_count * 2));
+			*(u16 **)destination = ACPI_CAST_PTR(u16, target);
+
+			/* Copy the PIN data */
+
+			source = ACPI_ADD_PTR(void, aml, ACPI_GET16(source));
+			acpi_rs_move_data(target, source, item_count,
+					  info->opcode);
+			break;
+
+		case ACPI_RSC_MOVE_GPIO_RES:
+
+			/* Generate and set the resource_source string pointer */
+
+			target = (char *)ACPI_ADD_PTR(void, resource,
+						      (resource->length -
+						       item_count));
+			*(u8 **)destination = ACPI_CAST_PTR(u8, target);
+
+			/* Copy the resource_source string */
+
+			source = ACPI_ADD_PTR(void, aml, ACPI_GET16(source));
+			acpi_rs_move_data(target, source, item_count,
+					  info->opcode);
+			break;
+
+		case ACPI_RSC_MOVE_SERIAL_VEN:
+
+			/* Generate and set the Vendor Data pointer */
+
+			target = (char *)ACPI_ADD_PTR(void, resource,
+						      (resource->length -
+						       item_count));
+			*(u8 **)destination = ACPI_CAST_PTR(u8, target);
+
+			/* Copy the Vendor Data */
+
+			source = ACPI_ADD_PTR(void, aml, info->value);
+			acpi_rs_move_data(target, source, item_count,
+					  info->opcode);
+			break;
+
+		case ACPI_RSC_MOVE_SERIAL_RES:
+
+			/* Generate and set the resource_source string pointer */
+
+			target = (char *)ACPI_ADD_PTR(void, resource,
+						      (resource->length -
+						       item_count));
+			*(u8 **)destination = ACPI_CAST_PTR(u8, target);
+
+			/* Copy the resource_source string */
+
+			source =
+			    ACPI_ADD_PTR(void, aml,
+					 (ACPI_GET16(source) + info->value));
+			acpi_rs_move_data(target, source, item_count,
+					  info->opcode);
+			break;
+
 		case ACPI_RSC_SET8:
 
 			ACPI_MEMSET(destination, info->aml_offset, info->value);
@@ -219,13 +359,18 @@ acpi_rs_convert_aml_to_resource(struct acpi_resource *resource,
 			 * Optional resource_source (Index and String). This is the more
 			 * complicated case used by the Interrupt() macro
 			 */
-			target =
-			    ACPI_ADD_PTR(char, resource,
-					 info->aml_offset + (item_count * 4));
+			target = ACPI_ADD_PTR(char, resource,
+					      info->aml_offset +
+					      (item_count * 4));
 
 			resource->length +=
 			    acpi_rs_get_resource_source(aml_resource_length,
-							(acpi_rs_length) (((item_count - 1) * sizeof(u32)) + info->value), destination, aml, target);
+							(acpi_rs_length)
+							(((item_count -
+							   1) * sizeof(u32)) +
+							 info->value),
+							destination, aml,
+							target);
 			break;
 
 		case ACPI_RSC_BITMASK:
@@ -327,6 +472,7 @@ acpi_rs_convert_resource_to_aml(struct acpi_resource *resource,
 {
 	void *source = NULL;
 	void *destination;
+	char *target;
 	acpi_rsdesc_size aml_length = 0;
 	u8 count;
 	u16 temp16 = 0;
@@ -334,6 +480,10 @@ acpi_rs_convert_resource_to_aml(struct acpi_resource *resource,
 
 	ACPI_FUNCTION_TRACE(rs_convert_resource_to_aml);
 
+	if (!info) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
 	/*
 	 * First table entry must be ACPI_RSC_INITxxx and must contain the
 	 * table length (# of table entries)
@@ -383,6 +533,14 @@ acpi_rs_convert_resource_to_aml(struct acpi_resource *resource,
 			    ((ACPI_GET8(source) & 0x03) << info->value);
 			break;
 
+		case ACPI_RSC_3BITFLAG:
+			/*
+			 * Mask and shift the flag bits
+			 */
+			ACPI_SET8(destination) |= (u8)
+			    ((ACPI_GET8(source) & 0x07) << info->value);
+			break;
+
 		case ACPI_RSC_COUNT:
 
 			item_count = ACPI_GET8(source);
@@ -400,6 +558,63 @@ acpi_rs_convert_resource_to_aml(struct acpi_resource *resource,
 			acpi_rs_set_resource_length(aml_length, aml);
 			break;
 
+		case ACPI_RSC_COUNT_GPIO_PIN:
+
+			item_count = ACPI_GET16(source);
+			ACPI_SET16(destination) = (u16)aml_length;
+
+			aml_length = (u16)(aml_length + item_count * 2);
+			target = ACPI_ADD_PTR(void, aml, info->value);
+			ACPI_SET16(target) = (u16)aml_length;
+			acpi_rs_set_resource_length(aml_length, aml);
+			break;
+
+		case ACPI_RSC_COUNT_GPIO_VEN:
+
+			item_count = ACPI_GET16(source);
+			ACPI_SET16(destination) = (u16)item_count;
+
+			aml_length =
+			    (u16)(aml_length + (info->value * item_count));
+			acpi_rs_set_resource_length(aml_length, aml);
+			break;
+
+		case ACPI_RSC_COUNT_GPIO_RES:
+
+			/* Set resource source string length */
+
+			item_count = ACPI_GET16(source);
+			ACPI_SET16(destination) = (u16)aml_length;
+
+			/* Compute offset for the Vendor Data */
+
+			aml_length = (u16)(aml_length + item_count);
+			target = ACPI_ADD_PTR(void, aml, info->value);
+
+			/* Set vendor offset only if there is vendor data */
+
+			if (resource->data.gpio.vendor_length) {
+				ACPI_SET16(target) = (u16)aml_length;
+			}
+
+			acpi_rs_set_resource_length(aml_length, aml);
+			break;
+
+		case ACPI_RSC_COUNT_SERIAL_VEN:
+
+			item_count = ACPI_GET16(source);
+			ACPI_SET16(destination) = item_count + info->value;
+			aml_length = (u16)(aml_length + item_count);
+			acpi_rs_set_resource_length(aml_length, aml);
+			break;
+
+		case ACPI_RSC_COUNT_SERIAL_RES:
+
+			item_count = ACPI_GET16(source);
+			aml_length = (u16)(aml_length + item_count);
+			acpi_rs_set_resource_length(aml_length, aml);
+			break;
+
 		case ACPI_RSC_LENGTH:
 
 			acpi_rs_set_resource_length(info->value, aml);
@@ -417,6 +632,48 @@ acpi_rs_convert_resource_to_aml(struct acpi_resource *resource,
 					  info->opcode);
 			break;
 
+		case ACPI_RSC_MOVE_GPIO_PIN:
+
+			destination = (char *)ACPI_ADD_PTR(void, aml,
+							   ACPI_GET16
+							   (destination));
+			source = *(u16 **)source;
+			acpi_rs_move_data(destination, source, item_count,
+					  info->opcode);
+			break;
+
+		case ACPI_RSC_MOVE_GPIO_RES:
+
+			/* Used for both resource_source string and vendor_data */
+
+			destination = (char *)ACPI_ADD_PTR(void, aml,
+							   ACPI_GET16
+							   (destination));
+			source = *(u8 **)source;
+			acpi_rs_move_data(destination, source, item_count,
+					  info->opcode);
+			break;
+
+		case ACPI_RSC_MOVE_SERIAL_VEN:
+
+			destination = (char *)ACPI_ADD_PTR(void, aml,
+							   (aml_length -
+							    item_count));
+			source = *(u8 **)source;
+			acpi_rs_move_data(destination, source, item_count,
+					  info->opcode);
+			break;
+
+		case ACPI_RSC_MOVE_SERIAL_RES:
+
+			destination = (char *)ACPI_ADD_PTR(void, aml,
+							   (aml_length -
+							    item_count));
+			source = *(u8 **)source;
+			acpi_rs_move_data(destination, source, item_count,
+					  info->opcode);
+			break;
+
 		case ACPI_RSC_ADDRESS:
 
 			/* Set the Resource Type, General Flags, and Type-Specific Flags */
diff --git a/drivers/acpi/acpica/rsserial.c b/drivers/acpi/acpica/rsserial.c
new file mode 100644
index 0000000..d0b8e12
--- /dev/null
+++ b/drivers/acpi/acpica/rsserial.c
@@ -0,0 +1,441 @@
+/*******************************************************************************
+ *
+ * Module Name: rsserial - GPIO/serial_bus resource descriptors
+ *
+ ******************************************************************************/
+
+/*
+ * Copyright (C) 2000 - 2011, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#include <acpi/acpi.h>
+#include "accommon.h"
+#include "acresrc.h"
+
+#define _COMPONENT          ACPI_RESOURCES
+ACPI_MODULE_NAME("rsserial")
+
+/*******************************************************************************
+ *
+ * acpi_rs_convert_gpio
+ *
+ ******************************************************************************/
+struct acpi_rsconvert_info acpi_rs_convert_gpio[17] = {
+	{ACPI_RSC_INITGET, ACPI_RESOURCE_TYPE_GPIO,
+	 ACPI_RS_SIZE(struct acpi_resource_gpio),
+	 ACPI_RSC_TABLE_SIZE(acpi_rs_convert_gpio)},
+
+	{ACPI_RSC_INITSET, ACPI_RESOURCE_NAME_GPIO,
+	 sizeof(struct aml_resource_gpio),
+	 0},
+
+	/*
+	 * These fields are contiguous in both the source and destination:
+	 * revision_id
+	 * connection_type
+	 */
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.gpio.revision_id),
+	 AML_OFFSET(gpio.revision_id),
+	 2},
+
+	{ACPI_RSC_1BITFLAG, ACPI_RS_OFFSET(data.gpio.producer_consumer),
+	 AML_OFFSET(gpio.flags),
+	 0},
+
+	{ACPI_RSC_2BITFLAG, ACPI_RS_OFFSET(data.gpio.sharable),
+	 AML_OFFSET(gpio.int_flags),
+	 3},
+
+	{ACPI_RSC_2BITFLAG, ACPI_RS_OFFSET(data.gpio.io_restriction),
+	 AML_OFFSET(gpio.int_flags),
+	 0},
+
+	{ACPI_RSC_1BITFLAG, ACPI_RS_OFFSET(data.gpio.triggering),
+	 AML_OFFSET(gpio.int_flags),
+	 0},
+
+	{ACPI_RSC_2BITFLAG, ACPI_RS_OFFSET(data.gpio.polarity),
+	 AML_OFFSET(gpio.int_flags),
+	 1},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.gpio.pin_config),
+	 AML_OFFSET(gpio.pin_config),
+	 1},
+
+	/*
+	 * These fields are contiguous in both the source and destination:
+	 * drive_strength
+	 * debounce_timeout
+	 */
+	{ACPI_RSC_MOVE16, ACPI_RS_OFFSET(data.gpio.drive_strength),
+	 AML_OFFSET(gpio.drive_strength),
+	 2},
+
+	/* Pin Table */
+
+	{ACPI_RSC_COUNT_GPIO_PIN, ACPI_RS_OFFSET(data.gpio.pin_table_length),
+	 AML_OFFSET(gpio.pin_table_offset),
+	 AML_OFFSET(gpio.res_source_offset)},
+
+	{ACPI_RSC_MOVE_GPIO_PIN, ACPI_RS_OFFSET(data.gpio.pin_table),
+	 AML_OFFSET(gpio.pin_table_offset),
+	 0},
+
+	/* Resource Source */
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.gpio.resource_source.index),
+	 AML_OFFSET(gpio.res_source_index),
+	 1},
+
+	{ACPI_RSC_COUNT_GPIO_RES,
+	 ACPI_RS_OFFSET(data.gpio.resource_source.string_length),
+	 AML_OFFSET(gpio.res_source_offset),
+	 AML_OFFSET(gpio.vendor_offset)},
+
+	{ACPI_RSC_MOVE_GPIO_RES,
+	 ACPI_RS_OFFSET(data.gpio.resource_source.string_ptr),
+	 AML_OFFSET(gpio.res_source_offset),
+	 0},
+
+	/* Vendor Data */
+
+	{ACPI_RSC_COUNT_GPIO_VEN, ACPI_RS_OFFSET(data.gpio.vendor_length),
+	 AML_OFFSET(gpio.vendor_length),
+	 1},
+
+	{ACPI_RSC_MOVE_GPIO_RES, ACPI_RS_OFFSET(data.gpio.vendor_data),
+	 AML_OFFSET(gpio.vendor_offset),
+	 0},
+};
+
+/*******************************************************************************
+ *
+ * acpi_rs_convert_i2c_serial_bus
+ *
+ ******************************************************************************/
+
+struct acpi_rsconvert_info acpi_rs_convert_i2c_serial_bus[16] = {
+	{ACPI_RSC_INITGET, ACPI_RESOURCE_TYPE_SERIAL_BUS,
+	 ACPI_RS_SIZE(struct acpi_resource_i2c_serialbus),
+	 ACPI_RSC_TABLE_SIZE(acpi_rs_convert_i2c_serial_bus)},
+
+	{ACPI_RSC_INITSET, ACPI_RESOURCE_NAME_SERIAL_BUS,
+	 sizeof(struct aml_resource_i2c_serialbus),
+	 0},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.common_serial_bus.revision_id),
+	 AML_OFFSET(common_serial_bus.revision_id),
+	 1},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.common_serial_bus.type),
+	 AML_OFFSET(common_serial_bus.type),
+	 1},
+
+	{ACPI_RSC_1BITFLAG, ACPI_RS_OFFSET(data.common_serial_bus.slave_mode),
+	 AML_OFFSET(common_serial_bus.flags),
+	 0},
+
+	{ACPI_RSC_1BITFLAG,
+	 ACPI_RS_OFFSET(data.common_serial_bus.producer_consumer),
+	 AML_OFFSET(common_serial_bus.flags),
+	 1},
+
+	{ACPI_RSC_MOVE8,
+	 ACPI_RS_OFFSET(data.common_serial_bus.type_revision_id),
+	 AML_OFFSET(common_serial_bus.type_revision_id),
+	 1},
+
+	{ACPI_RSC_MOVE16,
+	 ACPI_RS_OFFSET(data.common_serial_bus.type_data_length),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 1},
+
+	/* Vendor data */
+
+	{ACPI_RSC_COUNT_SERIAL_VEN,
+	 ACPI_RS_OFFSET(data.common_serial_bus.vendor_length),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 AML_RESOURCE_I2C_MIN_DATA_LEN},
+
+	{ACPI_RSC_MOVE_SERIAL_VEN,
+	 ACPI_RS_OFFSET(data.common_serial_bus.vendor_data),
+	 0,
+	 sizeof(struct aml_resource_i2c_serialbus)},
+
+	/* Resource Source */
+
+	{ACPI_RSC_MOVE8,
+	 ACPI_RS_OFFSET(data.common_serial_bus.resource_source.index),
+	 AML_OFFSET(common_serial_bus.res_source_index),
+	 1},
+
+	{ACPI_RSC_COUNT_SERIAL_RES,
+	 ACPI_RS_OFFSET(data.common_serial_bus.resource_source.string_length),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 sizeof(struct aml_resource_common_serialbus)},
+
+	{ACPI_RSC_MOVE_SERIAL_RES,
+	 ACPI_RS_OFFSET(data.common_serial_bus.resource_source.string_ptr),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 sizeof(struct aml_resource_common_serialbus)},
+
+	/* I2C bus type specific */
+
+	{ACPI_RSC_1BITFLAG, ACPI_RS_OFFSET(data.i2c_serial_bus.access_mode),
+	 AML_OFFSET(i2c_serial_bus.type_specific_flags),
+	 0},
+
+	{ACPI_RSC_MOVE32, ACPI_RS_OFFSET(data.i2c_serial_bus.connection_speed),
+	 AML_OFFSET(i2c_serial_bus.connection_speed),
+	 1},
+
+	{ACPI_RSC_MOVE16, ACPI_RS_OFFSET(data.i2c_serial_bus.slave_address),
+	 AML_OFFSET(i2c_serial_bus.slave_address),
+	 1},
+};
+
+/*******************************************************************************
+ *
+ * acpi_rs_convert_spi_serial_bus
+ *
+ ******************************************************************************/
+
+struct acpi_rsconvert_info acpi_rs_convert_spi_serial_bus[20] = {
+	{ACPI_RSC_INITGET, ACPI_RESOURCE_TYPE_SERIAL_BUS,
+	 ACPI_RS_SIZE(struct acpi_resource_spi_serialbus),
+	 ACPI_RSC_TABLE_SIZE(acpi_rs_convert_spi_serial_bus)},
+
+	{ACPI_RSC_INITSET, ACPI_RESOURCE_NAME_SERIAL_BUS,
+	 sizeof(struct aml_resource_spi_serialbus),
+	 0},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.common_serial_bus.revision_id),
+	 AML_OFFSET(common_serial_bus.revision_id),
+	 1},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.common_serial_bus.type),
+	 AML_OFFSET(common_serial_bus.type),
+	 1},
+
+	{ACPI_RSC_1BITFLAG, ACPI_RS_OFFSET(data.common_serial_bus.slave_mode),
+	 AML_OFFSET(common_serial_bus.flags),
+	 0},
+
+	{ACPI_RSC_1BITFLAG,
+	 ACPI_RS_OFFSET(data.common_serial_bus.producer_consumer),
+	 AML_OFFSET(common_serial_bus.flags),
+	 1},
+
+	{ACPI_RSC_MOVE8,
+	 ACPI_RS_OFFSET(data.common_serial_bus.type_revision_id),
+	 AML_OFFSET(common_serial_bus.type_revision_id),
+	 1},
+
+	{ACPI_RSC_MOVE16,
+	 ACPI_RS_OFFSET(data.common_serial_bus.type_data_length),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 1},
+
+	/* Vendor data */
+
+	{ACPI_RSC_COUNT_SERIAL_VEN,
+	 ACPI_RS_OFFSET(data.common_serial_bus.vendor_length),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 AML_RESOURCE_SPI_MIN_DATA_LEN},
+
+	{ACPI_RSC_MOVE_SERIAL_VEN,
+	 ACPI_RS_OFFSET(data.common_serial_bus.vendor_data),
+	 0,
+	 sizeof(struct aml_resource_spi_serialbus)},
+
+	/* Resource Source */
+
+	{ACPI_RSC_MOVE8,
+	 ACPI_RS_OFFSET(data.common_serial_bus.resource_source.index),
+	 AML_OFFSET(common_serial_bus.res_source_index),
+	 1},
+
+	{ACPI_RSC_COUNT_SERIAL_RES,
+	 ACPI_RS_OFFSET(data.common_serial_bus.resource_source.string_length),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 sizeof(struct aml_resource_common_serialbus)},
+
+	{ACPI_RSC_MOVE_SERIAL_RES,
+	 ACPI_RS_OFFSET(data.common_serial_bus.resource_source.string_ptr),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 sizeof(struct aml_resource_common_serialbus)},
+
+	/* Spi bus type specific  */
+
+	{ACPI_RSC_1BITFLAG, ACPI_RS_OFFSET(data.spi_serial_bus.wire_mode),
+	 AML_OFFSET(spi_serial_bus.type_specific_flags),
+	 0},
+
+	{ACPI_RSC_1BITFLAG, ACPI_RS_OFFSET(data.spi_serial_bus.device_polarity),
+	 AML_OFFSET(spi_serial_bus.type_specific_flags),
+	 1},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.spi_serial_bus.data_bit_length),
+	 AML_OFFSET(spi_serial_bus.data_bit_length),
+	 1},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.spi_serial_bus.clock_phase),
+	 AML_OFFSET(spi_serial_bus.clock_phase),
+	 1},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.spi_serial_bus.clock_polarity),
+	 AML_OFFSET(spi_serial_bus.clock_polarity),
+	 1},
+
+	{ACPI_RSC_MOVE16, ACPI_RS_OFFSET(data.spi_serial_bus.device_selection),
+	 AML_OFFSET(spi_serial_bus.device_selection),
+	 1},
+
+	{ACPI_RSC_MOVE32, ACPI_RS_OFFSET(data.spi_serial_bus.connection_speed),
+	 AML_OFFSET(spi_serial_bus.connection_speed),
+	 1},
+};
+
+/*******************************************************************************
+ *
+ * acpi_rs_convert_uart_serial_bus
+ *
+ ******************************************************************************/
+
+struct acpi_rsconvert_info acpi_rs_convert_uart_serial_bus[22] = {
+	{ACPI_RSC_INITGET, ACPI_RESOURCE_TYPE_SERIAL_BUS,
+	 ACPI_RS_SIZE(struct acpi_resource_uart_serialbus),
+	 ACPI_RSC_TABLE_SIZE(acpi_rs_convert_uart_serial_bus)},
+
+	{ACPI_RSC_INITSET, ACPI_RESOURCE_NAME_SERIAL_BUS,
+	 sizeof(struct aml_resource_uart_serialbus),
+	 0},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.common_serial_bus.revision_id),
+	 AML_OFFSET(common_serial_bus.revision_id),
+	 1},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.common_serial_bus.type),
+	 AML_OFFSET(common_serial_bus.type),
+	 1},
+
+	{ACPI_RSC_1BITFLAG, ACPI_RS_OFFSET(data.common_serial_bus.slave_mode),
+	 AML_OFFSET(common_serial_bus.flags),
+	 0},
+
+	{ACPI_RSC_1BITFLAG,
+	 ACPI_RS_OFFSET(data.common_serial_bus.producer_consumer),
+	 AML_OFFSET(common_serial_bus.flags),
+	 1},
+
+	{ACPI_RSC_MOVE8,
+	 ACPI_RS_OFFSET(data.common_serial_bus.type_revision_id),
+	 AML_OFFSET(common_serial_bus.type_revision_id),
+	 1},
+
+	{ACPI_RSC_MOVE16,
+	 ACPI_RS_OFFSET(data.common_serial_bus.type_data_length),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 1},
+
+	/* Vendor data */
+
+	{ACPI_RSC_COUNT_SERIAL_VEN,
+	 ACPI_RS_OFFSET(data.common_serial_bus.vendor_length),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 AML_RESOURCE_UART_MIN_DATA_LEN},
+
+	{ACPI_RSC_MOVE_SERIAL_VEN,
+	 ACPI_RS_OFFSET(data.common_serial_bus.vendor_data),
+	 0,
+	 sizeof(struct aml_resource_uart_serialbus)},
+
+	/* Resource Source */
+
+	{ACPI_RSC_MOVE8,
+	 ACPI_RS_OFFSET(data.common_serial_bus.resource_source.index),
+	 AML_OFFSET(common_serial_bus.res_source_index),
+	 1},
+
+	{ACPI_RSC_COUNT_SERIAL_RES,
+	 ACPI_RS_OFFSET(data.common_serial_bus.resource_source.string_length),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 sizeof(struct aml_resource_common_serialbus)},
+
+	{ACPI_RSC_MOVE_SERIAL_RES,
+	 ACPI_RS_OFFSET(data.common_serial_bus.resource_source.string_ptr),
+	 AML_OFFSET(common_serial_bus.type_data_length),
+	 sizeof(struct aml_resource_common_serialbus)},
+
+	/* Uart bus type specific  */
+
+	{ACPI_RSC_2BITFLAG, ACPI_RS_OFFSET(data.uart_serial_bus.flow_control),
+	 AML_OFFSET(uart_serial_bus.type_specific_flags),
+	 0},
+
+	{ACPI_RSC_2BITFLAG, ACPI_RS_OFFSET(data.uart_serial_bus.stop_bits),
+	 AML_OFFSET(uart_serial_bus.type_specific_flags),
+	 2},
+
+	{ACPI_RSC_3BITFLAG, ACPI_RS_OFFSET(data.uart_serial_bus.data_bits),
+	 AML_OFFSET(uart_serial_bus.type_specific_flags),
+	 4},
+
+	{ACPI_RSC_1BITFLAG, ACPI_RS_OFFSET(data.uart_serial_bus.endian),
+	 AML_OFFSET(uart_serial_bus.type_specific_flags),
+	 7},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.uart_serial_bus.parity),
+	 AML_OFFSET(uart_serial_bus.parity),
+	 1},
+
+	{ACPI_RSC_MOVE8, ACPI_RS_OFFSET(data.uart_serial_bus.lines_enabled),
+	 AML_OFFSET(uart_serial_bus.lines_enabled),
+	 1},
+
+	{ACPI_RSC_MOVE16, ACPI_RS_OFFSET(data.uart_serial_bus.rx_fifo_size),
+	 AML_OFFSET(uart_serial_bus.rx_fifo_size),
+	 1},
+
+	{ACPI_RSC_MOVE16, ACPI_RS_OFFSET(data.uart_serial_bus.tx_fifo_size),
+	 AML_OFFSET(uart_serial_bus.tx_fifo_size),
+	 1},
+
+	{ACPI_RSC_MOVE32,
+	 ACPI_RS_OFFSET(data.uart_serial_bus.default_baud_rate),
+	 AML_OFFSET(uart_serial_bus.default_baud_rate),
+	 1},
+};
diff --git a/drivers/acpi/acpica/rsutils.c b/drivers/acpi/acpica/rsutils.c
index 231811e..4409db8 100644
--- a/drivers/acpi/acpica/rsutils.c
+++ b/drivers/acpi/acpica/rsutils.c
@@ -144,6 +144,9 @@ acpi_rs_move_data(void *destination, void *source, u16 item_count, u8 move_type)
 			 * since there are no alignment or endian issues
 			 */
 		case ACPI_RSC_MOVE8:
+		case ACPI_RSC_MOVE_GPIO_RES:
+		case ACPI_RSC_MOVE_SERIAL_VEN:
+		case ACPI_RSC_MOVE_SERIAL_RES:
 			ACPI_MEMCPY(destination, source, item_count);
 			return;
 
@@ -153,6 +156,7 @@ acpi_rs_move_data(void *destination, void *source, u16 item_count, u8 move_type)
 			 * misaligned memory transfers
 			 */
 		case ACPI_RSC_MOVE16:
+		case ACPI_RSC_MOVE_GPIO_PIN:
 			ACPI_MOVE_16_TO_16(&ACPI_CAST_PTR(u16, destination)[i],
 					   &ACPI_CAST_PTR(u16, source)[i]);
 			break;
diff --git a/drivers/acpi/acpica/utresrc.c b/drivers/acpi/acpica/utresrc.c
index 6ffd3a8..cd7fbbf 100644
--- a/drivers/acpi/acpica/utresrc.c
+++ b/drivers/acpi/acpica/utresrc.c
@@ -43,7 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
-#include "amlresrc.h"
+#include "acresrc.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utresrc")
@@ -154,6 +154,138 @@ const char *acpi_gbl_typ_decode[] = {
 	"TypeF"
 };
 
+const char *acpi_gbl_ppc_decode[] = {
+	"PullDefault",
+	"PullUp",
+	"PullDown",
+	"PullNone"
+};
+
+const char *acpi_gbl_ior_decode[] = {
+	"IoRestrictionNone",
+	"IoRestrictionInputOnly",
+	"IoRestrictionOutputOnly",
+	"IoRestrictionNoneAndPreserve"
+};
+
+const char *acpi_gbl_dts_decode[] = {
+	"Width8bit",
+	"Width16bit",
+	"Width32bit",
+	"Width64bit",
+	"Width128bit",
+	"Width256bit",
+};
+
+/* GPIO connection type */
+
+const char *acpi_gbl_ct_decode[] = {
+	"Interrupt",
+	"I/O"
+};
+
+/* Serial bus type */
+
+const char *acpi_gbl_sbt_decode[] = {
+	"/* UNKNOWN serial bus type */",
+	"I2C",
+	"SPI",
+	"UART"
+};
+
+/* I2C serial bus access mode */
+
+const char *acpi_gbl_am_decode[] = {
+	"AddressingMode7Bit",
+	"AddressingMode10Bit"
+};
+
+/* I2C serial bus slave mode */
+
+const char *acpi_gbl_sm_decode[] = {
+	"ControllerInitiated",
+	"DeviceInitiated"
+};
+
+/* SPI serial bus wire mode */
+
+const char *acpi_gbl_wm_decode[] = {
+	"FourWireMode",
+	"ThreeWireMode"
+};
+
+/* SPI serial clock phase */
+
+const char *acpi_gbl_cph_decode[] = {
+	"ClockPhaseFirst",
+	"ClockPhaseSecond"
+};
+
+/* SPI serial bus clock polarity */
+
+const char *acpi_gbl_cpo_decode[] = {
+	"ClockPolarityLow",
+	"ClockPolarityHigh"
+};
+
+/* SPI serial bus device polarity */
+
+const char *acpi_gbl_dp_decode[] = {
+	"PolarityLow",
+	"PolarityHigh"
+};
+
+/* UART serial bus endian */
+
+const char *acpi_gbl_ed_decode[] = {
+	"LittleEndian",
+	"BigEndian"
+};
+
+/* UART serial bus bits per byte */
+
+const char *acpi_gbl_bpb_decode[] = {
+	"DataBitsFive",
+	"DataBitsSix",
+	"DataBitsSeven",
+	"DataBitsEight",
+	"DataBitsNine",
+	"/* UNKNOWN Bits per byte */",
+	"/* UNKNOWN Bits per byte */",
+	"/* UNKNOWN Bits per byte */"
+};
+
+/* UART serial bus stop bits */
+
+const char *acpi_gbl_sb_decode[] = {
+	"StopBitsNone",
+	"StopBitsOne",
+	"StopBitsOnePlusHalf",
+	"StopBitsTwo"
+};
+
+/* UART serial bus flow control */
+
+const char *acpi_gbl_fc_decode[] = {
+	"FlowControlNone",
+	"FlowControlHardware",
+	"FlowControlXON",
+	"/* UNKNOWN flow control keyword */"
+};
+
+/* UART serial bus parity type */
+
+const char *acpi_gbl_pt_decode[] = {
+	"ParityTypeNone",
+	"ParityTypeEven",
+	"ParityTypeOdd",
+	"ParityTypeMark",
+	"ParityTypeSpace",
+	"/* UNKNOWN parity keyword */",
+	"/* UNKNOWN parity keyword */",
+	"/* UNKNOWN parity keyword */"
+};
+
 #endif
 
 /*
@@ -173,7 +305,7 @@ const u8 acpi_gbl_resource_aml_sizes[] = {
 	ACPI_AML_SIZE_SMALL(struct aml_resource_end_dependent),
 	ACPI_AML_SIZE_SMALL(struct aml_resource_io),
 	ACPI_AML_SIZE_SMALL(struct aml_resource_fixed_io),
-	0,
+	ACPI_AML_SIZE_SMALL(struct aml_resource_fixed_dma),
 	0,
 	0,
 	0,
@@ -193,7 +325,17 @@ const u8 acpi_gbl_resource_aml_sizes[] = {
 	ACPI_AML_SIZE_LARGE(struct aml_resource_address16),
 	ACPI_AML_SIZE_LARGE(struct aml_resource_extended_irq),
 	ACPI_AML_SIZE_LARGE(struct aml_resource_address64),
-	ACPI_AML_SIZE_LARGE(struct aml_resource_extended_address64)
+	ACPI_AML_SIZE_LARGE(struct aml_resource_extended_address64),
+	ACPI_AML_SIZE_LARGE(struct aml_resource_gpio),
+	0,
+	ACPI_AML_SIZE_LARGE(struct aml_resource_common_serialbus),
+};
+
+const u8 acpi_gbl_resource_aml_serial_bus_sizes[] = {
+	0,
+	ACPI_AML_SIZE_LARGE(struct aml_resource_i2c_serialbus),
+	ACPI_AML_SIZE_LARGE(struct aml_resource_spi_serialbus),
+	ACPI_AML_SIZE_LARGE(struct aml_resource_uart_serialbus),
 };
 
 /*
@@ -209,35 +351,49 @@ static const u8 acpi_gbl_resource_types[] = {
 	0,
 	0,
 	0,
-	ACPI_SMALL_VARIABLE_LENGTH,
-	ACPI_FIXED_LENGTH,
-	ACPI_SMALL_VARIABLE_LENGTH,
-	ACPI_FIXED_LENGTH,
-	ACPI_FIXED_LENGTH,
-	ACPI_FIXED_LENGTH,
-	0,
+	ACPI_SMALL_VARIABLE_LENGTH,	/* 04 IRQ */
+	ACPI_FIXED_LENGTH,	/* 05 DMA */
+	ACPI_SMALL_VARIABLE_LENGTH,	/* 06 start_dependent_functions */
+	ACPI_FIXED_LENGTH,	/* 07 end_dependent_functions */
+	ACPI_FIXED_LENGTH,	/* 08 IO */
+	ACPI_FIXED_LENGTH,	/* 09 fixed_iO */
+	ACPI_FIXED_LENGTH,	/* 0_a fixed_dMA */
 	0,
 	0,
 	0,
-	ACPI_VARIABLE_LENGTH,
-	ACPI_FIXED_LENGTH,
+	ACPI_VARIABLE_LENGTH,	/* 0_e vendor_short */
+	ACPI_FIXED_LENGTH,	/* 0_f end_tag */
 
 	/* Large descriptors */
 
 	0,
-	ACPI_FIXED_LENGTH,
-	ACPI_FIXED_LENGTH,
+	ACPI_FIXED_LENGTH,	/* 01 Memory24 */
+	ACPI_FIXED_LENGTH,	/* 02 generic_register */
 	0,
-	ACPI_VARIABLE_LENGTH,
-	ACPI_FIXED_LENGTH,
-	ACPI_FIXED_LENGTH,
-	ACPI_VARIABLE_LENGTH,
-	ACPI_VARIABLE_LENGTH,
-	ACPI_VARIABLE_LENGTH,
-	ACPI_VARIABLE_LENGTH,
-	ACPI_FIXED_LENGTH
+	ACPI_VARIABLE_LENGTH,	/* 04 vendor_long */
+	ACPI_FIXED_LENGTH,	/* 05 Memory32 */
+	ACPI_FIXED_LENGTH,	/* 06 memory32_fixed */
+	ACPI_VARIABLE_LENGTH,	/* 07 Dword* address */
+	ACPI_VARIABLE_LENGTH,	/* 08 Word* address */
+	ACPI_VARIABLE_LENGTH,	/* 09 extended_iRQ */
+	ACPI_VARIABLE_LENGTH,	/* 0_a Qword* address */
+	ACPI_FIXED_LENGTH,	/* 0_b Extended* address */
+	ACPI_VARIABLE_LENGTH,	/* 0_c Gpio* */
+	0,
+	ACPI_VARIABLE_LENGTH	/* 0_e *serial_bus */
 };
 
+/*
+ * For the i_aSL compiler/disassembler, we don't want any error messages
+ * because the disassembler uses the resource validation code to determine
+ * if Buffer objects are actually Resource Templates.
+ */
+#ifdef ACPI_ASL_COMPILER
+#define ACPI_RESOURCE_ERROR(plist)
+#else
+#define ACPI_RESOURCE_ERROR(plist)  ACPI_ERROR(plist)
+#endif
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ut_walk_aml_resources
@@ -265,6 +421,7 @@ acpi_ut_walk_aml_resources(u8 * aml,
 	u8 resource_index;
 	u32 length;
 	u32 offset = 0;
+	u8 end_tag[2] = { 0x79, 0x00 };
 
 	ACPI_FUNCTION_TRACE(ut_walk_aml_resources);
 
@@ -286,6 +443,10 @@ acpi_ut_walk_aml_resources(u8 * aml,
 
 		status = acpi_ut_validate_resource(aml, &resource_index);
 		if (ACPI_FAILURE(status)) {
+			/*
+			 * Exit on failure. Cannot continue because the descriptor length
+			 * may be bogus also.
+			 */
 			return_ACPI_STATUS(status);
 		}
 
@@ -300,7 +461,7 @@ acpi_ut_walk_aml_resources(u8 * aml,
 			    user_function(aml, length, offset, resource_index,
 					  context);
 			if (ACPI_FAILURE(status)) {
-				return (status);
+				return_ACPI_STATUS(status);
 			}
 		}
 
@@ -333,7 +494,19 @@ acpi_ut_walk_aml_resources(u8 * aml,
 
 	/* Did not find an end_tag descriptor */
 
-	return (AE_AML_NO_RESOURCE_END_TAG);
+	if (user_function) {
+
+		/* Insert an end_tag anyway. acpi_rs_get_list_length always leaves room */
+
+		(void)acpi_ut_validate_resource(end_tag, &resource_index);
+		status =
+		    user_function(end_tag, 2, offset, resource_index, context);
+		if (ACPI_FAILURE(status)) {
+			return_ACPI_STATUS(status);
+		}
+	}
+
+	return_ACPI_STATUS(AE_AML_NO_RESOURCE_END_TAG);
 }
 
 /*******************************************************************************
@@ -354,6 +527,7 @@ acpi_ut_walk_aml_resources(u8 * aml,
 
 acpi_status acpi_ut_validate_resource(void *aml, u8 * return_index)
 {
+	union aml_resource *aml_resource;
 	u8 resource_type;
 	u8 resource_index;
 	acpi_rs_length resource_length;
@@ -375,7 +549,7 @@ acpi_status acpi_ut_validate_resource(void *aml, u8 * return_index)
 		/* Verify the large resource type (name) against the max */
 
 		if (resource_type > ACPI_RESOURCE_NAME_LARGE_MAX) {
-			return (AE_AML_INVALID_RESOURCE_TYPE);
+			goto invalid_resource;
 		}
 
 		/*
@@ -392,15 +566,17 @@ acpi_status acpi_ut_validate_resource(void *aml, u8 * return_index)
 		    ((resource_type & ACPI_RESOURCE_NAME_SMALL_MASK) >> 3);
 	}
 
-	/* Check validity of the resource type, zero indicates name is invalid */
-
+	/*
+	 * Check validity of the resource type, via acpi_gbl_resource_types. Zero
+	 * indicates an invalid resource.
+	 */
 	if (!acpi_gbl_resource_types[resource_index]) {
-		return (AE_AML_INVALID_RESOURCE_TYPE);
+		goto invalid_resource;
 	}
 
 	/*
-	 * 2) Validate the resource_length field. This ensures that the length
-	 *    is at least reasonable, and guarantees that it is non-zero.
+	 * Validate the resource_length field. This ensures that the length
+	 * is at least reasonable, and guarantees that it is non-zero.
 	 */
 	resource_length = acpi_ut_get_resource_length(aml);
 	minimum_resource_length = acpi_gbl_resource_aml_sizes[resource_index];
@@ -413,7 +589,7 @@ acpi_status acpi_ut_validate_resource(void *aml, u8 * return_index)
 		/* Fixed length resource, length must match exactly */
 
 		if (resource_length != minimum_resource_length) {
-			return (AE_AML_BAD_RESOURCE_LENGTH);
+			goto bad_resource_length;
 		}
 		break;
 
@@ -422,7 +598,7 @@ acpi_status acpi_ut_validate_resource(void *aml, u8 * return_index)
 		/* Variable length resource, length must be at least the minimum */
 
 		if (resource_length < minimum_resource_length) {
-			return (AE_AML_BAD_RESOURCE_LENGTH);
+			goto bad_resource_length;
 		}
 		break;
 
@@ -432,7 +608,7 @@ acpi_status acpi_ut_validate_resource(void *aml, u8 * return_index)
 
 		if ((resource_length > minimum_resource_length) ||
 		    (resource_length < (minimum_resource_length - 1))) {
-			return (AE_AML_BAD_RESOURCE_LENGTH);
+			goto bad_resource_length;
 		}
 		break;
 
@@ -440,7 +616,23 @@ acpi_status acpi_ut_validate_resource(void *aml, u8 * return_index)
 
 		/* Shouldn't happen (because of validation earlier), but be sure */
 
-		return (AE_AML_INVALID_RESOURCE_TYPE);
+		goto invalid_resource;
+	}
+
+	aml_resource = ACPI_CAST_PTR(union aml_resource, aml);
+	if (resource_type == ACPI_RESOURCE_NAME_SERIAL_BUS) {
+
+		/* Validate the bus_type field */
+
+		if ((aml_resource->common_serial_bus.type == 0) ||
+		    (aml_resource->common_serial_bus.type >
+		     AML_RESOURCE_MAX_SERIALBUSTYPE)) {
+			ACPI_RESOURCE_ERROR((AE_INFO,
+					     "Invalid/unsupported SerialBus resource descriptor: BusType 0x%2.2X",
+					     aml_resource->common_serial_bus.
+					     type));
+			return (AE_AML_INVALID_RESOURCE_TYPE);
+		}
 	}
 
 	/* Optionally return the resource table index */
@@ -450,6 +642,22 @@ acpi_status acpi_ut_validate_resource(void *aml, u8 * return_index)
 	}
 
 	return (AE_OK);
+
+      invalid_resource:
+
+	ACPI_RESOURCE_ERROR((AE_INFO,
+			     "Invalid/unsupported resource descriptor: Type 0x%2.2X",
+			     resource_type));
+	return (AE_AML_INVALID_RESOURCE_TYPE);
+
+      bad_resource_length:
+
+	ACPI_RESOURCE_ERROR((AE_INFO,
+			     "Invalid resource descriptor length: Type "
+			     "0x%2.2X, Length 0x%4.4X, MinLength 0x%4.4X",
+			     resource_type, resource_length,
+			     minimum_resource_length));
+	return (AE_AML_BAD_RESOURCE_LENGTH);
 }
 
 /*******************************************************************************
diff --git a/include/acpi/acrestyp.h b/include/acpi/acrestyp.h
index 0a66cc4..3506e39 100644
--- a/include/acpi/acrestyp.h
+++ b/include/acpi/acrestyp.h
@@ -61,11 +61,14 @@ typedef u32 acpi_rsdesc_size;	/* Max Resource Descriptor size is (Length+3) = (6
 #define ACPI_WRITE_COMBINING_MEMORY     (u8) 0x02
 #define ACPI_PREFETCHABLE_MEMORY        (u8) 0x03
 
+/*! [Begin] no source code translation */
 /*
  * IO Attributes
- * The ISA IO ranges are:     n000-n0_fFh, n400-n4_fFh, n800-n8_fFh, n_c00-n_cFFh.
- * The non-ISA IO ranges are: n100-n3_fFh, n500-n7_fFh, n900-n_bFFh, n_cd0-n_fFFh.
+ * The ISA IO ranges are:     n000-n0FFh,  n400-n4FFh, n800-n8FFh, nC00-nCFFh.
+ * The non-ISA IO ranges are: n100-n3FFh,  n500-n7FFh, n900-nBFFh, nCD0-nFFFh.
  */
+/*! [End] no source code translation !*/
+
 #define ACPI_NON_ISA_ONLY_RANGES        (u8) 0x01
 #define ACPI_ISA_ONLY_RANGES            (u8) 0x02
 #define ACPI_ENTIRE_RANGE               (ACPI_NON_ISA_ONLY_RANGES | ACPI_ISA_ONLY_RANGES)
@@ -81,16 +84,26 @@ typedef u32 acpi_rsdesc_size;	/* Max Resource Descriptor size is (Length+3) = (6
 #define ACPI_DECODE_16                  (u8) 0x01	/* 16-bit IO address decode */
 
 /*
- * IRQ Attributes
+ * Interrupt attributes - used in multiple descriptors
  */
+
+/* Triggering */
+
 #define ACPI_LEVEL_SENSITIVE            (u8) 0x00
 #define ACPI_EDGE_SENSITIVE             (u8) 0x01
 
+/* Polarity */
+
 #define ACPI_ACTIVE_HIGH                (u8) 0x00
 #define ACPI_ACTIVE_LOW                 (u8) 0x01
+#define ACPI_ACTIVE_BOTH                (u8) 0x02
+
+/* Sharing */
 
 #define ACPI_EXCLUSIVE                  (u8) 0x00
 #define ACPI_SHARED                     (u8) 0x01
+#define ACPI_EXCLUSIVE_AND_WAKE         (u8) 0x02
+#define ACPI_SHARED_AND_WAKE            (u8) 0x03
 
 /*
  * DMA Attributes
@@ -127,6 +140,8 @@ typedef u32 acpi_rsdesc_size;	/* Max Resource Descriptor size is (Length+3) = (6
 #define ACPI_POS_DECODE                 (u8) 0x00
 #define ACPI_SUB_DECODE                 (u8) 0x01
 
+/* Producer/Consumer */
+
 #define ACPI_PRODUCER                   (u8) 0x00
 #define ACPI_CONSUMER                   (u8) 0x01
 
@@ -192,6 +207,21 @@ struct acpi_resource_fixed_io {
 	u8 address_length;
 };
 
+struct acpi_resource_fixed_dma {
+	u16 request_lines;
+	u16 channels;
+	u8 width;
+};
+
+/* Values for Width field above */
+
+#define ACPI_DMA_WIDTH8                         0
+#define ACPI_DMA_WIDTH16                        1
+#define ACPI_DMA_WIDTH32                        2
+#define ACPI_DMA_WIDTH64                        3
+#define ACPI_DMA_WIDTH128                       4
+#define ACPI_DMA_WIDTH256                       5
+
 struct acpi_resource_vendor {
 	u16 byte_length;
 	u8 byte_data[1];
@@ -329,6 +359,166 @@ struct acpi_resource_generic_register {
 	u64 address;
 };
 
+struct acpi_resource_gpio {
+	u8 revision_id;
+	u8 connection_type;
+	u8 producer_consumer;	/* For values, see Producer/Consumer above */
+	u8 pin_config;
+	u8 sharable;		/* For values, see Interrupt Attributes above */
+	u8 io_restriction;
+	u8 triggering;		/* For values, see Interrupt Attributes above */
+	u8 polarity;		/* For values, see Interrupt Attributes above */
+	u16 drive_strength;
+	u16 debounce_timeout;
+	u16 pin_table_length;
+	u16 vendor_length;
+	struct acpi_resource_source resource_source;
+	u16 *pin_table;
+	u8 *vendor_data;
+};
+
+/* Values for GPIO connection_type field above */
+
+#define ACPI_RESOURCE_GPIO_TYPE_INT             0
+#define ACPI_RESOURCE_GPIO_TYPE_IO              1
+
+/* Values for pin_config field above */
+
+#define ACPI_PIN_CONFIG_DEFAULT                 0
+#define ACPI_PIN_CONFIG_PULLUP                  1
+#define ACPI_PIN_CONFIG_PULLDOWN                2
+#define ACPI_PIN_CONFIG_NOPULL                  3
+
+/* Values for io_restriction field above */
+
+#define ACPI_IO_RESTRICT_NONE                   0
+#define ACPI_IO_RESTRICT_INPUT                  1
+#define ACPI_IO_RESTRICT_OUTPUT                 2
+#define ACPI_IO_RESTRICT_NONE_PRESERVE          3
+
+/* Common structure for I2C, SPI, and UART serial descriptors */
+
+#define ACPI_RESOURCE_SERIAL_COMMON \
+	u8                                      revision_id; \
+	u8                                      type; \
+	u8                                      producer_consumer;   /* For values, see Producer/Consumer above */\
+	u8                                      slave_mode; \
+	u8                                      type_revision_id; \
+	u16                                     type_data_length; \
+	u16                                     vendor_length; \
+	struct acpi_resource_source             resource_source; \
+	u8                                      *vendor_data;
+
+struct acpi_resource_common_serialbus {
+ACPI_RESOURCE_SERIAL_COMMON};
+
+/* Values for the Type field above */
+
+#define ACPI_RESOURCE_SERIAL_TYPE_I2C           1
+#define ACPI_RESOURCE_SERIAL_TYPE_SPI           2
+#define ACPI_RESOURCE_SERIAL_TYPE_UART          3
+
+/* Values for slave_mode field above */
+
+#define ACPI_CONTROLLER_INITIATED               0
+#define ACPI_DEVICE_INITIATED                   1
+
+struct acpi_resource_i2c_serialbus {
+	ACPI_RESOURCE_SERIAL_COMMON u8 access_mode;
+	u16 slave_address;
+	u32 connection_speed;
+};
+
+/* Values for access_mode field above */
+
+#define ACPI_I2C_7BIT_MODE                      0
+#define ACPI_I2C_10BIT_MODE                     1
+
+struct acpi_resource_spi_serialbus {
+	ACPI_RESOURCE_SERIAL_COMMON u8 wire_mode;
+	u8 device_polarity;
+	u8 data_bit_length;
+	u8 clock_phase;
+	u8 clock_polarity;
+	u16 device_selection;
+	u32 connection_speed;
+};
+
+/* Values for wire_mode field above */
+
+#define ACPI_SPI_4WIRE_MODE                     0
+#define ACPI_SPI_3WIRE_MODE                     1
+
+/* Values for device_polarity field above */
+
+#define ACPI_SPI_ACTIVE_LOW                     0
+#define ACPI_SPI_ACTIVE_HIGH                    1
+
+/* Values for clock_phase field above */
+
+#define ACPI_SPI_FIRST_PHASE                    0
+#define ACPI_SPI_SECOND_PHASE                   1
+
+/* Values for clock_polarity field above */
+
+#define ACPI_SPI_START_LOW                      0
+#define ACPI_SPI_START_HIGH                     1
+
+struct acpi_resource_uart_serialbus {
+	ACPI_RESOURCE_SERIAL_COMMON u8 endian;
+	u8 data_bits;
+	u8 stop_bits;
+	u8 flow_control;
+	u8 parity;
+	u8 lines_enabled;
+	u16 rx_fifo_size;
+	u16 tx_fifo_size;
+	u32 default_baud_rate;
+};
+
+/* Values for Endian field above */
+
+#define ACPI_UART_LITTLE_ENDIAN                 0
+#define ACPI_UART_BIG_ENDIAN                    1
+
+/* Values for data_bits field above */
+
+#define ACPI_UART_5_DATA_BITS                   0
+#define ACPI_UART_6_DATA_BITS                   1
+#define ACPI_UART_7_DATA_BITS                   2
+#define ACPI_UART_8_DATA_BITS                   3
+#define ACPI_UART_9_DATA_BITS                   4
+
+/* Values for stop_bits field above */
+
+#define ACPI_UART_NO_STOP_BITS                  0
+#define ACPI_UART_1_STOP_BIT                    1
+#define ACPI_UART_1P5_STOP_BITS                 2
+#define ACPI_UART_2_STOP_BITS                   3
+
+/* Values for flow_control field above */
+
+#define ACPI_UART_FLOW_CONTROL_NONE             0
+#define ACPI_UART_FLOW_CONTROL_HW               1
+#define ACPI_UART_FLOW_CONTROL_XON_XOFF         2
+
+/* Values for Parity field above */
+
+#define ACPI_UART_PARITY_NONE                   0
+#define ACPI_UART_PARITY_EVEN                   1
+#define ACPI_UART_PARITY_ODD                    2
+#define ACPI_UART_PARITY_MARK                   3
+#define ACPI_UART_PARITY_SPACE                  4
+
+/* Values for lines_enabled bitfield above */
+
+#define ACPI_UART_CARRIER_DETECT                (1<<2)
+#define ACPI_UART_RING_INDICATOR                (1<<3)
+#define ACPI_UART_DATA_SET_READY                (1<<4)
+#define ACPI_UART_DATA_TERMINAL_READY           (1<<5)
+#define ACPI_UART_CLEAR_TO_SEND                 (1<<6)
+#define ACPI_UART_REQUEST_TO_SEND               (1<<7)
+
 /* ACPI_RESOURCE_TYPEs */
 
 #define ACPI_RESOURCE_TYPE_IRQ                  0
@@ -348,7 +538,10 @@ struct acpi_resource_generic_register {
 #define ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64   14	/* ACPI 3.0 */
 #define ACPI_RESOURCE_TYPE_EXTENDED_IRQ         15
 #define ACPI_RESOURCE_TYPE_GENERIC_REGISTER     16
-#define ACPI_RESOURCE_TYPE_MAX                  16
+#define ACPI_RESOURCE_TYPE_GPIO                 17	/* ACPI 5.0 */
+#define ACPI_RESOURCE_TYPE_FIXED_DMA            18	/* ACPI 5.0 */
+#define ACPI_RESOURCE_TYPE_SERIAL_BUS           19	/* ACPI 5.0 */
+#define ACPI_RESOURCE_TYPE_MAX                  19
 
 /* Master union for resource descriptors */
 
@@ -358,6 +551,7 @@ union acpi_resource_data {
 	struct acpi_resource_start_dependent start_dpf;
 	struct acpi_resource_io io;
 	struct acpi_resource_fixed_io fixed_io;
+	struct acpi_resource_fixed_dma fixed_dma;
 	struct acpi_resource_vendor vendor;
 	struct acpi_resource_vendor_typed vendor_typed;
 	struct acpi_resource_end_tag end_tag;
@@ -370,6 +564,11 @@ union acpi_resource_data {
 	struct acpi_resource_extended_address64 ext_address64;
 	struct acpi_resource_extended_irq extended_irq;
 	struct acpi_resource_generic_register generic_reg;
+	struct acpi_resource_gpio gpio;
+	struct acpi_resource_i2c_serialbus i2c_serial_bus;
+	struct acpi_resource_spi_serialbus spi_serial_bus;
+	struct acpi_resource_uart_serialbus uart_serial_bus;
+	struct acpi_resource_common_serialbus common_serial_bus;
 
 	/* Common fields */
 
-- 
1.7.9.rc1

