Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1GLLoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 07:44:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38525 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1GLLoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 07:44:15 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Ian Kent <ikent@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Union mount and lockdep design issues
References: <1310305703.13309.7.camel@twins>
	<1302756608.2854.10.camel@perseus.themaw.net>
	<BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<4DA5DCB8.3040101@gmail.com>
	<BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
	<4DA5F569.9020309@gmail.com>
	<BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
	<24792.1302808448@redhat.com> <2477.1309342656@redhat.com>
	<4E1962BE.8010204@redhat.com> <1408.1310382069@redhat.com>
	<1310385651.18678.59.camel@twins>
	<CAOMqctQoO7zKojoEuYri8ZWDDMM3Ef6VRtPYzsf-02xhJ8e6jA@mail.gmail.com>
	<1310392232.4276.14.camel@perseus.themaw.net>
	<CAOMqctSDxauVLw5OisAeCaFa7DvZDgg_1YCmHaWdJZm60JDVtg@mail.gmail.com>
	<1310405033.4276.28.camel@perseus.themaw.net>
	<CAOMqctSZcAuA8r=Bdtg1hhM9xzDmDuOPn376HXuQ0Tb8xrRwzw@mail.gmail.com>
	<87tyar6gv8.fsf@tucsk.pomaz.szeredi.hu>
	<CAOMqctQauGk0XszoUo61k4GQ5gWWWgyRXY9x9J=D+K4kMJ_CUw@mail.gmail.com>
Date: Tue, 12 Jul 2011 13:45:08 +0200
In-Reply-To: <CAOMqctQauGk0XszoUo61k4GQ5gWWWgyRXY9x9J=D+K4kMJ_CUw@mail.gmail.com>
	(Michal Suchanek's message of "Tue, 12 Jul 2011 11:58:35 +0200")
Message-ID: <87liw367uj.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Suchanek <hramrach@centrum.cz> writes:

> On 12 July 2011 10:30, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Michal Suchanek <hramrach@centrum.cz> writes:
>>
>>> The locking order is likely determined by the structure of the union
>>> and not some system-wide order of filesystems so assuming the readonly
>>> layers are locked as well you will probably get a deadlock with
>>> technically correct mount:
>>>
>>> mount -t overlayfs overlayfs -olowerdir=/lower2,upperdir=/upper /tmpoverlay
>>> mount -t overlayfs overlayfs -olowerdir=/lower1,upperdir=/tmpoverlay /overlay
>>>
>>> mount -t overlayfs overlayfs -olowerdir=/lower1,upperdir=/upper2 /tmpoverlay2
>>> mount -t overlayfs overlayfs -olowerdir=/lower2,upperdir=/tmpoverlay2 /overlay2
>>>
>>> because now lower1 and lower2 are differently ordered in the two
>>> overlays.
>>
>> Overlayfs never locks both upper and lower at the same time, which means
>> there's no AB-BA locking dependency.  The lock orderings are:
>>
>> -> /overlay
>>  -> /lower1
>>  -> /tmpoverlay
>>    -> /lower2
>>    -> /upper
>> -> /overlay2
>>  -> /lower2
>>  -> /tmpoverlay2
>>    -> /lower1
>>    -> /upper2
>>
>> As you can see there's no nesting of lower2 and lower1 into each other.
>>
>> When you combine two filesystems, a completely new ordering is created
>> each time, there's no possibility to make an AB-BA nesting.  At least I
>> cannot see one.
>
> Except you can get in situation where overlay locks lower1 and
> tmpoverlay waits for lower2

Note: tmpoverlay lock does *not* nest into lower1 lock, they are both on
the same nesting level.  There's no dependency between the two.

>  which is held by overlay2 waiting for
> lower1 in tmpoverlay2.

No deadlock there.

Thanks,
Miklos
