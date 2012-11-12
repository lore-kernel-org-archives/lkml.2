Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2KLUXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:23:54 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65087 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab2KLUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:23:52 -0500
MIME-Version: 1.0
In-Reply-To: <1378.1352379110@warthog.procyon.org.uk>
References: <1378.1352379110@warthog.procyon.org.uk>
Date: Mon, 12 Nov 2012 15:23:51 -0500
Message-ID: <CA+5PVA5vMyNmQYCLX315Jc+kN9zQuZo_h0Devpjfr43TezE-qA@mail.gmail.com>
Subject: Re: [GIT PULL] UAPI: perf fixes
From: Josh Boyer <jwboyer@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: acme@ghostprotocols.net, mingo@kernel.org, tglx@linutronix.de,
        bp@alien8.de, namhyung@gmail.com, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 7:51 AM, David Howells <dhowells@redhat.com> wrote:
>
>  (6) Make perf work for x86 by adding -I flags and changing long #includes
>      with "../../include" in them into short <asm/foo.h> type things.

This patch seems to break building perf on ppc64.  It fails with:

+ make -j16 -C tools/perf -s V=1 WERROR=0 HAVE_CPLUS_DEMANGLE=1 prefix=/usr all

<snip>

builtin-kvm.c:25:21: fatal error: asm/svm.h: No such file or directory
compilation terminated.
make: *** [builtin-kvm.o] Error 1
make: *** Waiting for unfinished jobs....

And that is indeed because arch/powerpc/include/asm/svm.h doesn't exist
(and therefore can't be exported like the first patch for x86 in this
series does).  You can find full build logs with this patch series
applied here: http://ppc.koji.fedoraproject.org/koji/taskinfo?taskID=781782

However, without some form of fix for the ../.. includes, perf still
fails to build on arches like ARM and powerpc with errors like this:

In file included from util/../perf.h:29:0,
                 from util/cache.h:7,
                 from util/quote.c:1:
util/../../../arch/powerpc/include/asm/unistd.h:12:29: fatal error:
uapi/asm/unistd.h: No such file or directory
compilation terminated.
make: *** [util/parse-events-test.o] Error 1

Full build logs here:
http://ppc.koji.fedoraproject.org/koji/taskinfo?taskID=781076

So.  Something else might need to be done to fix perf builds for non-x86
arches.

josh
