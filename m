Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0KARQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:16:26 -0400
Received: from mx6.sophos.com ([213.31.172.36]:47232 "EHLO mx6.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab0KARQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:16:24 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 12/20] fanotify: allow userspace to override max marks
Date: Mon, 1 Nov 2010 17:16:01 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "agruen@suse.de" <agruen@suse.de>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com> <20101028213244.24810.19075.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213244.24810.19075.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Message-ID: <201011011716.01875.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 01/11/2010 17:16:02,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 01/11/2010 17:16:02,
	Serialize complete at 01/11/2010 17:16:02
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 Oct 2010 22:32:44 Eric Paris wrote:
> Some fanotify groups, especially those like AV scanners, will need to place
> lots of marks, particularly ignore marks.  Since ignore marks do not pin
> inodes in cache and are cleared if the inode is removed from core (usually
> under memory pressure) we expose an interface for listeners, with
> CAP_SYS_ADMIN, to override the maximum number of marks and be allowed to
> set and 'unlimited' number of marks.  Programs which make use of this
> feature will be able to OOM a machine.
>
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
>
>  fs/notify/fanotify/fanotify_user.c |    9 ++++++++-
>  include/linux/fanotify.h           |    4 +++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/fs/notify/fanotify/fanotify_user.c
> b/fs/notify/fanotify/fanotify_user.c index 1d33d7d..f921610 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -707,7 +707,14 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags,
> unsigned int, event_f_flags) group->max_events =
> FANOTIFY_DEFAULT_MAX_EVENTS;
>       }
>
> -     group->fanotify_data.max_marks = FANOTIFY_DEFAULT_MAX_MARKS;
> +     if (flags & FAN_UNLIMITED_MARKS) {
> +             fd = -EPERM;
> +             if (!capable(CAP_SYS_ADMIN))
> +                     goto out_put_group;

Same redundant (or not) capable as with queue depth.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
