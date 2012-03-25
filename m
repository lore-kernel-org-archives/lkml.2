Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2CYHYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 03:24:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40678 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2CYHYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 03:24:12 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Date: Sun, 25 Mar 2012 09:24:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.0-06946-gf1d38e4; KDE/4.8.1; x86_64; ; )
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
References: <201203220903.15360.a.miskiewicz@gmail.com> <20120323171058.GA3279@albatros> <20120323161504.dced28b9.akpm@linux-foundation.org>
In-Reply-To: <20120323161504.dced28b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203250924.06908.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 of March 2012, Andrew Morton wrote:
> On Fri, 23 Mar 2012 21:10:58 +0400
> 
> Vasiliy Kulikov <segoon@openwall.com> wrote:
> > proc_parse_options() inside of proc_mount() runs only once at the boot
> > time without any given options.  So, following umount(2)+mount(2) ignore
> > mount options: proc_parse_options() is not called as ->s_root is already
> > initialized.  To fix that parse mount options unconditionally.
> > 
> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> > Reported-by: Arkadiusz Mi__kiewicz <a.miskiewicz@gmail.com>
> > ---
> > 
> >  fs/proc/root.c |    9 +++++----
> >  1 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/proc/root.c b/fs/proc/root.c
> > index 46a15d8..eed44bf 100644
> > --- a/fs/proc/root.c
> > +++ b/fs/proc/root.c
> > @@ -115,12 +115,13 @@ static struct dentry *proc_mount(struct
> > file_system_type *fs_type,
> > 
> >  	if (IS_ERR(sb))
> >  	
> >  		return ERR_CAST(sb);
> > 
> > +	if (!proc_parse_options(options, ns)) {
> > +		deactivate_locked_super(sb);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +
> > 
> >  	if (!sb->s_root) {
> >  	
> >  		sb->s_flags = flags;
> > 
> > -		if (!proc_parse_options(options, ns)) {
> > -			deactivate_locked_super(sb);
> > -			return ERR_PTR(-EINVAL);
> > -		}
> > 
> >  		err = proc_fill_super(sb);
> >  		if (err) {
> >  		
> >  			deactivate_locked_super(sb);
> 
> I'm surprised.  "mount -o remount,<options>" doesn't work on a mounted
> procfs, and nobody noticed until now?

For me initial mount -o options didn't apply these options. Then mount -o 
remount,options applied these.

> The patch looks OK - has it been tested with both valid and invalid
> mount options?

Well, it fixes my initial case where initial mount failed to apply options.

Just tested with invalid options.

[   18.518529] proc: unrecognized mount option "crap" or missing value

but there is another problem - unmounting it and mounting without options 
causes old option to persist:

# mount none /proc -t proc -o hidepid=2
# umount /proc
# mount none /proc -t proc
# grep "/proc" /proc/mounts
none /proc proc rw,relatime,hidepid=2 0 0

There should be no hidepid=2 now.

> I redid the changelog:
> 
> 
> From: Vasiliy Kulikov <segoon@openwall.com>
> Subject: proc: fix mount -t proc -o AAA
> 
> The proc_parse_options() call from proc_mount() runs only once at boot
> time.  So on any later mount attempt, any mount options are ignored
> because ->s_root is already initialized.
> 
> As a consequence, "mount -o remount,<options>" will ignore the options.

So this changelog doesn't match what I saw.

> 
> To fix this, parse the mount options unconditionally.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/proc/root.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff -puN fs/proc/root.c~proc-fix-mount-t-proc-o-aaa fs/proc/root.c
> --- a/fs/proc/root.c~proc-fix-mount-t-proc-o-aaa
> +++ a/fs/proc/root.c
> @@ -115,12 +115,13 @@ static struct dentry *proc_mount(struct
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
> _


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
