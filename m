Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab2FDTcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:32:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55824 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2FDTcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:32:24 -0400
MIME-Version: 1.0
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Mon, 4 Jun 2012 14:32:02 -0500
Message-ID: <CAFkjPTkmgMY_TkUHvCmN0iQ9Hx4ADBVCLXGrQB8uMyoF0xMj0g@mail.gmail.com>
Subject: seq_file dangerous assumption?
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was merging up someone else's driver code from a much older kernel
to 3.5-rc1 and ran into some issues with corrupted memory.  The
character driver in question was using seq-file.c to handle reads to
the device.  Based on looking around at other drivers, no one else
does this -- so its probably (well, definitely based on what I found)
not the right way to do this.

seq_open seems to make a fairly general assumption:
(from linux-3.5-rc1 fs/seq_file.c)
...
int seq_open(struct file *file, const struct seq_operations *op)
{
        struct seq_file *p = file->private_data;

        if (!p) {
                p = kmalloc(sizeof(*p), GFP_KERNEL);
                if (!p)
                        return -ENOMEM;
                file->private_data = p;
        }
        memset(p, 0, sizeof(*p));
..

In other words, if something is in file->private_data, then we must
have already allocated and put our structure there.  In the case of
this driver, file->private_data was already populated (with a pointer
to the device structure) -- so the call to seq_open zero'd a portion
of the device structure and then corrupted it with a seq_file
structure.

So, an obvious solution is, don't use seq_file with a character device
-- but shouldn't there also be a fingerprint or something in the
seq_file structure as a sanity check so foolish developers don't trip
over it and corrupt their kernel memory?

      -eric
