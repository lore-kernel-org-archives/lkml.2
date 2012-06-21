Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984Ab2FUR3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:29:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38462 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab2FUR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:29:06 -0400
Date: Thu, 21 Jun 2012 14:28:59 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "Pierre-Loup A. Griffais" <pgriffais@nvidia.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, torvalds@linux-foundation.org,
        Mike Sartain <mikesart@valvesoftware.com>
Subject: Re: [PATCH] perf symbols: Follow .gnu_debuglink section to find
 separate symbols
Message-ID: <20120621172859.GA17747@infradead.org>
References: <4FE24D31.3070608@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE24D31.3070608@nvidia.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 20, 2012 at 03:22:41PM -0700, Pierre-Loup A. Griffais escreveu:
> The .gnu_debuglink section is specified to contain the filename of the
> debug info file, as well as a CRC that can be used to validate it.

> This provides more context:
> http://sourceware.org/gdb/onlinedocs/gdb/Separate-Debug-Files.html
> 
> +++ b/tools/perf/util/symbol.c
> +static int filename__read_debuglink(const char *filename,
> +				    char *path, size_t size)
> +{

Isn't there any other function that opens an ELF file, looks for an
specific session to then read its contents?

Couldn't it be reused here?

> +		case SYMTAB__DEBUGLINK: {
> +			char *last_slash;
> +			strncpy(name, dso->long_name, size);
> +			last_slash = name + dso->long_name_len;
> +			while (last_slash && *last_slash != '/')
> +				last_slash--;

Why the test for last_slash to be != NULL? How could it ever be? This is
an optimization since we have the dso->long_name_len so that we avoid
using strrchr that in turn would do an strlen?

So the test should be:

			while (last_slash != name && *last_slash != '/')

To avoid underflowing, right?

> +			if (last_slash)
> +				last_slash++;
> +			filename__read_debuglink(dso->long_name, last_slash,

How last_slash can point to the path? It looks like it points to the
basename, no?

Yeah, it is, and then your algorithm will work because last_slash
doesn't point to the _path_, but to a string _preceded_ by the path, so
for /bin/ls, the debuglink content would be ls.debug and that is what
will be stashed there, ending up with:

name = "/bin/\0"
last_slash---^
name = "/bin/ls.debug\0"

I.e. its not really the last slash, but where the debuglink content has
to be stashed, concatenating with the same dirname as the associated
binary.

Can you please rename "last_slash" to "debuglink"? And "path" to
"debuglink" as well in the routine that reads the debuglink.

> +						 size - (last_slash - name));
> +			}

Other than that, thanks a lot for working on this, surely we have to
support this feature!

- ARnaldo
