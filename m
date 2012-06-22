Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678Ab2FVTzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:55:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab2FVTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:55:53 -0400
Date: Fri, 22 Jun 2012 12:55:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rob Landley <rob@landley.net>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Doug Ledford <dledford@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] fs: introduce pipe-only dump mode suid_dumpable=3
Message-Id: <20120622125551.269552c2.akpm@linux-foundation.org>
In-Reply-To: <20120622192413.GA5774@www.outflux.net>
References: <20120622192413.GA5774@www.outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 12:24:13 -0700
Kees Cook <keescook@chromium.org> wrote:

> The value
> of suid_dumpable=2 is now historic, and attempting to set this sysctl
> value returns -EINVAL.

This sounds a bit harsh - will it not cause existing configurations to
immediately break?  If so, would it not be better to retain the =2 mode
for a while, and emit a nice warning when it is set?

>
> ...
>
> +/* Allow only the valid suid_dumpable values. */
> +static int do_proc_dointvec_suid_dumpable_conv(bool *negp,
> +		unsigned long *lvalp, int *valp, int write, void *data)
> +{
> +	if (write) {
> +		int val = *negp ? -*lvalp : *lvalp;
> +		if (val != SUID_DUMPABLE_DISABLED &&
> +		    val != SUID_DUMPABLE_ENABLED &&
> +		    val != SUID_DUMPABLE_PIPE_ONLY)
> +			return -EINVAL;
> +		*valp = val;
> +	} else {
> +		int val = *valp;
> +		if (val < 0) {
> +			*negp = true;
> +			*lvalp = (unsigned long)-val;
> +		} else {
> +			*negp = false;
> +			*lvalp = (unsigned long)val;

Those two typecasts are unneeded.

> +		}
> +	}
> +	return 0;
> +}
> +

