Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1D0Bfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:35:45 -0400
Received: from science.horizon.com ([71.41.210.146]:16882 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753308Ab1D0Bfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:35:44 -0400
Date: 26 Apr 2011 21:35:41 -0400
Message-ID: <20110427013541.18526.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: torvalds@linux-foundation.org
Subject: Re: [PATCH v2 5/6] signal: sys_sigprocmask() needs retarget_shared_pending()
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, oleg@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and notice how you now can do that helper function *WITHOUT* any
> conditionals, and just make it do
> 
>     sigprocmask(&clear, &set, NULL);
> 
> which handles all cases correctly (just "andn clear" + "or set") with
> no if's or switch'es.

Gripe: Arrgh, apostrophe disease!  Linus, youre picking up nasty habits.

Suggestion: Actually, the usual, more flexible implementation, is
"andn mask" + "xor set".  That gives all 4 bit operations (nop, set,
clear, and toggle) unique bit combinations.

Not that it's of any use in many cases, but it has better hack value.

That would convert to:
  switch (how) {
  case SIG_BLOCK:
      mask_bits = new_set;
      set_bits = new_set;
      break;
  case SIG_UNBLOCK:
      mask_bits = new_set;
      set_bits = 0;
      break
  case SIG_SET:
     mask_bits = low_bits | new_set;
     set_bits = new_set;
     break;
   default:
     return -EINVAL;
  }

If you prefer separate set & clear fields, with both set meaning "toggle",
which admittedly is a more elegant representation, then it's
"andn (set|clear)" + "xor set".
