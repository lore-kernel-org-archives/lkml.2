Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0KZLlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:41:44 -0500
Received: from mx5.sophos.com ([213.31.172.35]:51542 "EHLO mx5.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab0KZLlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:41:42 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Subject: Re: [PATCH 4/4] fanotify: Expose the file changes to the user
Date: Fri, 26 Nov 2010 11:41:40 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3; KDE/4.5.3; x86_64; ; )
CC: Eric Paris <eparis@redhat.com>, Scott Hassan <hassan@dotfunk.com>,
        Jan Kara <jack@suse.cz>, "agruen@linbit.com" <agruen@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20101122002747.13674.69384.stgit@zaytsev.su> <201011261011.55266.tvrtko.ursulin@sophos.com> <AANLkTikRDyq4_rA5M7tiAuJJ7aa-pGfRj2YeqAmH5COA@mail.gmail.com>
In-Reply-To: <AANLkTikRDyq4_rA5M7tiAuJJ7aa-pGfRj2YeqAmH5COA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201011261141.40640.tvrtko.ursulin@sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 Nov 2010 11:21:18 Alexey Zaytsev wrote:
> On Fri, Nov 26, 2010 at 13:11, Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
wrote:
> > On Monday 22 Nov 2010 00:37:21 Alexey Zaytsev wrote:
> >> +struct fanotify_opt_hdr {
> >> +       __u8 type;
> >> +       __u8 reserved;
> >> +       __u16 len;
> >> +       /* Payload goes here. */
> >> +};
> >> +
> >> +#define FANOTIFY_METADATA_VERSION      3
> >>
> >>  struct fanotify_event_metadata {
> >> -       __u16 event_len;
> >> +       __u16 event_len; /* Including the options */
> >>         __u8 vers;
> >> -       __u8 reserved;
> >> +       __u8 options_offset; /* Aka header length */
> >>         __s32 fd;
> >>         __aligned_u64 mask;
> >>         __s32 pid;
> >> +       /* Options go here. */
> >>  };
> >
> > I am not 100% comfortable with having 16 bits length fields because I am
> > just not sure there is a measurable performance difference versus just
> > going with 32 bits.
>
> I'm not concerned so much with the performance, as with the storage.
> If we are generating events for every access on a mount point, some
> consumers might build a considerable backlog over a period of high
> activity. Would be good if we could cut the event size by 1/3 for
> free. And I don't see an event growing 64k even with the options. Do
> you?

I don't but maybe it is just lack of imagination.

My bias is that I am mostly thinking about synchronous events where large
backlog is not a realistic scenario. How realistic you think is this with
async events?

> > Also, options_offset is, if I understood it correctly, basically the
> > lenght of fanotify_event_metadata. As such, isn't that field redundant
> > since the lenght is implied from the protocol version?
>
> There are two problems there.
>
> 1) You lose backwards-compatibility. It's still an ABI breakage, even
> if you tell the users about it.

Assuming 2.6.37 release as starting point for ABI considerations?

> 2) You can't build a program to account for different fanotify versions:
>         if (vers >= N) { use the cool stuff } else if {vers >= N-1}  {
> still good }

I don't get why not, but maybe I am just slow today. There will always be 1:1
mapping from version to your options_offset field, no? How does then removing
options_offset change anything?

Tvrtko

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.
