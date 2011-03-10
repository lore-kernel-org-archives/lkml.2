Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab1CJWqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:46:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45004 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1CJWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:46:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=emlq+zAyewjuUdPd8JcMRsLTNj7HezOqRWocgL1KR7Qf7e3slbyrcoXLfsWP/wLSXW
         3s3Z3qX16Cri2X52qgxt9JALEkZymkysIhSfvQoTRhoO7sls2pV26Kv5SlWXzaKa3bmu
         xf8rORKFMzpeHF028xK8dYkustm+jFj/PgYfQ=
Date: Thu, 10 Mar 2011 23:46:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, ssp@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cleanups] x86, dumpstack: Correct stack dump info
 when frame pointer is available
Message-ID: <20110310224604.GA1837@nowhere>
References: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
 <tip-074206a787e4dfdc4c290789ab6604c7f9e691ca@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-074206a787e4dfdc4c290789ab6604c7f9e691ca@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 10:24:53PM +0000, tip-bot for Namhyung Kim wrote:
> Commit-ID:  074206a787e4dfdc4c290789ab6604c7f9e691ca
> Gitweb:     http://git.kernel.org/tip/074206a787e4dfdc4c290789ab6604c7f9e691ca
> Author:     Namhyung Kim <namhyung@gmail.com>
> AuthorDate: Tue, 8 Mar 2011 20:44:19 +0900
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 10 Mar 2011 23:20:30 +0100
> 
> x86, dumpstack: Correct stack dump info when frame pointer is available
> 
> Current stack dump code scans entire stack and checks each entry for a
> pointer to kernel code. If CONFIG_FRAME_POINTER=y it could mark
> whether the pointer is valid or not based on value of the frame
> pointer. Invalid entries could be preceded by '?' sign.
> 
> However this was not going to happen because scan start point was
> always higher than the frame pointer so that they could not meet.
> 
> Commit 9c0729dc8062 ("x86: Eliminate bp argument from the stack
> tracing routines") delayed bp acquisition point, so the bp was
> read in lower frame, thus all of the entries were marked invalid.
> 
> This patch fixes this by reverting above commit while retaining
> stack_frame() helper as suggested by Frederic Weisbecker.
> End result looks like below:
> 
> before:
> [    3.508329] Call Trace:
> [    3.508551]  [<ffffffff814f35c9>] ? panic+0x91/0x199
> [    3.508662]  [<ffffffff814f3739>] ? printk+0x68/0x6a
> [    3.508770]  [<ffffffff81a981b2>] ? mount_block_root+0x257/0x26e
> [    3.508876]  [<ffffffff81a9821f>] ? mount_root+0x56/0x5a
> [    3.508975]  [<ffffffff81a98393>] ? prepare_namespace+0x170/0x1a9
> [    3.509216]  [<ffffffff81a9772b>] ? kernel_init+0x1d2/0x1e2
> [    3.509335]  [<ffffffff81003894>] ? kernel_thread_helper+0x4/0x10
> [    3.509442]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
> [    3.509542]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
> [    3.509641]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
> 
> after:
> [    3.522991] Call Trace:
> [    3.523351]  [<ffffffff814f35b9>] panic+0x91/0x199
> [    3.523468]  [<ffffffff814f3729>] ? printk+0x68/0x6a
> [    3.523576]  [<ffffffff81a981b2>] mount_block_root+0x257/0x26e
> [    3.523681]  [<ffffffff81a9821f>] mount_root+0x56/0x5a
> [    3.523780]  [<ffffffff81a98393>] prepare_namespace+0x170/0x1a9
> [    3.523885]  [<ffffffff81a9772b>] kernel_init+0x1d2/0x1e2
> [    3.523987]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
> [    3.524228]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
> [    3.524345]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
> [    3.524445]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Soren Sandmann <ssp@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---

Nice fix, thanks!
