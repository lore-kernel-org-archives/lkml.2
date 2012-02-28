Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2B1I6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:58:24 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:57630 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2B1I6W convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Tue, 28 Feb 2012 03:58:22 -0500
Message-Id: <4F4CA56202000078000751EF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 28 Feb 2012 08:58:58 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] consolidate WARN_...ONCE() static variables
References: <4F4BAAFA0200007800074F8F@nat28.tlf.novell.com>
 <20120227160302.ef9f6af4.akpm@linux-foundation.org>
 <4F4C93520200007800075197@nat28.tlf.novell.com>
 <20120227234451.3a00a76a.akpm@linux-foundation.org>
 <4F4C983002000078000751AE@nat28.tlf.novell.com>
 <20120228001210.26b59479.akpm@linux-foundation.org>
 <4F4C9B7802000078000751BC@nat28.tlf.novell.com>
 <20120228003206.e661f926.akpm@linux-foundation.org>
In-Reply-To: <20120228003206.e661f926.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.12 at 09:32, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 28 Feb 2012 08:16:40 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> Oh, sorry - to carry static data the accesses to which are unlikely
>> (i.e., as in the case given, fully contained in code sections inside
>> conditionals which themselves use unlikely() on their primary/only
>> clause - in other words, something that the compiler really could
>> do on its own).
> 
> I think I just learned more about this patch than at any time since we
> started discussing it.
> 
> Why add a new section, rather than using __read_mostly?

Because __read_mostly data frequently is hot.

> I suppose we should add and use a #define for this, like __read_mostly.
> That would be a good site for documenting it ;)

That's a possibility of course. I'll do so in an eventual v3.

> And I come back to my old friend printk_once().  If I'm understanding
> things correctly, we can/should make that test unlikely, then mark
> __print_once as __this_new_section?  Otherwise... help!

No. The variable itself serves for the tested condition here, and
hence a priori you can't say whether the whole construct sits in
a hot path (whether putting it in a hot path is a good idea is
another question, but the print-this-one-time-only nature of it
may be the very reason why someone considers this reasonable
for his code).

As opposed to that, the access to the static variable in WARN_ONCE()
is *after* an unlikely() condition was already evaluated, i.e. would
generally sit on a code path that we hope doesn't get speculated
along (often), by means of the compiler suitably arranging branch
targets.

> btw, I don't think there's a significant performance benefit here - if
> the kernel is ever executing WARN_ON_ONCE(), WARN_ONCE() or
> printk_once() with any frequency then it is already badly broken.

The intended performance benefit isn't with the WARN_ONCE()
constructs - we certainly don't care much about them being executed
efficiently - but instead with code path accessing other data in the
same cache line (or spilled across multiple cache lines just because
of the __warned variable sitting in the middle).

> Which brings us down to saving a bit of space.  And I don't think I see
> how this saves space?

The space saving results from grouping (many) 1-byte entities
together, which (when emitted normally) will generally require
padding to 4 or 8 bytes (as being adjacent with other static data
in the same or next compilation unit). That padding won't occur
if all of the items in a given section are of the same size (and
alignment).

Jan

