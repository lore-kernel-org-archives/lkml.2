Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0I3Rwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:52:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34934 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab0I3Rwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=fOKQjGehlg84db6CufIoPfHrnx8ENwWVktT1ckvOyN/3Vpspyo7gozj0pmhq8fYg6X
         tXTfDgE0BpWb4/BqgyYjX6d5ciGAN97IGOKwEeZ1/H6BVjhsOJo1XetxKlon89KnfjfF
         CFB2l7VmFW0he3hjLc8exnJcn3b48ULIuxTBE=
Subject: QUESTION: block layer ->request and tasklets
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 19:52:34 +0200
Message-ID: <1285869154.26846.44.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an issue that is possible related to my lack of understanding of
the block system, that really drives me nuts.

Here is the short description:

A 'perfect' block driver is supposed to start a sector transfer right in
the ->request.

An IRQ will cause the driver to end this request (or part of it), and
try to fetch another one and submit it to the hardware, effectively
doing the same thing the ->request does.
This is not easy to implement in stand alone block driver, and it is
even harder to so in a common layer.
Yet, Alex's memorystick subsystem does implement this style of a driver,
and it works quite well

A memory stick low level driver is designed after the block driver.
It also has a ->request function and a 'queue' of requests, even though
this is an illusion, because every time a request is 'fetched' from
upper layer, it is created on the fly by a state machine.
An upper level driver is a block driver.

Now the problem:
The jmb38x_ms ->request function doesn't set the hardware, but rather it
queues a tasklet, which does the work.
It seems to be redundant, and yet if I remove the tasklet, the system
randomly freezes, and worse that that, none of lockup detecters catch
it, so I am unable to get a backtrace.
This is a time I am really mad at hardware vendors for removing the
reset button....

On the other hand my ms_block.c, an upper level driver for old
MemorySticks, works OK.
But it contains a thread that does the IO. Its ->request only wakes it
up.

So in both cases, the block layer calls the ->request of the high level
block driver, and then execution context switches (to thread or tasklet)
which setups the IO.
I have a bad feeling that this is a race/deadlock somewhere, but I
triple checked everything.


Any ideas?

Best regards,
	Maxim Levitsky

