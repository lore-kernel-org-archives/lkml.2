Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2GFHt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:49:56 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38307 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2GFHtz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Fri, 6 Jul 2012 03:49:55 -0400
Message-Id: <4FF6AF17020000780008DFA9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 08:25:43 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Nick Bowler" <nbowler@elliptictech.com>,
        "Arnaud Lacombe" <lacombar@gmail.com>,
        "Sam Ravnborg" <sam@ravnborg.org>, "Michal Marek" <mmarek@suse.cz>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: "Inconsistent kallsyms data" error
References: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com>
In-Reply-To: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.07.12 at 23:18, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Anyway, after hacking the source to actually show the difference, and
> to also *not* change the version string just becuse it's dirty, I see
> this difference:
> 
>  - System.map:
> 
>     ...
>     ffffffff8189b4d0 R kallsyms_addresses
>     ffffffff818ee910 R kallsyms_num_syms
>     ffffffff818ee918 R kallsyms_names
>     ...
>     ffffffff819fa9a0 R __stop___modver
>     ffffffff819fb000 R __end_rodata
>     ...
> 
>  - .tmp_System.map:
> 
>     ...
>     ffffffff8189b4d0 R kallsyms_addresses
>     ffffffff818ee850 R kallsyms_num_syms
>     ffffffff818ee858 R kallsyms_names
>     ...
>     ffffffff819fa720 R __stop___modver
>     ffffffff819fb000 R __end_rodata
> 
> (the diff itself is huge, because once the addresses change, they stay
> different).
> 
> Notice how 'kallsyms_addresses' has the same value, but
> 'kallsyms_num_syms' (and subsequent symbols until the page-aligned
> __end_rodata symbol that gets them back in sync) do not. I have no
> idea *why* this happens, but it definitely does.
> 
> It seems the real difference is the size of the "kallsyms_addresses"
> data structure. No idea why, though.

Since it's clearly not an alignment problem, it almost certainly
means there were symbols added in the second pass, when
none were expected to be added.

> This happens with current git (commit c4aed353b1b0), on an x86-64
> machine running current F17 as of today, with the attached config.
> Maybe that makes somebody else able to recreate this and figure out
> what is so magical about the layout that the exact kernel version and
> config (and likely compiler/binutils versions) matter.
> 
> Any ideas? Added a fairly random set of people who get mentioned in
> the linker script commits etc.

I would have asked you to tar up all files in the build tree root
(if you still have them, ideally including the ones you saved from
deletion; quite possibly other object files in the tree might
subsequently need looking at too, so just taking the full tree
would probably be best), but since I'll be on vacation for two
weeks starting this evening that would probably not be of much
immediate help.

In the unlikely event that the problem remains unsolved till then,
I would still offer to take a look, not the least because the mere
presence of the KALLSYMS_EXTRA_PASS workaround always
puzzled me. (With reproduction unfortunately being so fragile, 
I'm having not much hope to be able to recreate the issue
myself.)

Jan

