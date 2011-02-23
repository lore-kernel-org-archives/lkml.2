Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1BWQdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:33:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883Ab1BWQdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:33:14 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
 <20110222140349.GA20708@kryptos.osrc.amd.com> <AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
 <AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Feb 2011 08:32:04 -0800
Message-ID: <AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
To: Anca Emanuel <anca.emanuel@gmail.com>, Dave Airlie <airlied@redhat.com>,
        linux-fbdev@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 9:42 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> General protection fault:
> http://i.imgur.com/TBJ6y.jpg
>
> dmesg: http://pastebin.com/qD8pR8QH
> config: http://pastebin.com/XEurtHWi

That's drivers/video/fbmem.c: fb_release(), and the "Code:"
disassembly shows that it is

  1b:	e8 f7 c0 29 00       	callq  xyz
  20:	48 8b 93 b8 03 00 00 	mov    0x3b8(%rbx),%rdx
  27:*	48 8b 42 10          	mov    0x10(%rdx),%rax     <-- trapping instruction

which corresponds to

        mutex_lock(&info->lock);
        if (info->fbops->fb_release)
                info->fbops->fb_release(info,1);

so it looks like 'info->fbops' is invalid. It's in %rdx, and is
0x00d000ae00b500c2, which is definitely not a valid pointer. Looks
like some bad corruption (looks like a sequence of 16-bit numbers, but
it could be anything).

Looks like nouveafb took over from vesafb. Did you do anything special
to trigger this?

Also, you do seem to have some extra patches (yama at the least). Anything else?

                            Linus
