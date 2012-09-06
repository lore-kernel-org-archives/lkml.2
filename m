Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2IFIAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:00:23 -0400
Received: from ozlabs.org ([203.10.76.45]:60861 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab2IFIAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:00:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: David Howells <dhowells@redhat.com>, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] module: signature infrastructure
In-Reply-To: <CAKi4VA+R0EY9OteOCc=JGOqtshAJd5_CWu9tyJqjjkvG6qZUjw@mail.gmail.com>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk> <87627ufi2h.fsf@rustcorp.com.au> <CAKi4VALezG7VccXJfwvzr2UZrmAjCUp9eZRjGwqq6cWcExNqXA@mail.gmail.com> <874nndl3ro.fsf@rustcorp.com.au> <CAKi4VA+R0EY9OteOCc=JGOqtshAJd5_CWu9tyJqjjkvG6qZUjw@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 17:25:27 +0930
Message-ID: <87a9x3io0g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
> Sorry to come up with this suggestion only now (and after you have
> already talked to me at LPC). Only after seeing this implementation I
> thought about the implications of having the module signed in this
> format.
...
> I'm worried about performance here. Module loading can take a fair
> amount of boot time. It may not be critical for servers or desktops
> that we rarely boot, but it is for embedded uses.
...
> Letting it in be32 is the simplest solution IMO. it's way simpler then
> the loop above.
...
>> Scanning the module is the least of our issues since we've just copied
>> it and we're about to SHA it.
>
> Yeah, but I don't think we need to scan it one more time. On every
> boot. For every module

Regretfully, I don't have Linus' talent for flamage.

There's no measurable performance impact.  Scanning 1k takes about
5usec; we've wasted about enough time on this subject to load a billion
kernel modules.

I know this.  Not because I'm brilliant, but because I *measured* it.  I
even pulled out my original module signature signing check code, and
that was both faster and simpler.  See below.

Your assertion that the length-prepended version is "way simpler" is
wrong.  Again, I know this because I *read the code*:

        https://git.kernel.org/?p=linux/kernel/git/kasatkin/linux-digsig.git;a=commitdiff;h=19eef6e4e529ccf2b3a6ab5c19dd40f2eaf8fcaf

Don't send any more lazy, unthoughtful mails to the list.  It's
disrespectful and makes me grumpy.

Rusty.
PS.  Pushed updated version to my kernel.org linux.git/module-signing branch.

#ifdef CONFIG_MODULE_SIG
static int module_sig_check(struct load_info *info,
			    const void *mod, unsigned long *len)
{
	int err = 0;
	const unsigned long markerlen = strlen(MODULE_SIG_STRING);
	const void *p = mod, *end = mod + *len;

	/* Poor man's memmem. */
	while ((p = memchr(p, MODULE_SIG_STRING[0], end - p))) {
		if (p + markerlen > end)
			break;

		if (memcmp(p, MODULE_SIG_STRING, markerlen) == 0) {
			const void *sig = p + markerlen;
			/* Truncate module up to signature. */
			*len = p - mod;
			err = mod_verify_sig(mod, *len,
					     sig, end - sig,
					     &info->sig_ok);
			break;
		}
		p++;
	}

	/* Not having a signature is only an error if we're strict. */
	if (!err && !info->sig_ok && sig_enforce)
		err = -EKEYREJECTED;
	return err;
}
