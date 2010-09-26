Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0IZW2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 18:28:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34194 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab0IZW23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 18:28:29 -0400
Date: Sun, 26 Sep 2010 23:28:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 2/2] alpha: Make sys_getxpid() call do_getppid()
Message-ID: <20100926222828.GA19804@ZenIV.linux.org.uk>
References: <1285513774.2697.255.camel@localhost>
 <1285513991.2697.262.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285513991.2697.262.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 04:13:11PM +0100, Ben Hutchings wrote:
> sys_getxpid() was not following RCU protocol or considering namespace
> visibility for the parent pid.  Change it to call do_geptpid() which
> does the right thing.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> This is totally untested, and I've never written Alpha assembly before,
> so this definitely needs review and testing by an Alpha porter.
> 
> I've left the shortcut tgid lookup there as I assume it is still valid.

I think I have a better variant, getting rid of asm magic completely.
Basically, in ptrace.h have
#define current_pt_regs() \
        ((struct pt_regs *)(current_thread_info() + 2*PAGE_SIZE) - 1)

(and turn force_successful_syscall_return() into (current_pt_regs()->r0 = 0),
while we are at it) and do what I'm doing for e.g. getxgid and alpha_pipe:
SYSCALL_DEFINE0(getxgid)
{
        struct cred *cred = current->cred;
        current_pt_regs()->r20 = cred->egid;
        return cred->gid;
}

SYSCALL_DEFINE0(alpha_pipe)
{
        int fd[2];
        int res = do_pipe_flags(&fd, 0);
        if (!res) {
                /* The return values are in $0 and $20.  */
                current_pt_regs()->r20 = fd[1];
                res = fd[0];
        }
        return res;
}

I planned to hold it back until the merge window, since it's not a bugfix,
but with that one... what the hell, might as well do it.  Less asm glue
is a Good Thing(tm).

One problem with your patch, though:

; git grep do_getppid
;

IOW, which tree is that against?
