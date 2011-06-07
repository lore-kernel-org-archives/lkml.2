Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab1FGTJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:09:06 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57321 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab1FGTJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:09:05 -0400
Date: Tue, 7 Jun 2011 15:07:42 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>, Xiaotian Feng <dfeng@redhat.com>
Subject: Re: [PATCH] do_coredump: fix the "ispipe" error check
Message-ID: <20110607190742.GA16974@hmsreliant.think-freely.org>
References: <1307457010-7241-1-git-send-email-jslaby@suse.cz>
 <20110607181607.GA3732@redhat.com>
 <20110607183542.GA5559@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607183542.GA5559@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 08:35:42PM +0200, Oleg Nesterov wrote:
> do_coredump() assumes that if format_corename() fails it should
> return -ENOMEM. This is not true, for example cn_print_exe_file()
> can propagate the error from d_path. Even if it was true, this is
> too fragile. Change the code to check "ispipe < 0".
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  fs/exec.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- ptrace/fs/exec.c~corename_errcode	2011-06-07 19:44:30.000000000 +0200
> +++ ptrace/fs/exec.c	2011-06-07 20:20:48.000000000 +0200
> @@ -2092,16 +2092,16 @@ void do_coredump(long signr, int exit_co
>  
>  	ispipe = format_corename(&cn, signr);
>  
> -	if (ispipe == -ENOMEM) {
> -		printk(KERN_WARNING "format_corename failed\n");
> -		printk(KERN_WARNING "Aborting core\n");
> -		goto fail_corename;
> -	}
> -
>   	if (ispipe) {
>  		int dump_count;
>  		char **helper_argv;
>  
> +		if (ispipe < 0) {
> +			printk(KERN_WARNING "format_corename failed\n");
> +			printk(KERN_WARNING "Aborting core\n");
> +			goto fail_corename;
> +		}
> +
>  		if (cprm.limit == 1) {
>  			/*
>  			 * Normally core limits are irrelevant to pipes, since
> 
> 
Looks good. Thanks!
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>
