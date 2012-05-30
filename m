Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab2E3Wvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 18:51:52 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43878 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab2E3Wvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 18:51:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120530213638.GZ11775@ZenIV.linux.org.uk>
References: <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <20120516021828.GP22082@ZenIV.linux.org.uk> <1337807899.15138.31.camel@falcor>
 <20120530043443.GA3200@ZenIV.linux.org.uk> <20120530163605.GV11775@ZenIV.linux.org.uk>
 <1338406967.2257.24.camel@localhost> <20120530202427.GW11775@ZenIV.linux.org.uk>
 <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
 <20120530205612.GY11775@ZenIV.linux.org.uk> <CA+55aFwXfD6vCj8sHuB33ctB-D8cfJN45h+iURXA6mR=S0mgwA@mail.gmail.com>
 <20120530213638.GZ11775@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 May 2012 15:51:27 -0700
X-Google-Sender-Auth: DWXdlroZ6LySHaEK9tUq1TLK8C0
Message-ID: <CA+55aFzP8Eo1AX7MS-RRG_Atq3NF0bS1ReZydRtgxxy7TDn57Q@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 2:36 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> The only difference is that for file-backed ones !MMU wants
> VM_MAYEXEC in that file's bdi flags (BDI_CAP_EXEC_MAP).  And
> that actually sounds reasonable in !MMU case.

Ok, I don't think it should be strictly necessary, but I guess I don't
mind either.

> Anyway, I've dumped the variant I've got into vfs.git@security_file_mmap;
> it should be at commit f12a0fd062b1d259a0b6bc6442019e6d4c45e9f5.
>
> Comments?

Two small ones:

 - I really don't think you should use "goto out" in
security_mmap_file(). That implies that you're exiting the function,
but in fact you're jumping to the very *meat* of the function.

   So I think you should rename "out" as "no_added_exec" or something.

And a small question:  This code:

+       ret = security_mmap_file(file, prot, flags);
+       if (!ret) {
+               down_write(&current->mm->mmap_sem);
+               retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+               up_write(&current->mm->mmap_sem);
+       }

now seems to exist in four places. And in fact, that pretty much seems
to *be* what vm_mmap() is, at this point. Why isn't there just one
single vm_mmap() implementation, and then the callers of that?

                    Linus
