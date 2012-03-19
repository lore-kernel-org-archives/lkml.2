Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab2CSX25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:28:57 -0400
Received: from ozlabs.org ([203.10.76.45]:43820 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab2CSX2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:28:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, pawel.moll@arm.com
Subject: Re: [00/11] pr_debug during module initialization
In-Reply-To: <CAJfuBxxPY_25P70qzmEw0JgoxyCpKDuzB1vKsJR6R-GxS+NGCA@mail.gmail.com>
References: <1331766126-11674-1-git-send-email-jim.cromie@gmail.com> <87aa3dxs6m.fsf@rustcorp.com.au> <CAJfuBxxPY_25P70qzmEw0JgoxyCpKDuzB1vKsJR6R-GxS+NGCA@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 20 Mar 2012 09:57:00 +1030
Message-ID: <87d388qiij.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 00:17:29 -0600, Jim Cromie <jim.cromie@gmail.com> wrote:
> On Sun, Mar 18, 2012 at 8:04 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > The module parts seem fine.  The re-parsing of the commandline seems
> > weird:  I'd really rather see something in unknown_bootoption(), like:
> >
> >        /* Unused module parameter. */
> >        if (strchr(param, '.') && (!val || strchr(param, '.') < val)) {
> > +               /* Check for <module>.dyndebug fake param */
> > +               dyndebug_parse(param, val);
> >                return 0;
> >        }
> 
> That is too early - the dyndbg rules cant be activated
> until dynamic_debug_init() runs, which is currently an
> arch_initcall(dynamic_debug_init);
> 
> Patch 11 makes it core-initcall, (which Im not sure is ok
> for all cases, but works for me), I also tried it with
> early_initcall (and that worked too)
> but I think thats still after the Booting kernel parse.

Indeed.  OK, that's fine then.

> I *could* capture the dyndbg options during Booting kernel
> parse, and activate them once the tables are loaded,
> but this seems convoluted.

Agreed.

> a "private" parse-args. After your earlier suggestion to use a
> callback, it occurred to me that just reusing parse_args would
> work, be fairly minimal (only 2 lines in dynamic_debug_init())
> and its already called a bunch of times; Booting kernel,
> module-load, and do-initcall-level (in Pawel's patch).
> Pawels patch doesnt do anything to avoid reparsing
> boot-time params.
> 
> Does this change your weirdness assessment ?

It's still weird to re-parse, but with a comment explaining that we
need to do it again after dynamic_debug_init().  Unless we can call
that explicitly before parse_args().
> Lastly, my earlier rev handled  foo.dyndbg params
> for loadable modules.  I took that out cuz
> Documentation/kernel-parameters.txt says thats
> for builtins (only, as I read it), and treating foo.dyndbg
> differently should be done w/o discussion.

Yes, when a module 'foo' declares it has a parameter 'bar', it becomes
'foo.bar' if the module is built-in, and just 'bar' if the module is
loaded.

Furthermore, modprobe reads /proc/cmdline when loading foo, looking for
"foo.*" to add to the modprobe arguments.

> > Otherwise, all looks good!
> >
> > Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> thanks.  I guess the Ack (vs SOB) means that Jason should
> forward it on to Greg as a single set ?
> (subject to his Ack of course)

I assumed it would go via Jason.  Otherwise, get his ack and resend to
me.

Thanks,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
