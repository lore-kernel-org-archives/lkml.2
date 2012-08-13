Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2HMMDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:03:10 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:50855 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2HMMDH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:16:1>);
	Mon, 13 Aug 2012 08:03:07 -0400
Message-Id: <502909110200007800094719@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 13 Aug 2012 13:02:57 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "Robert Richter" <robert.richter@amd.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        "Hugh Dickins" <hughd@google.com>, "Alex Shi" <alex.shu@intel.com>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, <x86@kernel.org>,
        <linux-mm@kvack.org>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        <linux-mips@linux-mips.org>, "Andi Kleen" <ak@linux.intel.com>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Ingo Molnar" <mingo@redhat.com>, "Mel Gorman" <mgorman@suse.de>,
        <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 4/6] x86: Add clear_page_nocache
References: <1344524583-1096-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1344524583-1096-5-git-send-email-kirill.shutemov@linux.intel.com>
 <5023F1BC0200007800093EF0@nat28.tlf.novell.com>
 <20120813114334.GA21855@otc-wbsnb-06>
In-Reply-To: <20120813114334.GA21855@otc-wbsnb-06>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.08.12 at 13:43, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> On Thu, Aug 09, 2012 at 04:22:04PM +0100, Jan Beulich wrote:
>> >>> On 09.08.12 at 17:03, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>  wrote:
> 
> ...
> 
>> > ---
>> >  arch/x86/include/asm/page.h          |    2 ++
>> >  arch/x86/include/asm/string_32.h     |    5 +++++
>> >  arch/x86/include/asm/string_64.h     |    5 +++++
>> >  arch/x86/lib/Makefile                |    1 +
>> >  arch/x86/lib/clear_page_nocache_32.S |   30 ++++++++++++++++++++++++++++++
>> >  arch/x86/lib/clear_page_nocache_64.S |   29 +++++++++++++++++++++++++++++
>> 
>> Couldn't this more reasonably go into clear_page_{32,64}.S?
> 
> We don't have clear_page_32.S.

Sure, but you're introducing a file anyway. Fold the new code into
the existing file for 64-bit, and create a new, similarly named one
for 32-bit.

>> >+	xorl   %eax,%eax
>> >+	movl   $4096/64,%ecx
>> >+	.p2align 4
>> >+.Lloop:
>> >+	decl	%ecx
>> >+#define PUT(x) movnti %eax,x*8(%edi) ; movnti %eax,x*8+4(%edi)
>> 
>> Is doing twice as much unrolling as on 64-bit really worth it?
> 
> Moving 64 bytes per cycle is faster on Sandy Bridge, but slower on
> Westmere. Any preference? ;)

If it's not a clear win, I'd favor the 8-stores-per-cycle variant,
matching x86-64.

Jan

