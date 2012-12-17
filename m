Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2LQTEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:04:20 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35291 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2LQTES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:04:18 -0500
MIME-Version: 1.0
In-Reply-To: <87hanoxpdh.fsf@xmission.com>
References: <87txroxpgq.fsf@xmission.com> <87hanoxpdh.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Dec 2012 11:03:56 -0800
Message-ID: <CALCETrVaj0yzhGau0M+9Dd2AX+wu4anFWCfAG=Y6NnG1g-3LBg@mail.gmail.com>
Subject: Re: [PATCH 2/4] userns: Require CAP_SYS_ADMIN for most uses of setns.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 2:03 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Andy Lutomirski <luto@amacapital.net> found a nasty little bug in
> the permissions of setns.  With unprivileged user namespaces it
> became possible to create new namespaces without privilege.
>
> However the setns calls were relaxed to only require CAP_SYS_ADMIN in
> the user nameapce of the targed namespace.
>
> Which made the following nasty sequence possible.
>
> pid = clone(CLONE_NEWUSER | CLONE_NEWNS);
> if (pid == 0) { /* child */
>         system("mount --bind /home/me/passwd /etc/passwd");
> }
> else if (pid != 0) { /* parent */
>         char path[PATH_MAX];
>         snprintf(path, sizeof(path), "/proc/%u/ns/mnt");
>         fd = open(path, O_RDONLY);
>         setns(fd, 0);
>         system("su -");
> }
>
> Prevent this possibility by requiring CAP_SYS_ADMIN
> in the current user namespace when joing all but the user namespace.
>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/namespace.c           |    3 ++-
>  ipc/namespace.c          |    3 ++-
>  kernel/pid_namespace.c   |    3 ++-
>  kernel/utsname.c         |    3 ++-
>  net/core/net_namespace.c |    3 ++-
>  5 files changed, 10 insertions(+), 5 deletions(-)

Acked-by: Andy Lutomirski <luto@amacapital.net>
