Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab0JZAG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:06:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38706 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab0JZAG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:06:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cSkK1t0PKRtel/TyHrqWdK4tgjeoweFsmxBtbEY48Cswdqhzs+ah7JsQN7V4LP3RX9
         Tx8bgr4BlpQ77EK0WFucH3+VRPnYRrYPvDDXeNHQc1xN0XnUMY2tRdOOpZhosKW4LhUR
         Gf75sZs1B1Mwsy0XEBbwQ1TTFclIZGKXgJksg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010250638250.14160@localhost6.localdomain6>
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
Date: Mon, 25 Oct 2010 18:06:26 -0600
Message-ID: <AANLkTikvXs1LT49eQReq82-CZy2X0jjp25dG6kPcteti@mail.gmail.com>
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
From: Nick Piggin <npiggin@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <npiggin@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 10:41 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 25 Oct 2010, Nick Piggin wrote:
>> You do not want to add a bloated mutex to each inode hash bucket and
>> think you can just dust off your hands and walk away.  You would
>> probably make a smaller auxiliary hash of locks, sanely sized, and
>> protect it with that.
>>
>> So it would be wrong to just bloat hlist_bl by a factor of several times
>> (how big is a mutex in -rt?) without doing anything else.
>
> Let me worry about it.

No, because you simply should almost never turn the hlist locking into anything
big and bloated, whether it is for -rt or anything else. It is most
likely going to be
used as a per-bucket hash lock (or bit of metadata), so anything
larger than a bit
(which is essentially free) is way overkill.

You would instead have an auxiliary small hash of locks, not tens of megs of
mutexes.


>> Although a sane locking macro and structure like I had, would perfectly
>> allow you to switch locks in a single place just the same.
>
> And a locking macro/structure is better in self documenting than a
> helper function which was proposed by Christoph?

Yes, because you still have the problem that you need to go through and fix up
all call sites.

With my abstraction, there is a small inode function for locking an inode hash
bucket. You have to change 2 places (lock and unlock) to look up an aux hash
of locks and you're done.
