Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab2BABtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:49:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2BABtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:49:09 -0500
Date: Tue, 31 Jan 2012 17:49:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
Message-Id: <20120131174914.8ce5291d.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de>
	<20120124135443.2772d455.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr>
	<20120131172334.7f26f164.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1202010224510.29848@frira.zrqbmnf.qr>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 02:35:06 +0100 (CET) Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Wednesday 2012-02-01 02:23, Andrew Morton wrote:
> >>
> >> If there is a piece of kernel code that
> >> assumes/requests that userspace use a 16-byte buffer (such as
> >> cn_proc as mentioned), then it should use a file-level define or
> >> something with a comment above it that this is a fixed user value.
> >> 
> >> I would therefore say that changing TASK_COMM_LEN is possible without 
> >> breaking any userprogram.
> >> 
> >> (In other words, TASK_COMM_LEN can just remain what it is, and 
> >> comm[TASK_COMM_LEN] in struct task_struct could be changed to 
> >> e.g. comm[32]. Using sizeof(x.comm) also seems more proof in general.)
> >
> >Well yes, we could increase the size and provide new and better APIs
> >for accessing it, while teaching the old APIs to truncate.  That might
> >cause some problems for old-API-using userspace during the transition
> >period, but I doubt if they would be large problems.
> 
> Did my patch not change the existing code sites using ->comm
> to always copy at most min(userbufsize aka 16, sizeof(t->comm)) bytes,
> thereby keeping the promise to userspace while at the same time
> making TASK_COMM_LEN's value freely choosable?

That change is pretty pointless as long as we don't provide APIs to let
userspace access the expanded size.  And I've explained why we cannot
alter the existing APIs.

So until and unless we decide to add the new APIs I think that the
cleanup parts of the patch are good, but the parts which increase the
kernel text footprint are not.

