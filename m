Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2FWSER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 14:04:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46560 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2FWSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 14:04:16 -0400
MIME-Version: 1.0
In-Reply-To: <4FE4AD09020000780008B77F@nat28.tlf.novell.com>
References: <4FE4AD09020000780008B77F@nat28.tlf.novell.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sat, 23 Jun 2012 20:03:55 +0200
Message-ID: <CAPXgP13nd7k3v3YGcW9F45L8LhT5tctw64jaooUwQ8=ypfVH+g@mail.gmail.com>
Subject: Re: [PATCH] syslog: fill buffer with more than a single message for SYSLOG_ACTION_READ
To: Jan Beulich <JBeulich@suse.com>
Cc: gregkh@linuxfoundation.org, yuanhan.liu@linux.intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 5:36 PM, Jan Beulich <JBeulich@suse.com> wrote:
> The recent changes to the printk buffer management resulted in
> SYSLOG_ACTION_READ to only return a single message, whereas previously
> the buffer would get filled as much as possible. As, when too small to
> fit everything, filling it to the last byte would be pretty ugly with
> the new code, the patch arranges for as many messages as possible to
> get returned in a single invocation. User space tools in at least all
> SLES versions depend on the old behavior.

What a weird assumption for using that interface. It does a simple
one-time read and assumes it will never block in that? If something
would clear the log, or it would not contain a message, that read will
block and the tool would just hang? :)

But sure, sounds needed to restore the old behaviour if such weird
users exist, and the patch looks fine from looking over it.

> This at once addresses the issue attempted to get fixed with commit
> b56a39ac263e5b8cafedd551a49c2105e68b98c2 ("printk: return -EINVAL if
> the message len is bigger than the buf size"), and since that commit
> widened the possibility for losing a message altogether, the patch
> here assumes that this other commit would get reverted first
> (otherwise the patch here won't apply).
>
> Furthermore, this patch also addresses the problem dealt with in
> commit 4a77a5a06ec66ed05199b301e7c25f42f979afdc ("printk: use mutex
> lock to stop syslog_seq from going wild"), so I'd recommend reverting
> that one too (albeit there's no direct collision between the two).

Are you sure that is covered? Doesn't the other thread would just
return 0 to the caller then, instead of continuing to stay in the
syscall when the first thread got the message?

Kay
