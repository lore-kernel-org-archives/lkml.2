Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0KUXCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 18:02:33 -0500
Received: from smtp-out.google.com ([74.125.121.35]:36344 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab0KUXCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 18:02:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Lqq9Lo+JdcmO+yRLjfe/YKSes408LvUTYovZOh5Ya9DmDiZsFBfQPi5XrXJ1mipMUb
         w2Xh6+BiVgPHbEa5SDcQ==
MIME-Version: 1.0
In-Reply-To: <1290304824-22722-1-git-send-email-ccross@android.com>
References: <1290304824-22722-1-git-send-email-ccross@android.com>
Date: Sun, 21 Nov 2010 15:02:28 -0800
X-Google-Sender-Auth: wRs2yIzqSnMspfJQDcblxSOagmw
Message-ID: <AANLkTikx6d0_VFtZ4zWQucRCf=vFt7N2M6=0jpnKasEE@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Remove RCU from task->cgroups
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 6:00 PM, Colin Cross <ccross@android.com> wrote:
> The synchronize_rcu call in cgroup_attach_task can be very
> expensive.  All fastpath accesses to task->cgroups already
> use task_lock() or cgroup_lock() to protect against updates,
> and only the CGROUP_DEBUG files have RCU read-side critical
> sections.
>
> This patch replaces rcu_read_lock() with task_lock(current)
> around the debug file acceses to current->cgroups and removes
> the synchronize_rcu call in cgroup_attach_task.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  kernel/cgroup.c |   22 ++++++++--------------
>  1 files changed, 8 insertions(+), 14 deletions(-)
>

This patch isn't correct, there's an rcu_dereference I missed inside
task_group(), and that's the important one.
