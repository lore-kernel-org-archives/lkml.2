Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2IDMJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:09:43 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2475 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756840Ab2IDMJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:09:42 -0400
Subject: Re: Why exported const value modified by another driver not updated
 in original driver
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Manavendra Nath Manav <mnm.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Date: Tue, 04 Sep 2012 14:06:31 +0200
In-Reply-To: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
References: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1346760392.5081.19.camel@thorin>
Mime-Version: 1.0
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Die, 2012-09-04 at 15:00 +0530, Manavendra Nath Manav wrote:
[....]
> I have declared a static const int variable in one driver and exported
> that variable symbol.

Exporting a "static" variable makes conceptually no sense whatsoever -
either you want it exported (so you should remove the "static") or you
want it not exported - which is precisely the definition of "static".

> retains the original value. When both virtual and physical addresses
> of the variable as seen by both drivers are same, how is this even
> possible. Is it a kernel bug?

It's a bug in your drivers.
The C compiler sees an initialized "static const" variable. So the C
compiler knows that it is not accessible from other compilation units
(because it is "static") and the variable isn't changing within the
current compilation unit (because the variable as such is "const" and
their is no non-const pointer to it or similar).
Since this is the only compilation unit, it knows that no one will/can
change it's value.
So the C compiler happily replaces all references to the variable with
it's value - just as if you would have #define'd that value.

Obviously, later on it is exported and the variable actually exists and
you can change it in the other file. But since the value has been
replaced literally by "123" at compile (more precise: optimizer time),
you don't see a change in the printk()s.

> Interestingly, when i change the declaration of variable to "volatile"
> in driver.c as "static const volatile int" then the driver.ko prints
> modified value "987" during rmmod and the original value "123" is
> lost. What is the difference between this and previous declaration?

"volatile" tells the C compiler that a variable may change it's value
without explicit code.
A typical use case are hardware registers which are changed by the
underlying hardware.
In user space, variables may be modified by signal handlers (which can
occur at any time in a program - unless specifcally blocked).

So the optimizer must not accesses to "volatile" variables because they
may change their value at any time.

> Please forgive if you find this question silly?

That all is actually pure (K&R-)C and has nothing to do with the kernel.


> static const int value = 123;
[...]
> EXPORT_SYMBOL(value);

I wonder if we can modify EXPORT_SYMBOL() so that it compile-time-fails
for "static" variables.
And if we actually want that.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

