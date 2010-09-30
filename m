Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0I3IZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:25:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0I3IYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:24:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/6] staging/bcm: add sparse annotations
Date: Thu, 30 Sep 2010 10:24:12 +0200
Message-Id: <1285835052-11880-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285835052-11880-1-git-send-email-arnd@arndb.de>
References: <1285835052-11880-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3zCbKAxuew3lQWsyURcz81/OADICp/I9V9wPSJL5Wk+
 pRRlFYO35sYmsUwUZ+71K0SMXNk2MOQB76V2/Y6J3K2HK+XPiZ
 IUotFBHjZZTULL4iOKzZgTHbgt09MtrXuXFIunYX4lwPsD9qpT
 kHrwgSg4r5r9yf5eP14kEIvvGuMsEHFRZ5dwmWh4hUgNR7WR0M
 vU8m6Y52P2OgggDavsoHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This marks up the code where sparse complains in most cases.
Most of the changes are in the ioctl handling code, which
gets __user annotations, finding one unchecked user access.

The rest is mostly about marking functions static when they
are only used in one file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/bcm/Adapter.h             |    2 +-
 drivers/staging/bcm/Bcmchar.c             |  148 ++++++++++++++---------------
 drivers/staging/bcm/Bcmnet.c              |    2 +-
 drivers/staging/bcm/CmHost.c              |    8 +-
 drivers/staging/bcm/Debug.c               |    2 +-
 drivers/staging/bcm/HandleControlPacket.c |    2 +-
 drivers/staging/bcm/IPv6Protocol.c        |    4 +-
 drivers/staging/bcm/InterfaceDld.c        |    6 +-
 drivers/staging/bcm/InterfaceIdleMode.c   |    2 +-
 drivers/staging/bcm/InterfaceIdleMode.h   |    2 +-
 drivers/staging/bcm/InterfaceInit.c       |   26 +++---
 drivers/staging/bcm/Ioctl.h               |    8 +-
 drivers/staging/bcm/LeakyBucket.c         |    2 +-
 drivers/staging/bcm/Misc.c                |   18 ++--
 drivers/staging/bcm/PHSModule.c           |    2 +-
 drivers/staging/bcm/Prototypes.h          |    3 +-
 drivers/staging/bcm/Qos.c                 |    8 +-
 drivers/staging/bcm/led_control.c         |   22 ++--
 drivers/staging/bcm/nvm.c                 |   54 +++++-----
 19 files changed, 160 insertions(+), 161 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index a7c0ce9..742ddeb 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -652,7 +652,7 @@ typedef struct _ETH_HEADER_STRUC ETH_HEADER_STRUC, *PETH_HEADER_STRUC;
 
 typedef struct FirmwareInfo
 {
-	PVOID		pvMappedFirmwareAddress;
+	void __user *	pvMappedFirmwareAddress;
 	ULONG		u32FirmwareLength;
 	ULONG		u32StartingAddress;
 }__attribute__((packed)) FIRMWARE_INFO, *PFIRMWARE_INFO;
diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 2248ae5..38d21eb 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -156,9 +156,10 @@ static ssize_t bcm_char_read(struct file *filp, char __user *buf, size_t size, l
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
     PPER_TARANG_DATA  pTarang = (PPER_TARANG_DATA)filp->private_data;
+	void __user *argp = (void __user *)argp;
 	PMINI_ADAPTER 	Adapter = pTarang->Adapter;
 	INT  			Status = STATUS_FAILURE;
-	IOCTL_BUFFER 	IoBuffer={0};
+	IOCTL_BUFFER 	IoBuffer={};
 #ifndef BCM_SHM_INTERFACE
     int timeout = 0;
 #endif
@@ -169,9 +170,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 	if(_IOC_TYPE(cmd) != BCM_IOCTL)
 		return -EFAULT;
 	if(_IOC_DIR(cmd) & _IOC_READ)
-		Status = !access_ok(VERIFY_WRITE, (PVOID)arg, _IOC_SIZE(cmd));
+		Status = !access_ok(VERIFY_WRITE, argp, _IOC_SIZE(cmd));
 	else if (_IOC_DIR(cmd) & _IOC_WRITE)
-	    Status = !access_ok(VERIFY_READ, (PVOID)arg, _IOC_SIZE(cmd));
+	    Status = !access_ok(VERIFY_READ, argp, _IOC_SIZE(cmd));
 	else if (_IOC_NONE == (_IOC_DIR(cmd) & _IOC_NONE))
 	    Status = STATUS_SUCCESS;
 
@@ -215,7 +216,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			PCHAR temp_buff = NULL;
 			UINT Bufflen = 0;
 			/* Copy Ioctl Buffer structure */
-			if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg,
+			if(copy_from_user((PCHAR)&IoBuffer, argp,
 				sizeof(IOCTL_BUFFER)))
 			{
 				Status = -EFAULT;
@@ -241,7 +242,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				bcm_kfree(temp_buff);
 				return Status;
 			}
-			if(copy_to_user((PCHAR)IoBuffer.OutputBuffer,
+			if(copy_to_user(IoBuffer.OutputBuffer,
 				(PCHAR)temp_buff, (UINT)IoBuffer.OutputLength))
 			{
 				Status = -EFAULT;
@@ -255,7 +256,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			UINT uiTempVar=0;
 			/* Copy Ioctl Buffer structure */
 
-			if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg,
+			if(copy_from_user(&IoBuffer, argp,
 				sizeof(IOCTL_BUFFER)))
 			{
 				Status = -EFAULT;
@@ -308,7 +309,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				break;
 			}
 			/* Copy Ioctl Buffer structure */
-			if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg,
+			if(copy_from_user(&IoBuffer, argp,
 				sizeof(IOCTL_BUFFER)))
 			{
 				Status = -EFAULT;
@@ -348,7 +349,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				bcm_kfree(temp_buff);
 				return Status;
 			}
-			if(copy_to_user((PCHAR)IoBuffer.OutputBuffer,
+			if(copy_to_user(IoBuffer.OutputBuffer,
 				(PCHAR)temp_buff, (UINT)IoBuffer.OutputLength))
 			{
 				Status = -EFAULT;
@@ -370,7 +371,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				break;
 			}
 			/* Copy Ioctl Buffer structure */
-			if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg,
+			if(copy_from_user((PCHAR)&IoBuffer, argp,
 					sizeof(IOCTL_BUFFER)))
 			{
 				Status = -EFAULT;
@@ -438,7 +439,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				Status = -EACCES;
 				break;
 			}
-			if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER)))
+			if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			{
 				Status = -EFAULT;
 				break;
@@ -528,7 +529,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				Status = -EACCES;
 				break;
 			}
-			Status =copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+			Status =copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 			if(Status)
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Failed while copying the IOBufer from user space err:%d",Status);
@@ -573,7 +574,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				Status = -EACCES;
 				break;
 			}
-			if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER)))
+			if(copy_from_user((PCHAR)&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
             {
             	Status = -EFAULT;
                     break;
@@ -610,7 +611,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					Status = -EINVAL;
 					break;
 				}
-				Status = copy_from_user( (PCHAR)&IoBuffer, ( PCHAR)arg, sizeof( IOCTL_BUFFER));
+				Status = copy_from_user( (PCHAR)&IoBuffer, argp, sizeof( IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Failed while copying the IOBufer from user space err:%d",Status);
@@ -678,7 +679,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 											pgpio_multi_info[WIMAX_IDX].uiGPIOMask);
 				}
 
-				Status = copy_to_user( (PCHAR)IoBuffer.OutputBuffer, &gpio_multi_info, IoBuffer.OutputLength);
+				Status = copy_to_user(IoBuffer.OutputBuffer, &gpio_multi_info, IoBuffer.OutputLength);
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Failed while copying Content to IOBufer for user space err:%d",Status);
@@ -699,7 +700,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					Status = -EINVAL;
 					break;
 			}
-			Status = copy_from_user( (PCHAR)&IoBuffer, ( PCHAR)arg, sizeof( IOCTL_BUFFER));
+			Status = copy_from_user(&IoBuffer, argp, sizeof( IOCTL_BUFFER));
 			if(Status)
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Failed while copying the IOBufer from user space err:%d",Status);
@@ -758,7 +759,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			{
 				pgpio_multi_mode[WIMAX_IDX].uiGPIOMode = *( UINT*) ucResetValue;
 			}
-			Status = copy_to_user( (PCHAR)IoBuffer.OutputBuffer, &gpio_multi_mode, IoBuffer.OutputLength);
+			Status = copy_to_user(IoBuffer.OutputBuffer, &gpio_multi_mode, IoBuffer.OutputLength);
 			if(Status)
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Failed while copying Content to IOBufer for user space err:%d",Status);
@@ -776,7 +777,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		{
 			PVOID pvBuffer=NULL;
 			/* Copy Ioctl Buffer structure */
-			if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg,
+			if(copy_from_user(&IoBuffer, argp,
 							sizeof(IOCTL_BUFFER)))
 			{
 				Status = -EFAULT;
@@ -864,8 +865,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					break;
 				}
 				/* Copy Ioctl Buffer structure */
-				if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg,
-						sizeof(IOCTL_BUFFER)))
+				if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "copy_from_user 1 failed\n");
 					Status = -EFAULT;
