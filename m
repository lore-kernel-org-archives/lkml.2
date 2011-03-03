Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab1CCP5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:57:40 -0500
Received: from smtp.nokia.com ([147.243.1.48]:50898 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758198Ab1CCP5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:57:39 -0500
Date: Thu, 3 Mar 2011 17:52:49 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Ken Sumrall <ksumrall@android.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <e@mx-da02.nokia.com>
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
	remount filesystems ro
Message-ID: <20110303155248.GC4245@esdhcp04044.research.nokia.com>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299137483-10975-1-git-send-email-ksumrall@android.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/11 23:31 -0800, ext Ken Sumrall wrote:
> Add 4 new commands to the reboot system call, that do the same thing as the
> RESTART, HALT, POWER_OFF, and RESTART2 commands, but also remount writable
> filesystems as read-only just before doing what the command normally does.
> Now that Android is using EXT4, and since we don't have a standard init
> setup to unmount filesystems before rebooting, this allows the system to
> reboot with clean filesystems, and also improves boot time as the journal
> does not need to be replayed when mounting the filesystem.
> 
> Signed-off-by: Ken Sumrall <ksumrall@android.com>
> ---
...
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 7f5a0cd..3f474e6 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -392,6 +392,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  	mutex_lock(&reboot_mutex);
>  	switch (cmd) {
>  	case LINUX_REBOOT_CMD_RESTART:
> +	case LINUX_REBOOT_CMD_RMNT_RESTART:
> +		if (cmd == LINUX_REBOOT_CMD_RMNT_RESTART)
> +			emergency_remount_synchronous();
>  		kernel_restart(NULL);
>  		break;

What happened to fall through cases?

 	switch (cmd) {
+	case LINUX_REBOOT_CMD_RMNT_RESTART:
+		emergency_remount_synchronous();
 	case LINUX_REBOOT_CMD_RESTART:
		kernel_restart(NULL);
 		break;

Ditto for the other related hunks. 

Then again, I agree with the other responders, in particular those about fixing 
problems with init in init itself.

Phil
