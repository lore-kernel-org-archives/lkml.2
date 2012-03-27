Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2C0SF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:05:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63805 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2C0SFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120323190855.GA27213@www.outflux.net>
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
	<20120323190855.GA27213@www.outflux.net>
Date: Tue, 27 Mar 2012 14:05:24 -0400
Message-ID: <CA+5PVA5FR_QoTtNVV04VXrjOujAMFHMXF4-GnyZHLPUGnvb3zA@mail.gmail.com>
Subject: Re: [PATCH v2] futex: mark get_robust_list as deprecated
From: Josh Boyer <jwboyer@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        spender@grsecurity.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 3:08 PM, Kees Cook <keescook@chromium.org> wrote:
> Notify get_robust_list users that the syscall is going away.
>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>  - add note to feature-removal-schedule.txt.
> ---
>  Documentation/feature-removal-schedule.txt |   10 ++++++++++
>  kernel/futex.c                             |    2 ++
>  kernel/futex_compat.c                      |    2 ++
>  3 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 4bfd982..e3bf119 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -543,3 +543,13 @@ When:      3.5
>  Why:   The old kmap_atomic() with two arguments is deprecated, we only
>        keep it for backward compatibility for few cycles and then drop it.
>  Who:   Cong Wang <amwang@redhat.com>
> +
> +----------------------------
> +
> +What:  get_robust_list syscall
> +When:  2013
> +Why:   There appear to be no production users of the get_robust_list syscall,
> +       and it runs the risk of leaking address locations, allowing the bypass
> +       of ASLR. It was only ever intended for debugging, so it should be
> +       removed.
> +Who:   Kees Cook <keescook@chromium.org>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index d701be5..e2b0fb9 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2449,6 +2449,8 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
>        if (!futex_cmpxchg_enabled)
>                return -ENOSYS;
>
> +       WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
> +

Do you really need WARN_ONCE?  It's going to spew a backtrace if this
is called, and that is going to cause various auto-bug reporters to file
bugs as well.  There's nothing that can be done with those bugs other
than to wait until this is removed.  Maybe it won't trigger because
nobody is using it, but ugh.

Is printk_once sufficient?

josh
