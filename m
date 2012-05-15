Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966625Ab2EOTnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:43:01 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59472 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966612Ab2EOTm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
	<CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
	<CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
Date: Tue, 15 May 2012 15:42:57 -0400
Message-ID: <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 2:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, May 15, 2012 at 10:19 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>  - move the whole call to security_file_mmap() to outside the
>> mmap_sem, and test the *suggested* address (which is not the same as
>> the final address)
>
> Actually, I think I have a simpler approach.
>
> We already actually have two *different* security_file_mmap() calls:
> it's just that currently the difference is shown by the last argument
> to the function ("addr_only").

I'm the one who introduced that bit of horrific.  I originally did it
the way you describe and someone (it was a long time ago, and I think
it was Ted Tso, but I am probably very very wrong on that) ask me to
tack it on the end like this.  I'd be very happy with the split you
describe.

I'd rather not, however, move the address call site like you described
above, as I don't want to allow NULL + ~MAP_FIXED to be tested until
it has been resolved to a real address.  I don't want someone to find
a way to get the kernel to choose 4096 and avoid the check....

Mimi, would you like to do this (slightly) larger change?  Should I?
