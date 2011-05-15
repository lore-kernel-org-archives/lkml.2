Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1EOKp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 06:45:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58969 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab1EOKpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 06:45:25 -0400
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se, tomas.winkler@intel.com,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 01/10] staging/mei: MEI Driver documentations
Date: Sun, 15 May 2011 13:43:39 +0300
Message-Id: <1305456228-15265-2-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
References: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/mei/mei.txt |  189 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 189 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/mei/mei.txt

diff --git a/drivers/staging/mei/mei.txt b/drivers/staging/mei/mei.txt
new file mode 100644
index 0000000..17302ad
--- /dev/null
+++ b/drivers/staging/mei/mei.txt
@@ -0,0 +1,189 @@
+Intel MEI
+=======================
+
+Introduction
+=======================
+
+The Intel Management Engine (Intel ME) is an isolated and
+protected computing resource (Coprocessor) residing inside
+Intel chipsets. The Intel ME provides support for computer/IT
+management features.
+The Feature set depends on the Intel chipset SKU.
+
+The Intel Management Engine Interface (Intel MEI, previously known
+as HECI) is the interface between the Host and Intel ME.
+This interface is exposed to the host as a PCI device.
+The Intel MEI Driver is in charge of the communication channel
+between a host application and the ME feature.
+
+Each Intel ME feature (Intel ME Client) is addressed by
+GUID/UUID and each feature defines its own protocol.
+The protocol is message-based with a header and payload up to
+512 bytes.
+
+[place holder to URL to protocol definitions]
+
+Prominent usage of the Interface is to communicate with
+Intel Active Management Technology (Intel AMT)
+implemented in firmware running on the Intel ME.
+
+Intel AMT provides the ability to manage a host remotely out-of-band (OOB)
+even when the host processor has crashed or is in a sleep state.
+
+Some examples of Intel AMT usage are:
+   - Monitoring hardware state and platform components
+   - Remote power off/on (useful for green computing or overnight IT maintenance)
+   - OS updates
+   - Storage of useful platform information such as software assets
+   - built-in hardware KVM
+   - selective network isolation of Ethernet and IP protocol flows based on
+     policies set by a remote management console
+   - IDE device redirection from remote management console
+
+Intel AMT (OOB) communication is based on SOAP (deprecated
+starting with Release 6.0) over HTTP/HTTPS or WS-Management protocol
+over HTTP and HTTPS that are received from a remote
+management console application.
+
+For more information about Intel AMT:
+http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/WordDocuments/aboutintelamt.htm
+
+
+MEI Driver
+=======================
+
+The driver exposes a character device called /dev/mei.
+
+An application maintains communication with an ME feature while
+/dev/mei is open. The binding to a specific features is performed
+by calling MEI_CONNECT_CLIENT_IOCTL, which passes the desired UUID.
+The number of instances of an ME feature that can be opened
+at the same time depends on the ME feature, but most of the
+features allow only a single instance.
+
+
+The Intel AMT Host Interface (AMTHI) feature requires multiple
+simultaneous user applications, therefore the MEI driver handles
+this internally by maintaining request queues for the applications.
+
+The driver is oblivious to data that are passed between
+
+Because some of the ME features can change the system
+configuration, the driver by default allows only privileged
+user to access it.
+
+A Code snippet for application communicating with AMTHI client:
+	struct mei_connect_client_data data;
+	fd = open(MEI_DEVICE);
+
+	data.d.in_client_uuid = AMTHI_UUID;
+
+	ioctl(fd, IOCTL_MEI_CONNECT_CLIENT, &data);
+
+	printf(“Ver=%d, MaxLen=%ld\n”,
+			data.d.in_client_uuid.protocol_version,
+			data.d.in_client_uuid.max_msg_length);
+
+	[...]
+
+	write(fd, amthi_req_data, amthi_req_data_len);
+
+	[...]
+
+	read(fd, &amthi_res_data, amthi_res_data_len);
+
+	[...]
+	close(fd);
+
+ME Applications:
+==============
+
+1) Intel Local Management Service (Intel LMS)
+	Applications running locally on the platform communicate with
+	Intel AMT Release 2.0 and later releases in the same way
+	that network applications do via SOAP over HTTP (deprecated
+	starting with Release 6.0) or with WS-Management over SOAP over
+	HTTP. which means that some Intel AMT feature can be access
+	from a local application using same Network interface as for
+	remote application.
+
+	When a local application sends a message addressed to the local
+	Intel AMT host name, the Local Manageability Service (LMS),
+	which listens for traffic directed to the host name, intercepts
+	the message and routes it to the Intel Management Engine Interface.
+	For more information:
+	http://software.intel.com/sites/manageability/AMT_Implementation_and_
+	Reference_Guide/WordDocuments/localaccess1.htm
+
+	The LMS opens a connection using the MEI driver to the LMS
+	FW feature using a defined UUID and then communicates with the
+	feature using a protocol
+	called Intel(R) AMT Port Forwarding Protocol (APF protocol).
+	The protocol is used to maintain multiple sessions with
+	Intel AMT from a single application.
+	See the protocol specification in
+	the Intel(R) AMT Implementation and Reference Guide
+	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/HTMLDocuments/MPSDocuments/Intel%20AMT%20Port%20Forwarding%20Protocol%20Reference%20Manual.pdf
+
+  2) Intel AMT Remote configuration using a Local Agent:
+	A Local Agent enables IT personnel to configure Intel AMT out-of-the-box
+	without requiring installing additional data to enable setup.
+	The remote configuration process may involve an ISV-developed remote
+	configuration agent that runs on the host.
+	For more information:
+	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/WordDocuments/remoteconfigurationwithalocalagent.htm
+
+	How the Local Agent Works (including Command structs):
+	http://software.intel.com/sites/manageability/AMT_Implementation_and_Reference_Guide/WordDocuments/howthelocalagentsampleworks.htm
+
+Intel AMT OS Health Watchdog:
+=============================
+The Intel AMT Watchdog is an OS Health (Hang/Crash) watchdog.
+Whenever the OS hangs or crashes, Intel AMT will send an event
+to whoever subscribed to this event. This mechanism means that
+IT knows when a platform crashes even when there is a hard failure
+on the host.
+The AMT Watchdog is composed of two parts:
+	1) FW Feature - that receives the heartbeats
+	   and sends an event when the heartbeats stop.
+	2) MEI driver – connects to the watchdog (WD) feature,
+	   configures the watchdog and sends the heartbeats.
+
+The MEI driver configures the Watchdog to expire by default
+every 120sec unless set by the user using module parameters.
+The Driver then sends heartbeats every 2sec.
+
+If WD feature does not exist (i.e. the connection failed),
+the MEI driver will disable the sending of heartbeats.
+
+Module Parameters
+=================
+watchdog_timeout - the user can use this module parameter
+to change the watchdog timeout setting.
+
+This value sets the Intel AMT watchdog timeout interval in seconds;
+the default value is 120sec.
+in order to disable the watchdog activites set the value to 0.
+Normal values should be between 120 and 65535
+
+Supported Chipsets:
+==================
+7 Series Chipset Family
+6 Series Chipset Family
+5 Series Chipset Family
+4 Series Chipset Family
+Mobile 4 Series Chipset Family
+ICH9
+82946GZ/GL
+82G35 Express
+82Q963/Q965
+82P965/G965
+Mobile PM965/GM965
+Mobile GME965/GLE960
+82Q35 Express
+82G33/G31/P35/P31 Express
+82Q33 Express
+82X38/X48 Express
+
+---
+linux-mei@linux.intel.com
-- 
1.7.1

