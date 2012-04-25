Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab2DYOZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:25:42 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:19095 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753059Ab2DYOZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:25:39 -0400
Date: Wed, 25 Apr 2012 10:24:52 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/4] kbuild: link of vmlinux moved to a script
Message-ID: <20120425142452.GA13682@elliptictech.com>
References: <20120424194148.GA2216@merkur.ravnborg.org>
 <20120424194431.GC2311@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424194431.GC2311@merkur.ravnborg.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Without actually running it, a few comments on the shell script itself.

On 2012-04-24 21:44 +0200, Sam Ravnborg wrote:
> +++ b/scripts/link-vmlinux.sh
[...]
> +# We need access to CONFIG_ symbols
> +source ./.config

source is non-standard and not widely supported.  In particular, this
will not work on systems using dash for /bin/sh.  In this instance,
simply replacing source with the portable dot builtin will be exactly
equivalent, as in:

   . ./.config

> +# Error out on error
> +set -e

While a valiant effort, using set -e to handle errors is just asking
for surprises down the road.  Ignoring the fact that "set -e" has been
historically underspecified (and there is thus some variety in how
different shells handle it), consider the following:

  set -e
  foo() {
    false
    echo oops
  }
  foo || echo foo failed

Because the _call_ to foo appears on the left side of ||, the commands
_within_ foo are not subject to the effects of set -e.  In bash, the
above script therefore prints "oops", and does not normally print "foo
failed".

> +# Delete output files in case of error
> +trap cleanup SIGHUP SIGINT SIGQUIT SIGTERM ERR

This is another ksh-ism, which will again fail on systems with /bin/sh
being dash.  More portable:

  trap cleanup HUP INT QUIT TERM
  trap '(exit $?) || cleanup' EXIT

However, the Autoconf shell portability manual documents some confusion
regarding what $? should be in an exit trap when it is entered by using
the exit command:

  "Bash considers exit to be the last command, while Zsh and Solaris
  /bin/sh consider that when the trap is run it is still in the exit,
  hence it is the previous exit status that the trap receives".

The manual subsequently recommends that "exit 42" therefore be written
as "(exit 42); exit 42".  Fortunately, in this script, the only call to
exit immediately follows an explicit call to cleanup, so it won't
actually matter whether or not the exit trap calls cleanup again.

Nevertheless, I cannot reproduce the described trap behaviour with
current versions of Zsh, so maybe all this information is out of date.
That being said ...

> +cleanup()
> +{
> +	rm -f vmlinux.o
> +	rm -f .old_version
> +	rm -f .tmp_vmlinux*
> +	rm -f .tmp_kallsyms*
> +	rm -f vmlinux
> +	rm -f .tmp_System.map
> +	rm -f System.map
> +}

... this whole ad-hoc cleanup mechanism looks prone to failure.
Basically, if something goes really wrong and files get left behind, a
subsequent "make" is going to see up-to-date files and proceed with
garbage.  A more robust approach is, for filenames used in the Makefile,
to output to "dummy" files (e.g., write to vmlinux.tmp).  Only after
everything was successful (either at the very end of the script or in
the makefile rule which calls it), rename the dummy files to their
actual filename.

That way, the cleanup becomes "best effort" and, from a build
correctness point of view, won't matter if it misses removing
files for whatever reason.

[...]
> +# step a (see comment above)
> +if [ -n "${CONFIG_KALLSYMS}" ]; then
> +	mksysmap ${kallsyms_vmlinux} .tmp_System.map
> +
> +	if [ $(cmp -s System.map .tmp_System.map) ]; then

This test is wrong: it is passing the output of cmp to the [ builtin.
Aside from not being properly quoted (so the output of cmp is subject to
word splitting, which will make [ unhappy if it actually happens),
you've asked cmp to produce no output by giving it the -s option so
this test will always be false.

Presumably this should be:

        if ! cmp -s System.map .tmp_System.map; then

which actually tests the exit status of cmp instead of its output, and
executes the branch if cmp failed.  (Aside: some older shells don't
support the "if ! cmd; then stuff; fi" pattern, so you sometimes see it
written as: "if cmd; then :; else stuff; fi".  We probably don't care
too much about such shells here).

> +		echo Inconsistent kallsyms data
> +		echo echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
> +		cleanup
> +		exit 1
> +	fi
> +fi

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

