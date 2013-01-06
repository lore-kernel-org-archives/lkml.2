Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3AFVzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 16:55:45 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:50978 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3AFVzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 16:55:43 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2013 16:55:43 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20713.62152.44264.204077@quad.stoffel.home>
Date: Sun, 6 Jan 2013 16:55:20 -0500
From: "John Stoffel" <john@stoffel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: John Stoffel <john@stoffel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Major network performance regression in 3.7
In-Reply-To: <20130106215200.GV16031@1wt.eu>
References: <1357490393.6919.267.camel@edumazet-glaptop>
	<20130106164416.GF16031@1wt.eu>
	<1357492255.6919.336.camel@edumazet-glaptop>
	<20130106173543.GB22432@1wt.eu>
	<1357497541.6919.519.camel@edumazet-glaptop>
	<1357497809.6919.529.camel@edumazet-glaptop>
	<1357498276.6919.547.camel@edumazet-glaptop>
	<1357498815.6919.570.camel@edumazet-glaptop>
	<20130106193410.GL16031@1wt.eu>
	<20713.61807.385486.594545@quad.stoffel.home>
	<20130106215200.GV16031@1wt.eu>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Willy" == Willy Tarreau <w@1wt.eu> writes:

Willy> On Sun, Jan 06, 2013 at 04:49:35PM -0500, John Stoffel wrote:
>> >>>>> "Willy" == Willy Tarreau <w@1wt.eu> writes:
>> 
Willy> On Sun, Jan 06, 2013 at 11:00:15AM -0800, Eric Dumazet wrote:
>> >> On Sun, 2013-01-06 at 10:51 -0800, Eric Dumazet wrote:
>> >> > > 
>> >> > > (sd->len is usually 4096, which is expected, but sd->total_len value is
>> >> > > huge in your case, so we always set the flag in fs/splice.c)
>> >> > 
>> >> > I am testing :
>> >> > 
>> >> >        if (sd->len < sd->total_len && pipe->nrbufs > 1)
>> >> >                 more |= MSG_SENDPAGE_NOTLAST;
>> >> > 
>> >> 
>> >> Yes, this should fix the problem :
>> >> 
>> >> If there is no following buffer in the pipe, we should not set NOTLAST.
>> >> 
>> >> diff --git a/fs/splice.c b/fs/splice.c
>> >> index 8890604..6909d89 100644
>> >> --- a/fs/splice.c
>> >> +++ b/fs/splice.c
>> >> @@ -696,8 +696,10 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
>> >> return -EINVAL;
>> >> 
>> >> more = (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
>> >> -	if (sd->len < sd->total_len)
>> >> +
>> >> +	if (sd->len < sd->total_len && pipe->nrbufs > 1)
>> >> more |= MSG_SENDPAGE_NOTLAST;
>> >> +
>> >> return file->f_op->sendpage(file, buf->page, buf->offset,
sd-> len, &pos, more);
>> >> }
>> 
Willy> OK it works like a charm here now ! I can't break it anymore, so it
Willy> looks like you finally got it !
>> 
>> It's still broken, there's no comments in the code to explain all this
>> magic to mere mortals!  *grin*

Willy> I would generally agree, but when Eric fixes such a thing, he
Willy> generally goes with lengthy details in the commit message.

I'm sure he will too, I just wanted to nudge him because while I sorta
followed this discussion, I see lots of pain down the road if the code
wasn't updated with some nice big fat comments.

Great job finding this code and testing, testing, testing.

John

