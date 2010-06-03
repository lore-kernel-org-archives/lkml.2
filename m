Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0FCRzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:55:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0FCRzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:55:08 -0400
Date: Thu, 3 Jun 2010 14:54:45 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com
Subject: Re: how to use perf annotate on the kernel
Message-ID: <20100603175445.GC8928@ghostprotocols.net>
References: <AANLkTik2yNxwCHl7FZAyOG4Vt56RlLi59oZR5Jo6o9ox@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik2yNxwCHl7FZAyOG4Vt56RlLi59oZR5Jo6o9ox@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 03, 2010 at 07:23:02PM +0200, Stephane Eranian escreveu:
> Arnaldo,
> 
> I am trying to understand how one is supposed
> to use perf annotate to get sample correlations
> with kernel symbols.
> 
> I do:
> 
> # perf record -a -e cycles:k dd if=/dev/zero of=/dev/null count=1000000
> # perf report
> 
> # Events: 14K cycles
> #
> # Overhead          Command        Shared Object  Symbol
> # ........  ...............  ...................  ......
> #
>      8.76%               dd  [kernel.kallsyms]    [k] __lock_acquire
>      7.49%               dd  [kernel.kallsyms]    [k] sched_clock
> 
> # perf annotate (or annotate -d '[kernel.kallsyms]'?)
> Can't annotate __lock_acquire: No vmlinux file was found in the path
> 
> # perf annotate -k vmlinux
> objdump: '[kernel.kallsyms]': No such file

This looks like a bug in how it reports this problem, probably vmlinux
is not in the current directory, or it is but has a build-id that
doesn't matches the one in the perf.data file.

But the message is wrong, should be like it is in the tui, for this same
situation:

	ui_helpline__puts("No vmlinux file found, can't "
			  "annotate with just a kallsyms file");

> Am I missing something here?

If you don't specify it with --vmlinux/-k it will try to find it in one
of these places:

        vmlinux_path[vmlinux_path__nr_entries] = strdup("vmlinux");
        if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
                goto out_fail;
        ++vmlinux_path__nr_entries;
        vmlinux_path[vmlinux_path__nr_entries] = strdup("/boot/vmlinux");
        if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
                goto out_fail;
        ++vmlinux_path__nr_entries;
        snprintf(bf, sizeof(bf), "/boot/vmlinux-%s", uts.release);
        vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
        if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
                goto out_fail;
        ++vmlinux_path__nr_entries;
        snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", uts.release);
        vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
        if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
                goto out_fail;
        ++vmlinux_path__nr_entries;
        snprintf(bf, sizeof(bf), "/usr/lib/debug/lib/modules/%s/vmlinux",
                 uts.release);
        vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);

It also now looks at /sys/kernel/notes, gets the build-id, and looks up
in the build-id cache.

- Arnaldo
