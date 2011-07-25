Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1GYXka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:40:30 -0400
Received: from mother.openwall.net ([195.42.179.200]:52614 "HELO
	mother.openwall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751963Ab1GYXkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:40:22 -0400
Date: Tue, 26 Jul 2011 03:40:13 +0400
From: Solar Designer <solar@openwall.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>,
        Sebastian Krahmer <krahmer@suse.de>
Subject: Re: [kernel-hardening] [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
Message-ID: <20110725234013.GB24110@openwall.com>
References: <20110715170650.585f1dad@notabene.brown> <20110715073823.GA3821@albatros> <1310738313.30257.27.camel@moss-pluto> <20110715152641.GA6286@albatros> <1310759683.30257.123.camel@moss-pluto> <20110721140936.632d2c8b@notabene.brown> <20110721124830.GA1325@openwall.com> <CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com> <20110721193939.GA3914@openwall.com> <20110725171423.GA3739@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725171423.GA3739@albatros>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy,

On Mon, Jul 25, 2011 at 09:14:23PM +0400, Vasiliy Kulikov wrote:
> @@ -1433,6 +1433,19 @@ static int do_execve_common(const char *filename,
>  	struct files_struct *displaced;
>  	bool clear_in_exec;
>  	int retval;
> +	const struct cred *cred = current_cred();
> +
> +	/*
> +	 * We move the actual failure in case of RLIMIT_NPROC excess from
> +	 * set*uid() to execve() because too many poorly written programs
> +	 * don't check setuid() return code.  Here we additionally recheck
> +	 * whether NPROC limit is still exceeded.
> +	 */
> +	if ((current->flags & PF_NPROC_EXCEEDED) &&
> +	    atomic_read(&cred->user->processes) > rlimit(RLIMIT_NPROC)) {
> +		retval = -EAGAIN;
> +		goto out_ret;
> +	}

Do you possibly need:

	current->flags &= ~PF_NPROC_EXCEEDED;

somewhere after this point?

I think it's weird to have past set_user() failure affect other than the
very next execve().

Perhaps also reset the flag on fork() because we have an RLIMIT_NPROC
check on fork() anyway.

Thanks,

Alexander
