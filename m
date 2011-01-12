Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab1ALEGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 23:06:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58974 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ALEGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 23:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XyE91wevDuo3W50v1v8IqkCz8i2xs84ujI2/Uvh0x6osgqMgDy9QkDyrsleqmg+vQh
         kQuuOslqK2DWgKA7MEdVRimLo+ujjg9sbvDzHbSjXClFn258+cQTwPSvJ/6o4e/JilE0
         otZ1Rgu0uOXK/STOjRSz5k9nB6jVHDNFLNzEc=
MIME-Version: 1.0
In-Reply-To: <1294804776.2821.4.camel@perseus>
References: <20110107075831.GA14915@amd>
	<1294763679.2435.72.camel@doink>
	<AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	<1294768668.2435.177.camel@doink>
	<1294804776.2821.4.camel@perseus>
Date: Wed, 12 Jan 2011 15:06:01 +1100
Message-ID: <AANLkTi=6UNmYq_fxLeCM7iH-VAGL8TLyfW3sSgCkC+8c@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
From: Nick Piggin <npiggin@gmail.com>
To: Ian Kent <raven@themaw.net>
Cc: aelder@sgi.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 2:59 PM, Ian Kent <raven@themaw.net> wrote:
> On Tue, 2011-01-11 at 11:57 -0600, Alex Elder wrote:
>> On Tue, 2011-01-11 at 08:51 -0800, Linus Torvalds wrote:
>> > On Tue, Jan 11, 2011 at 8:34 AM, Alex Elder <aelder@sgi.com> wrote:
>> > >
>> > > FYI, when using this code, as merged by Linus, I hit the
>> > > BUG_ON() at the beginning of d_set_d_op() when it's called
>> > > by autofs4_dir_mkdir().  I managed to work around it by
>> > > just commenting out those BUG_ON() calls but it's something
>> > > that ought to get addressed properly.
>> >
>> > Yeah, removing the BUG_ON() isn't the right thing to do - it means
>> > that autofs4 is obviously setting the dentry ops twice for the same
>> > dentry.
>> >
>> > Possibly the thing could be relaxed to allow setting the _same_ d_op
>> > pointer, ie do something like
>> >
>> >    if (dentry->d_op == op)
>> >       return;
>> >
>> > at the top of that function. But looking at it, I don't think that
>> > fixes the autofs4 issue.
>>
>> That's easy enough, but it seems everybody else ensures
>> this gets done just once per dentry, and it would be nice
>> to preserve that "tightness" if possible.
>>
>> > The fact that autofs4 does "d_add()" before it sets the d_ops (or
>> > other dentry state, for that matter) looks a bit scary. To me that
>> > smells like it might get a  dentry lookup hit before it's actually
>> > fully done.
>>
>> Agreed.
>
> Isn't the parent i_mutex held during mkdir()?

Yes but there are concurrency cases allowed without i_mutex.

Lookup, for example, which ends up touching d_revalidate and
when dropping the dentry, possibly d_delete.

There seems no benefit to allowing switch of d_ops on a live
dentry, and many downsides. So the rule should just be that it
is not allowed.


> Still the order can be changed, of course.
>
>>
>> > Does it make any difference if you move the various d_add() calls down
>> > to the end of the functions to when the "dentry" has really been
>> > instantiated?
>>
>> Looking at it quickly, I don't think that would matter for
>> the case at hand.  I.e., that might be safer but it doesn't
>> address the fact that these fields are getting initialized
>> multiple times.
>
> Yeah, a hangover from changes done over time.
> Not setting the dentry op in ->lookup() should fix this.

How about negative dentries? They should be set up with d_ops
upon allocation, preferably if your operations can handle negative
dentries.

Thanks,
Nick
