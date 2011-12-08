Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab1LHQLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:11:18 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35439 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220Ab1LHQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:11:16 -0500
X-Sasl-enc: jX3N4CUoSPGJqnE/5u0lozfdW8er+jsNovHnmIsuXiS0 1323360675
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: John Stoffel <john@stoffel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 08 Dec 2011 11:10:52 -0500
In-Reply-To: <20191.49202.793643.397028@quad.stoffel.home>
References: <1323280461.10724.13.camel@lenny>
	 <20191.49202.793643.397028@quad.stoffel.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323360655.10724.35.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 14:36 -0500, John Stoffel wrote:
> >>>>> "Colin" == Colin Walters <walters@verbum.org> writes:
> 
> Colin> I've recently been doing some work in software compilation, and it'd be
> Colin> really handy if I could call chroot(2) as a non-root user.  The reason
> Colin> to chroot is to help avoid "host contamination" - I can set up a build
> Colin> root and then chroot in.  The reason to do it as non-root is, well,
> Colin> requiring root to build software sucks for multiple obvious reasons.
> 
> What's wrong with using 'fakeroot' or tools like that instead? 

I assume you mean
"fakechroot" ( https://github.com/fakechroot/fakechroot/wiki )

The answer is twofold:

1) It's a pile of gross hacks that can easily be buggy, and will be
permanently trying to keep up with newer system calls.
2) It's slower.  My edit-compile-debug cycle REALLY matters to me.  If
you're a developer, it should matter to you - it directly impacts your
productivity.

How much slower?  Okay, well I tried "fakechroot" from Fedora 15.  It
appears to break parallel make.  Which obviously already disqualifies it
from being a core part of my edit-compile-debug cycle.

But here's an example of a small autotools (~6000 significant lines of
C) project, of which running configure is by far the slowest part.  Note
'metabuild' is a trivial script which wraps the
'autogen.sh;configure;make' dance:

$ metabuild   # to prime the caches
...
$ git clean -dfx
...
$ time ostbuild-user-chroot --unshare-ipc --unshare-pid --unshare-net
--mount-bind /src /src --mount-proc /proc
--mount-bind /dev /dev / /bin/sh -c 'cd /src/test-project; metabuild'
...
real	0m17.627s
user	0m9.397s
sys	0m5.074s
$ git clean -dfx
...
$ time fakeroot fakechroot chroot / /bin/sh -c 'cd /src/test-project;
metabuild -j 1'
real	0m35.327s
user	0m13.118s
sys	0m10.639s

So it almost exactly doubles...Oh, crap, I just remembered I have
ccache, so we're really only timing configure runs here.  Anyways, you
get the point.  Doubling my compile time is bad.  And this is a
relatively small project.

One of the best parts of Linux is the filesystem and VFS - it's really
amazingly fast compared to other OSes, especially if you know how to use
it.  Adding in layers of emulation and crap in between the program and
the filesystem takes that away.


