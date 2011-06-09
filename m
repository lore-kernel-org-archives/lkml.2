Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab1FIMGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:06:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48331 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1FIMGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Y56AunWhRaneiHmDf4lECzMNa7TucOCzRlVIMWFy/AozSZRU4JeVj/Uiynhw2PHAH0
         uEQwhiBYeZEt6GDNz7NBCDNVjPr/cNo1aMcVRLncIGAweI7j5oGsCFSGLfOo0gZvH/Po
         4J5vW98EP6iIX5rs5kw1ZwZrP2DIAU4FFRPpY=
MIME-Version: 1.0
In-Reply-To: <20110609104017.GW11521@ZenIV.linux.org.uk>
References: <4DEFD979.50405@tilera.com>
	<1307607243-5737-1-git-send-email-minipli@googlemail.com>
	<20110609104017.GW11521@ZenIV.linux.org.uk>
Date: Thu, 9 Jun 2011 14:06:42 +0200
Message-ID: <BANLkTimAR8ou0dwX_uB8g4pQQtu0+V5k5w@mail.gmail.com>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
From: Mathias Krause <minipli@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 12:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Jun 09, 2011 at 10:14:03AM +0200, Mathias Krause wrote:
>
>> v1 was actually the alternative solution in run_init_process()
>> v2 was missing the set_fs() calls for SPARC, TILE and Xtensa
>
> sparc does not need it...

So do FRV, M68k (MMU and NOMMU) and PA-RISC. But they all call
set_fs(USER_DS) in flush_thread() and additionally in start_thread().
As those architectures aren't that visible for the average user, I
guess this is just an oversight that has no measurable performance
impact anyway.

For SPARC we might not want this duplicated work so the call to
set_fs() in flush_thread() should be removed to equalize the semantics
of that function between the different architectures -- call
set_fs(USER_DS) only in start_thread() (with the above exceptions).
...Albeit by looking closer at the implementation of flush_old_exec()
I think we should just move the set_fs() call there and remove it from
the architecture dependent implementations of flush_thread() and
start_thread(). flush_old_exec() is the real point of no return and
this way we get it consistent between all architectures.

What do you think?

Mathias
