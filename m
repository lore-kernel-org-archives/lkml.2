Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1FVSPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:15:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44766 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932276Ab1FVSPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:15:30 -0400
Date: Wed, 22 Jun 2011 19:10:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110622191022.66135615@lxorguk.ukuu.org.uk>
In-Reply-To: <1308760683.10423.16.camel@Joe-Laptop>
References: <20110622095341.GA3353@albatros>
	<1308760683.10423.16.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 09:38:03 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2011-06-22 at 13:53 +0400, Vasiliy Kulikov wrote:
> > This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
> > charset passed to printk().

I think this is fundamentally wrong.

It makes sense for some interfaces but not others and arbitarily doing it
makes a nasty mess of anything like file name printing in non English
languages.

The right way to do this IMHO is for the console device itself to have a
filter function, the default would be the 0x20-0x7E but for example with
any console which has an accompanying tty device the right behaviour
depends upon the port UTF8 flag (IUTF8).

If that is set you shouldn't be filtering out unicode, just control codes.

Minor other nit is that you might want to allow BEL through and you
certainly want to allow tab through.

The core code should not be hardcoding policy assumptions about symbol
sets and ASCII, for an awful lot of consoles today that assumption is
just plain wrong, for others it makes sense

So with tty maintainer hat on - NAK to the current approach but a good
idea to do it properly.
