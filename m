Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab0ETTn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 15:43:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429Ab0ETTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 15:43:23 -0400
Date: Thu, 20 May 2010 12:42:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Tridgell <tridge@samba.org>, David Howells <dhowells@redhat.com>,
       Eric Paris <eparis@parisplace.org>, Jakub Jelinek <jakub@redhat.com>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: check_kill_permission: don't check creds if
 same_thread_group()
Message-Id: <20100520124214.2ac81a21.akpm@linux-foundation.org>
In-Reply-To: <20100517195414.GA21504@redhat.com>
References: <20100517195414.GA21504@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 21:54:14 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Andrew Tridgell reports that aio_read(SIGEV_SIGNAL) can fail if the
> the notification from the helper thread races with setresuid(), see
> http://samba.org/~tridge/junkcode/aio_uid.c
> 
> This happens because check_kill_permission() doesn't allow to send
> a signal to the task with the different cred->xids. But there is no
> any security reason to check ->cred's when the task sends a signal
> (private or group-wide) to its sub-thread. Whatever we do, any thread
> can bypass all security checks and send SIGKILL to all threads, or
> it can block a signal SIG and do kill(gettid(), SIG) to deliver this
> signal to another sub-thread. Not to mention that CLONE_THREAD implies
> CLONE_VM.
> 
> Change check_kill_permission() to avoid the credentials check when
> the sender and the target are from the same thread group.
> 
> Also, move "cred = current_cred()" down to avoid calling get_current()
> twice.
> 
> Note: David Howells pointed out we could relax this even more, the
> CLONE_SIGHAND (without CLONE_THREAD) case probably does not need
> these checks too.

So... which kernel(s) do we think this fix should be merged into?
