Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab1FBMnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:43:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41094 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758645Ab1FBMnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:43:15 -0400
Date: Thu, 2 Jun 2011 13:43:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] sysctl: add support for poll()
Message-ID: <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
	<BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com>
	<m18vtkq57c.fsf@fess.ebiederm.org>
	<BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Host names are dynamic, can change during system runtime by dhcp or
> similar setups, or just get changed by the user.

I don't actually see what this has to do with utsname. uname historically
defined nodename as "name within an implementation-defined communications
network" and actually tended to be the UUCP name. Modern SuS says "`the
name of the node of the communications network to which this node is
attached, if any"

The latter unfortunately makes no sense anyway and is a fine example of
standards body cluelessness as name mapping on IP networks is not one
name per host, and also because the standard doesn't require the fields
in the struct are long enough to hold a DNS name!

(Indeed in its usual head up backside manner its technically valid to
define

	char nodename[1];

and have only \0 as a valid reply)

Realistically all the naming policy has to be in userspace, and that
means that all the userspace bits have to agree on what they use utsname
for (or indeed if they are wise not use nodename in the first place) so
they can handle name management outside of kernel.

In the DHCP case for example a node which is acquiring a DHCP address on
wireless and on ethernet at the same time (very typical) has to make sure
all its DHCP and other address management policies agree rather than have
the two have a kernel food fight over the name to use.

So this all belongs in conman, network manager and other similar
systems and I'd suggest they try and deal with the meaningful IP world
questions of "what list of names do I posess for purpose X on network Y"
and "is this one of my names on ..."

> The alternative is to have a process constantly polling and reading
> the file, which is nothing we even want to think about in 2011.

Or to manage it properly.

> It's just another special case to bring us out of the UNIX stone age
> of doing things. :)

Unfortunately not. It's a misguided attempt to follow stone age Unix 'one
short name' policy. Forget utsname node names, they are a historical
quirk of UUCP and friends and on many OS platforms will be limited to 15
chars !

As to poll in general I can see some of the other proc files being
more relevant, eg for process monitoring tools being able to poll
in /proc/<pid> and some of the proc/sys and sysctl data that does change
meaningfully. Utsname however is not one of those things.


Alan
