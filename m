Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2IXMf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:35:29 -0400
Received: from science.horizon.com ([71.41.210.146]:59139 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754674Ab2IXMf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:35:28 -0400
Date: 24 Sep 2012 08:35:27 -0400
Message-ID: <20120924123527.9284.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, vda.linux@googlemail.com
Subject: Re: [PATCH 2/4] lib: vsprintf: Optimize division by 10000
Cc: hughd@google.com, linux-kernel@vger.kernel.org, mina86@mina86.com
In-Reply-To: <CAK1hOcOO7MoDDzJgKJ+2dra5n3ogyKR+mKyTh+o_isgRi3yRxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is the comparison of the x86-32 assembly
> of the fragment which does "x / 10000" thing,
> before and after the patch:

> -01 c6                  add    %eax,%esi
> -b8 59 17 b7 d1         mov    $0xd1b71759,%eax
> -f7 e6                  mul    %esi
> -89 d3                  mov    %edx,%ebx
> -89 f2                  mov    %esi,%edx
> -c1 eb 0d               shr    $0xd,%ebx
> 
> +01 c7                  add    %eax,%edi
> +b8 d7 c5 6d 34         mov    $0x346dc5d7,%eax
> +f7 e7                  mul    %edi
> +89 55 e8               mov    %edx,-0x18(%ebp)
> +8b 5d e8               mov    -0x18(%ebp),%ebx
> +89 fa                  mov    %edi,%edx
> +89 45 e4               mov    %eax,-0x1c(%ebp)
> +c1 eb 0b               shr    $0xb,%ebx
> 
> Poor gcc got confused, and generated somewhat
> worse code (spilling and immediately reloading upper
> part of 32x32->64 multiply).

> Please test and benchmark your changes to this code
> before submitting them.

Thanks for the feedback!  It very much *was* intended to start a
conversation with you, but the 7 week response delay somewhat interfered
with that process.

I was playing with it on ARM, where the results are a bit different.

As you can see, it fell out of some other word which *did* make a
useful difference.  I just hadn't tested this change in isolation,
which I realized as I wrote the final commit comment while cleaning
up the series for publication.

(And please excuse me if there's some paging delay on my part
to swap the whole business back in; it's been a while.)

I'll see if I can come up with something that provides the cleaner code
(do you agree that the source *looks* nicer?) and still makes GCC do
the right thing.
