Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab2BABXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:23:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2BABX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:23:29 -0500
Date: Tue, 31 Jan 2012 17:23:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
Message-Id: <20120131172334.7f26f164.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de>
	<20120124135443.2772d455.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1201250121260.20692@frira.zrqbmnf.qr>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 02:15:10 +0100 (CET) Jan Engelhardt <jengelh@medozas.de> wrote:

> On Tuesday 2012-01-24 22:54, Andrew Morton wrote:
> 
> >On Sat, 21 Jan 2012 23:09:44 +0100
> >Jan Engelhardt <jengelh@medozas.de> wrote:
> >
> >> I found that the kernel BUG()s out, already during boot, when bumping
> >> TASK_COMM_LEN to a value larger than 16
> >
> >We can never increase TASK_COMM_LEN - it is part of the kernel ABI/API.
> >Doing so would destroy existing userspace which uses 16-byte buffers.
> 
> I do not see TASK_COMM_LEN being exposed to userspace. In fact, it is 
> behind a #ifdef __KERNEL__.

Userspace uses "16".  Because it knows that what's the kernel uses. 
It's part of the ABI.

> There is nothing wrong with userspace using a buffer with a size 
> different from the object's size within the kernel. It's done all the 
> time, in fact. readlink(2) for example also has a size argument rather 
> than declaring to all parties they have to use PATH_MAX everytime.

prctl(PR_GET_NAME) unconditionally copies out 16 bytes.

> >If you're interested in working on this stuff I'd suggest that we
> >confine ourselves to cleaning things up (without adding code) rather
> >than permitting a different TASK_COMM_LEN.  Things like replacing "16"
> >with TASK_COMM_LEN.
> 
> There is what I would call the "Plate of Tunable Macros". #defines
> that invite the reader to change them (think PID_MAX_DEFAULT).
> 
> If there is a piece of kernel code that
> assumes/requests that userspace use a 16-byte buffer (such as
> cn_proc as mentioned), then it should use a file-level define or
> something with a comment above it that this is a fixed user value.
> 
> I would therefore say that changing TASK_COMM_LEN is possible without 
> breaking any userprogram.
> 
> (In other words, TASK_COMM_LEN can just remain what it is, and 
> comm[TASK_COMM_LEN] in struct task_struct could be changed to 
> e.g. comm[32]. Using sizeof(x.comm) also seems more proof in general.)

Well yes, we could increase the size and provide new and better APIs
for accessing it, while teaching the old APIs to truncate.  That might
cause some problems for old-API-using userspace during the transition
period, but I doubt if they would be large problems.
