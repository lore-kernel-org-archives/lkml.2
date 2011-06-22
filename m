Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab1FVIhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:37:50 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48097 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1FVIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:37:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6384"; a="99096511"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: =?UTF-8?q?=5BRFC/PATCH/RESEND=202/3=5D=20usb=20unittests=20framework=3A=20Documentation?=
Date: Wed, 22 Jun 2011 11:34:09 +0300
Message-Id: <1308731651-7397-3-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1308731651-7397-1-git-send-email-tlinder@codeaurora.org>
References: <1308731651-7397-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 .../usb/unittests/Documentation/autoconfig_readme  |   20 +
 .../usb/unittests/Documentation/create-gadget-img  |   47 ++
 tools/usb/unittests/Documentation/unittests-info   |  526 ++++++++++++++++++++
 tools/usb/unittests/Documentation/unittests-setup  |  127 +++++
 4 files changed, 720 insertions(+), 0 deletions(-)
 create mode 100644 tools/usb/unittests/Documentation/autoconfig_readme
 create mode 100644 tools/usb/unittests/Documentation/create-gadget-img
 create mode 100644 tools/usb/unittests/Documentation/unittests-info
 create mode 100644 tools/usb/unittests/Documentation/unittests-setup

diff --git a/tools/usb/unittests/Documentation/autoconfig_readme b/tools/usb/unittests/Documentation/autoconfig_readme
new file mode 100644
index 0000000..07112e1
--- /dev/null
+++ b/tools/usb/unittests/Documentation/autoconfig_readme
@@ -0,0 +1,20 @@
+
+Questions can be refereed to tlinder@codeaurora.org.
+Copyright (C) 2011 Code Aurora Forum. All rights reserved
+
+Description
+-----------
+This script is used to automatically configure the kernel .config file
+(instead of using menuconfig).
+This script should be ran after using defconfig.
+
+Please note that the script modifies the .config file under out-32 (and
+should be executed in the out-32 directory).
+
+The script activates the dummy_HCD controller and configures the gadget
+to operate in  a SS mode.
+
+--
+Created by a consultant of the Qualcomm Innovation Center, Inc.
+The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
+
diff --git a/tools/usb/unittests/Documentation/create-gadget-img b/tools/usb/unittests/Documentation/create-gadget-img
new file mode 100644
index 0000000..edb34a7
--- /dev/null
+++ b/tools/usb/unittests/Documentation/create-gadget-img
@@ -0,0 +1,47 @@
+
+Questions can be refereed to tlinder@codeaurora.org.
+Copyright (C) 2011 Code Aurora Forum. All rights reserved
+
+
+This is how disk is built:
+-------------------------
+VM points to the location of the Virtual Machine
+
+cd $VM
+mkdir rootfs
+# create unformatted image
+qemu-img create -f raw gadget.img 600M
+# format it with ext2
+mkfs.ext2 -F gadget.img
+# mount
+fuseext2 gadget.img rootfs -o rw+
+# populate disk with basic Linux installation
+debootstrap --arch=i386 karmic rootfs
+
+#prepare image for real life
+echo "proc            /proc           proc    defaults        0       0" >> rootfs/etc/fstab
+echo "/dev/sda        /               ext2    defaults        0       0" >> rootfs/etc/fstab
+
+echo "user    ALL=(ALL) ALL" >> rootfs/etc/sudoers
+
+echo "auto lo" >> rootfs/etc/network/interfaces
+echo "iface lo inet loopback" >> rootfs/etc/network/interfaces
+echo "auto eth0" >> rootfs/etc/network/interfaces
+echo "iface eth0 inet dhcp" >> rootfs/etc/network/interfaces
+
+#unmount it
+fusermount -u rootfs
+
+Boot in a single mode (use -append "root=/dev/sda single"); in the VM, execute:
+
+useradd user
+passwd -d user
+echo "root:root00" | chpasswd
+apt-get --yes install openssh-server
+halt
+
+NOTE: instructions are incomplete
+
+--
+Created by a consultant of the Qualcomm Innovation Center, Inc.
+The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
\ No newline at end of file
diff --git a/tools/usb/unittests/Documentation/unittests-info b/tools/usb/unittests/Documentation/unittests-info
new file mode 100644
index 0000000..163b270
--- /dev/null
+++ b/tools/usb/unittests/Documentation/unittests-info
@@ -0,0 +1,526 @@
+
+Questions can be refereed to tlinder@codeaurora.org.
+Copyright (C) 2011 Code Aurora Forum. All rights reserved
+
+1: INPUT PARAMETERS
+-------------------
+
+Usb_test receives the following input parameters:
+1.int busnum - the bus number of the USB device to run the tests on
+2.int devnum - the device number of the USB device to run the tests on
+3.int productid - the product id of the USB device to run the tests on
+4.int vendorid - the vendor id of the USB device to run the tests on
+The above data can be retrieved by running lsusb command on the VM/Linux host
+the USB device is connected to.
+Note: You should provide either busnum and devnum or productid and vendorid
+as an input.
+5.int num_expected_strms_in_ep - the number of expected streams for IN EP's
+  ep_comp desc
+6.int num_expected_strms_out_ep - the number of expected streams for OUT EP's
+  ep_comp desc
+7.int intr_num - the number of the interface to run the test on
+8.int devel - set this flag to 1 if you wish to run in development mode.
+  (Refer to section 3 for more details)
+9.int uasp_dev - set this flag to 1 if running the test on a UAS Gadget driver
+10.int debug - this flag indicates if debug information will be printed or not.
+  The default is that no debug info will be printed (debug = 0). You can change
+  that by setting debug = 1 (optional)
+11.int streams_dev - Setting this flag to 1 will result in running only streams
+  tests
+12.char gadget_sysfs_path[MAX_STRING_LEN] - Gadget sysfs path. The default is:
+  "/sys/devices/platform/dummy_udc/gadget/"
+
+Example:
+./usb_tests --busnum=2 --devnum=3 --debug=1
+
+
+2: RUNNING A SUBSET OF THE TESTS (ACCORDING TO DEVICE SPEED)
+------------------------------------------------------------
+
+On Unittests initialization the speed of the connected device is read and the
+appropriate test suite is excluded from the tests to run. Meaning if it's a
+HS/SS device CompositeSSTests/ CompositeHSTests won't be run.
+Beside this exception GoogleTest will run all the test suites.
+
+
+3. RUNNING IN DEVELOPMENT MODE
+------------------------------
+
+It's possible to choose a test to run. In order to do so run the test in
+development mode, meaning
+	./usb_tests --busnum=2 --devnum=3 -devel=1
+This will open a list of test for you to choose which test to run.
+At the moment this option is developed for UAS tests only but other tests can be
+easily added to this menu.
+
+4: IMPLEMENTED TESTS
+--------------
+
+4.1: DUMMY TESTS
+
+4.1.1 test_connect_disconnect
+  Test Suite: DummyTests
+  Test Name: test_connect_disconnect
+  Test Description:
+  This test verifies the connect&disconnect sequence.
+  Verification is done by testing the correct enumeration descriptors were sent
+  (according to speed).
+
+
+4.2: COMPOSITE HS TESTS
+
+This test suite is applicable only for a HS device. The test in this suite
+verify chapter 9 requests that are applicable only to HS device.
+For example: HS descriptors.
+
+4.2.1 Test_hs_descriptors
+  Test Suite: CompositeHSTests
+  Test Name: test_hs_descriptors
+  Test Description:
+  This test verifies the validity of the HS device and interface descriptors
+  returned as part of the enumeration sequence.
+  Verification is done according to the expected descriptors defined in
+  hs_expected_desc.h
+
+4.2.2 Test_hs_get_status_default_device
+  Test Suite: CompositeHSTests
+  Test Name: test_hs_get_status_default_device
+  Test Description:
+  This function sends a GET_STATUS request to the hs device in default state and
+  checks that the response is as expected (section 9.4.5 in the USB2 standard)
+
+4.2.3 Test_hs_get_status_default_interface
+  Test Suite: CompositeHSTests
+  Test Name: test_hs_get_status_default_interface
+  Test Description:
+  This function sends a GET_STATUS request to the hs interface in default state
+  (section 9.4.5 in the USB2 standard)
+
+4.2.4 Test_hs_get_status_default_endpoint
+  Test Suite: CompositeHSTests
+  Test Name: test_hs_get_status_default_endpoint
+  Test Description:
+  This function sends a GET_STATUS request to the hs endpoint in default state
+  (section 9.4.5 in the USB2 standard)
+
+4.2.5 Test_hs_set_feature_suspend_interface
+  Test Suite: CompositeHSTests
+  Test Name: test_hs_set_feature_suspend_interface
+  Test Description:
+  This function sends a SET_FEATURE request to the ss interface in default
+  state, to set the suspend functionality for remote wakeup.
+
+4.2.6 Test_hs_set_feature_halt_ep
+  Test Suite: CompositeHSTests
+  Test Name: test_hs_set_feature_halt_ep
+  Test Description:
+  This function sends a SET_FEATURE request to the hs EP in default state, to
+  set the halt feature. It's run for the BULK IN endpoint and assumes the device
+  has such.
+
+
+4.3: COMPOSITE SS TESTS
+
+This test suite is applicable only for a SS device. The test in this suite
+verify chapter 9 modifications that were made/added by the USB 3.0 spec.
+
+4.3.1 Test_ss_descriptors
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_descriptors
+  Test Description:
+  This test verifies the validity of the HS device, interface and BOS
+  descriptors returned as part of the enumeration sequence.
+  Verification is done according to the expected descriptors defined in
+  ss_expected_desc.h
+
+4.3.2 Test_ss_get_status_default_device
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_get_status_default_device
+  Test Description:
+  This function sends a GET_STATUS request to the ss device in default state
+  (when LTM, U1 & U2 are not enabled) and checks that the response is as
+  expected (section 9.4.5 in the USB3 standard)
+  Verification of the GetStatus() request is done by the SetFeature()
+  (with bmRequestType = 0x80H) request sent prior to the GetStatus() request.
+
+4.3.3 Test_ss_get_status_default_interface
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_get_status_default_interface
+  Test Description:
+  This function sends a GET_STATUS request to the ss interface in default state
+  (section 9.4.5 in the USB3 standard)
+  Verification of the GetStatus() request is done by the SetFeature()
+  (with bmRequestType = 0x81H) request sent prior to the GetStatus() request.
+  Refer to Section 9.4.5 of the USB 3.0 spec for details on GetStatus request.
+
+4.3.4 Test_ss_get_status_default_ep
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_get_status_default_ep
+  Test Description:
+  This function sends a  GET_STATUS request to the ss endpoint in default state
+  (section 9.4.5 in the USB3 standard). It's run for the BULK IN endpoint and
+  assumes the device has such.
+  Verification of the GetStatus() request is done by the SetFeature()
+  (with bmRequestType = 0x81H) request sent prior to the GetStatus() request.
+  Refer to Section 9.4.5 of the USB 3.0 spec for details on GetStatus request.
+
+4.3.5 Test_ss_set_feature_u1_device
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_set_feature_u1_device
+  Test Description:
+  This function sends a SET_FEATURE request to the ss device in default state,
+  to set the U1 power level capability.
+  Verification that the SetFeature request was successful is done by GetStatus()
+  request with bmRequestType = 0x81H. Refer to Section 9.4.5 of the USB 3.0 spec
+  for details on GetStatus request.
+  Refer to section 9.4.9 and Table 9-6 of the USB 3.0 spec for more details on
+  the SetFeature request.
+
+4.3.6 Test_ss_set_feature_u2_device
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_set_feature_u2_device
+  Test Description:
+  This function sends a SET_FEATURE request to the ss device in default state,
+  to set the U2 power level capability.
+  Verification that the SetFeature request was successful is done by GetStatus()
+  request with bmRequestType = 0x81H. Refer to Section 9.4.5 of the USB 3.0
+  spec for details on GetStatus request.
+  Refer to section 9.4.9 and Table 9-6 of the USB 3.0 spec for more details on
+  the SetFeature request.
+
+4.3.7 Test_ss_set_feature_ltm_device
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_set_feature_u2_device
+  Test Description:
+  This function sends a SET_FEATURE request to the ss device in default state,
+  to set the LTM capability.
+  Verification that the SetFeature request was successful is done by GetStatus()
+  request with bmRequestType = 0x81H. Refer to Section 9.4.5 of the USB 3.0
+  spec for details on GetStatus request.
+  Refer to section 9.4.9 and Table 9-6 of the USB 3.0 spec for more details on
+  the SetFeature request.
+
+4.3.8 Test_ss_set_feature_halt_ep
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_set_feature_halt_ep
+  Test Description:
+  This function sends a SET_FEATURE request to the ss EP in default state, to
+  set the halt feature It's run for the BULK IN endpoint and assumes  the device
+  has such.
+  Verification that the SetFeature request was successful is done by GetStatus()
+  request with bmRequestType = 0x81H. Refer to Section 9.4.5 of the USB 3.0
+  spec for details on GetStatus request.
+  Refer to section 9.4.9 and Table 9-6 of the USB 3.0 spec for more details on
+  the SetFeature request.
+
+4.3.9 Test_ss_set_feature_suspend_low_power_interface
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_set_feature_suspend_low_power_interface
+  Test Description:
+  This function sends a SET_FEATURE request to the ss interface in default
+  state, to set the suspend functionality for low power.
+  Verification that the SetFeature request was successful is done by GetStatus()
+  request with bmRequestType = 0x81H. Refer to Section 9.4.5 of the USB 3.0
+  spec for details on GetStatus request.
+  Refer to section 9.4.9 and Table 9-6 of the USB 3.0 spec for more details on
+  the SetFeature request.
+
+4.3.10 Test_ss_set_feature_suspend_remote_wakeup_interface
+  Test Suite: CompositeSSTests
+  Test Name: test_ss_set_feature_suspend_remote_wakeup_interface
+  Test Description:
+  This function sends a SET_FEATURE request to the ss interface in default
+  state, to set the suspend functionality for remote wakeup.
+  Verification that the SetFeature request was successful is done by GetStatus()
+  request with bmRequestType = 0x81H. Refer to Section 9.4.5 of the USB 3.0
+  spec for details on GetStatus request.
+  Refer to section 9.4.9 and Table 9-6 of the USB 3.0 spec for more details on
+  the SetFeature request.
+
+
+4.4: SERIAL TESTS
+
+The tests in this test suite are general data transfer tests that are applicable
+to all devices (HS and SS) and test the data transfers in the Gadget framework,
+not in a specific FD. The test in this test suite should be performed on the
+g_zero module using f_sourcesink gadget.
+
+4.4.1 Test_single_bulk_in
+  Test Suite: SerialTests
+  Test Name: test_single_bulk_in
+  Test Description:
+  This test verifies a single BULK transfer on a BULK IN endpoint. Data transfer
+  size is an input parameter for the test.
+
+4.4.2 Test_single_bulk_out
+  Test Suite: SerialTests
+  Test Name: test_single_bulk_out
+  Test Description:
+  This test verifies a single BULK transfer on a BULK OUT endpoint. Data
+  transfer size is an input parameter for the test.
+
+
+4.5 STREAMS TESTS
+
+The tests in this test suite intended to test the streaming capability added by
+the SS USB  spec, thus they are applicable only to SS devices.
+
+4.5.1 Tests_streams_bulk_loopback
+  Test Suite: StreamsTests
+  Test Name: test_streams_bulk_loopback
+  Test Description:
+  This test initiates N bulk OUT transfers on N streams, and verifies reception
+  on bulk IN EP.
+
+
+4.6 UAS TESTS
+
+This tests are meant to run on a UAS supporting device. Their intention is to
+test various COMAND/TASK MANAGEMENT IUs handling as defined by the UAS spec.
+The COMMAND IUs include SCSI commands.
+Verification of all the test successful completion is done according to the
+SENCE IU received upon completion.
+The below tests are applicable to UAS device operating both in SS and in HS
+mode.
+
+4.6.1 exec_send_inquiry
+  Test Suite: UASTests
+  Test Name: exec_send_inquiry
+  Test Description:
+  This function sends the INQUIRY SCSI command (opCode = 0x12), encapsulated in
+  a COMMAND IU, to the device and verifies the correct reply from it.
+
+4.6.2 exec_send_request_sense
+  Test Suite: UASTests
+  Test Name: exec_send_request_sense
+  Test Description:
+  This function sends the REQUEST SENSE SCSI command (opCode = 0x03),
+  encapsulated in a COMMAND IU, to the device and verifies the correct reply
+  from it.
+
+4.6.3 exec_test_unit_ready
+  Test Suite: UASTests
+  Test Name: exec_test_unit_ready
+  Test Description:
+  This function sends the TEST UNIT READY SCSI command (opCode = 0x00),
+  encapsulated in a COMMAND IU, to the device and verifies the correct reply
+  from it.
+
+4.6.4 exec_send_read_capacity
+  Test Suite: UASTests
+  Test Name: exec_send_read_capacity
+  Test Description:
+  This function sends the READ CAPACITY SCSI command (opCode = 0x25),
+  encapsulated in a COMMAND IU, to the device and verifies the correct reply
+  from it.
+
+4.6.5 exec_send_mode_sense
+  Test Suite: UASTests
+  Test Name: exec_send_mode_sense
+  Test Description:
+  This function sends the MODE SENSE6 SCSI command (opCode = 0x01), encapsulated
+  in a COMMAND IU, to the device and verifies the correct reply from it.
+
+4.6.6 exec_send_mode_sense10
+  Test Suite: UASTests
+  Test Name: exec_send_mode_sense10
+  Test Description:
+  This function sends the MODE SENSE10 SCSI command (opCode = 0x5a),
+  encapsulated in a COMMAND IU, to the device and verifies the correct
+  completion of it.
+
+4.6.7 exec_send_prevent_allow_removal
+  Test Suite: UASTests
+  Test Name: exec_send_prevent_allow_removal
+  Test Description:
+  This function sends the ALLOW MEDIUM REMOVAL SCSI command (opCode = 0x1e),
+  encapsulated in a COMMAND IU, to the device and verifies the correct
+  completion of it.
+
+4.6.8 exec_test_read6
+  Test Suite: UASTests
+  Test Name: exec_test_read6
+  Test Description:
+  This function sends the READ6 SCSI command (opCode = 0x08), encapsulated in a
+  COMMAND IU, to the device and verifies the correct completion of it.
+  At the beginning of the test a verification buffer is written to the device.
+  The read data is compared to that buffer. Upon test completion the device data
+  file content is restored to its original state.
+
+4.6.9 exec_test_read10
+  Test Suite: UASTests
+  Test Name: exec_test_read10
+  Test Description:
+  This function sends the READ10 SCSI command (opCode = 0x28), encapsulated in
+  a COMMAND IU, to the device and verifies the correct completion of it.
+  At the beginning of the test a verification buffer is written to the device.
+  The read data is compared to that buffer. Upon test completion the device data
+  file content is restored to its original state.
+
+4.6.10 exec_test_read12
+  Test Suite: UASTests
+  Test Name: exec_test_read12
+  Test Description:
+  This function sends the READ12 SCSI command (opCode = 0xa8), encapsulated in
+  a COMMAND IU, to the device and verifies the correct completion of it.
+  At the beginning of the test a verification buffer is written to the device.
+  The read data is compared to that buffer. Upon test completion the device data
+  file content is restored to its original state.
+
+4.6.11 exec_test_write6
+  Test Suite: UASTests
+  Test Name: exec_test_write6
+  Test Description:
+  This function sends the WRITE6 SCSI command (opCode = 0x0a), encapsulated in
+  a COMMAND IU, to the device and verifies the correct completion of it.
+  Upon test completion the device data file content is restored to its original
+  state.
+  TODO: Add write verification
+
+4.6.12 exec_test_write10
+  Test Suite: UASTests
+  Test Name: exec_test_write10
+  Test Description:
+  This function sends the WRITE10 SCSI command (opCode = 0x2a), encapsulated in
+  a COMMAND IU, to the device and verifies the correct completion of it.
+  Upon test completion the device data file content is restored to its original
+  state.
+  TODO: Add write verification
+
+4.6.13 exec_test_write12
+  Test Suite: UASTests
+  Test Name: exec_test_write12
+  Test Description:
+  This function sends the WRITE12 SCSI command (opCode = 0xaa), encapsulated in
+  a COMMAND IU, to the device and verifies the correct completion of it.
+  Upon test completion the device data file content is restored to its original
+  state.
+  TODO: Add write verification
+
+4.6.14 exec_test_write_huge
+  Test Suite: UASTests
+  Test Name: exec_test_write_huge
+  Test Description:
+  This function sends the WRITE10 SCSI command (opCode = 0x2a), encapsulated in
+  a COMMAND IU, with a huge amount of data to write and verifies the correct
+  completion of it.
+  Upon test completion the device data file content is restored to its original
+  state.
+  TODO: Add write verification
+
+4.6.15 exec_test_read_format_capacities
+  Test Suite: UASTests
+  Test Name: exec_test_read_format_capacities
+  Test Description:
+  This function sends the READ FORMAT CAPACITIES SCSI command (opCode = 0x23),
+  encapsulated in a COMMAND IU and verifies the correct completion of it.
+
+4.6.16 exec_test_start_stop
+  Test Suite: UASTests
+  Test Name: exec_test_start_stop
+  Test Description:
+  This function sends the START STOP UNIT SCSI command (opCode = 0x1b),
+  encapsulated in a COMMAND IU and verifies the correct completion of it.
+  This test verifies several versions of the command:
+	a)(LoEj,Start) = 00 (stop motor)
+	b)(LoEj,Start) = 01 (start motor)
+	c)(LoEj,Start) = 10 (Eject media)
+  After the media is ejected the lun is closed. We need to re-open it manually
+  in order to be able to continue working with it. This is done by writing to
+  the file attribute the name of the file the module was loaded with.
+	d)(LoEj,Start) = 11 (LOAD media)
+
+4.6.17 exec_test_verify
+  Test Suite: UASTests
+  Test Name: exec_test_verify
+  Test Description:
+  This function sends the VERIFY SCSI command (opCode = 0x2f), encapsulated in
+  a COMMAND IU and verifies the correct completion of it.
+
+4.6.18 exec_test_synchronize_cache
+  Test Suite: UASTests
+  Test Name: exec_test_synchronize_cache
+  Test Description:
+  This function sends the SINCHRONIZE CACHE SCSI command (opCode = 0x35),
+  encapsulated in a COMMAND IU and verifies the correct completion of it.
+
+4.6.19 exec_test_tm_reset_lun
+  Test Suite: UASTests
+  Test Name: exec_test_tm_reset_lun
+  Test Description:
+  This function sends the LOGICAL UNIT RESET TASK MANAGEMENTcommand
+  (Code = 0x08), and verifies the correct completion of it according to the
+  RESPONSE IU.
+  At the beginning of the test 2 commands are issued to the device that should
+  be canceled by the RESET LUN TM.
+
+4.6.20 exec_test_tm_abort_task
+  Test Suite: UASTests
+  Test Name: exec_test_tm_abort_task
+  Test Description:
+  This function sends the ABORT TASK TASK MANAGEMENTcommand (Code = 0x01), and
+  verifies the correct completion of it according to the RESPONSE IU.
+  At the beginning of the test a command is issued to the device that should be
+  canceled by the ABORT TASK TM.
+
+4.6.21 exec_test_tm_abort_task_set
+  Test Suite: UASTests
+  Test Name: exec_test_tm_abort_task_set
+  Test Description:
+  This function sends the ABORT TASK SET TASK MANAGEMENTcommand (Code = 0x02),
+  and verifies the correct completion of it according to the RESPONSE IU.
+  At the beginning of the test 2 commands are issued to the device that should
+  be canceled by the ABORT TASK SET TM.
+
+4.6.22 exec_test_tm_reset_nexus
+  Test Suite: UASTests
+  Test Name: exec_test_tm_reset_nexus
+  Test Description:
+  This function sends the RESET NEXUS TASK MANAGEMENTcommand (Code = 0x10), and
+  verifies the correct completion of it according to the RESPONSE IU.
+  At the beginning of the test 2 commands are issued to the device that should
+  be canceled by the RESET NEXUS TM.
+
+4.6.23 exec_test_tm_query_async_ev
+  Test Suite: UASTests
+  Test Name: exec_test_tm_query_async_ev
+  Test Description:
+  This function sends the QUERY ASYNC EVENT TASK MANAGEMENTcommand
+  (Code = 0x82), and verifies the correct completion of it according to the
+  RESPONSE IU.
+
+4.6.24 exec_test_tm_query_task
+  Test Suite: UASTests
+  Test Name: exec_test_tm_query_task
+  Test Description:
+  This function sends the QUERY TASK TASK MANAGEMENTcommand (Code = 0x80), and
+  verifies the correct completion of it according to the RESPONSE IU.
+
+4.6.25 exec_test_tm_query_task_set
+  Test Suite: UASTests
+  Test Name: exec_test_tm_query_task_set
+  Test Description:
+  This function sends the QUERY TASK SET TASK MANAGEMENTcommand (Code = 0x81),
+  and verifies the correct completion of it according to the RESPONSE IU.
+
+4.6.26 exec_test_tm_overlapped_tag
+  Test Suite: UASTests
+  Test Name: exec_test_tm_overlapped_tag
+  Test Description:
+  This function verifies correct handling of tag overlapping. It issues 2
+  commands with the same tag id and verifies that both commands were handled
+  correctly, meaning aborted.
+  One of the commands issued is a COMMAND IU and the other is TM IU.
+
+4.6.27 exec_test_cmd_overlapped_tag
+  Test Suite: UASTests
+  Test Name: exec_test_cmd_overlapped_tag
+  Test Description:
+  This function verifies correct handling of tag overlapping. It issues 2
+  commands with the same tag id and verifies that both commands were handled
+  correctly, meaning aborted.
+  Both of the command issued are COMMAND IUs.
+
+--
+Created by a consultant of the Qualcomm Innovation Center, Inc.
+The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
\ No newline at end of file
diff --git a/tools/usb/unittests/Documentation/unittests-setup b/tools/usb/unittests/Documentation/unittests-setup
new file mode 100644
index 0000000..f336e3b
--- /dev/null
+++ b/tools/usb/unittests/Documentation/unittests-setup
@@ -0,0 +1,127 @@
+
+Questions can be refereed to tlinder@codeaurora.org.
+Copyright (C) 2011 Code Aurora Forum. All rights reserved
+
+USB device Unit test framework
+==============================
+
+Introduction
+-------------
+
+This document describes the SuperSpeed USB Unit tests including setup,
+environment and test cases.
+
+
+1: SETUP
+---------
+
+The Unit tests code consists of 4 parts:
+
+1. The usb-tests code that is part of the kernel usb code.
+2. Googletest code. Downloaded from the web.
+3. The user-space test code in this distribution
+4. libusb code that is part of the libusb git repository
+
+The Unit tests can be ran on any Linux machine with a device that has g_zero
+and dummy_hcd module loaded on it. If you wish to run the Unit tests on another
+device (one that doesn't support g_zero and dumm_hcd_ it's possible but not all
+of the bellow tests will pass. This is due to the fact that several proprietary
+control requests handling were implemented in the above modules in order to
+support some of the tests. For example: new control request handling was
+added to the dummy_hcd module to perform a connect/disconnect sequence.
+
+
+1.1: GETTING USB-TEST CODE FROM THE KERNEL REPOSITORY
+
+Get the kernel code from
+    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+The unit test kernel patches are released as part of kernel2.6.?? so you should
+work with this version of the kernel or later.
+
+Compiling the Kernel code:
+Export $KERNEL to point to the location of your kernel.
+mkdir out-32
+cd out-32
+make -C $KERNEL O=`pwd` ARCH=x86 defconfig
+
+Run the autoconfig.sh script to configure the kernel. Please refer to
+autoconfig_readme for details.
+
+Compilation:
+make -C $KERNEL O=`pwd` ARCH=x8
+
+
+1.2: LIBUSB CODE
+
+Get the libusb code from git://git.libusb.org/libusb.git
+The libusb related patches are merged into the libusb tree. (NOT YET!!!)
+
+1.2.1 Libusb Setup and compilation
+
+Install the following packages (from synaptic):
+a. autoconfig
+b.automake
+c. libtool
+
+Run: ./autogen.sh. –prefix=<output_folder>
+This script will generate the .config file and the Makefile
+
+Open the auto-generated Makefiles (there is one under libusb, one under
+libusb/libusb and another one under libusb/examples) and update the following:
+a)To CPPFLAGS add -m32 (CPPFLAGS = -m32)
+b)To CFLAGS add -m32 (CFLAGS = -g -O2 -m32)
+c)Change every x86_64 to i386
+
+run: make install
+The library and include files will be placed in . --prefix=<output_folder>
+
+
+1.3: GOOGLETEST CODE
+
+Download from
+http://code.google.com/p/googletest/downloads/list (gtest-1.5.0.tar.bz2) .
+Open the Makefile and add “-lpthread” to CXXFLAGS:
+CXXFLAGS += -g -Wall -Wextra -m32 -L/usr/lib32 -lstdc++ -L/usr/local/lib -lusb-1.0 -lpthread
+
+
+1.4 COMPILING USER SPACE TEST CODE (IN THIS PACKAGE)
+
+cd ../tools/usb/unittests/make/ (from your working area)
+
+Set the $KERNEL to your kernel source code, $GTEST to your Googletest directory
+and $LIBUSB to your libusb compilation output directory.
+
+make
+The make creates an executable called usb_tests
+
+
+1.5: VIRTUAL MACHINE
+
+If you wish to use the dummy_hcd module then it's best to run the Unit tests on
+a Virtual machine (VM).
+Debugging of the VM kernel is performed with insight.
+So you'll be required to install the following packages:
+1. qemu
+2. fuseext2
+3. insight
+
+Create gadjet.img. Refer to create-gadget-img for details.
+
+1.5.1 Initial setup of the VM:
+
+Copy usb_tests to the VM.
+Copy the libusb library files to the VM (from <output_folder>/lib)
+
+
+2: RUNNING THE UNIT TEST
+-----------------------
+
+On the VM (or other Linux host) do:
+export LD_LIBRARY_PATH=<libusb library files path on the VM>
+run the tests script: ./usb_tests with relevant input parameters. (Refer to
+unittests-info for additional information)
+
+--
+Created by a consultant of the Qualcomm Innovation Center, Inc.
+The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
+
-- 
1.7.0.4

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
