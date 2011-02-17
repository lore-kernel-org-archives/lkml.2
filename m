Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1BQXJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:09:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab1BQXJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:09:16 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com>
References: <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
 <20110217.140119.39175251.davem@davemloft.net> <20110217221957.GA11244@dtor-ws.eng.vmware.com>
 <20110217.142320.102554706.davem@davemloft.net> <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 15:08:52 -0800
Message-ID: <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
To: David Miller <davem@davemloft.net>
Cc: dtor@vmware.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        rusty@rustcorp.com.au, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 2:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Gaah, I didn't realize that we've never had to do anything like this
> before, and that the exception table is all arch-specific code. So we
> don't have any way to "output that damned pointer and stop whining
> about it" model at all.

Actually, I don't think the problem is about ".word" vs ".xword". We
should be able to just use ".long" everywhere.

But the symbol _name_ may have different prefixes, and when we use
"asm()" at the top level, we can't use the expressions to fix it up.
So a

  asm(".long %0":'i" (symbol))

doesn't work (ignore the lack of section naming, that's not
important), and neither can we just do something like

  #define output_asm_pointer(section, symbol) \
       asm(".long " #symbol)

portably, because some linker formats want to see prepended underscores etc.

Grr.

Where in gcc is the alignment expansion logic? I'd like to see what
the rules are, just for my own perverse satisfaction.

                        Linus
