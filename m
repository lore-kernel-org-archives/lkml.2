Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1KQUse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:48:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab1KQUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:48:33 -0500
Date: Thu, 17 Nov 2011 12:48:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
Message-Id: <20111117124831.688adbeb.akpm@linux-foundation.org>
In-Reply-To: <4EC4DA15.7090106@parallels.com>
References: <4EC4DA15.7090106@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 13:55:33 +0400
Pavel Emelyanov <xemul@parallels.com> wrote:

> While doing the checkpoint-restore in the userspace one need to determine
> whether various kernel objects (like mm_struct-s of file_struct-s) are shared
> between tasks and restore this state.
> 
> The 2nd step can for now be solved by using respective CLONE_XXX flags and
> the unshare syscall, while there's currently no ways for solving the 1st one.
> 
> One of the ways for checking whether two tasks share e.g. an mm_struct is to
> provide some mm_struct ID of a task to its proc file. The best from the
> performance point of view ID is the object address in the kernel, but showing
> them to the userspace is not good for security reasons.
> 
> Thus the object address is XOR-ed with a "random" value of the same size and 
> then shown in proc. Providing this poison is not leaked into the userspace then
> ID seem to be safe. The objects for which the IDs are shown are:
> 
> * all namespaces living in /proc/pid/ns/
> * open files (shown in /proc/pid/fdinfo/)
> * objects, that can be shared with CLONE_XXX flags (except for namespaces)
> 
> Changes since
> v1: * Tejun worried about the single poison value was a weak side - leaking one
>       makes all the IDs vulnerable. To address this several poison values - one
>       per object type - are introduced. They are stored in a plain array. Tejun, 
>       is this enough from your POV, or you'd like to see them widely scattered 
>       over the memory?
>     * Pekka proposed to initialized poison values in the late_initcall callback
>     * ... and move the code to mm/util.c
> 
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

It doesn't *sound* terribly secure.  There might be clever ways in
which userspace can determine the secret mask, dunno.  We should ask
evil-minded security people to review this proposal.

Why not simply use a sequence number, increment it each time we create
an mm_struct?  On could use an idr tree to prevent duplicates but it
would be simpler and sufficient to make it 64-bit and we never have to
worry about wraparound causing duplicates.
