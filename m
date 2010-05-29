Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0E2B7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 21:59:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60104 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab0E2B7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 21:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QbPXRyPPIHtjs2/HNNHHmJ7/STg1VgztZ/i8geUcOALdzq154r7RMKiQXrgelgV3lF
         FMGL0N88daYvGizjYQo6zFASiGAYbvMVjp2/9cwnBDJdNyiBiDsLi5ZfryXAYbBjUke8
         yD+KFkusxVO+nLKMOLuv84oaLYJ7jOwGAL0Oo=
MIME-Version: 1.0
In-Reply-To: <AANLkTimzsHAxha3vQxeFn5pF5BmYZ8nLawSG2YU3eujZ@mail.gmail.com>
References: <1274885054-15698-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHw3d-0001yr-Ag@pomaz-ex.szeredi.hu> <AANLkTimzsHAxha3vQxeFn5pF5BmYZ8nLawSG2YU3eujZ@mail.gmail.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, 29 May 2010 09:59:00 +0800
Message-ID: <AANLkTimCXzrXcfwbCy5MZ3D40WBnGbF6Kbj6egTSjk2s@mail.gmail.com>
Subject: Re: [PATCH v2 3/4]: sendfile: remove flags paramter of 
	do_splice_direct()
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: axboe@kernel.dk, viro@zeniv.linux.org.uk, matthew@wil.cx, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 6:06 PM, Changli Gao <xiaosuo@gmail.com> wrote:
> On Fri, May 28, 2010 at 5:40 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, 26 May 2010, Changli Gao wrote:
>>> remove flags paramter of do_splice_direct().
>>>
>>> the flags parameter of do_splice_direct() doesn't mean non-block read of
>>> in file,
>>
>> Actually, it does.  Look at the SPLICE_F_NONBLOCK usage in
>> __generic_splice_file_read().
>>
>
> Oh, I checked the code again. You're right. However, why don't we
> check the flags of in file instead in __generic_file_splice_read()?
>

I am afraid that __generic_file_splice_read() should not use SPLICE_F_NONBLOCK.

Here is the comment from the commit 42324c62704365d6a3e89138dea55909d2f26afe :

<<EOF
Linus introduced  SPLICE_F_NONBLOCK in commit
29e350944fdc2dfca102500790d8ad6d6ff4f69d
(splice: add SPLICE_F_NONBLOCK flag )

  It doesn't make the splice itself necessarily nonblocking (because the
  actual file descriptors that are spliced from/to may block unless they
  have the O_NONBLOCK flag set), but it makes the splice pipe operations
  nonblocking.

Linus intention was clear : let SPLICE_F_NONBLOCK control the splice
pipe mode only
EOF

And I have greped the whole code:

fs/splice.c:            if (spd->flags & SPLICE_F_NONBLOCK) {
fs/splice.c:                    if (flags & SPLICE_F_NONBLOCK) {
fs/splice.c:            if (sd->flags & SPLICE_F_NONBLOCK)
fs/splice.c:                    if (flags & SPLICE_F_NONBLOCK) {
fs/splice.c:            if (flags & SPLICE_F_NONBLOCK) {
fs/splice.c:                    if (flags & SPLICE_F_NONBLOCK) {
fs/splice.c:    if (!ret && ipipe->waiting_writers && (flags &
SPLICE_F_NONBLOCK))
fs/splice.c: * applicable one is SPLICE_F_NONBLOCK.
include/linux/splice.h:#define SPLICE_F_NONBLOCK (0x02) /* don't block
on the pipe splicing (but */
kernel/relay.c:                 if (flags & SPLICE_F_NONBLOCK)
kernel/trace/trace.c:           if (flags & SPLICE_F_NONBLOCK)

besides the __generic_file_splice_read(), there are two users: relay
and trace. I believe they all misuse this flag.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
