Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2BXUXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:23:30 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48547 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab2BXUX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:23:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.24.202 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120224190651.GA22287@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com>
 <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com>
 <20120224190651.GA22287@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Feb 2012 12:23:08 -0800
X-Google-Sender-Auth: fhdByiYx-Fxq7CX99dC1g82YYKA
Message-ID: <CA+55aFz6EoiKjzisFmU0j4aezXsPinDyfv3DdKeeKQibkaO6DQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] signalfd/epoll fixes
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 11:06 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> OK. Please see v2.

Ok, I applied these.

And then, dammit, I unapplied them again.

And then I applied them again.

I'm *really* conflicted, because I have this really strong feeling
that it's just papering over a symptom, and we damn well shouldn't be
doing that. I really think that what we really should do is allow
"poll()" to have a "poll_remove" callback (so each "add_poll_wait()"
will have a callback when it gets remove).

Then we could make the poll() functions actually do allocations and
crap - or at least add refcounts - and the "poll_remove()" ones would
undo them.

And then we could rip out all this, and make signalfd just do

  static void poll_remove(struct file *file, struct wait_queue *wq)
  {
    struct sighand *sighand = container_of(wq, struct sighand, signalfd_wqh);
    __cleanup_sighand(sighand);
  }

and add that "poll_remove" to its file handler operations. And in
"poll()", it would just do

   atomic_inc(&sighand->count);

as it does the poll_wait() thing. Sure, we need to have some way to
test "did we really add it", and only increment the count if so (so
poll_wait() would need to return a value), but this seems to be the
*real* fix. Because the real problem is that we cannot currently
refcount the poll users.

Ok, so it's just a strong feeling, and I *did* end up applying these
two patches after all, but I really wonder how hard it would be to
just add a single new callback function and be able to refcount that
sighand structure itself.

                           Linus
