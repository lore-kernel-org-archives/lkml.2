Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2BPLmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:42:50 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37063 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2BPLmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:42:49 -0500
MIME-Version: 1.0
In-Reply-To: <20120216001040.GA21919@kroah.com>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
 <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
 <CAOULuObKZX_VER0ERPNBb0gS8GBQBHpJBHQcpJi2kNBBysL=2A@mail.gmail.com> <20120216001040.GA21919@kroah.com>
From: Egmont Koblinger <egmont@gmail.com>
Date: Thu, 16 Feb 2012 12:42:07 +0100
Message-ID: <CAGWcZkJ+uvg=GwFJ+AizCAope2rWw2wujJYUZMvz8GBkKr34sA@mail.gmail.com>
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 01:10, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Odds are emacs also does this correctly, anyone care to verify that?

Actually, thanks for the hint, emacs is the first editor where I could
easily trigger the bug.  I made the input data a bit longer (200
lines), and it's being pasted incorrectly all the time.

Stracing xterm contains exactly this, with the "= 68" at the end, 200 times:
write(5, "a=(12345678912345678912345678912"..., 68) = 68

Contrary to xterm, gnome-terminal doesn't split the buffer at
newlines, it tries to write to /dev/ptmx in one single step. In this
example I extended the file to 1000 lines long (68000 bytes), here's
what strace gnome-terminal says:
open("/dev/ptmx", O_RDWR) = 17
[...]
write(17, "a=(12345678912345678912345678912"..., 68000) = 65280
[...]
write(17, "a=(12345678912345678912345678912"..., 2720) = 2720

So copy-paste starts misbehaving after 4kB, which suggests a buffer
size of around that size; on the other hand, writes to /dev/ptmx can
return up to almost 64kB, which suggests a much larger terminal buffer
which makes it strange that it starts misbehaving as early as at 4kB.

On a side note, apparently gnome-terminal handles short writes
correctly. (It's a mere accident that the size of the first write,
65280, is dividable by the line length of my example, 68.  A different
input shows that the second write indeed continues sending the buffer
from the correct offset, from the middle of a line. The return value
of the first write is the same, 65280 in that case too.)


thx,
egmont
