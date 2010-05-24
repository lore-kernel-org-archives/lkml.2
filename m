Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0EXCqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 22:46:33 -0400
Received: from pop3.scorch.co.nz ([203.167.210.162]:44429 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755350Ab0EXCqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 22:46:32 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 May 2010 22:46:32 EDT
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: linux-kernel@vger.kernel.org
Subject: Trying to use SLUB in an odd way
Date: Mon, 24 May 2010 14:39:48 +1200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005241439.48373.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

YAFFS uses an internal almost slub-like allocator and I've been looking at 
moving it to use SLUB as part of an attempt to mainline yaffs.

In yaffs I create a lot of tiny objects which are allocated in blocks, like 
slub, and then managed in a free list. Very slubbish so far, but mine is far 
less intelligent than slub.

The difference though is that I can keep the objects for each mount separate 
and can dump the whole lot on umount without individually freeing objects. I 
just deallocate my whole cache.

There are two problems that I encountered in  moving to slub:
1) I want to keep each mount point separate, but slub just hooks up with an 
existing cache of the same size. I managed to trick slub into keeping yaffs 
objects in their own cache by assigning a fake ctor. That stops the 
combination (well at present anyway - could easy change in the future like if 
ctor gets dropped). Like a VW Bug: ugly but it gets you there....

2) If I dump a cache with existing in-use objects then slub gets upset and 
dumps warnings. I don't like the idea of just ignoring warnings. I also don't 
want to manually tear down trees etc when the existing  "just dump it" 
approach is a lot faster. Pity there is no "trust me I know what I'm doing" 
flag.

Questions:
A) Is there a better way to use slub to do this or is it better to just 
continue with my manual allocator?

B) Is it worth adding flags to kmem_cache_create() to say:
 a) Don't combine this slub with others.
 b) "Trust me I know what I'm doing": Allow the cache to be dumped with 
objects still allocated. 

If (B) makes sense I'll put together a patch.

-- Charles


