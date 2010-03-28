Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0C1M2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 08:28:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48718 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0C1M2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 08:28:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BAF4B49.9070308@s5r6.in-berlin.de>
Date: Sun, 28 Mar 2010 14:27:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
References: <201003242240.54907.arnd@arndb.de> <201003251438.59062.arnd@arndb.de> <4BAD4795.2040700@s5r6.in-berlin.de> <201003271537.40488.arnd@arndb.de>
In-Reply-To: <201003271537.40488.arnd@arndb.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Your patches look good, but it would be helpful to also set .llseek = no_llseek
> in the file operations, because that is much easier to grep for than
> only the nonseekable_open. While it's technically a NOP on the presence of
> nonseekable_open, it will help that I don't accidentally apply my patch on
> top of yours.

Sounds like a plan, but (a) if my .llseek = no_llseek and your .llseek =
default_llseek are not within diff context range, you (or whoever else
merges mine and yours) only get a compiler warning (Initializer entry
defined twice) rather than a merge conflict which couldn't be missed,
(b) there won't be a merge conflict in "BKL removal: mark remaining
users as 'depends on BKL'".  (c) While I don't mind adding more visual
clutter to ieee1394/*, I prefer terse coding in firewire/*.

How about I put my nonseekable_open additions into a release branch and
send you a pull request after a few days exposure in linux-next?  If you
do not plan to respin your patch queue soon or at all, I could even let
you pull a for-arnd branch with a semantically correct merge of yours
and mine.

General thoughts:

".llseek = NULL," so far meant "do the Right Thing on lseek() and
friends, as far as the fs core can tell".  Shouldn't we keep it that
way?  It's as close to other ".method = NULL," as it can get, which
either mean "silently skip this method if it doesn't matter" (e.g.
.flush) or "fail attempts to use this method with a fitting errno" (e.g.
.write).

Of course, as we have already seen with infiniband, firewire, ieee1394,
.llseek = NULL is ambiguous in practice.  Does the driver really want to
use default_llseek, or should it rather use no_llseek and/or
nonseekable_open, or should it even implement a dummy_llseek() { return
0; } which avoids the BKL but preserves ABI behaviour?  This needs to be
resolved for each and every case eventually, regardless of whether or
when your addition of .llseek = default_llseek enters mainline.
-- 
Stefan Richter
-=====-==-=- --== ===--
http://arcgraph.de/sr/
