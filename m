Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1HBVnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:43:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab1HBVnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:43:41 -0400
Date: Tue, 2 Aug 2011 17:43:37 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: Jan Seiffert <kaffeemonster@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sfrench@us.ibm.com, linux-cifs@vger.kernel.org
Subject: Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for
 large dirs
Message-ID: <20110802174337.70a4ff15@tlielax.poochiereds.net>
In-Reply-To: <CAH2r5mvTtsDVaYWYswo+CgFRRZJ-+hWTca-3V9vZP7wh0ezfyw@mail.gmail.com>
References: <CAPwCz79UntBiAs4X+XSj62xvkpK0CW6cqQqhyCU97r4u5SmJ_g@mail.gmail.com>
	<20110802064455.0777c0fd@corrin.poochiereds.net>
	<20110802120008.3e19d193@tlielax.poochiereds.net>
	<CAH2r5mvTtsDVaYWYswo+CgFRRZJ-+hWTca-3V9vZP7wh0ezfyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 11:03:28 -0500
Steve French <smfrench@gmail.com> wrote:

> your patch does look right.
> 

Sigh...as is often the case, things are not quite so simple...

I did some auditing of how server->maxBuf is used in the cifs code and
found it to be very confused. The reason it basically works, I think is
because on NEGOTIATE, the client does this:

       server->maxBuf = min(le32_to_cpu(pSMBr->MaxBufferSize),
                       (__u32) CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);

So using maxBuf and CIFSMaxBufSize interchangeably like the code does
is basically OK, even if it is confusing to limit how much the client
can receive based on how much the server can.

I think that we really need to approach this more comprehensively and
have a clear delineation between server->maxBuf and CIFSMaxBufSize. I
don't think it would be wise though to put that into 3.1 at this point.

I think it would probably be best to just back out commit c4d3396b2 for
now, and I'll plan to do this as a larger (and hopefully better-tested)
patchset for 6.2.

Sound ok? Do you need me to send a revert patch?

-- 
Jeff Layton <jlayton@redhat.com>
