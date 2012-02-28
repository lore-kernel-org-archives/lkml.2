Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2B1ICG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:02:06 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:3642 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab2B1ICE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Tue, 28 Feb 2012 03:02:04 -0500
Message-Id: <4F4C983002000078000751AE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 28 Feb 2012 08:02:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] consolidate WARN_...ONCE() static variables
References: <4F4BAAFA0200007800074F8F@nat28.tlf.novell.com>
 <20120227160302.ef9f6af4.akpm@linux-foundation.org>
 <4F4C93520200007800075197@nat28.tlf.novell.com>
 <20120227234451.3a00a76a.akpm@linux-foundation.org>
In-Reply-To: <20120227234451.3a00a76a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.12 at 08:44, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 28 Feb 2012 07:41:54 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> >>> On 28.02.12 at 01:03, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Mon, 27 Feb 2012 15:10:34 +0000
>> > "Jan Beulich" <JBeulich@suse.com> wrote:
>> > 
>> >> Due to the alignment of following variables, these typically consume
>> >> more than just the single byte that 'bool' requires, and as there are
>> >> a few hundred instances, the cache pollution (not so much the waste of
>> >> memory) sums up. Put these variables into their own section, outside
>> >> of any half way frequently used memory range.
>> >> 
>> >> v2: Do the same also to the __warned variable of rcu_lockdep_assert().
>> >> (Don't, however, include the ones used by printk_once() and alike, as
>> >> they can potentially be hot.)
>> > 
>> > I have a bad feeling that I still don't understand this patch.  Ho hum.
>> > 
>> > What are the rules for the new .data.unlikely section?  When should
>> > people put variables into this section?  Perhaps we can document this
>> > somewhere?
>> 
>> If I knew the "where" part of this, I could put together a few sentences.
>> I just grep-ed through Documentation/, without finding e.g. any rules
>> or guidelines for using {,un}likely()...
>>
> 
> At the definition site in vmlinux.lds?

Sorry, Andrew, but this makes no sense to me. For one, vmlinux.lds{,h}
don't define anything, they merely gather together all input sections.
Second, the very similar use of .text.unlikely there isn't being explained
in any way either (which makes sense given that that's a compiler
generated section, which I just derived the new section's name from).

If anything, I would expect a place where all the special sections (.init*,
.exit*, etc) are being explained, but this (if existing at all) is scattered
around. While I don't mind adding a few words to something that
already exists, I'm not really eager to write something from scratch.

Finally, if we're really looking forward to having this used in a broader
manner (and particularly with objects wider than bool), then the
section name should get changed again anyway (and perhaps some
further abstraction be created): The goal of the patch is not only to
get the symbols out of potentially hot cache lines, but (secondary,
but nevertheless) also to avoid the non-negligible waste of space due
to padding (taking into consideration that the compiler doesn't really
do a good job in this regard, nor does it make meaningful attempts
at providing the necessary infrastructure for doing so manually).

Jan

