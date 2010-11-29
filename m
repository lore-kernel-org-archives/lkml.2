Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0K2Q5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:57:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59599 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0K2Q5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:57:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BCGN5nK/Jb7R+JqrsYsNWfT9vsCemZle0ZrlnCKw207Xk2Jk+3KaqHC4WggX05my0w
         TTqMSSyyrPkdL5ykm+MOeCb/uar4pb2QZS+2+h+S60HDaDHXs4OyKGuN7k+G4LySn6hy
         D8TlDpon+nsTwfNxQi/4HDrR9frG3P4uz+UTw=
MIME-Version: 1.0
In-Reply-To: <1291047294.3248.9.camel@localhost.localdomain>
References: <20101122002747.13674.69384.stgit@zaytsev.su>
	<20101122003357.13674.30341.stgit@zaytsev.su>
	<201011261011.55266.tvrtko.ursulin@sophos.com>
	<1291047294.3248.9.camel@localhost.localdomain>
Date: Mon, 29 Nov 2010 19:51:26 +0300
Message-ID: <AANLkTikHyYZYfX7sg=edsC6uykM8gje+JsBUxpbYZ1q1@mail.gmail.com>
Subject: Re: [PATCH 4/4] fanotify: Expose the file changes to the user
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Scott Hassan <hassan@dotfunk.com>, Jan Kara <jack@suse.cz>,
        "agruen@linbit.com" <agruen@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 19:14, Eric Paris <eparis@redhat.com> wrote:
> On Fri, 2010-11-26 at 10:11 +0000, Tvrtko Ursulin wrote:
>> On Monday 22 Nov 2010 00:37:21 Alexey Zaytsev wrote:
>
>> >  struct fanotify_event_metadata {
>> > -       __u16 event_len;
>> > +       __u16 event_len; /* Including the options */
>> >         __u8 vers;
>> > -       __u8 reserved;
>> > +       __u8 options_offset; /* Aka header length */
>> >         __s32 fd;
>> >         __aligned_u64 mask;
>> >         __s32 pid;
>> > +       /* Options go here. */
>> >  };
>
>> Also, options_offset is, if I understood it correctly, basically the lenght of
>> fanotify_event_metadata. As such, isn't that field redundant since the lenght
>> is implied from the protocol version?
>
> Ok, the way I envision the interface is the fanotify_event_metadata is
> going to be information that is common for all event types.  If a
> particular event type (in the case being brought forth MODIFY and
> CLOSE_WRITE) needs more information it will use the optional headers.
> I'd still like to be able to add generic info, ex: the uid of the
> requesting process, to the generic event metadata.  We might also
> someday want to use the optional headers for things like the inotify
> move cookie.  Why waste space in every event when only the move type
> events cared about this cookie?
>
> This necessitates options_offset.  Lets say I compile my userspace app
> as version 3.  I know that fanotify_event_metadata is 14 bytes long in
> version 3.  Thus I start looking at byte 15 for the first optional
> header.  But the kernel is version 4 and fanotify_event_metadata is
> actually 18 bytes long.  Whoops, userspace should be looking at byte 19
> for the header but accidentally looked at byte 15.  options_offset will
> allow a version 3 userspace to run on a version 4 kernel while skipping
> bytes 15-18 which it doesn't understand.
>
> At the end of all of this discussion what did people finally agree on?
> Something like this?
>
> struct fanotify_opt_hdr {
>        __u16 type;
>        __u16 len;
>        /* Payload goes here. */
> };
>
> struct fanotify_event_metadata {
>        __u32 event_len; /* Including the options */
>        __u16 vers;
>        __u16 options_offset; /* Aka header length */
>        __s32 fd;
>        __aligned_u64 mask;
>        __s32 pid;
>        /* Options go here. */
> };
>

Yep, except mask should go after options_offset to avoid the gap, and
let's make both vers and options_offset u8, just in case we need the
other 2 bytes in the future:

struct fanotify_event_metadata {
       __u32 event_len; /* Including the options */
       __u8 vers;
       __u8 options_offset; /* Aka header length */
       __u16 reserved;
       __aligned_u64 mask;
       __s32 fd;
       __s32 pid;
       /* Options go here. */
};

> We could be ABI compatible if we let vers as a __u32 and added
> options_offset at the end of the structure...   Do we have strong
> feelings on either side about maintaining compatibility or about3
> structure lengths?

Actually, with event_len being __u32, and mask moved back, we are
already abi-compatible. The users would see the wrong version, but
it's always > 2, so everyone happy. Together with the hypothetical
huge options, this fully justifies spending 2 bytes on event_len to
me.
