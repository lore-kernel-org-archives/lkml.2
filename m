Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab0JWRt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:49:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59205 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab0JWRt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uReQBFyv9Sm9vJd+8ec0t+KIdiGeYxLppYX6Nc9UO6LhRSBybQtv5ea/vy1TtP0SWL
         WzMBn1WhCNjIJ1qhESHBcrQo4u6u5+9ykUYhtjDk2eKmcI7wTNsQOzBN4+yK1KYhZngW
         Br7t1ceuWNYa3eubbxVrh5MR/sP3t9w7vBJus=
Subject: Re: [PATCH] fs/buffer.c: change buffer_busy() to use logical-OR
 expression
From: Namhyung Kim <namhyung@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101023172107.GQ19804@ZenIV.linux.org.uk>
References: <1287853575-14190-1-git-send-email-namhyung@gmail.com>
	 <20101023172107.GQ19804@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Oct 2010 02:49:48 +0900
Message-ID: <1287856188.1681.48.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-23 (토), 18:21 +0100, Al Viro:
> On Sun, Oct 24, 2010 at 02:06:15AM +0900, Namhyung Kim wrote:
> > Convert bitwise-OR operator to logical-OR in favor of short-circuit
> > evaluation. The end result would be same.
> 
> It'll cost _more_.
> 
> Think of it:
> 	v = atomic_read(...)
> 	w = bh->b_state
> 	w &= constant
> 	v |= w
> 	return v
> vs.
> 	v = atomic_read()
> 	branch to l if not equal to 0
> 	w = bh->b_state
> 	if w & constant is not 0, branch to l
> 	v = 0
> 	return v
> l:	v = 1
> 	return v
> 
> That short-circuit won't win anything here.

I see. It adds expensive branch insns. I just checked that patched code
generated longer code, Cool. But what if I exchange the order of
evaluation, check the bitmask before atomic_read()? Isn't it helpful
either?

Thanks.


-- 
Regards,
Namhyung Kim


