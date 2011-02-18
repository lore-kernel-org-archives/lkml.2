Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab1BRBAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:00:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1BRBAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:00:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hRRwBNP5VKFi58A3cAR8EBMGT8Xc/TTnxb6hbwvvmNW0wc0VJUMpcOhb2oPWjtfVuy
         NWfoyygYYVdQiqO4XSaw==
MIME-Version: 1.0
In-Reply-To: <20110217133152.4043.94951.stgit@rabbit.intern.cm-ag>
References: <20110217133152.4043.94951.stgit@rabbit.intern.cm-ag>
From: Paul Menage <menage@google.com>
Date: Thu, 17 Feb 2011 16:59:51 -0800
Message-ID: <AANLkTi=X7rHEy9yOngogs_OQ69FJeZeQRSwvFdgnbWxo@mail.gmail.com>
Subject: Re: [PATCH] new cgroup controller "fork"
To: Max Kellermann <mk@cm4all.com>
Cc: lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 5:31 AM, Max Kellermann <mk@cm4all.com> wrote:
> Can limit the number of fork()/clone() calls in a cgroup.  It is
> useful as a safeguard against fork bombs.

I'd be inclined to simplify this a bit - avoid impacting the fork()
path twice, with cgroup_fork_pre_fork() and cgroup_fork_fork() and
just do the checks and decrements in a single pass. (In the event of
hitting a limit, you may need to make another partial pass up the tree
to restore the charged fork attempts)

Yes, it's true that you might charge for a fork() that later failed
for some other reason, but this will very rare (except on a machine
that's already screwed for other reasons) so that I don't think anyone
would complain about it. Especially if you explicitly document
"fork.remaining" as number of permitted "fork attempts".

Also, it would be slightly clearer to use fork_cgroup_* rather than
cgroup_fork_* - this makes it clearer that it's part of a cgroups
subsystem called "fork", rather than part of the cgroups core
framework.

I don't think that you need to make your spinlock IRQ-safe - AFAICS
nothing accesses it from the interrupt path.

Paul
