Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab2FVMjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:39:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43170 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846Ab2FVMjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:39:41 -0400
Date: Fri, 22 Jun 2012 09:39:35 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "Pierre-Loup A. Griffais" <pgriffais@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Mike Sartain <mikesart@valvesoftware.com>
Subject: Re: [PATCH] perf symbols: Follow .gnu_debuglink section to find
 separate symbols
Message-ID: <20120622123935.GF17747@infradead.org>
References: <4FE24D31.3070608@nvidia.com>
 <20120621172859.GA17747@infradead.org>
 <4FE36AC1.70407@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE36AC1.70407@nvidia.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 21, 2012 at 11:41:05AM -0700, Pierre-Loup A. Griffais escreveu:
> On 06/21/2012 10:28 AM, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jun 20, 2012 at 03:22:41PM -0700, Pierre-Loup A. Griffais escreveu:
> >> The .gnu_debuglink section is specified to contain the filename of the

> >> http://sourceware.org/gdb/onlinedocs/gdb/Separate-Debug-Files.html

> >> +static int filename__read_debuglink(const char *filename,

> > Isn't there any other function that opens an ELF file, looks for an
> > specific session to then read its contents?

> > Couldn't it be reused here?
 
> There are plenty, but they're all different enough that trying to fold
> them into common code seemed involved and risky. The closest looks like
> elf_read_build_id(), but in order to leverage that one the common
> function would need to take a list of sections to try in sequence.

But we can have helper routines to do what is done to open the elf file,
etc, right?

> Unless you have strong feelings against using filename__read_debuglink()
> as-is I would recommend that any such work happen outside of that patch
> in the interest of minimizing risk.

Agreed, that could be done later.

> >> +		case SYMTAB__DEBUGLINK: {
> >> +			char *last_slash;
> >> +			strncpy(name, dso->long_name, size);
> >> +			last_slash = name + dso->long_name_len;
> >> +			while (last_slash && *last_slash != '/')
> >> +				last_slash--;

> > Why the test for last_slash to be != NULL? How could it ever be? This is
> > an optimization since we have the dso->long_name_len so that we avoid
> > using strrchr that in turn would do an strlen?

> > So the test should be:
> > 			while (last_slash != name && *last_slash != '/')

> > To avoid underflowing, right?
> 
> Oops, yeah; not what I had in mind. Thanks for catching that.
> 
> >> +			if (last_slash)
> >> +				last_slash++;
> >> +			filename__read_debuglink(dso->long_name, last_slash,

> > How last_slash can point to the path? It looks like it points to the
> > basename, no?
> > 
> > Yeah, it is, and then your algorithm will work because last_slash
> > doesn't point to the _path_, but to a string _preceded_ by the path, so
> > for /bin/ls, the debuglink content would be ls.debug and that is what
> > will be stashed there, ending up with:
> > 
> > name = "/bin/\0"
> > last_slash---^
> > name = "/bin/ls.debug\0"
> > 
> > I.e. its not really the last slash, but where the debuglink content has
> > to be stashed, concatenating with the same dirname as the associated
> > binary.
> 
> Yes, that's correct; sorry for the ill-named variables.
> 
> > Can you please rename "last_slash" to "debuglink"? And "path" to
> > "debuglink" as well in the routine that reads the debuglink.
> 
> Done. I'm proposing to resend with:
> 
> 			while (debuglink != name && *debuglink != '/')
> 				debuglink--;
> 			if (*debuglink == '/')
> 				debuglink++;
> 
> The underflow and subsequent "*debuglink == '/'" checks are only there
> to do the right thing in case dso->long_name happens to just be a local
> filename without any slashes in it. I realize that's probably never
> supposed to happen, so I could remove them if you want. I'd rather err
> on the side of caution, though.

That is the right mindset, code has to be robust.
 
> >> +						 size - (last_slash - name));
> >> +			}
> > 
> > Other than that, thanks a lot for working on this, surely we have to
> > support this feature!
> 
> Thanks a lot for walking through the logic. Looking forward to your
> comments before I resend!

Please resend! :-)

- Arnaldo
