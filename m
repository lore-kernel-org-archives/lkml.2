Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab2IDLte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:49:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36271 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab2IDLtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:49:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAJKgH8BYe7oS5opyiX0NL7Qj3CreEiRBD4xWoORhLAVWaqMe-A@mail.gmail.com>
References: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
 <CAJKgH8CNJM2SyR7bD8nXae13-Fq1MP1Xn7+383YU-HPwKBe+Zg@mail.gmail.com>
 <20120904103905.GA21953@jak-linux.org> <CAJKgH8BYe7oS5opyiX0NL7Qj3CreEiRBD4xWoORhLAVWaqMe-A@mail.gmail.com>
From: Chinmay V S <cvs268@gmail.com>
Date: Tue, 4 Sep 2012 17:19:00 +0530
Message-ID: <CAK-9PRDA4xnc08rR+yf_NoG0+7uUJn0euV+cOoEMOAYMYeN5Cg@mail.gmail.com>
Subject: Re: Why exported const value modified by another driver not updated
 in original driver
To: Manavendra Nath Manav <mnm.kernel@gmail.com>
Cc: Julian Andres Klode <jak@jak-linux.org>, kernelnewbies@kernelnewbies.org,
        devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manavendra,

Couple of things are involved in above experiment.

1. const
The variable "value" is defined as
- "static const int" in driver.c.
- "extern int" in hacker.c (i.e. not const).

2. volatile
An object marked volatile is always fetched from memory and the
compiler does NOT try to optimise away this read from memory. This is
because volatile is an explicit indication to the compiler to fetch
the value from memory and not used older value cached in CPU-register.

Here is whats happening in regular case:

driver.ko init()
    - alloc RAM for "value"
    - load value of "value" into register
    - print "value"
      (123 in driver.ko context)
hacker.ko init()
    (no alloc RAM as it is extern. Allow assignment as its NOT const here).
    - load value of "value" into register
    - print "value"
      (987 in hacker.ko context)
hacker.ko exit()
    - print "value"
      (987 in hacker.ko context)
driver.ko exit()
    - print "value"
      (123 in hacker.ko context)


Here is whats happening in case volatile is used:

driver.ko init()
    - alloc RAM for "value"
    - load value of "value" into register
    - print "value"
     (123 in driver.ko context)
hacker.ko init()
    (no alloc RAM as it is extern. Allow assignment as its NOT const here).
    - load value of "value" into register
    - print "value"
      (987 in hacker.ko context)
hacker.ko exit()
    - print "value"
     (987 in hacker.ko context)
driver.ko exit()
    - fetch value of "value" from RAM.
      (as volatile forces an explicit read from memory)
    - print "value"
      (987 copied from hacker.ko context into driver.ko context)

As Alan mentioed above, it will be interesting to look into the
assembly code of your modules. Run objdump -S on your .ko modules and
search for .init.text and .exit.text in the assembly. Observing where
the compiler decides to place the object "value" should explain why
things work the way they do.

--
regards
CVS
