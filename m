Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2GKTS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:18:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab2GKTS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:18:57 -0400
Date: Wed, 11 Jul 2012 15:18:52 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.5-rc6 dentry related GPF
Message-ID: <20120711191852.GA1016@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120711183239.GA7122@redhat.com>
 <CA+55aFz5E4NMDF+OXDoGkHz2Mr2sBXf6nYcOXomDZHmnUSdWHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz5E4NMDF+OXDoGkHz2Mr2sBXf6nYcOXomDZHmnUSdWHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 12:10:12PM -0700, Linus Torvalds wrote:
 > On Wed, Jul 11, 2012 at 11:32 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > What's puzzling me though is how we got from do_dentry_open to try_module_get ?
 > 
 > It's the
 > 
 >     f->f_op = fops_get(inode->i_fop);
 > 
 > that does it.
 > 
 > I have no idea what the actual bug is, though, but the code decodes to
 > 
 >    0:	89 75 f0             	mov    %esi,-0x10(%rbp)
 >    3:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
 >    7:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
 >    c:	b8 01 00 00 00       	mov    $0x1,%eax
 >   11:	48 85 ff             	test   %rdi,%rdi
 >   14:	48 89 fb             	mov    %rdi,%rbx
 >   17:	74 42                	je     0x5b
 >   19:	65 48 8b 04 25 b0 c8 	mov    %gs:0xc8b0,%rax
 >   20:	00 00
 >   22:	83 80 44 e0 ff ff 01 	addl   $0x1,-0x1fbc(%rax)
 >   29:*	83 3f 02             	cmpl   $0x2,(%rdi)     <-- trapping instruction
 >   2c:	0f 84 54 01 00 00    	je     0x186
 >   32:	48 8b 87 50 02 00 00 	mov    0x250(%rdi),%rax
 >   39:	65 48 ff 00          	incq   %gs:(%rax)
 > 
 > where that "cmpl $2" is the "module_is_live(module)" test, as far as I
 > can tell. And %rdi should be the module pointer, but it is obviously
 > garbage:
 > 
 >   rdi = 54415541e5894855
 > 
 > which looks like some odd corrupted ASCII to me ("UH\211\345AUAT") but
 > that makes no sense either.

I fixed some really stupid braino in my fuzzer last night, so oopses are
falling out left and right since then. It's probably only a matter of
time before I walk into this again. Perhaps with more data it'll start
to make sense.

	Dave

