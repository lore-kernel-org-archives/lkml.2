Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab0HQTY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:24:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56045 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750797Ab0HQTYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:24:20 -0400
Date: Tue, 17 Aug 2010 20:39:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Proposal: Use hi-res clock for file timestamps
Message-ID: <20100817203941.729830b7@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=w1UA5ZZDBigpxMiL7A7DnbnQhLkg62JZpC6Ri@mail.gmail.com>
References: <AANLkTimnyXKahtjaFeSsgcq=xMy-pP3na1jidQhZ-dt2@mail.gmail.com>
	<87aaolwar8.fsf@basil.nowhere.org>
	<20100817174134.GA23176@fieldses.org>
	<20100817182920.GD18161@basil.fritz.box>
	<20100817190447.GA28049@fieldses.org>
	<AANLkTi=w1UA5ZZDBigpxMiL7A7DnbnQhLkg62JZpC6Ri@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem with "increment mtime by a nanosecond when necessary" is
> that timestamps can wind up out of order.  As in:

Surely that depends on your implementation ?

> 1) Do a bunch of operations on file A
> 2) Do one operation on file B
> 
> Imagine each operation on A incrementing its timestamp by a nanosecond
> "just because".  If all of these operations happen in less than 4 ms,
> you can wind up with the timestamp on B being EARLIER than the
> timestamp on A.  That is a big no-no (think "make" or anything else
> relying on timestamps for relative times).


[time resolution bits of data][value incremented value for that time]


	if (time_now == time_last)
		return { time_last , ++ct };
	else {
		ct = 0;
		time_last = time_now
		return { time_last , 0 };
	}

providing it is done with the same 'ct' across the fs and you can't do
enough ops/second to wrap the nanosecs - which should be fine for now,
your ordering is still safe is it not ?

> If you can prove that the last modification on B happens after the
> last modification on A, then it is very bad for the mtime on B to be
> earlier than the mtime on A.  I guarantee that will break things in
> the real world.

Alan
