Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab1J2Rwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:52:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40733 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933544Ab1J2Rwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:52:49 -0400
MIME-Version: 1.0
Date: Sat, 29 Oct 2011 19:52:47 +0200
Message-ID: <CANq1E4SovxjRsuDN3PMqCnjBMMQeHWnvbwreXJWcDj7D7wUxWw@mail.gmail.com>
Subject: [BUG] kobject module-ref race-condition or unsafe module_put(THIS_MODULE)
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I currently do not understand how kobjects keep a reference to the
owning module. Lets assume I provide a "release" method via a
kobj_type for my kobject. I want to go sure my module is still alive
when this method is called. Otherwise, this "release" method would be
no longer available and we would jump into invalid memory. Therefore,
I need to take a reference to my own module. This seems trivial.
However, how do I release this reference again?
The most simple solution might be calling module_put(THIS_MODULE) in
my "release" method. However, if this call drops the module-refcount
to 0 and immediately removes the module, the module_put() returns to
my "release" function which now is no longer available.

It seems quite unlikely that the cleanup of a module is faster than
two function-returns, however, theoretically there is a race
condition.

The following example is based on fs/char_dev.c. Lets assume my module
provides a  kobject structure. On init I take a ref to myself with
try_module_get(THIS_MODULE).
I add my own kobj_type with the following release function:

static void mydev_put(struct mydev *p)
{
	if (p) {
		kobject_put(&p->kobj);
		module_put(THIS_MODULE);
	}
}

How can we go sure that module_put() doesn't free my own module before
it returns? Isn't a call to module_put(THIS_MODULE) always unsafe
(unless I own at least two references)?

grep "module_put(THIS_MODULE)" -r ./kernel_src/ | wc -l
returns 118 results.
I doubt that all these 118 places can got sure that they own at least
2 references when calling this, otherwise it would be quite unsafe to
call this function.


Maybe I have missed some important fact here, but this seems quite
unsafe to me. Adding a "owner" field to a kobj_type would fix that
issue for kobjects/devices.

Regards
David