@@ -1037,7 +1037,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			break;
 
 		case IOCTL_GET_PACK_INFO:
-			if(copy_to_user((PCHAR)arg, &Adapter->PackInfo,
+			if(copy_to_user(argp, &Adapter->PackInfo,
 				sizeof(PacketInfo)*NO_OF_QUEUES))
 			{
 				Status = -EFAULT;
@@ -1048,7 +1048,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		case IOCTL_BCM_SWITCH_TRANSFER_MODE:
 		{
 			UINT uiData = 0;
-			if(copy_from_user(&uiData, (PUINT)arg, sizeof(UINT)))
+			if(copy_from_user(&uiData, argp, sizeof(UINT)))
 			{
 				Status = -EFAULT;
 				break;
@@ -1070,13 +1070,12 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		case IOCTL_BCM_GET_DRIVER_VERSION:
 		{
 			/* Copy Ioctl Buffer structure */
-			if(copy_from_user((PCHAR)&IoBuffer,
-					(PCHAR)arg, sizeof(IOCTL_BUFFER)))
+			if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			{
 				Status = -EFAULT;
 				break;
 			}
-			if(copy_to_user((PUCHAR)IoBuffer.OutputBuffer,
+			if(copy_to_user(IoBuffer.OutputBuffer,
 				VER_FILEVERSION_STR, (UINT)IoBuffer.OutputLength))
 			{
 				Status = -EFAULT;
@@ -1089,8 +1088,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		{
 			LINK_STATE *plink_state = NULL;
 			/* Copy Ioctl Buffer structure */
-			if(copy_from_user((PCHAR)&IoBuffer,
-					(PCHAR)arg, sizeof(IOCTL_BUFFER)))
+			if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "copy_from_user failed..\n");
 				Status = -EFAULT;
@@ -1100,7 +1098,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			plink_state->bIdleMode = (UCHAR)Adapter->IdleMode;
 			plink_state->bShutdownMode = Adapter->bShutStatus;
 			plink_state->ucLinkStatus = (UCHAR)Adapter->LinkStatus;
-			if(copy_to_user((PUCHAR)IoBuffer.OutputBuffer,
+			if(copy_to_user(IoBuffer.OutputBuffer,
 				(PUCHAR)plink_state, (UINT)IoBuffer.OutputLength))
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy_to_user Failed..\n");
@@ -1114,14 +1112,12 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
         {
             UINT  tracing_flag;
             /* copy ioctl Buffer structure */
-			if(copy_from_user((PCHAR)&IoBuffer,
-				(PCHAR)arg, sizeof(IOCTL_BUFFER)))
+			if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			{
 				Status = -EFAULT;
 				break;
 			}
-			if(copy_from_user((PCHAR)&tracing_flag,
-                     (PCHAR)IoBuffer.InputBuffer,sizeof(UINT)))
+			if(copy_from_user(&tracing_flag, IoBuffer.InputBuffer,sizeof(UINT)))
             {
 				Status = -EFAULT;
 				break;
@@ -1135,7 +1131,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		case IOCTL_BCM_GET_DSX_INDICATION:
 		{
 			ULONG ulSFId=0;
-			if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg,
+			if(copy_from_user((PCHAR)&IoBuffer, argp,
 					sizeof(IOCTL_BUFFER)))
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Invalid IO buffer!!!" );
@@ -1148,7 +1144,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					IoBuffer.OutputLength, sizeof(stLocalSFAddIndicationAlt));
 				return -EINVAL;
 			}
-			if(copy_from_user((PCHAR)&ulSFId, (PCHAR)IoBuffer.InputBuffer,
+			if(copy_from_user(&ulSFId, IoBuffer.InputBuffer,
 					sizeof(ulSFId)))
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Invalid SFID!!! %lu", ulSFId );
@@ -1165,8 +1161,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		{
 			PCHAR temp_buff;
 
-			if(copy_from_user((PCHAR)&IoBuffer,
-					(PCHAR)arg, sizeof(IOCTL_BUFFER)))
+			if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy_from user for IoBuff failed\n");
 				Status = -EFAULT;
@@ -1193,7 +1188,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 	        Status = GetDroppedAppCntrlPktMibs((PVOID)temp_buff,
 									(PPER_TARANG_DATA)filp->private_data);
 
-			if(copy_to_user((PCHAR)IoBuffer.OutputBuffer,(PCHAR)temp_buff,
+			if(copy_to_user(IoBuffer.OutputBuffer,(PCHAR)temp_buff,
 				sizeof(S_MIBS_HOST_STATS_MIBS)))
 			{
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy to user failed\n");
@@ -1234,7 +1229,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					break;
 				}
 				/* Copy Ioctl Buffer structure */
-				if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER)))
+				if(copy_from_user((PCHAR)&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 				{
 					Status = -EFAULT;
 					break;
@@ -1298,8 +1293,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		case IOCTL_BCM_GET_NVM_SIZE:
 			{
 
-			if(copy_from_user((unsigned char *)&IoBuffer,
-					(unsigned char *)arg, sizeof(IOCTL_BUFFER)))
+			if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			{
 				//IOLog("failed NVM first");
 				Status = -EFAULT;
@@ -1324,13 +1318,13 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				UINT uiSectorSize = 0 ;
 				if(Adapter->eNVMType == NVM_FLASH)
 				{
-					Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+					Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 					if(Status)
 					{
 						BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Copy From User space failed. status :%d", Status);
 						return Status;
 					}
-					uiSectorSize = *((PUINT)(IoBuffer.InputBuffer));
+					uiSectorSize = *((PUINT)(IoBuffer.InputBuffer)); /* FIXME: unchecked __user access */
 					if((uiSectorSize < MIN_SECTOR_SIZE) || (uiSectorSize > MAX_SECTOR_SIZE))
 					{
 
@@ -1385,13 +1379,13 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 //				BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "Entered the ioctl %x \n", IOCTL_BCM_SET_DEBUG );
 
 				BCM_DEBUG_PRINT (Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "In SET_DEBUG ioctl\n");
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user((PCHAR)&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy from user failed\n");
 					break;
 				}
-				Status = copy_from_user(&sUserDebugState,(USER_BCM_DBG_STATE *)IoBuffer.InputBuffer, sizeof(USER_BCM_DBG_STATE));
+				Status = copy_from_user(&sUserDebugState,IoBuffer.InputBuffer, sizeof(USER_BCM_DBG_STATE));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0,  "Copy of IoBuffer.InputBuffer failed");
@@ -1424,9 +1418,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		case IOCTL_BCM_NVM_WRITE:
 			{
 
-				NVM_READWRITE  stNVMReadWrite = {0};
+				NVM_READWRITE  stNVMReadWrite = {};
 				PUCHAR pReadData = NULL;
-				PUCHAR pBuffertobeCopied = NULL;
+				void __user * pBuffertobeCopied = NULL;
 				ULONG ulDSDMagicNumInUsrBuff = 0 ;
 				struct timeval tv0, tv1;
 				memset(&tv0,0,sizeof(struct timeval));
@@ -1451,7 +1445,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 
 			/* Copy Ioctl Buffer structure */
 
-				if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER)))
+				if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"copy_from_user failed\n");
                     Status = -EFAULT;
@@ -1519,8 +1513,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 							bcm_kfree(pReadData);
 							return Status;
 						}
-					if(copy_to_user((PCHAR)stNVMReadWrite.pBuffer,
-							(PCHAR)pReadData, (UINT)stNVMReadWrite.uiNumBytes))
+					if(copy_to_user(stNVMReadWrite.pBuffer,
+							pReadData, (UINT)stNVMReadWrite.uiNumBytes))
 						{
 							bcm_kfree(pReadData);
 							Status = -EFAULT;
@@ -1612,7 +1606,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				UINT BuffSize = 0;
 				UINT ReadBytes = 0;
 				UINT ReadOffset = 0;
-				PUCHAR OutPutBuff = NULL;
+				char __user *OutPutBuff = NULL;
 
 				if(IsFlash2x(Adapter) != TRUE)
 				{
@@ -1621,7 +1615,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				}
 
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_FLASH2X_SECTION_READ Called");
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
@@ -1629,7 +1623,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				}
 
 				//Reading FLASH 2.x READ structure
-				Status = copy_from_user((PUCHAR)&sFlash2xRead, (PUCHAR)IoBuffer.InputBuffer,sizeof(FLASH2X_READWRITE));
+				Status = copy_from_user(&sFlash2xRead, IoBuffer.InputBuffer,sizeof(FLASH2X_READWRITE));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of Input Buffer failed");
@@ -1653,7 +1647,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					BuffSize = NOB ;
 
 				ReadOffset = sFlash2xRead.offset ;
-				OutPutBuff = (PUCHAR)(IoBuffer.OutputBuffer) ;
+				OutPutBuff = IoBuffer.OutputBuffer;
 
 
 				pReadBuff = (PCHAR)kzalloc(BuffSize , GFP_KERNEL);
@@ -1717,7 +1711,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			 {
 			 	FLASH2X_READWRITE sFlash2xWrite = {0};
 				PUCHAR pWriteBuff = NULL;
-				PUCHAR InputAddr = NULL;
+				void __user *InputAddr = NULL;
 				UINT NOB = 0;
 				UINT BuffSize = 0;
 				UINT WriteOffset = 0;
@@ -1734,7 +1728,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 
 
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, " IOCTL_BCM_FLASH2X_SECTION_WRITE Called");
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
@@ -1742,7 +1736,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				}
 
 				//Reading FLASH 2.x READ structure
-				Status = copy_from_user((PCHAR)&sFlash2xWrite, (PCHAR)IoBuffer.InputBuffer, sizeof(FLASH2X_READWRITE));
+				Status = copy_from_user(&sFlash2xWrite, IoBuffer.InputBuffer, sizeof(FLASH2X_READWRITE));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Reading of output Buffer from IOCTL buffer fails");
@@ -1771,7 +1765,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				if(validateFlash2xReadWrite(Adapter,&sFlash2xWrite) == FALSE)
 					return STATUS_FAILURE ;
 
-				InputAddr = (PCHAR)(sFlash2xWrite.pDataBuff) ;
+				InputAddr = sFlash2xWrite.pDataBuff;
 				WriteOffset = sFlash2xWrite.offset ;
 				NOB = sFlash2xWrite.numOfBytes;
 
@@ -1849,7 +1843,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 			 	PFLASH2X_BITMAP psFlash2xBitMap = NULL ;
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP Called");
 
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
@@ -1882,7 +1876,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 
 				BcmGetFlash2xSectionalBitMap(Adapter, psFlash2xBitMap);
 				up(&Adapter->NVMRdmWrmLock);
-				Status = copy_to_user((PCHAR)IoBuffer.OutputBuffer, (PCHAR)psFlash2xBitMap, sizeof(FLASH2X_BITMAP));
+				Status = copy_to_user(IoBuffer.OutputBuffer, psFlash2xBitMap, sizeof(FLASH2X_BITMAP));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "copying Flash2x bitMap failed");
@@ -1903,14 +1897,14 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					return -EINVAL;
 				}
 
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
 					return Status;
 				}
 
-				Status = copy_from_user((PCHAR)&eFlash2xSectionVal,(PCHAR)IoBuffer.InputBuffer, sizeof(INT));
+				Status = copy_from_user(&eFlash2xSectionVal,IoBuffer.InputBuffer, sizeof(INT));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of flash section val failed");
@@ -1981,14 +1975,14 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					return -EINVAL;
 				}
 
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed Status :%d", Status);
 					return Status;
 				}
 
-				Status = copy_from_user((PCHAR)&sCopySectStrut,(PCHAR)IoBuffer.InputBuffer, sizeof(FLASH2X_COPY_SECTION));
+				Status = copy_from_user(&sCopySectStrut,IoBuffer.InputBuffer, sizeof(FLASH2X_COPY_SECTION));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of Copy_Section_Struct failed with Status :%d", Status);
@@ -2059,7 +2053,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				Status = STATUS_SUCCESS;
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, " IOCTL_BCM_GET_FLASH_CS_INFO Called");
 
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
@@ -2081,7 +2075,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 						break;
 					}
 
-					Status = copy_to_user((PCHAR)IoBuffer.OutputBuffer, (PCHAR)Adapter->psFlash2xCSInfo, sizeof(FLASH2X_CS_INFO));
+					Status = copy_to_user(IoBuffer.OutputBuffer, Adapter->psFlash2xCSInfo, sizeof(FLASH2X_CS_INFO));
 					if(Status)
 					{
 						BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "copying Flash2x cs info failed");
@@ -2096,7 +2090,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 						Status = -EINVAL;
 						break;
 					}
-					Status = copy_to_user((PCHAR)IoBuffer.OutputBuffer, (PCHAR)Adapter->psFlashCSInfo, sizeof(FLASH_CS_INFO));
+					Status = copy_to_user(IoBuffer.OutputBuffer, Adapter->psFlashCSInfo, sizeof(FLASH_CS_INFO));
 					if(Status)
 					{
 						BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "copying Flash CS info failed");
@@ -2119,13 +2113,13 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					return -EINVAL;
 				}
 
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
 					return Status;
 				}
-				Status = copy_from_user((PCHAR)&eFlash2xSectionVal,(PCHAR)IoBuffer.InputBuffer, sizeof(INT));
+				Status = copy_from_user(&eFlash2xSectionVal,IoBuffer.InputBuffer, sizeof(INT));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of flash section val failed");
@@ -2159,13 +2153,13 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		case IOCTL_BCM_NVM_RAW_READ :
 			 {
 
-				NVM_READWRITE  stNVMRead = {0};
+				NVM_READWRITE  stNVMRead = {};
 				INT NOB ;
 				INT BuffSize ;
 				INT ReadOffset = 0;
 				UINT ReadBytes = 0 ;
 				PUCHAR pReadBuff = NULL ;
-				PUCHAR OutPutBuff = NULL ;
+				char __user *OutPutBuff = NULL ;
 
 				if(Adapter->eNVMType != NVM_FLASH)
 				{
@@ -2174,14 +2168,14 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				}
 
 				/* Copy Ioctl Buffer structure */
-				if(copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER)))
+				if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "copy_from_user 1 failed\n");
 					Status = -EFAULT;
 					break;
 				}
 
-				if(copy_from_user(&stNVMRead, (PUCHAR)IoBuffer.OutputBuffer,sizeof(NVM_READWRITE)))
+				if(copy_from_user(&stNVMRead, IoBuffer.OutputBuffer,sizeof(NVM_READWRITE)))
 				{
 					Status = -EFAULT;
 					break;
@@ -2196,7 +2190,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					BuffSize = NOB ;
 
 				ReadOffset = stNVMRead.uiOffset ;
-				OutPutBuff = (PUCHAR)(stNVMRead.pBuffer) ;
+				OutPutBuff = stNVMRead.pBuffer;
 
 
 				pReadBuff = (PCHAR)kzalloc(BuffSize , GFP_KERNEL);
@@ -2261,7 +2255,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				ULONG RxCntrlMsgBitMask = 0 ;
 
 				/* Copy Ioctl Buffer structure */
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,"copy of Ioctl buffer is failed from user space");
@@ -2290,7 +2284,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				DevInfo.u32NVMType = Adapter->eNVMType;
 				DevInfo.u32InterfaceType = BCM_USB;
 
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
@@ -2303,7 +2297,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 					Status = -EINVAL;
 					break;
 				}
-				Status = copy_to_user((PCHAR)IoBuffer.OutputBuffer, (PCHAR)&DevInfo, sizeof(DevInfo));
+				Status = copy_to_user(IoBuffer.OutputBuffer, &DevInfo, sizeof(DevInfo));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"copying Dev info structure to user space buffer failed");
@@ -2319,7 +2313,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,"IOCTL_BCM_TIME_SINCE_NET_ENTRY called");
 
