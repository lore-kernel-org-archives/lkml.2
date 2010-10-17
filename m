Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0JQNMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 09:12:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57581 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab0JQNMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 09:12:47 -0400
MIME-Version: 1.0
In-Reply-To: <1287313332.1998.172.camel@laptop>
References: <20101016065206.GO4681@dastard>
	<20101016192027.GA6883@infradead.org>
	<1287295077.3020.83.camel@localhost.localdomain>
	<1287313332.1998.172.camel@laptop>
Date: Sun, 17 Oct 2010 09:12:47 -0400
Message-ID: <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
From: Eric Paris <eparis@parisplace.org>
To: Peter Zijlstra <peterz@infradead.org>, eparis@redhat.com
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 7:02 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2010-10-17 at 01:57 -0400, Mimi Zohar wrote:
>> On Sat, 2010-10-16 at 15:20 -0400, Christoph Hellwig wrote:
>> > Besides the algorithmic problems with ima, why is kernel.org using
>> > IMA to start with?  Except for IBM looking for a reason to jusity why
>> > TPM isn't a completely waster of ressources it's pointless.  And it was
>> > only merged under the premise that it would not affect innocent normal
>> > users.
>> >
>>
>> Can we keep this at the design level please? When IMA is enabled, it
>> needs to store information on a per inode basis, yet has to wait to
>> late_initcall() for the TPM, at which point some inodes would have
>> already been created.
>
> Being build (CONFIG_IMA=y) is not the same as default enabled. Is there
> a way to build this stuff and not have it enabled?

IMA isn't really 'enabled' by default (then again people might not
call it 'disabled' either).  When 'enabled' IMA takes cryptographic
hashes of the contents of files, stores those in a list, and backs
that list storage with the TPM.  If we expect IMA to ever transfer
from disabled to enabled we actually need a small amount of
information about inodes from the time it was disabled.  We need to
know how many things have the given inode open for read and how many
for write.  The reason it needs this information is that it needs to
be able to realize the the value of a cryptographic hash of the
contents of a file is useless if some other process is able to change
those contents immediately after the measurement.  I haven't looked
closely, but we could probably get away with only knowing the number
of writers.  Today, we collect readers, writers, and total number with
it open (should be equal to readers+writers) because that debugging
has found and fixed where a couple of filesystems are doing dumb
things.  Maybe we could get rid of readers/total but then we have no
idea when 'some random fs' does something which makes the writers
count incorrect.

Today, by default, when 'not enabled' we create a full data structure
which includes the reader/writer count, space for cryptographic
information, and a couple of other little things and store them in a
radix tree just for the reader/writer count.  I believe that if we
stored the writer count in the inode we could probably delay the
creation of the full structure until it was needed.  But at the time
of merging/review putting anything in the inode was rejected and we
were told to use a radix tree.

We could split this into 2 structures, thus greatly shrinking the size
of the structure needed for the default/disabled case, but it doesn't
help the fact that the suggested structure for storage (the radix
tree) is apparently quite inefficient.  I'd love to hear other
suggestions for a better structure....

-Eric
