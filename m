Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab0EZTdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:33:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32921 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0EZTdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:33:13 -0400
Date: Wed, 26 May 2010 16:32:55 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [GIT PULL 0/2] perf annotate fix and report improvoment
Message-ID: <20100526193255.GC9874@ghostprotocols.net>
References: <1274664671-27385-1-git-send-email-acme@infradead.org>
 <AANLkTil5WtBnMQt1odjEgmWHOuuKxb4AIyuBLAqOiUSg@mail.gmail.com>
 <20100526005531.GA9874@ghostprotocols.net>
 <AANLkTim-xv9mNEwGCueV47AoKh6AXbrdbTdCEwZHaEHJ@mail.gmail.com>
 <20100526182351.GB9874@ghostprotocols.net>
 <AANLkTimOEUKYXzdMOiWE6gRxR7vJX36VscdLjRroqGLq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimOEUKYXzdMOiWE6gRxR7vJX36VscdLjRroqGLq@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 26, 2010 at 09:07:05PM +0200, Stephane Eranian escreveu:
> Hi,
> 
> +lkml et al.
> 
> On Wed, May 26, 2010 at 8:23 PM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> > Em Wed, May 26, 2010 at 06:45:18PM +0200, Stephane Eranian escreveu:
> >> Attached is the trace for
> >> perf annotate -i ~/perf.data noploop
> >>
> >> I get no output at all (TUI is off). Copied over .debug tarball + perf.data.
> >
> > Looks like the bug I'm investigating now:
> >
> > build id event received for [kernel.kallsyms]: 54b1e7cc3cf52e0db255aab44ce7538eb62655b8
> > build id event received for /tmp/noploop: 875ae61623e89f408b425ca0486a9ec99e3ac73e
> > Looking at the vmlinux_path (5 entries long)
> > No build_id in vmlinux, ignoring it
> > No build_id in /boot/vmlinux, ignoring it
> > No build_id in /boot/vmlinux-2.6.34-tip-default+, ignoring it
> > build_id in /lib/modules/2.6.34-tip-default+/build/vmlinux is
> > 3635a0e8dfc9a1afbd5627c2ba789e41d77d3cd1 while expected is
> > 54b1e7cc3cf52e0db255aab44ce7538eb62655b8, ignoring it
> > No build_id in /usr/lib/debug/lib/modules/2.6.34-tip-default+/vmlinux, ignoring it
> >
> > In my case it is not finding the vmlinux because I'm using RHEL6 Beta
> > kernel without the respective kernel-debuginfo{-common} packages so it
> > doesn't find the vmlinux, uses just /proc/kallsyms and that is not
> > enough for annotation.
> >
> > In your case the problem is that we only cache the kallsyms file in the
> > build-id cache ($HOME/.debug) and that is not enough for annotation, so
> > I have to fix two things:
> >
> I can understand the issue with the kernel symbols.

That has to be fixed and I've got some patches already for that, testing
them now.

> But in this example, I only really care about the symbols in the
> noploop program (/tmp/noploop).
> 
> Missing symbol support for the kernel should not cause perf to avoid
> trying to resolve the symbols in other modules such as my user program
> here.

Right, my bad, I thought that the problem was about the kernel symbols.

Then can you try replacing:

perf annotate -i ~/perf.data noploop

with:

perf annotate -i ~/perf.data -d noploop

And see if that helps?

Because, in the debug output you sent me we have:

Thread 11487 noploop
Functions:
Map: 400000-401000 0 /tmp/noploop
dso: noploop (/tmp/noploop, Functions, loaded, 875ae61623e89f408b425ca0486a9ec99e3ac73e)
 508-58f _init
 590-5bb _start
 5bc-5df call_gmon_start
 5e0-64f __do_global_dtors_aux
 650-67f frame_dummy
 680-681 noploop
 6e0-6ea handler
 6f0-6f1 __libc_csu_fini
 700-788 __libc_csu_init
 790-7c7 __do_global_ctors_aux
 7c8-1000 _fini

So yes, there is a symbol called noploop and it is in the binary
noploop, that _has_ a build-id, and that is in the cache, perf managed
to load its symtab and knows where it is mapped, when it created this
symbol it did:

symbol__new: noploop 0x680-0x681
dso__load_sym: adjusting symbol: st_value: 0x400690 sh_addr: 0x400590 sh_offset: 0x590

Now with perf annotate -D you should get a raw dump that will tell you
if it managed to find the hist_entry for this symbol.

And I checked and there are no other "noploop" symbol in any of the
other DSOs involved.

> > 1. tell about these constraints when a symbol cannot be annotated, not
> > just silently fail
> >
> Agreed, print something like <uknown symbol> or <cannot resolve symbol>
> 
> 
> > 2. cache the vmlinux file in the build-id cache instead of the vmlinux,
> > if the vmlinux file was found, if not, fallback to caching the kallsyms
> > file.
> >
> Don't you need to match buildid here too, the vmlinux linux on the host
> may not match the one on the target, i.e., monitored system.

Right, it is checked if the build-id is in the perf.data file.
 
> > Both can't be cached at the same time as they will have the same
> > build-id and thus at least the symlink would be to one of them.
> >
> > I'll make this even configurable in ~/.perfconfig, on a new [symbol]
> > section, something like:
> >
> > [symbol]
> >
> >        cache_vmlinux = on/off
> >
> > So that people that have issues with the size of these beasts can trade
> > off disk space used by the cache versus being able to do annotation.
> >
> Yes, disk space is an issue.

- Arnaldo
