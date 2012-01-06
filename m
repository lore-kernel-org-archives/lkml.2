Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2AFMhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:37:51 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:46030 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2AFMhu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:2>);
	Fri, 6 Jan 2012 07:37:50 -0500
Message-Id: <4F06F964020000780006ACFA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jan 2012 12:38:44 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Michal Marek" <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] consolidate WARN_...ONCE() static variables
References: <4EF3609D0200007800069A30@nat28.tlf.novell.com>
 <20120104150305.8b2ab00c.akpm@linux-foundation.org>
 <4F059304020000780006A906@nat28.tlf.novell.com>
 <20120105130324.44949af9.akpm@linux-foundation.org>
 <4F06B37D020000780006AC1F@nat28.tlf.novell.com>
 <20120106030329.d934f5bc.akpm@linux-foundation.org>
In-Reply-To: <20120106030329.d934f5bc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.12 at 12:03, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 06 Jan 2012 07:40:29 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> >>> On 05.01.12 at 22:03, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Thu, 05 Jan 2012 11:09:40 +0000
>> > "Jan Beulich" <JBeulich@suse.com> wrote:
>> > 
>> >> >>> On 05.01.12 at 00:03, Andrew Morton <akpm@linux-foundation.org> wrote:
>> >> > On Thu, 22 Dec 2011 15:53:49 +0000
>> >> > "Jan Beulich" <JBeulich@suse.com> wrote:
>> >> > 
>> >> >> Due to the alignment of following variables, these typically consume
>> >> >> more than just the single byte that 'bool' requires, and as there are
>> >> >> a few hundred instances, the cache pollution (not so much the waste of
>> >> >> memory) sums op. Put these variables into their own section, outside
>> >> >> of half way frequently used memory range.
>> >> >> 
>> >>
>> >> ...
>> >>
>> >> > printk_once() should also be converted.  And ata_print_version_once(),
>> >> > if it insists on continuing to exist.
>> >> 
>> >> I disagree for those (and intentionally didn't touch printk_once();
>> >> wasn't aware of the other) - at best this could get marked
>> >> __read_mostly, but that's not the subject of this patch.
>> > 
>> > Confused.  It is exactly the subject of the patch?
>> 
>> No - the goal here is to eliminate the wasteful alignment holes
>> created by the __warned variables in the WARN_...ONCE()
>> instances.
> 
> What are these alignment holes?  I'd assumed (without thinking a lot)
> that they were little three or two byte gaps because sizeof(bool)=1 or
> 2.

The holes are typically sizeof(long) - 1 bytes (i.e. 7 on 64-bit), with
some cases of smaller/larger ones.

> But I see that sizeof(bool) is actually 4, so I don't know what
> you're talking about.

They're 1-byte variables, and System.map confirms this (with the
patch in place):

ffffffff81638808 d __warned.24033
ffffffff81638809 d __warned.25205
ffffffff8163880a d __warned.30138
ffffffff8163880b d __warned.27363
...

> Apparently there is some gcc behaviour which you know about and I
> don't.

No magic gcc behavior is involved here afaict - this example

typedef _Bool bool;

bool b;

bool test(void) {
	return b;
}

unsigned size(void) {
	return sizeof(bool);
}

unsigned align(void) {
	return __alignof__(bool);
}

confirms that with whatever gcc I try, sizeof and __alignof__
produce 1 on x86.

Jan

