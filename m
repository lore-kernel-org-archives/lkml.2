Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0JAMoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:44:37 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:52748 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0JAMog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:44:36 -0400
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201009302207.IJB81715.tFSLFHFOVJOOMQ@I-love.SAKURA.ne.jp>
In-Reply-To: <201009302207.IJB81715.tFSLFHFOVJOOMQ@I-love.SAKURA.ne.jp>
Message-Id: <201010012144.JBJ78166.FFMOQJLOVOSHtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 1 Oct 2010 21:44:33 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1413,6 +1413,9 @@ int do_execve(const char * filename,
>  	free_bprm(bprm);
>  	if (displaced)
>  		put_files_struct(displaced);
> +	/* Just for testing. */
> +	if (!retval)
> +		retval = 1;
>  	return retval;
>  
>  out:
> 
> With a patch above (on x86 CentOS 5.5 with 2.6.36-rc6 kernel),
> a few programs failed to work properly.
> 
>   udevd-event[$PID]: run_program: '$PROGRAM' abnormal exit
> 
I found below messages in dmesg when above error message is printed.

[   16.082683] usb_id[2097]: segfault at dfa68ce8 ip 0806ffb7 sp bf892b30 error 5 in usb_id[8048000+cd000]
[   16.732016] scsi_id[2133]: segfault at dfa37e78 ip 08071157 sp bf85d640 error 5 in scsi_id[8048000+cf000]
[   16.754163] scsi_id[2138]: segfault at e002ca08 ip 08071157 sp bfe521d0 error 4 in scsi_id[8048000+cf000]
[   16.910293] scsi_id[2162]: segfault at e008def8 ip 08071157 sp bfeb36c0 error 4 in scsi_id[8048000+cf000]
[   16.971028] scsi_id[2167]: segfault at dff9f908 ip 08071157 sp bfdc50d0 error 5 in scsi_id[8048000+cf000]
[   17.435741] vol_id[2177]: segfault at e017d258 ip 08072bb7 sp bff9c0a0 error 4 in vol_id[8048000+d0000]
[   17.497793] vol_id[2179]: segfault at dfc82ab8 ip 08072bb7 sp bfaa1900 error 5 in vol_id[8048000+d0000]
[   17.676152] edd_id[2197]: segfault at dff0de58 ip 0806f097 sp bfd3b920 error 5 in edd_id[8048000+ca000]
[   17.678064] edd_id[2196]: segfault at dff55a38 ip 0806f097 sp bfd83500 error 5 in edd_id[8048000+ca000]
[   18.317277] vol_id[2210]: segfault at e00c8a48 ip 08072bb7 sp bfee7890 error 4 in vol_id[8048000+d0000]

And I confirmed that applying below patch in addition to above patch solves
these segfault failures.

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -315,7 +315,7 @@ long sys_execve(const char __user *name,
 	error = do_execve(filename, argv, envp, regs);
 
 #ifdef CONFIG_X86_32
-	if (error == 0) {
+	if (error >= 0) {
 		/* Make sure we don't return using sysenter.. */
                 set_thread_flag(TIF_IRET);
         }

This result indicates that sys_execve() expected that do_execve() returns 0
if do_execve() successfully replaced the current process's image.

Now, the question is "when is do_execve() > 0 allowed"?
If do_execve() > 0 is allowed when the current process's image was successfully
replaced, we need to either "modify do_execve() callers not to assume 0 on
success" or "modify do_execve() return 0 on success".



Regards.
