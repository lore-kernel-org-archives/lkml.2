Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab2BADBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:01:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2BADBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:01:03 -0500
Date: Tue, 31 Jan 2012 19:01:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
Message-Id: <20120131190109.b53347fd.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.01.1202010257240.29848@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de>
	<20120124135443.2772d455.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr>
	<20120131172334.7f26f164.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
	<20120131174914.8ce5291d.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1202010257240.29848@frira.zrqbmnf.qr>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 03:15:50 +0100 (CET) Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Wednesday 2012-02-01 02:49, Andrew Morton wrote:
> >> 
> >> Did my patch not change the existing code sites using ->comm
> >> to always copy at most min(userbufsize aka 16, sizeof(t->comm)) bytes,
> >> thereby keeping the promise to userspace while at the same time
> >> making TASK_COMM_LEN's value freely choosable?
> >
> >That change is pretty pointless as long as we don't provide APIs to let
> >userspace access the expanded size.  And I've explained why we cannot
> >alter the existing APIs.
> 
> Ah yes, indeed. My reason for augmenting the size of t->comm was so
> that `ps afx` could show a more complete name of certain kernel
> threads' names. In this case, the kernel delivers the name via
> procfs via seq_printf("%s, t->comm),

Where does procfs do this?

> as do a few debug statements
> in the fashion of pr_debug("%s/%u ate my CPU", t->comm, t->pid).
> So maybe it was not /completely/ pointless.

I agree that the 16-char thing is irritatingly small.  But if we were
to increase it and to then utilise that increase, those userspace apps
which are still using the legacy prctl(PR_GET_NAME) would produce
pretty bad output.  Instead of "migration/0" and "migration/1" you'd
get "migration_threa" and "migration_threa".  And "flush-8:32" would
maddeningly become "flusher_thread-".

I suppose that would help motivate people to update their tools ;)
