Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2EGCaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 22:30:05 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:40452 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2EGC36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 22:29:58 -0400
From: Tom Lin <tom_lin@emc.com.tw>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        Tom Lin <tom_lin@emc.com.tw>, Aarom Huang <aaron_huang@emc.com.tw>
Subject: [PATCH 2/2] Input: Elan I2C Touch Pad Programming Guide
Date: Mon,  7 May 2012 10:29:34 +0800
Message-Id: <1336357774-3255-2-git-send-email-tom_lin@emc.com.tw>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1336357774-3255-1-git-send-email-tom_lin@emc.com.tw>
References: <1336357774-3255-1-git-send-email-tom_lin@emc.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Elan I2C touchpad is compatible with Microsoft HID over I2C protocol.
The purpose of this programming guide is to explain hot initial and get report
form Elan touchpad via I2C interface.

Cc: Aarom Huang <aaron_huang@emc.com.tw>
Signed-off-by: Tom Lin(Lin Yen Yu) <tom_lin@emc.com.tw>
---
 Documentation/input/elantech_i2c.txt |  760 ++++++++++++++++++++++++++++++++++
 1 file changed, 760 insertions(+)
 create mode 100644 Documentation/input/elantech_i2c.txt

diff --git a/Documentation/input/elantech_i2c.txt b/Documentation/input/elantech_i2c.txt
new file mode 100644
index 0000000..3578b24
--- /dev/null
+++ b/Documentation/input/elantech_i2c.txt
@@ -0,0 +1,760 @@
+Elan I2C Touchpad Programming Guide
+===================================
+	Copyright (c) 2012 Elan Microelectronics corp.
+
+Contents
+~~~~~~~~
+
+1. Introduction
+   1.1 Feature
+2. Descriptors of Touchpad
+   2.1 HID Descriptor
+   2.2 Report Descriptor
+3. Description fo Command
+   3.1 List of Commands
+   3.2 HID Descriptor Retrieval
+   3.3 Report Descriptor Retrieval
+   3.4 Reading an Input Report
+   3.5 Command Register
+       3.5.1 Enable/Disable Touchpad
+       3.5.2 Reset
+   3.6 Basic Information of Touchpad
+   3.7 TP Driver Control Register
+4. Data Packet of Touchpad
+   4.1 Standard Mouse Mode
+   4.2 Absolute Mode
+
+
+
+/////////////////////////////////////////////////////////////////////////////
+1. Introduction
+   ~~~~~~~~~~~~
+
+The Elan I2C touchpad is compatible with Microsoft HID over I2C protocol
+version 0.91. The touchpad provides the standard mouse mode and the absolute
+mode. The touchpad can report maximun five finger positions, when it works in
+absolute mode.
+
+The purpose of this programming guide is to explain how to initial and get
+report from Touch-Pad via I2C interface. About the detail of HID over I2c
+protocal, please refer to "Microsoft HID over I2C Protocol Specification"
+
+1.1 Feature
+    ~~~~~~~
+* The Elan I2C touchpad is compatible with Microsoft HID over I2C protocol
+  version 0.91.
+* Support standard mouse mode and absolute mode.
+* Support maximun five positions of finger in absolute mode.
+* I2C slave device address (7 bits):0x15
+* I2C bus speed:400 kbit/sec
+
+
+
+/////////////////////////////////////////////////////////////////////////////
+2. Descriptors of Touchpad
+   ~~~~~~~~~~~~~~~~~~~~~~~
+
+The following section shows the HID and report descriptor of Elan I2C
+touchapad.
+
+* 2.1 HID Descriptor
+      ~~~~~~~~~~~~~~
+The HID Descriptor for Elan I2C Touchpad is described below.
+-------------------------------------------------------------------------------
+| Byte   | Field                | Value | Notes                               |
+-------------------------------------------------------------------------------
+| Offset |                      | (HEX) |                                     |
+-------------------------------------------------------------------------------
+| 0      | wHIDDescLength       | 001e  | Length of HID Descirptor. Fixed to  |
+|        |                      |       | 30 bytes(0x001e).                   |
+-------------------------------------------------------------------------------
+| 2      | bcdVersion           | 0100  | Compliant with version 1.00.        |
+-------------------------------------------------------------------------------
+| 4      | wReportDescLength    | 004f  | Report Descriptor is 79 Bytes       |
+|        |                      |       | (0x004f).                           |
+-------------------------------------------------------------------------------
+| 6      | wReportDescRegister  | 0002  | Identifier to read Report           |
+|        |                      |       | Descriptor.                         |
+-------------------------------------------------------------------------------
+| 8      | wInputRegister       | 0003  | Identifier to read Input Report     |
+-------------------------------------------------------------------------------
+| 10     | wMaxInputLength      | 0006  | Input Report is 4 Bytes + 2 Bytes   |
+|        |                      |       | length field.                       |
+-------------------------------------------------------------------------------
+| 12     | wOutputRegister      | 0004  | Identifier to read Output Report.   |
+-------------------------------------------------------------------------------
+| 14     | wMaxOutputLength     | 0000  | No Output Report.                   |
+-------------------------------------------------------------------------------
+| 16     | wCommandRegister     | 0005  | Identifier for Command Register.    |
+-------------------------------------------------------------------------------
+| 18     | wDataRegister        | 0006  | Identifier for Data Register.       |
+-------------------------------------------------------------------------------
+| 20     | wVendorID            | 1267  | Vendor ID 0x1267                    |
+-------------------------------------------------------------------------------
+| 22     | wProductID           | 0001  | Product ID 0001                     |
+-------------------------------------------------------------------------------
+| 24     | wVersionID           | 0000  | Version 0000                        |
+-------------------------------------------------------------------------------
+| 26     | RESERVED             | 00 00 | Reserved                            |
+|        |                      | 00 00 |                                     |
+-------------------------------------------------------------------------------
+
+
+* 2.2 Report Descriptr
+      ~~~~~~~~~~~~~~~~
+
+The Report Descriptor defines the HID reports of Elan I2C touchpad. The Report
+Descirptor includes standard 3 bytes mosue report, Vendor Usage, and Elan
+touchpad absolute mode report. The Report Descriptor for the Elan I2C Touchpad
+is described below.
+===============================================================================
+;Describe Standard 3 Byte Report Include Report ID, Vendor Usage, and ABS
+report descriptor
+
+0x05,0x01	; Usage Page(Generic Desktop),
+0x09,0x02	; Usage (Mouse),
+0xa1,0x01	; Collection (Application),
+0x85,0x01	; Report ID,
+0x09,0x01	; Usage (Pointer),
+0xa1,0x00	; Collection (Physical),
+0x05,0x09	; Usage Page(Buttons),
+0x19,0x01	; Usage Minimum (01),
+0x29,0x02	; Usage Maximum (02),
+0x15,0x00	; Logical Minimum (0),
+0x25,0x01	; Logical Maximum (1),
+0x75,0x01	; Report Size (1),
+0x95,0x02	; Report Count (2),
+0x81,0x02	; Input (Data, Variable, Absolute), ;2 button bits
+0x95,0x06	; Report Count(6),
+0x81,0x03	; Input(Cnst,Var,Abs),; 6 bit padding
+0x05,0x01	; Usage Page(Generic Desktop),
+0x09,0x30	; Usage (X),
+0x09,0x31	; Usage (Y),
+0x15,0x81	; Logical Minimum (-127),
+0x25,0x7f	; Logical Maximum (127),
+0x75,0x08	; Report Size (8),
+0x95,0x02	; Report Count (2),
+0x81,0x06	; Input(Data, Variable, Relative), ;2 position bytes (X&Y)
+0xc0		; End Collection
+0x06,0x00,0xff	; Usage_PAGE (Vendor Defined)
+0x85,0x0f	; REPORT_ID (Feature)
+0x09,0xc5	; USAGE (Vendor Usage 0xc5)
+0x15,0x00	; LOGICAL_MINIMUM (0)
+0x26,0xff,0x00	; LOGICAL_MAXIMUM (255)
+0x75,0x08	; REPORT_SIZE (8)
+0x96,0x00,0x01	; REPORT_COUNT (256)
+0xb1,0x02	; FEATURE (Data, Var, Abs)
+0x85,0x5d	; REPORT_ID (ABS)
+0x09,0x01	; USAGE (eKTF2000 Click-Pad)
+0x95,0x28	; REPORT_COUNT(28)
+0x75,0x08	; REPORT_SIZE (8)
+0x81,0x01	; INPUT (Constant, Array ,Absolute)
+0xc0		; End Collection
+===============================================================================
+
+
+
+/////////////////////////////////////////////////////////////////////////////
+3. Description of Command
+   ~~~~~~~~~~~~~~~~~~~~~~
+
+3.1 List of Commands
+    ~~~~~~~~~~~~~~~~
+-------------------------------------------------------------------------------
+| Register | Register Definition     | R/W   | Data | Note                    |
+| Address  |                         |       | Byte |                         |
+-------------------------------------------------------------------------------
+| 0x0001   | HID descriptor          | Read  | 30   |                         |
+-------------------------------------------------------------------------------
+| 0x0002   | Report descriptor       | Read  | 79   |                         |
+-------------------------------------------------------------------------------
+| 0x0003   | Input report            | Read  |      |                         |
+-------------------------------------------------------------------------------
+| 0x0004   | Output report           | Write |      | currently unsupported   |
+-------------------------------------------------------------------------------
+| 0x0005   | Command register        | Write |      |                         |
+-------------------------------------------------------------------------------
+| 0x0006   | Data register           | Read  |      | currently unsupported   |
+|          |                         | Write |      |                         |
+-------------------------------------------------------------------------------
+| Elan Extension Register                                                     |
+-------------------------------------------------------------------------------
+| 0x0100   | Version of HID over I2C | Read  | 2    |                         |
+|          | Protocol.               |       |      |                         |
+-----------------------------------------------------                         |
+| 0x0101   | Module Unique ID.       | Read  | 2    |                         |
+-----------------------------------------------------                         |
+| 0x0105   | Trace number of X and Y | Read  | 2    | Basic information of    |
+|          | axis                    |       |      | touchpad.               |
+-----------------------------------------------------                         |
+| 0x0106   | X axis maximum position | Read  | 2    |                         |
+-----------------------------------------------------                         |
+| 0x0107   | Y axis maximum position | Read  | 2    |                         |
+-----------------------------------------------------                         |
+| 0x0108   | DPI value of X and Y    | Read  | 2    |                         |
+|          | axis                    |       |      |                         |
+------------------------------------------------------------------------------|
+| 0x0300   | TP Driver Control Reg   | Read  | 2    | TP driver control       |
+|          |                         | Write |      | register                |
+-------------------------------------------------------------------------------
+
+
+3.2 HID Descriptor Retrieval (Register: 0x0001)
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The HID Descriptor is stored on the touchpad firmware where it can be retrieved
+on touchpad initialization. During touchpad initialization, the Host must
+retrieve the HID Descriptor. To retrieve the HID Descriptor, the Host must read
+the HID Descriptor Register.
+
+The following is an illustration of the protocol between the Host and touchpad
+to retrieve the HID Descriptor.
+
+S Addr Wr [A] DataLow(HID Desc Addr) [A] DataHigh(HID Desc Addr) [A] Sr Addr Rd
+                          [A] [DataLow(HID Desc)] A...[DataHigh(HID Desc)] NA P
+Key to symbols
+==============
+
+S     (1 bit) : Start bit
+P     (1 bit) : Stop bit
+Sr    (1 bit) : Repeated Start bit
+Rd/Wr (1 bit) : Read/Write bit. Rd equals 1, Wr equals 0.
+A, NA (1 bit) : Accept and reverse accept bit.
+Addr  (7 bits): I2C 7 bit address. Note that this can be expanded as usual to
+                get a 10 bit I2C address.
+Comm  (8 bits): Command byte, a data byte which often selects a register on
+                the device.
+Data  (8 bits): A plain data byte. Sometimes, I write DataLow, DataHigh
+                for 16 bit data.
+Count (8 bits): A data byte containing the length of a block operation.
+
+[..]: Data sent by I2C device, as opposed to data sent by the host adapter.
+
+
+3.3 Report Descriptor Retrieval (Register:0x0002)
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+A single Report Descriptor is stored on the the touchpad firmware. During
+touchpad initialization, the Host gets the location and length of the report
+descriptor from wReportDescRegister and wReportDescLength in the HID Descriptor
+. To retrieve the Report Descriptor from the touchpad, the Host will read the
+register identified in wReportDescRegister for a length of wReportDescLength.
+
+The following is an illustration of the protocol between the Host and the
+touchpad to retrieve the Report Descriptor.
+
+S Addr Wr [A] DataLow(Report Desc Reg) [A] DataHigh(Report Desc Reg) [A] Sr
+         Addr Rd [A] [DataLow(Report Desc)] A .... [DataHigh(Report Desc)] NA P
+
+
+3.4 Reading an Input Report (Register:0x0003)
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The Host can get touchpad reprot via read an input report. The following
+sequence of operations explains the process of retrieval of the Input Report.
+
+-------------------------------------------------------------------------------
+| Sequence  | Host Side                  | Device Side                        |
+-------------------------------------------------------------------------------
+| Step 1    |                            | Device asserts the interrupt       |
+|           |                            | indicating that it has a input     |
+|           |                            | Report to send to Host             |
+-------------------------------------------------------------------------------
+| Step 2    | Host issues a READ repuest |                                    |
+|           | I2C protocol, after it     |                                    |
+|           | receives the interrupt.    |                                    |
+-------------------------------------------------------------------------------
+| Step 3    |                            | Device returns the length (2 bytes)|
+|           |                            | and the entire Input Report.       |
+-------------------------------------------------------------------------------
+| Step 4    |                            | If the Device has no more Input    |
+|           |                            | Reports to send, it de-asserts the |
+|           |                            | interrupt line.                    |
+-------------------------------------------------------------------------------
+
+The following is an illustration of the protocol between the Host and touchpad
+to read an input reprot.
+      S Addr Rd [A] [DataLow(Length Field)] A [DataHigh(Length Field)] A
+                  [DataLow(Report Filed)] A ... [DataHigh(Report Field)] NA P
+-----                                                                       ----
+/INT|_____________________..........._______________________________________|
+
+
+
+
+3.5 Command Register (Register:0x0005)
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The command register contains a 2 Byte value that will identify the command
+that is being sent by the Host to touchpad. The table below identifies the
+commands be supported by touchpad currently.
+
+----------------------------------------
+| Command | Description                |
+----------------------------------------
+| 0x0800  | Wake Up (Enable touchpad)  |
+----------------------------------------
+| 0x0801  | Sleep (Disable touchpad)   |
+----------------------------------------
+| 0x0100  | Reset                      |
+----------------------------------------
+
+
+3.5.1 Enable/Disable Touchpad
+      ~~~~~~~~~~~~~~~~~~~~~~~
+
+The Host can issue the SET_POWER command to enable or disable touchpad.
+
+The following is an illustration of the protocol between the Host and the
+Device for SET_POWER (Enable/Disable Touchpad).
+
+S Addr Wr [A] DataLow(Command Register) [A] DataHigh(Command Register) [A]
+                                   DataLow(Command) [A] DataHigh(Command) [A] P
+
+
+3.5.2 Rest
+      ~~~~
+
+The following section identifies 2 forms of RESETs:
+
+* Host Initiated Reset(HIR).
+----------------------------
+A Host shall initally issue a reset to the device at startup to initialize the
+device. After the Host sends the REST command to the Command Register, the
+touchpad will REST itself back to the initialized state. At then end of the
+reset, the touchpad will also write 2 Byte value to the Input Register with
+the sentinel value of 0x0000 (2 Bytes containing 0) and assert the interrupt
+to indicate that touchpad has been initiailied.
+
+The following is an illustration of the protocol between the HOST and the
+touchpad to issue an HIR.
+
+S Addr Wr [A] DataLow(Command Reg) [A] DataHigh(Command Reg) [A]
+		DataLow(Command) [A] DataHigh(Command) [A] P
+
+
+       S Addr Rd [A] [DataLow(Length Field)] A [DataHigh(Lenght Field)] NA P
+------                                                                     ---
+/INT |_____________________________________________________________________|
+
+
+* Device initiated Reset(DIR).
+-----------------------------
+There may be operations where the touchpad needs to reset itself without a
+a request from the Host. Some examples of the conditions that may trigger this
+are listed below:
+  * Touchpad initials itself completely after power on
+  * Electro static discharge
+  * Fault tolerance
+
+The Elan I2C touchpad will inform the Host after a DIR that the touchpad
+performed a reset and that it is operational again. The mechanism for informing
+the Host of a DIR is the same as that for a HIR. When the touchpad reinitializes
+itself completely, it will update the input register data with 0x0000 and then
+asserts the interrupt.
+
+
+
+3.6. Basic Information of Touchpad
+     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The following section explains the command set for reading the basic
+information of touchpad. The Host can issue the Elan extension read command to
+retrieve the firmware information of touchpad via I2C interface.
+
+The following is an illustration of the protocol between the Host and Device
+for Elan extension read command.
+
+S Addr Wr [A] DataLow(Elan Ext Reg) [A] DataHigh(Elan Ext Reg [A] Sr Addr Rd [A]
+                             [DataLow(Data Field)] A [DataHigh(Data Field)] NA P
+
+The table below identifies the content of Elan touchpad touchpad basic
+information.
+-------------------------------------------------------------------------------
+| Register | Content        | Descriprions             | Note                 |
+-------------------------------------------------------------------------------
+| Address  |                |                          |                      |
+===============================================================================
+| 0x0100   |                | Vesrion of HID over I2C  | Version 0.91         |
+|          |                | Protocol.                |                      |
+-------------------------------------------------------------------------------
+|          | Low Byte       | 0x91                     |                      |
+|          --------------------------------------------------------------------
+|          | High Byte      | 0x00                     |                      |
+===============================================================================
+| 0x0101   |                | Module Unique ID         | For Driver and       |
+|          |                |                          | Customer.            |
+-------------------------------------------------------------------------------
+|          | Low Byte       | Module Unique ID         |                      |
+|          --------------------------------------------------------------------
+|          | High Byte      | Reserved                 |                      |
+===============================================================================
+| 0x0105   |                | Trace number of X and Y  |                      |
+|          |                | axis.                    |                      |
+-------------------------------------------------------------------------------
+|          | Low Byte       | Trace number of X        |                      |
+|          --------------------------------------------------------------------
+|          | High Byte      | Trace number of Y        |                      |
+===============================================================================
+| 0x0106   |                | X axis maximun position  |                      |
+-------------------------------------------------------------------------------
+|          | Low Byte       | X Abs Max Position [7:0] |                      |
+|          --------------------------------------------------------------------
+|          | High Byte      | X Abs Max Position [11:8]|                      |
+===============================================================================
+| 0x0107   |                | Y axis maximun position  |                      |
+-------------------------------------------------------------------------------
+|          | Low Byte       | Y Abs Max Position [7:0] |                      |
+|          --------------------------------------------------------------------
+|          | High Byte      | Y Abs Max Position [11:8]|                      |
+===============================================================================
+| 0x0108   |                | DPI value of X and Y     |                      |
+|          |                | axis.                    |                      |
+-------------------------------------------------------------------------------
+|          |                |                          | 0x01 : 800 DPI       |
+|          |                |                          | 0x02 : 810 DPI       |
+|          |                |                          | 0x03 : 820 DPI       |
+|          |                |                          | 0x04 : 830 DPI       |
+|          |                |                          | 0x05 : 840 DPI       |
+|          | Low Byte       | DPI value of X           | 0x06 : 850 DPI       |
+|          |                |                          | 0x07 : 860 DPI       |
+|          |                |                          | 0x08 : 870 DPI       |
+|          |                |                          | 0x09 : 880 DPI       |
+|          |                |                          | 0x0A : 890 DPI       |
+|          |                |                          | Other: Reserved      |
+|          --------------------------------------------------------------------
+|          |                |                          | 0x01 : 800 DPI       |
+|          |                |                          | 0x02 : 810 DPI       |
+|          |                |                          | 0x03 : 820 DPI       |
+|          |                |                          | 0x04 : 830 DPI       |
+|          |                |                          | 0x05 : 840 DPI       |
+|          | High Byte      | DPI value of Y           | 0x06 : 850 DPI       |
+|          |                |                          | 0x07 : 860 DPI       |
+|          |                |                          | 0x08 : 870 DPI       |
+|          |                |                          | 0x09 : 880 DPI       |
+|          |                |                          | 0x0A : 890 DPI       |
+|          |                |                          | Other: Reserved      |
+===============================================================================
+
+
+
+3.7 TP Driver Control Register
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The Host can switch the working mode of the touchpad to standard mode or
+absolute mode via writes command to TP Driver Copyright Report. The list below
+identifies the definition of TP Driver Control Register.
+* Standard 3 bytes mouse mode: 0x0000
+* ELAN absolute mode: 0x0001
+
+The following is an illustration of the protocol between the Host and the Device
+for Elan extension write command.
+
+S Addr Wr [A] DataLow(Elan Ext Reg) [A] DataHigh(Elan Ext Reg) [A] DataLow
+                                          (Command) [A] DataHigh(Command) [A] P
+
+
+
+
+/////////////////////////////////////////////////////////////////////////////
+4. Data Packet of Touhpad
+   ~~~~~~~~~~~~~~~~~~~~~~
+
+There are two modes provided by touchpad: standard mouse mode and absolute
+mode. The Host can get touchpad data packet via read an input report. Every
+input report starts with a length field (2 bytes), followed by report ID (1
+byte), and finally followed by the report of touch pad.
+
+-----------------------------------------------------------------
+|       Length        | Report ID |          Report             |
+| (2 Unsigned Bytes)  |  (1 Byte) |    (3 or 28 Bytes)          |
+-----------------------------------------------------------------
+
+The value stored in the "Length" field is calculated as follows:
+  Value in Length field = 2 Bytes (#Bytes for the "Length field") + 1 Byte
+  (#Byte for the "Report ID" field) + n Bytes (#Bytes for the "Report" field).
+
+The following section explains the data packet of touchpad.
+
+
+
+4.1 Standard Mouse Mode
+    ~~~~~~~~~~~~~~~~~~~
+
+The description of data packet is showed as follow:
+--------------------------------------------------------------------
+|                         Report ID : 0x01                         |
+--------------------------------------------------------------------
+| Byte\Bit | Bit7 | Bit6 | Bit5 | Bit4 | Bit3 | Bit2 | Bit1 | Bit0 |
+--------------------------------------------------------------------
+| Byte 1   |  0   |  0   |  0   |  0   |  0   |  0   |  0   |  1   |
+--------------------------------------------------------------------
+| Byte 2   |  0   |  0   |  0   |  0   |  0   |  0   |  RB  |  LB  |
+--------------------------------------------------------------------
+| Byte 3   |                    X Data (X Bits 7 ~ 0)              |
+--------------------------------------------------------------------
+| Byte 4   |                    Y Data (Y Bits 7 ~ 0)              |
+--------------------------------------------------------------------
+
+--------------------------------------------------------------------
+|                        Description                               |
+--------------------------------------------------------------------
+| Byte 1   | Reprot  ID = 0x01                                     |
+--------------------------------------------------------------------
+| LB       | Left button status, 1 = button pressed                |
+--------------------------------------------------------------------
+| RB       | Right button status, 1 = button pressed               |
+--------------------------------------------------------------------
+| X Data   | X direction data:X7 = MSB                             |
+--------------------------------------------------------------------
+| Y Data   | Y direction data:Y7 = MSB                             |
+--------------------------------------------------------------------
+
+
+4.2 Absolute Mode
+    ~~~~~~~~~~~~~
+
+The description of data packet is showed as follow:
+--------------------------------------------------------------------
+|                         Report ID : 0x5d                         |
+--------------------------------------------------------------------
+| Byte\Bit | Bit7 | Bit6 | Bit5 | Bit4 | Bit3 | Bit2 | Bit1 | Bit0 |
+====================================================================
+| Byte 1   |  0   |  1   |  0   |  1   |  1   |  1   |  0   |  1   |
+--------------------------------------------------------------------
+| Byte 2   | FT5  | FT4  | FT3  | FT2  | FT1  |  MB  |  RB  |  LB  |
+====================================================================
+| Byte 3   | X1 ABS Position High (X1  | Y1 ABS Position High (Y1  |
+|          | Bits 11 ~ 8)              | Bits 11 ~ 8)              |
+--------------------------------------------------------------------
+| Byte 4   | X1 ABS Pointer Low (X1 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 5   | Y1 ABS Pointer Low (Y1 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 6   | FT1 MKY Value (Bits 3 ~ 0)| FT1 MKX Value (Bits 3 ~ 0)|
+--------------------------------------------------------------------
+| Byte 7   | FT1 H Value (Bits 7 ~ 0)                              |
+====================================================================
+| Byte 8   | X2 ABS Position High (X2  | Y2 ABS Position High (Y2  |
+|          | Bits 11 ~ 8)              | Bits 11 ~ 8)              |
+--------------------------------------------------------------------
+| Byte 9   | X2 ABS Pointer Low (X2 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 10  | Y2 ABS Pointer Low (Y2 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 11  | FT2 MKY Value (Bits 3 ~ 0)| FT2 MKX Value (Bits 3 ~ 0)|
+--------------------------------------------------------------------
+| Byte 12  | FT2 H Value (Bits 7 ~ 0)                              |
+====================================================================
+| Byte 13  | X3 ABS Position High (X3  | Y3 ABS Position High (Y3  |
+|          | Bits 11 ~ 8)              | Bits 11 ~ 8)              |
+--------------------------------------------------------------------
+| Byte 14  | X3 ABS Pointer Low (X3 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 15  | Y3 ABS Pointer Low (Y3 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 16  | FT3 MKY Value (Bits 3 ~ 0)| FT3 MKX Value (Bits 3 ~ 0)|
+--------------------------------------------------------------------
+| Byte 17  | FT3 H Value (Bits 7 ~ 0)                              |
+====================================================================
+| Byte 18  | X4 ABS Position High (X4  | Y4 ABS Position High (Y4  |
+|          | Bits 11 ~ 8)              | Bits 11 ~ 8)              |
+--------------------------------------------------------------------
+| Byte 19  | X4 ABS Pointer Low (X4 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 20  | Y4 ABS Pointer Low (Y4 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 21  | FT4 MKY Value (Bits 3 ~ 0)| FT4 MKX Value (Bits 3 ~ 0)|
+--------------------------------------------------------------------
+| Byte 22  | FT4 H Value (Bits 7 ~ 0)                              |
+====================================================================
+| Byte 23  | X5 ABS Position High (X5  | Y5 ABS Position High (Y5  |
+|          | Bits 11 ~ 8)              | Bits 11 ~ 8)              |
+--------------------------------------------------------------------
+| Byte 24  | X5 ABS Pointer Low (X5 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 25  | Y5 ABS Pointer Low (Y5 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 26  | FT5 MKY Value (Bits 3 ~ 0)| FT5 MKX Value (Bits 3 ~ 0)|
+--------------------------------------------------------------------
+| Byte 27  | FT5 H Value (Bits 7 ~ 0)                              |
+====================================================================
+| Byte 28  | Reserved                                              |
+--------------------------------------------------------------------
+
+--------------------------------------------------------------------
+|                        Description                               |
+--------------------------------------------------------------------
+| Byte 1        | Report ID = 0x5d                                 |
+--------------------------------------------------------------------
+| FTn           | Finger touch status,ex:                          |
+| (FT5 ~ FT1)   | 5'b00000 = no finger touch                       |
+|               | 5'b00001 = ID 1 finger touch                     |
+|               | 5'b00101 = ID 1 and 3 finger touch               |
+--------------------------------------------------------------------
+| LB            | Left button status, 1 = button pressed           |
+--------------------------------------------------------------------
+| RB            | Right button status, 1 = button pressed          |
+--------------------------------------------------------------------
+| MB            | Middle button status, 1 = button pressed         |
+--------------------------------------------------------------------
+| Xn (X5 ~ X1)  | FTn finger absolute data in X-axis, Xn Bits 11 ~ |
+| ABS Position  | 0.                                               |
+--------------------------------------------------------------------
+| Yn (Y5 ~ Y1)  | FTn finger absolute data in Y-axis, Yn Bits 11 ~ |
+| ABS Position  | 0.                                               |
+--------------------------------------------------------------------
+| FTn MKX Value | FTn finger width value in X-axis                 |
+--------------------------------------------------------------------
+| FTn MKY Value | FTn finger width value in Y-axis                 |
+--------------------------------------------------------------------
+| FTn H Value   | FTn finger pressure value,                       |
+--------------------------------------------------------------------
+| Byte 28       | Reserved for CRC-8 error check, currently        |
+|               | unsupported. The default value of this field is  |
+|               | 0x00.                                            |
+--------------------------------------------------------------------
+
+
+
+Finger Touchpad & Button Status Change
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The touchpad provides dynamic report formant. When finger touch the touchpad,
+the five information will list in the packet. If multi fingers touch the
+touchpad, touchpad will sort the finger information by FT1 ~ FT5.
+
+For example, when finger ID1, finger ID3 and finger ID5 touch the touchpad, and
+left button pressed at the same time, the packet will be sent cyclically. The
+report packet is showed as follow:
+
+
+--------------------------------------------------------------------
+|                         Report ID : 0x5d                         |
+--------------------------------------------------------------------
+| Byte\Bit | Bit7 | Bit6 | Bit5 | Bit4 | Bit3 | Bit2 | Bit1 | Bit0 |
+====================================================================
+| Byte 1   |  0   |  1   |  0   |  1   |  1   |  1   |  0   |  1   |
+--------------------------------------------------------------------
+| Byte 2   | FT5  |  0   | FT3  |  0   | FT1  |  0   |  0   |  LB  |
+====================================================================
+| Byte 3   | X1 ABS Position High (X1  | Y1 ABS Position High (Y1  |
+|          | Bits 11 ~ 8)              | Bits 11 ~ 8)              |
+--------------------------------------------------------------------
+| Byte 4   | X1 ABS Pointer Low (X1 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 5   | Y1 ABS Pointer Low (Y1 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 6   | FT1 MKY Value (Bits 3 ~ 0)| FT1 MKX Value (Bits 3 ~ 0)|
+--------------------------------------------------------------------
+| Byte 7   | FT1 H Value (Bits 7 ~ 0)                              |
+====================================================================
+| Byte 8   | X3 ABS Position High (X3  | Y3 ABS Position High (Y3  |
+|          | Bits 11 ~ 8)              | Bits 11 ~ 8)              |
+--------------------------------------------------------------------
+| Byte 9   | X3 ABS Pointer Low (X3 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 10  | Y3 ABS Pointer Low (Y3 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 11  | FT3 MKY Value (Bits 3 ~ 0)| FT3 MKX Value (Bits 3 ~ 0)|
+--------------------------------------------------------------------
+| Byte 12  | FT3 H Value (Bits 7 ~ 0)                              |
+====================================================================
+| Byte 13  | X5 ABS Position High (X5  | Y5 ABS Position High (Y5  |
+|          | Bits 11 ~ 8)              | Bits 11 ~ 8)              |
+--------------------------------------------------------------------
+| Byte 14  | X5 ABS Pointer Low (X3 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 15  | Y5 ABS Pointer Low (Y3 Bits 7 ~ 0)                    |
+--------------------------------------------------------------------
+| Byte 16  | FT5 MKY Value (Bits 3 ~ 0)| FT5 MKX Value (Bits 3 ~ 0)|
+--------------------------------------------------------------------
+| Byte 17  | FT5 H Value (Bits 7 ~ 0)                              |
+====================================================================
+| Byte 18  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 19  |                           0                           |
+--------------------------------------------------------------------
+| Byte 20  |                           0                           |
+--------------------------------------------------------------------
+| Byte 21  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 22  |                           0                           |
+====================================================================
+| Byte 23  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 24  |                           0                           |
+--------------------------------------------------------------------
+| Byte 25  |                           0                           |
+--------------------------------------------------------------------
+| Byte 26  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 27  |                           0                           |
+====================================================================
+| Byte 28  |                           0                           |
+--------------------------------------------------------------------
+
+
+After all finger left the touchpad and button released, it will send the last
+packet to inform the host. The packet list as follow:
+--------------------------------------------------------------------
+|                         Report ID : 0x5d                         |
+--------------------------------------------------------------------
+| Byte\Bit | Bit7 | Bit6 | Bit5 | Bit4 | Bit3 | Bit2 | Bit1 | Bit0 |
+====================================================================
+| Byte 1   |  0   |  1   |  0   |  1   |  1   |  1   |  0   |  1   |
+--------------------------------------------------------------------
+| Byte 2   |  0   |  0   |  0   |  0   |  0   |  0   |  0   |  0   |
+====================================================================
+| Byte 3   |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 4   |                           0                           |
+--------------------------------------------------------------------
+| Byte 5   |                           0                           |
+--------------------------------------------------------------------
+| Byte 6   |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 7   |                           0                           |
+====================================================================
+| Byte 8   |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 9   |                           0                           |
+--------------------------------------------------------------------
+| Byte 10  |                           0                           |
+--------------------------------------------------------------------
+| Byte 11  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 12  |                           0                           |
+====================================================================
+| Byte 13  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 14  |                           0                           |
+--------------------------------------------------------------------
+| Byte 15  |                           0                           |
+--------------------------------------------------------------------
+| Byte 16  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 17  |                           0                           |
+====================================================================
+| Byte 18  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 19  |                           0                           |
+--------------------------------------------------------------------
+| Byte 20  |                           0                           |
+--------------------------------------------------------------------
+| Byte 21  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 22  |                           0                           |
+====================================================================
+| Byte 23  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 24  |                           0                           |
+--------------------------------------------------------------------
+| Byte 25  |                           0                           |
+--------------------------------------------------------------------
+| Byte 26  |             0             |              0            |
+--------------------------------------------------------------------
+| Byte 27  |                           0                           |
+====================================================================
+| Byte 28  |                           0                           |
+--------------------------------------------------------------------
-- 
1.7.9.2

