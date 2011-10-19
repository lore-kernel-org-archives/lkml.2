Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1JSEd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:33:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44222 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab1JSEd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:33:27 -0400
MIME-Version: 1.0
In-Reply-To: <1318974898-21431-6-git-send-email-serge@hallyn.com>
References: <1318974898-21431-1-git-send-email-serge@hallyn.com>
	<1318974898-21431-6-git-send-email-serge@hallyn.com>
Date: Tue, 18 Oct 2011 21:33:25 -0700
X-Google-Sender-Auth: 1xRjNs5bvhL_Vpp8zR2joDvyAFw
Message-ID: <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] user namespace: clamp down users of cap_raised
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Serge Hallyn <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org, oleg@redhat.com, richard@nod.at,
        mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        dhowells@redhat.com, eparis@redhat.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 2:54 PM, Serge Hallyn <serge@hallyn.com> wrote:
> From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
>
> A few modules are using cap_raised(current_cap(), cap) to authorize
> actions.  This means that tasks which are privileged in non-initial
> user namespaces will be deemed privileged.  The privilege should only
> be granted if the task is in the initial user namespace.
>
> Switching the calls to capable() would change the behavior - it would
> cause the LSM capable hooks to be called, and set PF_SUPERPRIV if
> the capability was used.  So instead, put in an explicit check and
> refuse privilege if the caller is not in init_user_ns.
>
> Vasiliy had suggested introducing a new helper for this.  I'm open
> to suggestions, but for four callers and for a discouraged idiom,
> I'd rather not pollute the capable* function namespace with a bad name.
> (even has_capability goes through the LSM hooks)
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Andrew Morgan <morgan@kernel.org>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  drivers/block/drbd/drbd_nl.c           |    5 +++++
>  drivers/md/dm-log-userspace-transfer.c |    3 +++
>  drivers/staging/pohmelfs/config.c      |    3 +++
>  drivers/video/uvesafb.c                |    3 +++
>  4 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
> index 0feab26..9a87a14 100644
> --- a/drivers/block/drbd/drbd_nl.c
> +++ b/drivers/block/drbd/drbd_nl.c
> @@ -2297,6 +2297,11 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
>                return;
>        }
>
> +       if (current_user_ns() != &init_user_ns) {

I'd feel much happier with this if it did use some inline or macro here.

#define NS_IS_NON_DEFAULT (current_user_ns() != &init_user_ns)

if (NS_IS_NON_DEFAULT || !cap_raised(current_cap(), CAP_SYS_ADMIN)) {
        retcode = ERR_PERM;
        goto fail;
}

Is it important to support the situation that NS support is not configured?

Cheers

Andrew


> +               retcode = ERR_PERM;
> +               goto fail;
> +       }
> +
>        if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
>                retcode = ERR_PERM;
>                goto fail;
> diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
> index 1f23e04..140ca81 100644
> --- a/drivers/md/dm-log-userspace-transfer.c
> +++ b/drivers/md/dm-log-userspace-transfer.c
> @@ -134,6 +134,9 @@ static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
>  {
>        struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
>
> +       if (current_user_ns() != &init_user_ns)
> +               return;
> +
>        if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
>                return;
>
> diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
> index b6c42cb..cd259d0 100644
> --- a/drivers/staging/pohmelfs/config.c
> +++ b/drivers/staging/pohmelfs/config.c
> @@ -525,6 +525,9 @@ static void pohmelfs_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *n
>  {
>        int err;
>
> +       if (current_user_ns() != &init_user_ns)
> +               return;
> +
>        if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
>                return;
>
> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
> index 7f8472c..71dab8e 100644
> --- a/drivers/video/uvesafb.c
> +++ b/drivers/video/uvesafb.c
> @@ -73,6 +73,9 @@ static void uvesafb_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *ns
>        struct uvesafb_task *utask;
>        struct uvesafb_ktask *task;
>
> +       if (current_user_ns() != &init_user_ns)
> +               return;
> +
>        if (!cap_raised(current_cap(), CAP_SYS_ADMIN))
>                return;
>
> --
> 1.7.5.4
>
>
