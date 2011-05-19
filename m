Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab1ESNmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:42:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49318 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932921Ab1ESNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:42:04 -0400
Date: Thu, 19 May 2011 14:43:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: d.g.jansen@googlemail.com
Cc: Dennis.Jansen@web.de, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Message-ID: <20110519144312.38177704@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Problem: laptop_mode wants to keep applications from waking the hard
> disks but fsync calls can "sneak through". (IMHO this is a bug.)

Its a standards requirement and thing many apps rely on. Also you can do
it perfectly well in user space for all apps. Thats why you can
preconfigure preloads and it's why you have glic library source code!

> Proposed solution: Pretend the fsync was executed and successful.
> Insert two lines into the fsync and fdatasync calls in fs/sync.c:
> if (unlikely(laptop_mode))
>    return 0;

Whoops you've just risked corrupting any app which relies on fsync for
ordering if there is a crash.

> "This is not necessary with SSDs"
> I'm not sure, but I think that SSDs will also keep an active SATA
> connection if you write to them all the time. They also have standby

On SSD the impact is miniscule as far as I can tell. A graph would tell
you more.

The "right" way to do this is more complicated by far. An fsync is an
ordering guarantee so you need to implement that ordering guarantee even
if you don't force writes to physical media. That at least cuts down most
failures (but not all - eg commits with a network component such as email
receives)

Anyway you can do it in userspace trivially if you want.
