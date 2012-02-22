Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2BVQFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:05:03 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:37325 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab2BVQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:05:00 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Tejun Heo <tj@kernel.org>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [RESEND][PATCH 1/2] drivers/block/DAC960: fix DAC960_V2_IOCTL_Opcode_T -Wenum-compare warning
Date: Wed, 22 Feb 2012 17:04:40 +0100
Message-Id: <1329926681-6057-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1329926681-6057-1-git-send-email-danny.kukawka@bisect.de>
References: <1329926681-6057-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329926700;8b37ff75;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed compiler warning:

comparison between ‘DAC960_V2_IOCTL_Opcode_T’ and ‘enum <anonymous>’

Renamed enum, added a new enum for SCSI_10.CommandOpcode in
DAC960_V2_ProcessCompletedCommand().

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/block/DAC960.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index e086fbb..487ce64 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -4627,7 +4627,8 @@ static void DAC960_V2_ProcessCompletedCommand(DAC960_Command_T *Command)
   DAC960_Controller_T *Controller = Command->Controller;
   DAC960_CommandType_T CommandType = Command->CommandType;
   DAC960_V2_CommandMailbox_T *CommandMailbox = &Command->V2.CommandMailbox;
-  DAC960_V2_IOCTL_Opcode_T CommandOpcode = CommandMailbox->Common.IOCTL_Opcode;
+  DAC960_V2_IOCTL_Opcode_T IOCTLOpcode = CommandMailbox->Common.IOCTL_Opcode;
+  DAC960_V2_CommandOpcode_T CommandOpcode = CommandMailbox->SCSI_10.CommandOpcode;
   DAC960_V2_CommandStatus_T CommandStatus = Command->V2.CommandStatus;
 
   if (CommandType == DAC960_ReadCommand ||
@@ -4699,7 +4700,7 @@ static void DAC960_V2_ProcessCompletedCommand(DAC960_Command_T *Command)
     {
       if (Controller->ShutdownMonitoringTimer)
 	      return;
-      if (CommandOpcode == DAC960_V2_GetControllerInfo)
+      if (IOCTLOpcode == DAC960_V2_GetControllerInfo)
 	{
 	  DAC960_V2_ControllerInfo_T *NewControllerInfo =
 	    Controller->V2.NewControllerInformation;
@@ -4719,14 +4720,14 @@ static void DAC960_V2_ProcessCompletedCommand(DAC960_Command_T *Command)
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
@@ -4915,7 +4916,7 @@ static void DAC960_V2_ProcessCompletedCommand(DAC960_Command_T *Command)
 	  NewPhysicalDeviceInfo->LogicalUnit++;
 	  Controller->V2.PhysicalDeviceIndex++;
 	}
-      else if (CommandOpcode == DAC960_V2_GetPhysicalDeviceInfoValid)
+      else if (IOCTLOpcode == DAC960_V2_GetPhysicalDeviceInfoValid)
 	{
 	  unsigned int DeviceIndex;
 	  for (DeviceIndex = Controller->V2.PhysicalDeviceIndex;
@@ -4938,7 +4939,7 @@ static void DAC960_V2_ProcessCompletedCommand(DAC960_Command_T *Command)
 	    }
 	  Controller->V2.NeedPhysicalDeviceInformation = false;
 	}
-      else if (CommandOpcode == DAC960_V2_GetLogicalDeviceInfoValid &&
+      else if (IOCTLOpcode == DAC960_V2_GetLogicalDeviceInfoValid &&
 	       CommandStatus == DAC960_V2_NormalCompletion)
 	{
 	  DAC960_V2_LogicalDeviceInfo_T *NewLogicalDeviceInfo =
@@ -5065,7 +5066,7 @@ static void DAC960_V2_ProcessCompletedCommand(DAC960_Command_T *Command)
 			 [LogicalDeviceNumber] = true;
 	  NewLogicalDeviceInfo->LogicalDeviceNumber++;
 	}
-      else if (CommandOpcode == DAC960_V2_GetLogicalDeviceInfoValid)
+      else if (IOCTLOpcode == DAC960_V2_GetLogicalDeviceInfoValid)
 	{
 	  int LogicalDriveNumber;
 	  for (LogicalDriveNumber = 0;
-- 
1.7.8.3

