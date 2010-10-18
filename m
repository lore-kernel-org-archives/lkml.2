Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0JRSOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:14:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58441 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab0JRSOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:14:09 -0400
Message-ID: <4CBC8E02.6070109@kernel.org>
Date: Mon, 18 Oct 2010 11:12:18 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
References: <20101016065206.GO4681@dastard> <20101016192027.GA6883@infradead.org> <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com> <20101017003526.GA29677@dastard> <4CBA4933.1080108@kernel.org> <20101017021138.GG32255@dastard>
In-Reply-To: <20101017021138.GG32255@dastard>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Oct 2010 11:12:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2010 07:11 PM, Dave Chinner wrote:
> On Sat, Oct 16, 2010 at 05:54:11PM -0700, J.H. wrote:
>> There does seem to be a boot option to disable it, but it seems to be on
>> by default if it's compiled in, and it's not like it's obvious that this
>> is there and chewing up resources, is there a way to find out how much
>> memory this is chewing up?
> 
> $ grep iint_cache /proc/slabinfo | awk '// { print $2 * ($4 + 560) / 1048576 "MiB" }'
> 1164.91MiB
> $

Exciting, I saw that too.  Not sure I'm going to get to do a reboot on
master before Kernel summit (and it's OS upgrade) but I'm re-compiling
the kernel with IMA disabled.

Master's live backup machine was chewing nearly 4G of memory, and
if/when I flip some of the big frontend machines over this is going to
be a completely unacceptable waste of memory.

For the record I'm really not happy or keen on having to maintain a
custom kernel just to get this disabled, but if it's going to save me 4G
on a single quiet machine I can only assumes it's going to save me
several 10s of gigs on some of the bigger machines.

> $ while [ 1 ]; do
>> grep iint_cache /proc/slabinfo | awk '// { print $2 * ($4 + 560) / 1048576 "MiB" }'
>> sleep 5
>> done
> 955.706MiB
> 937.438MiB
> 928.851MiB
> 920.912MiB
> 919.067MiB
> 919.086MiB
> 919.111MiB
> .....
> 
> This is only with about 1.2M inodes cached - yesterday I saw the
> inode cache grow to 3.5M inodes during an rsync run....
> 
> Also, it's doing a good job of fragmenting the radix tree node cache
> - it's currently at 50% population - 3.8M entries, 1.9M in use. i.e.
> wasting another ~1GB of RAM itself right now....

Ouch, thanks for giving us a heads up on it, definately not something I
expected to quietly creep in and bite me.  I should have a solution, if
one I'm not happy with, in the short term.  Hopefully Fedora/upstream
will have a better solution soon.

For the record I liked the explicit opt-in that was mentioned vs. and
automatic opt-in without disable we have now.

- John 'Warthog9' Hawley