-				Status = copy_from_user((PCHAR)&IoBuffer, (PCHAR)arg, sizeof(IOCTL_BUFFER));
+				Status = copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy of IOCTL BUFFER failed");
@@ -2336,7 +2330,7 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				do_gettimeofday(&tv);
 				stTimeElapsedSinceNetEntry.ul64TimeElapsedSinceNetEntry = tv.tv_sec - Adapter->liTimeSinceLastNetEntry;
 
-				Status = copy_to_user((PCHAR)IoBuffer.OutputBuffer, (PCHAR)&stTimeElapsedSinceNetEntry, sizeof(ST_TIME_ELAPSED));
+				Status = copy_to_user(IoBuffer.OutputBuffer, &stTimeElapsedSinceNetEntry, sizeof(ST_TIME_ELAPSED));
 				if(Status)
 				{
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"copying ST_TIME_ELAPSED structure to user space buffer failed");
diff --git a/drivers/staging/bcm/Bcmnet.c b/drivers/staging/bcm/Bcmnet.c
index c619f91..bb9260c 100644
--- a/drivers/staging/bcm/Bcmnet.c
+++ b/drivers/staging/bcm/Bcmnet.c
@@ -111,7 +111,7 @@ static struct net_device_stats *bcm_get_stats(struct net_device *dev)
 Register other driver entry points with the kernel
 */
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 29)
-struct net_device_ops bcmNetDevOps = {
+static struct net_device_ops bcmNetDevOps = {
     .ndo_open		= bcm_open,
     .ndo_stop 		= bcm_close,
     .ndo_get_stats 	= bcm_get_stats,
diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index f8e9e32..0329f7d 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1014,7 +1014,7 @@ static VOID CopyToAdapter( register PMINI_ADAPTER Adapter,		/**<Pointer to the A
 *
 * Returns	  - None
 *************************************************************************/
-VOID DumpCmControlPacket(PVOID pvBuffer)
+static VOID DumpCmControlPacket(PVOID pvBuffer)
 {
 	UINT 					uiLoopIndex;
 	UINT                    nIndex;
@@ -2362,7 +2362,7 @@ BOOLEAN CmControlResponseMessage(PMINI_ADAPTER Adapter,  /**<Pointer to the Adap
 	return TRUE;
 }
 
-int get_dsx_sf_data_to_application(PMINI_ADAPTER Adapter, UINT uiSFId, PUCHAR user_buffer)
+int get_dsx_sf_data_to_application(PMINI_ADAPTER Adapter, UINT uiSFId, void __user *user_buffer)
 {
 	int status = 0;
 	struct _packet_info *psSfInfo=NULL;
@@ -2375,8 +2375,8 @@ int get_dsx_sf_data_to_application(PMINI_ADAPTER Adapter, UINT uiSFId, PUCHAR us
 	}
 	BCM_DEBUG_PRINT( Adapter,DBG_TYPE_OTHERS, CONN_MSG, DBG_LVL_ALL, "status =%d",status);
 	psSfInfo=&Adapter->PackInfo[status];
-	if(psSfInfo->pstSFIndication && copy_to_user((PCHAR)user_buffer,
-		(PCHAR)psSfInfo->pstSFIndication, sizeof(stLocalSFAddIndicationAlt)))
+	if(psSfInfo->pstSFIndication && copy_to_user(user_buffer,
+		psSfInfo->pstSFIndication, sizeof(stLocalSFAddIndicationAlt)))
 	{
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "copy to user failed SFID %d, present in queue !!!", uiSFId );
 		status = -EFAULT;
diff --git a/drivers/staging/bcm/Debug.c b/drivers/staging/bcm/Debug.c
index d01eb12..2703f30 100644
--- a/drivers/staging/bcm/Debug.c
+++ b/drivers/staging/bcm/Debug.c
@@ -3,7 +3,7 @@
 static UINT current_debug_level=BCM_SCREAM;
 
 int bcm_print_buffer( UINT debug_level, const char *function_name,
-				  char *file_name, int line_number, unsigned char *buffer, int bufferlen, unsigned int base)
+				  char *file_name, int line_number, unsigned char *buffer, int bufferlen, enum _BASE_TYPE base)
 {
 	static const char * const buff_dump_base[] = {
 		"DEC", "HEX", "OCT", "BIN"
diff --git a/drivers/staging/bcm/HandleControlPacket.c b/drivers/staging/bcm/HandleControlPacket.c
index 8499513..7b2ec28 100644
--- a/drivers/staging/bcm/HandleControlPacket.c
+++ b/drivers/staging/bcm/HandleControlPacket.c
@@ -223,7 +223,7 @@ int control_packet_handler  (PMINI_ADAPTER Adapter  /**< pointer to adapter obje
 	return STATUS_SUCCESS;
 }
 
-INT flushAllAppQ()
+INT flushAllAppQ(void)
 {
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	PPER_TARANG_DATA	pTarang = NULL;
diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index cb4ca9a..5ec3b89 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -1,6 +1,6 @@
 #include "headers.h"
 
-UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader,BOOLEAN *bParseDone,USHORT *pusPayloadLength)
+static UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader,BOOLEAN *bParseDone,USHORT *pusPayloadLength)
 {
 	UCHAR *pucRetHeaderPtr = NULL;
 	UCHAR *pucPayloadPtr = NULL;
@@ -130,7 +130,7 @@ UCHAR * GetNextIPV6ChainedHeader(UCHAR **ppucPayload,UCHAR *pucNextHeader,BOOLEA
 }
 
 
-UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload,USHORT *pusSrcPort,USHORT *pusDestPort,USHORT usPayloadLength,UCHAR ucNextHeader)
+static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload,USHORT *pusSrcPort,USHORT *pusDestPort,USHORT usPayloadLength,UCHAR ucNextHeader)
 {
 	UCHAR *pIpv6HdrScanContext = pucPayload;
 	BOOLEAN bDone = FALSE;
diff --git a/drivers/staging/bcm/InterfaceDld.c b/drivers/staging/bcm/InterfaceDld.c
index f9761db..8825b8e 100644
--- a/drivers/staging/bcm/InterfaceDld.c
+++ b/drivers/staging/bcm/InterfaceDld.c
@@ -22,7 +22,7 @@ int InterfaceFileDownload( PVOID arg,
     while(1)
     {
         oldfs=get_fs(); set_fs(get_ds());
-        len=vfs_read(flp, buff, MAX_TRANSFER_CTRL_BYTE_USB, &pos);
+        len=vfs_read(flp, (void __force __user *)buff, MAX_TRANSFER_CTRL_BYTE_USB, &pos);
         set_fs(oldfs);
         if(len<=0)
         {
@@ -83,7 +83,7 @@ int InterfaceFileReadbackFromChip( PVOID arg,
     while(1)
     {
         oldfs=get_fs(); set_fs(get_ds());
-        len=vfs_read(flp, buff, MAX_TRANSFER_CTRL_BYTE_USB, &pos);
+        len=vfs_read(flp, (void __force __user *)buff, MAX_TRANSFER_CTRL_BYTE_USB, &pos);
         set_fs(oldfs);
         fw_down++;
         if(len<=0)
@@ -381,7 +381,7 @@ int bcm_ioctl_fw_download(PMINI_ADAPTER Adapter, FIRMWARE_INFO *psFwInfo)
 			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL,"Failed in allocation memory");
 			return -ENOMEM;
 		}
-		retval = copy_from_user(buff,(PUCHAR)psFwInfo->pvMappedFirmwareAddress, psFwInfo->u32FirmwareLength);
+		retval = copy_from_user(buff,psFwInfo->pvMappedFirmwareAddress, psFwInfo->u32FirmwareLength);
 		if(retval != STATUS_SUCCESS)
 		{
 			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "copying buffer from user space failed");
diff --git a/drivers/staging/bcm/InterfaceIdleMode.c b/drivers/staging/bcm/InterfaceIdleMode.c
index d99fc7c..0750382 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -42,7 +42,7 @@ send to f/w with in 200 ms after the Idle/Shutdown req issued
 */
 
 
-int InterfaceIdleModeRespond(PMINI_ADAPTER Adapter,int* puiBuffer)
+int InterfaceIdleModeRespond(PMINI_ADAPTER Adapter, unsigned int* puiBuffer)
 {
 	int	status = STATUS_SUCCESS;
 	unsigned int	uiRegRead = 0;
diff --git a/drivers/staging/bcm/InterfaceIdleMode.h b/drivers/staging/bcm/InterfaceIdleMode.h
index f87c132..1bc723d 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.h
+++ b/drivers/staging/bcm/InterfaceIdleMode.h
@@ -3,7 +3,7 @@
 
 INT InterfaceIdleModeWakeup(PMINI_ADAPTER Adapter);
 
-INT InterfaceIdleModeRespond(PMINI_ADAPTER Adapter,PINT puiBuffer);
+INT InterfaceIdleModeRespond(PMINI_ADAPTER Adapter, unsigned int *puiBuffer);
 
 VOID InterfaceWriteIdleModeWakePattern(PMINI_ADAPTER Adapter);
 
diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index 8bf900b..81523b1 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -68,12 +68,12 @@ static int usbbcm_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t usbbcm_read(struct file *file, char *buffer, size_t count, loff_t *ppos)
+static ssize_t usbbcm_read(struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
 	return 0;
 }
 
-static ssize_t usbbcm_write(struct file *file, const char *user_buffer, size_t count, loff_t *ppos)
+static ssize_t usbbcm_write(struct file *file, const char __user *user_buffer, size_t count, loff_t *ppos)
 {
 	return 0;
 }
@@ -188,14 +188,12 @@ usbbcm_device_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	}
 
 	/* Allocate Adapter structure */
-	if((psAdapter = kmalloc(sizeof(MINI_ADAPTER), GFP_KERNEL)) == NULL)
+	if((psAdapter = kzalloc(sizeof(MINI_ADAPTER), GFP_KERNEL)) == NULL)
 	{
-		//BCM_DEBUG_PRINT(psAdapter,DBG_TYPE_PRINTK, 0, 0, "Out of memory");
+		BCM_DEBUG_PRINT(psAdapter,DBG_TYPE_PRINTK, 0, 0, "Out of memory");
 		return -ENOMEM;
 	}
 
-	memset(psAdapter, 0, sizeof(MINI_ADAPTER));
-
     /* Init default driver debug state */
 
     psAdapter->stDebugState.debug_level = DBG_LVL_CURR;
@@ -618,9 +616,9 @@ INT InterfaceAdapterInit(PS_INTERFACE_ADAPTER psIntfAdapter)
 				if((psIntfAdapter->bHighSpeedDevice == FALSE) && bcm_usb_endpoint_is_bulk_out(endpoint))
 				{
 					// Once BULK is selected in FS mode. Revert it back to INT. Else USB_IF will fail.
-					UINT uiData = ntohl(EP2_CFG_INT);
+					UINT _uiData = ntohl(EP2_CFG_INT);
 					BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL,"Reverting Bulk to INT as it is FS MODE");
-					BeceemEEPROMBulkWrite(psIntfAdapter->psAdapter,(PUCHAR)&uiData,0x136,4,TRUE);
+					BeceemEEPROMBulkWrite(psIntfAdapter->psAdapter,(PUCHAR)&_uiData,0x136,4,TRUE);
 				}
 			}
 			else
@@ -773,7 +771,8 @@ INT InterfaceAdapterInit(PS_INTERFACE_ADAPTER psIntfAdapter)
 
 	return 0;
 }
-int InterfaceSuspend (struct usb_interface *intf, pm_message_t message)
+
+static int InterfaceSuspend (struct usb_interface *intf, pm_message_t message)
 {
 	PS_INTERFACE_ADAPTER  psIntfAdapter = usb_get_intfdata(intf);
 	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "=================================\n");
@@ -802,7 +801,8 @@ int InterfaceSuspend (struct usb_interface *intf, pm_message_t message)
 
 	return 0;
 }
-int InterfaceResume (struct usb_interface *intf)
+
+static int InterfaceResume (struct usb_interface *intf)
 {
     PS_INTERFACE_ADAPTER  psIntfAdapter = usb_get_intfdata(intf);
 	printk("=================================\n");
@@ -816,12 +816,14 @@ int InterfaceResume (struct usb_interface *intf)
 	InterfaceRx(psIntfAdapter);
 	return 0;
 }
-int InterfacePreReset(struct usb_interface *intf)
+
+static int InterfacePreReset(struct usb_interface *intf)
 {
     printk("====================>");
 	return STATUS_SUCCESS;
 }
-int InterfacePostReset(struct usb_interface *intf)
+
+static int InterfacePostReset(struct usb_interface *intf)
 {
     printk("Do Post chip reset setting here if it is required");
    	return STATUS_SUCCESS;
diff --git a/drivers/staging/bcm/Ioctl.h b/drivers/staging/bcm/Ioctl.h
index 2651fc2..e4f8eb7 100644
--- a/drivers/staging/bcm/Ioctl.h
+++ b/drivers/staging/bcm/Ioctl.h
@@ -18,9 +18,9 @@ typedef struct wrmbuffer
 
 typedef struct ioctlbuffer
 {
-	PVOID	InputBuffer;
+	void __user *InputBuffer;
 	ULONG	InputLength;
-	PVOID	OutputBuffer;
+	void __user *OutputBuffer;
 	ULONG	OutputLength;
 }__attribute__((packed)) IOCTL_BUFFER, *PIOCTL_BUFFER;
 
@@ -209,7 +209,7 @@ typedef struct _DEVICE_DRIVER_INFO
 typedef  struct _NVM_READWRITE
 {
 
-	void *pBuffer;
+	void __user *pBuffer;
 // Data to be written from|read to. Memory should be allocated by the caller.
 
 	uint32_t  uiOffset;
@@ -269,7 +269,7 @@ typedef struct _FLASH2X_READWRITE
 	B_UINT32 offset;		//Offset within Section.
 	B_UINT32 numOfBytes;	//NOB from the offset
 	B_UINT32  bVerify;
-	PVOID pDataBuff;	//Buffer for reading/writing
+	void __user *pDataBuff;	//Buffer for reading/writing
 
 }FLASH2X_READWRITE, *PFLASH2X_READWRITE;
 /*
diff --git a/drivers/staging/bcm/LeakyBucket.c b/drivers/staging/bcm/LeakyBucket.c
index b407938..cae3823 100644
--- a/drivers/staging/bcm/LeakyBucket.c
+++ b/drivers/staging/bcm/LeakyBucket.c
@@ -15,7 +15,7 @@
 * Returns     - None
 **********************************************************************/
 
-VOID UpdateTokenCount(register PMINI_ADAPTER Adapter)
+static VOID UpdateTokenCount(register PMINI_ADAPTER Adapter)
 {
 	ULONG 	liCurrentTime;
 	INT 	i = 0;
diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index 994132f..22550f7 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -503,6 +503,7 @@ INT CopyBufferToControlPacket(PMINI_ADAPTER Adapter,/**<Logical Adapter*/
 	return Status;
 }
 
+#if 0
 /*****************************************************************
 * Function    - SendStatisticsPointerRequest()
 *
@@ -514,7 +515,7 @@ INT CopyBufferToControlPacket(PMINI_ADAPTER Adapter,/**<Logical Adapter*/
 *
 * Returns     - None.
 *****************************************************************/
-VOID SendStatisticsPointerRequest(PMINI_ADAPTER Adapter,
+static VOID SendStatisticsPointerRequest(PMINI_ADAPTER Adapter,
 								PLINK_REQUEST	pstStatisticsPtrRequest)
 {
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "======>");
@@ -526,7 +527,7 @@ VOID SendStatisticsPointerRequest(PMINI_ADAPTER Adapter,
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "<=====");
 	return;
 }
-
+#endif
 
 
 void SendLinkDown(PMINI_ADAPTER Adapter)
@@ -1379,7 +1380,7 @@ int bcm_parse_target_params(PMINI_ADAPTER Adapter)
 		return -ENOENT;
 	}
 	oldfs=get_fs();	set_fs(get_ds());
-	len=vfs_read(flp, buff, BUFFER_1K, &pos);
+	len=vfs_read(flp, (void __user __force *)buff, BUFFER_1K, &pos);
 	set_fs(oldfs);
 
 	if(len != sizeof(STARGETPARAMS))
@@ -1535,7 +1536,9 @@ VOID doPowerAutoCorrection(PMINI_ADAPTER psAdapter)
 		BCM_DEBUG_PRINT(psAdapter,DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL,"Using Forced User Choice: %lx\n", psAdapter->ulPowerSaveMode);
 	}
 }
