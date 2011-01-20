Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1ATXn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:43:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755883Ab1ATXn5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTin6GM5W0nmWgD1a-2FK=CvHk=P3o6CYe-sFe6c=@mail.gmail.com>
References: <20110119.180418.216749267.davem@davemloft.net>
 <AANLkTin32jUnBtHF-EAkSMnFQM6cTbn-G3NZQJ3xjTWU@mail.gmail.com>
 <1295559646.2613.35.camel@edumazet-laptop> <AANLkTikLY1B3=C2TjAbYKVHbub-aPeG2heaUBWRUAg=R@mail.gmail.com>
 <AANLkTin6GM5W0nmWgD1a-2FK=CvHk=P3o6CYe-sFe6c=@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Jan 2011 15:43:00 -0800
Message-ID: <AANLkTin-RBwg+J4MqOm7A40-TFAJ1sp4e6tzi6OaobNi@mail.gmail.com>
Subject: Re: [GIT] Networking
To: Colin Walters <walters@verbum.org>,
        Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 2:38 PM, Colin Walters <walters@verbum.org> wrote:
>
> It is actually; see src/gs-auth-pam.c; there is some pretty scary code
> there; basically all of PAM is put in a thread to avoid blocking the
> mainloop.  Whether the code is actually buggy I can't say immediately;
> it's certainly possible.

I stand corrected.

But it turns out to be a kernel bug after all, although not in
networking. It bisected down to commit e462c448fdc8: "pipe: use event
aware wakeups".

I don't immediately see why, but I suspect it's the pipe_release()
case that needs to add POLLHUP to the wakeup cases. I suspect that
what is going on is that gnome-screensaver-dialog uses a pipe to talk
to the PAM code, and waits for the pipe to close. And we used to wake
it up unconditionally, but now we only wake up the poll waiter if it's
waiting for POLLIN/POLLOUT, rather than for anything else.

Anyway, I'll double-check my bisect by doing a revert of that commit
on top of current -git, but I'm pretty sure the bisect was correct,
since it did end up pointing to a commit that clearly changed poll
behavior.

                              Linus
