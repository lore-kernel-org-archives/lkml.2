Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2CTGIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 02:08:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53400 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2CTGIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 02:08:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120318192755.GB6589@ZenIV.linux.org.uk>
References: <20120313005855.GA24639@redhat.com> <CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
 <20120318192755.GB6589@ZenIV.linux.org.uk>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 20 Mar 2012 03:08:08 -0300
Message-ID: <CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
Subject: Re: [3.3-rc7] sys_poll use after free (hibernate)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 4:27 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Mar 18, 2012 at 12:02:04PM -0700, Linus Torvalds wrote:
>> and that load is from
>>
>>     poll_wait(filp, &table->poll->wait, wait);
>>
>> where the testing of %rsi and %rcx are the "if (p && wait_address)"
>> check in poll_wait(), and %rsi is "table->poll" if I read it all
>> correctly.
>>
>> And the 6b6b6b6b6b6b6b6b pattern is obviously POISON_FREE, so
>> apparently 'table' has already been freed.
>>
>> I suspect the whole sysctl 'poll' code is seriously broken, since it
>> seems to depend on those ctl_table pointers being stable over the
>> whole open/close sequence, but if somebody unregisters the sysctl,
>> it's all gone. The ctl_table doesn't have any refcounting etc, and I
>> suspect that your hibernate sequence ends up unregistering some sysctl
>> (perhaps as part of a module unload?)

How could that happen if the only files that support poll  right now
on sysctl are kernel/hostname and kernel/domainname?

>
> Ewww...  The way it was supposed to work (prio to ->poll() madness) was
> that actual IO gets wrapped into grab_header()/sysctl_head_finish()
> pair.  proc_sys_poll() doesn't do it, so yes, that post-mortem is
> very likely to be correct.

Yes, it  seems like I forgot to call grab_header() there, sorry for
that. I'll prepare a patch and send you later today. I just wonder
what is happening to reach that code... :-/


Lucas De Marchi
