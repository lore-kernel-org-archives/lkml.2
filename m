Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab1IWTCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:02:55 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:7799 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1IWTCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:02:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1316804302!28782095!341
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Joe Perches <joe@perches.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "chris.mason@oracle.com" <chris.mason@oracle.com>
Date: Fri, 23 Sep 2011 14:02:27 -0500
Subject: RE: [PATCH] btrfs/ioctl.c: quiet sparse warnings
Thread-Topic: [PATCH] btrfs/ioctl.c: quiet sparse warnings
Thread-Index: Acx6HNqGsHcPnI3zQW2xoY3849N/rAABUvMg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DBB8425@AUSP01VMBX24.collaborationhost.net>
References: <201109231107.54227.hartleys@visionengravers.com>
 <1316801760.28330.5.camel@Joe-Laptop>
In-Reply-To: <1316801760.28330.5.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8NJ32LI006410

On Friday, September 23, 2011 11:16 AM, Joe Perches wrote:
> On Fri, 2011-09-23 at 11:07 -0700, H Hartley Sweeten wrote:
>> Quiet the following sparse warnings:
> []
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> []
>> @@ -2705,7 +2705,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
>>  		up_read(&info->groups_sem);
>>  	}
>>  
>> -	user_dest = (struct btrfs_ioctl_space_info *)
>> +	user_dest = (struct btrfs_ioctl_space_info __user *)
>>                 (arg + sizeof(struct btrfs_ioctl_space_args));
>
>	user_dest = arg;
>	user_dest++;
>
> ?

That produces a new sparse warning:

fs/btrfs/ioctl.c: In function â€˜btrfs_ioctl_space_infoâ€™:
fs/btrfs/ioctl.c:2708: warning: â€˜user_destâ€™ may be used uninitialized in this function

I guess user_dest could be set at the start of the function.  This would
also remove the cast of arg in the first copy_from_user.

Something like this:

------

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 970977a..9e7e5dc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2599,13 +2599,13 @@ static void get_block_group_info(struct list_head *groups_list,
        }
 }
 
-long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 {
        struct btrfs_ioctl_space_args space_args;
        struct btrfs_ioctl_space_info space;
        struct btrfs_ioctl_space_info *dest;
        struct btrfs_ioctl_space_info *dest_orig;
-       struct btrfs_ioctl_space_info __user *user_dest;
+       struct btrfs_ioctl_space_info __user *user_dest = arg;
        struct btrfs_space_info *info;
        u64 types[] = {BTRFS_BLOCK_GROUP_DATA,
                       BTRFS_BLOCK_GROUP_SYSTEM,
@@ -2617,9 +2617,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
        u64 slot_count = 0;
        int i, c;
 
-       if (copy_from_user(&space_args,
-                          (struct btrfs_ioctl_space_args __user *)arg,
-                          sizeof(space_args)))
+       if (copy_from_user(&space_args, user_dest, sizeof(space_args)))
                return -EFAULT;
 
        for (i = 0; i < num_types; i++) {
@@ -2705,8 +2703,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
                up_read(&info->groups_sem);
        }
 
-       user_dest = (struct btrfs_ioctl_space_info *)
-               (arg + sizeof(struct btrfs_ioctl_space_args));
+       user_dest++;
 
        if (copy_to_user(user_dest, dest_orig, alloc_size))
                ret = -EFAULT;

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