-unsigned char *ReadMacAddrEEPROM(PMINI_ADAPTER Adapter, ulong dwAddress)
+
+#if 0
+static unsigned char *ReadMacAddrEEPROM(PMINI_ADAPTER Adapter, ulong dwAddress)
 {
 	unsigned char *pucmacaddr = NULL;
 	int status = 0, i=0;
@@ -1575,6 +1578,7 @@ unsigned char *ReadMacAddrEEPROM(PMINI_ADAPTER Adapter, ulong dwAddress)
 OUT:
 	return pucmacaddr;
 }
+#endif
 
 #if 0
 INT ReadMacAddressFromEEPROM(PMINI_ADAPTER Adapter)
@@ -1614,7 +1618,7 @@ INT ReadMacAddressFromEEPROM(PMINI_ADAPTER Adapter)
 }
 #endif
 
-void convertEndian(B_UINT8 rwFlag, PUINT puiBuffer, UINT uiByteCount)
+static void convertEndian(B_UINT8 rwFlag, PUINT puiBuffer, UINT uiByteCount)
 {
 	UINT uiIndex = 0;
 
@@ -1814,7 +1818,7 @@ exit:
 }
 
 
-VOID HandleShutDownModeWakeup(PMINI_ADAPTER Adapter)
+static VOID HandleShutDownModeWakeup(PMINI_ADAPTER Adapter)
 {
 	int clear_abort_pattern = 0,Status = 0;
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, MP_SHUTDOWN, DBG_LVL_ALL, "====>\n");
@@ -1844,7 +1848,7 @@ VOID HandleShutDownModeWakeup(PMINI_ADAPTER Adapter)
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, MP_SHUTDOWN, DBG_LVL_ALL, "<====\n");
 }
 
