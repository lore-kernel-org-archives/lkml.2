Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2HBUmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:42:08 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45419 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2HBUmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:42:04 -0400
X-Originating-IP: 217.70.178.143
X-Originating-IP: 173.246.103.110
Date: Thu, 2 Aug 2012 13:41:57 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
Message-ID: <20120802204157.GB7916@jtriplet-mobl1>
References: <5019B0B4.1090102@gmail.com>
 <20120801224556.GF15477@google.com>
 <501A4FC1.8040907@gmail.com>
 <20120802103244.GA23318@leaf>
 <501A633B.3010509@gmail.com>
 <501A7AD3.7000008@gmail.com>
 <20120802161556.GA25572@leaf>
 <501AAF47.3090708@gmail.com>
 <20120802174457.GA6251@jtriplet-mobl1>
 <501ABEE2.10007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501ABEE2.10007@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 07:54:42PM +0200, Sasha Levin wrote:
> On 08/02/2012 07:44 PM, Josh Triplett wrote:
> > On Thu, Aug 02, 2012 at 06:48:07PM +0200, Sasha Levin wrote:
> >> On 08/02/2012 06:15 PM, Josh Triplett wrote:
> >>> On Thu, Aug 02, 2012 at 03:04:19PM +0200, Sasha Levin wrote:
> >>>> On 08/02/2012 01:23 PM, Sasha Levin wrote:
> >>>>>> #define DEFINE_HASH_TABLE(name, length) struct hash_table name = { .count = length, .buckets = { [0 ... (length - 1)] = HLIST_HEAD_INIT } }
> >>>>> The limitation of this approach is that the struct hash_table variable must be 'static', which is a bit limiting - see for example the use of hashtable in 'struct user_namespace'.
> >>>>>
> >>>>
> >>>> What if we just use two possible decelerations? One of static structs and one for regular ones.
> >>>>
> >>>> struct hash_table {
> >>>>         size_t bits;
> >>>>         struct hlist_head buckets[];
> >>>> };
> >>>>
> >>>> #define DEFINE_HASHTABLE(name, bits)                                    \
> >>>>         union {                                                         \
> >>>>                 struct hash_table name;                                 \
> >>>>                 struct {                                                \
> >>>>                         size_t bits;                                    \
> >>>
> >>> This shouldn't use "bits", since it'll get expanded to the macro
> >>> argument.
> >>>
> >>>>                         struct hlist_head buckets[1 << bits];           \
> >>>>                 } __name;                                               \
> >>>
> >>> __##name
> >>>
> >>>>         }
> >>>>
> >>>> #define DEFINE_STATIC_HASHTABLE(name, bit)                              \
> >>>>         static struct hash_table name = { .bits = bit,                  \
> >>>>                 .buckets = { [0 ... (bit - 1)] = HLIST_HEAD_INIT } }
> >>>
> >>> You probably wanted to change that to [0 ... ((1 << bit) - 1)] , to
> >>> match DEFINE_HASHTABLE.
> >>
> >> I wrote it by hand and didn't compile test, will fix all of those.
> >>
> >>> Since your definition of DEFINE_HASHTABLE would also work fine when used
> >>> statically, why not just always use that?
> >>>
> >>> #define DEFINE_STATIC_HASHTABLE(name, bits) static DEFINE_HASHTABLE(name, bits) = { .name.bits = bits }
> >>
> >> It will get defined fine, but it will be awkward to use. We'd need to pass anonymous union to all the functions that handle this hashtable, which isn't pretty.
> > 
> > No, it'll still use the anonymous union, so you'll still have a thing of
> > type "struct hash_table" with the given name, and you can use that name
> > with the hash-table functions.
> 
> We can use 'struct hash_table' directly, but then the call will look awkward :)
> 
> Consider this case (I've placed arbitrary values into size and name:
> 
> /* I've "preprocessed" the DEFINE macro below */
> union {
> 	struct hash_table table;
> 	struct {
> 		size_t bits;
> 		struct hlist_head buckets[32];
> 	}
> } my_hashtable;

That expansion doesn't match the macros.  Using the most recent
definitions of DEFINE_HASHTABLE and DEFINE_STATIC_HASHTABLE from above,
the definition would look something like this:

static union {
	struct hash_table my_hashtable;
	struct {
		size_t bits;
		struct hlist_head buckets[1 << 5];
	} __my_hashtable;
} = { .my_hashtable.bits = 5 };

> void foo(struct hash_table *table)
> {
> /* Do something */
> }
> 
> int main(void)
> {
> 	foo(my_hashtable); /* This is what the user expects to work, and won't work in this case */
> 
> 	foo(&my_hashtable.table); /* This is what he has to do, which means the user has to know about the internal structure of the union */
> }

Given the expansion above, you can just write this as
foo(&my_hashtable), which seems sensible to me.

- Josh Triplett
