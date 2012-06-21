Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab2FUSlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 14:41:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4310 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab2FUSla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 14:41:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 21 Jun 2012 11:41:01 -0700
Message-ID: <4FE36AC1.70407@nvidia.com>
Date: Thu, 21 Jun 2012 11:41:05 -0700
From: "Pierre-Loup A. Griffais" <pgriffais@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Mike Sartain <mikesart@valvesoftware.com>
Subject: Re: [PATCH] perf symbols: Follow .gnu_debuglink section to find separate
 symbols
References: <4FE24D31.3070608@nvidia.com> <20120621172859.GA17747@infradead.org>
In-Reply-To: <20120621172859.GA17747@infradead.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for taking a look, Arnaldo; inline:

On 06/21/2012 10:28 AM, Arnaldo Carvalho de Melo wrote:

> Em Wed, Jun 20, 2012 at 03:22:41PM -0700, Pierre-Loup A. Griffais escreveu:
>> The .gnu_debuglink section is specified to contain the filename of the
>> debug info file, as well as a CRC that can be used to validate it.
> 
>> This provides more context:
>> http://sourceware.org/gdb/onlinedocs/gdb/Separate-Debug-Files.html
>>
>> +++ b/tools/perf/util/symbol.c
>> +static int filename__read_debuglink(const char *filename,
>> +				    char *path, size_t size)
>> +{
> 
> Isn't there any other function that opens an ELF file, looks for an
> specific session to then read its contents?
> 
> Couldn't it be reused here?


There are plenty, but they're all different enough that trying to fold
them into common code seemed involved and risky. The closest looks like
elf_read_build_id(), but in order to leverage that one the common
function would need to take a list of sections to try in sequence.
Unless you have strong feelings against using filename__read_debuglink()
as-is I would recommend that any such work happen outside of that patch
in the interest of minimizing risk.

> 
>> +		case SYMTAB__DEBUGLINK: {
>> +			char *last_slash;
>> +			strncpy(name, dso->long_name, size);
>> +			last_slash = name + dso->long_name_len;
>> +			while (last_slash && *last_slash != '/')
>> +				last_slash--;
> 
> Why the test for last_slash to be != NULL? How could it ever be? This is
> an optimization since we have the dso->long_name_len so that we avoid
> using strrchr that in turn would do an strlen?
> 
> So the test should be:
> 
> 			while (last_slash != name && *last_slash != '/')
> 
> To avoid underflowing, right?


Oops, yeah; not what I had in mind. Thanks for catching that.


>> +			if (last_slash)
>> +				last_slash++;
>> +			filename__read_debuglink(dso->long_name, last_slash,
> 
> How last_slash can point to the path? It looks like it points to the
> basename, no?
> 
> Yeah, it is, and then your algorithm will work because last_slash
> doesn't point to the _path_, but to a string _preceded_ by the path, so
> for /bin/ls, the debuglink content would be ls.debug and that is what
> will be stashed there, ending up with:
> 
> name = "/bin/\0"
> last_slash---^
> name = "/bin/ls.debug\0"
> 
> I.e. its not really the last slash, but where the debuglink content has
> to be stashed, concatenating with the same dirname as the associated
> binary.


Yes, that's correct; sorry for the ill-named variables.

> 
> Can you please rename "last_slash" to "debuglink"? And "path" to
> "debuglink" as well in the routine that reads the debuglink.


Done. I'm proposing to resend with:

			while (debuglink != name && *debuglink != '/')
				debuglink--;
			if (*debuglink == '/')
				debuglink++;

The underflow and subsequent "*debuglink == '/'" checks are only there
to do the right thing in case dso->long_name happens to just be a local
filename without any slashes in it. I realize that's probably never
supposed to happen, so I could remove them if you want. I'd rather err
on the side of caution, though.

> 
>> +						 size - (last_slash - name));
>> +			}
> 
> Other than that, thanks a lot for working on this, surely we have to
> support this feature!


Thanks a lot for walking through the logic. Looking forward to your
comments before I resend!
 - Pierre-Loup

> 
> - ARnaldo


