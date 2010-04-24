Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0DXUIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 16:08:45 -0400
Received: from 5-161-237-24-mvl.swc.gci.net ([24.237.161.5]:47359 "EHLO
	mail.adialaska.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752095Ab0DXUIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 16:08:44 -0400
Message-ID: <4BD34FC8.9000702@gmail.com>
Date: Sat, 24 Apr 2010 12:08:40 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10pre) Gecko/20100422 Shredder/3.0.5pre
MIME-Version: 1.0
To: Egon Alter <egon.alter@gmx.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bcache: ver 3
References: <201004241747.41045.egon.alter@gmx.net>
In-Reply-To: <201004241747.41045.egon.alter@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2010 07:47 AM, Egon Alter wrote:
>
> I'm wondering if this is similar to the "Cleancache" patches send a few days
> before.
>
> Could bcache provide a (block-dev) backend to cleancache? Also there is fs-
> cache (for networks-fs only currently). Can these caches be combined somehow?
>
> Egon

I just looked at cleancache, and it looks like it's trying to solve part 
of the same problem at a different level - sort of giving the page cache 
a second level, instead of transparently making block devices faster. I 
didn't see any code for whatever holds pages when they're not in memory, 
I gather this was originally intended for VMs where pages in the l2 
cache are still in memory, just not memory owned by the vm kernel.

Managing the cache itself is much simpler in that case; IMO most of the 
complexity involved in using an SSD as cache is the indexing, 
allocation, etc. - it's kind of like writing a filesystem, minus the 
notion of files, plus we can play fast and loose in certain ways.

That said, adding things to the cache should definitely be done more 
like the way cleancache does it; the page cache is what knows what's 
going on. So I don't think there's much if any code that could be 
shared, but definitely the hooks cleancache/ramzswap are using is what 
bcache should be using.

fs-cache is completely different, I haven't looked at it too much but 
just knowing its approach I don't think there's any way it'll be as 
efficient as bcache will be. It just makes more sense - makes things a 
lot simpler and there's less overhead involved in working with ranges of 
sectors than doing it at the filesystem level... and this way the 
allocation is determined entirely by bcache, and can be better optimized 
for ssd erase blocks. (Having the code run under generic_make_request 
does make the code more interesting since we can't sleep, but that's a 
solved issue and doesn't add to the work it does in the fast path).
