Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1F3F0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:26:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36893 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1F3F0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:26:20 -0400
MIME-Version: 1.0
Date: Wed, 29 Jun 2011 22:26:19 -0700
Message-ID: <BANLkTinZphAp1QxzddUMciwyhKXdo4y57Q@mail.gmail.com>
Subject: Ioctl in 2.6.35.22 change the argument value?
From: =?UTF-8?B?5a2Z5a2Q6I2A?= <faye.zixun@gmail.com>
To: linux-kernel mlist <linux-kernel@vger.kernel.org>
Cc: linux-stable mlist <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

When I want to get the block size about the block device(DM or real),I
use the system API like "ioctl(int fd, BLKGETSIZE,long size)".
Everything works fine. But when I pass the third parameter whose type
is "int", the first parameter fd will be changed to zero. It only
happened on x86_64 and 2.6.35 ,on  2.6.38 and 32bit will not occur,
I've already tested on them.
(My PC:Linux server-group 2.6.35-22-server #33-Ubuntu SMP Sun Sep 19
20:48:58 UTC 2010 x86_64 GNU/Linux)
here is the test code:
int main(){
        int fd;
        int blksize ;
        fd = open("/dev/sda",O_RDONLY,0);
        ioctl(fd, BLKGETSIZE,&blksize) ;
        close(fd);
}
If I change the fd type as long , won't occur again. I quite sure the
ioctl syscall when return from userspace changes the fd's value.
(gdb) r
Starting program: /home/test/main
10              fd = open("/dev/sda",O_RDONLY,0);
(gdb)
   0x00000000004005a7 <+35>:    callq  0x400490 <open@plt>
   0x00000000004005ac <+40>:    mov    %eax,-0x4(%rbp)
   0x00000000004005af <+43>:    lea    -0x8(%rbp),%rdx
   0x00000000004005b3 <+47>:    mov    -0x4(%rbp),%eax
   0x00000000004005b6 <+50>:    mov    $0x1260,%esi
=> 0x00000000004005bb <+55>:    mov    %eax,%edi
   0x00000000004005bd <+57>:    mov    $0x0,%eax
   0x00000000004005c2 <+62>:    callq  0x400470 <ioctl@plt>
   0x00000000004005c7 <+67>:    mov    -0x4(%rbp),%eax
(gdb) ni
0x00000000004005bd      11              ioctl(fd, BLKGETSIZE,&blksize) ;
(gdb) p $edi
$1 = 5
(gdb) n
12              close(fd);
(gdb) p $edi
$3 = 5
(gdb) p fd
$4 = 0
And I also find that in the function :
"int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned
cmd,unsigned long arg)"
If it's case which  return put_uint() will be fine ,I mean the fd, and
that was opposite to the case which  return put_long();
Dose anybody now which path after 2.6.35 slove the problem ?I just
guess about restore_all(arch/x86/include/). thanks a lot!
I will be gratefull for u help. Thanks a lot. Thanks a million!
--
Regards,
Sri.
--
2011-06-30

--------------------------------------------------------------------------------

faye.zixun
