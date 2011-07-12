Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1GLStf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:49:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39782 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab1GLStd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:49:33 -0400
MIME-Version: 1.0
In-Reply-To: <87liw367uj.fsf@tucsk.pomaz.szeredi.hu>
References: <1310305703.13309.7.camel@twins> <1302756608.2854.10.camel@perseus.themaw.net>
 <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com>
 <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <4DA5DCB8.3040101@gmail.com>
 <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com> <4DA5F569.9020309@gmail.com>
 <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com> <24792.1302808448@redhat.com>
 <2477.1309342656@redhat.com> <4E1962BE.8010204@redhat.com>
 <1408.1310382069@redhat.com> <1310385651.18678.59.camel@twins>
 <CAOMqctQoO7zKojoEuYri8ZWDDMM3Ef6VRtPYzsf-02xhJ8e6jA@mail.gmail.com>
 <1310392232.4276.14.camel@perseus.themaw.net> <CAOMqctSDxauVLw5OisAeCaFa7DvZDgg_1YCmHaWdJZm60JDVtg@mail.gmail.com>
 <1310405033.4276.28.camel@perseus.themaw.net> <CAOMqctSZcAuA8r=Bdtg1hhM9xzDmDuOPn376HXuQ0Tb8xrRwzw@mail.gmail.com>
 <87tyar6gv8.fsf@tucsk.pomaz.szeredi.hu> <CAOMqctQauGk0XszoUo61k4GQ5gWWWgyRXY9x9J=D+K4kMJ_CUw@mail.gmail.com>
 <87liw367uj.fsf@tucsk.pomaz.szeredi.hu>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Tue, 12 Jul 2011 20:49:13 +0200
X-Google-Sender-Auth: zlNjZyg6pIyw_v6cMGDxjKQ2LC8
Message-ID: <CAOMqctSYVuzpCUN+QjB7n7rZrrH4c-hHz=iC7kX70JED_dbLyA@mail.gmail.com>
Subject: Re: Union mount and lockdep design issues
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ian Kent <ikent@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2011 13:45, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Michal Suchanek <hramrach@centrum.cz> writes:
>
>> On 12 July 2011 10:30, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> Michal Suchanek <hramrach@centrum.cz> writes:
>>>
>>>> The locking order is likely determined by the structure of the union
>>>> and not some system-wide order of filesystems so assuming the readonly
>>>> layers are locked as well you will probably get a deadlock with
>>>> technically correct mount:
>>>>
>>>> mount -t overlayfs overlayfs -olowerdir=/lower2,upperdir=/upper /tmpoverlay
>>>> mount -t overlayfs overlayfs -olowerdir=/lower1,upperdir=/tmpoverlay /overlay
>>>>
>>>> mount -t overlayfs overlayfs -olowerdir=/lower1,upperdir=/upper2 /tmpoverlay2
>>>> mount -t overlayfs overlayfs -olowerdir=/lower2,upperdir=/tmpoverlay2 /overlay2
>>>>
>>>> because now lower1 and lower2 are differently ordered in the two
>>>> overlays.
>>>
>>> Overlayfs never locks both upper and lower at the same time, which means
>>> there's no AB-BA locking dependency.  The lock orderings are:
>>>
>>> -> /overlay
>>>  -> /lower1
>>>  -> /tmpoverlay
>>>    -> /lower2
>>>    -> /upper
>>> -> /overlay2
>>>  -> /lower2
>>>  -> /tmpoverlay2
>>>    -> /lower1
>>>    -> /upper2
>>>
>>> As you can see there's no nesting of lower2 and lower1 into each other.
>>>
>>> When you combine two filesystems, a completely new ordering is created
>>> each time, there's no possibility to make an AB-BA nesting.  At least I
>>> cannot see one.
>>
>> Except you can get in situation where overlay locks lower1 and
>> tmpoverlay waits for lower2
>
> Note: tmpoverlay lock does *not* nest into lower1 lock, they are both on
> the same nesting level.  There's no dependency between the two.
>
>>  which is held by overlay2 waiting for
>> lower1 in tmpoverlay2.
>
> No deadlock there.
>

That's nice.

You can still do

mount --bind /lower1 /lower2/lower1
mount --bind /lower2 /lower1/lower2

Which is technically not against usage guidelines, unlike mount --bind
/upper /lower1/upper

If crossing mount boundaries is forbidden try with symlinks or hardlinks.

Thanks

Michal
