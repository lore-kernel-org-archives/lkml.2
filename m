Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0ETOYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:24:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:48202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0ETOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:24:05 -0400
Date: Thu, 20 May 2010 11:23:37 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf session fix host_machine handling wrt build
 ids
Message-ID: <20100520142337.GB26284@ghostprotocols.net>
References: <1274288493-15523-1-git-send-email-acme@infradead.org>
 <AANLkTindijJnIeElAkoj0CGC7nJwVEzIC_OlDbJ_adE8@mail.gmail.com>
 <20100519201137.GA26284@ghostprotocols.net>
 <AANLkTin1xWNaQLZrMcJmlC4GCKMibjinRmYNtUgxYJAK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin1xWNaQLZrMcJmlC4GCKMibjinRmYNtUgxYJAK@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 19, 2010 at 10:55:55PM +0200, Stephane Eranian escreveu:
> On Wed, May 19, 2010 at 10:11 PM, Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > Yeah, the NO_NEWT make target was out of our uneasyness about making
> > newt the sole report output, and my patch removing tons of code stolen
> > but not used (greedy us!) was also in that direction, trying to get the
> > git ~/.CONFIG way into perf.

> That's not because I compile with newt support that I want curses output each
> time I use perf report. I could not find an option to turn it off.

> Unless you tell me that if it detects stdout is not a tty it does not
> use newt. But that would not be good enough I think.

Agreed, I'll add something like what git has for formatting, i.e. some
perf report --tty and --tui

With --tui being the default. If someone don't want it they can either
use 'make NO_NEWT=1', use | less, redirect to a file, remove the
newt-devel/libnewt-dev or set it in ~/.perfconfig.

> Ok, so you are advocating that perf configuration options be saved in
> ~/.perfconfig and that would include the destination dir for all the
> "symbolization" files. BTW, I think the name .debug is confusing here.
> It contains symbolization info not debug info. For all I know the
> binaries may have no debug info at all.

Yeah, I even called a symtab cache when I introduced it, but the idea
was that perhaps it could be used by systemtap and other tools that use
build id indexed debugging info, even if it is just a symtab.

But because it doesn't always have just a symtab, I decided to use
something more generic.

perf annotate, for instance, can use the DWARF info there if present.

> > We have to have that and consistent accross the tools command line
> > options to override where this is stored/used.
> >
> > > The problem with the environment variable is that you tend to forget to
> > > set it. As you suggest below, you may run perf report on another machine
> > > too and you don't necessarily want to overwrite the .debug you may already
> >
> > Well, we wouldn't be overwriting anything since we hope that what is
> > used to create the buildid is reasonably safe against collision, so even
> > if the DSOs are for different arches, it should be rather difficult to
> > get 'perf unarchive' causing problems.

> I think you're right. If you have the same file name, e.g.,
> /usr/bin/date but compiled differently, then you should have different
> buildids, thus you will not clash on either leaf files in your tree.
> Directories may already exist but that's okay. Am I right?

Yes, you are. I decided to have DSO names used as a directory where we
store files named by its build ids so that, among others, the following
use case becomes straight forward:

vi app.c
make

# caches app _at this point in time_ by build-id creates perf.data
perf record ./app

# do some changes, optimizations, whatever
vi app.c
make

# caches app _with another build-id_, renames existing perf.data file to
# perf.data.old
perf record ./app

# compares perf.data and perf.data.old, finding the two binary versions
perf diff

	Right now perf.data.old is deleted if present and perf.data is
renamed to it, so we have just two files for perf diff, but we can as
well implement code in 'perf diff' to consider N files, generating
plots, etc, and the build-id cache is what allows this to be done really
seamlessly.

- Arnaldo
