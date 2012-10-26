Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2JZCcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 22:32:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55116 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2JZCcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 22:32:23 -0400
MIME-Version: 1.0
In-Reply-To: <1351212379-26026-1-git-send-email-ming.lei@canonical.com>
References: <1351212379-26026-1-git-send-email-ming.lei@canonical.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Oct 2012 19:32:01 -0700
X-Google-Sender-Auth: eHbReix4oi2HgVt9yR-YtbMcPPE
Message-ID: <CA+55aFwaLnyYFaydxw1ALmp_EP217DmgY=ihNy3z1ZqF-pqkSA@mail.gmail.com>
Subject: Re: [PATCH v1] firmware loader: introduce module parameter to
 customize fw search path
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 5:46 PM, Ming Lei <ming.lei@canonical.com> wrote:
>                 struct file *file;
> -               snprintf(path, PATH_MAX, "%s/%s", fw_path[i], buf->fw_id);
> +
> +               if (i < 0) {
> +                       if (!fw_path_para[0])   /* No customized path */
> +                               continue;
> +                       snprintf(path, PATH_MAX, "%s/%s", fw_path_para,
> +                                buf->fw_id);
> +               } else {
> +                       snprintf(path, PATH_MAX, "%s/%s", fw_path[i],
> +                                buf->fw_id);
> +               }

Ugh. This is just disgusting.

Please just make "fw_path[0]" just be the pointer to fw_path_para[]
(which sounds like the cleanest fix) and get rid of the negative 'i'
and conditional entirely.

Or if there is some odd reason you don't want to do that, at least
make the conditional much smaller, without the snprintf() in both arms
(ie make the if-statement just set a "const char *dir" variable to
either fw_path[i] or fw_path_para or whatever).

Sure, the compiler *may* merge them (gcc does, but I've seen it miss
them too), but even if the compiler might fix up ugly code, that's not
a reason for it to be ugly in the source code anyway.

          Linus
