Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0JOQ0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:26:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34517 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab0JOQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TKPJx/bq+zLCKDuIleKfZ4Bobt8iZrmAiHWWCUlLm2R0T7zA527sdZgBawGbdk8XOT
         zPX0vZrm4OR7An2ildqHk28/gGsmqBMnR2mKUsvh4S/s71Py1bYUW2mUUvvZh9k+bO/J
         5MrSWHc5jHrpty9m/ve1EIhOLFJrkRJd2/EvY=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 5/7] staging:ft1000: Remove PSEUDO_HDR typedef usage.
Date: Fri, 15 Oct 2010 14:13:02 +0200
Message-Id: <1287144784-3359-5-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
References: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |    6 +-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   14 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   22 +++++-----
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h   |    7 +--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   41 +------------------
 5 files changed, 27 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 539607f..e2a9278 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -655,7 +655,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             //IOCTL_DPRAM_COMMAND dpram_command;
             USHORT qtype;
             USHORT msgsz;
-            PPSEUDO_HDR ppseudo_hdr;
+		struct pseudo_hdr *ppseudo_hdr;
             PUSHORT pmsg;
             USHORT total_len;
             USHORT app_index;
@@ -768,7 +768,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                             // Need to put sequence number plus new checksum for message
                             //pmsg = (PUSHORT)&dpram_command.dpram_blk.pseudohdr;
                             pmsg = (PUSHORT)&dpram_data->pseudohdr;
-                            ppseudo_hdr = (PPSEUDO_HDR)pmsg;
+				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
                             total_len = msgsz+2;
                             if (total_len & 0x1) {
                                 total_len++;
@@ -785,7 +785,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                                 //DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum);
                             }
                             pmsg++;
-                            ppseudo_hdr = (PPSEUDO_HDR)pmsg;
+				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
 #if 0
                             ptr = dpram_data;
                             DEBUG("FT1000:ft1000_ChIoctl: Command Send\n");
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index b950634..48eb697 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -507,7 +507,7 @@ static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
 //---------------------------------------------------------------------------
 // Function:    hdr_checksum
 //
-// Parameters:  PPSEUDO_HDR pHdr - Pseudo header pointer
+// Parameters:  struct pseudo_hdr *pHdr - Pseudo header pointer
 //
 // Returns:     checksum - success
 //
