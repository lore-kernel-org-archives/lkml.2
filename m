Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0JDNQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:16:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42960 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab0JDNQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dFv5W8iQPLYv/sHwFzHvGIV87ecfkUvWYASuQGSFoqtKXl29IAy/0cOPuCdE399OcB
         JHninvSfSW5W+TkCiX+Dkb3a2k+GYPN1tAerEebnD2yGWxoQ2KGWhaWVW3U0BstNcXa/
         21jKm2mbnyYKonFLsZCUaAUqeLF9Z7dcBAiOs=
MIME-Version: 1.0
In-Reply-To: <1285835052-11880-5-git-send-email-arnd@arndb.de>
References: <1285835052-11880-1-git-send-email-arnd@arndb.de>
	<1285835052-11880-5-git-send-email-arnd@arndb.de>
Date: Mon, 4 Oct 2010 15:16:14 +0200
Message-ID: <AANLkTikvMWnDQRjqCaMddkRCvhSdij7sN7XPfzNSSYW-@mail.gmail.com>
Subject: Re: [PATCH 4/6] staging/ft1000-usb: fix problems found by sparse
From: Belisko Marek <marek.belisko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't apply this patch with git. After manual patching it produce
compilation errors.
Did you test it?

On Thu, Sep 30, 2010 at 10:24 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> In the original code, address space annotations are missing,
> which hides a possible unchecked user pointer access.
>
> Two functions use a lot of stack space.
>
> Extern declarations are all in the wrong place, which leads
> to type differences between caller and callee in some cases.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |   36 ++++-----
>  .../staging/ft1000/ft1000-usb/ft1000_download.c    |   41 ++++-----
>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   89 ++++++++------------
>  drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    2 +-
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   21 +----
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   41 +++++++++-
>  6 files changed, 110 insertions(+), 120 deletions(-)
>
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> index 282deeb..46e72e4 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> @@ -41,13 +41,9 @@
>  #include "ft1000_usb.h"
>  //#include "ft1000_ioctl.h"
>
> -void ft1000_DestroyDevice(struct net_device *dev);
> -u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, u8 highlow);
> -u16 ft1000_read_register(struct ft1000_device *ft1000dev, short* Data, u16 nRegIndx);
> +static int ft1000_flarion_cnt = 0;
>
> -extern inline u16 ft1000_asic_read (struct net_device *dev, u16 offset);
> -extern inline void ft1000_asic_write (struct net_device *dev, u16 offset, u16 value);
> -extern void CardSendCommand(struct ft1000_device *ft1000dev, unsigned short *ptempbuffer, int size);
> +//need to looking usage of ft1000Handle
>
>  static int ft1000_ChOpen (struct inode *Inode, struct file *File);
>  static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait);
> @@ -55,12 +51,6 @@ static long ft1000_ChIoctl(struct file *File, unsigned int Command,
>                            unsigned long Argument);
>  static int ft1000_ChRelease (struct inode *Inode, struct file *File);
>
> -static int ft1000_flarion_cnt = 0;
> -
> -//need to looking usage of ft1000Handle
> -
> -
> -
>  // Global pointer to device object
>  static struct ft1000_device *pdevobj[MAX_NUM_CARDS + 2];
>  //static devfs_handle_t ft1000Handle[MAX_NUM_CARDS];
> @@ -326,7 +316,7 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
>         info->app_info[i].nRxMsg = 0;
>         info->app_info[i].nTxMsgReject = 0;
>         info->app_info[i].nRxMsgMiss = 0;
> -        info->app_info[i].fileobject = 0;
> +        info->app_info[i].fileobject = NULL;
>         info->app_info[i].app_id = i+1;
>         info->app_info[i].DspBCMsgFlag = 0;
>         info->app_info[i].NumOfMsg = 0;
> @@ -539,6 +529,7 @@ static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait)
>  static long ft1000_ChIoctl (struct file *File, unsigned int Command,
>                            unsigned long Argument)
>  {
> +    void __user *argp = (void __user *)Argument;
>     struct net_device *dev;
>     PFT1000_INFO info;
>     struct ft1000_device *ft1000dev;
> @@ -579,7 +570,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
>     switch (cmd) {
>     case IOCTL_REGISTER_CMD:
>             DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_REGISTER called\n");
> -            result = get_user(tempword, (unsigned short *)Argument);
> +            result = get_user(tempword, (__u16 __user*)argp);
>             if (result) {
>                 DEBUG("result = %d failed to get_user\n", result);
>                 break;
> @@ -601,7 +592,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
>
>         get_ver_data.drv_ver = FT1000_DRV_VER;
>
> -        if (copy_to_user((PIOCTL_GET_VER)Argument, &get_ver_data, sizeof(get_ver_data)) ) {
> +        if (copy_to_user(argp, &get_ver_data, sizeof(get_ver_data)) ) {
>             DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
>             result = -EFAULT;
>             break;
> @@ -651,7 +642,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
>         do_gettimeofday ( &tv );
>         get_stat_data.ConTm = (u32)(tv.tv_sec - info->ConTm);
>         DEBUG("Connection Time = %d\n", (int)get_stat_data.ConTm);
> -        if (copy_to_user((PIOCTL_GET_DSP_STAT)Argument, &get_stat_data, sizeof(get_stat_data)) ) {
> +        if (copy_to_user(argp, &get_stat_data, sizeof(get_stat_data)) ) {
>             DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
>             result = -EFAULT;
>             break;
> @@ -692,7 +683,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
>                //DEBUG("FT1000:ft1000_ChIoctl: try to SET_DPRAM \n");
>
>                 // Get the length field to see how many bytes to copy
> -                result = get_user(msgsz, (unsigned short *)Argument);
> +                result = get_user(msgsz, (__u16 __user *)argp);
>                 msgsz = ntohs (msgsz);
>                 //DEBUG("FT1000:ft1000_ChIoctl: length of message = %d\n", msgsz);
>
> @@ -708,7 +699,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
>                        break;
>
>                 //if ( copy_from_user(&(dpram_command.dpram_blk), (PIOCTL_DPRAM_BLK)Argument, msgsz+2) ) {
> -                if ( copy_from_user(&dpram_data, (PIOCTL_DPRAM_BLK)Argument, msgsz+2) ) {
> +                if ( copy_from_user(&dpram_data, argp, msgsz+2) ) {
>                     DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
>                     result = -EFAULT;
>                 }
> @@ -852,7 +843,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
>             }
>
>             result = 0;
> -            pioctl_dpram = (PIOCTL_DPRAM_BLK)Argument;
> +            pioctl_dpram = argp;
>             if (list_empty(&info->app_info[i].app_sqlist) == 0) {
>                 //DEBUG("FT1000:ft1000_ChIoctl:Message detected in slow queue\n");
>                 spin_lock_irqsave(&free_buff_lock, flags);
> @@ -862,7 +853,10 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
>                 //DEBUG("FT1000:ft1000_ChIoctl:NumOfMsg for app %d = %d\n", i, info->app_info[i].NumOfMsg);
>                 spin_unlock_irqrestore(&free_buff_lock, flags);
>                 msglen = ntohs(*(u16 *)pdpram_blk->pbuffer) + PSEUDOSZ;
> -                pioctl_dpram->total_len = htons(msglen); /* XXX exploit here */
> +                result = get_user(msglen, &pioctl_dpram->total_len);
> +               if (result)
> +                       break;
> +               msglen = htons(msglen);
>                 //DEBUG("FT1000:ft1000_ChIoctl:msg length = %x\n", msglen);
>                 if(copy_to_user (&pioctl_dpram->pseudohdr, pdpram_blk->pbuffer, msglen))
>                                {
> @@ -935,7 +929,7 @@ static int ft1000_ChRelease (struct inode *Inode, struct file *File)
>     // initialize application information
>     info->appcnt--;
>     DEBUG("ft1000_chdev:%s:appcnt = %d\n", __FUNCTION__, info->appcnt);
> -    info->app_info[i].fileobject = 0;
> +    info->app_info[i].fileobject = NULL;
>
>     return 0;
>  }
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
> index c71a1f4..ba07d5d 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
> @@ -133,15 +133,6 @@ typedef struct _DSP_IMAGE_INFO_V6 {
>  } DSP_IMAGE_INFO_V6, *PDSP_IMAGE_INFO_V6;
>
>
> -u16 ft1000_read_register(struct ft1000_device *ft1000dev, short* Data, u16 nRegIndx);
> -u16 ft1000_write_register(struct ft1000_device *ft1000dev, USHORT value, u16 nRegIndx);
> -u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, USHORT cnt);
> -u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, USHORT cnt);
> -u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, u8 highlow);
> -u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT value, u8 highlow);
> -u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer);
> -u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer);
> -
>  //---------------------------------------------------------------------------
>  // Function:    getfw
>  //
> @@ -154,7 +145,7 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHA
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -char *getfw (char *fn, int *pimgsz)
> +char *getfw (char *fn, size_t *pimgsz)
>  {
>     struct file *fd;
>     mm_segment_t fs = get_fs();
> @@ -190,7 +181,7 @@ char *getfw (char *fn, int *pimgsz)
>         return NULL;
>     }
>     pos = 0;
> -    if (vfs_read(fd, pfwimg, fwimgsz, &pos) != fwimgsz) {
> +    if (vfs_read(fd, (void __user __force*)pfwimg, fwimgsz, &pos) != fwimgsz) {
>        vfree(pfwimg);
>        DEBUG("FT1000:%s:failed to read firmware image\n",__FUNCTION__);
>        filp_close(fd, current->files);
> @@ -216,7 +207,7 @@ char *getfw (char *fn, int *pimgsz)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -ULONG check_usb_db (struct ft1000_device *ft1000dev)
> +static ULONG check_usb_db (struct ft1000_device *ft1000dev)
>  {
>    int               loopcnt;
>    USHORT            temp;
> @@ -295,7 +286,7 @@ ULONG check_usb_db (struct ft1000_device *ft1000dev)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_value)
> +static USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_value)
>  {
>    USHORT            handshake;
>    int               loopcnt;
> @@ -406,7 +397,7 @@ USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_value)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -void put_handshake(struct ft1000_device *ft1000dev,USHORT handshake_value)
> +static void put_handshake(struct ft1000_device *ft1000dev,USHORT handshake_value)
>  {
>     ULONG tempx;
>     USHORT tempword;
> @@ -442,7 +433,7 @@ void put_handshake(struct ft1000_device *ft1000dev,USHORT handshake_value)
>
>  }
>
> -USHORT get_handshake_usb(struct ft1000_device *ft1000dev, USHORT expected_value)
> +static USHORT get_handshake_usb(struct ft1000_device *ft1000dev, USHORT expected_value)
>  {
>    USHORT            handshake;
>    int               loopcnt;
> @@ -482,7 +473,7 @@ USHORT get_handshake_usb(struct ft1000_device *ft1000dev, USHORT expected_value)
>    return HANDSHAKE_TIMEOUT_VALUE;
>  }
>
> -void put_handshake_usb(struct ft1000_device *ft1000dev,USHORT handshake_value)
> +static void put_handshake_usb(struct ft1000_device *ft1000dev,USHORT handshake_value)
>  {
>    int i;
>
> @@ -501,7 +492,7 @@ void put_handshake_usb(struct ft1000_device *ft1000dev,USHORT handshake_value)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -USHORT get_request_type(struct ft1000_device *ft1000dev)
> +static USHORT get_request_type(struct ft1000_device *ft1000dev)
>  {
>    USHORT   request_type;
>    ULONG    status;
> @@ -533,7 +524,7 @@ USHORT get_request_type(struct ft1000_device *ft1000dev)
>
>  }
>
> -USHORT get_request_type_usb(struct ft1000_device *ft1000dev)
> +static USHORT get_request_type_usb(struct ft1000_device *ft1000dev)
>  {
>    USHORT   request_type;
>    ULONG    status;
> @@ -577,7 +568,7 @@ USHORT get_request_type_usb(struct ft1000_device *ft1000dev)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -long get_request_value(struct ft1000_device *ft1000dev)
> +static long get_request_value(struct ft1000_device *ft1000dev)
>  {
>    ULONG     value;
>    USHORT   tempword;
> @@ -605,7 +596,8 @@ long get_request_value(struct ft1000_device *ft1000dev)
>
>  }
>
> -long get_request_value_usb(struct ft1000_device *ft1000dev)
> +#if 0
> +static long get_request_value_usb(struct ft1000_device *ft1000dev)
>  {
>    ULONG     value;
>    USHORT   tempword;
> @@ -633,6 +625,7 @@ long get_request_value_usb(struct ft1000_device *ft1000dev)
>    return value;
>
>  }
> +#endif
>
>  //---------------------------------------------------------------------------
>  // Function:    put_request_value
> @@ -647,7 +640,7 @@ long get_request_value_usb(struct ft1000_device *ft1000dev)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
> +static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
>  {
>    ULONG    tempx;
>    ULONG    status;
> @@ -675,7 +668,7 @@ void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -USHORT hdr_checksum(PPSEUDO_HDR pHdr)
> +static USHORT hdr_checksum(PPSEUDO_HDR pHdr)
>  {
>    USHORT   *usPtr = (USHORT *)pHdr;
>    USHORT   chksum;
> @@ -705,7 +698,7 @@ USHORT hdr_checksum(PPSEUDO_HDR pHdr)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -ULONG write_blk (struct ft1000_device *ft1000dev, USHORT **pUsFile, UCHAR **pUcFile, long word_length)
> +static ULONG write_blk (struct ft1000_device *ft1000dev, USHORT **pUsFile, UCHAR **pUcFile, long word_length)
>  {
>    ULONG Status = STATUS_SUCCESS;
>    USHORT dpram;
> @@ -861,7 +854,7 @@ static void usb_dnld_complete (struct urb *urb)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -ULONG write_blk_fifo (struct ft1000_device *ft1000dev, USHORT **pUsFile, UCHAR **pUcFile, long word_length)
> +static ULONG write_blk_fifo (struct ft1000_device *ft1000dev, USHORT **pUsFile, UCHAR **pUcFile, long word_length)
>  {
>    ULONG Status = STATUS_SUCCESS;
>    int byte_length;
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
> index 4c3b1db..44395c0 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
> @@ -35,24 +35,12 @@
>
>  //#define JDEBUG
>
> -
> -extern void *pFileStart;
> -extern ULONG FileLength;
> -
> -
> -extern int numofmsgbuf;
> -
> -
> -int ft1000_poll_thread(void *arg);
> -
> +static int ft1000_reset(struct net_device *ft1000dev);
> +static int ft1000_submit_rx_urb(PFT1000_INFO info);
>  static void ft1000_hbchk(u_long data);
> -int ft1000_reset(struct net_device *ft1000dev);
>  static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  static int ft1000_open (struct net_device *dev);
> -int ft1000_close (struct net_device *dev);
>  static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev);
> -u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLength);
> -int ft1000_submit_rx_urb(PFT1000_INFO info);
>  static struct timer_list poll_timer[MAX_NUM_CARDS];
>  static int ft1000_chkcard (struct ft1000_device *dev);
>  /*
> @@ -67,21 +55,11 @@ static const struct net_device_ops ft1000net_ops = {
>  //Jim
>
>  static u8 tempbuffer[1600];
> -int gCardIndex;
> +static int gCardIndex;
>
>  #define MAX_RCV_LOOP   100
>
>
> -extern struct list_head freercvpool;
> -extern spinlock_t free_buff_lock;   // lock to arbitrate free buffer list for receive command data
> -
> -//end of Jim
> -
> -extern int ft1000_CreateDevice(struct ft1000_device *dev);
> -extern PDPRAM_BLK ft1000_get_buffer (struct list_head *bufflist);
> -extern void ft1000_free_buffer (PDPRAM_BLK pdpram_blk, struct list_head *plist);
> -
> -
>  static int atoi(const char *s)
>  {
>         int k = 0;
> @@ -207,7 +185,7 @@ static int ft1000_control(struct ft1000_device *ft1000dev,unsigned int pipe,
>  //
>  //---------------------------------------------------------------------------
>
> -u16 ft1000_read_register(struct ft1000_device *ft1000dev, short* Data, u16 nRegIndx)
> +u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx)
>  {
>     u16 ret = STATUS_SUCCESS;
>
> @@ -472,20 +450,20 @@ u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT va
>  //---------------------------------------------------------------------------
>  u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer)
>  {
> -    UCHAR tempbuffer[16];
> +    UCHAR buf[16];
>     USHORT pos;
>     u16 ret = STATUS_SUCCESS;
>
>     //DEBUG("fix_ft1000_read_dpram32: indx: %d  \n", indx);
>     pos = (indx / 4)*4;
> -    ret = ft1000_read_dpram32(ft1000dev, pos, (PUCHAR)&tempbuffer[0], 16);
> +    ret = ft1000_read_dpram32(ft1000dev, pos, buf, 16);
>     if (ret == STATUS_SUCCESS)
>     {
>         pos = (indx % 4)*4;
> -        *buffer++ = tempbuffer[pos++];
> -        *buffer++ = tempbuffer[pos++];
> -        *buffer++ = tempbuffer[pos++];
> -        *buffer++ = tempbuffer[pos++];
> +        *buffer++ = buf[pos++];
> +        *buffer++ = buf[pos++];
> +        *buffer++ = buf[pos++];
> +        *buffer++ = buf[pos++];
>     }
>     else
>     {
> @@ -524,7 +502,7 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHA
>     USHORT pos1;
>     USHORT pos2;
>     USHORT i;
> -    UCHAR tempbuffer[32];
> +    UCHAR buf[32];
>     UCHAR resultbuffer[32];
>     PUCHAR pdata;
>     u16 ret  = STATUS_SUCCESS;
> @@ -533,15 +511,15 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHA
>
>     pos1 = (indx / 4)*4;
>     pdata = buffer;
> -    ret = ft1000_read_dpram32(ft1000dev, pos1, (PUCHAR)&tempbuffer[0], 16);
> +    ret = ft1000_read_dpram32(ft1000dev, pos1, buf, 16);
>     if (ret == STATUS_SUCCESS)
>     {
>         pos2 = (indx % 4)*4;
> -        tempbuffer[pos2++] = *buffer++;
> -        tempbuffer[pos2++] = *buffer++;
> -        tempbuffer[pos2++] = *buffer++;
> -        tempbuffer[pos2++] = *buffer++;
> -        ret = ft1000_write_dpram32(ft1000dev, pos1, (PUCHAR)&tempbuffer[0], 16);
> +        buf[pos2++] = *buffer++;
> +        buf[pos2++] = *buffer++;
> +        buf[pos2++] = *buffer++;
> +        buf[pos2++] = *buffer++;
> +        ret = ft1000_write_dpram32(ft1000dev, pos1, buf, 16);
>     }
>     else
>     {
> @@ -556,7 +534,7 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHA
>         buffer = pdata;
>         for (i=0; i<16; i++)
>         {
> -            if (tempbuffer[i] != resultbuffer[i]){
> +            if (buf[i] != resultbuffer[i]){
>
>                 ret = STATUS_FAILURE;
>             }
> @@ -596,7 +574,7 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHA
>  //
>  //  Returns:    None
>  //-----------------------------------------------------------------------
> -void card_reset_dsp (struct ft1000_device *ft1000dev, BOOLEAN value)
> +static void card_reset_dsp (struct ft1000_device *ft1000dev, BOOLEAN value)
>  {
>     u16 status = STATUS_SUCCESS;
>     USHORT tempword;
> @@ -645,7 +623,7 @@ void card_reset_dsp (struct ft1000_device *ft1000dev, BOOLEAN value)
>  // Notes:
>  //
>  //---------------------------------------------------------------------------
> -void CardSendCommand(struct ft1000_device *ft1000dev, unsigned char *ptempbuffer, int size)
> +void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int size)
>  {
>     unsigned short temp;
>     unsigned char *commandbuf;
> @@ -1202,7 +1180,7 @@ u16 reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *int
>    return STATUS_SUCCESS;
>  }
>
> -int ft1000_reset(struct net_device *dev)
> +static int ft1000_reset(struct net_device *dev)
>  {
>     ft1000_reset_card(dev);
>     return 0;
> @@ -1432,7 +1410,7 @@ static inline u16 ft1000_read_fifo_len (struct net_device *dev)
>  //              SUCCESS
>  //
>  //---------------------------------------------------------------------------
> -int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
> +static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
>  {
>     FT1000_INFO *pInfo = netdev_priv(netdev);
>     struct ft1000_device *pFt1000Dev = pInfo->pFt1000Dev;
> @@ -1658,7 +1636,7 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  //              SUCCESS
>  //
>  //---------------------------------------------------------------------------
> -int ft1000_copy_up_pkt (struct urb *urb)
> +static int ft1000_copy_up_pkt (struct urb *urb)
>  {
>     PFT1000_INFO info = urb->context;
>     struct ft1000_device *ft1000dev = info->pFt1000Dev;
> @@ -1774,7 +1752,7 @@ int ft1000_copy_up_pkt (struct urb *urb)
>  //              SUCCESS
>  //
>  //---------------------------------------------------------------------------
> -int ft1000_submit_rx_urb(PFT1000_INFO info)
> +static int ft1000_submit_rx_urb(PFT1000_INFO info)
>  {
>     int result;
>     struct ft1000_device *pFt1000Dev = info->pFt1000Dev;
> @@ -2102,7 +2080,7 @@ static void ft1000_hbchk(u_long data)
>  //          = 1 (successful)
>  //
>  //---------------------------------------------------------------------------
> -BOOLEAN ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int maxsz, u16 *pnxtph) {
> +static BOOLEAN ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int maxsz, u16 *pnxtph) {
>     u16 size, ret;
>     u16 *ppseudohdr;
>     int i;
> @@ -2175,7 +2153,7 @@ BOOLEAN ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int maxsz,
>  }
>
>
> -int ft1000_dsp_prov(void *arg)
> +static int ft1000_dsp_prov(void *arg)
>  {
>     struct ft1000_device *dev = (struct ft1000_device *)arg;
>        FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev->net);
> @@ -2263,7 +2241,7 @@ int ft1000_dsp_prov(void *arg)
>  }
>
>
> -int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
> +static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
>        FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev->net);
>     u16 msgtype;
>     u16 tempword;
> @@ -2281,9 +2259,11 @@ int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
>     } convert;
>
>
> -    char cmdbuffer[1600];
> +    char *cmdbuffer = kmalloc(1600, GFP_KERNEL);
> +    if (!cmdbuffer)
> +       return STATUS_FAILURE;
>
> -    status = ft1000_read_dpram32(dev, 0x200, (PUCHAR)&cmdbuffer[0], size);
> +    status = ft1000_read_dpram32(dev, 0x200, cmdbuffer, size);
>
>
>     //if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword))
> @@ -2388,7 +2368,7 @@ int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
>                    info->fProvComplete = 0;
>                    status = ft1000_dsp_prov(dev);
>                    if (status != STATUS_SUCCESS)
> -                       return status;
> +                       goto out;
>                 }
>                 else {
>                     info->fProvComplete = 1;
> @@ -2537,8 +2517,11 @@ int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
>
>     }
>
> +    status = STATUS_SUCCESS;
> +out:
> +    kfree(cmdbuffer);
>     DEBUG("return from ft1000_proc_drvmsg\n");
> -    return STATUS_SUCCESS;
> +    return status;
>  }
>
>
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
> index 80faba5..d1ef396 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
> @@ -42,7 +42,7 @@ u16 ft1000_read_dpram16 (struct ft1000_device *ft1000dev, USHORT indx,
>                         PUCHAR buffer, u8 highlow);
>
>
> -int
> +static int
>  ft1000ReadProc (char *page, char **start, off_t off, int count, int *eof,
>                void *data)
>  {
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> index f708c09..4aef1c4 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> @@ -33,7 +33,7 @@ MODULE_SUPPORTED_DEVICE("QFT FT1000 Express Cards");
>
>
>  void *pFileStart;
> -ULONG FileLength;
> +size_t FileLength;
>
>  #define VENDOR_ID 0x1291   /* Qualcomm vendor id */
>  #define PRODUCT_ID 0x11    /* fake product id */
> @@ -46,24 +46,7 @@ static struct usb_device_id id_table[] = {
>
>  MODULE_DEVICE_TABLE (usb, id_table);
>
> -extern  struct ft1000_device *pdevobj[MAX_NUM_CARDS+2];
> -
> -char *getfw (char *fn, int *pimgsz);
> -
> -int ft1000_close(struct net_device *net);
> -void dsp_reload (struct ft1000_device *ft1000dev);
> -u16 init_ft1000_netdev(struct ft1000_device *ft1000dev);
> -u16 reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf);
> -int ft1000_poll(void* dev_id);
> -void ft1000_DestroyDevice(struct net_device *dev);
> -u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, u8 highlow);
> -u16 ft1000_read_register(struct ft1000_device *ft1000dev, short* Data, u16 nRegIndx);
> -BOOLEAN gPollingfailed = FALSE;
> -
> -void ft1000InitProc(struct net_device *dev);
> -void ft1000CleanupProc(FT1000_INFO *info);
> -int ft1000_poll_thread(void *arg);
> -
> +static BOOLEAN gPollingfailed = FALSE;
>  int ft1000_poll_thread(void *arg)
>  {
>     int ret = STATUS_SUCCESS;
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
> index a64d468..b0ab918 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
> @@ -102,7 +102,7 @@ typedef struct _PROV_RECORD {
>
>  #define UCHAR               u8
>  #define USHORT              u16
> -#define ULONG               u32
> +#define ULONG               u32 /* WTF ??? */
>  #define BOOLEAN             u8
>  #define PULONG              u32 *
>  #define PUSHORT             u16 *
> @@ -152,7 +152,6 @@ typedef struct _PROV_RECORD {
>
>  #define CIS_NET_ADDR_OFFSET 0xff0
>
> -#define MEM_TAG 'FLRN'
>  // MAGNEMITE specific
>
>  #define FT1000_REG_MAG_UFDR            0x0000  // Uplink FIFO Data Register.
> @@ -605,5 +604,43 @@ typedef struct _DPRAM_BLK {
>     u16 *pbuffer;
>  } __attribute__ ((packed)) DPRAM_BLK, *PDPRAM_BLK;
>
> +u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx);
> +u16 ft1000_write_register(struct ft1000_device *ft1000dev, USHORT value, u16 nRegIndx);
> +u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, USHORT cnt);
> +u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, USHORT cnt);
> +u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, u8 highlow);
> +u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT value, u8 highlow);
> +u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer);
> +u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer);
> +
> +extern void *pFileStart;
> +extern size_t FileLength;
> +extern int numofmsgbuf;
> +
> +int ft1000_close (struct net_device *dev);
> +u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLength);
> +
> +extern struct list_head freercvpool;
> +extern spinlock_t free_buff_lock;   // lock to arbitrate free buffer list for receive command data
> +
> +int ft1000_CreateDevice(struct ft1000_device *dev);
> +void ft1000_DestroyDevice(struct net_device *dev);
> +extern void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int size);
> +
> +PDPRAM_BLK ft1000_get_buffer (struct list_head *bufflist);
> +void ft1000_free_buffer (PDPRAM_BLK pdpram_blk, struct list_head *plist);
> +
> +char *getfw (char *fn, size_t *pimgsz);
> +
> +void dsp_reload(struct ft1000_device *ft1000dev);
> +u16 init_ft1000_netdev(struct ft1000_device *ft1000dev);
> +struct usb_interface;
> +u16 reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf);
> +int ft1000_poll(void* dev_id);
> +
> +void ft1000InitProc(struct net_device *dev);
> +void ft1000CleanupProc(FT1000_INFO *info);
> +
> +
>
>  #endif
> --
> 1.7.1
>
>

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
