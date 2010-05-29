Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0E2QU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 12:20:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab0E2QUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 12:20:25 -0400
X-Authority-Analysis: v=1.1 cv=EbJB9AiBqsyZPMVATYsj78CfMiBiOs+4P7kRKNQkfg0= c=1 sm=0 a=2iQPwODrlvMA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=pGLkceISAAAA:8 a=bnIpihOkyyCsO-PpGCEA:9 a=kHG0JlIdYjSq_g47VkQA:7 a=ugg1a3XjorRPC_zp4bYmLD4swBsA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH v2 3/4]: sendfile: remove flags paramter of 
 do_splice_direct()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Changli Gao <xiaosuo@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, axboe@kernel.dk,
       Al Viro <viro@zeniv.linux.org.uk>, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <AANLkTimCXzrXcfwbCy5MZ3D40WBnGbF6Kbj6egTSjk2s@mail.gmail.com>
References: <1274885054-15698-1-git-send-email-xiaosuo@gmail.com>
	 <E1OHw3d-0001yr-Ag@pomaz-ex.szeredi.hu>
	 <AANLkTimzsHAxha3vQxeFn5pF5BmYZ8nLawSG2YU3eujZ@mail.gmail.com>
	 <AANLkTimCXzrXcfwbCy5MZ3D40WBnGbF6Kbj6egTSjk2s@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 29 May 2010 12:20:19 -0400
Message-ID: <1275150019.22648.615.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Removed matthew@wil.cx since I'm getting errors in sending to that address ]


On Sat, 2010-05-29 at 09:59 +0800, Changli Gao wrote:
> On Fri, May 28, 2010 at 6:06 PM, Changli Gao <xiaosuo@gmail.com> wrote:
> > On Fri, May 28, 2010 at 5:40 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> On Wed, 26 May 2010, Changli Gao wrote:
> >>> remove flags paramter of do_splice_direct().
> >>>
> >>> the flags parameter of do_splice_direct() doesn't mean non-block read of
> >>> in file,
> >>
> >> Actually, it does.  Look at the SPLICE_F_NONBLOCK usage in
> >> __generic_splice_file_read().
> >>
> >
> > Oh, I checked the code again. You're right. However, why don't we
> > check the flags of in file instead in __generic_file_splice_read()?
> >
> 
> I am afraid that __generic_file_splice_read() should not use SPLICE_F_NONBLOCK.
> 
> Here is the comment from the commit 42324c62704365d6a3e89138dea55909d2f26afe :
> 
> <<EOF
> Linus introduced  SPLICE_F_NONBLOCK in commit
> 29e350944fdc2dfca102500790d8ad6d6ff4f69d
> (splice: add SPLICE_F_NONBLOCK flag )
> 
>   It doesn't make the splice itself necessarily nonblocking (because the
>   actual file descriptors that are spliced from/to may block unless they
>   have the O_NONBLOCK flag set), but it makes the splice pipe operations
>   nonblocking.
> 
> Linus intention was clear : let SPLICE_F_NONBLOCK control the splice
> pipe mode only
> EOF
> 
> And I have greped the whole code:
> 


> kernel/trace/trace.c:           if (flags & SPLICE_F_NONBLOCK)
> 
> besides the __generic_file_splice_read(), there are two users: relay
> and trace. I believe they all misuse this flag.
> 


The trace splice never blocks anyway. Since we have no good method to
wake up a waiter. That is, we never know if it is safe to call wakeup,
because a tracepoint may be in a section where the rq lock is held.

The only thing that passing SPLICE_F_NONBLOCK does in that code is to
return -EAGAIN when there is nothing in the buffer. Otherwise, it
returns 0.

-- Steve