@@ -516,7 +516,7 @@ static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static USHORT hdr_checksum(PPSEUDO_HDR pHdr)
+static USHORT hdr_checksum(struct pseudo_hdr *pHdr)
 {
    USHORT   *usPtr = (USHORT *)pHdr;
    USHORT   chksum;
@@ -775,7 +775,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
    u16                     Status = STATUS_SUCCESS;
    UINT                    uiState;
    USHORT                  handshake;
-   PPSEUDO_HDR             pHdr;
+	struct pseudo_hdr *pHdr;
    USHORT                  usHdrLength;
    long                    word_length;
    USHORT                  request;
@@ -1167,7 +1167,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
 
       case  STATE_SECTION_PROV:
          DEBUG("FT1000:download:STATE_SECTION_PROV\n");
-         pHdr = (PPSEUDO_HDR)pUcFile;
+		pHdr = (struct pseudo_hdr *)pUcFile;
 
          if (pHdr->checksum == hdr_checksum(pHdr))
          {
@@ -1179,16 +1179,16 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
             usHdrLength = ntohs(pHdr->length);    /* Byte length for PROV records */
 
             // Get buffer for provisioning data
-            pbuffer = kmalloc ( (usHdrLength + sizeof(PSEUDO_HDR) ), GFP_ATOMIC );
+		pbuffer = kmalloc((usHdrLength + sizeof(struct pseudo_hdr)), GFP_ATOMIC);
             if (pbuffer) {
-                memcpy(pbuffer, (void *)pUcFile, (UINT)(usHdrLength + sizeof(PSEUDO_HDR)));
+		memcpy(pbuffer, (void *)pUcFile, (UINT)(usHdrLength + sizeof(struct pseudo_hdr)));
                 // link provisioning data
 		pprov_record = kmalloc(sizeof(struct prov_record), GFP_ATOMIC);
                 if (pprov_record) {
                     pprov_record->pprov_data = pbuffer;
                     list_add_tail (&pprov_record->list, &pft1000info->prov_list);
                     // Move to next entry if available
-                    pUcFile = (UCHAR *)((unsigned long)pUcFile + (UINT)((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(PSEUDO_HDR));
+			pUcFile = (UCHAR *)((unsigned long)pUcFile + (UINT)((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
                     if ( (unsigned long)(pUcFile) - (unsigned long)(pFileStart) >= (unsigned long)FileLength) {
                        uiState = STATE_DONE_FILE;
                     }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 4a7e007..efe47ac 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1237,7 +1237,7 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
 
     //DEBUG("ft1000_copy_down_pkt() entered, len = %d\n", len);
 
-    count = sizeof (PSEUDO_HDR) + len;
+	count = sizeof(struct pseudo_hdr) + len;
     if(count > MAX_BUF_SIZE)
     {
         DEBUG("Error:ft1000_copy_down_pkt:Message Size Overflow!\n");
@@ -1263,7 +1263,7 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
         checksum ^= *pTemp ++;
     }
     *pTemp++ = checksum;
-    memcpy (&(pFt1000Dev->tx_buf[sizeof(PSEUDO_HDR)]), packet, len);
+	memcpy(&(pFt1000Dev->tx_buf[sizeof(struct pseudo_hdr)]), packet, len);
 
     netif_stop_queue(netdev);
 
@@ -1476,7 +1476,7 @@ static int ft1000_copy_up_pkt (struct urb *urb)
 
 
 
-    memcpy(pbuffer, ft1000dev->rx_buf+sizeof(PSEUDO_HDR), len-sizeof(PSEUDO_HDR));
+	memcpy(pbuffer, ft1000dev->rx_buf+sizeof(struct pseudo_hdr), len-sizeof(struct pseudo_hdr));
 
     //DEBUG("ft1000_copy_up_pkt: Data passed to Protocol layer\n");
     /*for (i=0; i<len+12; i++)
@@ -1755,7 +1755,7 @@ static int ft1000_dsp_prov(void *arg)
     u16 len;
     u16 i=0;
 	struct prov_record *ptr;
-    PPSEUDO_HDR ppseudo_hdr;
+	struct pseudo_hdr *ppseudo_hdr;
     PUSHORT pmsg;
     u16 status;
     USHORT TempShortBuf [256];
@@ -1795,7 +1795,7 @@ static int ft1000_dsp_prov(void *arg)
             len += PSEUDOSZ;
 
             pmsg = (PUSHORT)ptr->pprov_data;
-            ppseudo_hdr = (PPSEUDO_HDR)pmsg;
+		ppseudo_hdr = (struct pseudo_hdr *)pmsg;
             // Insert slow queue sequence number
             ppseudo_hdr->seq_num = info->squeseqnum++;
             ppseudo_hdr->portsrc = 0;
@@ -1840,7 +1840,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
 	struct dsp_init_msg *pdspinitmsg;
     PDRVMSG pdrvmsg;
     u16 i;
-    PPSEUDO_HDR ppseudo_hdr;
+	struct pseudo_hdr *ppseudo_hdr;
     PUSHORT pmsg;
     u16 status;
     union {
@@ -2008,7 +2008,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
                 pmsg = (PUSHORT)info->DSPInfoBlk;
                 *pmsg++ = 0;
                 *pmsg++ = htons(info->DSPInfoBlklen+20+info->DSPInfoBlklen);
-                ppseudo_hdr = (PPSEUDO_HDR)(PUSHORT)&info->DSPInfoBlk[2];
+		ppseudo_hdr = (struct pseudo_hdr *)(PUSHORT)&info->DSPInfoBlk[2];
                 ppseudo_hdr->length = htons(info->DSPInfoBlklen+4+info->DSPInfoBlklen);
                 ppseudo_hdr->source = 0x10;
                 ppseudo_hdr->destination = 0x20;
@@ -2056,7 +2056,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
                   // Put message into Slow Queue
                   // Form Pseudo header
                   pmsg = (PUSHORT)&tempbuffer[0];
-                  ppseudo_hdr = (PPSEUDO_HDR)pmsg;
+			ppseudo_hdr = (struct pseudo_hdr *)pmsg;
                   ppseudo_hdr->length = htons(0x0012);
                   ppseudo_hdr->source = 0x10;
                   ppseudo_hdr->destination = 0x20;
@@ -2127,7 +2127,7 @@ int ft1000_poll(void* dev_id) {
     USHORT portid;
     u16 nxtph;
     struct dpram_blk *pdpram_blk;
-    PPSEUDO_HDR ppseudo_hdr;
+	struct pseudo_hdr *ppseudo_hdr;
     unsigned long flags;
 
     //DEBUG("Enter ft1000_poll...\n");
@@ -2180,7 +2180,7 @@ int ft1000_poll(void* dev_id) {
 			       pdpram_blk = ft1000_get_buffer (&freercvpool);
 			       if (pdpram_blk != NULL) {
 			           if ( ft1000_receive_cmd(dev, pdpram_blk->pbuffer, MAX_CMD_SQSIZE, &nxtph) ) {
-				       ppseudo_hdr = (PPSEUDO_HDR)pdpram_blk->pbuffer;
+					ppseudo_hdr = (struct pseudo_hdr *)pdpram_blk->pbuffer;
 				       // Put message into the appropriate application block
 				       info->app_info[i].nRxMsg++;
 				       spin_lock_irqsave(&free_buff_lock, flags);
@@ -2210,7 +2210,7 @@ int ft1000_poll(void* dev_id) {
                         //DEBUG("Memory allocated = 0x%8x\n", (u32)pdpram_blk);
                         if (pdpram_blk != NULL) {
                            if ( ft1000_receive_cmd(dev, pdpram_blk->pbuffer, MAX_CMD_SQSIZE, &nxtph) ) {
-                               ppseudo_hdr = (PPSEUDO_HDR)pdpram_blk->pbuffer;
+				ppseudo_hdr = (struct pseudo_hdr *)pdpram_blk->pbuffer;
                                // Search for correct application block
                                for (i=0; i<MAX_NUM_APP; i++) {
                                    if (info->app_info[i].app_id == ppseudo_hdr->portdest) {
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
index e7d3ec8..3f72d5b 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
@@ -36,8 +36,7 @@
 #define MAX_DNLD_BLKSZ          1024
 
 // Standard Flarion Pseudo header
-typedef struct _PSEUDO_HDR
-{
+struct pseudo_hdr {
    unsigned short    length;           //length of msg body
    unsigned char     source;           //source address (0x10=Host 0x20=DSP)
    unsigned char     destination;      //destination address (refer to source address)
@@ -57,7 +56,7 @@ typedef struct _PSEUDO_HDR
    unsigned char     rsvd2;            //reserved
    unsigned short    qos_class;        //Quality of Service class (Not applicable on Mobile)
    unsigned short    checksum;         //Psuedo header checksum
-} __attribute__ ((packed)) PSEUDO_HDR, *PPSEUDO_HDR;
+} __attribute__ ((packed));
 
 typedef struct _IOCTL_GET_VER
 {
@@ -106,7 +105,7 @@ typedef struct _IOCTL_GET_DSP_STAT
 typedef struct _IOCTL_DPRAM_BLK
 {
     unsigned short total_len;
-    PSEUDO_HDR pseudohdr;
+	struct pseudo_hdr pseudohdr;
     unsigned char buffer[1780];
 } __attribute__ ((packed)) IOCTL_DPRAM_BLK, *PIOCTL_DPRAM_BLK;
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 673a245..bef9bcf 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -52,7 +52,7 @@
 
 
 struct media_msg {
-	PSEUDO_HDR pseudo;
+	struct pseudo_hdr pseudo;
 	u16 type;
 	u16 length;
 	u16 state;
@@ -64,7 +64,7 @@ struct media_msg {
 } __attribute__ ((packed));
 
 struct dsp_init_msg {
-	PSEUDO_HDR pseudo;
+	struct pseudo_hdr pseudo;
 	u16 type;
 	u16 length;
 	u8 DspVer[DSPVERSZ];        // DSP version number
@@ -455,43 +455,8 @@ struct prov_record {
 
 #define MAX_BUF_SIZE            4096
 
-
-#if 0 //Removed by Jim
-typedef struct _PSEUDO_HDR
-
-{
-
-   unsigned short    length;
-
-   unsigned char     source;
-
-   unsigned char     destination;
-
-   unsigned char     portdest;
-
-   unsigned char     portsrc;
-
-   unsigned short    sh_str_id;
-
-   unsigned char     control;
-
-   unsigned char     rsvd1;
-
-   unsigned char     seq_num;
-
-   unsigned char     rsvd2;
-
-   unsigned short    qos_class;
-
-   unsigned short    checksum;
-
-
-
-} PSEUDO_HDR, *PPSEUDO_HDR;
-#endif //end of Jim
-
 typedef struct _DRVMSG {
-        PSEUDO_HDR pseudo;
+	struct pseudo_hdr pseudo;
         u16 type;
         u16 length;
         u8  data[0];
-- 
1.7.1

