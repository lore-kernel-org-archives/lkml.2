Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1GKNgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:36:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35758 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab1GKNgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <1310385651.18678.59.camel@twins>
References: <1310305703.13309.7.camel@twins> <4E0AF2BA.2040706@gmail.com>
 <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
 <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
 <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
 <24792.1302808448@redhat.com> <2477.1309342656@redhat.com>
 <4E1962BE.8010204@redhat.com> <1408.1310382069@redhat.com> <1310385651.18678.59.camel@twins>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Mon, 11 Jul 2011 15:36:19 +0200
X-Google-Sender-Auth: LkY8_qhqUiHcmI3eNJUL4f2hAU0
Message-ID: <CAOMqctQoO7zKojoEuYri8ZWDDMM3Ef6VRtPYzsf-02xhJ8e6jA@mail.gmail.com>
Subject: Re: Union mount and lockdep design issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ian Kent <ikent@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        miklos@szeredi.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2011 14:00, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-07-11 at 12:01 +0100, David Howells wrote:
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>

>> > Also, why would you want to have a class per sb-instance? From last
>> > talking to David, he said there could only ever be 2 filesystems
>> > involved in this, the top and bottom, and it is determined on (union)
>> > mount time which is which.
>>
>> There can be more than 2 - one upperfs (the actual union) and many lowerfs -
>> though I think only one lowerfs is accessed at a time.
>
> Right, however I understood from our earlier discussion that the vfs
> would only ever try to lock 2 filesystems at a time, the top and one
> lower.

This is true from local point of view. However, it is technically
possible to use overlayfs as the upper layer of another overlayfs
which allows layering multiple readonly "branches" into a single
overlay. Since the vfs will lock the "union" and one (or possibly
both) of its branches and one of the branches may be itself an union
you can get arbitrary depth (which is currently limited by a constant
in the code to cut recursion depth and stack usage).

>
>> However, I was wondering that if in the future it could be possible to make it
>> possible to union over a union.  I think that conceptually it shouldn't be that
>> hard, but definitely lockdep presents a barrier unless the top union goes
>> behind the scenes of the lower union and interacts with its lowerfs's directly.
>
> Aside from lockdep, how many fs locks will you nest and how will you
> enforce the filesystem relations remain a DAG? But yeah, that'll be a
> tad harder to do. One of the ways we could tackle that is create a lock
> class per depth, and statically create say 16 of those, allowing for a
> DAG with span of 16.

This would be consistent with the limit on nesting imposed by stack
size but there should be probably some mechanism to infer one of the
numbers from the other.

>
>> > I'm also assuming that once a filesystem is part of a union mount, it
>> > cannot be accessed from outside of said union (can it? can the botton be
>> > itself be the top layer of another union?)
>>
>> Not at the moment; the hard read-only requirements on the lowerfs versus the
>> writeability requirements of the upperfs (you can't enter a directory that you
>> can't mirror up) prevent it.
>>
>> However, at some point I'd be interested in trying to make it possible to union
>> over a writeable filesystem.  This is pretty much a requirement for unioning
>> over NFS (as you can't tell the server to make the volume you're mounting hard
>> read-only).

I don't think that there is a hard readonly requirement. As far s a I
understand the current status is that "The filesystem should not be
modified directly" and "doing so will lead to undefined behaviour but
no crash or lockup". Unless there are bugs, obviously.

>> > Also, in what state are the filesystems on construction of the union?  Are
>> > they already fully formed and populated (do inodes already exist?)
>>
>> The lower filesystems must be fully formed and, at present, may not be modified
>> whilst in the union.
>>
>> The upper filesystem can be empty or filled by a previous union.  In fact,
>> there's nothing stopping the upper fs being an ordinary fs that's then used as
>> the upper layer in a union, but I'm not sure you can then access the lower
>> echelons as the directories don't contain fallthru entries.

As overlayfs does not have explicit fallthru entries layering any two
fully formed filesystems gives an union of the two. You will only lose
access to entries that were previously deleted in an union and have a
whiteout entry in the upper layer.

Unionmount makes any directories which were touched in an upper union
layer opaque and requires explicit fallthru entries to access the
lower layer. A normal filesystem does not have opaque directories and
allows access to the lower layer when it is used as the top layer for
the first time. Traversing the union will make it opaque, though.

Thanks

Michal
