Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1DMMwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:52:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46213 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1DMMwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nPWPfiff3+intGVsokzW/aoZp7M8Jh3wXmIdiB0jqVJTCQ7lgM04wVbKkizIYByDcn
         PtCK3LvlLxW8xtL/ipWNoJUQWmJhS1eaZYBnZe+k6vQTR7/G0phce6wYOtlYoYyZHfyM
         7QY3fHqD5pQpHRCeDoc9UI9BwBzpuot0KHbl8=
MIME-Version: 1.0
In-Reply-To: <SNT111-DS2245C6466732AF233DAA8CA7AA0@phx.gbl>
References: <SNT111-DS2245C6466732AF233DAA8CA7AA0@phx.gbl>
Date: Wed, 13 Apr 2011 14:52:41 +0200
Message-ID: <BANLkTi=Z89gZ6r0f5Ae7rcVzn=hfvmUrrw@mail.gmail.com>
Subject: Re: Call of /proc/ entry troughs a kernel bug
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: limp <johnkyr83@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 2:36 PM, limp <johnkyr83@hotmail.com> wrote:
> Hi all,
>
> I am using a 2.6.31.8 vanilla kernel on a Debian "lenny" distro.
>
> What I am trying to do is to create a module that creates a pseudo-file
> named '/proc/myfile' which prints some messages on the screen.
>
> My module compiles correctly and I am also inserting it (insmod) into the
> kernel without a problem. The problem occurs when I am trying to call it
> like that:
>
> $ cat /proc/myfile
>
> When I am doing that, I am getting the following output:
>
>
> Installing 'myfile' module
> BUG: unable to handle kernel paging request at 5a58e10f
> IP: [<5a58e10f>] 0x5a58e10f
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:1d.2/usb3/3-2/3-2:1.0/host2/target2:0:0/2:0:
> 0:0/block/sdb/size
> Modules linked in: myfile
>
> Pid: 2150, comm: cat Not tainted (2.6.31.8 #3) 986LCD-M/mITX
> EIP: 0060:[<5a58e10f>] EFLAGS: 00210206 CPU: 0
> EIP is at 0x5a58e10f
> EAX: d25c6ad8 EBX: 00000000 ECX: 00000006 EDX: d4652d00
> ESI: d443c2a0 EDI: d44a67a0 EBP: d4619e8c ESP: d4619e68
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process cat (pid: 2150, ti=d4618000 task=d463c9c0 task.ti=d4618000)
> Stack:
>  c10cfd2d d4652d00 d25c6ad8 5a58e10f 00000004 00000020 00000000 d4652d00
> <0> d25c6ad8 d4619eac c1095f99 de92a200 d25b2c00 c114f913 d4652d00 d4619ef8
> <0> d4619ef8 d4619ec8 c1096120 d4652d00 c10cfc0f d4652380 00000000 d4619ef8
> Call Trace:
>  [<c10cfd2d>] ? proc_reg_open+0x11e/0x1aa
>  [<c1095f99>] ? __dentry_open+0x155/0x243
>  [<c114f913>] ? security_inode_permission+0x1e/0x20
>  [<c1096120>] ? nameidata_to_filp+0x2b/0x42
>  [<c10cfc0f>] ? proc_reg_open+0x0/0x1aa
>  [<c10a0c94>] ? do_filp_open+0x3e4/0x75b
>  [<c10a106f>] ? getname+0x20/0xb6
>  [<c10a9b8a>] ? alloc_fd+0xdb/0xee
>  [<c1095d4d>] ? do_sys_open+0x4a/0xe2
>  [<c1095e27>] ? sys_open+0x1e/0x26
>  [<c1002a30>] ? sysenter_do_call+0x12/0x22
> Code:  Bad EIP value.
> EIP: [<5a58e10f>] 0x5a58e10f SS:ESP 0068:d4619e68
> CR2: 000000005a58e10f
> ---[ end trace dcbe10409eb0e88c ]---
>
>
> The code of my module is the following:
>
>
> #include <linux/module.h>       // for init_module()
> #include <linux/proc_fs.h>      // for proc_create_data()
>
> char modname[] = "myfile";
>
> int my_get_info( char *buf, char **start, off_t off, int count )
> {
>        int len = 1;
>        printk( "I am inside my get info function! \n");
>        return len;
> }
>
> static int __init my_init( void )
> {
>        printk( "<1>\nInstalling \'%s\' module\n", modname );
>        proc_create_data( modname, 0, NULL, my_get_info, NULL );
>        return  0;
> }
>
> static void __exit my_exit(void )
> {
>        remove_proc_entry( modname, NULL );
>        printk( "<1>Removing \'%s\' module\n", modname );
> }
>
> module_init( my_init );
> module_exit( my_exit );
>
> MODULE_LICENSE("GPL");
>
>
> Any help on trying to debug this problem will be greatly appreciated.

Review proc_create_data(), it does not work like that. Try not to
follow old tutorials.

>
> King regards,
>
> John K.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