-VOID SendShutModeResponse(PMINI_ADAPTER Adapter)
+static VOID SendShutModeResponse(PMINI_ADAPTER Adapter)
 {
 	CONTROL_MESSAGE		stShutdownResponse;
 	UINT NVMAccess = 0,lowPwrAbortMsg = 0;
diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSModule.c
index 8ba8489..8a38cf4 100644
--- a/drivers/staging/bcm/PHSModule.c
+++ b/drivers/staging/bcm/PHSModule.c
@@ -1345,7 +1345,7 @@ BOOLEAN DerefPhsRule(IN B_UINT16  uiClsId,S_CLASSIFIER_TABLE *psaClassifiertable
 	}
 }
 
-void DumpBuffer(PVOID BuffVAddress, int xferSize)
+static void DumpBuffer(PVOID BuffVAddress, int xferSize)
 {
 	int i;
 	int iPrintLength;
diff --git a/drivers/staging/bcm/Prototypes.h b/drivers/staging/bcm/Prototypes.h
index 7718937..70ec8bc 100644
--- a/drivers/staging/bcm/Prototypes.h
+++ b/drivers/staging/bcm/Prototypes.h
@@ -108,8 +108,7 @@ int wrmalt (PMINI_ADAPTER Adapter, UINT uiAddress, PUINT pucBuff, size_t sSize);
 
 int rdmalt (PMINI_ADAPTER Adapter, UINT uiAddress, PUINT pucBuff, size_t sSize);
 
-int get_dsx_sf_data_to_application(PMINI_ADAPTER Adapter, UINT uiSFId,
-	PUCHAR user_buffer);
+int get_dsx_sf_data_to_application(PMINI_ADAPTER Adapter, UINT uiSFId, void __user * user_buffer);
 
 void SendLinkDown(PMINI_ADAPTER Adapter);
 
diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 0003825..913a1e1 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -692,7 +692,7 @@ USHORT ClassifyPacket(PMINI_ADAPTER Adapter,struct sk_buff* skb)
 		return INVALID_QUEUE_INDEX;
 }
 
