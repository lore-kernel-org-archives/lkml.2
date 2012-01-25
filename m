Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2AYXac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:30:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2AYXaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:30:30 -0500
Date: Wed, 25 Jan 2012 15:30:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>,
        Vasiliy Kulikov <segoon@openwall.com>, Dan Ballard <dan@mindstab.net>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Colin Walters <walters@verbum.org>
Subject: Re: [PATCH v3] sysctl: control functionality of /proc/pid/mem
Message-Id: <20120125153028.17d69f6e.akpm@linux-foundation.org>
In-Reply-To: <20120123212115.GA29641@www.outflux.net>
References: <20120123212115.GA29641@www.outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 13:21:15 -0800
Kees Cook <keescook@chromium.org> wrote:

> 
> Add the "proc_pid_mem" sysctl to control whether or not /proc/pid/mem is
> allowed to work: 0: disabled, 1: read only, 2: read/write (default).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v3:
>  - document the default, thanks to Randy Dunlap.
>  - remove needless CONFIG_PROC_FS checks, thanks to Eric W. Biederman.

I was wondering about that.  Is CONFIG_PROC_FS=n, CONFIG_SYSCTL=y an
impossible combination?  If so, why?

> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -56,6 +56,7 @@ show up in /proc/sys/kernel:
>  - printk_delay
>  - printk_ratelimit
>  - printk_ratelimit_burst
> +- proc_pid_mem
>  - randomize_va_space
>  - real-root-dev               ==> Documentation/initrd.txt
>  - reboot-cmd                  [ SPARC only ]
> @@ -477,6 +478,20 @@ send before ratelimiting kicks in.
>  
>  ==============================================================
>  
> +proc_pid_mem:
> +
> +This option can be used to select the level of access given to potential
> +ptracers when using the per-process "mem" file in /proc/pid/mem.
> +
> +0 - Disable entirely.
> +
> +1 - Allow potential ptracers read access to process memory, but not writes.
> +
> +2 - Allow potential ptracers read and write access to process memory. This
> +    is the default.
> +
> +==============================================================

I agree with Colin on this (he stole my line!).



Overall, the patch looks really hacky and random.  I felt the same way
as Vasily: it's easy to see how a significant number of similar (and
hacky and random) patches could be added, resulting in a regrettable
mess.

Is there some better designed, more organized way of approaching all of
this?  Random ideas:

- A parallel /procfs-perms filesystem.  You write a number into
  /procfs-perms/stat to affect access to /proc/stat (although why the
  heck not just run `chmod /proc/stat'?) It's unclear how to handle
  /proc/pid/.  Perhaps literally have a /procfs-perms/pid/ directory.

- Make tasks inherit their /proc/pid/* permissions across fork, do a
  chmod /proc/1/whatever in initscripts.

- Other and better things ;)   This particular approach makes my toes
  curl.



