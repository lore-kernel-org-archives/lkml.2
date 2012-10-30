Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab2J3J6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:58:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50063 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab2J3J6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:58:09 -0400
Date: Tue, 30 Oct 2012 02:57:52 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf tools: Speed up the perf build time by simplifying
 the perf --version string generation
Message-ID: <20121030095752.GG25959@ghostprotocols.net>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <20121026170503.GC20695@ghostprotocols.net>
 <20121027131935.GA30001@gmail.com>
 <20121030081807.GA8245@gmail.com>
 <20121030084600.GB8245@gmail.com>
 <20121030093513.GE25959@ghostprotocols.net>
 <20121030094338.GA21644@gmail.com>
 <20121030094852.GA21705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030094852.GA21705@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 30, 2012 at 10:48:52AM +0100, Ingo Molnar escreveu:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > Does -l work?
> > 
> > Alternatively, please replace:
> > 
> >   git tag --list "v[0-9].[0-9]*" | tail -1
> > 
> > with:
> > 
> >   git tag | tail -1 | grep -E "v[0-9].[0-9]*"
> > 
> > which is just as fast.
> 
> make that:
> 
>     git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*"
> 
> this will work silently even if Git is not installed.

But we first check if we have a .git, that doesn't guarantees that git
is installed, but makes it a lot likely, no? Redirecting stderr to null
would need to be done in more places, so we would need to use something
like what we do for xmlto/asciidoc, $(call get-executable,$(GIT))

#
# First check if there is a .git to get the version from git describe
# otherwise try to get the version from the kernel Makefile
#
if test -d ../../.git -o -f ../../.git &&
        VN=$(echo $(git tag -l "v[0-9].[0-9]*" | tail -1)"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD) 2>/dev/null)
then
        VN=$(echo "$VN" | sed -e 's/-/./g');
else
        VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
fi
