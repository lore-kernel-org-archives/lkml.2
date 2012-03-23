Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab2CWSpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 14:45:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44571 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759426Ab2CWSpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 14:45:24 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Date: Fri, 23 Mar 2012 19:45:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-final-dirty; KDE/4.8.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
References: <201203220903.15360.a.miskiewicz@gmail.com> <20120323171058.GA3279@albatros>
In-Reply-To: <20120323171058.GA3279@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203231945.19501.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 of March 2012, Vasiliy Kulikov wrote:

> Thanks for the report.  Please test the following patch.

Seems to be working fine, now - thanks!



> 
> --------------------------------------------------------------
> From: Vasiliy Kulikov <segoon@openwall.com>
> Date: Fri, 23 Mar 2012 20:56:42 +0400
> Subject: [PATCH] proc: fix mount -t proc -o AAA
> 
> proc_parse_options() inside of proc_mount() runs only once at the boot
> time without any given options.  So, following umount(2)+mount(2) ignore
> mount options: proc_parse_options() is not called as ->s_root is already
> initialized.  To fix that parse mount options unconditionally.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> Reported-by: Arkadiusz Miśkiewicz <a.miskiewicz@gmail.com>
> ---
>  fs/proc/root.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 46a15d8..eed44bf 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -115,12 +115,13 @@ static struct dentry *proc_mount(struct
> file_system_type *fs_type, if (IS_ERR(sb))
>  		return ERR_CAST(sb);
> 
> +	if (!proc_parse_options(options, ns)) {
> +		deactivate_locked_super(sb);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	if (!sb->s_root) {
>  		sb->s_flags = flags;
> -		if (!proc_parse_options(options, ns)) {
> -			deactivate_locked_super(sb);
> -			return ERR_PTR(-EINVAL);
> -		}
>  		err = proc_fill_super(sb);
>  		if (err) {
>  			deactivate_locked_super(sb);


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
