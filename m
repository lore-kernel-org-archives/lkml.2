Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2CXMxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 08:53:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55022 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab2CXMxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 08:53:06 -0400
MIME-Version: 1.0
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 24 Mar 2012 08:52:46 -0400
Message-ID: <CAOPLpQcu3DTLHYnfbX0_k1M4=Yw2LSFEB6K4nEGavve1mWDsSg@mail.gmail.com>
Subject: seq_put_decimal_* optimization
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to squeeze out the last drop of slack from the /proc text
generation, shouldn't we then avoid code like

+       seq_put_decimal_ull(m, ' ', 0);

which is worse than what was there before? I realize that the code
actually becomes more readable like this.  So how about automatically
optimizing the code by adding something like the following to
seq_file.h:

#define seq_put_decimal_ull(m, delimiter, num) \
  (__builtin_constant_p(num) && \
   __builtin_constant_p(delimiter) && (delimiter) == ' ' \
   ? seq_write(m, " " #num, sizeof(" " #num) - 1) \
   : seq_put_decimal_ull(m, delimiter, num))

Completely untested and it is a minimal change.  It could be written
using an inline function and probably made more general that way
(e.g., handle more delimiters).  But this code should handle the case
that exist today and lead to a (very small) improvement without any
real costs to maintenance.