-BOOLEAN EthCSMatchSrcMACAddress(S_CLASSIFIER_RULE *pstClassifierRule,PUCHAR Mac)
+static BOOLEAN EthCSMatchSrcMACAddress(S_CLASSIFIER_RULE *pstClassifierRule,PUCHAR Mac)
 {
 	UINT i=0;
     PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
@@ -709,7 +709,7 @@ BOOLEAN EthCSMatchSrcMACAddress(S_CLASSIFIER_RULE *pstClassifierRule,PUCHAR Mac)
 	return TRUE;
 }
 
-BOOLEAN EthCSMatchDestMACAddress(S_CLASSIFIER_RULE *pstClassifierRule,PUCHAR Mac)
+static BOOLEAN EthCSMatchDestMACAddress(S_CLASSIFIER_RULE *pstClassifierRule,PUCHAR Mac)
 {
 	UINT i=0;
     PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
@@ -726,7 +726,7 @@ BOOLEAN EthCSMatchDestMACAddress(S_CLASSIFIER_RULE *pstClassifierRule,PUCHAR Mac
 	return TRUE;
 }
 
-BOOLEAN EthCSMatchEThTypeSAP(S_CLASSIFIER_RULE *pstClassifierRule,struct sk_buff* skb,PS_ETHCS_PKT_INFO pstEthCsPktInfo)
+static BOOLEAN EthCSMatchEThTypeSAP(S_CLASSIFIER_RULE *pstClassifierRule,struct sk_buff* skb,PS_ETHCS_PKT_INFO pstEthCsPktInfo)
 {
     PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	if((pstClassifierRule->ucEtherTypeLen==0)||
@@ -761,7 +761,7 @@ BOOLEAN EthCSMatchEThTypeSAP(S_CLASSIFIER_RULE *pstClassifierRule,struct sk_buff
 
 }
 
-BOOLEAN EthCSMatchVLANRules(S_CLASSIFIER_RULE *pstClassifierRule,struct sk_buff* skb,PS_ETHCS_PKT_INFO pstEthCsPktInfo)
+static BOOLEAN EthCSMatchVLANRules(S_CLASSIFIER_RULE *pstClassifierRule,struct sk_buff* skb,PS_ETHCS_PKT_INFO pstEthCsPktInfo)
 {
 	BOOLEAN bClassificationSucceed = FALSE;
 	USHORT usVLANID;
diff --git a/drivers/staging/bcm/led_control.c b/drivers/staging/bcm/led_control.c
index 0d07664..97adaae 100644
--- a/drivers/staging/bcm/led_control.c
+++ b/drivers/staging/bcm/led_control.c
@@ -22,7 +22,7 @@ BOOLEAN IsReqGpioIsLedInNVM(PMINI_ADAPTER Adapter, UINT gpios)
 		return TRUE;
 }
 
-INT LED_Blink(PMINI_ADAPTER Adapter, UINT GPIO_Num, UCHAR uiLedIndex, ULONG timeout, INT num_of_time, LedEventInfo_t currdriverstate)
+static INT LED_Blink(PMINI_ADAPTER Adapter, UINT GPIO_Num, UCHAR uiLedIndex, ULONG timeout, INT num_of_time, LedEventInfo_t currdriverstate)
 {
 	int Status = STATUS_SUCCESS;
 	BOOLEAN bInfinite = FALSE;
@@ -69,7 +69,7 @@ INT LED_Blink(PMINI_ADAPTER Adapter, UINT GPIO_Num, UCHAR uiLedIndex, ULONG time
 	return Status;
 }
 
-INT ScaleRateofTransfer(ULONG rate)
+static INT ScaleRateofTransfer(ULONG rate)
 {
 	if(rate <= 3)
 		return rate;
@@ -91,7 +91,7 @@ INT ScaleRateofTransfer(ULONG rate)
 
 
 
-INT LED_Proportional_Blink(PMINI_ADAPTER Adapter, UCHAR GPIO_Num_tx,
+static INT LED_Proportional_Blink(PMINI_ADAPTER Adapter, UCHAR GPIO_Num_tx,
 		UCHAR uiTxLedIndex, UCHAR GPIO_Num_rx, UCHAR uiRxLedIndex, LedEventInfo_t currdriverstate)
 {
 	/* Initial values of TX and RX packets*/
@@ -281,7 +281,7 @@ INT LED_Proportional_Blink(PMINI_ADAPTER Adapter, UCHAR GPIO_Num_tx,
 //  <OSAL_STATUS_CODE>
 //-----------------------------------------------------------------------------
 
-INT ValidateDSDParamsChecksum(
+static INT ValidateDSDParamsChecksum(
 													PMINI_ADAPTER Adapter,
 													ULONG  ulParamOffset,
 													USHORT usParamLen )
@@ -293,7 +293,7 @@ INT ValidateDSDParamsChecksum(
 
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, LED_DUMP_INFO, DBG_LVL_ALL,"LED Thread:ValidateDSDParamsChecksum: 0x%lx 0x%X",ulParamOffset, usParamLen);
 
-	puBuffer = OsalMemAlloc(usParamLen,'!MEM');
+	puBuffer = OsalMemAlloc(usParamLen,"!MEM");
 	if(!puBuffer)
 	{
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, LED_DUMP_INFO, DBG_LVL_ALL,"LED Thread: ValidateDSDParamsChecksum Allocation failed");
@@ -362,7 +362,7 @@ exit:
 //  <OSAL_STATUS_CODE>
 //-----------------------------------------------------------------------------
 
-INT ValidateHWParmStructure(PMINI_ADAPTER Adapter, ULONG ulHwParamOffset)
+static INT ValidateHWParmStructure(PMINI_ADAPTER Adapter, ULONG ulHwParamOffset)
 {
 
 	INT Status = STATUS_SUCCESS ;
@@ -383,7 +383,7 @@ INT ValidateHWParmStructure(PMINI_ADAPTER Adapter, ULONG ulHwParamOffset)
 	return Status;
 } /* ValidateHWParmStructure() */
 
-int ReadLEDInformationFromEEPROM(PMINI_ADAPTER Adapter, UCHAR GPIO_Array[])
+static int ReadLEDInformationFromEEPROM(PMINI_ADAPTER Adapter, UCHAR GPIO_Array[])
 {
 	int Status = STATUS_SUCCESS;
 
@@ -493,7 +493,7 @@ int ReadLEDInformationFromEEPROM(PMINI_ADAPTER Adapter, UCHAR GPIO_Array[])
 }
 
 
-int ReadConfigFileStructure(PMINI_ADAPTER Adapter, BOOLEAN *bEnableThread)
+static int ReadConfigFileStructure(PMINI_ADAPTER Adapter, BOOLEAN *bEnableThread)
 {
 	int Status = STATUS_SUCCESS;
 	UCHAR GPIO_Array[NUM_OF_LEDS+1]; /*Array to store GPIO numbers from EEPROM*/
@@ -610,7 +610,7 @@ int ReadConfigFileStructure(PMINI_ADAPTER Adapter, BOOLEAN *bEnableThread)
 //
 //-----------------------------------------------------------------------------
 
-VOID LedGpioInit(PMINI_ADAPTER Adapter)
+static VOID LedGpioInit(PMINI_ADAPTER Adapter)
 {
 	UINT uiResetValue = 0;
 	UINT uiIndex      = 0;
@@ -631,7 +631,7 @@ VOID LedGpioInit(PMINI_ADAPTER Adapter)
 }
 //-----------------------------------------------------------------------------
 
-INT BcmGetGPIOPinInfo(PMINI_ADAPTER Adapter, UCHAR *GPIO_num_tx, UCHAR *GPIO_num_rx ,UCHAR *uiLedTxIndex, UCHAR *uiLedRxIndex,LedEventInfo_t currdriverstate)
+static INT BcmGetGPIOPinInfo(PMINI_ADAPTER Adapter, UCHAR *GPIO_num_tx, UCHAR *GPIO_num_rx ,UCHAR *uiLedTxIndex, UCHAR *uiLedRxIndex,LedEventInfo_t currdriverstate)
 {
 	UINT uiIndex = 0;
 
@@ -676,7 +676,7 @@ INT BcmGetGPIOPinInfo(PMINI_ADAPTER Adapter, UCHAR *GPIO_num_tx, UCHAR *GPIO_num
 	}
 	return STATUS_SUCCESS ;
 }
-VOID LEDControlThread(PMINI_ADAPTER Adapter)
+static VOID LEDControlThread(PMINI_ADAPTER Adapter)
 {
 	UINT uiIndex = 0;
 	UCHAR GPIO_num = 0;
diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index 35ff4e7..41c9ab8 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -12,7 +12,7 @@
 //
 //-----------------------------------------------------------------------------
 
-UCHAR ReadEEPROMStatusRegister( PMINI_ADAPTER Adapter )
+static UCHAR ReadEEPROMStatusRegister( PMINI_ADAPTER Adapter )
 {
 	UCHAR uiData = 0;
 	DWORD dwRetries = MAX_EEPROM_RETRIES*RETRIES_PER_DELAY;
@@ -804,7 +804,7 @@ INT WriteBeceemEEPROM(PMINI_ADAPTER Adapter,UINT uiEEPROMOffset, UINT uiData)
 //-----------------------------------------------------------------------------
 
 
-INT FlashSectorErase(PMINI_ADAPTER Adapter,
+static INT FlashSectorErase(PMINI_ADAPTER Adapter,
 	UINT addr,
 	UINT numOfSectors)
 {
@@ -866,7 +866,7 @@ INT FlashSectorErase(PMINI_ADAPTER Adapter,
 //
 //-----------------------------------------------------------------------------
 
-INT flashByteWrite(
+static INT flashByteWrite(
 	PMINI_ADAPTER Adapter,
 	UINT uiOffset,
 	PVOID pData)
@@ -954,7 +954,7 @@ INT flashByteWrite(
 //
 //-----------------------------------------------------------------------------
 
-INT flashWrite(
+static INT flashWrite(
 	PMINI_ADAPTER Adapter,
 	UINT uiOffset,
 	PVOID pData)
@@ -1038,7 +1038,7 @@ INT flashWrite(
 //		OSAL_STATUS_CODE
 //
 //-----------------------------------------------------------------------------
-INT flashByteWriteStatus(
+static INT flashByteWriteStatus(
 	PMINI_ADAPTER Adapter,
 	UINT uiOffset,
 	PVOID pData)
@@ -1123,7 +1123,7 @@ INT flashByteWriteStatus(
 //
 //-----------------------------------------------------------------------------
 
-INT flashWriteStatus(
+static INT flashWriteStatus(
 	PMINI_ADAPTER Adapter,
 	UINT uiOffset,
 	PVOID pData)
@@ -1201,7 +1201,7 @@ INT flashWriteStatus(
 //
 //-----------------------------------------------------------------------------
 
-VOID BcmRestoreBlockProtectStatus(PMINI_ADAPTER Adapter,ULONG ulWriteStatus)
+static VOID BcmRestoreBlockProtectStatus(PMINI_ADAPTER Adapter,ULONG ulWriteStatus)
 {
 	UINT value;
 	value = (FLASH_CMD_WRITE_ENABLE<< 24);
@@ -1224,7 +1224,7 @@ VOID BcmRestoreBlockProtectStatus(PMINI_ADAPTER Adapter,ULONG ulWriteStatus)
 //		ULONG   - Status value before UnProtect.
 //
 //-----------------------------------------------------------------------------
-ULONG BcmFlashUnProtectBlock(PMINI_ADAPTER Adapter,UINT uiOffset, UINT uiLength)
+static ULONG BcmFlashUnProtectBlock(PMINI_ADAPTER Adapter,UINT uiOffset, UINT uiLength)
 {
 	ULONG ulStatus      = 0;
 	ULONG ulWriteStatus = 0;
@@ -1378,7 +1378,7 @@ INT BeceemFlashBulkWrite(
 	uiSectBoundary	  		= uiSectAlignAddr + Adapter->uiSectorSize;
 
 	//pTempBuff = OsalMemAlloc(MAX_SECTOR_SIZE,'!MVN');
-	pTempBuff = OsalMemAlloc(Adapter->uiSectorSize ,'!MVN');
+	pTempBuff = OsalMemAlloc(Adapter->uiSectorSize ,"!MVN");
 	if(NULL == pTempBuff)
 	{
 		goto BeceemFlashBulkWrite_EXIT;
@@ -1567,7 +1567,7 @@ BeceemFlashBulkWrite_EXIT:
 //
 //-----------------------------------------------------------------------------
 
-INT BeceemFlashBulkWriteStatus(
+static INT BeceemFlashBulkWriteStatus(
 	PMINI_ADAPTER Adapter,
 	PUINT pBuffer,
 	UINT uiOffset,
@@ -1602,7 +1602,7 @@ INT BeceemFlashBulkWriteStatus(
 
 
 //	pTempBuff = OsalMemAlloc(MAX_SECTOR_SIZE,'!MVN');
-	pTempBuff = OsalMemAlloc(Adapter->uiSectorSize,'!MVN');
+	pTempBuff = OsalMemAlloc(Adapter->uiSectorSize,"!MVN");
 	if(NULL == pTempBuff)
 	{
 		goto BeceemFlashBulkWriteStatus_EXIT;
@@ -1771,7 +1771,7 @@ BeceemFlashBulkWriteStatus_EXIT:
 
 INT PropagateCalParamsFromEEPROMToMemory(PMINI_ADAPTER Adapter)
 {
-	PCHAR pBuff = OsalMemAlloc(BUFFER_4K,'3MVN');
+	PCHAR pBuff = OsalMemAlloc(BUFFER_4K,"3MVN");
 	UINT uiEepromSize = 0;
 	UINT uiIndex = 0;
 	UINT uiBytesToCopy = 0;
@@ -1925,7 +1925,7 @@ INT PropagateCalParamsFromFlashToMemory(PMINI_ADAPTER Adapter)
 //
 //-----------------------------------------------------------------------------
 
-INT BeceemEEPROMReadBackandVerify(
+static INT BeceemEEPROMReadBackandVerify(
 	PMINI_ADAPTER Adapter,
 	PUINT pBuffer,
 	UINT uiOffset,
@@ -2000,7 +2000,7 @@ INT BeceemEEPROMReadBackandVerify(
 	return 0;
 }
 
-VOID BcmSwapWord(UINT *ptr1) {
+static VOID BcmSwapWord(UINT *ptr1) {
 
 	UINT  tempval = (UINT)*ptr1;
 	char *ptr2 = (char *)&tempval;
@@ -2025,7 +2025,7 @@ VOID BcmSwapWord(UINT *ptr1) {
 //		OSAL_STATUS_CODE
 //
 //-----------------------------------------------------------------------------
-INT BeceemEEPROMWritePage( PMINI_ADAPTER Adapter, UINT uiData[], UINT uiOffset )
+static INT BeceemEEPROMWritePage( PMINI_ADAPTER Adapter, UINT uiData[], UINT uiOffset )
 {
 	UINT uiRetries = MAX_EEPROM_RETRIES*RETRIES_PER_DELAY;
 	UINT uiStatus = 0;
@@ -2604,7 +2604,7 @@ UINT BcmGetFlashSectorSize(PMINI_ADAPTER Adapter, UINT FlashSectorSizeSig, UINT
 //		<OSAL_STATUS_CODE>
 //-----------------------------------------------------------------------------
 
-INT BcmInitEEPROMQueues(PMINI_ADAPTER Adapter)
+static INT BcmInitEEPROMQueues(PMINI_ADAPTER Adapter)
 {
 	UINT value = 0;
 	/* CHIP Bug : Clear the Avail bits on the Read queue. The default
@@ -2734,7 +2734,7 @@ VOID BcmValidateNvmType(PMINI_ADAPTER Adapter)
 // Returns:
 //		Flash ID
 //-----------------------------------------------------------------------------
-ULONG BcmReadFlashRDID(PMINI_ADAPTER Adapter)
+static ULONG BcmReadFlashRDID(PMINI_ADAPTER Adapter)
 {
 	ULONG ulRDID = 0;
 	UINT value;
@@ -2804,7 +2804,7 @@ INT BcmDeAllocFlashCSStructure(PMINI_ADAPTER psAdapter)
 	return STATUS_SUCCESS ;
 }
 
-INT	BcmDumpFlash2XCSStructure(PFLASH2X_CS_INFO psFlash2xCSInfo,PMINI_ADAPTER Adapter)
+static INT	BcmDumpFlash2XCSStructure(PFLASH2X_CS_INFO psFlash2xCSInfo,PMINI_ADAPTER Adapter)
 {
 	UINT Index = 0;
     BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, NVM_RW, DBG_LVL_ALL, "**********************FLASH2X CS Structure *******************");
@@ -2865,7 +2865,7 @@ INT	BcmDumpFlash2XCSStructure(PFLASH2X_CS_INFO psFlash2xCSInfo,PMINI_ADAPTER Ada
 }
 
 
-INT	ConvertEndianOf2XCSStructure(PFLASH2X_CS_INFO psFlash2xCSInfo)
+static INT	ConvertEndianOf2XCSStructure(PFLASH2X_CS_INFO psFlash2xCSInfo)
 {
 	UINT Index = 0;
 	psFlash2xCSInfo->MagicNumber = ntohl(psFlash2xCSInfo->MagicNumber);
@@ -2921,7 +2921,7 @@ INT	ConvertEndianOf2XCSStructure(PFLASH2X_CS_INFO psFlash2xCSInfo)
 	return STATUS_SUCCESS;
 }
 
-INT	ConvertEndianOfCSStructure(PFLASH_CS_INFO psFlashCSInfo)
+static INT	ConvertEndianOfCSStructure(PFLASH_CS_INFO psFlashCSInfo)
 {
 	//UINT Index = 0;
 	psFlashCSInfo->MagicNumber					 		=ntohl(psFlashCSInfo->MagicNumber);
@@ -2961,7 +2961,7 @@ INT IsSectionExistInVendorInfo(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL sectio
  		(Adapter->psFlash2xVendorInfo->VendorSection[section].OffsetFromZeroForSectionStart != UNINIT_PTR_IN_CS) );
 }
 
-VOID UpdateVendorInfo(PMINI_ADAPTER Adapter)
+static VOID UpdateVendorInfo(PMINI_ADAPTER Adapter)
 {
 	B_UINT32 i = 0;
 	UINT uiSizeSection = 0;
@@ -3742,7 +3742,7 @@ B_UINT8 IsOffsetWritable(PMINI_ADAPTER Adapter, UINT uiOffset)
 		return FALSE;
 }
 
-INT BcmDumpFlash2xSectionBitMap(PFLASH2X_BITMAP psFlash2xBitMap)
+static INT BcmDumpFlash2xSectionBitMap(PFLASH2X_BITMAP psFlash2xBitMap)
 {
     PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, NVM_RW, DBG_LVL_ALL, "***************Flash 2.x Section Bitmap***************");
@@ -4074,7 +4074,7 @@ Return Value:- Make the priorit highest else return erorr code
 **/
 INT BcmSetActiveSection(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL eFlash2xSectVal)
 {
-	INT SectImagePriority = 0;
+	unsigned int SectImagePriority = 0;
 	INT Status =STATUS_SUCCESS;
 
 	//DSD_HEADER sDSD = {0};
@@ -5178,7 +5178,7 @@ INT ReadDSDSignature(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL dsd)
 INT ReadDSDPriority(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL dsd)
 {
 	//UINT priOffsetInMap = 0 ;
-	INT uiDSDPri = STATUS_FAILURE;
+	unsigned int uiDSDPri = STATUS_FAILURE;
 	//DSD_HEADER dsdHeader = {0};
 	//priOffsetInMap = (PUCHAR)&(dsdHeader.DSDImagePriority) -(PUCHAR)&dsdHeader;
 	if(IsSectionWritable(Adapter,dsd))
@@ -5260,7 +5260,7 @@ INT ReadISOSignature(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL iso)
 INT ReadISOPriority(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL iso)
 {
 
-	INT ISOPri = STATUS_FAILURE;
+	unsigned int ISOPri = STATUS_FAILURE;
 	if(IsSectionWritable(Adapter,iso))
 	{
 		if(ReadISOSignature(Adapter,iso)== ISO_IMAGE_MAGIC_NUMBER)
@@ -5482,7 +5482,7 @@ INT IsSectionWritable(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL Section)
 INT CorruptDSDSig(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL eFlash2xSectionVal)
 {
 
-	PUCHAR pBuff = 0 ;
+	PUCHAR pBuff = NULL;
 	UINT sig = 0;
 	UINT uiOffset = 0;
 	UINT BlockStatus = 0;
@@ -5555,7 +5555,7 @@ INT CorruptDSDSig(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL eFlash2xSectionVal)
 INT CorruptISOSig(PMINI_ADAPTER Adapter, FLASH2X_SECTION_VAL eFlash2xSectionVal)
 {
 
-	PUCHAR pBuff = 0 ;
+	PUCHAR pBuff = NULL;
 	UINT sig = 0;
 	UINT uiOffset = 0;
 
-- 
1.7.1

