Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab0EROL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:11:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368Ab0EROLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:11:25 -0400
Date: Tue, 18 May 2010 16:08:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrew Tridgell <tridge@samba.org>, Eric Paris <eparis@parisplace.org>,
       Jakub Jelinek <jakub@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: check_kill_permission: don't check creds if
	same_thread_group()
Message-ID: <20100518140840.GA4096@redhat.com>
References: <20100518133925.GA1353@redhat.com> <20100517195414.GA21504@redhat.com> <2996.1274172907@redhat.com> <25639.1274190647@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25639.1274190647@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Yes, but both current_cred() and same_thread_group(current, t) call
> > get_current(), and gcc doesn't cache the result because we call
> > audit_signal_info() in between.
>
> Sorry, yes.  I was reading get_current() as current_cred() for some reason.
>
> However, you are _still_ calling get_current() twice...  So that bit of your
> changelog isn't really correct.

If I read kernel/signal.s correctly - no.

Well, yes, get_current() is still called twice inside check_kill_permission().
But this is because we have audit_signal_info()->audit_dummy_context() which
uses current too.

But "cred = current_cred()" and same_thread_group(current, t) read
gs:current_task only once, so this change really helps (although the
optimization is very minor, of course).

> In fact, get_current() should be __attribute_const__ since it can't change
> whilst you're looking at it, except within switch_to(), probably in a piece of
> assembly code, so gcc should be free to cache it as long as it likes.

Agreed! I thought about this many times.

Oleg.

