Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2DFG0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:26:30 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44875 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2DFG03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:26:29 -0400
MIME-Version: 1.0
In-Reply-To: <1333692989-9230-1-git-send-email-kernelfans@gmail.com>
References: <1333692989-9230-1-git-send-email-kernelfans@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Apr 2012 23:26:07 -0700
X-Google-Sender-Auth: iJa1c_8viO_PMfyMJGLSBAxYMRo
Message-ID: <CA+55aFyT7vCjr0-3qdz_0oNVZ+a3K8A7F7aGVVzYtNdUkovp1Q@mail.gmail.com>
Subject: Re: [PATCH] pid: remove redundant condition
To: Liu Ping Fan <kernelfans@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 11:16 PM, Liu Ping Fan <kernelfans@gmail.com> wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>
> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> ---
>  kernel/pid.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 9f08dfa..e4ca244 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -248,8 +248,7 @@ void put_pid(struct pid *pid)
>                return;
>
>        ns = pid->numbers[pid->level].ns;
> -       if ((atomic_read(&pid->count) == 1) ||
> -            atomic_dec_and_test(&pid->count)) {
> +       if (atomic_dec_and_test(&pid->count) {
>                kmem_cache_free(ns->pid_cachep, pid);
>                put_pid_ns(ns);
>        }

No, this isn't necessarily redundant.

The atomic_dec_and_test() instruction can be very expensive. So if
count was 1 before, we're the last user, and we can free it without
the expensive atomic_dec_and_test().

However, if we are *not* the last user, then we can race with another
user decrementing the count, so now we need to use the expensive
version.

Now, whether that special case is really worth it or not, I don't
know. But it's not redundant.

                    Linus
