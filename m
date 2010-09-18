Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0IRKwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 06:52:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56411 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0IRKwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 06:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Z6Gb40yxkUHQZxkwuZoJEouL8C2bwj6fNsdQYfXqpk58B9FohqyDUOUYO1GBhlofyi
         bErfnuQwQmfNjuJjLJ4zTfU32OZzffPL313AuzAoe713rlIdfA2omtovr97rAlWDqCne
         m6Gh10QMCKsfeOYNUpM53zsbpt+wF7UnNOU2E=
Message-ID: <4C949A05.5060209@gmail.com>
Date: Sat, 18 Sep 2010 03:52:53 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Using the page cache while maintaining a reserve? Or do it some other
 way?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been writing bcache - a patch to use SSDs to cache arbitrary block 
devices. The biggest thing left before it can be considered production 
ready (besides lots more testing) is making memory allocation deadlock 
proof.

I've been using the page cache for bcache's btree; it might be 50-100 mb 
of data with a decent sized SSD and I don't want to roll my own cache if 
I don't have to.

The problem is I need to maintain a reserve of enough memory for new 
btree nodes to split all the way to the root, and bcache's btree nodes 
are sized to the SSD's erase block. Since most consumer SSDs seem to 
have 512k erase blocks, that means a couple megabytes of reserve. (Yes, 
bcache can efficiently use 512k btree nodes, with 16 byte keys - pretty 
cool, huh? :)

Just keeping a couple megabytes of memory around unused is a little 
silly when the cache could easily be the reserve - except I don't see 
any way of doing this with the page cache. I imagine it'd probably be 
possible to rip pages belonging to bcache's mapping out of the page 
cache, except I don't think I'd be able to pick out the oldest ones that 
way and besides that it doesn't sound like a very sane thing to do. 
Guaranteeing the reserve might not be so bad by holding more buckets 
pinned in memory from within bcache, but probably it'd end up tricky and 
error prone at best.

So, I imagine I'm going to need a dedicated cache in order to do this 
right - if I maintain an lru for the whole btree implementing the 
reserve is easy, I'd just need to make the pages reclaimable or 
otherwise respond to memory pressure (which is what I have not figured 
out how to do). But I can't be the first person to have this problem, so 
I'm hoping someone will have some suggestions or there'll be an easier 
solution... (It seems like the kind of thing filesystems might run into...).

I'd also like to get my code reviewed more, but as the patch is almost 
6k lines now that's inevitably not going to be easy. I don't see any way 
to usefully split much of it out, to make it easier to digest - if 
anyone has any suggestions, I'm all ears.

http://bcache.evilpiepirate.org
git://evilpiepirate.org/~kent/linux-bcache.git
git://evilpiepirate.org/~kent/bcache-tools.git
