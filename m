Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab1LOQsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:48:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49192 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1LOQsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:48:52 -0500
MIME-Version: 1.0
In-Reply-To: <20111215084050.GQ2203@ZenIV.linux.org.uk>
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu> <87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
 <CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com> <20111215084050.GQ2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Dec 2011 08:48:30 -0800
X-Google-Sender-Auth: -F6TjIADwyoxQDcsomAcJmFVvaA
Message-ID: <CA+55aFxsFDbnD2om1TWHJiqCEwnWKpw2d1jNU+K_GgaSStiDfw@mail.gmail.com>
Subject: Re: [PATCH resend] audit: fix mark refcounting
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eric Paris <eparis@redhat.com>,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 12:40 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> In particular, a quick grep shows that there are destroy_mark users still in:
>>
>>  - fs/notify/fanotify/fanotify_user.c
>>
>>  - fs/notify/dnotify/dnotify.c (2 of them)
>>
>>  - fs/notify/inotify/inotify_fsnotify.c
>>
>> that don't do "put_mark()" after the destroy. Why is it ok there?
>
> Um?  dnotify has fsnotify_put_mark() called in both cases...

Ok, that didn't show up in my grep, the "put_mark()" was more than
three lines away in the other case. As mentioned, I simply grepped
without looking at much context at all.

> I don't like it; it's called from ->handle_event() and parent->mark is
> exactly the inode_mark argument of that method.  It ought to be pinned
> by caller.  In other places we *do* need get/put around that destroy
> and we generally do that.

Presumably *parent* is pinned by caller, but not ->mark. So when the
parent directory is deleted, the parent data structure stays around,
but mark is cleanred, and you get the oops that was reported. See the
simple two-liner example to trigger it. I didn't test it myself, but
it looks obvious.

                             Linus
