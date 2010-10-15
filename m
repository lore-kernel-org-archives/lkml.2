Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0JOOke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:40:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49250 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab0JOOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SWGl6ptT6L9h1gr+yEQ0ycT+8i94RFYt2A/9zE6ifg7Xe4L+w49U9wqwhQ2gXhDzra
         suSKNf9rflHpRrnYkzeQNalyPj8sts+MpOoOYeJJvEBrkVPliMs1CbV3fW10IuUOZ8zZ
         o3v7QbfYnNgZ7uI+d/8P9086v9iAnQi0obFcY=
Subject: Re: Results of my work on memorystick subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <463093.9879.qm@web37607.mail.mud.yahoo.com>
References: <463093.9879.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 15:34:32 +0200
Message-ID: <1287149672.3473.28.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 23:45 -0700, Alex Dubov wrote:
> > 
> > 
> > And what I had to go through to understand the
> > mspro_block_read_attributes....
> > 
> 
> Ellipsis to the rescue! :-)
> This is just one straightforward function which parses the header block
> in an originally intended fashion. You can simplify it by making it "less
> correct", windows driver style, but otherwise I fail to see what could be
> so difficult about it.

Alex, it is now straight forward.

Lets see what gems I found in old version:

* It does obscure math with sizes, offsets.
multiplies, divides offsets, sizes, uses data stored in 'param' register
to 'recover' the data.

* It overloads the 'rc' variable to store attribute size.
That is outright nasty as you would say.

* It has not a single comment, especially about its caching.

Alex, don't get me wrong.

Let me explain why did I refactor the mspro_blk.c

I have created the ms_block.c, and I just had to create a set of common
helpers to reduce code duplication because I hate it.
It works well, very well now.

Now I had put quite a lot of changes to common code, including few state
variables in the 'card' structure.

I really had to do that. I added common INT polling feature to reduce
code duplication. I also added a timeout for INT polling. It saved me
from restart for a lot of times (while I debugged the code).
And I really can't put a piece of code that can enter an endless loop
if conditions are right.

If I were to inline the INT read function, it would create a huge code
duplication.

I added a register read/write functions.
These made it possible to be free of constant fear of sending TPC of
wrong size because register window isn't updated.
It allowed me to read/write just the right registers everywhere without
additional effor, and most importantly reduce the >8 bytes TPC which
improve performance significantly on Jmicron.

It also helped me a lot to debug and workaround that damn Jmicon reader.

The way I handle card states not only allowed me to have several states
that handle a same TPC, but allowed me to have states that don't handle
any.

Now on the other hand, the mspro_blk.c did't use these changes, and
therefore was in constant danger of beeing broken.
I had to think carefully how to add changes, while keeping the old way
working.

So I bit the bullet, and made the mspro_blk.c use new support code.
Among the way I tried to make it simpler.
I understand that you might not like that I 'made your code better',
That is very subjective, and besides,
I'll say maybe I didn't. Yet at least it is consistent with ms_block.c

Alex, maybe I shouldn’t say that new code is nice and clean.
Don't hate me because of that.




