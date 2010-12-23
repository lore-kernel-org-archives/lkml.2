Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab0LWTiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 14:38:03 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58191 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0LWTiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 14:38:01 -0500
MIME-Version: 1.0
Date: Thu, 23 Dec 2010 19:38:00 +0000
Message-ID: <AANLkTinwWpT3S0bNOjX-wTk_wfQ-56Wd7q6WfMmUTO9_@mail.gmail.com>
Subject: Oddity with Kconfig behaviour when using a type definition and no prompt
From: David Peverley <pev@sketchymonkey.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I've been investigating behaviour in the kbuild config system that I don't
really understand. It feels like its a bug to me but it's so fundamental I
would have expected it to have been picked up before so I'm a bit confused,
hence I thought I'd throw it at the list for comment / review!

The good news is that I've reproduced it with all of the 2.6 kernels and a
couple of different GCC versions. Hopefully it should be easy to understand
just by reading this email though.

The behaviour that I didn't understand is that if you add a new variable
to a Kconfig file it can behave in different ways depending on the state of
the input prompt. "kconfig-language.txt" states :

  The type definition optionally accepts an input prompt, so these two
  examples are equivalent:
     bool "Networking support"
  and
     bool
     prompt "Networking support"

This is what I've always expected. Trying the following with a clean
kernel. However, what happens in the (often used) case of a type definition
with no prompt e.g.
     bool
is not defined in this doc. My _assumption_ would be that it should still
be used by the config system though :

  bob:linux-2.6.31.14 $ make defconfig
  *** Default configuration is based on 'x86_64_defconfig'
  #
  # configuration written to .config
  #
  bob:linux-2.6.31.14 $ printf "\nconfig PEV_TEST\n\tbool\n" >> lib/Kconfig
  bob:linux-2.6.31.14 $ make oldconfig
  scripts/kconfig/conf -o arch/x86/Kconfig
  #
  # configuration written to .config
  #

"make oldconfig" ignores the new variable and as far as the newly generated
.config is concerned, it is ignored. According to "kconfig.txt" :

  To see a list of new config symbols when using "make oldconfig", use
        cp user/some/old.config .config
        yes "" | make oldconfig >conf.new

So to my mind this isn't correct as oldconfig should have known about the
new variable "PEV_TEST"?

Now, if you add a new variable with a prompt :

  bob:linux-2.6.31.14 $ printf "\nconfig PEV_TEST_PROMPT\n\tbool
\"test\"\n" >> lib/Kconfig
  bob:linux-2.6.31.14 $ make oldconfig
  scripts/kconfig/conf -o arch/x86/Kconfig
  *
  * Restart config...
  *
  *
  * Linux Kernel Configuration
  *
  test (PEV_TEST_PROMPT) [N/y] (NEW)

Now oldconfig acknowledges the new variable and asks us to set a value.
Shouldn't this be consistant with the previous example?

This becomes a problem in the following scenarion. If your tree is as
we've left it (i.e. added the two new variables as above) and now you add
to add the new variable into a defconfig file - I'm using "x86_64_defconfig"
as it's what we've used so far :

  linux $ echo "CONFIG_PEV_TEST=y" >> arch/x86/configs/x86_64_defconfig
  linux $ echo "CONFIG_PEV_TEST_PROMPT=y" >> arch/x86/configs/x86_64_defconfig
  linux $ rm -f .config
  linux $  make x86_64_defconfig
  #
  # configuration written to .config
  #
  linux $ grep PEV .config
  CONFIG_PEV_TEST_PROMPT=y
  linux $

The variable we added with a prompt is correctly put in .config, but the
other one is discarded!

So... I fear this isn't correct, can anyone sanity-check my train of
thought here? I've seen this happening for various variables in the kernel
such as "CONFIG_LOCKDEP" and "TRACE_IRQFLAGS" when I've been hacking my
.config so I suspect this can be a real-world issue!]

This also seems to be reproducable with types such as int and tristate and
seems to be reproducable from 2.6.1 !

Cheers,

~Pev
