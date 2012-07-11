Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab2GKXX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 19:23:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2GKXXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 19:23:25 -0400
Date: Wed, 11 Jul 2012 16:23:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Patch] kernel/sys.c: fix an incorrect error branch in
 orderly_poweroff()
Message-Id: <20120711162323.9f22fa56.akpm@linux-foundation.org>
In-Reply-To: <1341372710-14648-1-git-send-email-amwang@redhat.com>
References: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
	<1341372710-14648-1-git-send-email-amwang@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Jul 2012 11:31:47 +0800
Cong Wang <amwang@redhat.com> wrote:

> From: WANG Cong <xiyou.wangcong@gmail.com>
> 
> When argv_split() fails, argv is NULL, thus we should avoid calling
> agrv_free(argv), and should jump after it.
> 
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> diff --git a/kernel/sys.c b/kernel/sys.c
> index e0c8ffc..ffa510f 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2217,13 +2217,13 @@ int orderly_poweroff(bool force)
>  
>  	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
>  				      NULL, argv_cleanup, NULL);
> -out:
>  	if (likely(!ret))
>  		return 0;
>  
>  	if (ret == -ENOMEM)
>  		argv_free(argv);
>  
> +out:
>  	if (force) {
>  		printk(KERN_WARNING "Failed to start orderly shutdown: "
>  		       "forcing the issue\n");

That code's still pretty stupid-looking, and it's such convoluted code
which leads to bugs of this nature.

Please, always feel free to step back a bit and think about the overall
structure, see if it can be improved.


eg...


From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/sys.c: avoid argv_free(NULL)

If argv_split() failed, the code will end up calling argv_free(NULL).  Fix
it up and clean things up a bit.

Addresses Coverity report 703573.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-avoid-argv_freenull kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-avoid-argv_freenull
+++ a/kernel/sys.c
@@ -2196,25 +2196,25 @@ static void argv_cleanup(struct subproce
 int orderly_poweroff(bool force)
 {
 	int argc;
-	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	char **argv;
 	static char *envp[] = {
 		"HOME=/",
 		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
 		NULL
 	};
-	int ret = -ENOMEM;
+	int ret;
 
+	argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
 	if (argv == NULL) {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
 		       __func__, poweroff_cmd);
-		goto out;
+		return -ENOMEM;
 	}
 
 	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
 				      NULL, argv_cleanup, NULL);
-out:
 	if (likely(!ret))
-		return 0;
+		return 0;		/* success */
 
 	if (ret == -ENOMEM)
 		argv_free(argv);
_

