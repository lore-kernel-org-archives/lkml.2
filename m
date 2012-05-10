Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2EJRFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:05:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63144 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2EJRFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:05:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120510165538.GA20931@redhat.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
 <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
 <1336519085-27450-2-git-send-email-suresh.b.siddha@intel.com>
 <20120509210551.GB334@redhat.com> <1336599123.4634.42.camel@sbsiddha-desk.sc.intel.com>
 <20120510165538.GA20931@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 May 2012 10:04:56 -0700
X-Google-Sender-Auth: 54mGBuC-TVwZoMbeBO7_u6UvccA
Message-ID: <CA+55aFwNST_Lhou1h9JWkg348BET7CbqNX50XYPOFNbXioXdxg@mail.gmail.com>
Subject: Re: [PATCH 1/3] coredump: flush the fpu exit state for proper
 multi-threaded core dump
To: Oleg Nesterov <oleg@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 9:55 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> My point was, there is no any guarantee prepare_to_copy() does the flush.
> An architecture can do this in copy_thread() or arch_dup_task_struct(),
> for example. In fact I do not understand why x86 doesn't do this.

I agree that it would actually make more sense to do in
arch_dup_task_struct(). I had trouble finding where the heck the
fork() code did the FPU fixes back when I was fighting the FPU
corruption thing.

The prepare_to_copy() thing is, I think, purely historical, and I
think we should in fact get rid of it. Everybody else makes it a
no-op, I think, with a *few* exceptions that seem to have copied the
x86 model of flushing the FPU there.

So if somebody sends me a patch to remove that thing, and move the few
existing users to arch_dup_task_struct(), I'd take it.

I think it would be a mistake to use it in the exit path. Make an
explicit "drop_thread_state()" or similar macro, which can undo FPU
state and possibly other architecture state.

                       Linus
