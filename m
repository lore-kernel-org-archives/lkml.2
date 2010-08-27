Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0H0Xvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:51:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51765 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0H0Xvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:51:54 -0400
MIME-Version: 1.0
In-Reply-To: <1282682582-15980-1-git-send-email-eparis@redhat.com>
References: <1282682582-15980-1-git-send-email-eparis@redhat.com>
Date: Fri, 27 Aug 2010 19:51:53 -0400
Message-ID: <AANLkTimbQivEd7z1+sdLgChieGrY3c9iQWXVKgcYRAY=@mail.gmail.com>
Subject: Re: [PATCH -v2] fanotify: drops the packed attribute from userspace
 event metadata
From: Eric Paris <eparis@parisplace.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andreas Schwab <schwab@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Andreas Gruenbacher <agruen@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I liked this version until I realized that userspace doesn't have
aligned_u64 as a valid type.

I'm feeling more like my old version of the patch.  Anyone have
thoughts or comments?

-Eric

On Tue, Aug 24, 2010 at 4:43 PM, Eric Paris <eparis@redhat.com> wrote:
> The userspace event metadata structure was packed so when sent from a kernel
> with a certain set of alignment rules to a userspace listener with a different
> set of alignment rules the userspace process would be able to use the
> structure.  On some arches just using packed, even if it doesn't do anything
> to the alignment can cause a severe performance hit.  From now on we are
> not going to set the packed attribute and will just need to be very careful
> to make sure the structure is naturally aligned.
>
> Cc: Andreas Schwab <schwab@redhat.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
> Cc: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
>  include/linux/fanotify.h |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
> index 0535461..b892e46 100644
> --- a/include/linux/fanotify.h
> +++ b/include/linux/fanotify.h
> @@ -65,20 +65,23 @@
>                                 FAN_ALL_PERM_EVENTS |\
>                                 FAN_Q_OVERFLOW)
>
> -#define FANOTIFY_METADATA_VERSION      1
> -
> +#define FANOTIFY_METADATA_VERSION      2
> +/*
> + * These structures must be naturally aligned so that a 32 bit userspace process
> + * will find the offsets the same as a 64bit process.
> + */
>  struct fanotify_event_metadata {
>        __u32 event_len;
>        __u32 vers;
> -       __u64 mask;
> +       aligned_u64 mask;
>        __s32 fd;
>        __s32 pid;
> -} __attribute__ ((packed));
> +};
>
>  struct fanotify_response {
>        __s32 fd;
>        __u32 response;
> -} __attribute__ ((packed));
> +};
>
>  /* Legit userspace responses to a _PERM event */
>  #define FAN_ALLOW      0x01
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
