Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0ESU4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:56:06 -0400
Received: from smtp-out.google.com ([74.125.121.35]:31196 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0ESU4C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:56:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YynL9biSaD/G1G2rTC/2PvpBn6So2gwsAFSd6X2O/awjeBS86W4Sfb4kcS41a95y7
	HYs/PLfg7jr9dMLTyVCCw==
MIME-Version: 1.0
In-Reply-To: <20100519201137.GA26284@ghostprotocols.net>
References: <1274288493-15523-1-git-send-email-acme@infradead.org>
	 <AANLkTindijJnIeElAkoj0CGC7nJwVEzIC_OlDbJ_adE8@mail.gmail.com>
	 <20100519201137.GA26284@ghostprotocols.net>
Date: Wed, 19 May 2010 22:55:55 +0200
Message-ID: <AANLkTin1xWNaQLZrMcJmlC4GCKMibjinRmYNtUgxYJAK@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] perf session fix host_machine handling wrt build 
	ids
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:11 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
>
> Em Wed, May 19, 2010 at 09:36:45PM +0200, Stephane Eranian escreveu:
> > Hi,
> >
> > On Wed, May 19, 2010 at 7:01 PM, Arnaldo Carvalho de Melo
> > <acme@infradead.org> wrote:
> > > Hi Ingo,
> > >
> > >        Please pull from:
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> > >
> > > Stephane and Tom,
> > >
> > >        Now the build id code should be back working:
> > >
> > > [root@doppio linux-2.6-tip]# rm -rf /root/.debug/
> > > [root@doppio linux-2.6-tip]# perf record find / > /dev/null
> > > ^C[ perf record: Woken up 3 times to write data ]
> > > [ perf record: Captured and wrote 0.667 MB perf.data (~29163 samples) ]
> > > [root@doppio linux-2.6-tip]# perf buildid-list
> > > 349199a1e1b7cc25ac4f7004deed260f0146665e [kernel.kallsyms]
> >
> >
> > It is working again for me too. Thanks for the quick fix.
>
> Great, and thanks for the "quick" part, myself I thought it took more
> time than needed :-)

Well I could not understand the logical code flow with buildids, that's why
I posted the bug report. I am glad you fixed this.

>
> > Related to .debug, I think it would be useful to have a choice as to
> > where all that stuff gets saved. It is hardcoded to $HOME today.
> >
> > We could provide:
> > - an environment variable, e.g., PERFHOME or PERFDEBUGDIR
> > - an option to perf record, perf report, perf annotate, i.e., all commands
> >   that use .debug
> >
> > I looked at that today and I have a draft patch to add both the variable
> > + the option.
> >
>
> Yeah, the NO_NEWT make target was out of our uneasyness about making
> newt the sole report output, and my patch removing tons of code stolen
> but not used (greedy us!) was also in that direction, trying to get the
> git ~/.CONFIG way into perf.

That's not because I compile with newt support that I want curses output each
time I use perf report. I could not find an option to turn it off.
Unless you tell
me that if it detects stdout is not a tty it does not use newt. But
that would not
be good enough I think.
Ok, so you are advocating that perf configuration options be saved in
~/.perfconfig
and that would include the destination dir for all the "symbolization"
files. BTW,
I think the name .debug is confusing here. It contains symbolization info not
debug info. For all I know the binaries may have no debug info at all.

>
> We have to have that and consistent accross the tools command line
> options to override where this is stored/used.
>
> > The problem with the environment variable is that you tend to forget to
> > set it. As you suggest below, you may run perf report on another machine
> > too and you don't necessarily want to overwrite the .debug you may already
>
> Well, we wouldn't be overwriting anything since we hope that what is
> used to create the buildid is reasonably safe against collision, so even
> if the DSOs are for different arches, it should be rather difficult to
> get 'perf unarchive' causing problems.


I think you're right. If you have the same file name, e.g.,
/usr/bin/date but compiled
differently, then you should have different buildids, thus you will
not clash on either
leaf files in your tree. Directories may already exist but that's
okay. Am I right?
