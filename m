Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762Ab1IIWG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 18:06:56 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:51207 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1IIWGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 18:06:55 -0400
MIME-Version: 1.0
In-Reply-To: <1315602252.23777.5.camel@Joe-Laptop>
References: <cover.1314725877.git.jbaron@redhat.com> <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
 <20110908165230.a7505321.akpm@linux-foundation.org> <1315534396.11939.10.camel@Joe-Laptop>
 <20110908204200.6cf7abc2.akpm@linux-foundation.org> <1315540963.11939.12.camel@Joe-Laptop>
 <CAO+b5-oOHXEhnA+zpwA9GR7k1TX3Wn6XuOdc3TB4MPNiSpskiw@mail.gmail.com>
 <CAJfuBxx=r_P7em_naUN_c96A++V4v6nfd8B_V2dppRag-z_qwg@mail.gmail.com> <1315602252.23777.5.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 9 Sep 2011 16:06:24 -0600
Message-ID: <CAJfuBxwtefLyJcz1EbKvsGJ+XMtJiRW7A3Yy+wHXgL3GpUXbSg@mail.gmail.com>
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct _ddebug
 descriptor definitions
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        gregkh@suse.de, Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 3:04 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2011-09-09 at 13:23 -0600, Jim Cromie wrote:
>> It also allows for "lite" usage of dynamic-debug,
>> including 1..few descriptor per file or module to control all debug printing.
>> As outlined, this "lite" usage is determined by the coder,
>> it would be cool if it were more configurable than that,
>> but I dont see how that would work atm.
>
> General problem is that there are subsystems that use
> bitmasks with more than a just a few bits defined.
>

ah yes.  I was speaking narrowly.  But youre right, it would make
sense to cover all users ad-hoc debug flags.

The trick is then to allow those users to define flag-chars that they like
(mnemonic value), and that work with the dynamic-debug mini-language
implemented in $CONTROL reader.

Giving them the [A-Z1-9] flag space would probably do nicely,
it reserves [a-z] for dynamic-debug itself ([pmflt] currently,
[a_] added by my patchset)
[1-9] is a natural for levels,
[A-Z] is natural for bit-masks.


>> Now that the worms have escaped the can, one other thought:
>>       unsigned int lineno:24;
>> allows for insanely large files.  The largest in the tree is 29k,
>> 16 bits would cover all files likely to be accepted in the future.
>
> I hope ever.
Indeed ;-)

>> Since since it works with module/file/function filtering, 3-4 user
>> flags should be plenty.
>
> I rather doubt it as there are both level and mask uses.
>
> There is no real issue with adding another flag value
> to the struct anyway.  It's declared __aligned(8) and
> it ends in an unaligned single char so there's space
> for another u32 without extending the structure size.

But that begs the question - is there a reason why __aligned(4)
wouldnt work for 32 bit machines ?   It would reduce the footprint
for small machines.

I guess I should try it. its only cpu time.

If aligned(4) works, then trimming lineno to 16 doubles the flagspace
[0-7] levels take 3 bits, leaving 13 for bitmasks.
DYNAMIC_DEBUG_CLAIM_FLAGS('ABCGXYZ')
could map the [A-Z] range into those 13, while preserving mnemonics.

with INIT_DYNAMIC_DEBUG_METADATA_FLAGGED(name, fmt, flagstr)
coders could define the flags which are added to descriptor.flags for
that callsite,
marking them for selectability via flags-filtering;

echo A+p > $CONTROL
echo B+p > $CONTROL
echo C+p > $CONTROL
echo G+p > $CONTROL
echo X+p > $CONTROL
echo Y+p > $CONTROL
echo Z+p > $CONTROL

without requiring that they be marked beforehand:

echo <<HEREDOC
module foo function bar +B
module foo function cow +C
module foo function gator +G
...
HEREDOC > $CONTROL

(Id resist alternation as a flags-filter construct,
this is already in creeping-featurism territory)

Also, what is your notion of level ?
it is independent of the error,warning,info,debug levels correct ?
