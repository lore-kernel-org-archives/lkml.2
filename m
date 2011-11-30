Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1K3UlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:41:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42138 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1K3UlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:41:06 -0500
MIME-Version: 1.0
In-Reply-To: <20111130065000.GT2203@ZenIV.linux.org.uk>
References: <20111130065000.GT2203@ZenIV.linux.org.uk>
Date: Wed, 30 Nov 2011 15:41:04 -0500
X-Google-Sender-Auth: BJ1dY4QuNss70GJAt0t5L39PAyA
Message-ID: <CAP=VYLozbbfO=90GxuGe9k_V6OghwFdR3uVE-=dpX5be4qPhgw@mail.gmail.com>
Subject: Re: [RFC][PATCH] trimming includes from linux/security.h
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 1:50 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        linux/security.h pulls a lot of garbage; most of it can be avoided
> by several more struct ....; added in there, the rest is a matter of adding
> explicit includes in places that (weirdly) relied on security.h to pull
> what they wanted.  Plus taking round_hit_to_min() to the only place using
> it (mm/mmap.c)...
>
>        NOTE: it almost certainly won't build on some configs; it *does*
> survive allmodconfig on amd64, but that's all it had been tested on.  Help
> with review and (build-)testing would be very appreciated...  Fortunately,
> all breakage will show up on build, which makes finding it less painful.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Hi Al,

I did some testing on this for powerpc and arm.  The one snag I came
across was that security.h uses things like current->mm and fields in
task_struct, so you get fallout like I've pasted below.  But to put
sched.h (and all its 300 sub-includes) back into security.h kind of
defeats the purpose of what you were trying to do, I think.

A proper fix would be to somehow really make security.h  a real
standalone header, via using defines instead of inlines or similar?

For now, I just added sched.h to the files that were breaking, but
it seems wrong to penalize random C files for the breakage in the
security.h header file.

This tree seems to survive most powerpc and arm defconfigs:

http://git.kernel.org/?p=linux/kernel/git/paulg/linux.git;a=shortlog;h=refs/heads/al-security-Nov30

but as I said above, I'm not really liking the last commit on it
that adds sched.h to 20-odd files.

Paul.
---

In file included from /home/paul/git/linux-head/fs/super.c:28:
/home/paul/git/linux-head/include/linux/security.h: In function
'security_real_capable':
/home/paul/git/linux-head/include/linux/security.h:1890: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1890: warning: type
defaults to 'int' in declaration of '_________p1'
/home/paul/git/linux-head/include/linux/security.h:1890: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1890: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1890: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1890: warning: type
defaults to 'int' in declaration of 'type name'
/home/paul/git/linux-head/include/linux/security.h:1890: warning: type
defaults to 'int' in declaration of 'type name'
/home/paul/git/linux-head/include/linux/security.h:1890: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1890: warning: type
defaults to 'int' in declaration of 'type name'
/home/paul/git/linux-head/include/linux/security.h:1890: warning:
passing argument 2 of 'cap_capable' from incompatible pointer type
/home/paul/git/linux-head/include/linux/security.h:71: note: expected
'const struct cred *' but argument is of type 'int *'
/home/paul/git/linux-head/include/linux/security.h: In function
'security_real_capable_noaudit':
/home/paul/git/linux-head/include/linux/security.h:1901: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1901: warning: type
defaults to 'int' in declaration of '_________p1'
/home/paul/git/linux-head/include/linux/security.h:1901: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1901: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1901: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1901: warning: type
defaults to 'int' in declaration of 'type name'
/home/paul/git/linux-head/include/linux/security.h:1901: warning: type
defaults to 'int' in declaration of 'type name'
/home/paul/git/linux-head/include/linux/security.h:1901: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1901: warning: type
defaults to 'int' in declaration of 'type name'
/home/paul/git/linux-head/include/linux/security.h:1902: warning:
passing argument 2 of 'cap_capable' from incompatible pointer type
/home/paul/git/linux-head/include/linux/security.h:71: note: expected
'const struct cred *' but argument is of type 'int *'
/home/paul/git/linux-head/include/linux/security.h: In function
'security_vm_enough_memory':
/home/paul/git/linux-head/include/linux/security.h:1931: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h:1932: error:
dereferencing pointer to incomplete type
/home/paul/git/linux-head/include/linux/security.h: In function
'security_vm_enough_memory_kern':
/home/paul/git/linux-head/include/linux/security.h:1945: error:
dereferencing pointer to incomplete type
make[3]: *** [fs/super.o] Error 1
