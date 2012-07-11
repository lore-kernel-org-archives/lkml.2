Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab2GKTKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:10:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56518 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2GKTKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:10:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120711183239.GA7122@redhat.com>
References: <20120711183239.GA7122@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jul 2012 12:10:12 -0700
X-Google-Sender-Auth: Kcyhi5KHzjjhHcE3vEBwtonZD0U
Message-ID: <CA+55aFz5E4NMDF+OXDoGkHz2Mr2sBXf6nYcOXomDZHmnUSdWHA@mail.gmail.com>
Subject: Re: 3.5-rc6 dentry related GPF
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 11:32 AM, Dave Jones <davej@redhat.com> wrote:
>
> What's puzzling me though is how we got from do_dentry_open to try_module_get ?

It's the

    f->f_op = fops_get(inode->i_fop);

that does it.

I have no idea what the actual bug is, though, but the code decodes to

   0:	89 75 f0             	mov    %esi,-0x10(%rbp)
   3:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
   7:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
   c:	b8 01 00 00 00       	mov    $0x1,%eax
  11:	48 85 ff             	test   %rdi,%rdi
  14:	48 89 fb             	mov    %rdi,%rbx
  17:	74 42                	je     0x5b
  19:	65 48 8b 04 25 b0 c8 	mov    %gs:0xc8b0,%rax
  20:	00 00
  22:	83 80 44 e0 ff ff 01 	addl   $0x1,-0x1fbc(%rax)
  29:*	83 3f 02             	cmpl   $0x2,(%rdi)     <-- trapping instruction
  2c:	0f 84 54 01 00 00    	je     0x186
  32:	48 8b 87 50 02 00 00 	mov    0x250(%rdi),%rax
  39:	65 48 ff 00          	incq   %gs:(%rax)

where that "cmpl $2" is the "module_is_live(module)" test, as far as I
can tell. And %rdi should be the module pointer, but it is obviously
garbage:

  rdi = 54415541e5894855

which looks like some odd corrupted ASCII to me ("UH\211\345AUAT") but
that makes no sense either.

                   Linus
