Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2K2Rsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:48:54 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:51670 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956Ab2K2Rsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:48:52 -0500
Message-ID: <50B79FF4.4020201@ilyx.ru>
Date: Thu, 29 Nov 2012 21:48:36 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Xiaobing Tu <xiaobing.tu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Alek Du <alek.du@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Correct tty buffer flushing.
References: <50B55A93.4090900@ilyx.ru> <50B6A652.9000107@ilyx.ru> <20121129135418.4237e7f8@pyramind.ukuu.org.uk>
In-Reply-To: <20121129135418.4237e7f8@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2012 17:54, Alan Cox wrote:
>> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
>> index 6c9b7cd..4f02f9c 100644
>> --- a/drivers/tty/tty_buffer.c
>> +++ b/drivers/tty/tty_buffer.c
>> @@ -114,11 +114,14 @@ static void __tty_buffer_flush(struct tty_struct *tty)
>>  {
>>  	struct tty_buffer *thead;
>>  
>> -	while ((thead = tty->buf.head) != NULL) {
>> -		tty->buf.head = thead->next;
>> -		tty_buffer_free(tty, thead);
>> +	if (tty->buf.head == NULL)
>> +		return;
>> +	while ((thead = tty->buf.head->next) != NULL) {
>> +		tty_buffer_free(tty, tty->buf.head);
>> +		tty->buf.head = thead;
> 
> This part of the change seems to have no effect at all. There are no
> locks held so there is nothing guaranteeing how the other processors
> views of the order of operations will be affected.
> 
> Alan
> 

Test program for this problem, 
after revert "commit f8f72f047" without "[PATCH] tty: Correct tty buffer flushing.", 
it cause of "BUG report"(see below) on SMP system linux-3.7.0-rc7.
Both patches resolve problem for this test. But my patch is more right.IMHO. 
And also fix problem with tty_prepare_string*(). 
Thank you.
----------------------------------------------------------------------
#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <stdlib.h>

#define BUF_SIZE 4
#define ERROR_EXIT_CODE 1
#define parent child_id

static int
mfd=-1, sfd=-1, parent=1;

static char
pty_name[24];

static void
pty_exit(int ret, char * exit_message){
	if (sfd >= 0) close(sfd);
	if (mfd >= 0) close(mfd);
	printf("%s %s exit. \n %s",ret?"Error":"Normal", parent?"parent":"child",
			exit_message?exit_message:"");
	exit(ret);
}

static void
pty_init(void){
	int ptn;
	if( (mfd=open("/dev/ptmx", O_RDWR )) < 0 )
		pty_exit(ERROR_EXIT_CODE,"Couldn't open /dev/ptmx. \n");
	if (ioctl(mfd, TIOCGPTN, &ptn) < 0 )
		pty_exit(ERROR_EXIT_CODE,"Couldn't get pty number. \n");
	snprintf(pty_name, sizeof(pty_name), "/dev/pts/%d", ptn);
	printf("Slave pty name = %s.\n",pty_name);
	ptn=0;
	if (ioctl(mfd, TIOCSPTLCK, &ptn) < 0 )
		pty_exit(ERROR_EXIT_CODE,"Couldn't unlock pty slave. \n");
	if ( (sfd=open(pty_name, O_RDWR )) < 0 )
		pty_exit(ERROR_EXIT_CODE, "Couldn't open pty slave. \n");
}

int main(int argc,char *argv[]) {
	pty_init();
	char buf[]={ [0 ... BUF_SIZE-1]='1' };

	child_id=fork();
do {
	if(parent) {
		if ( write(mfd, buf, BUF_SIZE) < 0 )
			pty_exit(ERROR_EXIT_CODE, "Parent's write() error.\n");
	} else { //Child
		if ( tcflush(sfd, TCIFLUSH) < 0 )
			pty_exit(ERROR_EXIT_CODE, "Child's tcflush() error.\n");
	}
}	while(1);
	return 0; //Never
}
----------------------------------------------------------------------

Nov 29 20:42:07 bm kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
Nov 29 20:42:07 bm kernel: IP: [<ffffffff81343294>] tty_insert_flip_string_fixed_flag+0x74/0xd0
Nov 29 20:42:07 bm kernel: PGD 114bc8067 PUD 11149d067 PMD 0 
Nov 29 20:42:07 bm kernel: Oops: 0000 [#1] SMP 
Nov 29 20:42:07 bm kernel: Modules linked in: fuse autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support gpio_ich sg joydev coretemp kvm_intel kvm microcode pcspkr serio_raw i2c_i801 asus_atk0110 hwmon lpc_ich sky2 snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc nvidia(PO) ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic pata_jmicron ahci libahci
Nov 29 20:42:07 bm kernel: CPU 1 
Nov 29 20:42:07 bm kernel: Pid: 8953, comm: a.out Tainted: P           O 3.7.0-rc7-1+ #23 System manufacturer P5K Premium/P5K Premium
Nov 29 20:42:07 bm kernel: RIP: 0010:[<ffffffff81343294>]  [<ffffffff81343294>] tty_insert_flip_string_fixed_flag+0x74/0xd0
Nov 29 20:42:07 bm kernel: RSP: 0018:ffff88011dee5d58  EFLAGS: 00010202
Nov 29 20:42:07 bm kernel: RAX: 0000000000000004 RBX: ffff88012934d000 RCX: ffff880119cfbc00
Nov 29 20:42:07 bm kernel: RDX: 0000000000000246 RSI: ffff880112de1800 RDI: 0000000000000246
Nov 29 20:42:07 bm kernel: RBP: ffff88011dee5da8 R08: ffff880112de1800 R09: 0000000000000000
Nov 29 20:42:07 bm kernel: R10: 00007fffcd7827a0 R11: 0000000000000246 R12: 0000000000000000
Nov 29 20:42:07 bm kernel: R13: 0000000000000004 R14: 0000000000000004 R15: 0000000000000004
Nov 29 20:42:07 bm kernel: FS:  00007f1e28985700(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
Nov 29 20:42:07 bm kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov 29 20:42:07 bm kernel: CR2: 0000000000000018 CR3: 0000000110321000 CR4: 00000000000407e0
Nov 29 20:42:07 bm kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 29 20:42:07 bm kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 29 20:42:07 bm kernel: Process a.out (pid: 8953, threadinfo ffff88011dee4000, task ffff880128ba80c0)
Nov 29 20:42:07 bm kernel: Stack:
Nov 29 20:42:07 bm kernel: ffff88011dee5e78 0000000028852800 ffff880112de1800 0000000000000004
Nov 29 20:42:07 bm kernel: 0000000000000004 ffff880128852800 ffff88012934d000 ffff880112de1800
Nov 29 20:42:07 bm kernel: 0000000000000004 ffff880112de1800 ffff88011dee5dd8 ffffffff8134444b
Nov 29 20:42:07 bm kernel: Call Trace:
Nov 29 20:42:07 bm kernel: [<ffffffff8134444b>] pty_write+0x3b/0x80
Nov 29 20:42:07 bm kernel: [<ffffffff8107bcee>] ? add_wait_queue+0x4e/0x60
Nov 29 20:42:07 bm kernel: [<ffffffff8133e300>] n_tty_write+0x210/0x2e0
Nov 29 20:42:07 bm kernel: [<ffffffff8108ec10>] ? try_to_wake_up+0x2b0/0x2b0
Nov 29 20:42:07 bm kernel: [<ffffffff8133a161>] tty_write+0x1b1/0x290
Nov 29 20:42:07 bm kernel: [<ffffffff8133e0f0>] ? n_tty_ioctl+0xf0/0xf0
Nov 29 20:42:07 bm kernel: [<ffffffff8117d5d8>] vfs_write+0xc8/0x190
Nov 29 20:42:07 bm kernel: [<ffffffff8117de0f>] sys_write+0x5f/0xa0
Nov 29 20:42:07 bm kernel: [<ffffffff810d7a26>] ? __audit_syscall_exit+0x426/0x480
Nov 29 20:42:07 bm kernel: [<ffffffff815b4819>] system_call_fastpath+0x16/0x1b
Nov 29 20:42:07 bm kernel: Code: 00 07 00 00 48 0f 47 f0 48 63 f6 e8 47 fd ff ff 85 c0 41 89 c5 4c 8b a3 a8 01 00 00 74 42 48 98 48 8b 75 c0 45 01 ee 48 89 45 c8 <49> 63 7c 24 18 48 89 c2 49 03 7c 24 08 e8 9a 32 f4 ff 49 63 7c 
Nov 29 20:42:07 bm kernel: RIP  [<ffffffff81343294>] tty_insert_flip_string_fixed_flag+0x74/0xd0
Nov 29 20:42:07 bm kernel: RSP <ffff88011dee5d58>
Nov 29 20:42:07 bm kernel: CR2: 0000000000000018

