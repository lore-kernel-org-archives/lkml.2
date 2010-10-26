Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab0JZAMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:12:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42371 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0JZAMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nIKaVjT2zrMzxf+B0nE29K4tXW+azP+/GGvM9BKKlI/nVEBXXHVo0sTNi8XMxEXuWW
         3CYQj1ZLjMSwlDr1ibQBXOnTBWCRaMXuSmRhKTPgc2R/YyONYq5K900yGOzhOv4jvTOY
         YMOareWX5vObDli1YTxL37xiP+kIWqNA7ZlhQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010250900530.3583@localhost6.localdomain6>
References: <20101016075703.GO19147@amd>
	<20101016161642.GC16861@infradead.org>
	<20101016171213.GC3240@amd>
	<20101017004610.GB29677@dastard>
	<20101017022539.GA3317@amd>
	<87iq0za32l.fsf@basil.nowhere.org>
	<20101018162105.GB9571@infradead.org>
	<20101019070057.GA7770@amd>
	<20101019165044.GA13531@infradead.org>
	<alpine.LFD.2.00.1010241728510.11642@localhost6.localdomain6>
	<20101024211735.GB3137@amd>
	<alpine.LFD.2.00.1010250638250.14160@localhost6.localdomain6>
	<alpine.LFD.2.00.1010250900530.3583@localhost6.localdomain6>
Date: Mon, 25 Oct 2010 18:12:40 -0600
Message-ID: <AANLkTikeozj07Re34hS1Y-i8E90tqYy9kraVHs7MOkqg@mail.gmail.com>
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
From: Nick Piggin <npiggin@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 1:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 25 Oct 2010, Thomas Gleixner wrote:
>> On Mon, 25 Oct 2010, Nick Piggin wrote:
>> > Although a sane locking macro and structure like I had, would perfectly
>> > allow you to switch locks in a single place just the same.
>>
>> And a locking macro/structure is better in self documenting than a
>> helper function which was proposed by Christoph?
>
> Independently of what data structure you folks agree on, we really do
> _NOT_ want to have open coded bit_spin_*lock() anywhere in the code.
>
> As I said before, aside of RT it's a basic requirement to switch bit
> spinlocks to real ones for lockdep debugging.

Putting it in hlist_bl locking function doesn't do much to help --
putting mutexes
or spinlocks into hlist hashes is insane.

What might be good is to have a bit spinlock structure which is 0 size
in a normal
config, but it can hold things like lockdep data. Someone posted a patch maybe a
year ago to do that, which I thought was good but I don't know why it didn't go
anywhere.

It still doesn't solve your -rt problem really, because on a
production rt build like I
say, you can't blindly just replace bit spinlocks with mutexes. But it
makes lockdep
work and could take care of *some* bit spinlocks for -rt.
