Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0KJUnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:43:21 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14866 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab0KJUnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:43:20 -0500
Date: Wed, 10 Nov 2010 21:31:38 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        devel@driverdev.osuosl.org, Dan Carpenter <error27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 10/17][trivial] staging, bcm: Remove unnecessary casts
 of void ptr returning alloc function return values
In-Reply-To: <20101110004543.GA28373@kroah.com>
Message-ID: <alpine.LNX.2.00.1011102129050.625@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011082342560.23697@swampdragon.chaosbits.net> <20101110004543.GA28373@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Greg KH wrote:

> On Tue, Nov 09, 2010 at 12:09:51AM +0100, Jesper Juhl wrote:
> > Hi,
> > 
> > The [vk][cmz]alloc(_node) family of functions return void pointers which
> > it's completely unnecessary/pointless to cast to other pointer types since
> > that happens implicitly.
> > 
> > This patch removes such casts from drivers/staging/bcm/
> > 
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  CmHost.c       |    2 +-
> >  InterfaceDld.c |   27 +++++++++++++--------------
> >  Misc.c         |   12 +++++-------
> >  3 files changed, 19 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
> 
> This driver just got a major overhaul, and this patch doesn't apply
> anymore.
> 
> Care to redo it against the next linux-next tree?
> 

Here's a patch against a copy of linux-next that I just cloned.


Don't pointlessly cast pointers returned by allocation functions that 
return void pointers which are implicitly converted.
For drivers/staging/bcm/

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 CmHost.c       |    2 +-
 InterfaceDld.c |   14 ++++++--------
 Misc.c         |   15 ++++++---------
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 38b64e6..a685cad 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1702,7 +1702,7 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 	}
 	// For DSA_REQ, only upto "psfAuthorizedSet" parameter should be accessed by driver!
 
-	pstAddIndication=(stLocalSFAddIndication *)kmalloc(sizeof(*pstAddIndication), GFP_KERNEL);
+	pstAddIndication=kmalloc(sizeof(*pstAddIndication), GFP_KERNEL);
 	if(NULL==pstAddIndication)
 		return 0;
 
diff --git a/drivers/staging/bcm/InterfaceDld.c b/drivers/staging/bcm/InterfaceDld.c
index 1fc36a1..df64acb 100644
--- a/drivers/staging/bcm/InterfaceDld.c
+++ b/drivers/staging/bcm/InterfaceDld.c
@@ -5,15 +5,14 @@ int InterfaceFileDownload( PVOID arg,
                         struct file *flp,
                         unsigned int on_chip_loc)
 {
-    char            *buff=NULL;
    // unsigned int    reg=0;
     mm_segment_t    oldfs={0};
     int             errno=0, len=0 /*,is_config_file = 0*/;
     loff_t          pos=0;
 	PS_INTERFACE_ADAPTER psIntfAdapter = (PS_INTERFACE_ADAPTER)arg;
 	//PMINI_ADAPTER Adapter = psIntfAdapter->psAdapter;
+    char            *buff=kmalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_KERNEL);
 
-    buff=(PCHAR)kmalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_KERNEL);
     if(!buff)
     {
         return -ENOMEM;
@@ -56,7 +55,7 @@ int InterfaceFileReadbackFromChip( PVOID arg,
                         struct file *flp,
                         unsigned int on_chip_loc)
 {
-    char            *buff=NULL, *buff_readback=NULL;
+    char            *buff, *buff_readback;
     unsigned int    reg=0;
     mm_segment_t    oldfs={0};
     int             errno=0, len=0, is_config_file = 0;
@@ -65,8 +64,8 @@ int InterfaceFileReadbackFromChip( PVOID arg,
 	INT				Status = STATUS_SUCCESS;
 	PS_INTERFACE_ADAPTER psIntfAdapter = (PS_INTERFACE_ADAPTER)arg;
 
-    buff=(PCHAR)kmalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_DMA);
-    buff_readback=(PCHAR)kmalloc(MAX_TRANSFER_CTRL_BYTE_USB , GFP_DMA);
+    buff=kmalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_DMA);
+    buff_readback=kmalloc(MAX_TRANSFER_CTRL_BYTE_USB , GFP_DMA);
     if(!buff || !buff_readback)
     {
         kfree(buff);
@@ -287,7 +286,7 @@ int bcm_ioctl_fw_download(PMINI_ADAPTER Adapter, FIRMWARE_INFO *psFwInfo)
 	else
 	{
 
-		buff = (PUCHAR)kzalloc(psFwInfo->u32FirmwareLength,GFP_KERNEL);
+		buff = kzalloc(psFwInfo->u32FirmwareLength,GFP_KERNEL);
 		if(buff==NULL)
 		{
 			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL,"Failed in allocation memory");
@@ -345,11 +344,10 @@ static INT buffRdbkVerify(PMINI_ADAPTER Adapter,
 			PUCHAR mappedbuffer, UINT u32FirmwareLength,
 			ULONG u32StartingAddress)
 {
-	PUCHAR readbackbuff = NULL;
 	UINT len = u32FirmwareLength;
 	INT retval = STATUS_SUCCESS;
+	PUCHAR readbackbuff = kzalloc(MAX_TRANSFER_CTRL_BYTE_USB,GFP_KERNEL);
 
-	readbackbuff = (PUCHAR)kzalloc(MAX_TRANSFER_CTRL_BYTE_USB,GFP_KERNEL);
 	if(NULL == readbackbuff)
 	{
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "MEMORY ALLOCATION FAILED");
diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index 82d9f86..1bb6a1d 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -71,8 +71,7 @@ InitAdapter(PMINI_ADAPTER psAdapter)
 	default_wimax_protocol_initialize(psAdapter);
 	for (i=0;i<MAX_CNTRL_PKTS;i++)
 	{
-		psAdapter->txctlpacket[i] = (char *)kmalloc(MAX_CNTL_PKT_SIZE,
-												GFP_KERNEL);
+		psAdapter->txctlpacket[i] = kmalloc(MAX_CNTL_PKT_SIZE, GFP_KERNEL);
 		if(!psAdapter->txctlpacket[i])
 		{
 			BCM_DEBUG_PRINT(psAdapter,DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "No More Cntl pkts got, max got is %d", i);
@@ -1228,11 +1227,11 @@ static int bcm_parse_target_params(PMINI_ADAPTER Adapter)
 {
 	struct file 		*flp=NULL;
 	mm_segment_t 	oldfs={0};
-	char *buff = NULL;
+	char *buff;
 	int len = 0;
 	loff_t	pos = 0;
 
-	buff=(PCHAR)kmalloc(BUFFER_1K, GFP_KERNEL);
+	buff=kmalloc(BUFFER_1K, GFP_KERNEL);
 	if(!buff)
 	{
 		return -ENOMEM;
@@ -1393,12 +1392,10 @@ static VOID doPowerAutoCorrection(PMINI_ADAPTER psAdapter)
 #if 0
 static unsigned char *ReadMacAddrEEPROM(PMINI_ADAPTER Adapter, ulong dwAddress)
 {
-	unsigned char *pucmacaddr = NULL;
-	int status = 0, i=0;
-	unsigned int temp =0;
+	int status = 0, i = 0;
+	unsigned int temp = 0;
+	unsigned char *pucmacaddr = kmalloc(MAC_ADDRESS_SIZE, GFP_KERNEL);
 
-
-	pucmacaddr = (unsigned char *)kmalloc(MAC_ADDRESS_SIZE, GFP_KERNEL);
 	if(!pucmacaddr)
 	{
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "No Buffers to Read the EEPROM Address\n");



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

