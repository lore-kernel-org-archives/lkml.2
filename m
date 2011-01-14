Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab1ANDMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:12:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60561 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1ANDMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DdkkksD1iyI3Gj+Ye1dz5z/3Jcoo1m/6xEnnr6pOgn8eYPGFI7kWZqVXVelA1Xxju2
         rTzMdyAspGkn2mfIRerHlXe2bsreuy7JGuVW3af2U906NN43e2hn4A1ty66Z4btPQBTq
         NS+lfOHfIWAmCJ3NsjPIEnMVyDCiOsh4ywe9E=
MIME-Version: 1.0
In-Reply-To: <20110114030325.GU19804@ZenIV.linux.org.uk>
References: <8855.1294927436@jrobl>
	<AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
	<20110114030325.GU19804@ZenIV.linux.org.uk>
Date: Fri, 14 Jan 2011 14:12:35 +1100
Message-ID: <AANLkTi=H7Zhe4VMsh_tdrd7Atb9FX8j4AdiMNepXGsj9@mail.gmail.com>
Subject: Re: vfs-scale, d_revalidate from nfsd
From: Nick Piggin <npiggin@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 2:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Jan 14, 2011 at 01:57:55PM +1100, Nick Piggin wrote:
>> On Fri, Jan 14, 2011 at 1:03 AM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>> >
>> > NFSD calls filesystem's ->d_revalidate() with the parameter nd == NULL.
>> > So every
>> > ? ? ? ?if (nd->flags & LOOKUP_RCU)
>> > ? ? ? ? ? ? ? ?return -ECHILD;
>> > code which was added to ->d_revalidate() of FS which supports NFS
>> > exporting will crash.
>> >
>> > If we rewrite it as
>> > ? ? ? ?if (nd && (nd->flags & LOOKUP_RCU))
>> > ? ? ? ? ? ? ? ?return -ECHILD;
>> > the problem may not occur.
>> > But I am not sure whether lookup_one_len() call in NFSD support rcu-walk.
>>
>> Ah, good catch.
>>
>> I'm going to change the d_revalidate API so it takes and inode and rcu-walk
>> flag parameter to make it easier for filesystems to implement rcu-walk.
>>
>> That will take care of this NULL nd case.
>
> Oh, for fuck sake...  Would you at least mind posting your API change
> description to fsdevel before going for it?

Of course. I was discussing it with Miklos yesterday too, but haven't
finished getting a proposal together.

The main idea here would be to just pass in a flags parameter rather
thank poking in nd to get the rcu-walk status. That would solve this
problem and also avoid nd for most filesystems that don't care about
it.


> ->d_revalidate() is one sick puppy and it's intimately involved in atomic
> open rewrite.  Please, *please* don't make that shit even messier...

Right, I did agree with Miklos that using nd for passing rcu-walk
status was going in the wrong direction with that API. Do you
agree?
