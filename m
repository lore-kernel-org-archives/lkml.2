Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827Ab2EWSKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:10:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60581 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760669Ab2EWSKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:10:45 -0400
Message-ID: <1337796643.6910.6.camel@joe2Laptop>
Subject: Re: [RFC PATCH] dynamic_debug: Remove __used attribute from metadata
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Date: Wed, 23 May 2012 11:10:43 -0700
In-Reply-To: <CAJfuBxw4F-nsEwn6Nh2swo+j4xJprTb_e5o4tOjuJSqqEeCUhA@mail.gmail.com>
References: <1337284958.17726.51.camel@joe2Laptop>
	 <CAJfuBxw4F-nsEwn6Nh2swo+j4xJprTb_e5o4tOjuJSqqEeCUhA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 12:00 -0600, Jim Cromie wrote:
> On Thu, May 17, 2012 at 2:02 PM, Joe Perches <joe@perches.com> wrote:
> > The __used attribute in the declaration of the
> > dynamic_debug metadata stops the compiler from
> > optimizing and eliminating constant tests and
> > the metadata declaration used in things like:
> >
> >   #define DEBUG_LEVEL 0
> >   if (DEBUG_LEVEL > 1)
> >        pr_debug("foo...");
> >
> > This is a common construct for debugging macros
> > with a constant "level" test.
> >
> > When dynamic_debug is not configured, this is
> > pr_debug and format string is eliminated unless
> > DEBUG_LEVEL is greater than 1.
> >
> > Remove the unnecessary __used attribute so the
> > even the dynamic_debug use of pr_debug can be
> > appropriately optimized away completely.
> >
> 
> 
> Im a bit puzzled - the __used attr is in the
> #if defined(CONFIG_DYNAMIC_DEBUG) branch.

Correct, the optimization is for CONFIG_DYNAMIC_DEBUG
enabled.

> If its not config'd, the METADATA is not compiled,
> and this should have no effect.
> Did you mean enabled instead of configured ?

Nope.

	if (0)
		dynamic_pr_debug("foo %u\n", bar);

will not be optimized away completely because
dynamic_pr_debug uses
	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);
and that DEFINE includes __used

so even though the compiler knows that the branch
can not be taken, it still declares the known
unnecessary metadata.

