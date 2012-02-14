Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab2BNSbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:31:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922Ab2BNSbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:31:13 -0500
Date: Tue, 14 Feb 2012 19:24:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-am33-list@redhat.com
Subject: Re: [PATCH 20/40] mn10300: Use set_current_blocked() and
	block_sigmask()
Message-ID: <20120214182427.GA25119@redhat.com>
References: <20120214172340.GA22645@redhat.com> <1329219673-28711-21-git-send-email-matt@console-pimps.org> <1329219673-28711-1-git-send-email-matt@console-pimps.org> <17603.1329234976@redhat.com> <27258.1329243179@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27258.1329243179@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > No, only current can change ->blocked. This is even documented in
> > sigprocmask(). And more, the only correct way to change ->blocked
> > is set_current_blocked(). OK, with a couple of "I know what I am
> > doing" exceptions in kernel/signal.c.
>
> I was looking at force_sig_info() and derivatives.  Is that what you refer to?

Ah, sorry, forgot to mention...

force_sig_info() (and its callers) need the cleanups and fixes. It
is almost always wrong if t != current.

For example, please look at

	[PATCH 1/4] signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE
	http://marc.info/?l=linux-kernel&m=132890442717122

Hopefully we can fix all ab-users soon.



Just in case... if we race with force_sig_info() the task will be
killed anyway. But I agree, this is not nice and should be fixed.
And in any case, there are other places which assume it is safe
to read current->blocked lockless.

> If so, is it worth providing a force_sig_info_current(),
> force_sigsegv_current() and force_sig_current() to make things clearer to grep
> for, I wonder?

Yes, I think the "task_struct *t" argument should die.

Oleg.

