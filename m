Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0KBSqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 14:46:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59760 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0KBSqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 14:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=lpSHTkjx/Ynnol7l3HKEHKJS4RgaexMvIf7NC3Jw0OUCPVB7ukQLtU5coz/Ww4BQE+
         FsMBQZxDcK5KAuQDUn2AfbU5SOCgi+DL2IlAi+qnIkUN0eJ3qBbcGGut7QHP6BYn7U4I
         J+Im4xPXsT6npBSq2FRhKoG08SzBIgbgHAQO4=
MIME-Version: 1.0
In-Reply-To: <20101102182911.GE25614@thunk.org>
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de> <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
 <20101102182911.GE25614@thunk.org>
From: kevin granade <kevin.granade@gmail.com>
Date: Tue, 2 Nov 2010 13:46:23 -0500
Message-ID: <AANLkTim9JbCk29oPjrYMSfhtHL4tL4uHtDq_xZoe7tzg@mail.gmail.com>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this function
To: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 1:29 PM, Ted Ts'o <tytso@mit.edu> wrote:
>
> On Mon, Nov 01, 2010 at 04:27:26PM +0100, Lukas Czerner wrote:
> >
> > thank you for noticing this, because I actually do not see the warning
> > (I wonder why...), but it is definitely a bug, so the trivial patch below
> > should fix that.
>
> This is a slightly less trivial fix that eliminates the need for the
> "ret" variable entirely.
>
>                                                - Ted
>
> commit e048924538f0c62d18306e2fea0e22dac0140f6e
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Nov 2 14:19:30 2010 -0400
>
>    ext4: "ret" may be used uninitialized in ext4_lazyinit_thread()
>
>    Newer GCC's reported the following build warning:
>
>       fs/ext4/super.c: In function 'ext4_lazyinit_thread':
>       fs/ext4/super.c:2702: warning: 'ret' may be used uninitialized in this function
>
>    Fix it by removing the need for the ret variable in the first place.
>
>    Signed-off-by: "Lukas Czerner" <lczerner@redhat.com>
>    Reported-by: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
>    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8d1d942..4d7ef31 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2699,7 +2699,6 @@ static int ext4_lazyinit_thread(void *arg)
>        struct ext4_li_request *elr;
>        unsigned long next_wakeup;
>        DEFINE_WAIT(wait);
> -       int ret;
>
>        BUG_ON(NULL == eli);
>
> @@ -2723,13 +2722,12 @@ cont_thread:
>                        elr = list_entry(pos, struct ext4_li_request,
>                                         lr_request);
>
> -                       if (time_after_eq(jiffies, elr->lr_next_sched))
> -                               ret = ext4_run_li_request(elr);
> -
> -                       if (ret) {
> -                               ret = 0;
> -                               ext4_remove_li_request(elr);
> -                               continue;
> +                       if (time_after_eq(jiffies, elr->lr_next_sched)) {
> +                               if (ext4_run_li_request(elr) != 0) {
> +                                       /* error, remove the lazy_init job */
> +                                       ext4_remove_li_request(elr);
> +                                       continue;
> +                               }
>                        }
>
>                        if (time_before(elr->lr_next_sched, next_wakeup))

What do you think about this option for the second hunk? (not anything-tested)

@@ -2723,13 +2722,11 @@ cont_thread:
                       elr = list_entry(pos, struct ext4_li_request,
                                        lr_request);
-                       if (time_after_eq(jiffies, elr->lr_next_sched))
-                               ret = ext4_run_li_request(elr);
-
-                       if (ret) {
-                               ret = 0;
-                               ext4_remove_li_request(elr);
-                               continue;
+                       if (time_after_eq(jiffies, elr->lr_next_sched) &&
+                           ext4_run_li_request(elr) != 0) {
+                               /* error, remove the lazy_init job */
+                               ext4_remove_li_request(elr);
+                               continue;
                       }

                       if (time_before(elr->lr_next_sched, next_wakeup))
--

Though obviously it's a pretty subjective style issue.
Kevin Granade

> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
