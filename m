Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2A3TvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:51:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55765 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2A3TvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:51:10 -0500
Date: Mon, 30 Jan 2012 23:51:06 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
Message-ID: <20120130195105.GA1689@oksana.dev.rtsoft.ru>
References: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
 <m1boplkgzk.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m1boplkgzk.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 07:26:55PM -0800, Eric W. Biederman wrote:
> Anton Vorontsov <anton.vorontsov@linaro.org> writes:
> 
> > We'd like to use this function in the android low memory killer driver, so
> > let's export it.
> >
> > Also, move next_tgid() to kernel/pid.c, so now it lives with the rest of
> > pid library functions and does not depend on procfs. Plus, we may now hide
> > find_ge_pid() from the global namespace.
> >
> > While at it, also turn next_tgid()'s comments into kerneldoc format.
> >
> > There should be no functional changes.
> 
> Ouch no.
> 
> There is find_ge_pid that is general purpose, and there are a lot of
> things with the task list.  But this iterator is specific to the
> implementation of proc especially in how it grabs and drops locks.

Exactly, the way procfs grabs and drops locks is very attractive for
us to reuse in lowmemorykiller driver. :-) Proc is efficient in a
way that it does not need to hold the tacklist lock (otherwise, I guess,
it could be prone to attacks, e.g. by constantly readdiring /proc/ ?).

> Using this code outside of /proc will make /proc harder to maintain than
> it already is.
> 
> Why in the world would you want to traverse processes by pids when
> there are well defined iterators for looping over tasks already.

We just did not want to hold the global tasklist lock, if we could
avoid it. Low memory killer is a low priority stuff, and grabbing
tasklist lock seemed inefficient.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
