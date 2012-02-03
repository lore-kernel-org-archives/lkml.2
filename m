Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab2BCSeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:34:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53367 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab2BCSeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:34:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAHGf_=qA6EFue2-mNUg9udWV4xSx86XQsnyGV07hfZOUx6_egw@mail.gmail.com>
References: <20120116163106.GC7180@jl-vm1.vm.bytemark.co.uk>
	<1326776095-2629-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<CAAHN_R2g9zaujw30+zLf91AGDHNqE6HDc8Z4yJbrzgJcJYFkXg@mail.gmail.com>
	<4F2B02BC.8010308@gmail.com>
	<CAAHN_R0O7a+RX7BDfas3+vC+mnQpp0h3y4bBa1u4T-Jt=S9J_w@mail.gmail.com>
	<CAHGf_=qA6EFue2-mNUg9udWV4xSx86XQsnyGV07hfZOUx6_egw@mail.gmail.com>
Date: Sat, 4 Feb 2012 00:04:11 +0530
Message-ID: <CAAHN_R0+ExGcdpLM7KwC_KsPOemVOiRrmyWcowiu5_cWW3BPLQ@mail.gmail.com>
Subject: Re: [RESEND][PATCH] Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 1:31 PM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> The fact is, now process stack and pthread stack clearly behave
> different dance. libc don't expect pthread stack grow automatically.
> So, your patch will break userland. Just only change display thing.

The change should not make thread stacks (as implemented by glibc)
grow automatically in the general case since it has to implement guard
page(s) at the beginning of the mapped memory for stack using
mprotect(top, size, PROT_NONE). Due to this, the program will crash
before it ever has a chance to cause a page fault to make the stack
grow. This is of course assuming that the program doesn't purposely
jump over the guard page(s) by setting %sp beyond them and then
causing a page fault. So the only case in which a thread stack will
grow automatically is if the stackguard is set to 0:

http://pubs.opengroup.org/onlinepubs/007904975/functions/pthread_attr_setguardsize.html

I have also dropped an email on the libc-alpha list here to solicit
comments from libc maintainers on this:

http://sourceware.org/ml/libc-alpha/2012-02/msg00036.html


-- 
Siddhesh Poyarekar
http://siddhesh.in
