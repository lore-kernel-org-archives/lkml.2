Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0LBBMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:12:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755890Ab0LBBMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:12:38 -0500
Date: Wed, 1 Dec 2010 17:12:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nelson Elhage <nelhage@ksplice.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH v2] do_exit(): Make sure we run with get_fs() ==
 USER_DS.
Message-Id: <20101201171205.f49f537a.akpm@linux-foundation.org>
In-Reply-To: <1291170456-22580-1-git-send-email-nelhage@ksplice.com>
References: <20101130174947.5ccc3778.akpm@linux-foundation.org>
	<1291170456-22580-1-git-send-email-nelhage@ksplice.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 21:27:36 -0500
Nelson Elhage <nelhage@ksplice.com> wrote:

> If a user manages to trigger an oops with fs set to KERNEL_DS, fs is not
> otherwise reset before do_exit(). do_exit may later (via mm_release in fork.c)
> do a put_user to a user-controlled address, potentially allowing a user to
> leverage an oops into a controlled write into kernel memory.
> 
> A more logical place to put this might be when we know an oops has occurred,
> before we call do_exit(), but that would involve changing every architecture, in
> multiple places. Let's just stick it in do_exit instead.
> 
> Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
> ---
>  kernel/exit.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 21aa7b3..68899b3 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -914,6 +914,14 @@ NORET_TYPE void do_exit(long code)
>  	if (unlikely(!tsk->pid))
>  		panic("Attempted to kill the idle task!");
>  
> +	/*
> +	 * If do_exit is called because this processes oopsed, it's possible
> +	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
> +	 * continuing. This is relevant at least for clearing clear_child_tid in
> +	 * mm_release.
> +	 */
> +	set_fs(USER_DS);
> +
>  	tracehook_report_exit(&code);
>  
>  	validate_creds_for_do_exit(tsk);

I think that the potential of escalating an oops or a BUG into a local
root hole is pretty serious so I'll send this fix along for 2.6.37 and
I tagged it for -stable backporting, along with a sterner-sounding
changelog.



From: Nelson Elhage <nelhage@ksplice.com>

If a user manages to trigger an oops with fs set to KERNEL_DS, fs is not
otherwise reset before do_exit().  do_exit may later (via mm_release in
fork.c) do a put_user to a user-controlled address, potentially allowing a
user to leverage an oops into a controlled write into kernel memory.

This is only triggerable in the presence of another bug, but this
potentially turns a lot of DoS bugs into privilege escalations, so it's
worth fixing.  I have proof-of-concept code which uses this bug along with
CVE-2010-3849 to write a zero to an arbitrary kernel address, so I've
tested that this is not theoretical.


A more logical place to put this fix might be when we know an oops has
occurred, before we call do_exit(), but that would involve changing every
architecture, in multiple places.  Let's just stick it in do_exit instead.

[akpm@linux-foundation.org: update code comment]
Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds kernel/exit.c
--- a/kernel/exit.c~do_exit-make-sure-we-run-with-get_fs-==-user_ds
+++ a/kernel/exit.c
@@ -914,6 +914,15 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	/*
+	 * If do_exit is called because this processes oopsed, it's possible
+	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
+	 * continuing. Amongst other possible reasons, this is to prevent
+	 * mm_release()->clear_child_tid() from writing to a user-controlled
+	 * kernel address.
+	 */
+	set_fs(USER_DS);
+
 	tracehook_report_exit(&code);
 
 	validate_creds_for_do_exit(tsk);
_

