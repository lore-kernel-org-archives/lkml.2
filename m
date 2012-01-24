Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab2AXVyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:54:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2AXVyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:54:44 -0500
Date: Tue, 24 Jan 2012 13:54:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: fix memory corruptions when TASK_COMM_LEN
 != 16
Message-Id: <20120124135443.2772d455.akpm@linux-foundation.org>
In-Reply-To: <1327183785-27023-1-git-send-email-jengelh@medozas.de>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jan 2012 23:09:44 +0100
Jan Engelhardt <jengelh@medozas.de> wrote:

> I found that the kernel BUG()s out, already during boot, when bumping
> TASK_COMM_LEN to a value larger than 16

We can never increase TASK_COMM_LEN - it is part of the kernel ABI/API.
Doing so would destroy existing userspace which uses 16-byte buffers.

> (and I can imagine the same
> problem unfolding as well if it is set to something smaller).

hm, that's a surprise.  Decreasing TASK_COMM_LEN is at least slightly
possible but it's hard to see why we should do so.

> Various places do insufficient length checks, simply assume certain
> sizes or hardcode things. Even though e.g. get_task_comm clearly
> documents that its buffer ought to be TASK_COMM_LEN long, I do believe
> that an extra size parameter, such as added in this patch, is a lot
> more robust than relying on callers getting the buffer size right.
> 
> With this patch, I no longer experience crashes, but that is not to
> say that there are not any further places (e.g. in modules I never
> use) with flakey ->comm handling.

You do seem to have found a few warts around the task->comm handling. 
But I don't believe that addressing them justifies adding new code
(adding another argument to get_task_comm).

If you're interested in working on this stuff I'd suggest that we
confine ourselves to cleaning things up (without adding code) rather
than permitting a different TASK_COMM_LEN.  Things like replacing "16"
with TASK_COMM_LEN.
