Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab2K3Syo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:54:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:57598 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031630Ab2K3Sti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Danny Kukawka <danny.kukawka@bisect.de>, Jens Axboe <axboe@kernel.dk>
Subject: [ 02/37] drivers/block/DAC960: fix DAC960_V2_IOCTL_Opcode_T -Wenum-compare warning
Date: Fri, 30 Nov 2012 10:45:49 -0800
Message-Id: <20121130183857.475532637@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Kukawka <danny.kukawka@bisect.de>

commit bca505f1097c725708ddc055cf8055e922b0904b upstream.

Fixed compiler warning:

comparison between ‘DAC960_V2_IOCTL_Opcode_T’ and ‘enum <anonymous>’

Renamed enum, added a new enum for SCSI_10.CommandOpcode in
DAC960_V2_ProcessCompletedCommand().

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/DAC960.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -4627,7 +4627,8 @@ static void DAC960_V2_ProcessCompletedCo
   DAC960_Controller_T *Controller = Command->Controller;
   DAC960_CommandType_T CommandType = Command->CommandType;
   DAC960_V2_CommandMailbox_T *CommandMailbox = &Command->V2.CommandMailbox;
-  DAC960_V2_IOCTL_Opcode_T CommandOpcode = CommandMailbox->Common.IOCTL_Opcode;
+  DAC960_V2_IOCTL_Opcode_T IOCTLOpcode = CommandMailbox->Common.IOCTL_Opcode;
+  DAC960_V2_CommandOpcode_T CommandOpcode = CommandMailbox->SCSI_10.CommandOpcode;
   DAC960_V2_CommandStatus_T CommandStatus = Command->V2.CommandStatus;
 
   if (CommandType == DAC960_ReadCommand ||
@@ -4699,7 +4700,7 @@ static void DAC960_V2_ProcessCompletedCo
     {
       if (Controller->ShutdownMonitoringTimer)
 	      return;
-      if (CommandOpcode == DAC960_V2_GetControllerInfo)
+      if (IOCTLOpcode == DAC960_V2_GetControllerInfo)
 	{
 	  DAC960_V2_ControllerInfo_T *NewControllerInfo =
 	    Controller->V2.NewControllerInformation;
@@ -4719,14 +4720,14 @@ static void DAC960_V2_ProcessCompletedCo
 	  memcpy(ControllerInfo, NewControllerInfo,
 		 sizeof(DAC960_V2_ControllerInfo_T));
 	}
-      else if (CommandOpcode == DAC960_V2_GetEvent)
+      else if (IOCTLOpcode == DAC960_V2_GetEvent)
 	{
 	  if (CommandStatus == DAC960_V2_NormalCompletion) {
 	    DAC960_V2_ReportEvent(Controller, Controller->V2.Event);
 	  }
 	  Controller->V2.NextEventSequenceNumber++;
 	}
-      else if (CommandOpcode == DAC960_V2_GetPhysicalDeviceInfoValid &&
+      else if (IOCTLOpcode == DAC960_V2_GetPhysicalDeviceInfoValid &&
 	       CommandStatus == DAC960_V2_NormalCompletion)
 	{
 	  DAC960_V2_PhysicalDeviceInfo_T *NewPhysicalDeviceInfo =
@@ -4915,7 +4916,7 @@ static void DAC960_V2_ProcessCompletedCo
 	  NewPhysicalDeviceInfo->LogicalUnit++;
 	  Controller->V2.PhysicalDeviceIndex++;
 	}
-      else if (CommandOpcode == DAC960_V2_GetPhysicalDeviceInfoValid)
+      else if (IOCTLOpcode == DAC960_V2_GetPhysicalDeviceInfoValid)
 	{
 	  unsigned int DeviceIndex;
 	  for (DeviceIndex = Controller->V2.PhysicalDeviceIndex;
@@ -4938,7 +4939,7 @@ static void DAC960_V2_ProcessCompletedCo
 	    }
 	  Controller->V2.NeedPhysicalDeviceInformation = false;
 	}
-      else if (CommandOpcode == DAC960_V2_GetLogicalDeviceInfoValid &&
+      else if (IOCTLOpcode == DAC960_V2_GetLogicalDeviceInfoValid &&
 	       CommandStatus == DAC960_V2_NormalCompletion)
 	{
 	  DAC960_V2_LogicalDeviceInfo_T *NewLogicalDeviceInfo =
@@ -5065,7 +5066,7 @@ static void DAC960_V2_ProcessCompletedCo
 			 [LogicalDeviceNumber] = true;
 	  NewLogicalDeviceInfo->LogicalDeviceNumber++;
 	}
-      else if (CommandOpcode == DAC960_V2_GetLogicalDeviceInfoValid)
+      else if (IOCTLOpcode == DAC960_V2_GetLogicalDeviceInfoValid)
 	{
 	  int LogicalDriveNumber;
 	  for (LogicalDriveNumber = 0;


