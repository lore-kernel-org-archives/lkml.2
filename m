Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2KDSEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 13:04:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55515 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2KDSEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 13:04:35 -0500
MIME-Version: 1.0
In-Reply-To: <38620644.IyR5R8rjKP@percival>
References: <38620644.IyR5R8rjKP@percival>
Date: Sun, 4 Nov 2012 19:04:33 +0100
Message-ID: <CACRpkdZc3cEGfSKW-b=G31yuw_E-GOXid3jkxZ0tuKYGYRE5Nw@mail.gmail.com>
Subject: Re: How about a gpio_get(device *, char *) function?
From: Linus Walleij <linus.walleij@linaro.org>
To: Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:04 AM, Alex Courbot <acourbot@nvidia.com> wrote:

> Would anyone be opposed to having a gpio_get() function that works similarly
> to e.g. regulator_get() and clk_get()?

I understand the concept and why you want to do this.

However I think the global GPIO numberspace defeats the
purpose.

gpio_get() should get an abstract handle just like clk_get() or
regulator_get(), not a fixed numeral.

That is the only way to really transit away from the global GPIO
numberspace.

The proper refactoring I can see is to introduce an orthogonal
mechanism that will return something like a struct gpio_handle *
when you call gpio_get(), and then use a new set of accessor
functions to manipulate the GPIO, like gpio_handle_set()/ etc
for all known GPIO operations.

So defined in a new #ifdef CONFIG_GPIO_HANDLES or so
in a new <linux/gpio-handles.h> header and like the other
subsystems handling abstract resources just passing an
opaque pointer cookie around.

Then when migrating a driver to use this mechanism, only
include <linux/gpio-handles.h> and make that one driver only
use the abstract interface and get rid of the global numberspace.

Then we can have drivers that under a transition period will
support both the global numberspace and this new
handle-based access pattern.

Then migrate all clients over to <linux/gpio-handle.h> and
finally kill off the old global numberspace and only use
handles with that driver.

So a much more thorough refactoring is needed, just doing
a simple int lookup returning global GPIO numbers will likely
only make the current mess worse.

This more ambitious refactoring path is going to be a large
endavour and will likely go through a lot of reviews and
debate, but something like this is badly needed for the
GPIO subsystem.

Maybe Grant will have different opinions though so this is
not the final word on this issue...

Yours,
Linus Walleij
