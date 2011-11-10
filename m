Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935208Ab1KJE6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:58:34 -0500
Received: from hades.mikemestnik.net ([184.106.158.151]:53017 "EHLO
	hades.mikemestnik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935073Ab1KJE6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 23:58:30 -0500
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 23:58:30 EST
Message-ID: <4EBB57CA.6060202@mikemestnik.net>
Date: Wed, 09 Nov 2011 22:49:14 -0600
From: Mike Mestnik <cheako@mikemestnik.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: drivers/char/random.c: Open ended int size, makes assumption always
 4 bytes.
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that 64bit systems are farilly common it stands to reason that
calculations that need to use 32bit int/float(s) are appropriately type
cast.  I understand that while 64bit systems have pointers that are
64bit and that the size of int may well be 32bit, it's important that
type casts and shifts such as these take sizeof(int) into account... 
Even if sizeof(int) can be assured to always be 4.

In this case I believe it would be best to use more specific typecasts
to get accurate calculations.

Note the sifts here are 4bits, not 4bytes.  Still I think there is room
for problems here if these functions are passed int(s) with bits above
32set.

http://j.mp/uj0JZC
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/char/random.c;h=63e19ba56bbea5a12ee784f023bd13a758eaf611;hb=HEAD#l683


On another note, I can't discover what "uint code" should be.  It seams
like a good place to avoid hitting the repeat squelch.  For my project I
may have two 6 sided dice and there is a good chance they would hit the
same total for adjacent iterations, dropping this result seams like
something to avoid if the goal is to pool randomness.  At the same time
I'd wonder if I should shift/xor to undo the effects of this function or
if this is merely the first step in massaging the data into random
output.  One wonders what I should do.

My first thought would be to do something like:
void putc_randomness(unsigned char code)
{
  static unsigned char last_value;
  value^=1;
  add_input_randomness(32768, code ^ (code >> 4) ^ value, value);
}

