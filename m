Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab2CWXPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 19:15:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2CWXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:15:05 -0400
Date: Fri, 23 Mar 2012 16:15:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Arkadiusz =?UTF-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Message-Id: <20120323161504.dced28b9.akpm@linux-foundation.org>
In-Reply-To: <20120323171058.GA3279@albatros>
References: <201203220903.15360.a.miskiewicz@gmail.com>
	<20120323171058.GA3279@albatros>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012 21:10:58 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> proc_parse_options() inside of proc_mount() runs only once at the boot
> time without any given options.  So, following umount(2)+mount(2) ignore
> mount options: proc_parse_options() is not called as ->s_root is already
> initialized.  To fix that parse mount options unconditionally.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> Reported-by: Arkadiusz Mi__kiewicz <a.miskiewicz@gmail.com>
> ---
>  fs/proc/root.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 46a15d8..eed44bf 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -115,12 +115,13 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
>  	if (IS_ERR(sb))
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

I'm surprised.  "mount -o remount,<options>" doesn't work on a mounted
procfs, and nobody noticed until now?

The patch looks OK - has it been tested with both valid and invalid
mount options?


I redid the changelog:


From: Vasiliy Kulikov <segoon@openwall.com>
Subject: proc: fix mount -t proc -o AAA

The proc_parse_options() call from proc_mount() runs only once at boot
time.  So on any later mount attempt, any mount options are ignored
because ->s_root is already initialized.

As a consequence, "mount -o remount,<options>" will ignore the options.

To fix this, parse the mount options unconditionally.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/proc/root.c~proc-fix-mount-t-proc-o-aaa fs/proc/root.c
--- a/fs/proc/root.c~proc-fix-mount-t-proc-o-aaa
+++ a/fs/proc/root.c
@@ -115,12 +115,13 @@ static struct dentry *proc_mount(struct 
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 
+	if (!proc_parse_options(options, ns)) {
+		deactivate_locked_super(sb);
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (!sb->s_root) {
 		sb->s_flags = flags;
-		if (!proc_parse_options(options, ns)) {
-			deactivate_locked_super(sb);
-			return ERR_PTR(-EINVAL);
-		}
 		err = proc_fill_super(sb);
 		if (err) {
 			deactivate_locked_super(sb);
_

