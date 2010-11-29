Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0K2RME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:12:04 -0500
Received: from mx2.sophos.com ([195.166.81.53]:45329 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab0K2RMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:12:02 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 4/4] fanotify: Expose the file changes to the user
Date: Mon, 29 Nov 2010 17:11:57 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3; KDE/4.4.4; x86_64; ; )
CC: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Scott Hassan <hassan@dotfunk.com>, Jan Kara <jack@suse.cz>,
        "agruen@linbit.com" <agruen@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20101122002747.13674.69384.stgit@zaytsev.su> <201011261011.55266.tvrtko.ursulin@sophos.com> <1291047294.3248.9.camel@localhost.localdomain>
In-Reply-To: <1291047294.3248.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201011291711.57876.tvrtko.ursulin@sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 Nov 2010 16:14:54 Eric Paris wrote:
> On Fri, 2010-11-26 at 10:11 +0000, Tvrtko Ursulin wrote:
> > On Monday 22 Nov 2010 00:37:21 Alexey Zaytsev wrote:
> > >  struct fanotify_event_metadata {
> > >
> > > -       __u16 event_len;
> > > +       __u16 event_len; /* Including the options */
> > >
> > >         __u8 vers;
> > >
> > > -       __u8 reserved;
> > > +       __u8 options_offset; /* Aka header length */
> > >
> > >         __s32 fd;
> > >         __aligned_u64 mask;
> > >         __s32 pid;
> > >
> > > +       /* Options go here. */
> > >
> > >  };
> >
> > Also, options_offset is, if I understood it correctly, basically the
> > lenght of fanotify_event_metadata. As such, isn't that field redundant
> > since the lenght is implied from the protocol version?
>
> Ok, the way I envision the interface is the fanotify_event_metadata is
> going to be information that is common for all event types.  If a
> particular event type (in the case being brought forth MODIFY and
> CLOSE_WRITE) needs more information it will use the optional headers.
> I'd still like to be able to add generic info, ex: the uid of the
> requesting process, to the generic event metadata.  We might also
> someday want to use the optional headers for things like the inotify
> move cookie.  Why waste space in every event when only the move type
> events cared about this cookie?
>
> This necessitates options_offset.  Lets say I compile my userspace app
> as version 3.  I know that fanotify_event_metadata is 14 bytes long in
> version 3.  Thus I start looking at byte 15 for the first optional
> header.  But the kernel is version 4 and fanotify_event_metadata is
> actually 18 bytes long.  Whoops, userspace should be looking at byte 19
> for the header but accidentally looked at byte 15.  options_offset will
> allow a version 3 userspace to run on a version 4 kernel while skipping
> bytes 15-18 which it doesn't understand.

I see now what you want to do here. I assumed metadata is fixed for ever and
all expansions will come via options. That is why I said offset field is
redundant. If you want to leave option for changing metadata open then yes, I
agree it is needed.

> At the end of all of this discussion what did people finally agree on?
> Something like this?
>
> struct fanotify_opt_hdr {
>         __u16 type;
>         __u16 len;
>         /* Payload goes here. */
> };
>
> struct fanotify_event_metadata {
>         __u32 event_len; /* Including the options */
>         __u16 vers;
>         __u16 options_offset; /* Aka header length */
>         __s32 fd;
>         __aligned_u64 mask;
>         __s32 pid;
>         /* Options go here. */
> };
>
> We could be ABI compatible if we let vers as a __u32 and added
> options_offset at the end of the structure...   Do we have strong
> feelings on either side about maintaining compatibility or about
> structure lengths?

No strong feelings here on either. I do not really think maintaining
compatibility with an unreleased protocol is worth it. And I would not like to
limit any field to 8-bits if possible.

Tvrtko

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.
