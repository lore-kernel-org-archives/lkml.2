Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310Ab2AFKWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:22:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:51267 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030275Ab2AFKVz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:2>);
	Fri, 6 Jan 2012 05:21:55 -0500
Message-Id: <4F06B37D020000780006AC1F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jan 2012 07:40:29 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Michal Marek" <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] consolidate WARN_...ONCE() static variables
References: <4EF3609D0200007800069A30@nat28.tlf.novell.com>
 <20120104150305.8b2ab00c.akpm@linux-foundation.org>
 <4F059304020000780006A906@nat28.tlf.novell.com>
 <20120105130324.44949af9.akpm@linux-foundation.org>
In-Reply-To: <20120105130324.44949af9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.01.12 at 22:03, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 05 Jan 2012 11:09:40 +0000
> "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> >>> On 05.01.12 at 00:03, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Thu, 22 Dec 2011 15:53:49 +0000
>> > "Jan Beulich" <JBeulich@suse.com> wrote:
>> > 
>> >> Due to the alignment of following variables, these typically consume
>> >> more than just the single byte that 'bool' requires, and as there are
>> >> a few hundred instances, the cache pollution (not so much the waste of
>> >> memory) sums op. Put these variables into their own section, outside
>> >> of half way frequently used memory range.
>> >> 
>>
>> ...
>>
>> > printk_once() should also be converted.  And ata_print_version_once(),
>> > if it insists on continuing to exist.
>> 
>> I disagree for those (and intentionally didn't touch printk_once();
>> wasn't aware of the other) - at best this could get marked
>> __read_mostly, but that's not the subject of this patch.
> 
> Confused.  It is exactly the subject of the patch?

No - the goal here is to eliminate the wasteful alignment holes
created by the __warned variables in the WARN_...ONCE()
instances. These get accessed past and unlikely() condition,
and hence get moved into a separate data section (so they
would all end up together, with no holes in between).

The printk_once() situation is quite different: The variables get
accessed each time the code in question gets executed, and
hence cannot be considered on an unlikely code path without
additional knowledge of the surrounding code. Consequently
they don't belong into the same data section as the ones that
get moved here.

>> > Also rcu_lockdep_assert().
>> 
>> This one I mostly agree - the access is at least sitting past the
>> debug_lockdep_rcu_enabled() check, albeit not in an unlikely()
>> code path.
> 
> What does "unlikely" have to do with any of this?

See above.

> I'm suspecting that there is some changelog crappiness going on here. 
> What didn't you tell us?

I think the original description says all that it has to. It doesn't
care to say why others don't get converted, but I don't think
that's to be expected of it either (imagine how patch descriptions
would start looking like if everything that wasn't done in patch
was also described).

Jan

