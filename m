Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0HTJCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:02:21 -0400
Received: from mx3.sophos.com ([74.202.89.160]:60790 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab0HTJCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:02:18 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: struct fanotify_event_metadata
Date: Fri, 20 Aug 2010 10:02:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Andreas Schwab <schwab@linux-m68k.org>,
        Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <m21va1ozqx.fsf@igel.home> <201008191644.29299.tvrtko.ursulin@sophos.com> <1282240426.21419.1716.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282240426.21419.1716.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Message-ID: <201008201002.16235.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/08/2010 10:02:16,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/08/2010 10:02:16,
	Serialize complete at 20/08/2010 10:02:16
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 Aug 2010 18:53:46 Eric Paris wrote:
> On Thu, 2010-08-19 at 16:44 +0100, Tvrtko Ursulin wrote:
> > On Saturday 14 Aug 2010 18:44:38 Andreas Schwab wrote:
> > > The pid field of struct fanotify_event_metadata has 64 bits which looks
> > > excessive.  Wouldn't it make sense to make it 32 bits and swap it with
> > > the mask field?  That would avoid the unaligned mask field, and remove
> > > the need for the packed attribute.
>
> Wish this thought came up 2 weeks ago  :)  It's going to stay __packed__
> no matter what, even if the alignment works out nicely and it doesn't do
> anything.
>
> I'm certainly willing to shrink the pid and switch some locations if
> noone objects but it will definitely break userspace, in that it is
> going to require a recompile of anyone's userspace listener (the
> interface was only intended to grow, not get switched around) but it has
> only been in there about a week so I'm not seeing a huge harm.
>
> I would not be happy to see the mask shrink, we might not be there yet,
> we might not ever get there, but it was part of the future proofing of
> the interface.
>
> Would anyone like to send a patch? Tvrtko?

I think it is OK to break userspace while still in the merge window.
It is not even a big breakage but just a recompile.

So something like the below?
---
Shrink pid field in the fanotify_event_metadata to 32-bit to match
the kernel representation. Pull mask field up since it logically
comes before event auxiliary data and also makes for a nicer
alignment.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
---
 include/linux/fanotify.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index f0949a5..0e7f1bb 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -70,9 +70,9 @@
 struct fanotify_event_metadata {
        __u32 event_len;
        __u32 vers;
-       __s32 fd;
        __u64 mask;
-       __s64 pid;
+       __s32 fd;
+       __s32 pid;
 } __attribute__ ((packed));

 struct fanotify_response {


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
