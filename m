Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1DKByN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 21:54:13 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38556 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1DKByM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 21:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F1VPbPo5Wkb0rbueUGIfOaA5lBQC6Bfr9Qk+HMNt0Mqdc+GMazCYqd+sMFKk1Hn14x
         SwUQNUSfCe2qL1qpSzSWUeSqgflwJz93U6kvYanbH1D2INNnZjishhN91iBAZWDaBUD/
         Nyb4jdro3E/Z2GA2m/A5dDVuZ+m0DANaprvY0=
MIME-Version: 1.0
In-Reply-To: <1302442907.5366.15.camel@t41.thuisdomein>
References: <1302442907.5366.15.camel@t41.thuisdomein>
Date: Mon, 11 Apr 2011 09:54:11 +0800
X-Google-Sender-Auth: G-QxmFmHSUBAq-PawQxNBaJOCm4
Message-ID: <BANLkTi=ma7WDo9=kKwZGwuhi=qUEB8EW5g@mail.gmail.com>
Subject: Re: block: ioc->refcount accessed twice in put_io_context()?
From: Shaohua Li <shli@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/10 Paul Bolle <pebolle@tiscali.nl>:
> 0) Looking for clues to solve a problem I ran into, I noticed something
> odd in block/blk-ioc.c:put_io_context(). It seems it accesses the atomic
> variable ioc->refcount twice in a way which suggests things might race.
>
> 1) Code is more exact than words, so this (entirely untested) patch to
> solve this possible race might describe better what this is all about:
>
> @@ -33,12 +33,16 @@ static void cfq_dtor(struct io_context *ioc)
>  */
>  int put_io_context(struct io_context *ioc)
>  {
> +       int new;
> +
>        if (ioc == NULL)
>                return 1;
>
> -       BUG_ON(atomic_long_read(&ioc->refcount) == 0);
> +       new = atomic_long_dec_return(&ioc->refcount);
> +
> +       BUG_ON(new < 0);
>
> -       if (atomic_long_dec_and_test(&ioc->refcount)) {
> +       if (new == 0) {
>                rcu_read_lock();
>                cfq_dtor(ioc);
>                rcu_read_unlock();
>
so you hit this line?
BUG_ON(atomic_long_read(&ioc->refcount) == 0);
this suggests something else is already wrong, you should fix that.
