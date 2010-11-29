Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0K2PO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:14:58 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40614 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0K2PO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:14:57 -0500
Date: Mon, 29 Nov 2010 13:14:43 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
Subject: Re: [tip:perf/core] perf record: Add option to disable collecting
	build-ids
Message-ID: <20101129151443.GA11102@ghostprotocols.net>
References: <tip-baa2f6cedbfae962f04281a31f08ec29667d31a0@git.kernel.org> <AANLkTik5oXxxSKcLq2j_9OAVqSzPxqtqqkSrQhqeB2it@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik5oXxxSKcLq2j_9OAVqSzPxqtqqkSrQhqeB2it@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 29, 2010 at 11:22:50AM +0100, Stephane Eranian escreveu:
> Arnaldo,
 
> Indeed, collecting buildids at the end of a perf record session is a
> very time AND memory consuming phase. I have seen system oom because
> of this when running inside cgroup with low memory.
 
> This is easy to reproduce running: perf record -a -- ./Run shell.
> With this, you see perf record reaching a RSS first plateau during the
> active collection of the samples, i.e., dumping the kernel buffer on
> disk. But then, when it calls process_buildids(), it shoots way up in
> memory consumption. For instance, I have seen a perf record running at
> 10MB RSS shooting all the way to 250MB RSS during that phase. At
> first, I thought there was a memory leak somewhere. But after
> instrumenting for a while, nothing really showed up.
 
> I think the problem for RSS is not so much reloading the entire
> buffer, but rather that you are recreating the entire addresses spaces
> of all processes captured. The reason: you only want to save the
> buildids of the DSO for which you had at least one sample. Thus, you
> have to allocate/de-allocate tons of threads and map structures.  I
> wonder if simply looking for MMAP samples and storing the buildids
> (even if they have no samples) wouldn't be more efficient in some
> cases. I believe it would be faster and less memory greedy.

Indeed, probably it is better to do that and only when doing a 'perf
archive' to try to compact the resulting perf.data.tar.bz2 file by
picking just the ones with hits.

I'll look into that, possibly today.

- Arnaldo
