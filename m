Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0K2STy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:19:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab0K2STw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:19:52 -0500
Subject: Re: [PATCH 4/4] fanotify: Expose the file changes to the user
From: Eric Paris <eparis@redhat.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Scott Hassan <hassan@dotfunk.com>, Jan Kara <jack@suse.cz>,
        "agruen@linbit.com" <agruen@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <AANLkTikHyYZYfX7sg=edsC6uykM8gje+JsBUxpbYZ1q1@mail.gmail.com>
References: <20101122002747.13674.69384.stgit@zaytsev.su>
	 <20101122003357.13674.30341.stgit@zaytsev.su>
	 <201011261011.55266.tvrtko.ursulin@sophos.com>
	 <1291047294.3248.9.camel@localhost.localdomain>
	 <AANLkTikHyYZYfX7sg=edsC6uykM8gje+JsBUxpbYZ1q1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 13:14:33 -0500
Message-ID: <1291054473.3248.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 19:51 +0300, Alexey Zaytsev wrote:

[rewriting history!]
> struct fanotify_event_metadata {
>        __u32 event_len; /* Including the options */
>        __u8 vers;
>        __u8 options_offset; /* Aka header length */
>        __u16 reserved;
>        __aligned_u64 mask;
>        __s32 fd;
>        __s32 pid;
>        /* Options go here. */
> };

> and let's make both vers and options_offset u8, just in case we need the
> other 2 bytes in the future:

So the last discussion is around vers and options_offset.

Alexy:				Tvrtko:
__u8 vers;			__u16 vers;
__u8 options_offset;		__u16 options_offset;
__u16 unused;

The only type of long option that first comes to mind is a filename.   A
filename could easily blow out the __u8 options_offset.  I probably
shouldn't put that in the event_metadata since it wouldn't be fixed
length and it wouldn't allow fixed offset extention of the
event_metadata, so maybe I shouldn't worry about it.  I'm trying to
think of reasons why __u8 isn't adequate other than my usual "just make
it bigger than we ever need"

You'll notice I'm using __u64 for the mask, even though we don't come
close to filling up an __u32 at this point.

Even though I can't think of a likely reason __u8 is bad I think I like
the 'Tvrtko' option better.  I think we should do a compromise:

Eric:
__u8 vers;
__u8 unused;
__u16 options_offset;

If we ever overload vers we can expand into another field.  Would could
change unused into vers2 and define the version as vers + vers2;  vers2
could even exist somewhere else in the metadata.  That can be done once
we get to version 254 while maintaining backwards compat beyond 255.  If
we ever overflow options_offset we are screwed since old userspace
wouldn't know how to handle things.

So, if you want to send me a patch that implements the above (along with
the obvious version bump to 3, I'll queue it up for this merge window
even though we have an ABI compatible solution.

-Eric

