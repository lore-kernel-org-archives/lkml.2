Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2KUAS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:18:56 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33421 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2KUASz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:18:55 -0500
Date: Wed, 21 Nov 2012 00:24:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>,
        Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v2] devtmpfs: mount with noexec and nosuid
Message-ID: <20121121002412.1c957ad2@pyramind.ukuu.org.uk>
In-Reply-To: <CAGXu5jKS1OQPxiBPewtfOTJqntOMFnw4n08-zP7=87nD+z6eSg@mail.gmail.com>
References: <20121120204238.GA19554@www.outflux.net>
	<20121120211312.57f1b63d@pyramind.ukuu.org.uk>
	<CAGXu5jJv58UGwsWM=+ZSnaNpymh6Sm6xSjc0JuT+QoZ9U2++rw@mail.gmail.com>
	<20121120235353.3092c8d2@pyramind.ukuu.org.uk>
	<CAGXu5jKS1OQPxiBPewtfOTJqntOMFnw4n08-zP7=87nD+z6eSg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You just broke my bullshitometer
> >
> > It's a single syscall from your init binary, its microseconds.
> 
> Whatever, I still see it as a needless inefficiency.

As opposed to adding permanent kernel code and having to change the
setting by recompilation, and not being able to deploy this with older
kernels.

Right now you can add one call to your user space and it just works, with
old kernels, with new kernels, with Android etc. You think its *more
efficient* to add permanently loaded kernel hacks.

Wrong. Big time wrong. A page is 4096 bytes, your change is probably
about 8. So 1 in 512 builds will see an extra page of kernel space used
assuming an even distribution. For each of those users the moment they've
had a few page faults your solution is *less* efficient, and the moment
they've paged one page because of having less memory your solution has
become vastly less efficient.

So can we put the crap about efficiency away please. This basically reads
like

"Mummy, the mount syscall looks complicated let me hack everyones kernel
 with a crass extra Kconfig option because I'm crap"

> > You don't want to stop mmap with PROT_EXEC on /dev/mem as that breaks a
> > load of stuff, you want to stop people adding stuff to that file system
> > and executing it.
> 
> Well, initially the latter, yes. But as it turns out, setting noexec
> also stops PROT_EXEC on /dev/mem. Since the systems I'm building for
> all use KMS, there's no need to execute regions of /dev/mem (e.g. VESA
> BIOS init, etc).

I have news for you: this is the upstream kernel, you specific personal
needs should not define what is good design - this isn't GNOME.

If you block exec on anything but devices then all is happy. You could
even block it on anything but specific devices. At that point you could
get rid of the config option and make it more useful.

We don't need extra confusion Kconfig options, we don't need extra kernel
code combinations to fail to maintain. Your patch offers *NO* feature
advantages over the existing kernel.

NAK


Alan
