Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1JVQtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 12:49:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33773 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab1JVQtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 12:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <20111014171033.GC4294@google.com>
References: <20111014110416.552685686@openvz.org>
	<20111014110511.670174429@openvz.org>
	<20111014171033.GC4294@google.com>
Date: Sat, 22 Oct 2011 12:49:01 -0400
Message-ID: <CAPL5yKd++xy6xh1sKUnGO+6UZqXGSgRHsk9-k_OfGmVSgS7o7g@mail.gmail.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
From: Dan Merillat <dan.merillat@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Andrew Vagin <avagin@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 1:10 PM, Tejun Heo <tj@kernel.org> wrote:
> I don't think this is a good idea.  We already have most of interface
> necessary for restoring task state and there's no need to put it into
> the kernel as one piece.  If there's something which can't be done
> from userland using existing interfaces, let's please discuss what
> they are and whether they can be resolved differently first.

I may be missing something, but programs do care about their and their
children's PIDs, and even with a kernel interface to pick a specific
PID for a new process (yikes!) it wouldn't work if the original PID
was in use by another process.

Open file handles that point to files that have been changed/deleted
while the process was frozen, unlinked scratch files that are gone for
good when the original process dies, shared memory, processes at the
other end of pipes, etc.  Graphical programs get even worse, with
trying to reproduce the X11 state or GPU state.   Network isn't as
bad, as it's expected that it could be dropped at any time so most
programs can handle it.

If the userspace to be checkpointed can cope with all that, it can
handle moving the vdso mapping.   Since it has to have specific logic
to handle all the different types of , why not just have it dump
internal state on a signal and rerun with that file as an argument?
The target process that can deal with being externally frozen would
seem to be basically a tech demo.
