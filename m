Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2IYNBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:01:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44802 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab2IYNBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:01:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120925114425.15269.qmail@science.horizon.com>
References: <20120924134939.23197.qmail@science.horizon.com> <20120925114425.15269.qmail@science.horizon.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 25 Sep 2012 15:00:49 +0200
Message-ID: <CAK1hOcP5uuQafdQRmiAtLMMOos2ZZuOYU8qZgdg6LANfWdAjiw@mail.gmail.com>
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
To: George Spelvin <linux@horizon.com>
Cc: mpn@google.com, hughd@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 1:44 PM, George Spelvin <linux@horizon.com> wrote:
> Thanks to Denys Vlasenko for sending me his benchmarking code.
>
> I went and hacked on it to ransomize the numbers being converted more,
> since repeatedly converting the same number underestimates the number
> of branch mispredictions.
>
> Then I tried computing the number of digits beforehand, as mentioned
> in my earlier message, and it came out slightly slower.  The code is:
>
> static noinline_for_stack
> char *put_dec_trunc8(char *buf, unsigned n)
> {
>         static unsigned const pow10[9] = { 0, 10, 100, 1000, 10000, 100000,
>                                          1000000, 10000000, 100000000 };
>         unsigned digits = (19 * fls(n) + 6) >> 6;  /* Valid for < 44 bits */

fls() itself may be more expensive than a few jumps.

> But!  With more extensive refactoring of the number() code, computing
> the number of digits at the beginning can eliminate the entire business
> of formatting into tmp[] and copying backward.  We'll first compute the
> number of digits, check for buffer overflow, insert the printf padding,
> and then call the number-formatting code, passing the number of digits in.
>
> It seems plausible that the resultant simplification will produce a
> speedup.
>
> I'm going to experiment with that.  Denys, since I'm playing in your sandbox,
> do you have any violent objections to that?

I don't object.

-- 
vda
